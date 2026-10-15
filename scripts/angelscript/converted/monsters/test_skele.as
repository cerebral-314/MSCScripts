#pragma context server

// Converted from monsters/test_skele.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/test_skele"]
class TestSkele : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetModel("monsters/skeleton3.mdl");
		SetWidth(32);
		SetHeight(96);
		SetRace("hated");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton3.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
