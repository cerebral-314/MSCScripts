#pragma context server

// Converted from effects/base_debuff_diminishing.script by msc_transpiler.
// Debuff with adjustable diminishing return values
// by greatguys1
// This type of diminishing return uses a "pool" of seconds to pull from.
// Different effects have different pools. Pool is based on effect_id.
// If no time remains in the pool, the effect will not be applied.
// Pool regenerates slowly.
// Intended for heavy cc effects
// . effectmestack effects/base_debuff_diminishing 2

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseDebuffDiminishing
{
	// Constants
	string EFFECT_ID = "base_debuff";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	int POOL_CAP = 10;
	int POOL_REGEN = 4;

	// Variables (an unset .script variable reads as its own name)
	int POOL_REMAINING = 0;
	string POOL_FLAG_NAME = "POOL_FLAG_NAME";
	bool DEBUFF_SCRIPTFLAG = false;

	// unnamed block (first think)
	void BaseDebuffDiminishing_FirstThink()
	{
		POOL_REMAINING = POOL_CAP;
		POOL_FLAG_NAME = EFFECT_ID + "_diminishing";
	}

	// debuff_check_scriptflag
	// sets variables for scriptflags or disables applying if no time left in pool
	void BaseDebuffDiminishing_OnDebuffCheckScriptflag()
	{
		if (DEBUFF_SCRIPTFLAG)
			return;

		string action = "add";
		float timeUsed = Float(EFFECT_DURATION);

		if (Truthy(ScriptFlag(ENT_ME, POOL_FLAG_NAME, "name_exists")))
		{
			OnPoolGetAvailable();
			action = "edit";
		}
		timeUsed = Clamp(timeUsed, 0.0f, POOL_REMAINING);

		if (timeUsed == 0.0f) // no time left
		{
			DEBUFF_SCRIPTFLAG = true; // stops and removes the effect
			return;
		}

		OnEffectSetDuration(Text(timeUsed));

		float poolUsed = POOL_CAP - POOL_REMAINING;
		float regenTime = (timeUsed + poolUsed) * POOL_REGEN;
		string regenTimeText = Text(regenTime);

		string type = Text(GameTime() + timeUsed) + ";" + Text(timeUsed + poolUsed);

		ScriptFlags(ENT_ME, action, POOL_FLAG_NAME, type, regenTimeText, regenTimeText);
	}

	// pool_get_available
	// Gets number of seconds left available in the pool
	void BaseDebuffDiminishing_OnPoolGetAvailable()
	{
		ScriptFlags(ENT_ME, "remove_expired"); // Remove potentially expired dots

		string value = ScriptFlag(ENT_ME, POOL_FLAG_NAME, "name_type");

		if (value == "none")
		{
			POOL_REMAINING = POOL_CAP;
			return;
		}

		string endTime = GetToken(value, 0);
		float remaining = POOL_CAP - Float(GetToken(value, 1));

		float recovered = Clamp(Divide(GameTime() - Float(endTime), POOL_REGEN), 0.0f, 999.0f); // No negative values
		recovered = int(recovered); // Round down

		remaining += recovered;

		POOL_REMAINING = int(remaining);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// debuff_check_scriptflag
	void OnDebuffCheckScriptflag()
	{
		BaseDebuff_OnDebuffCheckScriptflag(); // effects/base_debuff
		BaseDebuffDiminishing_OnDebuffCheckScriptflag();
	}

	void OnPoolGetAvailable() { BaseDebuffDiminishing_OnPoolGetAvailable(); } // pool_get_available

	// This file's events and timers by their .script names
	bool BaseDebuffDiminishing_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "debuff_check_scriptflag") { OnDebuffCheckScriptflag(); return true; }
		if (name == "pool_get_available") { OnPoolGetAvailable(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/base_debuff_diminishing"]
shared class BaseDebuffDiminishingScript : BaseDebuffScript, BaseDebuffDiminishing
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseDebuffDiminishing_FirstThink();
		BaseDebuff_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseDebuffDiminishing_DispatchEvent(name, params)
			|| BaseDebuffScript::DispatchEvent(name, params);
	}
}
