#pragma context server

// Converted from monsters/firegiantghoul.script by msc_transpiler.
// Undead Fire Giant, by Gurluas
// - Thothie, adapted from one of his old scripts
// Fire Giant
// Hunt and See enemy are handled in base_monster

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Firegiantghoul
{
	// Constants
	int FIN_EXP = 150;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "zombie/zo_pain1.wav";
	string SOUND_FIREBALL = "magic/fireball_strike.wav";
	string ANIM_FIREBALL = "turnright";
	string ATTACK_DAMAGE = "40";
	string ATTACK_ACCURACY = "45%";
	int FIREBALL_DAMAGE = 50;
	int FIREBALL_RANGE = 1024;
	float FIREBALL_FREQ = 5.0f;
	float THROW_FREQ = 5.0f;
	float THROW_CHANCE = 12.0f;
	int AIM_RATIO = 50;
	int MY_MAX_HP = 1400;
	string MY_NAME = "Reanimated Bones of a Fire Giant";
	bool NO_ROAM = false;
	bool AM_TURRET = false;
	bool I_GLOW = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	float NPC_GIVE_EXP = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string ANIM_RUN = "walk";
	string ANIM_WALK = "walk";
	bool I_AM_TURNABLE = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float THROW_DELAY = 0.0f;
	int HIT_SOMEONE = 5;
	float AS_ATTACKING = 0.0f;
	bool FIREBALL_DELAY = false;
	bool I_R_GLOWING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";

	// unnamed block (first think)
	void Firegiantghoul_FirstThink()
	{
		NPC_GIVE_EXP = FIN_EXP;
		ANIM_IDLE = "idle1";
		MOVE_RANGE = "32"; // Stop approaching if already this close
		ATTACK_RANGE = 90.0f; // Start attacking at this range
		ATTACK_HITRANGE = 187.0f; // Actual attack range

		CAN_FLINCH = "1";
	}

	// npc_spawn
	void Firegiantghoul_OnNpcSpawn(string npc = "")
	{
		I_AM_TURNABLE = false;

		ANIM_ATTACK = "attack1";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";

		SetHealth(MY_MAX_HP);
		SetWidth(64);
		SetHeight(120);
		SetRace("undead");
		SetName(MY_NAME);
		SetGold(RandomInt(25, 50));
		SetHearingSensitivity(10);
		if (!NO_ROAM)
			SetRoam(true);
		if (NO_ROAM)
			SetRoam(false);
		SetModel("monsters/skeleton3.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		if (!AM_TURRET)
			SetMoveAnim(ANIM_WALK);
		if (AM_TURRET)
		{
			SetMoveAnim(ANIM_IDLE);
			ANIM_WALK = ANIM_IDLE;
			ANIM_RUN = ANIM_IDLE;
			NO_STUCK_CHECKS = "1";
		}
		PlayAnim("once", ANIM_IDLE); // stop shakes

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 2);
		SetDamageTaken("holy", 1.5f);
	}

	// throw_delay_reset
	void Firegiantghoul_OnThrowDelayReset()
	{
		THROW_DELAY = 0.0f;
	}

	// attack_1
	void Firegiantghoul_OnAttack12()
	{
		HIT_SOMEONE = 5;

		bool didPush = false;

		ANIM_ATTACK = "attack1";
		if (int(THROW_DELAY) == 0 && RandomInt(1, 100) <= THROW_CHANCE)
		{
			THROW_DELAY = 1.0f;
			CallEventDelayed(THROW_FREQ, "throw_delay_reset");
			PlayAnim("critical", "bigflinch");
			PlaySound(0, 10, "garg/gar_attack3.wav");
			if (RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE)
			{
				ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
				didPush = true;
			}
		}

		if (didPush)
			return;

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// throw_fireball
	void Firegiantghoul_OnThrowFireball()
	{
		AS_ATTACKING = GameTime();

		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		PlayAnim("critical", "turnright");

		SetVolume(10);
		PlayRandomSound(2, 10, SOUND_FIREBALL);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		if (RangeTo(ENT_LASTSEEN) <= 400.0f)
			TossProjectile("proj_fire_ball", "view", "none", 500, FIREBALL_DAMAGE, 1, "none");

		if (RangeTo(ENT_LASTSEEN) > 400.0f)
		{
			TossProjectile("proj_fire_ball", "view", @EntityOf(ENT_LASTSEEN), 500, FIREBALL_DAMAGE, 1, "none");
			CallExternal(ENT_LASTPROJECTILE, "lighten", 5, 0.1f);
		}

		ANIM_ATTACK = "attack1";
	}

	// npc_targetsighted
	// PARAM1 = target whenever valid target spotted (called every cycle)
	void Firegiantghoul_OnNpcTargetsighted(string target = "")
	{
		// //dbg temp sighted $get(PARAM1,name)
		if (I_R_FROZEN)
			return;

		if (!(RangeTo(target) > ATTACK_RANGE))
			return;
		if (FIREBALL_DELAY)
			return;
		FIREBALL_DELAY = true;
		CallEventDelayed(FIREBALL_FREQ, "reset_fireball_delay");
		SetMoveDest(target, 9999);
		CallEventDelayed(0.1f, "throw_fireball");
	}

	// cycle_up
	void Firegiantghoul_OnCycleUp(string reason = "")
	{
		if (NO_ROAM && !AM_TURRET)
			SetRoam(true);

		if (I_GLOW && !I_R_GLOWING)
		{
			I_R_GLOWING = true;
			// dbg temp settting glow
			ClientEvent("persist", "all", "monsters/firegiantghoul", IndexOf(ENT_ME));
			MY_LIGHT_SCRIPT = LastClientScriptId();
		}
	}

	// reset_fireball_delay
	void Firegiantghoul_OnResetFireballDelay()
	{
		FIREBALL_DELAY = false;
	}

	// npc_struck
	// I r hit
	void Firegiantghoul_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// game_death
	void Firegiantghoul_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
	}

	// chest_sfor_fireloot1
	void Firegiantghoul_OnChestSforFireloot1()
	{
		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "100%";
		CONTAINER_SCRIPT = "chests/sfor_fire1";
	}

	// chest_sfor_fireloot2
	void Firegiantghoul_OnChestSforFireloot2()
	{
		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "100%";
		CONTAINER_SCRIPT = "chests/sfor_fire2";
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
		Firegiantghoul_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		Firegiantghoul_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Firegiantghoul_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		Firegiantghoul_OnNpcTargetsighted(target);
	}

	void OnThrowDelayReset() { Firegiantghoul_OnThrowDelayReset(); } // throw_delay_reset
	void OnAttack12() { Firegiantghoul_OnAttack12(); } // attack_1
	void OnThrowFireball() { Firegiantghoul_OnThrowFireball(); } // throw_fireball
	void OnResetFireballDelay() { Firegiantghoul_OnResetFireballDelay(); } // reset_fireball_delay
	void OnNpcStruck(float damage = 0.0f) { Firegiantghoul_OnNpcStruck(damage); } // npc_struck
	void OnChestSforFireloot1() { Firegiantghoul_OnChestSforFireloot1(); } // chest_sfor_fireloot1
	void OnChestSforFireloot2() { Firegiantghoul_OnChestSforFireloot2(); } // chest_sfor_fireloot2
	void OnFireballFreq() {} // FIREBALL_FREQ
	void OnThrowFreq() {} // THROW_FREQ

	// This file's events and timers by their .script names
	bool Firegiantghoul_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "chest_sfor_fireloot1") { OnChestSforFireloot1(); return true; }
		if (name == "chest_sfor_fireloot2") { OnChestSforFireloot2(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reset_fireball_delay") { OnResetFireballDelay(); return true; }
		if (name == "throw_delay_reset") { OnThrowDelayReset(); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/firegiantghoul"]
shared class FiregiantghoulScript : BaseMonsterScript, Firegiantghoul
{
	// Variables declared by included files, with the value they start with in this script
	FiregiantghoulScript()
	{
		SOUND_DEATH = "zombie/zo_pain1.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton3.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Firegiantghoul_FirstThink();
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
		return Firegiantghoul_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
