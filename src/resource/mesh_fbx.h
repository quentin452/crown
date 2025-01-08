/*
 * Copyright (c) 2012-2024 Daniele Bartolini et al.
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "config.h"

#if CROWN_CAN_COMPILE
#include "resource/mesh.h"
#include "resource/types.h"

namespace crown
{
namespace fbx
{
	///
	s32 parse(Mesh &m, Buffer &buf, CompileOptions &opts);

} // namespace fbx

} // namespace crown

#endif
