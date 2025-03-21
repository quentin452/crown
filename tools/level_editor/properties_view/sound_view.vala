using Gee;

namespace Crown
{
    public class SoundView : PropertyGrid
    {
        // Widgets
        private ResourceChooserButton _name;
        private EntryDouble _range;
        private EntryDouble _volume;
        private CheckBox _loop;

        public SoundView(Database db, ProjectStore store)
        {
            base(db);

            // Widgets
            _name   = new ResourceChooserButton(store, "sound");
            _name.value_changed.connect(on_value_changed);
            _range  = new EntryDouble(1.0, 0.0, double.MAX);
            _range.value_changed.connect(on_value_changed);
            _volume = new EntryDouble(1.0, 0.0, 1.0);
            _volume.value_changed.connect(on_value_changed);
            _loop   = new CheckBox();
            _loop.value_changed.connect(on_value_changed);

            add_row("Name", _name);
            add_row("Range", _range);
            add_row("Volume", _volume);
            add_row("Loop", _loop);
        }

        private void on_value_changed()
        {
            _db.set_property_string(_id, "name", _name.value);
            _db.set_property_double(_id, "range", _range.value);
            _db.set_property_double(_id, "volume", _volume.value);
            _db.set_property_bool  (_id, "loop", _loop.value);

            _db.add_restore_point((int)ActionType.SET_SOUND, new Guid?[] { _id });
        }

        public override void update()
        {
            _name.value   = _db.get_property_string(_id, "name");
            _range.value  = _db.get_property_double(_id, "range");
            _volume.value = _db.get_property_double(_id, "volume");
            _loop.value   = _db.get_property_bool  (_id, "loop");
        }
    } 
} /* namespace Crown */