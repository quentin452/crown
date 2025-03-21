using Gee;

namespace Crown
{
    public class SoundTransformView : PropertyGrid
    {
        // Widgets
        private EntryVector3 _position;
        private EntryRotation _rotation;

        public SoundTransformView(Database db)
        {
            base(db);

            // Widgets
            _position = new EntryPosition();
            _rotation = new EntryRotation();

            _position.value_changed.connect(on_value_changed);
            _rotation.value_changed.connect(on_value_changed);

            add_row("Position", _position);
            add_row("Rotation", _rotation);
        }

        private void on_value_changed()
        {
            _db.set_property_vector3   (_id, "position", _position.value);
            _db.set_property_quaternion(_id, "rotation", _rotation.value);

            _db.add_restore_point((int)ActionType.SET_SOUND, new Guid?[] { _id });
        }

        public override void update()
        {
            Vector3 pos    = _db.get_property_vector3   (_id, "position");
            Quaternion rot = _db.get_property_quaternion(_id, "rotation");

            _position.value = pos;
            _rotation.value = rot;
        }
    }
} /* namespace Crown */