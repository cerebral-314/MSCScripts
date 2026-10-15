#pragma context server

// Converted from other/end_siege.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "other/end_siege"]
class EndSiege : BaseTemporaryScript
{
	// Variables (an unset .script variable reads as its own name)
	string G_SIEGE_MAP = "G_SIEGE_MAP";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary
		SetGlobal("G_CRITICAL_NPCS", "");
		G_SIEGE_MAP = "0";
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
