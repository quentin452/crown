using Gee;

namespace Crown
{
    public class ScriptPropertyGrid : PropertyGrid
    {
        // Widgets
        private ResourceChooserButton _script_resource;

        public ScriptPropertyGrid(Database db, ProjectStore store)
        {
            base(db);

            // Widgets
            _script_resource = new ResourceChooserButton(store, "lua");
            _script_resource.value_changed.connect(on_value_changed);

            add_row("Script", _script_resource);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.script_resource", _script_resource.value);

            _db.add_restore_point((int)ActionType.SET_SCRIPT, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _script_resource.value = unit.get_component_property_string(_component_id, "data.script_resource");
        }
    }
} /* namespace Crown */