#pragma context server

// Converted from the_wall/trigger_forsuth_mountains.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "the_wall/trigger_forsuth_mountains"]
class TriggerForsuthMountains : ScriptEntity
{
	// unnamed block (first think)
	void TriggerForsuthMountains_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string TriggerForsuthMountains_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		CBaseEntity@ frostyId = FindByName("forsuth_frosty");
		DebugPrint("forsuth_trigger " + EntityId(frostyId) + " vs " + EntityId(other));
		if (other !is FindByName("forsuth_frosty"))
			return result;
		DebugPrint("forsuth_trigger Go frosty!");
		CallExternal(other, "ext_mountain_comment");
		DeleteEntity(ENT_ME);
		return result;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return TriggerForsuthMountains_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TriggerForsuthMountains_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}
