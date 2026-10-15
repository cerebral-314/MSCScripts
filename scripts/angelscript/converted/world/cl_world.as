#pragma context server

// Converted from world/cl_world.script by msc_transpiler.
// General Settings for all maps
// This script is run on the client

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ClWorld
{

	// game_newlevel
	// 1: Mapname
	void ClWorld_OnGameNewlevel(string map = "")
	{
		SetGlobal("global.map.allownight", 1);
		OnTestmapNewlevel(map); // just for testing reflective surfaces
	}

	// testmap_newlevel
	void ClWorld_OnTestmapNewlevel(string testMode = "")
	{
		if (testMode == "test")
		{
			SetLocal("reg.texture.name", "black");
			SetLocal("reg.texture.reflect", 1);
			SetLocal("reg.texture.reflect.blend", 1);
			SetLocal("reg.texture.reflect.color", "1;1;1;0.1");
			SetLocal("reg.texture.reflect.range", 300);
			SetLocal("reg.texture.water", 1);
			LegacyCommand("registertexture");

			SetLocal("reg.texture.name", "Drapery2");
			SetLocal("reg.texture.reflect", 1);
			SetLocal("reg.texture.reflect.blend", 1);
			SetLocal("reg.texture.reflect.color", "1;1;1;0.8");
			// local reg.texture.reflect.blend	0
			// local reg.texture.reflect.color	1;1;1;1
			SetLocal("reg.texture.reflect.range", 512);
			SetLocal("reg.texture.water", 0);
			SetLocal("reg.texture.reflect.world", 1);
			LegacyCommand("registertexture");
		}

		if (testMode == "simple")
		{
			SetLocal("reg.texture.name", "black");
			SetLocal("reg.texture.reflect", 1);
			SetLocal("reg.texture.reflect.blend", 1);
			SetLocal("reg.texture.reflect.color", "1;1;1;0.8");
			SetLocal("reg.texture.reflect.range", 512);
			SetLocal("reg.texture.water", 0);
			LegacyCommand("registertexture");
		}

		SetLocal("reg.texture.name", "reflect_full");
		SetLocal("reg.texture.reflect", 1);
		SetLocal("reg.texture.reflect.blend", 1);
		SetLocal("reg.texture.reflect.color", "1;1;1;0.5");
		SetLocal("reg.texture.reflect.range", 1024);
		SetLocal("reg.texture.reflect.world", 1);
		SetLocal("reg.texture.water", 1);
		LegacyCommand("registertexture");

		SetLocal("reg.texture.name", "reflective");
		SetLocal("reg.texture.reflect", 1);
		SetLocal("reg.texture.reflect.blend", 1);
		SetLocal("reg.texture.reflect.color", "1;1;1;0.8");
		SetLocal("reg.texture.reflect.range", 512);
		SetLocal("reg.texture.reflect.world", 0);
		SetLocal("reg.texture.water", 0);
		LegacyCommand("registertexture");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameNewlevel(string map = "") { ClWorld_OnGameNewlevel(map); } // game_newlevel
	void OnTestmapNewlevel(string testMode = "") { ClWorld_OnTestmapNewlevel(testMode); } // testmap_newlevel

	// This file's events and timers by their .script names
	bool ClWorld_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_newlevel") { OnGameNewlevel(Param(params, 0)); return true; }
		if (name == "testmap_newlevel") { OnTestmapNewlevel(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/cl_world"]
shared class ClWorldScript : ScriptEntity, ClWorld
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ClWorld_DispatchEvent(name, params);
	}
}
