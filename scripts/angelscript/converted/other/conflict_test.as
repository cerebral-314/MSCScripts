#pragma context server

// Converted from other/conflict_test.script by msc_transpiler.
// utility script to test that conflict debugging is working

#include "runtime/ScriptEntity.as"
#include "converted/monsters/externals.as"
#include "converted/monsters/debug.as"

[script "other/conflict_test"]
class ConflictTest : MonstersExternalsScript
{
	// Constants
	int NOTICE_THIS_CONFLICT = 1;

	// Variables (an unset .script variable reads as its own name)
	bool CHECK_CONFLICTS = true;

	// unnamed block (first think)
	void ConflictTest_FirstThink()
	{
		CHECK_CONFLICTS = true;
		NOTICE_THIS_CONFLICT = 2;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Conflict Checker");
		SetModel("monsters/skeleton.mdl");
		SetWidth(32);
		SetHeight(32);
		SetHealth(10);
		SetRace("beloved");
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		PlayAnim("once", "idle1");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ConflictTest_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return MonstersExternalsScript::DispatchEvent(name, params);
	}
}
