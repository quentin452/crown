using Gee;

namespace Crown
{
    public class ActorPropertyGrid : PropertyGrid
    {
        // Widgets
        private Project _project;
        private ComboBoxMap _class;
        private ComboBoxMap _collision_filter;
        private EntryDouble _mass;
        private ComboBoxMap _material;
        private CheckBox3 _lock_translation;
        private CheckBox3 _lock_rotation;

        private void decode_global_physics_config(Hashtable global)
        {
            const string keys[] = { "actors", "collision_filters", "materials" };
            ComboBoxMap combos[] = { _class, _collision_filter, _material };

            for (int i = 0; i < keys.length; ++i) {
                combos[i].clear();
                if (global.has_key(keys[i])) {
                    Hashtable obj = (Hashtable)global[keys[i]];
                    foreach (var e in obj)
                        combos[i].append(e.key, e.key);
                }
            }

            if (_id != GUID_ZERO)
                update();
        }

        private void on_project_file_added_or_changed(string type, string name, uint64 size, uint64 mtime)
        {
            if (type != "physics_config" || name != "global")
                return;

            string path = ResourceId.path("physics_config", "global");
            try {
                Hashtable global = SJSON.load_from_path(_project.absolute_path(path));
                decode_global_physics_config(global);
            } catch (JsonSyntaxError e) {
                loge(e.message);
            }
        }

        private void on_project_file_removed(string type, string name)
        {
            if (type != "physics_config" || name != "global")
                return;

            decode_global_physics_config(new Hashtable());
        }

        public ActorPropertyGrid(Database db, Project prj)
        {
            base(db);

            _project = prj;

            // Widgets
            _class = new ComboBoxMap();
            _class.value_changed.connect(on_value_changed);
            _collision_filter = new ComboBoxMap();
            _collision_filter.value_changed.connect(on_value_changed);
            _material = new ComboBoxMap();
            _material.value_changed.connect(on_value_changed);
            _mass = new EntryDouble(1.0, 0.0, double.MAX);
            _mass.value_changed.connect(on_value_changed);
            _lock_translation = new CheckBox3();
            _lock_translation.value_changed.connect(on_value_changed);
            _lock_rotation = new CheckBox3();
            _lock_rotation.value_changed.connect(on_value_changed);

            add_row("Class", _class);
            add_row("Collision Filter", _collision_filter);
            add_row("Material", _material);
            add_row("Mass", _mass);
            add_row("Lock Translation", _lock_translation);
            add_row("Lock Rotation", _lock_rotation);

            prj.file_added.connect(on_project_file_added_or_changed);
            prj.file_changed.connect(on_project_file_added_or_changed);
            prj.file_removed.connect(on_project_file_removed);
        }

        private bool get_component_property_bool_optional(Unit unit, Guid component_id, string key)
        {
            return unit.get_component_property(component_id, key) != null
                ? (bool)unit.get_component_property_bool(component_id, key)
                : false
                ;
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            if (!_class.is_inconsistent() && _class.value != null)
                unit.set_component_property_string(_component_id, "data.class", _class.value);
            if (!_collision_filter.is_inconsistent() && _collision_filter.value != null)
                unit.set_component_property_string(_component_id, "data.collision_filter", _collision_filter.value);
            if (!_material.is_inconsistent() && _material.value != null)
                unit.set_component_property_string(_component_id, "data.material", _material.value);
            unit.set_component_property_double(_component_id, "data.mass", _mass.value);
            unit.set_component_property_bool  (_component_id, "data.lock_translation_x", _lock_translation._x.value);
            unit.set_component_property_bool  (_component_id, "data.lock_translation_y", _lock_translation._y.value);
            unit.set_component_property_bool  (_component_id, "data.lock_translation_z", _lock_translation._z.value);
            unit.set_component_property_bool  (_component_id, "data.lock_rotation_x", _lock_rotation._x.value);
            unit.set_component_property_bool  (_component_id, "data.lock_rotation_y", _lock_rotation._y.value);
            unit.set_component_property_bool  (_component_id, "data.lock_rotation_z", _lock_rotation._z.value);

            _db.add_restore_point((int)ActionType.SET_ACTOR, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _class.value               = unit.get_component_property_string(_component_id, "data.class");
            _collision_filter.value    = unit.get_component_property_string(_component_id, "data.collision_filter");
            _material.value            = unit.get_component_property_string(_component_id, "data.material");
            _mass.value                = unit.get_component_property_double(_component_id, "data.mass");
            _lock_translation._x.value = get_component_property_bool_optional(unit, _component_id, "data.lock_translation_x");
            _lock_translation._y.value = get_component_property_bool_optional(unit, _component_id, "data.lock_translation_y");
            _lock_translation._z.value = get_component_property_bool_optional(unit, _component_id, "data.lock_translation_z");
            _lock_rotation._x.value    = get_component_property_bool_optional(unit, _component_id, "data.lock_rotation_x");
            _lock_rotation._y.value    = get_component_property_bool_optional(unit, _component_id, "data.lock_rotation_y");
            _lock_rotation._z.value    = get_component_property_bool_optional(unit, _component_id, "data.lock_rotation_z");
        }
    }
} /* namespace Crown */