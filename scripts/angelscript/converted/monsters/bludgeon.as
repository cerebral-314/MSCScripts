#pragma context server

// Converted from monsters/bludgeon.script by msc_transpiler.
// Thothie - bludgeon, based on Boar (can charge) for MS 1.35 compatibility
// - has a very mean charge
// - sensitive to ice attacks
// - cowardly when hurt
// - Primary attack animation doesn't seem to work, does model need editing?
// - XP/GOLD set way low until attack (punch1) fixed in the model (needs event)
// - Since I can't get it to work due to model bjork, I adjusted so it jumps around like mad. Funny as hell it is.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Bludgeon
{
	// Constants
	string SOUND_STRUCK1 = "monsters/bludgeon/bludgeonattack.wav";
	string SOUND_STRUCK2 = "monsters/bludgeon/bludgeonattack.wav";
	string SOUND_STRUCK3 = "monsters/bludgeon/bludgeonattack.wav";
	string SOUND_PAIN = "monsters/bludgeon/bludgeonpain.wav";
	string SOUND_IDLE1 = "monsters/bludgeon/bludgeonidle.wav";
	string SOUND_IDLE2 = "monsters/bludgeon/bludgeonidle.wav";
	string SOUND_CHARGE = "monsters/boar/boarsight.wav";
	string SOUND_DEATH = "monsters/bludgeon/bludgeonpain.wav";
	float BASE_MOVESPEED = 2.0f;
	int CHARGE_MOVESPEED = 6;
	bool NO_ADJ_RANGES = true;
	string ATTACK_DAMAGE = "$rand(20,40)";
	string CHARGE_DAMAGE = "$rand(40,80)";
	int CHARGE_HITRANGE = 32;
	string ANIM_JUMP = "jump";
	string CL_SCRIPT = "monsters/boar_base_cl_charge";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "stand";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_JUMPING = false;
	string CHARGE_TARGET = "CHARGE_TARGET";
	bool IN_CHARGE = false;
	string CL_SCRIPT_ID = "CL_SCRIPT_ID";
	bool IN_JUMP = false;
	string PUSH_VEL = "PUSH_VEL";

	// unnamed block (first think)
	void Bludgeon_FirstThink()
	{
		IS_UNHOLY = true;

		// setvard CAN_FLEE		1
		// const FLEE_HEALTH		100
		// const FLEE_CHANCE		50%
		if (ToLowerCase(MapName()) != "islesofdread2")
		{
			NPC_GIVE_EXP = 120.0f; // intended 80
		}
		else
		{
			NPC_GIVE_EXP = 0.0f; // just here for show
		}

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10; // intended 10
		DROP_GOLD_MAX = 30; // intended 30

		MOVE_RANGE = "32";
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 120.0f;

		ANIM_IDLE = "stand";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "punch1";
		PrecacheFile(CL_SCRIPT);
	}

	// npc_spawn
	void Bludgeon_OnNpcSpawn(string npc = "")
	{
		SetName("Bludgeon Demon");
		SetModel("monsters/bludgeon.mdl");
		SetHealth(200);
		SetWidth(32);
		SetHeight(72);
		SetRace("demon");
		SetRoam(true);
		SetHearingSensitivity(8);
		SetDamageTaken("all", 0.5f); // dark armor.. damn my tabs don't match source :)
		SetDamageTaken("fire", 0); // immune to fire
		SetDamageTaken("cold", 5); // very vulnerable to cold
		SetDamageTaken("lightning", 2); // vulnerable to lightning
		SetDamageTaken("holy", 30); // ^_^

		SetMoveSpeed(BASE_MOVESPEED); // anim LX fux0red

		CallEventDelayed(5.0f, "idle_loop");

		CatchSpeech("debug_props", "debug");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE);
	}

	// debug_props
	void Bludgeon_OnDebugProps()
	{
		SetSayTextRange(2048);
		SayText("Range " + Text(ATTACK_RANGE));
	}

	// my_target_died
	void Bludgeon_OnMyTargetDied(string offender = "")
	{
		IS_JUMPING = false;
		SayText("Little-G rox0rz your box0rz!");
	}

	// npc_targetsighted
	void Bludgeon_OnNpcTargetsighted(string target = "")
	{
		if (!IS_JUMPING)
		{
			IS_JUMPING = true;
			CallEventDelayed(2.0f, "jump_checks");
		}

		if (!(RangeTo(target) > 256.0f))
			return;
		// charge
		if (IN_CHARGE)
			return;
		if (IN_JUMP)
			return;
		CHARGE_TARGET = HUNT_LASTTARGET;
		OnDoCharge();
	}

	// do_charge
	void Bludgeon_OnDoCharge()
	{
		IN_CHARGE = true;
		SetMoveAnim(ANIM_RUN);
		PlaySound(0, 10, SOUND_CHARGE);
		OnNpcatkSuspendAi();
		SetMoveDest(CHARGE_TARGET, 10);
		CallEventDelayed(1.0f, "charge_noise");
		ClientEvent("new", "all_in_sight", CL_SCRIPT, IndexOf(ENT_ME)); // Start Dust effect
		CL_SCRIPT_ID = LastClientScriptId();
		CallEventDelayed(15.0f, "charge_stop");

		OnChargeScan();
	}

	// charge_noise
	void Bludgeon_OnChargeNoise()
	{
		SetMoveSpeed(CHARGE_MOVESPEED);
		// dbg temp Charging $get(CHARGE_TARGET,name)
		PlaySound(0, 10, SOUND_CHARGE);
	}

	// charge_scan
	void Bludgeon_OnChargeScan()
	{
		if (!IN_CHARGE)
			return;
		CallEventDelayed(0.1f, "charge_scan");
		SetMoveDest(CHARGE_TARGET, 10);
		if (!(RangeTo(CHARGE_TARGET) <= ATTACK_RANGE))
			return;
		DoDamage(CHARGE_TARGET, ATTACK_HITRANGE, CHARGE_DAMAGE, "100%");
		CallEventDelayed(0.1f, "charge_stop");
	}

	// charge_stop
	void Bludgeon_OnChargeStop()
	{
		SetMoveSpeed(BASE_MOVESPEED);
		IN_CHARGE = false;
		ClientEvent("remove", "all", CL_SCRIPT);
		OnNpcatkResumeAi();
		if (IsAlive(CHARGE_TARGET))
			OnNpcatkTarget2(CHARGE_TARGET);
	}

	// jump_checks
	void Bludgeon_OnJumpChecks()
	{
		if (!IS_JUMPING)
			return;
		CallEventDelayed(Random(2, 6), "jump_checks");
		PlayAnim("critical", ANIM_JUMP);
	}

	// attack_1
	void Bludgeon_OnAttack12()
	{
		PlaySound(0, 10, SOUND_STRUCK1);
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, CHARGE_DAMAGE, "100%");
	}

	// jump_start
	// from model
	void Bludgeon_OnJumpStart()
	{
		IN_JUMP = true;
		CallEventDelayed(0.1f, "jump_boost");
		PlaySound(0, 10, SOUND_CHARGE);
	}

	// jump_boost
	void Bludgeon_OnJumpBoost()
	{
		// dbg temp jump boost
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 600)));
	}

	// jump_land
	// from model
	void Bludgeon_OnJumpLand()
	{
		PlaySound(0, 10, SOUND_IDLE1);
	}

	// jump_done
	// from model
	void Bludgeon_OnJumpDone(string npc = "")
	{
		IN_JUMP = false;
	}

	// game_struck
	void Bludgeon_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN);
	}

	// idle_loop
	void Bludgeon_OnIdleLoop()
	{
		CallEventDelayed(Random(5, 10), "idle_loop");
		if (CanSee("enemy"))
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2);
	}

	// game_damaged_other
	string Bludgeon_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		float r = RandomInt(50, 100);
		if (RandomInt(1, 2) == 1)
			r = -r;

		PUSH_VEL = Text(RelativeVelocity(Vector3(r, 50, 10)));

		if (IN_CHARGE)
		{
			OnChargeHit();
		}
		else
		{
			AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		}
		return result;
	}

	// charge_hit
	void Bludgeon_OnChargeHit()
	{
		// dbg temp charge hit $get(ent_laststruckbyme,name)
		// using stun and addvel instead of effect_push to make stun resist possible
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 200, 200)));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", 3, self);
	}

	// npc_death
	void Bludgeon_OnNpcDeath()
	{
		ClientEvent("remove", "all", CL_SCRIPT);
		if (RandomInt(1, 50) == 1)
			SayText("No, little-G, I have failed you!");
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
		result = AppendResult(result, Bludgeon_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bludgeon_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		Bludgeon_OnMyTargetDied(offender);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Bludgeon_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		Bludgeon_OnNpcTargetsighted(target);
	}

	void OnDebugProps() { Bludgeon_OnDebugProps(); } // debug_props
	void OnDoCharge() { Bludgeon_OnDoCharge(); } // do_charge
	void OnChargeNoise() { Bludgeon_OnChargeNoise(); } // charge_noise
	void OnChargeScan() { Bludgeon_OnChargeScan(); } // charge_scan
	void OnChargeStop() { Bludgeon_OnChargeStop(); } // charge_stop
	void OnJumpChecks() { Bludgeon_OnJumpChecks(); } // jump_checks
	void OnAttack12() { Bludgeon_OnAttack12(); } // attack_1
	void OnJumpStart() { Bludgeon_OnJumpStart(); } // jump_start
	void OnJumpBoost() { Bludgeon_OnJumpBoost(); } // jump_boost
	void OnJumpLand() { Bludgeon_OnJumpLand(); } // jump_land
	void OnJumpDone(string npc = "") { Bludgeon_OnJumpDone(npc); } // jump_done
	void OnIdleLoop() { Bludgeon_OnIdleLoop(); } // idle_loop
	void OnChargeHit() { Bludgeon_OnChargeHit(); } // charge_hit
	void OnNpcDeath() { Bludgeon_OnNpcDeath(); } // npc_death

	// This file's events and timers by their .script names
	bool Bludgeon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "charge_hit") { OnChargeHit(); return true; }
		if (name == "charge_noise") { OnChargeNoise(); return true; }
		if (name == "charge_scan") { OnChargeScan(); return true; }
		if (name == "charge_stop") { OnChargeStop(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "do_charge") { OnDoCharge(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_loop") { OnIdleLoop(); return true; }
		if (name == "jump_boost") { OnJumpBoost(); return true; }
		if (name == "jump_checks") { OnJumpChecks(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "jump_land") { OnJumpLand(); return true; }
		if (name == "jump_start") { OnJumpStart(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bludgeon"]
shared class BludgeonScript : BaseMonsterScript, Bludgeon
{
	// Variables declared by included files, with the value they start with in this script
	BludgeonScript()
	{
		SOUND_DEATH = "monsters/bludgeon/bludgeonpain.wav";
		BASE_MOVESPEED = 2.0f;
		ANIM_IDLE = "stand";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bludgeon.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bludgeon_FirstThink();
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
		return Bludgeon_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
