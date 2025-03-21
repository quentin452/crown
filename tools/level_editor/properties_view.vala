/*
 * Copyright (c) 2012-2025 Daniele Bartolini et al.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Gee;
namespace Crown
{
public class PropertiesView : Gtk.Bin
{
	public struct ComponentEntry
	{
		string type;
		int position;
	}

	// Data
	private Database _db;
	private HashMap<string, Expander> _expanders;
	private HashMap<string, PropertyGrid> _objects;
	private ArrayList<ComponentEntry?> _entries;
	private Gee.ArrayList<Guid?>? _selection;

	// Widgets
	private Gtk.Label _nothing_to_show;
	private Gtk.Label _unknown_object_type;
	private Gtk.Viewport _viewport;
	private Gtk.ScrolledWindow _scrolled_window;
	private PropertyGridSet _object_view;
	private Gtk.Stack _stack;

	[CCode (has_target = false)]
	public delegate Gtk.Menu ContextMenu(string object_type);

	public PropertiesView(Database db, ProjectStore store)
	{
		// Data
		_db = db;

		_expanders = new HashMap<string, Expander>();
		_objects = new HashMap<string, PropertyGrid>();
		_entries = new ArrayList<ComponentEntry?>();
		_selection = null;

		// Widgets
		_object_view = new PropertyGridSet();
		_object_view.border_width = 6;

		// Unit
		register_object_type("Unit",                    "name",                              0, new UnitView(_db, store));
		register_object_type("Transform",               OBJECT_TYPE_TRANSFORM,               0, new TransformPropertyGrid(_db),             	UnitView.component_menu);
		register_object_type("Light",                   OBJECT_TYPE_LIGHT,                   1, new LightPropertyGrid(_db),                 	UnitView.component_menu);
		register_object_type("Camera",                  OBJECT_TYPE_CAMERA,                  2, new CameraPropertyGrid(_db),                	UnitView.component_menu);
		register_object_type("Mesh Renderer",           OBJECT_TYPE_MESH_RENDERER,           3, new MeshRendererPropertyGrid(_db, store),   	UnitView.component_menu);
		register_object_type("Sprite Renderer",         OBJECT_TYPE_SPRITE_RENDERER,         3, new SpriteRendererPropertyGrid(_db, store), 	UnitView.component_menu);
		register_object_type("Collider",                OBJECT_TYPE_COLLIDER,                3, new ColliderPropertyGrid(_db, store),       	UnitView.component_menu);
		register_object_type("Tile Terrain",            OBJECT_TYPE_TILE_TERRAIN,            3, new TileTerrainPropertyGrid(_db),       		UnitView.component_menu);
		register_object_type("Actor",                   OBJECT_TYPE_ACTOR,                   3, new ActorPropertyGrid(_db, store._project), 	UnitView.component_menu);
		register_object_type("Script",                  OBJECT_TYPE_SCRIPT,                  3, new ScriptPropertyGrid(_db, store),         	UnitView.component_menu);
		register_object_type("Animation State Machine", OBJECT_TYPE_ANIMATION_STATE_MACHINE, 3, new AnimationStateMachine(_db, store),      	UnitView.component_menu);

		// Sound
		register_object_type("Transform", "sound_transform",  0, new SoundTransformView(_db));
		register_object_type("Sound",     "sound_properties", 1, new SoundView(_db, store));

		_nothing_to_show = new Gtk.Label("Select an object to start editing");
		_unknown_object_type = new Gtk.Label("Unknown object type");

		_viewport = new Gtk.Viewport(null, null);
		_viewport.add(_object_view);

		_scrolled_window = new Gtk.ScrolledWindow(null, null);
		_scrolled_window.add(_viewport);

		_stack = new Gtk.Stack();
		_stack.add(_nothing_to_show);
		_stack.add(_scrolled_window);
		_stack.add(_unknown_object_type);

		this.add(_stack);
		this.get_style_context().add_class("properties-view");

		store._project.project_reset.connect(on_project_reset);
	}

	private void register_object_type(string label, string object_type, int position, PropertyGrid cv, ContextMenu? action = null)
	{
		Expander expander = _object_view.add_property_grid(cv, label);
		if (action != null) {
			expander.button_release_event.connect((ev) => {
					if (ev.button == Gdk.BUTTON_SECONDARY) {
						Gtk.Menu menu = action(object_type);
						menu.show_all();
						menu.popup_at_pointer(ev);
						return Gdk.EVENT_STOP;
					}

					return Gdk.EVENT_PROPAGATE;
				});
		}

		_objects[object_type] = cv;
		_expanders[object_type] = expander;
		_entries.add({ object_type, position });
	}

	public void show_unit(Guid id)
	{
		_stack.set_visible_child(_scrolled_window);

		foreach (var entry in _entries) {
			Expander expander = _expanders[entry.type];

			Unit unit = Unit(_db, id);
			Guid component_id;
			Guid owner_id;
			if (unit.has_component_with_owner(out component_id, out owner_id, entry.type) || entry.type == "name") {
				PropertyGrid cv = _objects[entry.type];
				cv._id = id;
				cv._component_id = component_id;
				cv.update();

				if (id == owner_id)
					expander.get_style_context().remove_class("inherited");
				else
					expander.get_style_context().add_class("inherited");

				expander.show_all();
			} else {
				expander.hide();
			}
		}
	}

	public void show_sound_source(Guid id)
	{
		_stack.set_visible_child(_scrolled_window);

		foreach (var entry in _entries) {
			Expander expander = _expanders[entry.type];

			if (entry.type == "sound_transform" || entry.type == "sound_properties") {
				PropertyGrid cv = _objects[entry.type];
				cv._id = id;
				cv.update();
				expander.show_all();
			} else {
				expander.hide();
			}
		}
	}

	public void show_or_hide_properties()
	{
		if (_selection == null || _selection.size != 1) {
			_stack.set_visible_child(_nothing_to_show);
			return;
		}

		Guid id = _selection[_selection.size - 1];
		if (!_db.has_object(id))
			return;

		if (_db.object_type(id) == OBJECT_TYPE_UNIT)
			show_unit(id);
		else if (_db.object_type(id) == OBJECT_TYPE_SOUND_SOURCE)
			show_sound_source(id);
		else
			_stack.set_visible_child(_unknown_object_type);
	}

	public void on_selection_changed(Gee.ArrayList<Guid?> selection)
	{
		_selection = selection;
		show_or_hide_properties();
	}

	public override void map()
	{
		base.map();
		show_or_hide_properties();
	}

	public void on_project_reset()
	{
		foreach (var obj in _objects) {
			PropertyGrid cv = obj.value;
			cv._id = GUID_ZERO;
			cv._component_id = GUID_ZERO;
		}
	}
}

} /* namespace Crown */
