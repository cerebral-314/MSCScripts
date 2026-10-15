#pragma context server

// Converted from monsters/slime_black_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SlimeBlackBase
{
	// Constants
	string SOUND_DEATH = "monsters/sludge/bio.wav";
	string SOUND_STRUCK1 = "barnacle/bcl_bite3.wav";
	string SOUND_STRUCK2 = "barnacle/bcl_die3.wav";
	string SOUND_IDLE = "barnacle/bcl_alert2.wav";
	string SOUND_ATTACK1 = "barnacle/bcl_tongue1.wav";
	string SOUND_ATTACK2 = "barnacle/bcl_chew3.wav";
	string ATTACK_HITCHANCE = "75%";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string CHILD_SCRIPT = "monsters/slime_black_small";
	int CHILD_DIST = 20;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "walk";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NO_SPAWN_STUCK_CHECK = false;
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	string MOMMY_KILLER = "MOMMY_KILLER";
	float NPC_DMG_MULTI = 0.0f;
	float NPC_HP_MULTI = 0.0f;

	// unnamed block (first think)
	void SlimeBlackBase_FirstThink()
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

	// npc_spawn
	void SlimeBlackBase_OnNpcSpawn(string npc = "")
	{
		SetName("Black Pudding");
		SetHealth(40);
		SetWidth(40);
		SetHeight(44);
		SetModel("monsters/slime_large.mdl");
		SetModelBody(0, 12);
		SetHearingSensitivity(7);
		SetRace("wildanimal"); // greater version should be demon for ease of placement
		if (Truthy(GetVar("ME_NO_WANDER")))
			SetRoam(true);
		if (!Truthy(GetVar("ME_NO_WANDER")))
			SetRoam(false);
		NPC_GIVE_EXP = 20.0f;
		SetBoundingBox("none");

		CallEventDelayed(1.0f, "slime_cycle");

		SetBlood("green");

		SetSolid("none");

		SetDamageTaken("pierce", 0.25f);
		SetDamageTaken("slash", 0.75f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("stun", 0);
	}

	// bite1
	// called from model
	void SlimeBlackBase_OnBite1()
	{
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "acid");
	}

	// game_damaged_other
	string SlimeBlackBase_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		return result;
	}

	// game_struck
	void SlimeBlackBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// game_death
	void SlimeBlackBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnSpawnChildren();
	}

	// spawn_children
	void SlimeBlackBase_OnSpawnChildren()
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
	void SlimeBlackBase_OnSlimeCycle()
	{
		// //dbg temp Slimetarget $get(NPCATK_TARGET,name)
		if (NPCATK_TARGET == "unset" && RandomInt(1, 10) == 1)
			PlaySound(0, 10, SOUND_IDLE);

		if (NPCATK_TARGET != "unset" && !Truthy(GetVar("NO_COMBAT_REPOS")) && RangeTo(NPCATK_TARGET) < ATTACK_RANGE && RandomInt(1, 3) == 1)
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

	// game_dynamically_created
	// PARAM1=movedest PARAM2=motherkiller Param3=NPC_DMG_MULTI Param4=NPC_HP_MULTI
	void SlimeBlackBase_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MOMMY_KILLER = creatorValue2;
		OnNpcatkSuspendAi("0.5");
		SetMoveDest(creatorValue1, 1);
		CallEventDelayed(0.75f, "avenge_mommy");

		NPC_DMG_MULTI = Float(damage);
		NPC_HP_MULTI = Float(skill);

		if (NPC_DMG_MULTI > 0.0f)
			SetDamageMultiplier(Float(skill));
	}

	// avenge_mommy
	void SlimeBlackBase_OnAvengeMommy()
	{
		OnNpcatkSettarget(MOMMY_KILLER, "he_killed_mommy!");
	}

	// cycle_up
	void SlimeBlackBase_OnCycleUp(string reason = "")
	{
		if (Truthy(GetVar("ME_NO_WANDER")))
			SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SlimeBlackBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SlimeBlackBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SlimeBlackBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SlimeBlackBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SlimeBlackBase_OnNpcSpawn(npc);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		SlimeBlackBase_OnCycleUp(reason);
	}

	void OnBite1() { SlimeBlackBase_OnBite1(); } // bite1
	void OnSpawnChildren() { SlimeBlackBase_OnSpawnChildren(); } // spawn_children
	void OnSlimeCycle() { SlimeBlackBase_OnSlimeCycle(); } // slime_cycle
	void OnAvengeMommy() { SlimeBlackBase_OnAvengeMommy(); } // avenge_mommy

	// This file's events and timers by their .script names
	bool SlimeBlackBase_DispatchEvent(const string &in name, const array<string> &in params)
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
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/slime_black_base"]
shared class SlimeBlackBaseScript : BaseMonsterNewScript, SlimeBlackBase
{
	// Variables declared by included files, with the value they start with in this script
	SlimeBlackBaseScript()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime.mdl");
		Precache("monsters/slime_large.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBlackBase_FirstThink();
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
		return SlimeBlackBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
