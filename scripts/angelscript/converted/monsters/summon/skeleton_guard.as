#pragma context server

// Converted from monsters/summon/skeleton_guard.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/skeleton.as"

[script "monsters/summon/skeleton_guard"]
class SkeletonGuard : MonstersSummonSkeletonScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonGuard()
	{
		SUM_SAY_COME = "Yes... my maaaster.";
		SUM_SAY_ATTACK = "Death... Approaches...";
		SUM_SAY_HUNT = "I am... Hunt...ing...";
		SUM_SAY_DEFEND = "Your... Defense... Is all.";
		SUM_SAY_DEATH = "No longer... Can I... Hold.";
		SUM_SAY_GUARD = "I... Shall hold.";
		SUM_REPORT_SUFFIX = ", master.";
		GUARD_STRUCK1 = "body/armour1.wav";
		GUARD_STRUCK2 = "body/armour2.wav";
		GUARD_STRUCK3 = "body/armour3.wav";
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 8, GUARD_STRUCK1, GUARD_STRUCK2, GUARD_STRUCK3);
	}

	// summon_spawn
	void OnSummonSpawn()
	{
		MonstersSummonSkeleton_OnSummonSpawn(); // monsters/summon/skeleton

		SetName("Undead Guardian");

		SetAnimMoveSpeed(0.5f);
		SetAnimFrameRate(0.5f);
		SetDamageTaken("all", 0.5f);

		SetBlood("none");

		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("holy", 3);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("poison", 0);

		BASE_FRAMERATE = "0.5";
	}

	// pre_name_set
	void OnPreNameSet()
	{
		SetModelBody(0, 3);
		SetModelBody(1, 3);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "pre_name_set") { OnPreNameSet(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		return MonstersSummonSkeletonScript::DispatchEvent(name, params);
	}
}
