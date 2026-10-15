#pragma context server

// Converted from monsters/guardian_iron_charger.script by msc_transpiler.
// Guardian Charger by Thothie
// - Temporary script that marks the position to charge from

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "monsters/guardian_iron_charger"]
class GuardianIronCharger : BaseTemporaryScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary

		SetGravity(0);
		CallEventDelayed(0.01f, "mark_position");
	}

	// mark_position
	void OnMarkPosition()
	{
		SetGlobal("G_GUARDIAN_CHARGER", OriginOf(ENT_ME));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "mark_position") { OnMarkPosition(); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
