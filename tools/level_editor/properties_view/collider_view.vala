using Gee;

namespace Crown
{
    public class ColliderPropertyGrid : PropertyGrid
    {
        // Widgets.
        private Project _project;
        private ComboBoxMap _source;
        private ResourceChooserButton _scene;
        private ComboBoxMap _node;
        private ComboBoxMap _shape;
        // Inline colliders.
        private EntryPosition _position;
        private EntryRotation _rotation;
        private EntryVector3 _half_extents; // Box only.
        private EntryDouble _radius;        // Sphere and capsule only.
        private EntryDouble _height;        // Capsule only.

        private void decode(Hashtable mesh_resource)
        {
            const string keys[] = { "nodes" };
            ComboBoxMap combos[] = { _node };

            for (int i = 0; i < keys.length; ++i) {
                combos[i].clear();

                Mesh mesh = Mesh();
                mesh.decode(mesh_resource);
                foreach (var node in mesh._nodes)
                    combos[i].append(node, node);
            }
        }

        private void decode_from_resource(string type, string name)
        {
            try {
                string path = ResourceId.path(type, name);
                decode(SJSON.load_from_path(_project.absolute_path(path)));
            } catch (JsonSyntaxError e) {
                loge(e.message);
            }
        }

        public ColliderPropertyGrid(Database db, ProjectStore store)
        {
            base(db);

            _project = store._project;

            // Widgets.
            _source = new ComboBoxMap();
            _source.append("inline", "inline");
            _source.append("mesh", "mesh");
            _source.value_changed.connect(on_source_value_changed);
            _scene = new ResourceChooserButton(store, "mesh");
            _scene.value_changed.connect(on_scene_value_changed);
            _node = new ComboBoxMap();
            _node.value_changed.connect(on_value_changed);
            _shape = new ComboBoxMap();
            _shape.append("sphere", "sphere");
            _shape.append("capsule", "capsule");
            _shape.append("box", "box");
            _shape.append("convex_hull", "convex_hull");
            _shape.append("mesh", "mesh");
            _shape.value_changed.connect(on_shape_value_changed);

            _position = new EntryPosition();
            _position.value_changed.connect(on_value_changed);
            _rotation = new EntryRotation();
            _rotation.value_changed.connect(on_value_changed);
            _half_extents = new EntryVector3(Vector3(0.5, 0.5, 0.5), VECTOR3_ZERO, VECTOR3_MAX);
            _half_extents.value_changed.connect(on_value_changed);
            _radius = new EntryDouble(0.5, 0.0, double.MAX);
            _radius.value_changed.connect(on_value_changed);
            _height = new EntryDouble(1.0, 0.0, double.MAX);
            _height.value_changed.connect(on_value_changed);

            add_row("Source", _source);
            add_row("Scene", _scene);
            add_row("Node", _node);

            add_row("Shape", _shape);
            add_row("Position", _position);
            add_row("Rotation", _rotation);
            add_row("Half Extents", _half_extents);
            add_row("Radius", _radius);
            add_row("Height", _height);
        }

        private void on_source_value_changed()
        {
            if (_source.value == "inline") {
                _shape.value = _shape.any_valid_id();
            } else if (_source.value == "mesh") {
                _scene.value = "core/units/primitives/cube";
                decode_from_resource("mesh", _scene.value);
                _node.value = "Cube";
                _shape.value = "mesh";
            } else {
                assert(false);
            }

            enable_disable_properties();
            on_value_changed();
        }

        private void on_scene_value_changed()
        {
            decode_from_resource("mesh", _scene.value);
            _node.value = _node.any_valid_id();

            on_value_changed();
        }

        private void on_shape_value_changed()
        {
            enable_disable_properties();
            on_value_changed();
        }

        private void enable_disable_properties()
        {
            if (_source.value == "inline") {
                _scene.sensitive = false;
                _node.sensitive = false;
                _position.sensitive = true;
                _rotation.sensitive = true;

                if (_shape.value == "sphere") {
                    _half_extents.sensitive = false;
                    _radius.sensitive = true;
                    _height.sensitive = false;
                } else if (_shape.value == "capsule") {
                    _half_extents.sensitive = false;
                    _radius.sensitive = true;
                    _height.sensitive = true;
                } else if (_shape.value == "box") {
                    _half_extents.sensitive = true;
                    _radius.sensitive = false;
                    _height.sensitive = false;
                } else {
                    _position.sensitive = false;
                    _rotation.sensitive = false;
                    _half_extents.sensitive = false;
                    _radius.sensitive = false;
                    _height.sensitive = false;
                }
            } else if (_source.value == "mesh") {
                _scene.sensitive = true;
                _node.sensitive = true;
                _position.sensitive = false;
                _rotation.sensitive = false;
                _half_extents.sensitive = false;
                _radius.sensitive = false;
                _height.sensitive = false;
            } else {
                assert(false);
            }
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.source", _source.value);
            unit.set_component_property_string(_component_id, "data.scene", _scene.value);
            unit.set_component_property_string(_component_id, "data.name", _node.value);
            unit.set_component_property_string(_component_id, "data.shape", _shape.value);
            unit.set_component_property_vector3(_component_id, "data.collider_data.position", _position.value);
            unit.set_component_property_quaternion(_component_id, "data.collider_data.rotation", _rotation.value);
            unit.set_component_property_vector3(_component_id, "data.collider_data.half_extents", _half_extents.value);
            unit.set_component_property_double(_component_id, "data.collider_data.radius", _radius.value);
            unit.set_component_property_double(_component_id, "data.collider_data.height", _height.value);

            _db.add_restore_point((int)ActionType.SET_COLLIDER, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);

            if (unit.get_component_property(_component_id, "data.source") == null)
                _source.value = "mesh";
            else
                _source.value = unit.get_component_property_string(_component_id, "data.source");

            if (unit.get_component_property(_component_id, "data.scene") == null) {
                _scene.value = "core/units/primitives/cube";
                decode_from_resource("mesh", _scene.value);
                _node.value  = _node.any_valid_id();
            } else {
                _scene.value = unit.get_component_property_string(_component_id, "data.scene");
                decode_from_resource("mesh", _scene.value);
                _node.value = unit.get_component_property_string(_component_id, "data.name");
            }

            _shape.value = unit.get_component_property_string(_component_id, "data.shape");

            if (unit.get_component_property(_component_id, "data.collider_data.position") != null)
                _position.value = unit.get_component_property_vector3(_component_id, "data.collider_data.position");
            if (unit.get_component_property(_component_id, "data.collider_data.rotation") != null)
                _rotation.value = unit.get_component_property_quaternion(_component_id, "data.collider_data.rotation");
            if (unit.get_component_property(_component_id, "data.collider_data.half_extents") != null)
                _half_extents.value = unit.get_component_property_vector3(_component_id, "data.collider_data.half_extents");
            if (unit.get_component_property(_component_id, "data.collider_data.radius") != null)
                _radius.value = unit.get_component_property_double(_component_id, "data.collider_data.radius");
            if (unit.get_component_property(_component_id, "data.collider_data.height") != null)
                _height.value = unit.get_component_property_double(_component_id, "data.collider_data.height");

            enable_disable_properties();
        }
    } 
} /* namespace Crown */