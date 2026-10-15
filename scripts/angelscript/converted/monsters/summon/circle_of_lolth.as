#pragma context server

// Converted from monsters/summon/circle_of_lolth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe2.as"

[script "monsters/summon/circle_of_lolth"]
class CircleOfLolth : BaseAoe2Script
{
	// Constants
	string SOUND_PULSE = "bullchicken/bc_acid2.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	bool AOE_AFFECTS_WARY = false;
	string MY_SKILL = "MY_SKILL";
	string MY_CL_IDX = "MY_CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	CircleOfLolth()
	{
		AOE_SCAN_FREQ = 1.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe2_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe2
		SetNoPush(true);
		SetInvincible(true);
		PLAYING_DEAD = "1";
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = duration
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseAoe2_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_aoe2
		MY_OWNER = creatorValue1;
		AOE_DURATION = creatorValue2;
		AOE_RADIUS = "180";
		AOE_AFFECTS_WARY = true;

		Vector3 myGround = OriginOf(ENT_ME);
		float curGroundZ = GroundHeight(myGround);
		myGround.z = curGroundZ;
		SetOrigin(ENT_ME, myGround);

		if (!IsPlayer(ENT_ME))
			MY_SKILL = "none";

		ClientEvent("new", "all", "effects/sfx_seal", OriginOf(ENT_ME), AOE_RADIUS, 36, AOE_DURATION, "spider");
		MY_CL_IDX = LastClientScriptId();
	}

	// aoe_scan_loop
	void OnAoeScanLoop()
	{
		BaseAoe2_OnAoeScanLoop(); // monsters/summon/base_aoe2
		ClientEvent("update", "all", MY_CL_IDX, "ext_spider_pulse");
	}

	// aoe_end
	void OnAoeEnd()
	{
		BaseAoe2_OnAoeEnd(); // monsters/summon/base_aoe2
		DeleteEntity(ENT_ME);
	}

	// aoe_affect_target
	void OnAoeAffectTarget(string target = "")
	{
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(target, "direct", Random(5, 10), 100, MY_OWNER, MY_OWNER, "axehandling", "magic_effect");
		ApplyEffect(target, "effects/webbed", 3, MY_OWNER);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/seals.mdl");
		CallEventDelayed(AOE_SCAN_FREQ, "aoe_scan_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_affect_target") { OnAoeAffectTarget(Param(params, 0)); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "aoe_scan_loop") { OnAoeScanLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseAoe2Script::DispatchEvent(name, params);
	}
}
