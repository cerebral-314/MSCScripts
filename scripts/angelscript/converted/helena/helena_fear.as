#pragma context server

// Converted from helena/helena_fear.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "helena/helena_fear"]
class HelenaFear : BaseTemporaryScript
{
	// Variables declared by included files, with the value they start with in this script
	HelenaFear()
	{
		DEATH_DELAY = 5.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary

		CallEventDelayed(0.5f, "make_fear");
	}

	// make_fear
	void OnMakeFear()
	{
		CallExternal("all", "orc_raid");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_fear") { OnMakeFear(); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
