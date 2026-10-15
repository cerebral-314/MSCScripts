#pragma context server

// Converted from chests/orcfor_caves.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/orcfor_base.as"

[script "chests/orcfor_caves"]
class OrcforCaves : OrcforBaseScript
{
	// Variables (an unset .script variable reads as its own name)
	bool SET_TRAP = false;

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseTreasurechest_OnGamePlayerused(player); // chests/base_treasurechest
		if (SET_TRAP)
			return;
		SET_TRAP = true;
		string msgTitle = NameOf(player) + " has triggered a trap!";
		InfoMessage("all", msgTitle, "Oh noes!");
		UseTrigger("spawn_cave_trap");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OrcforBase_OnChestAdditems(); // chests/orcfor_base

		OnAddGold(100.0f * Float(GetVar("G_GAVE_ARTI1")));
		OnAddEpicItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		return OrcforBaseScript::DispatchEvent(name, params);
	}
}
