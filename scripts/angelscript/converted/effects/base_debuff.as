#pragma context server

// Converted from effects/base_debuff.script by msc_transpiler.
// Base debuff by greatguys1
// Allows replenishing a single instance of a debuff by stacking the effect

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseDebuff
{
	// Constants
	string EFFECT_ID = "base_debuff";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";

	// Variables (an unset .script variable reads as its own name)
	string DEBUFF_INTENSITY = "1";
	bool DEBUFF_SCRIPTFLAG = false;
	bool DEBUFF_STARTED = false;

	// unnamed block (first think)
	void BaseDebuff_FirstThink()
	{
		DEBUFF_INTENSITY = "1"; // Only really necessary if the debuff has variable intensity
		DEBUFF_SCRIPTFLAG = false; // Flag that gets set to 1 if this debuff already exists
		DEBUFF_STARTED = false; // Flag that gets set to 1 when the debuff successfully starts
	}

	// game_activate
	void BaseDebuff_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		OnDebuffCheckScriptflag();

		if (Truthy(ScriptVarOf(ENT_ME, "PLAYING_DEAD")))
			DEBUFF_SCRIPTFLAG = true;

		if (!DEBUFF_SCRIPTFLAG)
			OnDebuffStart();
		else
			RemoveScript();
	}

	// debuff_start
	// Use this event to set vars for debuffs
	void BaseDebuff_OnDebuffStart()
	{
		DEBUFF_STARTED = true;
		ScriptFlags(ENT_ME, "add", EFFECT_ID, "debuff", DEBUFF_INTENSITY, EFFECT_DURATION);
	}

	// game_death
	// Gets called when npc dies
	void BaseDebuff_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ScriptFlags(ENT_ME, "remove", EFFECT_ID);
	}

	// debuff_check_scriptflag
	void BaseDebuff_OnDebuffCheckScriptflag()
	{
		ScriptFlags(ENT_ME, "remove_expired"); // Remove potentially expired dots

		string intensity = ScriptFlag(ENT_ME, EFFECT_ID, "name_value");

		if (intensity == "none") // Scriptflag exists
			return;
		if (DEBUFF_SCRIPTFLAG)
			return;

		DEBUFF_SCRIPTFLAG = true;
		ScriptFlags(ENT_ME, "edit", EFFECT_ID, "debuff", DEBUFF_INTENSITY, EFFECT_DURATION);
	}

	// game_scriptflag_update
	// <action> <name> <type> <value> <base_expire_time>
	void BaseDebuff_OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f)
	{
		if (DEBUFF_SCRIPTFLAG)
			return;
		if (action != "edit")
			return;
		if (flagName != EFFECT_ID)
			return;

		OnDebuffScriptflagUpdate(Text(value), Float(Text(baseExpireTime)));
	}

	// debuff_scriptflag_update
	void BaseDebuff_OnDebuffScriptflagUpdate(string intensity = "", float duration = 0.0f)
	{
		if (Float(intensity) > Float(DEBUFF_INTENSITY))
			DEBUFF_INTENSITY = intensity;

		// No effective way to check if new time is less than time remaining, so just set it.
		OnEffectSetDuration(Text(duration));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDebuff_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff);
	}

	void OnDebuffStart() { BaseDebuff_OnDebuffStart(); } // debuff_start
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseDebuff_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnDebuffCheckScriptflag() { BaseDebuff_OnDebuffCheckScriptflag(); } // debuff_check_scriptflag
	void OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f) { BaseDebuff_OnGameScriptflagUpdate(action, flagName, flagType, value, baseExpireTime); } // game_scriptflag_update
	void OnDebuffScriptflagUpdate(string intensity = "", float duration = 0.0f) { BaseDebuff_OnDebuffScriptflagUpdate(intensity, duration); } // debuff_scriptflag_update

	// This file's events and timers by their .script names
	bool BaseDebuff_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "debuff_check_scriptflag") { OnDebuffCheckScriptflag(); return true; }
		if (name == "debuff_scriptflag_update") { OnDebuffScriptflagUpdate(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "debuff_start") { OnDebuffStart(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_scriptflag_update") { OnGameScriptflagUpdate(Param(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/base_debuff"]
shared class BaseDebuffScript : BaseEffectScript, BaseDebuff
{
	// Variables declared by included files, with the value they start with in this script
	BaseDebuffScript()
	{
		EFFECT_ID = "base_debuff";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseDebuff_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseDebuff_DispatchEvent(name, params)
			|| BaseEffectScript::DispatchEvent(name, params);
	}
}
