/*
 * Copyright (c) 2012-2025 Daniele Bartolini et al.
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Crown
{
public class AndroidDeployer
{
	public string? _sdk_path;
	public string? _ndk_root_path;
	public string? _build_tools_path;
	public string _dx_path;
	public string _aapt_path;
	public string _zipalign_path;

	public AndroidDeployer()
	{
		_sdk_path = null;
		_ndk_root_path = null;
		_build_tools_path = null;

		check_config();
	}

	public int check_config()
	{
		_sdk_path = GLib.Environment.get_variable("ANDROID_SDK_PATH");
		if (_sdk_path == null)
			return -1;

		_ndk_root_path = GLib.Environment.get_variable("ANDROID_NDK_ROOT");
		if (_ndk_root_path == null)
			return -1;

		_build_tools_path = GLib.Environment.get_variable("ANDROID_BUILD_TOOLS");
		if (_build_tools_path == null)
			return -1;

		_dx_path = Path.build_path(Path.DIR_SEPARATOR_S
			, _build_tools_path
			, "dx"
			);

		_aapt_path = Path.build_path(Path.DIR_SEPARATOR_S
			, _build_tools_path
			, "aapt"
			);

		_zipalign_path = Path.build_path(Path.DIR_SEPARATOR_S
			, _build_tools_path
			, "zipalign"
			);

		return 0;
	}
}

} /* namespace Crown */
