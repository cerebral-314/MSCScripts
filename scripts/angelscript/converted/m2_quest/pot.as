#pragma context server

// Converted from m2_quest/pot.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "m2_quest/pot"]
class Pot : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	Vector3 GLOW_COLOR = Vector3();
	float GLOW_RAD = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("cooking_pot");
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetNoPush(true);
		SetWidth(16);
		SetHeight(72);
		SetModel("props/pot1.mdl");
		GLOW_COLOR = Vector3(255, 200, 128);
		GLOW_RAD = 64.0f;
		CallEventDelayed(0.1f, "glow_loop");
	}

	// glow_loop
	void OnGlowLoop()
	{
		CallEventDelayed(10.0f, "glow_loop");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), GLOW_COLOR, GLOW_RAD, 10.1f);
	}

	// ext_cooking
	void OnExtCooking()
	{
		SetModelBody(0, 1);
		GLOW_COLOR = Vector3(255, 225, 164);
		GLOW_RAD = 96.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/pot1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_cooking") { OnExtCooking(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "glow_loop") { OnGlowLoop(); return true; }
		return false;
	}
}
