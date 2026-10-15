#pragma context server

// Converted from monsters/troll.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - misc minor improvements sound + animation
// Standard Troll

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersTroll
{
	// Constants
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK = "monsters/troll/trollattack.wav";
	string SOUND_DEATH = "monsters/troll/trolldeath.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle0";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	float NPC_GIVE_EXP = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool IS_GUARDIAN = false;
	bool IMMUNE_VAMPIRE = false;
	string PUSH_VEL = "PUSH_VEL";
	float AS_ATTACKING = 0.0f;
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void MonstersTroll_FirstThink()
	{
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 35;
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fall";
		ANIM_ATTACK = "double_punch"; // this varies, needs to be a var
		ATTACK_RANGE = 135.0f;
		ATTACK_HITRANGE = 200.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "100";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		NPC_GIVE_EXP = 100.0f;
		NPC_MUST_SEE_TARGET = "0";

		// setvard STUCK_CHECK_FREQUENCY 1.2 //I move pretty damn fast, so stuck check more often
		PrecacheFile("monsters/base_monster");
		PrecacheFile("monsters/base_npc_attack");
		PrecacheFile("monsters/base_npc");
	}

	// npc_spawn
	void MonstersTroll_OnNpcSpawn(string npc = "")
	{
		SetHealth(300);
		// ov 100
		SetWidth(100);
		SetHeight(125);
		SetName("Troll");
		if (MapName() == "ww3d")
			IS_GUARDIAN = true;
		if (Truthy(GetVar("G_SHAD_PRESENT")))
			OnBoZombieMode();
		if (IS_GUARDIAN)
		{
			SetName("Temple Guardian");
			SetRace("demon");
			SetProp(ENT_ME, "skin", 1);
			IMMUNE_VAMPIRE = true;
			SetBlood("none");
			CallEventDelayed(0.1f, "guard_attribs");
		}
		if (!IS_GUARDIAN)
			SetRace("orc");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("lightning", 1.1f);
		SetModel("monsters/troll.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);

		CallEventDelayed(10.0f, "random_idle");

		OnTrollSpawn();
	}

	// guard_attribs
	void MonstersTroll_OnGuardAttribs()
	{
		SetDamageTaken("holy", 2);
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// attack_1
	// called by model double_punch @ frame 13 and 26
	void MonstersTroll_OnAttack12()
	{
		PlaySound(2, 10, SOUND_ATTACK);
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(ENTITY_ENEMY, "direct", Text(Random(20, 30)), "75%", "blunt");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = "hit_down";
	}

	// attack_2
	// called by model hit_down @ frame 20
	void MonstersTroll_OnAttack22()
	{
		PlaySound(2, 10, SOUND_ATTACK);
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(ENTITY_ENEMY, "direct", Text(Random(35, 45)), "75%", "blunt");
		ANIM_ATTACK = "double_punch";
		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = "double_punch";
	}

	// npc_struck
	void MonstersTroll_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlaySound(2, 5, SOUND_PAIN);
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void MonstersTroll_OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void MonstersTroll_OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// game_hearsound
	void MonstersTroll_OnGameHearsound()
	{
		SetVolume(10);
		PlaySound(2, 10, SOUND_IDLE);
	}

	// random_idle
	// idle anims
	void MonstersTroll_OnRandomIdle()
	{
		// //dbg CanHear CAN_HEAR
		CallEventDelayed(10.0f, "random_idle");
		if (IS_HUNTING)
			return;
		if (CanSee("enemy"))
			return;
		if (IS_FLEEING)
			return;
		int animSelect = RandomInt(0, 3);
		if (animSelect == 0)
			ANIM_IDLE = "idle0";
		if (animSelect == 1)
			ANIM_IDLE = "idle1";
		if (animSelect == 2)
			ANIM_IDLE = "idle2";
		if (animSelect == 3)
			ANIM_IDLE = "idle3";
		PlayAnim("once", ANIM_IDLE);
	}

	// warcry
	// called by model idle2 @ frame 28
	void MonstersTroll_OnWarcry()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// npcatk_targetvalidate
	void MonstersTroll_OnNpcatkTargetvalidate(string target = "")
	{
		if (DID_WARCRY)
			return;
		if (!IsPlayer(ENT_LASTSEEN))
			return;

		AS_ATTACKING = GameTime();
		PlayAnim("critical", "idle2");
		DID_WARCRY = true;
	}

	// my_target_died
	void MonstersTroll_OnMyTargetDied(string offender = "")
	{
		DID_WARCRY = false;
		if (CanSee("player"))
			return;
		PlayAnim("critical", "idle2");
	}

	// game_damaged_other
	string MonstersTroll_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (PUSH_VEL == "PUSH_VEL")
			return result;

		AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		return result;
	}

	// bo_zombie_mode
	void MonstersTroll_OnBoZombieMode()
	{
		SetName("Petrified Troll");
		SetRace("demon");
		SetProp(ENT_ME, "skin", 1);
		IMMUNE_VAMPIRE = true;
		SetBlood("none");
		CallEventDelayed(0.1f, "guard_attribs");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, MonstersTroll_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersTroll_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		MonstersTroll_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		MonstersTroll_OnMyTargetDied(offender);
	}

	void OnGuardAttribs() { MonstersTroll_OnGuardAttribs(); } // guard_attribs
	void OnAttack12() { MonstersTroll_OnAttack12(); } // attack_1
	void OnAttack22() { MonstersTroll_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { MonstersTroll_OnNpcStruck(damage); } // npc_struck
	void OnStomp1() { MonstersTroll_OnStomp1(); } // stomp_1
	void OnStomp2() { MonstersTroll_OnStomp2(); } // stomp_2
	void OnGameHearsound() { MonstersTroll_OnGameHearsound(); } // game_hearsound
	void OnRandomIdle() { MonstersTroll_OnRandomIdle(); } // random_idle
	void OnWarcry() { MonstersTroll_OnWarcry(); } // warcry
	void OnBoZombieMode() { MonstersTroll_OnBoZombieMode(); } // bo_zombie_mode
	void OnTrollSpawn() {} // troll_spawn

	// This file's events and timers by their .script names
	bool MonstersTroll_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_hearsound") { OnGameHearsound(); return true; }
		if (name == "guard_attribs") { OnGuardAttribs(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "random_idle") { OnRandomIdle(); return true; }
		if (name == "stomp_1") { OnStomp1(); return true; }
		if (name == "stomp_2") { OnStomp2(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/troll"]
shared class MonstersTrollScript : BaseMonsterNewScript, MonstersTroll
{
	// Variables declared by included files, with the value they start with in this script
	MonstersTrollScript()
	{
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/troll.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersTroll_FirstThink();
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
		return MonstersTroll_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
