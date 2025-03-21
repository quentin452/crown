using Gee;

namespace Crown
{
    public class LightPropertyGrid : PropertyGrid
    {
        // Widgets
        private ComboBoxMap _type;
        private EntryDouble _range;
        private EntryDouble _intensity;
        private EntryDouble _spot_angle;
        private ColorButtonVector3 _color;

        public LightPropertyGrid(Database db)
        {
            base(db);

            // Widgets
            _type = new ComboBoxMap();
            _type.value_changed.connect(on_value_changed);
            _type.append("directional", "Directional");
            _type.append("omni", "Omni");
            _type.append("spot", "Spot");
            _range = new EntryDouble(0.0, 0.0, double.MAX);
            _range.value_changed.connect(on_value_changed);
            _intensity = new EntryDouble(0.0, 0.0,  double.MAX);
            _intensity.value_changed.connect(on_value_changed);
            _spot_angle = new EntryDouble(0.0, 0.0,  90.0);
            _spot_angle.value_changed.connect(on_value_changed);
            _color = new ColorButtonVector3();
            _color.value_changed.connect(on_value_changed);

            add_row("Type", _type);
            add_row("Range", _range);
            add_row("Intensity", _intensity);
            add_row("Spot Angle", _spot_angle);
            add_row("Color", _color);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string (_component_id, "data.type",       _type.value);
            unit.set_component_property_double (_component_id, "data.range",      _range.value);
            unit.set_component_property_double (_component_id, "data.intensity",  _intensity.value);
            unit.set_component_property_double (_component_id, "data.spot_angle", _spot_angle.value * (Math.PI/180.0));
            unit.set_component_property_vector3(_component_id, "data.color",      _color.value);

            _db.add_restore_point((int)ActionType.SET_LIGHT, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _type.value       = unit.get_component_property_string (_component_id, "data.type");
            _range.value      = unit.get_component_property_double (_component_id, "data.range");
            _intensity.value  = unit.get_component_property_double (_component_id, "data.intensity");
            _spot_angle.value = unit.get_component_property_double (_component_id, "data.spot_angle") * (180.0/Math.PI);
            _color.value      = unit.get_component_property_vector3(_component_id, "data.color");
        }
    }
} /* namespace Crown */