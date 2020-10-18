/*
 * Copyright (c) 2012-2020 Daniele Bartolini and individual contributors.
 * License: https://github.com/dbartolini/crown/blob/master/LICENSE
 */

namespace Crown
{
const string CROWN_VERSION = "0.39.0";

#if CROWN_PLATFORM_LINUX
const string ENGINE_DIR = ".";
const string EXE_PREFIX = "./";
const string EXE_SUFFIX = "";
#elif CROWN_PLATFORM_WINDOWS
const string ENGINE_DIR = ".";
const string EXE_PREFIX = "";
const string EXE_SUFFIX = ".exe";
#endif
const string ENGINE_EXE = EXE_PREFIX
#if CROWN_DEBUG
	+ "crown-debug"
#else
	+ "crown-development"
#endif
	+ EXE_SUFFIX;
const string DEPLOY_DEFAULT_NAME = "crown-release";
const string DEPLOY_EXE = EXE_PREFIX + DEPLOY_DEFAULT_NAME + EXE_SUFFIX;

const uint16 CROWN_DEFAULT_SERVER_PORT = 10618;

const string LEVEL_EDITOR_BOOT_DIR = "core/editors/level_editor";
const string UNIT_PREVIEW_BOOT_DIR = "core/editors/unit_preview";
const string LEVEL_NONE = "";

}
