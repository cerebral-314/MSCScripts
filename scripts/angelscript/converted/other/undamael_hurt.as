#pragma context server

// Converted from other/undamael_hurt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherUndamaelHurt
{
	// Variables (an unset .script variable reads as its own name)
	float LAST_TOUCH = 0.0f;
	string UNDAMAEL_ID = "UNDAMAEL_ID";
	string RAND_ID = "RAND_ID";

	// unnamed block (first think)
	void OtherUndamaelHurt_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string OtherUndamaelHurt_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (EntityId(other) == UNDAMAEL_ID)
			return result;
		DebugPrint("touching something not undamael!");
		if (!(GameTime() > LAST_TOUCH))
			return result;
		LAST_TOUCH = GameTime() + 0.5f;
		if (!IsAlive(other))
			return result;
		// dodamage PARAM1 direct 10000 100% UNDAMAEL_ID target
		if (IsAlive(UNDAMAEL_ID))
		{
			HelpTip(other, "generic", "BEWARE", "The lava Undmael rests in acts as his digestive system. Undamael has gained", HealthOf(other), "health.");
			GiveHealth(UNDAMAEL_ID, HealthOf(other));
		}
		if ("UNDAMAEL_ID" != UNDAMAEL_ID)
			DoDamageEx(@other, "direct", 10000, "100%", UNDAMAEL_ID, UNDAMAEL_ID, "none", "target");
		else if (IsPlayer(other))
			LegacyCommand("kill", @other);
		else
			DoDamageEx(@other, "direct", 10000, "100%", GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", "target");
		return result;
	}

	// undamael_spawn
	void OtherUndamaelHurt_OnUndamaelSpawn()
	{
		UNDAMAEL_ID = EntityId(FindByName("undamael"));
	}

	// bd_debug
	// <print_var> <property_printvar> <extra> <extra> <caller_id>
	void OtherUndamaelHurt_OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "")
	{
		if (RAND_ID == "RAND_ID")
		{
			SetName("pitedge");
			RAND_ID = RandomInt(1000, 9999);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherUndamaelHurt_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnUndamaelSpawn() { OtherUndamaelHurt_OnUndamaelSpawn(); } // undamael_spawn

	// bd_debug
	void OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "")
	{
		OtherUndamaelHurt_OnBdDebug(caller, varType, varName, key);
		Debug_OnBdDebug(caller, varType, varName, key); // monsters/debug
	}

	// This file's events and timers by their .script names
	bool OtherUndamaelHurt_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bd_debug") { OnBdDebug(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "undamael_spawn") { OnUndamaelSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/undamael_hurt"]
shared class OtherUndamaelHurtScript : DebugScript, OtherUndamaelHurt
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherUndamaelHurt_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherUndamaelHurt_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
