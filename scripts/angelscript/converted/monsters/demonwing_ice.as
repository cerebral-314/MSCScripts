#pragma context server

// Converted from monsters/demonwing_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/demonwing_venom.as"

[script "monsters/demonwing_ice"]
class DemonwingIce : DemonwingVenomScript
{
	// Variables declared by included files, with the value they start with in this script
	DemonwingIce()
	{
		MONSTER_NAME = "Icewing";
		MONSTER_SKIN_IDX = 2;
		SPIT_PROJECTILE = "proj_ice_bolt";
		DOT_EFFECT = "effects/dot_cold";
		MONSTER_HP = 1000.0f;
		DMG_CLAW = 100.0f;
		NPC_BASE_EXP = "200";
		SOUND_SPIT = "magic/ice_strike.wav";
	}

	// unnamed block (first think)
	void DemonwingIce_FirstThink()
	{
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 1.25f);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		DemonwingVenom_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/demonwing_venom
		CallEventDelayed(0.05f, "scale_down");
	}

	// scale_down
	void OnScaleDown()
	{
		SetProp(ENT_ME, "scale", 0.5f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/demonwing.mdl");
		Precache("monsters/bat/flap_big1.wav");
		Precache("monsters/bat/flap_big2.wav");
		Precache("magic/ice_strike.wav");
		Precache("monsters/bat/flap_big.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DemonwingIce_FirstThink();
		DemonwingVenom_FirstThink();
		DemonwingVenom_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "scale_down") { OnScaleDown(); return true; }
		return DemonwingVenomScript::DispatchEvent(name, params);
	}
}
