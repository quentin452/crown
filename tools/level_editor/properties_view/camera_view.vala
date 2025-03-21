using Gee;

namespace Crown
{
    public class CameraPropertyGrid : PropertyGrid
    {
        // Widgets
        private ComboBoxMap _projection;
        private EntryDouble _fov;
        private EntryDouble _near_range;
        private EntryDouble _far_range;

        public CameraPropertyGrid(Database db)
        {
            base(db);

            // Widgets
            _projection = new ComboBoxMap();
            _projection.append("orthographic", "Orthographic");
            _projection.append("perspective", "Perspective");
            _projection.value_changed.connect(on_value_changed);
            _fov = new EntryDouble(0.0, 1.0,   90.0);
            _fov.value_changed.connect(on_value_changed);
            _near_range = new EntryDouble(0.001, double.MIN, double.MAX);
            _near_range.value_changed.connect(on_value_changed);
            _far_range  = new EntryDouble(1000.000, double.MIN, double.MAX);
            _far_range.value_changed.connect(on_value_changed);

            add_row("Projection", _projection);
            add_row("FOV", _fov);
            add_row("Near Range", _near_range);
            add_row("Far Range", _far_range);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.projection", _projection.value);
            unit.set_component_property_double(_component_id, "data.fov", _fov.value * (Math.PI/180.0));
            unit.set_component_property_double(_component_id, "data.near_range", _near_range.value);
            unit.set_component_property_double(_component_id, "data.far_range", _far_range.value);

            _db.add_restore_point((int)ActionType.SET_CAMERA, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _projection.value = unit.get_component_property_string(_component_id, "data.projection");
            _fov.value        = unit.get_component_property_double(_component_id, "data.fov") * (180.0/Math.PI);
            _near_range.value = unit.get_component_property_double(_component_id, "data.near_range");
            _far_range.value  = unit.get_component_property_double(_component_id, "data.far_range");
        }
    }
} /* namespace Crown */