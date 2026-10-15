#pragma context server

// Converted from other/no_extra_exp.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "other/no_extra_exp"]
class NoExtraExp : BaseTemporaryScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary
		if (!Truthy(Eval("game.cvar.ms_difficulty")))
			return;

		SetGlobal("G_PLAYER_RAMP", 0);
		InfoMessage("all", "NO BONUS XP", "Bonus experience is blocked on this map. Monsters will not scale per player on server.");
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
