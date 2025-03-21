using Gee;

namespace Crown
{
    public class AnimationStateMachine : PropertyGrid
    {
        // Widgets
        private ResourceChooserButton _state_machine_resource;

        public AnimationStateMachine(Database db, ProjectStore store)
        {
            base(db);

            // Widgets
            _state_machine_resource = new ResourceChooserButton(store, "state_machine");
            _state_machine_resource.value_changed.connect(on_value_changed);

            add_row("State Machine", _state_machine_resource);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.state_machine_resource", _state_machine_resource.value);

            _db.add_restore_point((int)ActionType.SET_ANIMATION_STATE_MACHINE, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _state_machine_resource.value = unit.get_component_property_string(_component_id, "data.state_machine_resource");
        }
    }
} /* namespace Crown */