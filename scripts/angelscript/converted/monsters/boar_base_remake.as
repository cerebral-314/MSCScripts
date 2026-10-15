#pragma context server

// Converted from monsters/boar_base_remake.script by msc_transpiler.
// For updated boars, not compatible with old base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BoarBaseRemake
{
	// Constants
	string ANIM_ATTACK1_NORM = "gore_forward";
	string ANIM_ATTACK1_LARGE = "gore_forward2";
	string ANIM_ATTACK_GORE_RIGHT = "gore_right";
	string ANIM_ATTACK_GORE_LEFT = "gore_left";
	string ANIM_STOMP = "stompsnort";
	string ANIM_CHARGE = "charge";
	string ANIM_BACKUP = "back_off";
	string ATTACK_HITCHANCE = "50%";
	int BOAR_WIDTH1 = 50;
	int BOAR_HEIGHT1 = 50;
	int BOAR_WIDTH2 = 75;
	int BOAR_HEIGHT2 = 75;
	int BOAR_WIDTH3 = 96;
	int BOAR_HEIGHT3 = 96;
	Vector3 BOAR_RIGHT_PUSH = Vector3();
	Vector3 BOAR_LEFT_PUSH = Vector3();
	int BOAR_SIZE = 1;
	int BOAR_SKIN = 0;
	string BOAR_MODEL = "monsters/boar1.mdl";
	float FREQ_CHARGE = 20.0f;
	float FREQ_BACKUP = 10.0f;
	string CL_CHARGE_SCRIPT = "monsters/boar_base_cl_charge";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/boar/boarpain.wav";
	string SOUND_IDLE1 = "monsters/boar/boaridle.wav";
	string SOUND_IDLE2 = "monsters/boar/boarsight2.wav";
	string SOUND_CHARGE = "monsters/boar/boarsight.wav";
	string SOUND_DEATH = "monsters/boar/boardeath.wav";
	string SOUND_SWIPE1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPE2 = "zombie/claw_miss2.wav";
	string SOUND_GORE = "zombie/claw_strike3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ANIM_IDLE2 = "ANIM_IDLE2";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string ANIM_ATTACK_DEF = "ANIM_ATTACK_DEF";
	int BOAR_WIDTH = 0;
	int BOAR_HEIGHT = 0;
	float NEXT_CHARGE = 0.0f;
	bool BOAR_CHARGING = false;
	float AS_ATTACKING = 0.0f;
	float NEXT_BACKUP = 0.0f;
	string BOAR_CHARGE_TARGET = "BOAR_CHARGE_TARGET";
	int BOAR_CHARGE_FX_IDX = 0;
	string PUSH_VEL = "PUSH_VEL";
	float DMG_ATTACK = 0.0f;

	// unnamed block (first think)
	void BoarBaseRemake_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_IDLE2 = "idle2";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "gore_forward";
		ANIM_DEATH = "die1";
	}

	// game_precache
	void BoarBaseRemake_OnGamePrecache()
	{
	}

	// game_postspawn
	void BoarBaseRemake_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		ATTACK_RANGE = BOAR_WIDTH * 1.25f;
		ATTACK_HITRANGE = BOAR_WIDTH * 1.5f;
		ATTACK_MOVERANGE = BOAR_WIDTH * 1.2f;

		if (BOAR_SIZE > 1)
		{
			ANIM_ATTACK = ANIM_ATTACK1_LARGE;
			ANIM_ATTACK_DEF = ANIM_ATTACK1_LARGE;
		}
		else
		{
			ANIM_ATTACK = ANIM_ATTACK1_NORM;
			ANIM_ATTACK_DEF = ANIM_ATTACK1_NORM;
		}
	}

	// npc_spawn
	void BoarBaseRemake_OnNpcSpawn(string npc = "")
	{
		SetModel(BOAR_MODEL);
		SetProp(ENT_ME, "skin", BOAR_SKIN);

		if (BOAR_SIZE == 1)
		{
			BOAR_WIDTH = BOAR_WIDTH1;
			BOAR_HEIGHT = BOAR_HEIGHT1;
		}
		if (BOAR_SIZE == 2)
		{
			BOAR_WIDTH = BOAR_WIDTH2;
			BOAR_HEIGHT = BOAR_HEIGHT2;
		}
		if (BOAR_SIZE == 3)
		{
			BOAR_WIDTH = BOAR_WIDTH3;
			BOAR_HEIGHT = BOAR_HEIGHT3;
		}

		SetWidth(BOAR_WIDTH);
		SetHeight(BOAR_HEIGHT);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		// no affect here
		// setvard BOAR_LENGTH BOAR_WIDTH
		// multiply BOAR_LENGTH 10.0
		// setsolid box
		// local NEG_WIDTH $neg(BOAR_WIDTH)
		// setbbox $vec(NEG_WIDTH,NEG_WIDTH,0) $vec(BOAR_WIDTH,BOAR_LENGTH,BOAR_HEIGHT)
		if (ToLowerCase(MapName()) == "nightmare_thornlands")
			SetMonsterClip(false);

		SetRace("wildanimal");

		SetRoam(true);

		OnBoarSpawn();
	}

	// npc_targetsighted
	// Works here, but not helping
	// { npc_post_spawn
	// width BOAR_WIDTH
	// height BOAR_HEIGHT
	// local NEG_WIDTH $neg(BOAR_WIDTH)
	// setbbox $vec(NEG_WIDTH,NEG_WIDTH,0) $vec(BOAR_WIDTH,BOAR_WIDTH,BOAR_HEIGHT)
	// }
	void BoarBaseRemake_OnNpcTargetsighted(string target = "")
	{
		if (BOAR_CHARGING)
			return;
		if (!(GameTime() > NEXT_CHARGE))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		if (RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE)
		{
			NEXT_CHARGE = GameTime() + FREQ_CHARGE;
			BOAR_CHARGING = true;
			OnBoarChargeSequence();
		}
		else if (GameTime() > NEXT_BACKUP)
		{
			AS_ATTACKING = GameTime() + 6.0f;
			NEXT_BACKUP = GameTime() + FREQ_BACKUP;
			SetRoam(false);
			PlayAnim("critical", ANIM_BACKUP);
			OnNpcatkSuspendMovement(ANIM_BACKUP, "1.0");
			DebugPrint("backingup");
		}
	}

	// npcatk_resume_movement
	void BoarBaseRemake_OnNpcatkResumeMovement()
	{
		SetRoam(true);
	}

	// boar_charge_sequence
	void BoarBaseRemake_OnBoarChargeSequence()
	{
		BOAR_CHARGE_TARGET = NPCATK_TARGET;
		// callevent npcatk_suspend_ai
		// setvard AS_ATTACKING game.time
		// add AS_ATTACKING 6.0
		PlaySound(1, 10, SOUND_CHARGE);
		SetRoam(false);
		PlayAnim("critical", ANIM_STOMP);
		SetMoveAnim(ANIM_CHARGE);
		SetMoveSpeed(2);
		CallEventDelayed(1.0f, "boar_charge_sequence2");
		CallEventDelayed(5.0f, "boar_charge_stop");
	}

	// boar_charge_sequence2
	void BoarBaseRemake_OnBoarChargeSequence2()
	{
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", CL_CHARGE_SCRIPT, IndexOf(ENT_ME), BOAR_SIZE);
		BOAR_CHARGE_FX_IDX = Int(LastClientScriptId());

		if (BOAR_SIZE == 3)
		{
			DebugPrint("sound_loop_start");
			ServerPlaySound(2, 10, "monsters/boar/hoofbeats_loop.wav");
		}
		OnBoarChargeLoop();
	}

	// boar_charge_loop
	void BoarBaseRemake_OnBoarChargeLoop()
	{
		if (!BOAR_CHARGING)
			return;
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.1f, "boar_charge_loop");
		SetMoveDest(BOAR_CHARGE_TARGET, ATTACK_MOVERANGE);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(BOAR_CHARGE_TARGET) < ATTACK_RANGE)
		{
			DoDamage(BOAR_CHARGE_TARGET, ATTACK_HITRANGE, DMG_CHARGE, "100%", "blunt");
			AddVelocity(BOAR_CHARGE_TARGET, RelativeVelocity(Vector3(0, 200, 200)));
			ApplyEffect(BOAR_CHARGE_TARGET, "effects/debuff_stun", 3, self);
			OnBoarChargeStop();
		}
	}

	// boar_charge_stop
	void BoarBaseRemake_OnBoarChargeStop()
	{
		if (BOAR_SIZE == 3)
		{
			DebugPrint("sound_loop_stop");
			ServerPlaySound(2, 0, "monsters/boar/hoofbeats_loop.wav");
		}

		if (BOAR_CHARGE_FX_IDX > 0)
			ClientEvent("update", "all", BOAR_CHARGE_FX_IDX, "remove_fx");
		BOAR_CHARGE_FX_IDX = 0;
		SetMoveSpeed(1);
		SetRoam(true);
		BOAR_CHARGING = false;
		SetMoveAnim(ANIM_RUN);
		NEXT_CHARGE = GameTime() + FREQ_CHARGE;
	}

	// game_death
	void BoarBaseRemake_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (BOAR_CHARGING && BOAR_SIZE == 3)
			ServerPlaySound(2, 0, "monsters/boar/hoofbeats_loop.wav");
		BOAR_CHARGING = false;
		if (BOAR_CHARGE_FX_IDX > 0)
			ClientEvent("update", "all", BOAR_CHARGE_FX_IDX, "remove_fx");
	}

	// npc_struck
	// Hit by someone
	void BoarBaseRemake_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(4, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN, SOUND_PAIN, SOUND_PAIN);
	}

	// npc_selectattack
	void BoarBaseRemake_OnNpcSelectattack()
	{
		int nextAttack = RandomInt(0, 2);
		if (nextAttack == 0)
			ANIM_ATTACK = ANIM_ATTACK_DEF;
		if (nextAttack == 1)
			ANIM_ATTACK = ANIM_ATTACK_GORE_RIGHT;
		if (nextAttack == 2)
			ANIM_ATTACK = ANIM_ATTACK_GORE_LEFT;
	}

	// gore_left
	void BoarBaseRemake_OnGoreLeft()
	{
		PUSH_VEL = Text(BOAR_LEFT_PUSH);
		DMG_ATTACK = DMG_GORE_LEFT;
		if (BOAR_SIZE == 3)
			PlayRandomSound(0, 5, SOUND_SWIPE1, SOUND_SWIPE2);
		OnGoreDamage();
	}

	// gore_right
	void BoarBaseRemake_OnGoreRight()
	{
		PUSH_VEL = Text(BOAR_RIGHT_PUSH);
		DMG_ATTACK = DMG_GORE_RIGHT;
		if (BOAR_SIZE == 3)
			PlayRandomSound(0, 5, SOUND_SWIPE1, SOUND_SWIPE2);
		OnGoreDamage();
	}

	// gore_forward
	void BoarBaseRemake_OnGoreForward()
	{
		DMG_ATTACK = DMG_GORE_FORWARD;
		OnGoreDamage();
		float targRange = RangeTo(NPCATK_TARGET);
		float maxPushRange = ATTACK_HITRANGE;
		if (!(targRange < maxPushRange))
			return;
		float rangePercent = Divide(targRange, maxPushRange);
		float pushStr = Ratio(rangePercent, 400, 110);
		PUSH_VEL = Text(RelativeVelocity(Vector3(0, pushStr, 110)));
		if (BOAR_SIZE == 3)
			PlayRandomSound(0, 8, SOUND_GORE);
	}

	// gore_damage
	void BoarBaseRemake_OnGoreDamage()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_ATTACK, ATTACK_HITCHANCE);
		if (PUSH_VEL == "PUSH_VEL")
			return;
		AddVelocity(NPCATK_TARGET, Vec(PUSH_VEL));
	}

	// back_off
	void BoarBaseRemake_OnBackOff()
	{
		DebugPrint("animevent back_off");
		if (I_R_FROZEN)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -400, 110)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { BoarBaseRemake_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BoarBaseRemake_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		BoarBaseRemake_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBaseRemake_OnNpcSpawn(npc);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BoarBaseRemake_OnNpcSelectattack();
	}

	// npcatk_resume_movement
	void OnNpcatkResumeMovement()
	{
		BaseMonsterShared_OnNpcatkResumeMovement(); // monsters/base_monster_shared
		BoarBaseRemake_OnNpcatkResumeMovement();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BoarBaseRemake_OnNpcTargetsighted(target);
	}

	void OnBoarChargeSequence() { BoarBaseRemake_OnBoarChargeSequence(); } // boar_charge_sequence
	void OnBoarChargeSequence2() { BoarBaseRemake_OnBoarChargeSequence2(); } // boar_charge_sequence2
	void OnBoarChargeLoop() { BoarBaseRemake_OnBoarChargeLoop(); } // boar_charge_loop
	void OnBoarChargeStop() { BoarBaseRemake_OnBoarChargeStop(); } // boar_charge_stop
	void OnNpcStruck(float damage = 0.0f) { BoarBaseRemake_OnNpcStruck(damage); } // npc_struck
	void OnGoreLeft() { BoarBaseRemake_OnGoreLeft(); } // gore_left
	void OnGoreRight() { BoarBaseRemake_OnGoreRight(); } // gore_right
	void OnGoreForward() { BoarBaseRemake_OnGoreForward(); } // gore_forward
	void OnGoreDamage() { BoarBaseRemake_OnGoreDamage(); } // gore_damage
	void OnBackOff() { BoarBaseRemake_OnBackOff(); } // back_off
	void OnBoarSpawn() {} // boar_spawn

	// This file's events and timers by their .script names
	bool BoarBaseRemake_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "back_off") { OnBackOff(); return true; }
		if (name == "boar_charge_loop") { OnBoarChargeLoop(); return true; }
		if (name == "boar_charge_sequence") { OnBoarChargeSequence(); return true; }
		if (name == "boar_charge_sequence2") { OnBoarChargeSequence2(); return true; }
		if (name == "boar_charge_stop") { OnBoarChargeStop(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "gore_damage") { OnGoreDamage(); return true; }
		if (name == "gore_forward") { OnGoreForward(); return true; }
		if (name == "gore_left") { OnGoreLeft(); return true; }
		if (name == "gore_right") { OnGoreRight(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_resume_movement") { OnNpcatkResumeMovement(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/boar_base_remake"]
shared class BoarBaseRemakeScript : BaseMonsterNewScript, BoarBaseRemake
{
	// Variables every script that includes this file declares
	int DMG_CHARGE = 0;
	float DMG_GORE_FORWARD = 0.0f;
	float DMG_GORE_LEFT = 0.0f;
	float DMG_GORE_RIGHT = 0.0f;
	string FLEE_CHANCE = "FLEE_CHANCE";

	// Variables declared by included files, with the value they start with in this script
	BoarBaseRemakeScript()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/boar/boardeath.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar1.mdl");
		Precache("monsters/boar/hoofbeats_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BoarBaseRemake_FirstThink();
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
		return BoarBaseRemake_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
