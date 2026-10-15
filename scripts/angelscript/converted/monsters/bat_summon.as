#pragma context server

// Converted from monsters/bat_summon.script by msc_transpiler.
// Bat summoned by giant bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat.as"

[script "monsters/bat_summon"]
class BatSummon : MonstersBatScript
{
	// Variables (an unset .script variable reads as its own name)
	string BAT_ATTACK_DMG = "BAT_ATTACK_DMG";

	// unnamed block (first think)
	void BatSummon_FirstThink()
	{
		NPC_GIVE_EXP = 5.0f;
		CAN_FLEE = "0";
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		BAT_ATTACK_DMG = creatorValue2;
		SetMoveDest(damage, 9999);
		CallEventOrDelay(creatorValue1, "bat_die");
	}

	// bat_spawn
	void OnBatSpawn()
	{
		MonstersBat_OnBatSpawn(); // monsters/bat

		SetName("Summoned Bat");
		SetHealth(20);
		SetWidth(1);
		SetHeight(1);
		SetHearingSensitivity(3.5f);
		SetIdleAnim(ANIM_IDLE_FLY);
		SetMoveAnim(ANIM_WALK);
	}

	// bat_die
	void OnBatDie()
	{
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
		CAN_HEAR = "0";
		DeleteEntity(ENT_ME, "fade");
	}

	// bat_hang
	void OnBatHang()
	{
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, BAT_ATTACK_DMG, ATTACK_HITCHANCE);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatSummon_FirstThink();
		MonstersBat_FirstThink();
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bat_die") { OnBatDie(); return true; }
		if (name == "bat_hang") { OnBatHang(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return MonstersBatScript::DispatchEvent(name, params);
	}
}
