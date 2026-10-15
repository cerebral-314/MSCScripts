#pragma context server

// Converted from monsters/summon/base_aoe2.script by msc_transpiler.
// Thothie MAR2010_15
// - Dependable base_aoe script
// -
// - These vars MUST be set in game_dynamically_created
// - AOE_OWNER - id of owner (will use value of MY_OWNER if set)
// - AOE_RADIUS - radius of AOE effect (can also be const)
// - AOE_DURATION - duration of AOE effect (can also be const)
// - AOE_AFFECTS_WARY - wary enemies are effected
// - Constants (default)
// - AOE_SCAN_TYPE dodamage (scan via dodamage - maybe blocked by other entities) | tsphere (scan via sphere [goes through walls]) | rsphere (scans area freely, but does not go through walls) | noscan (does no scan, but still calls aoe_scan_loop)
// - AOE_SCAN_FREQ 0.5 - how often to scan
// - AOE_FRIENDLY 0 (set 1 for friendly effects)
// - AOE_VULNERABLE 0 (set to 1 to allow AOE generator to be attacked)
// - AOE_VADJ 0 (vertically adjust scan point for dodamage scans)
// - Set by base
// - AOE_ACTIVE - 1 while active
// - Calls to be handled by top script
// - aoe_affect_target <id> //note: checks PVP before call, unless AOE_FRIENDLY
// - aoe_end - called when AOE_DURATION ends (does not remove script)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseAoe2
{
	// Constants
	string AOE_SCAN_TYPE = "dodamage";
	float AOE_SCAN_FREQ = 0.5f;
	bool AOE_FRIENDLY = false;
	bool AOE_VULNERABLE = false;
	int AOE_VADJ = 0;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string AOE_OWNER = "AOE_OWNER";
	bool AOE_ACTIVE = false;
	string AOE_TARGET_LIST = "AOE_TARGET_LIST";

	// game_spawn
	void BaseAoe2_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (AOE_VULNERABLE)
			return;
		SetModel("null.mdl");
		SetInvincible(true);
		SetRace("beloved");
		SetNoPush(true);
		SetGravity(0);
		PLAYING_DEAD = "1";
	}

	// game_dynamically_created
	// <owner> <radius> <duration> <affects_wary>
	void BaseAoe2_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		CallEventDelayed(0.01f, "aoe_start");
	}

	// aoe_start
	void BaseAoe2_OnAoeStart()
	{
		if (IsAlive(GetVar("MY_OWNER"))) // Small adaption for older scripts
			AOE_OWNER = GetVar("MY_OWNER");
		if (!AOE_VULNERABLE) // If this is vulnerable, set appropriate race so it can be targeted
			SetRace(RaceOf(AOE_OWNER));

		AOE_ACTIVE = true;
		OnAoeScanLoop(); // Start scanning
		CallEventOrDelay(AOE_DURATION, "aoe_end"); // Set timer to end aoe
	}

	// aoe_scan_loop
	void BaseAoe2_OnAoeScanLoop()
	{
		int count;

		if (!AOE_ACTIVE)
			return;
		CallEventDelayed(AOE_SCAN_FREQ, "aoe_scan_loop"); // call loop again

		if (AOE_SCAN_TYPE == "dodamage")
			DoDamage(Text(RelativePosition(Vector3(0, 0, AOE_VADJ))), AOE_RADIUS, 0, "100%", 0, "reflective", "target");

		if (Contains(AOE_SCAN_TYPE, "sphere"))
		{
			if (AOE_FRIENDLY) // Get list to affect friendlies
			{
				AOE_TARGET_LIST = LegacyFunction("get_isphere", "ally", AOE_RADIUS);
			}
			else
			{
				AOE_TARGET_LIST = LegacyFunction("get_isphere", "any", AOE_RADIUS); // Get list to affect enemies
			}

			if (AOE_TARGET_LIST != "none")
			{
				count = GetTokenCount(AOE_TARGET_LIST);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnAoeAffectTargets();
				}
			}
		}
	}

	// aoe_affect_targets
	void BaseAoe2_OnAoeAffectTargets()
	{
		string targ = GetToken(AOE_TARGET_LIST, loopIteration);
		targ = EntityId(EntityOf(targ));

		int doEffect = Int(OnFuncFilterTargs(targ));

		if (doEffect == 0)
			return;
		OnAoeAffectTarget(targ); // affect target
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) //This gets called when using the 'dodamage' scan type
	string BaseAoe2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		int doEffect = Int(OnFuncFilterTargs(EntityId(target)));

		if (doEffect == 0)
			return result;
		OnAoeAffectTarget(EntityId(target));
		return result;
	}

	// aoe_end
	void BaseAoe2_OnAoeEnd()
	{
		AOE_ACTIVE = false;
	}

	// func_filter_targs
	// <targId> //returns 0 or 1 depending on whether or not this aoe should affect the given target
	string BaseAoe2_OnFuncFilterTargs(string target = "")
	{
		string result = "";

		bool doEffect = true;

		if (!AOE_FRIENDLY) // If not a friendly aoe
		{
			if (IsPlayer(AOE_OWNER))
			{
				if (IsPlayer(target)) // if player is trying to affect player
				{
					if (!IsPvp()) // If not pvp, then dont affect target
						doEffect = false;
				}
			}

			// Only check relationships if its not a friendly aoe, since getting non-friendly list here does not auto-filter relationships.
			string relate = RelationshipOf(AOE_OWNER, target);
			if (relate == "ally")
				doEffect = false;
			else if (relate == "neutral")
				doEffect = false;

			if (!Truthy(GetVar("AOE_AFFECTS_WARY")) && relate == "wary")
				doEffect = false;
		}

		if (AOE_SCAN_TYPE == "rsphere")
		{
			// Check for line of sight
			Vector3 traceStart = OriginOf(ENT_ME);
			Vector3 traceEnd = OriginOf(target);
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");

			if (traceLine != Text(traceEnd))
			{
				doEffect = false; // There is a wall in the way!
			}
		}

		result = "";
		result = AppendResult(result, Text(doEffect));
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseAoe2_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { BaseAoe2_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnAoeStart() { BaseAoe2_OnAoeStart(); } // aoe_start
	void OnAoeScanLoop() { BaseAoe2_OnAoeScanLoop(); } // aoe_scan_loop
	void OnAoeAffectTargets() { BaseAoe2_OnAoeAffectTargets(); } // aoe_affect_targets
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseAoe2_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnAoeEnd() { BaseAoe2_OnAoeEnd(); } // aoe_end
	string OnFuncFilterTargs(string target = "") { return BaseAoe2_OnFuncFilterTargs(target); } // func_filter_targs
	void OnAoeDuration() {} // AOE_DURATION
	void OnAoeAffectTarget(string target = "") {} // aoe_affect_target

	// This file's events and timers by their .script names
	bool BaseAoe2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "aoe_affect_targets") { OnAoeAffectTargets(); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "aoe_scan_loop") { OnAoeScanLoop(); return true; }
		if (name == "aoe_start") { OnAoeStart(); return true; }
		if (name == "func_filter_targs") { Return(OnFuncFilterTargs(Param(params, 0))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/base_aoe2"]
shared class BaseAoe2Script : ScriptEntity, BaseAoe2
{
	// Variables every script that includes this file declares
	string AOE_DURATION = "AOE_DURATION";
	string AOE_RADIUS = "AOE_RADIUS";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(AOE_SCAN_FREQ, "aoe_scan_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseAoe2_DispatchEvent(name, params);
	}
}
