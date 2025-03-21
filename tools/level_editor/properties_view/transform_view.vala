using Gee;

namespace Crown
{
    public class TransformPropertyGrid : PropertyGrid
    {
        // Widgets
        private EntryPosition _position;
        private EntryRotation _rotation;
        private EntryScale _scale;

        public TransformPropertyGrid(Database db)
        {
            base(db);

            // Widgets
            _position = new EntryPosition();
            _position.value_changed.connect(on_value_changed);
            _rotation = new EntryRotation();
            _rotation.value_changed.connect(on_value_changed);
            _scale = new EntryScale();
            _scale.value_changed.connect(on_value_changed);

            add_row("Position", _position);
            add_row("Rotation", _rotation);
            add_row("Scale", _scale);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_vector3   (_component_id, "data.position", _position.value);
            unit.set_component_property_quaternion(_component_id, "data.rotation", _rotation.value);
            unit.set_component_property_vector3   (_component_id, "data.scale", _scale.value);

            _db.add_restore_point((int)ActionType.SET_TRANSFORM, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _position.value = unit.get_component_property_vector3   (_component_id, "data.position");
            _rotation.value = unit.get_component_property_quaternion(_component_id, "data.rotation");
            _scale.value    = unit.get_component_property_vector3   (_component_id, "data.scale");
        }
    }
} /* namespace Crown */