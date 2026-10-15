#pragma context server

// Converted from other/trigger_base.script by msc_transpiler.
// base for scripted hurt triggers
// Attach this to a func_wall_toggle with a targetname for breaking web effect that slows players
// Targetname [PARAM2] = name to use
// target [PARAM3] = amt to burn

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherTriggerBase
{
	// Variables (an unset .script variable reads as its own name)
	string EFFECT_DAMAGE = "EFFECT_DAMAGE";
	string EFFECT_TIME = "EFFECT_TIME";
	float LAST_DMG = 0.0f;

	// unnamed block (first think)
	void OtherTriggerBase_FirstThink()
	{
		SetCallback("touch", "enable");
		SetProp(ENT_ME, "solid", 1);
	}

	// game_touch
	string OtherTriggerBase_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		bool playerOnly = false;
		bool exitSub = false;
		string result = "";

		if (!(GameTime() > LAST_DMG))
			return result;

		// dbg PARAM2 touched by $get(PARAM1,name) for PARAM3
		EFFECT_DAMAGE = effectDamage;
		if (EFFECT_DAMAGE.isEmpty())
		{
			int burnDamage = 1000;
		}
		EFFECT_TIME = "2";
		if (Contains(EFFECT_DAMAGE, ";"))
		{
			EFFECT_DAMAGE = GetToken(effectDamage, 0);
			EFFECT_TIME = GetToken(effectDamage, 1);
			if (Contains(effectDamage, "no_monsters"))
				playerOnly = true;
		}
		CallExternal(GetVar("GAME_MASTER"), "gm_setname", hpRange);

		if (playerOnly && !IsPlayer(other))
			exitSub = true;
		if (exitSub)
			return result;

		LAST_DMG = GameTime() + Float(EFFECT_TIME);

		OnApplyDamage(other);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherTriggerBase_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnApplyDamage(CBaseEntity@ target = null) {} // apply_damage

	// This file's events and timers by their .script names
	bool OtherTriggerBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/trigger_base"]
shared class OtherTriggerBaseScript : ScriptEntity, OtherTriggerBase
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherTriggerBase_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherTriggerBase_DispatchEvent(name, params);
	}
}
