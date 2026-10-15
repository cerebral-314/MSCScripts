#pragma context server

// Converted from calruin2/multisource_fix.script by msc_transpiler.
// odd attempt to fix weird multisource bug in calruin2

#include "runtime/ScriptEntity.as"

[script "calruin2/multisource_fix"]
class MultisourceFix : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float LAST_TOUCHED = 0.0f;
	bool ME_ACTIVE = false;

	// unnamed block (first think)
	void MultisourceFix_FirstThink()
	{
		SetCallback("touch", "enable");
		SetProp(ENT_ME, "solid", 1);
	}

	// game_touch
	string MultisourceFix_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (ME_ACTIVE)
			return result;
		if (!IsPlayer(other))
			return result;

		float timeDiff = GameTime() - LAST_TOUCHED;
		if (!(timeDiff > 2.0f))
			return result;
		LAST_TOUCHED = GameTime();

		ME_ACTIVE = true;
		CallExternal(GetVar("GAME_MASTER"), "calruin2_trigger_touched");
		return result;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return MultisourceFix_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// calruin2_trigger_reset
	void OnCalruin2TriggerReset()
	{
		ME_ACTIVE = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MultisourceFix_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "calruin2_trigger_reset") { OnCalruin2TriggerReset(); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}
