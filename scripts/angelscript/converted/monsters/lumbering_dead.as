#pragma context server

// Converted from monsters/lumbering_dead.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/lumbering_dead"]
class LumberingDead : BaseMonsterNewScript
{
	// Constants
	string ANIM_SLASH = "attack1";
	string ANIM_CHEW = "attack2";
	string ANIM_THROW = "attack3";
	string ANIM_JUMP = "jump1";
	string ANIM_DEATH1 = "diebackward";
	string ANIM_DEATH2 = "dieforward";
	string ANIM_DEATH3 = "dieheadshot_1";
	string ANIM_DEATH4 = "dieheadshot_2";
	string ANIM_FLINCH_CUSTOM = "big_flinch";
	string ANIM_DANCE = "sohappy";
	string ANIM_RUN1 = "runlong";
	string ANIM_RUN2 = "runshort";
	string ANIM_LOOK = "idle1";
	string ANIM_IDLE_DEF = "idle2";
	string ANIM_EAT_LOOP = "eat_loop";
	string ANIM_VICTORY = "victoryeat1";
	float DMG_SLASH = 200.0f;
	int DMG_CHEW = 100;
	float DMG_GLOB = 400.0f;
	float FREQ_CHEW = 0.0f;
	float FREQ_THROW = 0.0f;
	string SOUND_ATTACK_START = "monsters/undeadz/c_golmbone_atk1.wav";
	string SOUND_SLASH_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_SLASH_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_SLASH_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_SLASH_HIT2 = "zombie/claw_strike2.wav";
	string SOUND_SLASH_HIT3 = "zombie/claw_strike3.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	string SOUND_STEP1 = "common/npc_step1.wav";
	string SOUND_STEP2 = "common/npc_step2.wav";
	string SOUND_IDLE = "monsters/undeadz/c_skeltchf_bat1.wav";
	string SOUND_ALERT1 = "monsters/undeadz/c_golmbone_bat1.wav";
	string SOUND_ALERT2 = "monsters/undeadz/c_golmbone_slct.wav";
	string SOUND_ALERT3 = "monsters/undeadz/c_hookhorr_bat1.wav";
	string SOUND_FLINCH1 = "monsters/undeadz/c_golmbone_hit1.wav";
	string SOUND_FLINCH2 = "monsters/undeadz/c_hookhorr_slct.wav";
	string SOUND_CHEW_START = "monsters/undeadz/c_hookhorr_atk1.wav";
	string SOUND_CHEW1 = "monsters/undeadz/c_skeleton_atk1.wav";
	string SOUND_CHEW2 = "monsters/undeadz/c_skeleton_atk2.wav";
	string SOUND_CHEW3 = "monsters/undeadz/c_skeleton_atk3.wav";
	string SOUND_DEATH1 = "monsters/undeadz/c_golmbone_dead.wav";
	string SOUND_DEATH2 = "monsters/undeadz/c_hookhorr_dead.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string GLOB_EFFECT_TYPE = "GLOB_EFFECT_TYPE";
	int GLOB_EFFECT_DOT = 0;
	float GLOB_EFFECT_DUR = 0.0f;
	string NPC_ALT_SOUND_DEATH = "NPC_ALT_SOUND_DEATH";
	float FLINCH_CUSTOM_HEALTH = 0.0f;
	bool EAT_MODE = false;
	float NEXT_THROW = 0.0f;
	bool DID_ALERT = false;
	float NEXT_IDLE_SOUND = 0.0f;
	float NEXT_CHEW = 0.0f;
	float NEXT_LOOK = 0.0f;
	bool SLASH_ATTACK = false;
	float NPC_TARG_RANGE = 0.0f;
	Vector3 NPC_TARG_POS = Vector3();
	float NEXT_CUSTOM_FLINCH = 0.0f;
	float N_CRABS = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	LumberingDead()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle2";
		NPC_GIVE_EXP = 1000.0f;
	}

	// unnamed block (first think)
	void LumberingDead_FirstThink()
	{
		ANIM_DEATH = "diebackward";

		ANIM_WALK = "walk"; // frame_walk1 / frame_walk2
		ANIM_RUN = "runlong"; // frame_run1 / frame_run2
		ANIM_IDLE = "idle2";
	}

	// unnamed block (first think)
	void LumberingDead_FirstThink2()
	{
		NPC_GIVE_EXP = 1000.0f;

		ATTACK_RANGE = 64.0f;
		MOVE_RANGE = "48";
		ATTACK_MOVERANGE = 48.0f;

		ANIM_ATTACK = "attack1"; // frame_attack / frame_attack_start

		GLOB_EFFECT_TYPE = "effects/dot_acid";
		GLOB_EFFECT_DOT = 50;
		GLOB_EFFECT_DUR = 5.0f;
		NPC_ALT_SOUND_DEATH = SOUND_DEATH1;
	}

	// game_dodamage
	string LumberingDead_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (EAT_MODE)
		{
			EAT_MODE = false;
			SetIdleAnim(ANIM_IDLE);
			NO_STUCK_CHECKS = "0";
			SetRoam(true);
		}

		NPC_TARG_RANGE = RangeTo(NPCATK_TARGET);
		NPC_TARG_POS = OriginOf(NPCATK_TARGET);

		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SLASH_HIT1, SOUND_SLASH_HIT2, SOUND_SLASH_HIT3);
			float x = Random(-100, 100);
			float y = Random(100, 200); // Causes crash if randf is used inside of relvel
			AddVelocity(target, RelativeVelocity(Vector3(x, y, 100)));
		}
		else
		{
			PlayRandomSound(0, 10, SOUND_SLASH_MISS1, SOUND_SLASH_MISS2);
		}
		SLASH_ATTACK = false;
		return result;
	}

	// game_damaged
	string LumberingDead_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(HealthOf(ENT_ME) < FLINCH_CUSTOM_HEALTH))
			return result;
		if (!(GameTime() > NEXT_CUSTOM_FLINCH))
			return result;
		NEXT_CUSTOM_FLINCH = GameTime() + 20.0f;
		PlayRandomSound(0, 10, SOUND_FLINCH1, SOUND_FLINCH2);
		PlayAnim("critical", ANIM_FLINCH_CUSTOM);
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/skullcrab");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		int rndDeathSnd = RandomInt(1, 2);
		int rndDeathAnim = RandomInt(1, 3);
		if (rndDeathSnd == 1)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH1;
		if (rndDeathSnd == 2)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH2;
		if (rndDeathAnim == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeathAnim == 2) // ANIM_DEATH2 dies forward, too likely to fall into player
			ANIM_DEATH = ANIM_DEATH3;
		if (rndDeathAnim == 3)
			ANIM_DEATH = ANIM_DEATH4;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lumbering Dead");
		SetHealth(4000);
		SetRace("undead");
		SetModel("monsters/lumbering.mdl");
		SetWidth(32);
		SetHeight(96);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetHearingSensitivity(4);
		SetRoam(true);

		SetDamageTaken("all", 0.75f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("slash", 1);
		SetDamageTaken("blunt", 1.5f);
		SetDamageTaken("pierce", 0.5f);
		IMMUNE_VAMPIRE = true;

		CallEventDelayed(2.0f, "finalize_npc");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		float gameTime = GameTime();

		if (NPCATK_TARGET == "unset" && gameTime > NEXT_IDLE_SOUND)
		{
			NEXT_IDLE_SOUND = gameTime + Random(10, 20);
			PlaySound(0, 10, SOUND_IDLE);
			PlayAnim("once", ANIM_LOOK);
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (RangeTo(NPCATK_TARGET) > 200.0f)
		{
			ANIM_RUN = ANIM_RUN1;
			SetMoveAnim(ANIM_RUN1);
		}
		else
		{
			ANIM_RUN = ANIM_RUN2;
			SetMoveAnim(ANIM_RUN2);
		}

		if (RangeTo(NPCATK_TARGET) < 48.0f && gameTime > NEXT_CHEW)
		{
			NEXT_CHEW = gameTime + FREQ_CHEW;
			PlayAnim("critical", ANIM_CHEW);
		}
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_LOOK))
			return;
		NEXT_LOOK = GameTime() + 20.0f;
		AS_ATTACKING = 0.0f;
		AS_ATTACKING += 5.0f;
		PlayAnim("once", ANIM_LOOK);
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(NPC_TARG_RANGE < 200.0f))
			return;
		PlayAnim("once", ANIM_VICTORY);
		SetIdleAnim(ANIM_EAT_LOOP);
		Vector3 facePos = OriginOf(ENT_ME);
		float myYaw = AnglesOf(ENT_ME).y;
		SetRoam(false);
		EAT_MODE = true;
		// vectoradd FACE_POS $relpos($vec(0,MY_YAW,0),$vec(0,200,0))
		SetMoveDest(NPC_TARG_POS, 9999);
		NO_STUCK_CHECKS = "1";
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, LumberingDead_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, LumberingDead_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		float gameTime = GameTime();

		if (EAT_MODE)
		{
			EAT_MODE = false;
			SetIdleAnim(ANIM_IDLE);
			NO_STUCK_CHECKS = "0";
			SetRoam(true);
			NEXT_THROW = gameTime + 5.0f;
		}

		if (NPCATK_TARGET != "unset" && GameTime() > NEXT_THROW && RangeTo(NPCATK_TARGET) > 128.0f)
		{
			AS_ATTACKING = gameTime + 5.0f;
			NEXT_THROW = gameTime + 5.0f;
			PlayAnim("critical", ANIM_THROW);
		}

		if (DID_ALERT)
			return;
		DID_ALERT = true;
		NEXT_THROW = gameTime + FREQ_THROW;

		AS_ATTACKING = gameTime + 5.0f;

		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);
	}

	// finalize_npc
	void OnFinalizeNpc()
	{
		FLINCH_CUSTOM_HEALTH = MaxHealthOf(ENT_ME) * 0.3f;
	}

	// frame_attack_start
	void OnFrameAttackStart()
	{
		if (RandomInt(1, 3) != 1)
			return;
		PlaySound(0, 10, SOUND_ATTACK_START);
	}

	// frame_attack
	void OnFrameAttack()
	{
		SLASH_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SLASH, "80%", "slash");
	}

	// frame_walk1
	void OnFrameWalk1()
	{
		PlaySound(0, 5, SOUND_STEP1);
	}

	// frame_walk2
	void OnFrameWalk2()
	{
		PlaySound(0, 5, SOUND_STEP2);
	}

	// frame_run1
	void OnFrameRun1()
	{
		PlaySound(0, 10, SOUND_STEP1);
	}

	// frame_run2
	void OnFrameRun2()
	{
		PlaySound(0, 10, SOUND_STEP2);
	}

	// frame_chewface_start
	void OnFrameChewfaceStart()
	{
		PlaySound(0, 10, SOUND_CHEW_START);
		if (RangeTo(NPCATK_TARGET) < 64.0f)
			AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, -300, 0)));
	}

	// frame_chewface
	void OnFrameChewface()
	{
		PlayRandomSound(0, 10, SOUND_CHEW1, SOUND_CHEW2, SOUND_CHEW3);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, -300, 0)));
		DoDamage(NPCATK_TARGET, 64, DMG_CHEW, "90%", "pierce");
	}

	// crab_died
	void OnCrabDied()
	{
		N_CRABS -= 1.0f;
	}

	// frame_grab_crab
	void OnFrameGrabCrab()
	{
		if (!(N_CRABS < 2.0f))
			return;
		SetModelBody(1, 1);
	}

	// frame_toss_crab
	void OnFrameTossCrab()
	{
		NEXT_THROW = GameTime() + FREQ_THROW;
		PlaySound(0, 10, SOUND_THROW);
		if (N_CRABS < 2.0f)
		{
			N_CRABS += 1.0f;
			CreateNpc("monsters/skullcrab", RelativePosition(Vector3(-20, 20, 75)), self, NPCATK_TARGET);
		}
		else
		{
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			if (!IsPlayer(Text(targOrg)))
				targOrg.z += HeightOf(NPCATK_TARGET);
			float targDist = Divide(Distance(targOrg, MyOrigin()), 35.0f);
			SetAngle("add_view.pitch", targDist);

			int bombSpeed = 600;
			if (RangeTo(NPCATK_TARGET) > 800.0f)
				bombSpeed = 800;

			NEXT_THROW = GameTime() + 5.0f;
			TossProjectile("proj_glob", RelativePosition(Vector3(-10, 0, 27)), "none", bombSpeed, DMG_GLOB, 0.1f, "none");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("monsters/lumbering.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LumberingDead_FirstThink();
		LumberingDead_FirstThink2();
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
		if (name == "crab_died") { OnCrabDied(); return true; }
		if (name == "finalize_npc") { OnFinalizeNpc(); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "frame_attack_start") { OnFrameAttackStart(); return true; }
		if (name == "frame_chewface") { OnFrameChewface(); return true; }
		if (name == "frame_chewface_start") { OnFrameChewfaceStart(); return true; }
		if (name == "frame_grab_crab") { OnFrameGrabCrab(); return true; }
		if (name == "frame_run1") { OnFrameRun1(); return true; }
		if (name == "frame_run2") { OnFrameRun2(); return true; }
		if (name == "frame_toss_crab") { OnFrameTossCrab(); return true; }
		if (name == "frame_walk1") { OnFrameWalk1(); return true; }
		if (name == "frame_walk2") { OnFrameWalk2(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
