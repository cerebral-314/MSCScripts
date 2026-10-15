#pragma context server

// Converted from monsters/summon/sfx_glassmaker.script by msc_transpiler.
// Thothie - stupid thing to ensure ice lords death anim goes right

#include "runtime/ScriptEntity.as"

[script "monsters/summon/sfx_glassmaker"]
class SfxGlassmaker : ScriptEntity
{
	// Constants
	bool DO_NADDA = false;

	// Variables (an unset .script variable reads as its own name)
	bool DO_NADDA2 = false;

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DO_NADDA2 = false;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetRace("beloved");
		SetInvincible(true);
		CallEventDelayed(0.1f, "glass_splodie");
	}

	// glass_splodie
	void OnGlassSplodie()
	{
		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 40, 10, 100, 30);
		CallEventDelayed(0.1f, "glass_splodie2");
	}

	// glass_splodie2
	void OnGlassSplodie2()
	{
		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 128)), 1, 40, 10, 100, 30);
		CallEventDelayed(0.1f, "remove_sploder");
	}

	// remove_sploder
	void OnRemoveSploder()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "glass_splodie") { OnGlassSplodie(); return true; }
		if (name == "glass_splodie2") { OnGlassSplodie2(); return true; }
		if (name == "remove_sploder") { OnRemoveSploder(); return true; }
		return false;
	}
}
