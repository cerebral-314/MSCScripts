#pragma context server

// Converted from monsters/slime_mud_large.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/slime_mud_large"]
class SlimeMudLarge : BaseMonsterNewScript
{
	// Constants
	string SOUND_STRUCK1 = "player/hitground2.wav";
	string SOUND_STRUCK2 = "player/hitground2.wav";
	string SOUND_ATTACK1 = "player/hitground1.wav";
	string SOUND_ATTACK2 = "player/hitground1.wav";
	string ATTACK_HITCHANCE = "70%";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string CHILD_SCRIPT = "test_scripts/example_scripts/monsters/slime_mud_small";
	int CHILD_DIST = 20;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOMMY_KILLER = "MOMMY_KILLER";

	// Variables declared by included files, with the value they start with in this script
	SlimeMudLarge()
	{
		SOUND_DEATH = "player/hitground2.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void SlimeMudLarge_FirstThink()
	{
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "30";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 120.0f;

		NPC_MUST_SEE_TARGET = "0";
		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_damaged_other
	string SlimeMudLarge_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		OnSpawnChildren();
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SlimeMudLarge_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	// PARAM1=movedest PARAM2=motherkiller Param3=NPC_DMG_MULTI Param4=NPC_HP_MULTI
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		MOMMY_KILLER = creatorValue2;
		OnNpcatkSuspendAi("0.5");
		SetMoveDest(creatorValue1, 1);
		CallEventDelayed(0.75f, "avenge_mommy");

		NPC_DMG_MULTI = Float(damage);
		NPC_HP_MULTI = Float(skill);

		if (NPC_DMG_MULTI > 0.0f)
			SetDamageMultiplier(Float(skill));
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Mud Pie");
		SetHealth(666);
		SetWidth(40);
		SetHeight(44);
		SetModel("dwarvencave/slime_ecave.mdl");
		SetModelBody(0, 11);
		SetHearingSensitivity(7);
		SetRace("wildanimal"); // greater version should be demon for ease of placement
		SetRoam(false);
		NPC_GIVE_EXP = 600.0f;
		SetBoundingBox("none");

		CallEventDelayed(1.0f, "slime_cycle");

		SetSolid("none");

		SetDamageTaken("pierce", 0.2f);
		SetDamageTaken("slash", 0.4f);
		SetDamageTaken("blunt", 0.8f);
		SetDamageTaken("cold", 0.6f);
		SetDamageTaken("fire", 0.6f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("stun", 1);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
	}

	// bite1
	// called from model
	void OnBite1()
	{
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "fire");
	}

	// spawn_children
	void OnSpawnChildren()
	{
		CBaseEntity@ myKiller = EntityOf(ENT_LASTSTRUCK);

		Vector3 childMoveDest = MyOrigin();
		Vector3 locOffset = RelativePosition(Vector3(0, -20, 0));
		childMoveDest += RelativePosition(Vector3(0, 45, 0), Vector3(0, 128, 0));
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc", 0.1f, CHILD_SCRIPT, RelativePosition(Vector3(0, -20, 0)), childMoveDest, @myKiller, NPC_DMG_MULTI, NPC_HP_MULTI);

		childMoveDest = MyOrigin();
		locOffset = RelativePosition(Vector3(0, 20, 0));
		childMoveDest += RelativePosition(Vector3(0, 135, 0), Vector3(0, 128, 0));
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc2", 0.2f, CHILD_SCRIPT, locOffset, childMoveDest, @myKiller, NPC_DMG_MULTI, NPC_HP_MULTI);

		childMoveDest = MyOrigin();
		locOffset = RelativePosition(Vector3(20, 0, 0));
		childMoveDest += RelativePosition(Vector3(0, 225, 0), Vector3(0, 128, 0));
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc3", 0.3f, CHILD_SCRIPT, locOffset, childMoveDest, @myKiller, NPC_DMG_MULTI, NPC_HP_MULTI);

		childMoveDest = MyOrigin();
		locOffset = RelativePosition(Vector3(-20, 0, 0));
		childMoveDest += RelativePosition(Vector3(0, 315, 0), Vector3(0, 128, 0));
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc4", 0.4f, CHILD_SCRIPT, RelativePosition(Vector3(-20, 0, 0)), childMoveDest, @myKiller, NPC_DMG_MULTI, NPC_HP_MULTI);
	}

	// slime_cycle
	void OnSlimeCycle()
	{
		// //dbg temp Slimetarget $get(NPCATK_TARGET,name)
		if (NPCATK_TARGET == "unset" && RandomInt(1, 10) == 1)
			PlaySound(0, 10, "SOUND_IDLE");

		if (NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) < ATTACK_RANGE && RandomInt(1, 3) == 1)
		{
			Vector3 destPos = OriginOf(NPCATK_TARGET);
			OnNpcatkSuspendAi("1.0", "combat_reposition");
			NPC_FORCED_MOVEDEST = true;
			int rndAng = RandomInt(0, 359);
			destPos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, ATTACK_RANGE, 0));
			SetMoveDest(destPos, 1);
		}

		CallEventDelayed(2.0f, "slime_cycle");
	}

	// avenge_mommy
	void OnAvengeMommy()
	{
		OnNpcatkSettarget(MOMMY_KILLER, "he_killed_mommy!");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarvencave/slime_ecave.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeMudLarge_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "avenge_mommy") { OnAvengeMommy(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "slime_cycle") { OnSlimeCycle(); return true; }
		if (name == "spawn_children") { OnSpawnChildren(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
