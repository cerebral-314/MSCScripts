#pragma context server

// Converted from monsters/slime_ceriux1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SlimeCeriux1
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
	int MOVE_FAST = 200;
	int MOVE_NORMAL = 100;
	float ATTACK_RATE = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "Idle1";
	string ANIM_RUN = "Idle2";
	string ANIM_WALK = "move";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool DELAY_ATTACK = false;

	// unnamed block (first think)
	void SlimeCeriux1_FirstThink()
	{
		ANIM_IDLE = "Idle1";
		ANIM_RUN = "Idle2";
		ANIM_WALK = "move";
		ANIM_ATTACK = "Move";
		ANIM_DEATH = "die";
		MOVE_RANGE = "20";
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 120.0f;

		NO_SPAWN_STUCK_CHECK = true;
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
	}

	// npc_spawn
	void SlimeCeriux1_OnNpcSpawn(string npc = "")
	{
		SetName("Sewer Slime");
		SetHealth(20);
		SetWidth(20);
		SetBlood("green");
		SetHeight(20);
		SetHearingSensitivity(4);
		SetModel("monsters/slime_ceirux.mdl");
		SetRace("wildanimal");
		if (!ME_NO_WANDER)
			SetRoam(true);
		if (ME_NO_WANDER)
			SetRoam(false);
		SetSolid("none");
		NPC_GIVE_EXP = 10.0f;

		CallEventDelayed(2.0f, "slime_cycle");
	}

	// bite1
	// called from model
	void SlimeCeriux1_OnBite1()
	{
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "acid");
	}

	// game_damaged_other
	string SlimeCeriux1_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		return result;
	}

	// game_struck
	void SlimeCeriux1_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// slime_cycle
	void SlimeCeriux1_OnSlimeCycle()
	{
		// //dbg temp Slimetarget $get(NPCATK_TARGET,name)
		if (NPCATK_TARGET == "unset" && RandomInt(1, 5) == 1)
			PlaySound(0, 10, SOUND_IDLE);

		if (NPCATK_TARGET != "unset" && RandomInt(1, 3) == 1)
			OnChickenRun(1.0f);

		CallEventDelayed(2.0f, "slime_cycle");
	}

	// game_movingto_dest
	// movement hack
	// Hack in movement because the model anims are missing it
	void SlimeCeriux1_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		NPC_HACKED_MOVE_SPEED = MOVE_FAST;
		if (NPCATK_TARGET == "unset")
			NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement
	}

	// game_stopmoving
	void SlimeCeriux1_OnGameStopmoving()
	{
		SetAnimMoveSpeed(0); // Force Stop
	}

	// npcatk_attack
	// attack hack
	void SlimeCeriux1_OnNpcatkAttack()
	{
		if (DELAY_ATTACK)
			return;
		DELAY_ATTACK = true;
		PlayAnim("critical", "Attack1");
		OnBite1();
		CallEventDelayed(ATTACK_RATE, "attack_delay_reset");
	}

	// attack_delay_reset
	void SlimeCeriux1_OnAttackDelayReset()
	{
		DELAY_ATTACK = false;
	}

	// npc_death
	void SlimeCeriux1_OnNpcDeath()
	{
		OnNpcFadeAway(); // maybe not monster spawn friendly, but prevents loop
	}

	// cycle_up
	void SlimeCeriux1_OnCycleUp(string reason = "")
	{
		if (ME_NO_WANDER)
			SetRoam(true);
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
		result = AppendResult(result, SlimeCeriux1_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SlimeCeriux1_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SlimeCeriux1_OnNpcSpawn(npc);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		SlimeCeriux1_OnCycleUp(reason);
	}

	void OnBite1() { SlimeCeriux1_OnBite1(); } // bite1
	void OnSlimeCycle() { SlimeCeriux1_OnSlimeCycle(); } // slime_cycle
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { SlimeCeriux1_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnGameStopmoving() { SlimeCeriux1_OnGameStopmoving(); } // game_stopmoving
	void OnNpcatkAttack() { SlimeCeriux1_OnNpcatkAttack(); } // npcatk_attack
	void OnAttackDelayReset() { SlimeCeriux1_OnAttackDelayReset(); } // attack_delay_reset
	void OnNpcDeath() { SlimeCeriux1_OnNpcDeath(); } // npc_death
	void OnAttackRate() {} // ATTACK_RATE

	// This file's events and timers by their .script names
	bool SlimeCeriux1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_delay_reset") { OnAttackDelayReset(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "slime_cycle") { OnSlimeCycle(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/slime_ceriux1"]
shared class SlimeCeriux1Script : BaseMonsterNewScript, SlimeCeriux1
{
	// Variables every script that includes this file declares
	bool ME_NO_WANDER = false;

	// Variables declared by included files, with the value they start with in this script
	SlimeCeriux1Script()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "Idle1";
		ANIM_RUN = "Idle2";
		ANIM_WALK = "move";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime_ceirux.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeCeriux1_FirstThink();
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
		return SlimeCeriux1_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
