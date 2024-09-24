/*
 * Copyright (c) 2012-2024 Daniele Bartolini et al.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Gtk;
using Gdk;

namespace Crown
{
public class EntryDouble : Gtk.Entry
{
	public double _min;
	public double _max;
	public double _value;
	public bool _stop_emit;
	public string _preview_fmt;
	public string _edit_fmt;

	public double value
	{
		get
		{
			return _value;
		}
		set
		{
			_stop_emit = true;
			set_value_safe(value);
			_stop_emit = false;
		}
	}

	// Signals
	public signal void value_changed();

	public EntryDouble(double val, double min, double max, string preview_fmt = "%.6g", string edit_fmt = "%.17g")
	{
		this.input_purpose = Gtk.InputPurpose.NUMBER;
		this.set_width_chars(1);

		this.scroll_event.connect(on_scroll);
		this.button_release_event.connect(on_button_release);
		this.activate.connect(on_activate);
		this.focus_in_event.connect(on_focus_in);
		this.focus_out_event.connect(on_focus_out);

		this._min = min;
		this._max = max;
		this._preview_fmt = preview_fmt;
		this._edit_fmt = edit_fmt;

		_stop_emit = true;
		set_value_safe(val);
		_stop_emit = false;
	}

	private bool on_scroll(Gdk.EventScroll ev)
	{
		GLib.Signal.stop_emission_by_name(this, "scroll-event");
		return Gdk.EVENT_PROPAGATE;
	}

	private bool on_button_release(Gdk.EventButton ev)
	{
		if (ev.button == Gdk.BUTTON_PRIMARY && this.has_focus) {
			this.text = _edit_fmt.printf(_value);
			this.set_position(-1);
			this.select_region(0, -1);
			return Gdk.EVENT_STOP;
		}

		return Gdk.EVENT_PROPAGATE;
	}

	private void on_activate()
	{
		this.select_region(0, 0);
		this.set_position(-1);
		set_value_safe(string_to_double(this.text, _value));
	}

	private bool on_focus_in(Gdk.EventFocus ev)
	{
		var app = (LevelEditorApplication)GLib.Application.get_default();
		app.entry_any_focus_in(this);

		this.text = _edit_fmt.printf(_value);
		this.set_position(-1);
		this.select_region(0, -1);
		return Gdk.EVENT_PROPAGATE;
	}

	private bool on_focus_out(Gdk.EventFocus ef)
	{
		var app = (LevelEditorApplication)GLib.Application.get_default();
		app.entry_any_focus_out(this);

		set_value_safe(string_to_double(this.text, _value));

		this.select_region(0, 0);

		return Gdk.EVENT_PROPAGATE;
	}

	private void set_value_safe(double val)
	{
		double clamped = val.clamp(_min, _max);

		// Convert to text for displaying
		this.text = _preview_fmt.printf(clamped);

		// Notify value changed
		if (_value != clamped) {
			_value = clamped;
			if (!_stop_emit)
				value_changed();
		}
	}

	/// Returns @a str as double or @a deffault if conversion fails.
	private double string_to_double(string str, double deffault)
	{
		TinyExpr.Variable vars[] =
		{
			{ "x", &_value }
		};

		int err;
		TinyExpr.Expr expr = TinyExpr.compile(str, vars, out err);

		return err == 0 ? TinyExpr.eval(expr) : deffault;
	}
}

} /* namespace Crown */
