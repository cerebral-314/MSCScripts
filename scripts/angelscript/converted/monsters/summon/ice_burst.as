#pragma context server

// Converted from monsters/summon/ice_burst.script by msc_transpiler.
// ice burst from flame burst

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/ice_burst"]
class IceBurst : BaseAoeScript
{
	// Constants
	int SCAN_RANGE = 256;

	// Variables (an unset .script variable reads as its own name)
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float MY_BASE_DAMAGE = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string BURST_SCRIPT_IDX = "BURST_SCRIPT_IDX";

	// game_dynamically_created
	// PARAM1 Owner, PARAM2 Damage
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// //dbg temp got PARAM1 PARAM2
		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		GAME_PVP = (IsPvp() ? 1 : 0);
		MY_BASE_DAMAGE = Float(creatorValue2);
		ACTIVE_SKILL = damage;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.ice";

		ClientEvent("new", "all_in_sight", "monsters/summon/ice_burst_cl", IndexOf(MY_OWNER));
		BURST_SCRIPT_IDX = LastClientScriptId();

		CallEventDelayed(0.25f, "big_boom");

		CallEventDelayed(3.0f, "effect_die");
	}

	// effect_die
	void OnEffectDie()
	{
		DeleteEntity(ENT_ME);
	}

	// big_boom
	void OnBigBoom()
	{
		PlaySound(0, 10, "ambience/steamburst1.wav");
		OnAoeApplyeffectRad();
	}

	// apply_aoe_effect
	// { game_dodamage //1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	// dbg game_dodamage PARAM1 $get(PARAM2,name) pvp GAME_PVP pr OWNER_ISPLAYER relate $get(PARAM2,relationship,MY_OWNER)
	// if PARAM1
	// if $get(PARAM2,relationship,MY_OWNER) equals enemy
	// //players don't burn each other
	// if ( OWNER_ISPLAYER )
	// {
	// if !GAME_PVP
	// if $get(PARAM2,isplayer)
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// local FREEZE_ON_CHANCE $rand(1,2)
	// if ( FREEZE_ON_CHANCE == 1 ) applyeffect PARAM2 effects/dot_cold 5 MY_OWNER 0 spellcasting.ice
	// if ( FREEZE_ON_CHANCE == 2 ) applyeffect PARAM2 effects/dot_cold_freeze 5 MY_OWNER 0
	// }
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		int freezeOnChance = RandomInt(1, 2);
		if (freezeOnChance == 1)
			ApplyEffect(target, "effects/dot_cold", 10, MY_OWNER, RandomInt(10, int(MY_BASE_DAMAGE)), ACTIVE_SKILL);
		if (freezeOnChance == 2)
		{
			if (HealthOf(target) > 1500.0f)
				ApplyEffect(target, "effects/dot_cold", 10, MY_OWNER, RandomInt(10, int(MY_BASE_DAMAGE)), ACTIVE_SKILL);
			if (HealthOf(target) <= 1500.0f)
				ApplyEffect(target, "effects/dot_cold_freeze", 5, MY_OWNER, RandomInt(10, 20));
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "big_boom") { OnBigBoom(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
