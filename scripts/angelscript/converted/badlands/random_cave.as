#pragma context server

// Converted from badlands/random_cave.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "badlands/random_cave"]
class RandomCave : BaseTemporaryScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary

		int rndTrig = RandomInt(1, 3);
		string trigString = "caveent" + rndTrig;
		UseTrigger(trigString);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
