/*
 * Copyright (c) 2012-2024 Daniele Bartolini et al.
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include "config.h"

#if CROWN_CAN_COMPILE
#include "core/containers/types.h"
#include "core/json/types.h"
#include "core/strings/string_id.h"
#include "resource/types.h"

namespace crown
{
typedef s32 (*CompileFunction)(Buffer &output, const char *json, CompileOptions &opts);

struct ComponentTypeData
{
	ALLOCATOR_AWARE;

	u32 _num;
	Array<u32> _unit_index;
	Buffer _data;
	CompileFunction _compiler;

	explicit ComponentTypeData(Allocator &a)
		: _num(0)
		, _unit_index(a)
		, _data(a)
		, _compiler(NULL)
	{
	}
};

struct ComponentTypeInfo
{
	StringId32 _type;
	float _spawn_order;

	bool operator<(const ComponentTypeInfo &a) const
	{
		return _spawn_order < a._spawn_order;
	}
};

struct Unit
{
	ALLOCATOR_AWARE;

	StringId32 _editor_name;
	JsonArray _merged_components;
	JsonArray _merged_components_data;
	HashMap<Guid, Unit *> _children;
	Unit *_parent;

	///
	explicit Unit(Allocator &a);
};

struct UnitCompiler
{
	HashMap<Guid, Unit *> _units;
	CompileOptions &_opts;
	Buffer _prefab_data;
	Array<u32> _prefab_offsets;
	Array<StringId64> _prefab_names;
	HashMap<StringId32, ComponentTypeData> _component_data;
	Array<ComponentTypeInfo> _component_info;
	Array<StringId32> _unit_names;
	Array<u32> _unit_parents;
	u32 _num_units;

	///
	UnitCompiler(Allocator &a, CompileOptions &opts);

	///
	~UnitCompiler();
};

namespace unit_compiler
{
	///
	s32 parse_unit(UnitCompiler &c, const char *path);

	///
	s32 parse_unit_array_from_json(UnitCompiler &c, const char *units_array_json);

	///
	Buffer blob(UnitCompiler &c);

} // namespace unit_compiler

} // namespace crown

#endif // if CROWN_CAN_COMPILE
