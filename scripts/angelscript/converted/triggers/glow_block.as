#pragma context server

// Converted from triggers/glow_block.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "triggers/glow_block"]
class GlowBlock : ScriptEntity
{
	// unnamed block (first think)
	void GlowBlock_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string GlowBlock_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (!Truthy(ScriptVarOf(other, "PLR_GLOW_BLOCK")))
			CallExternal(other, "ext_glow_block", 1);

		if (Truthy(ScriptVarOf(other, "IR_GLOWING")))
		{
			// applyeffect PARAM1 effects/effect_light 0.1 0 (0,0,0) $get(PARAM1,id)
			LegacyCommand("callexternal", "ext_glow_block", 1);
		}
		return result;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return GlowBlock_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GlowBlock_FirstThink();
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
