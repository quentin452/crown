using Gee;

namespace Crown
{
    public class MeshRendererPropertyGrid : PropertyGrid
    {
        // Widgets
        private Project _project;
        private ResourceChooserButton _scene;
        private ComboBoxMap _node;
        private ResourceChooserButton _material;
        private CheckBox _visible;

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

        public MeshRendererPropertyGrid(Database db, ProjectStore store)
        {
            base(db);

            _project = store._project;

            // Widgets
            _scene = new ResourceChooserButton(store, "mesh");
            _scene.value_changed.connect(on_scene_value_changed);
            _node = new ComboBoxMap();
            _material = new ResourceChooserButton(store, "material");
            _material.value_changed.connect(on_value_changed);
            _visible = new CheckBox();
            _visible.value_changed.connect(on_value_changed);

            add_row("Scene", _scene);
            add_row("Node", _node);
            add_row("Material", _material);
            add_row("Visible", _visible);
        }

        private void on_scene_value_changed()
        {
            decode_from_resource("mesh", _scene.value);
            _node.value = _node.any_valid_id();
            on_value_changed();
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.mesh_resource", _scene.value);
            unit.set_component_property_string(_component_id, "data.geometry_name", _node.value);
            unit.set_component_property_string(_component_id, "data.material", _material.value);
            unit.set_component_property_bool  (_component_id, "data.visible", _visible.value);

            _db.add_restore_point((int)ActionType.SET_MESH, new Guid?[] { _id, _component_id });
        }

        private void update_mesh_and_geometry(Unit unit)
        {
            _scene.value = unit.get_component_property_string(_component_id, "data.mesh_resource");
            decode_from_resource("mesh", _scene.value);
            _node.value = unit.get_component_property_string(_component_id, "data.geometry_name");
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            update_mesh_and_geometry(unit);
            _material.value = unit.get_component_property_string(_component_id, "data.material");
            _visible.value  = unit.get_component_property_bool  (_component_id, "data.visible");
        }
    }
} /* namespace Crown */