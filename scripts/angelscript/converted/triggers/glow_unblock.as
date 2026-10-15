#pragma context server

// Converted from triggers/glow_unblock.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "triggers/glow_unblock"]
class GlowUnblock : ScriptEntity
{
	// unnamed block (first think)
	void GlowUnblock_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string GlowUnblock_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (Truthy(ScriptVarOf(other, "PLR_GLOW_BLOCK")))
			CallExternal(other, "ext_glow_block", 0);
		return result;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return GlowUnblock_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GlowUnblock_FirstThink();
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
