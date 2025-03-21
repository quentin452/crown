using Gee;

namespace Crown
{
    public class UnitView : PropertyGrid
    {
        // Widgets
        private ProjectStore _store;
        private ResourceChooserButton _prefab;
        private Gtk.MenuButton _component_add;
        private Gtk.Box _components;
        private Gtk.Popover _add_popover;

        private void on_add_component_clicked(Gtk.Button button)
        {
            Gtk.Application app = ((Gtk.Window)this.get_toplevel()).application;
            app.activate_action("unit-add-component", new GLib.Variant.string(button.label));

            _add_popover.hide();
        }

        public static Gtk.Menu component_menu(string object_type)
        {
            Gtk.Menu menu = new Gtk.Menu();
            Gtk.MenuItem mi;

            mi = new Gtk.MenuItem.with_label("Remove Component");
            mi.activate.connect(() => {
                    GLib.Application.get_default().activate_action("unit-remove-component", new GLib.Variant.string(object_type));
                });
            menu.add(mi);

            return menu;
        }

        public UnitView(Database db, ProjectStore store)
        {
            base(db);

            _store = store;

            // Widgets
            _prefab = new ResourceChooserButton(store, "unit");
            _prefab._selector.sensitive = false;

            // List of component types.
            const string components[] =
            {
                OBJECT_TYPE_TRANSFORM,
                OBJECT_TYPE_LIGHT,
                OBJECT_TYPE_CAMERA,
                OBJECT_TYPE_MESH_RENDERER,
                OBJECT_TYPE_SPRITE_RENDERER,
                OBJECT_TYPE_COLLIDER,
                OBJECT_TYPE_TILE_TERRAIN,
                OBJECT_TYPE_ACTOR,
                OBJECT_TYPE_SCRIPT,
                OBJECT_TYPE_ANIMATION_STATE_MACHINE
            };

            Gtk.Box add_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            for (int cc = 0; cc < components.length; ++cc) {
                Gtk.Button mb;
                mb = new Gtk.Button.with_label(components[cc]);
                mb.clicked.connect(on_add_component_clicked);
                add_box.pack_start(mb);
            }
            add_box.show_all();
            _add_popover = new Gtk.Popover(null);
            _add_popover.add(add_box);

            _component_add = new Gtk.MenuButton();
            _component_add.label = "Add Component";
            _component_add.set_popover(_add_popover);

            _components = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
            _components.homogeneous = true;
            _components.pack_start(_component_add);

            add_row("Prefab", _prefab);
            add_row("Components", _components);
        }

        public override void update()
        {
            if (_db.has_property(_id, "prefab")) {
                _prefab.value = _db.get_property_string(_id, "prefab");
            } else {
                _prefab.value = "<none>";
            }
        }
    }
} /* namespace Crown */