#pragma context server

// Converted from monsters/troll_lobber.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Troll Lobber by Thothie - as standard troll, but primary attack is rock throw

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TrollLobber
{
	// Constants
	int TROLL_EXP = 150;
	string TROLL_NAME = "Troll";
	string PROJ_SCRIPT = "proj_troll_rock";
	string TROLL_MODEL = "monsters/troll.mdl";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK = "monsters/troll/trollattack.wav";
	string SOUND_DEATH = "monsters/troll/trolldeath.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle2.wav";
	string ANIM_PUNCH = "hit_down";
	string ANIM_DBLPUNCH = "double_punch";
	string ANIM_THROW = "throw_rock";
	int ROCK_RANGE = 800;
	int SWING_RANGE = 130;
	int MELE_RANGE = 128;
	int MELE_HITRANGE = 164;
	int AIM_RATIO = 25;
	int ATTACK_SPEED = 500;
	string ROCK_DAMAGE = "$rand(200,300)";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle0";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string FLINCH_CHANCE = "33";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MELEE_RANGE = "MELEE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	float NPC_GIVE_EXP = 0.0f;
	float COMBAT_REPOS = 0.0f;
	float AS_ATTACKING = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string PUSH_VEL = "PUSH_VEL";
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void TrollLobber_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 40;
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fall";
		ANIM_ATTACK = "throw_rock"; // this varies, needs to be a var
		MELEE_RANGE = "100";
		ATTACK_RANGE = ROCK_RANGE;
		ATTACK_HITRANGE = 300.0f;
		MOVE_RANGE = "400";
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "33";
		FLINCH_ANIM = "flinch2";
		FLINCH_DELAY = "2.0";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";

		// setvard STUCK_CHECK_FREQUENCY 1.2 //I move pretty damn fast, so stuck check more often
		PrecacheFile("monsters/base_monster");
		PrecacheFile("monsters/base_npc_attack");
		PrecacheFile("monsters/base_npc");
		PrecacheFile("items/proj_troll_rock");
	}

	// npc_spawn
	void TrollLobber_OnNpcSpawn(string npc = "")
	{
		SetHealth(600);
		// ov 100
		SetWidth(100);
		SetHeight(125);
		SetRace("orc");
		SetName(TROLL_NAME);
		SetRoam(true);
		NPC_GIVE_EXP = TROLL_EXP;
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("lightning", 1.1f);
		SetModel(TROLL_MODEL);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(10);

		COMBAT_REPOS = 0.0f;

		CallEventDelayed(10.0f, "random_idle");

		CatchSpeech("debug_props", "debug");

		OnTrollSpawn();
	}

	// debug_props
	void TrollLobber_OnDebugProps()
	{
		SetSayTextRange(1024);
		SayText("I is hunting ( " + Text(IS_HUNTING) + " ) my target ( " + NameOf(HUNT_LASTTARGET));
	}

	// npc_targetsighted
	void TrollLobber_OnNpcTargetsighted(string target = "")
	{
		// //dbg temp validating $get(PARAM1,name)
		if (!CanSee(HUNT_LASTTARGET))
			return;
		ANIM_ATTACK = ANIM_DBLPUNCH;
		ATTACK_RANGE = SWING_RANGE;
		if (RangeTo(HUNT_LASTTARGET) <= ROCK_RANGE && RangeTo(HUNT_LASTTARGET) > SWING_RANGE)
		{
			AS_ATTACKING = GameTime() + 10.0f;
			PlayAnim("once", ANIM_THROW);
			MOVE_RANGE = ROCK_RANGE;
			ATTACK_MOVERANGE = ROCK_RANGE;
		}
		if (RangeTo(HUNT_LASTTARGET) <= SWING_RANGE)
		{
			ANIM_ATTACK = ANIM_DBLPUNCH;
			MOVE_RANGE = MELEE_RANGE;
			ATTACK_MOVERANGE = Float(MELEE_RANGE);
		}
	}

	// rock_pickup
	void TrollLobber_OnRockPickup()
	{
		SetModelBody(1, 1); // show rock
	}

	// rock_throw
	void TrollLobber_OnRockThrow()
	{
		Vector3 mePos = OriginOf(ENT_ME);
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(HUNT_LASTTARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		float finAttackSpeed = ATTACK_SPEED;
		float aimAngle = Divide(RangeTo(HUNT_LASTTARGET), AIM_RATIO); // Aim up a bit
		if (targetZDifference > 200.0f)
		{
			// target higher, increase speed based on how much and reduce angle adj
			targetZDifference = Divide(targetZDifference, 2.0f);
			aimAngle = Divide(aimAngle, 2.0f);
			finAttackSpeed += targetZDifference;
		}
		SetAngle("add_view.x", aimAngle);

		// this hits if you use HUNT_LASTTARGET instead of <view>, but its a straight throw, doesn't look kewl
		// local SPEED_ADJ $get(HUNT_LASTTARGET,range)
		// multiply SPEED_ADJ 4
		// add FIN_ATTACK_SPEED SPEED_ADJ
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_troll_rock", RelativePosition(Vector3(0, 0, 21)), "none", finAttackSpeed, ROCK_DAMAGE, 0.75f, "none");
		COMBAT_REPOS += 1.0f;

		// dbg temp  @ $get(HUNT_LASTTARGET,name) ( repos COMBAT_REPOS angle AIM_ANGLE speed FIN_ATTACK_SPEED zdiff TARGET_Z_DIFFERENCE )
		SetModelBody(1, 0); // Hide Rock

		if (!(COMBAT_REPOS > 4.0f))
			return;
		COMBAT_REPOS = 0.0f;
		OnChickenRun(5.0f);
	}

	// attack_1
	// called by model double_punch @ frame 13 and 26
	void TrollLobber_OnAttack12()
	{
		SetModelBody(1, 0); // hide rock

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(20, 30), "75%");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_PUNCH;

		if (RangeTo(ENT_LASTSTRUCK) > MELE_RANGE)
			ANIM_ATTACK = ANIM_THROW;

		PlaySound(2, 10, SOUND_ATTACK);
	}

	// attack_2
	// called by model hit_down @ frame 20
	void TrollLobber_OnAttack22()
	{
		SetModelBody(1, 0); // hide rock

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(35, 45), "75%");
		ANIM_ATTACK = "double_punch";
		PlaySound(2, 10, SOUND_ATTACK);
		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_DBLPUNCH;
		if (RangeTo(ENT_LASTSTRUCK) > MELE_RANGE)
			ANIM_ATTACK = ANIM_THROW;
	}

	// npc_struck
	void TrollLobber_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlaySound(2, 5, SOUND_PAIN);
		if (RangeTo(ENT_LASTSTRUCK) < MELE_RANGE)
			ANIM_ATTACK = ANIM_DBLPUNCH;
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void TrollLobber_OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void TrollLobber_OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// game_hearsound
	void TrollLobber_OnGameHearsound()
	{
		SetVolume(10);
		PlaySound(2, 10, SOUND_IDLE);
	}

	// random_idle
	// idle anims
	void TrollLobber_OnRandomIdle()
	{
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
	void TrollLobber_OnWarcry()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// my_target_died
	void TrollLobber_OnMyTargetDied(string offender = "")
	{
		DID_WARCRY = false;
		if (CanSee("player"))
			return;
		PlayAnim("critical", "idle2");
	}

	// game_damaged_other
	string TrollLobber_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (EntityId(target) != HUNT_LASTTARGET)
			return result;
		if (!(damage > 1.0f))
			return result;

		COMBAT_REPOS = 0.0f;
		return result;
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
		result = AppendResult(result, TrollLobber_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		TrollLobber_OnMyTargetDied(offender);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		TrollLobber_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		TrollLobber_OnNpcTargetsighted(target);
	}

	void OnDebugProps() { TrollLobber_OnDebugProps(); } // debug_props
	void OnRockPickup() { TrollLobber_OnRockPickup(); } // rock_pickup
	void OnRockThrow() { TrollLobber_OnRockThrow(); } // rock_throw
	void OnAttack12() { TrollLobber_OnAttack12(); } // attack_1
	void OnAttack22() { TrollLobber_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { TrollLobber_OnNpcStruck(damage); } // npc_struck
	void OnStomp1() { TrollLobber_OnStomp1(); } // stomp_1
	void OnStomp2() { TrollLobber_OnStomp2(); } // stomp_2
	void OnGameHearsound() { TrollLobber_OnGameHearsound(); } // game_hearsound
	void OnRandomIdle() { TrollLobber_OnRandomIdle(); } // random_idle
	void OnWarcry() { TrollLobber_OnWarcry(); } // warcry
	void OnTrollSpawn() {} // troll_spawn

	// This file's events and timers by their .script names
	bool TrollLobber_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_hearsound") { OnGameHearsound(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "random_idle") { OnRandomIdle(); return true; }
		if (name == "rock_pickup") { OnRockPickup(); return true; }
		if (name == "rock_throw") { OnRockThrow(); return true; }
		if (name == "stomp_1") { OnStomp1(); return true; }
		if (name == "stomp_2") { OnStomp2(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/troll_lobber"]
shared class TrollLobberScript : BaseMonsterScript, TrollLobber
{
	// Variables declared by included files, with the value they start with in this script
	TrollLobberScript()
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
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollLobber_FirstThink();
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
		return TrollLobber_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
