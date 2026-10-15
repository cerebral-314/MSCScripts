#pragma context server

// Converted from monsters/troll_ice_lobber.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Troll Lobber by Thothie - as standard troll, but primary attack is rock throw

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_race_cold.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TrollIceLobber
{
	// Constants
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
	int ROCK_RANGE = 9999;
	int SWING_RANGE = 130;
	int MELE_RANGE = 128;
	int MELE_HITRANGE = 164;
	int AIM_RATIO = 25;
	int ATTACK_SPEED = 500;
	string ROCK_DAMAGE = "$rand(400,800)";

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
	bool DO_THROW = false;
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void TrollIceLobber_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 40;
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fall";
		ANIM_ATTACK = "double_punch"; // this varies, needs to be a var
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 300.0f;
		MOVE_RANGE = "400";
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "33";
		FLINCH_ANIM = "flinch2";
		FLINCH_DELAY = "2.0";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
	}

	// npc_spawn
	void TrollIceLobber_OnNpcSpawn(string npc = "")
	{
		SetHealth(2000);
		// ov 100
		SetWidth(100);
		SetHeight(125);
		SetRace("demon");
		SetName("Ice Troll Lobber");
		SetRoam(true);
		NPC_GIVE_EXP = 150.0f;
		SetDamageTaken("all", 0.7f);
		SetModel("monsters/troll_ice_lobber.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(10);

		COMBAT_REPOS = 0.0f;

		CallEventDelayed(10.0f, "random_idle");

		CatchSpeech("debug_props", "debug");

		OnTrollSpawn();
	}

	// debug_props
	void TrollIceLobber_OnDebugProps()
	{
		SetSayTextRange(1024);
		SayText("I is hunting ( " + Text(IS_HUNTING) + " ) my target ( " + NameOf(HUNT_LASTTARGET));
	}

	// npc_targetsighted
	void TrollIceLobber_OnNpcTargetsighted(string target = "")
	{
		// //dbg temp validating $get(PARAM1,name)
		if (!CanSee(target))
			return;
		// setvard ANIM_ATTACK ANIM_DBLPUNCH
		ATTACK_RANGE = SWING_RANGE;
		if (RangeTo(target) <= ROCK_RANGE)
		{
			if (RangeTo(target) > ATTACK_RANGE)
			{
				AS_ATTACKING = GameTime() + 20.0f;
				MOVE_RANGE = "400";
				ATTACK_MOVERANGE = 400.0f;
				PlayAnim("once", ANIM_THROW);
			}
		}
		else
		{
			MOVE_RANGE = "100";
			ATTACK_MOVERANGE = 100.0f;
		}
	}

	// rock_pickup
	void TrollIceLobber_OnRockPickup()
	{
		AS_ATTACKING = GameTime() + 20.0f;
		SetModelBody(1, 1); // show rock
		OnNpcatkSuspendAi("2.0");
		SetMoveDest(HUNT_LASTTARGET, 9999);
	}

	// rock_throw
	void TrollIceLobber_OnRockThrow()
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
		float targetRange = RangeTo(HUNT_LASTTARGET);
		if (targetRange <= 1000.0f)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_snow_ball2", RelativePosition(Vector3(0, 0, 21)), "none", finAttackSpeed, ROCK_DAMAGE, 0.75f, "none");
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "set_dmg", 200, 100, 20, 0.4f); // <dmg> <amt> <radius> <gravity>
		}
		if (targetRange > 1000.0f)
		{
			TossProjectile("proj_snow_ball2", RelativePosition(Vector3(0, 0, 21)), HUNT_LASTTARGET, finAttackSpeed, ROCK_DAMAGE, 0.75f, "none");
			CallExternal(EntityOf(ENT_LASTPROJECTILE), "set_dmg", 200, 100, 20, 0.01f); // <dmg> <amt> <radius> <gravity>
		}
		COMBAT_REPOS += 1.0f;

		// dbg temp  @ $get(HUNT_LASTTARGET,name) ( repos COMBAT_REPOS angle AIM_ANGLE speed FIN_ATTACK_SPEED zdiff TARGET_Z_DIFFERENCE )
		SetModelBody(1, 0); // Hide Rock

		OnNpcatkResumeAi();

		if (!(COMBAT_REPOS > 4.0f))
			return;
		COMBAT_REPOS = 0.0f;
		OnChickenRun(5.0f);
	}

	// attack_1
	// called by model double_punch @ frame 13 and 26
	void TrollIceLobber_OnAttack12()
	{
		DO_THROW = false;

		SetModelBody(1, 0); // hide rock

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(20, 30), "75%");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_PUNCH;

		// if ( $get(ent_laststruck,range) > MELE_RANGE ) setvard ANIM_ATTACK ANIM_THROW
		PlaySound(2, 10, SOUND_ATTACK);
	}

	// attack_2
	// called by model hit_down @ frame 20
	void TrollIceLobber_OnAttack22()
	{
		SetModelBody(1, 0); // hide rock

		DO_THROW = true;

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(35, 45), "75%");
		ANIM_ATTACK = "double_punch";
		PlaySound(2, 10, SOUND_ATTACK);
		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = ANIM_DBLPUNCH;
	}

	// npc_struck
	void TrollIceLobber_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlaySound(2, 5, SOUND_PAIN);
		if (RangeTo(ENT_LASTSTRUCK) < MELE_RANGE)
			ANIM_ATTACK = ANIM_DBLPUNCH;
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void TrollIceLobber_OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void TrollIceLobber_OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// game_hearsound
	void TrollIceLobber_OnGameHearsound()
	{
		SetVolume(10);
		PlaySound(2, 5, SOUND_IDLE);
	}

	// random_idle
	// idle anims
	void TrollIceLobber_OnRandomIdle()
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
	void TrollIceLobber_OnWarcry()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// my_target_died
	void TrollIceLobber_OnMyTargetDied(string offender = "")
	{
		DID_WARCRY = false;
		if (CanSee("player"))
			return;
		PlayAnim("critical", "idle2");
	}

	// game_damaged_other
	string TrollIceLobber_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (EntityId(target) != HUNT_LASTTARGET)
			return result;
		if (!(damage > 1.0f))
			return result;

		COMBAT_REPOS = 0.0f;
		return result;
	}

	// game_dodamage
	string TrollIceLobber_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (hit)
		{
			if (DO_THROW)
				ApplyEffect(target, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
			if (PUSH_VEL != "0")
				AddVelocity(target, Vec(PUSH_VEL));
		}
		PUSH_VEL = "0";
		DO_THROW = false;
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
		result = AppendResult(result, TrollIceLobber_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		TrollIceLobber_OnMyTargetDied(offender);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
		TrollIceLobber_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, TrollIceLobber_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		TrollIceLobber_OnNpcTargetsighted(target);
	}

	void OnDebugProps() { TrollIceLobber_OnDebugProps(); } // debug_props
	void OnRockPickup() { TrollIceLobber_OnRockPickup(); } // rock_pickup
	void OnRockThrow() { TrollIceLobber_OnRockThrow(); } // rock_throw
	void OnAttack12() { TrollIceLobber_OnAttack12(); } // attack_1
	void OnAttack22() { TrollIceLobber_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { TrollIceLobber_OnNpcStruck(damage); } // npc_struck
	void OnStomp1() { TrollIceLobber_OnStomp1(); } // stomp_1
	void OnStomp2() { TrollIceLobber_OnStomp2(); } // stomp_2
	void OnGameHearsound() { TrollIceLobber_OnGameHearsound(); } // game_hearsound
	void OnRandomIdle() { TrollIceLobber_OnRandomIdle(); } // random_idle
	void OnWarcry() { TrollIceLobber_OnWarcry(); } // warcry
	void OnTrollSpawn() {} // troll_spawn

	// This file's events and timers by their .script names
	bool TrollIceLobber_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
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
[script "monsters/troll_ice_lobber"]
shared class TrollIceLobberScript : BaseMonsterScript, TrollIceLobber, BaseRaceCold, BaseIceRace
{
	// Variables declared by included files, with the value they start with in this script
	TrollIceLobberScript()
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
		Precache("misc/glassgibs_huge.mdl");
		Precache("monsters/troll_ice_lobber.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollIceLobber_FirstThink();
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
		return TrollIceLobber_DispatchEvent(name, params)
			|| BaseIceRace_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
