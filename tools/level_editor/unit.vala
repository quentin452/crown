/*
 * Copyright (c) 2012-2024 Daniele Bartolini et al.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Gee;

namespace Crown
{
public class Unit
{
	public Database _db;
	public Guid _id;

	public Unit(Database db, Guid id)
	{
		_db = db;
		_id = id;
	}

	/// Loads the unit @a name.
	public static void load_unit(Database db, string name)
	{
		string resource_path = name + ".unit";

		Guid prefab_id = GUID_ZERO;
		if (db.add_from_resource_path(out prefab_id, resource_path) != 0)
			return; // Caller can query the database to check for error.
		assert(prefab_id != GUID_ZERO);
	}

	public void create(string? prefab, Vector3 pos, Quaternion rot, Vector3 scl)
	{
		_db.create(_id, OBJECT_TYPE_UNIT);

		if (prefab != null)
			_db.set_property_string(_id, "prefab", prefab);

		set_local_position(pos);
		set_local_rotation(rot);
		set_local_scale(scl);
	}

	public Value? get_component_property(Guid component_id, string key)
	{
		Value? val;

		// Search in components
		val = _db.get_property(_id, "components");
		if (val != null) {
			if (((HashSet<Guid?>)val).contains(component_id))
				return _db.get_property(component_id, key);
		}

		// Search in modified_components
		val = _db.get_property(_id, "modified_components.#" + component_id.to_string() + "." + key);
		if (val != null)
			return val;

		// Search in prefab
		val = _db.get_property(_id, "prefab");
		if (val != null) {
			// Convert prefab path to object ID.
			string prefab = (string)val;
			Unit.load_unit(_db, prefab);
			Guid prefab_id = _db.get_property_guid(GUID_ZERO, prefab + ".unit");

			Unit unit = new Unit(_db, prefab_id);
			return unit.get_component_property(component_id, key);
		}

		return null;
	}

	public bool get_component_property_bool(Guid component_id, string key)
	{
		return (bool)get_component_property(component_id, key);
	}

	public double get_component_property_double(Guid component_id, string key)
	{
		return (double)get_component_property(component_id, key);
	}

	public string get_component_property_string(Guid component_id, string key)
	{
		return (string)get_component_property(component_id, key);
	}

	public Guid get_component_property_guid(Guid component_id, string key)
	{
		return (Guid)get_component_property(component_id, key);
	}

	public Vector3 get_component_property_vector3(Guid component_id, string key)
	{
		return (Vector3)get_component_property(component_id, key);
	}

	public Quaternion get_component_property_quaternion(Guid component_id, string key)
	{
		return (Quaternion)get_component_property(component_id, key);
	}

	public void set_component_property_bool(Guid component_id, string key, bool val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_bool(component_id, key, val);
			return;
		}

		_db.set_property_bool(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	public void set_component_property_double(Guid component_id, string key, double val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_double(component_id, key, val);
			return;
		}

		_db.set_property_double(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	public void set_component_property_string(Guid component_id, string key, string val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_string(component_id, key, val);
			return;
		}

		_db.set_property_string(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	public void set_component_property_guid(Guid component_id, string key, Guid val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_guid(component_id, key, val);
			return;
		}

		_db.set_property_guid(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	public void set_component_property_vector3(Guid component_id, string key, Vector3 val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_vector3(component_id, key, val);
			return;
		}

		_db.set_property_vector3(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	public void set_component_property_quaternion(Guid component_id, string key, Quaternion val)
	{
		// Search in components
		Value? components = _db.get_property(_id, "components");
		if (components != null && ((HashSet<Guid?>)components).contains(component_id)) {
			_db.set_property_quaternion(component_id, key, val);
			return;
		}

		_db.set_property_quaternion(_id, "modified_components.#" + component_id.to_string() + "." + key, val);
	}

	/// Returns whether the @a unit_id has a component of type @a component_type.
	public static bool has_component_static(out Guid component_id, out Guid owner_id, string component_type, Database db, Guid unit_id)
	{
		Value? val;
		component_id = GUID_ZERO;
		owner_id = GUID_ZERO;
		bool prefab_has_component = false;

		// If the component type is found inside the "components" array, the unit has the component
		// and it owns it.
		val = db.get_property(unit_id, "components");
		if (val != null) {
			foreach (Guid id in (HashSet<Guid?>)val) {
				if ((string)db.object_type(id) == component_type) {
					component_id = id;
					owner_id = unit_id;
					return true;
				}
			}
		}

		// Otherwise, search if any prefab has the component.
		val = db.get_property(unit_id, "prefab");
		if (val != null) {
			// Convert prefab path to object ID.
			string prefab = (string)val;
			Unit.load_unit(db, prefab);
			Guid prefab_id = db.get_property_guid(GUID_ZERO, prefab + ".unit");

			prefab_has_component = has_component_static(out component_id
				, out owner_id
				, component_type
				, db
				, prefab_id
				);
		}

		if (prefab_has_component)
			return db.get_property(unit_id, "deleted_components.#" + component_id.to_string()) == null;

		component_id = GUID_ZERO;
		owner_id = GUID_ZERO;
		return false;
	}

	/// Returns whether the unit has the component_type.
	public bool has_component(out Guid component_id, string component_type)
	{
		Guid owner_id;
		return Unit.has_component_static(out component_id, out owner_id, component_type, _db, _id);
	}

	public Vector3 local_position()
	{
		Vector3 position;

		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			position = get_component_property_vector3(component_id, "data.position");
		else
			position = _db.get_property_vector3(_id, "position");

		return position;
	}

	public Quaternion local_rotation()
	{
		Quaternion rotation;

		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			rotation = get_component_property_quaternion(component_id, "data.rotation");
		else
			rotation = _db.get_property_quaternion(_id, "rotation");

		return rotation;
	}

	public Vector3 local_scale()
	{
		Vector3 scale;

		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			scale = get_component_property_vector3(component_id, "data.scale");
		else
			scale = _db.get_property_vector3(_id, "scale");

		return scale;
	}

	public void set_local_position(Vector3 position)
	{
		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			set_component_property_vector3(component_id, "data.position", position);
		else
			_db.set_property_vector3(_id, "position", position);
	}

	public void set_local_rotation(Quaternion rotation)
	{
		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			set_component_property_quaternion(component_id, "data.rotation", rotation);
		else
			_db.set_property_quaternion(_id, "rotation", rotation);
	}

	public void set_local_scale(Vector3 scale)
	{
		Guid component_id;
		if (has_component(out component_id, OBJECT_TYPE_TRANSFORM))
			set_component_property_vector3(component_id, "data.scale", scale);
		else
			_db.set_property_vector3(_id, "scale", scale);
	}

	public void remove_component(Guid component_id)
	{
		_db.remove_from_set(_id, "components", component_id);
	}

	/// Returns whether the unit has a prefab.
	public bool has_prefab()
	{
		return _db.has_property(_id, "prefab");
	}

	/// Returns whether the unit is a light unit.
	public bool is_light()
	{
		return has_prefab()
			&& _db.get_property_string(_id, "prefab") == "core/units/light";
	}

	/// Returns whether the unit is a camera unit.
	public bool is_camera()
	{
		return has_prefab()
			&& _db.get_property_string(_id, "prefab") == "core/units/camera";
	}

	public void send_component(RuntimeInstance runtime, Guid unit_id, Guid component_id)
	{
		string component_type = _db.object_type(component_id);
		Unit unit = new Unit(_db, unit_id);

		if (component_type == OBJECT_TYPE_TRANSFORM) {
			runtime.send_script(LevelEditorApi.move_object(unit_id
				, unit.get_component_property_vector3   (component_id, "data.position")
				, unit.get_component_property_quaternion(component_id, "data.rotation")
				, unit.get_component_property_vector3   (component_id, "data.scale")
				));
		} else if (component_type == OBJECT_TYPE_CAMERA) {
			runtime.send_script(LevelEditorApi.set_camera(unit_id
				, unit.get_component_property_string(component_id, "data.projection")
				, unit.get_component_property_double(component_id, "data.fov")
				, unit.get_component_property_double(component_id, "data.far_range")
				, unit.get_component_property_double(component_id, "data.near_range")
				));
		} else if (component_type == OBJECT_TYPE_MESH_RENDERER) {
			runtime.send_script(LevelEditorApi.set_mesh(unit_id
				, unit.get_component_property_string(component_id, "data.mesh_resource")
				, unit.get_component_property_string(component_id, "data.geometry_name")
				, unit.get_component_property_string(component_id, "data.material")
				, unit.get_component_property_bool  (component_id, "data.visible")
				));
		} else if (component_type == OBJECT_TYPE_SPRITE_RENDERER) {
			runtime.send_script(LevelEditorApi.set_sprite(unit_id
				, unit.get_component_property_string(component_id, "data.sprite_resource")
				, unit.get_component_property_string(component_id, "data.material")
				, unit.get_component_property_double(component_id, "data.layer")
				, unit.get_component_property_double(component_id, "data.depth")
				, unit.get_component_property_bool  (component_id, "data.visible")
				));
		} else if (component_type == OBJECT_TYPE_LIGHT) {
			runtime.send_script(LevelEditorApi.set_light(unit_id
				, unit.get_component_property_string (component_id, "data.type")
				, unit.get_component_property_double (component_id, "data.range")
				, unit.get_component_property_double (component_id, "data.intensity")
				, unit.get_component_property_double (component_id, "data.spot_angle")
				, unit.get_component_property_vector3(component_id, "data.color")
				));
		} else if (component_type == OBJECT_TYPE_SCRIPT) {
			/* No sync. */
		} else if (component_type == OBJECT_TYPE_COLLIDER) {
			/* No sync. */
		} else if (component_type == OBJECT_TYPE_ACTOR) {
			/* No sync. */
		} else if (component_type == OBJECT_TYPE_ANIMATION_STATE_MACHINE) {
			/* No sync. */
		} else {
			logw("Unregistered component type `%s`".printf(component_type));
		}
	}

	public void send(RuntimeInstance runtime)
	{
		runtime.send_script(LevelEditorApi.move_object(_id
			, local_position()
			, local_rotation()
			, local_scale()
			));
	}
}

} /* namespace Crown */
