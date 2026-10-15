#pragma context server

// Converted from monsters/summon/dragonfly.script by msc_transpiler.
// Summoned dragon fly for DragonFly Queen

#include "runtime/ScriptEntity.as"
#include "converted/monsters/dragonfly.as"

[script "monsters/summon/dragonfly"]
class MonstersSummonDragonfly : MonstersDragonflyScript
{
	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SetHealth(Float(SUMMON_HP));
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		// 1:$get(ent_me,id) 2:DMG_SUMMON 3:SUMMON_HEALTH 4:SUMMON_LIFETIME 5:HUNT_LASTTARGET
		MY_OWNER = creatorValue1;
		ATTACK_DAMAGE = creatorValue2;
		SUMMON_HP = damage;
		MY_DURATION = skill;
		FIRST_TARGET = extraValue5;
		CallEventDelayed(1.5f, "set_firstarg");
		CallEventOrDelay(MY_DURATION, "fade_out");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersDragonfly_OnNpcSpawn(npc); // monsters/dragonfly

		SetName("Dragonfly Spawn");
		SetModel("monsters/dragonfly.mdl");
		SetFly(true);
		SetRace("demon");
		SetHealth(30);
		SetWidth(24);
		SetHeight(24);
		SetHearingSensitivity(2);
		SetVolume(5);
		SetRoam(true);
		SetDamageTaken("pierce", 0.5f);
		SetMonsterClip(false);
		NPC_GIVE_EXP = 10.0f;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// set_firstarg
	void OnSetFirstarg()
	{
		OnNpcatkSettarget(FIRST_TARGET);
	}

	// fade_out
	void OnFadeOut()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "set_firstarg") { OnSetFirstarg(); return true; }
		return MonstersDragonflyScript::DispatchEvent(name, params);
	}
}
