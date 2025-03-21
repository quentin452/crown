using Gee;

namespace Crown
{
    public class SpriteRendererPropertyGrid : PropertyGrid
    {
        // Widgets
        private ResourceChooserButton _sprite_resource;
        private ResourceChooserButton _material;
        private EntryDouble _layer;
        private EntryDouble _depth;
        private CheckBox _visible;

        public SpriteRendererPropertyGrid(Database db, ProjectStore store)
        {
            base(db);

            // Widgets
            _sprite_resource = new ResourceChooserButton(store, "sprite");
            _sprite_resource.value_changed.connect(on_value_changed);
            _material = new ResourceChooserButton(store, "material");
            _material.value_changed.connect(on_value_changed);
            _layer = new EntryDouble(0.0, 0.0, 7.0);
            _layer.value_changed.connect(on_value_changed);
            _depth = new EntryDouble(0.0, 0.0, (double)uint32.MAX);
            _depth.value_changed.connect(on_value_changed);
            _visible = new CheckBox();
            _visible.value_changed.connect(on_value_changed);

            add_row("Sprite", _sprite_resource);
            add_row("Material", _material);
            add_row("Layer", _layer);
            add_row("Depth", _depth);
            add_row("Visible", _visible);
        }

        private void on_value_changed()
        {
            Unit unit = Unit(_db, _id);
            unit.set_component_property_string(_component_id, "data.sprite_resource", _sprite_resource.value);
            unit.set_component_property_string(_component_id, "data.material", _material.value);
            unit.set_component_property_double(_component_id, "data.layer", _layer.value);
            unit.set_component_property_double(_component_id, "data.depth", _depth.value);
            unit.set_component_property_bool  (_component_id, "data.visible", _visible.value);

            _db.add_restore_point((int)ActionType.SET_SPRITE, new Guid?[] { _id, _component_id });
        }

        public override void update()
        {
            Unit unit = Unit(_db, _id);
            _sprite_resource.value = unit.get_component_property_string(_component_id, "data.sprite_resource");
            _material.value        = unit.get_component_property_string(_component_id, "data.material");
            _layer.value           = unit.get_component_property_double(_component_id, "data.layer");
            _depth.value           = unit.get_component_property_double(_component_id, "data.depth");
            _visible.value         = unit.get_component_property_bool  (_component_id, "data.visible");
        }
    }
} /* namespace Crown */