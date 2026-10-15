#pragma context server

// Converted from monsters/hibari.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/hibari"]
class Hibari : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/hibari.mdl");
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		PLAYING_DEAD = "1";
		SetHealth(9999);
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		PlayAnim("once", "idle");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/hibari.mdl");
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
