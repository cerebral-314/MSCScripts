#pragma context server

// Converted from monsters/skeleton_ravager.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_pain.as"
#include "converted/monsters/base_jumper.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonRavager
{
	// Constants
	bool SKELE_SKIN = false;
	string ANIM_NPC_JUMP = "attack2";
	string SOUND_NPC_JUMP = "monsters/undeadz/c_skeleton_slct.wav";
	bool USES_PROJECTILE = false;
	string PROJECTILE_SCRIPT = "proj_fire_ball";
	float FREQ_PROJECTILE = 0.0f;
	int DMG_PROJECTILE = 200;
	string PROJECTILE_SPEED = "200";
	string ANIM_MOVE_CEILING = "anim_ceiling_move";
	string ANIM_IDLE_CEILING = "anim_ceiling_idle";
	string ANIM_DEATH_CEILING = "anim_death_ceiling";
	string ANIM_PROJECTILE_CEILING = "anim_ceiling_projectile";
	string ANIM_MOVE_CRAWL = "anim_crawl_floor";
	string ANIM_IDLE_CRAWL = "anim_crawl_idle";
	string ANIM_ATTACK_CRAWL = "anim_crawl_strike";
	string ANIM_DEATH_CRAWL = "anim_death_floor";
	string ANIM_PROJECTILE_CRAWL = "anim_crawl_strike";
	string ANIM_RUN_STAND = "anim_run";
	string ANIM_WALK_STAND = "walk";
	string ANIM_IDLE_STAND = "idle1";
	string ANIM_ATTACK_STAND = "attack1";
	string ANIM_ATTACK_SLAM = "attack2";
	string ANIM_DEATH_STAND = "anim_death_stand";
	string ANIM_PROJECTILE_STAND = "attack2";
	string ANIM_STAND2CRAWL = "anim_leapback2crawl";
	string ANIM_STAND2CEILING = "anim_stand2ceiling";
	string ANIM_CRAWL2STAND = "anim_crawl2stand";
	string ANIM_CEILING2STAND = "anim_ceiling2floor";
	float FREQ_STANCE_CHANGE = 0.0f;
	float DMG_CLAW = 0.0f;
	string DMG_CLAW_TYPE = "slash";
	string DMG_CLAW_EFFECT = "none";
	float DMG_CLAW_EFFECT_DUR = 5.0f;
	int DMG_CLAW_EFFECT_DOT = 50;
	int CLAWFX_WIDTH = 20;
	Vector3 CLAWFX_COLOR = Vector3();
	string CLAWFX_SPRITE = "claw.spr";
	bool BPAIN_USE_PAIN = true;
	bool BPAIN_USE_FLINCH = true;
	float BPAIN_FREQ_FLINCH = 0.0f;
	float BPAIN_FLINCH_HEALTH = 0.9f;
	string BPAIN_FLINCH_TOKENS = "flinchsmall;flinch;bigflinch;laflinch;raflinch;llflinch;rlflinch";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/undeadz/c_skeleton_hit1.wav";
	string SOUND_PAIN2 = "monsters/undeadz/c_skeleton_hit2.wav";
	string SOUND_ALERT1 = "monsters/undeadz/c_skeleton_bat1.wav";
	string SOUND_ALERT2 = "monsters/undeadz/c_skeleton_bat2.wav";
	string SOUND_ATTACK1 = "monsters/undeadz/c_skeleton_atk1.wav";
	string SOUND_ATTACK2 = "monsters/undeadz/c_skeleton_atk2.wav";
	string SOUND_ATTACK3 = "monsters/undeadz/c_skeleton_atk3.wav";
	string SOUND_SWIPE = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "monsters/undeadz/c_skeleton_dead.wav";
	string SOUND_LOOK = "monsters/undeadz/c_skeleton_slct.wav";
	string MONSTER_MODEL = "monsters/skeleton_ravenous.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "anim_run";
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	string STANCE_MODE = "unset";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_JUMPER = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float NEXT_STANCE_CHANGE = 0.0f;
	bool NO_CEILING = false;
	float AS_ATTACKING = 0.0f;
	bool NPC_NO_ATTACK = false;
	bool BPAIN_CAN_FLINCH = false;
	string ANIM_PROJECTILE = "ANIM_PROJECTILE";
	float SWIPE_COUNT = 0.0f;
	float NEXT_CEILING = 0.0f;
	float NEXT_PROJECTILE = 0.0f;
	bool USING_PROJECTILE = false;
	int DID_INTRO = 0;
	bool CAN_REACH_CEILING = false;

	// unnamed block (first think)
	// Monster script has a few interesting features
	// - Crawls on ceiling (though can't attack from there)
	// - Crawls on Ground
	// - Charging run attack
	// - Red blood CL beam-claws (maybe)
	void SkeletonRavager_FirstThink()
	{
		NPC_GIVE_EXP = 500.0f;

		NPC_JUMPER = false;

		ANIM_RUN = "anim_run"; // frame_claw_on frame_run_swipe frame_run_swipe frame_claw_off
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "anim_death_stand";

		STANCE_MODE = "unset";
	}

	// game_precache
	void SkeletonRavager_OnGamePrecache()
	{
	}

	// npc_spawn
	void SkeletonRavager_OnNpcSpawn(string npc = "")
	{
		OnSkeleSpawn();
		CallEventDelayed(1.0f, "finalize_stance");
	}

	// skele_spawn
	void SkeletonRavager_OnSkeleSpawn()
	{
		SetName("Skeletal Ravager");
		SetModel(MONSTER_MODEL);
		SetHealth(4000);
		SetWidth(32);
		SetHeight(72);
		SetRace("undead");
		SetBlood("none");
		SetDamageTaken("poison", 0);
		SetDamageTaken("blunt", 1.5f);
		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 2);
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// finalize_stance
	void SkeletonRavager_OnFinalizeStance()
	{
		if (STANCE_MODE != "unset")
			return;

		// no stance set, pick one
		NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;

		OnCeilingCheck();
		if (CAN_REACH_CEILING)
		{
			STANCE_MODE = "ceiling"; // skips anim
			OnCeilingMode();
		}

		if (STANCE_MODE != "unset") // couldn't do ceiling, do stand
			return;
		STANCE_MODE = "stand"; // skips anim
		OnStandMode();
	}

	// set_start_ceiling
	void SkeletonRavager_OnSetStartCeiling()
	{
		STANCE_MODE = "ceiling"; // so we don't play the related anims
		OnCeilingMode();
	}

	// set_start_crawl
	void SkeletonRavager_OnSetStartCrawl()
	{
		STANCE_MODE = "crawl"; // so we don't play the related anims
		OnCrawlMode();
	}

	// set_start_stand
	void SkeletonRavager_OnSetStartStand()
	{
		STANCE_MODE = "stand";
		OnStandMode();
	}

	// set_no_ceiling
	void SkeletonRavager_OnSetNoCeiling()
	{
		NO_CEILING = true;
	}

	// ceiling_mode
	void SkeletonRavager_OnCeilingMode()
	{
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("break");
		NPC_JUMPER = false;
		NPC_NO_ATTACK = true;
		BPAIN_CAN_FLINCH = false; // I has no ceiling flinch anims
		string prevStance = STANCE_MODE;
		STANCE_MODE = "ceiling";
		ANIM_IDLE = ANIM_IDLE_CEILING;
		ANIM_WALK = ANIM_MOVE_CEILING;
		ANIM_RUN = ANIM_MOVE_CEILING;
		ANIM_DEATH = ANIM_DEATH_CEILING;
		ANIM_ATTACK = "none"; // can't attack from here
		ANIM_PROJECTILE = ANIM_PROJECTILE_CEILING;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		if (prevStance == "stand")
		{
			PlaySound(0, 10, SOUND_LOOK);
			PlayAnim("critical", ANIM_STAND2CEILING);
			CallEventDelayed(1.0f, "ceiling_mode2");
		}
		else
		{
			OnCeilingMode2();
		}
	}

	// ceiling_mode2
	void SkeletonRavager_OnCeilingMode2()
	{
		BPAIN_CAN_FLINCH = true;
		SetGravity(-1);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 10000)));
	}

	// stand_mode
	void SkeletonRavager_OnStandMode()
	{
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("break");
		NPC_JUMPER = true;
		NPC_NO_ATTACK = false;
		OnBflinchSuspendFlinch("2.0");
		string prevStance = STANCE_MODE;
		STANCE_MODE = "stand";
		ANIM_IDLE = ANIM_IDLE_STAND;
		ANIM_WALK = ANIM_WALK_STAND;
		ANIM_RUN = ANIM_RUN_STAND;
		ANIM_DEATH = ANIM_DEATH_STAND;
		ANIM_ATTACK = ANIM_ATTACK_STAND;
		ANIM_PROJECTILE = ANIM_PROJECTILE_STAND;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		if (prevStance == "crawl")
		{
			PlaySound(0, 10, SOUND_LOOK);
			PlayAnim("critical", ANIM_CRAWL2STAND);
		}
		else if (prevStance == "ceiling")
		{
			PlaySound(0, 10, SOUND_LOOK);
			PlayAnim("critical", ANIM_CEILING2STAND);
		}
		SetGravity(1);
	}

	// crawl_mode
	void SkeletonRavager_OnCrawlMode()
	{
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("break");
		NPC_JUMPER = false;
		NPC_NO_ATTACK = false;
		BPAIN_CAN_FLINCH = false; // I has no crawling flinch anims
		string prevStance = STANCE_MODE;
		STANCE_MODE = "crawl";
		ANIM_IDLE = ANIM_IDLE_CRAWL;
		ANIM_WALK = ANIM_MOVE_CRAWL;
		ANIM_RUN = ANIM_MOVE_CRAWL;
		ANIM_DEATH = ANIM_DEATH_CRAWL;
		ANIM_ATTACK = ANIM_ATTACK_CRAWL;
		ANIM_PROJECTILE = ANIM_PROJECTILE_CRAWL;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		if (prevStance == "stand")
		{
			PlaySound(0, 10, SOUND_LOOK);
			PlayAnim("critical", ANIM_STAND2CRAWL);
		}
		SetGravity(1);
	}

	// frame_swipe
	void SkeletonRavager_OnFrameSwipe()
	{
		OnDidAttack();

		SWIPE_COUNT += 1.0f;
		if (SWIPE_COUNT > 3.0f)
		{
			// (always true here) if STANCE_MODE stand
			ANIM_ATTACK = ANIM_ATTACK_SLAM;
			SWIPE_COUNT = 0.0f;
		}

		if (DMG_CLAW_EFFECT == "none")
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "90%", "slash");
		else
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "90%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:claw");
	}

	// frame_slam
	void SkeletonRavager_OnFrameSlam()
	{
		OnDidAttack();

		float slamDmg = DMG_CLAW * 1.5f;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, slamDmg, "90%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:slam");

		if (USING_PROJECTILE)
			OnDoProjectile(AttachmentPositionOf(ENT_ME, 0));
		// (always true here) if STANCE_MODE stand

		ANIM_ATTACK = ANIM_ATTACK_STAND;
		SWIPE_COUNT = 0.0f; // redundancy
	}

	// frame_floor_swipe
	void SkeletonRavager_OnFrameFloorSwipe()
	{
		OnDidAttack();
		float dmgClaw = DMG_CLAW * 1.5f; // attack is much slower
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, dmgClaw, "90%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:clawfloor");
		if (USING_PROJECTILE)
			OnDoProjectile(AttachmentPositionOf(ENT_ME, 0));
	}

	// frame_run_swipe
	void SkeletonRavager_OnFrameRunSwipe()
	{
		if (DMG_CLAW_EFFECT == "none")
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "80%", "slash");
		else
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "80%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:claw");
	}

	// clawfloor_dodamage
	void SkeletonRavager_OnClawfloorDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 300, 110)));

		if (DMG_CLAW_EFFECT == "none")
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, DMG_CLAW_EFFECT, DMG_CLAW_EFFECT_DUR, self, DMG_CLAW_EFFECT_DOT);
	}

	// claw_dodamage
	void SkeletonRavager_OnClawDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, DMG_CLAW_EFFECT, DMG_CLAW_EFFECT_DUR, self, DMG_CLAW_EFFECT_DOT);
	}

	// slam_dodamage
	void SkeletonRavager_OnSlamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
		ApplyEffect(target, "effects/debuff_stun", 3.0f, self);

		if (DMG_CLAW_EFFECT == "none")
			return;
		ApplyEffect(target, DMG_CLAW_EFFECT, DMG_CLAW_EFFECT_DUR, self, DMG_CLAW_EFFECT_DOT);
	}

	// did_attack
	void SkeletonRavager_OnDidAttack()
	{
		// reset stance to ceiling timer
		if (NO_CEILING)
			return;
		if (STANCE_MODE != "stand")
			return;
		NEXT_CEILING = GameTime() + 10.0f;
	}

	// npc_targetsighted
	void SkeletonRavager_OnNpcTargetsighted(string target = "")
	{
		if (USES_PROJECTILE && RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE && GameTime() > NEXT_PROJECTILE)
		{
			NEXT_PROJECTILE = GameTime() + FREQ_PROJECTILE;
			USING_PROJECTILE = true;
			AS_ATTACKING = GameTime() + 5.0f;
			PlayAnim("once", ANIM_PROJECTILE);
		}

		if (DID_INTRO != 0)
			return;
		NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		DID_INTRO = 1;

		if (STANCE_MODE != "ceiling")
			return;
		PlayAnim("critical", ANIM_IDLE);
	}

	// npcatk_hunt
	void SkeletonRavager_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (SUSPEND_AI)
			return;

		if (STANCE_MODE == "ceiling")
		{
			Vector3 myOrg = OriginOf(ENT_ME);
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 100)));
			if (Truthy(LegacyFunction("get_under_sky", myOrg))) // hit some sky, drop down
			{
				NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
				OnStandMode();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (NPCATK_TARGET != "unset")
		{
			// drop to floor if target close
			if (STANCE_MODE == "ceiling" && Range2DTo(NPCATK_TARGET) < 256.0f)
			{
				// get their attention before dropping down
				PlayAnim("critical", ANIM_IDLE);
				PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
				CallEventDelayed(1.5f, "stand_mode");
				NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
				exitSub = true;
			}
			if (!exitSub)
			{
				// stand up if crawling, and target too far
				if (STANCE_MODE == "crawl" && Range2DTo(NPCATK_TARGET) > 512.0f)
				{
					OnStandMode();
					NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
					exitSub = true;
				}
				if (!exitSub && STANCE_MODE == "stand")
				{
					// seems this should be happening automatically, hrmm...
					if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
						SetMoveAnim(ANIM_WALK);
					else
						SetMoveAnim(ANIM_RUN);
				}
			}
		}
		if (exitSub)
			return;

		if (GameTime() > NEXT_STANCE_CHANGE)
		{
			// randomly go to crawl in combat
			if (STANCE_MODE == "stand" && NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) < 128.0f)
			{
				OnCrawlMode();
				NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
				exitSub = true;
			}
			if (!exitSub)
			{
				// ceiling, if available, and no attackers near by
				if (STANCE_MODE == "stand" && NPCATK_TARGET != "unset" && Range2DTo(NPCATK_TARGET) > 256.0f)
				{
					OnCeilingCheck();
					if (CAN_REACH_CEILING)
					{
						OnCeilingMode();
						NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
						exitSub = true;
					}
				}
				if (!exitSub && STANCE_MODE == "crawl")
				{
					OnStandMode();
					NEXT_STANCE_CHANGE = GameTime() + FREQ_STANCE_CHANGE;
				}
			}
		}
	}

	// frame_rclaw_on
	void SkeletonRavager_OnFrameRclawOn()
	{
		OnAttackSound(Random(80, 125));
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 1, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
	}

	// frame_lclaw_on
	void SkeletonRavager_OnFrameLclawOn()
	{
		OnAttackSound(Random(80, 125));
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 2, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
	}

	// frame_rclaw_on2
	// beams are not showing on these two for some reason
	void SkeletonRavager_OnFrameRclawOn2()
	{
		OnAttackSound(Random(125, 175));
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 1, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
	}

	// frame_lclaw_on2
	void SkeletonRavager_OnFrameLclawOn2()
	{
		OnAttackSound(Random(125, 175));
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 2, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
	}

	// frame_claws_on
	void SkeletonRavager_OnFrameClawsOn()
	{
		OnAttackSound(Random(80, 125));
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 1, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
		Effect("beam", "follow", CLAWFX_SPRITE, ENT_ME, 2, CLAWFX_WIDTH, 1.0f, 255, CLAWFX_COLOR);
	}

	// attack_sound
	// miss pitch
	void SkeletonRavager_OnAttackSound(float pitch = 0.0f)
	{
		if (RandomInt(1, 5) < 5)
			PlaySound(0, 10, SOUND_SWIPE, 0.8f, pitch);
		else
			PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// frame_leapback_boost
	void SkeletonRavager_OnFrameLeapbackBoost()
	{
		AddVelocity(ENT_ME, RelativePosition(Vector3(0, -400, 110)));
	}

	// ceiling_check
	void SkeletonRavager_OnCeilingCheck()
	{
		CAN_REACH_CEILING = false;
		Vector3 myOrg = OriginOf(ENT_ME);
		if (Truthy(LegacyFunction("get_under_sky", myOrg))) // can't, under sky
			return;
		Vector3 traceStart = OriginOf(ENT_ME);
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, 512.0f));
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == traceEnd) // can't, ceiling too high
			return;
		CAN_REACH_CEILING = true;
	}

	// game_dynamically_created
	void SkeletonRavager_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (creatorValue1 == "stand")
			OnSetStartStand();
		if (creatorValue1 == "crawl")
			OnSetStartCrawl();
		if (creatorValue1 == "ceiling")
		{
			OnSetStartCeiling();
			OnNpcatkSuspendAi();
			OnNpcSuicide();
		}
	}

	// game_death
	void SkeletonRavager_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (STANCE_MODE != "ceiling")
			return;

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("new", "all", "monsters/cl_corpse", IndexOf(ENT_ME), 23, SKELE_SKIN, 0, 1);
	}

	// do_projectile
	// <offset>
	void SkeletonRavager_OnDoProjectile(Vector3 offset = Vector3())
	{
		USING_PROJECTILE = false;
		PlaySound(0, 10, SOUND_PROJECTILE);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, offset, NPCATK_TARGET, PROJECTILE_SPEED, DMG_PROJECTILE, 5, "none");
		OnNpcAdjustProjectile();
	}

	// npcatk_jump
	void SkeletonRavager_OnNpcatkJump(float verticalDifference = 0.0f)
	{
		NEXT_STANCE_CHANGE += 5.0f; // so we don't change stances in the air
	}

	// frame_ceiling_projectile
	void SkeletonRavager_OnFrameCeilingProjectile()
	{
		OnDoProjectile(AttachmentPositionOf(ENT_ME, 0));
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
		SkeletonRavager_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SkeletonRavager_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BasePain_OnGameSpawn(playerRace, playerGender); // monsters/base_pain
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BasePain_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_pain
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SkeletonRavager_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		SkeletonRavager_OnNpcatkHunt();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SkeletonRavager_OnNpcTargetsighted(target);
	}

	// npcatk_jump
	void OnNpcatkJump(float verticalDifference = 0.0f)
	{
		BaseJumper_OnNpcatkJump(verticalDifference); // monsters/base_jumper
		SkeletonRavager_OnNpcatkJump(verticalDifference);
	}

	void OnGamePrecache() { SkeletonRavager_OnGamePrecache(); } // game_precache
	void OnSkeleSpawn() { SkeletonRavager_OnSkeleSpawn(); } // skele_spawn
	void OnFinalizeStance() { SkeletonRavager_OnFinalizeStance(); } // finalize_stance
	void OnSetStartCeiling() { SkeletonRavager_OnSetStartCeiling(); } // set_start_ceiling
	void OnSetStartCrawl() { SkeletonRavager_OnSetStartCrawl(); } // set_start_crawl
	void OnSetStartStand() { SkeletonRavager_OnSetStartStand(); } // set_start_stand
	void OnSetNoCeiling() { SkeletonRavager_OnSetNoCeiling(); } // set_no_ceiling
	void OnCeilingMode() { SkeletonRavager_OnCeilingMode(); } // ceiling_mode
	void OnCeilingMode2() { SkeletonRavager_OnCeilingMode2(); } // ceiling_mode2
	void OnStandMode() { SkeletonRavager_OnStandMode(); } // stand_mode
	void OnCrawlMode() { SkeletonRavager_OnCrawlMode(); } // crawl_mode
	void OnFrameSwipe() { SkeletonRavager_OnFrameSwipe(); } // frame_swipe
	void OnFrameSlam() { SkeletonRavager_OnFrameSlam(); } // frame_slam
	void OnFrameFloorSwipe() { SkeletonRavager_OnFrameFloorSwipe(); } // frame_floor_swipe
	void OnFrameRunSwipe() { SkeletonRavager_OnFrameRunSwipe(); } // frame_run_swipe
	void OnClawfloorDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { SkeletonRavager_OnClawfloorDodamage(hit, target, start, end, damageType, damageText); } // clawfloor_dodamage
	void OnClawDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { SkeletonRavager_OnClawDodamage(hit, target, start, end, damageType, damageText); } // claw_dodamage
	void OnSlamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { SkeletonRavager_OnSlamDodamage(hit, target, start, end, damageType, damageText); } // slam_dodamage
	void OnDidAttack() { SkeletonRavager_OnDidAttack(); } // did_attack
	void OnFrameRclawOn() { SkeletonRavager_OnFrameRclawOn(); } // frame_rclaw_on
	void OnFrameLclawOn() { SkeletonRavager_OnFrameLclawOn(); } // frame_lclaw_on
	void OnFrameRclawOn2() { SkeletonRavager_OnFrameRclawOn2(); } // frame_rclaw_on2
	void OnFrameLclawOn2() { SkeletonRavager_OnFrameLclawOn2(); } // frame_lclaw_on2
	void OnFrameClawsOn() { SkeletonRavager_OnFrameClawsOn(); } // frame_claws_on
	void OnAttackSound(float pitch = 0.0f) { SkeletonRavager_OnAttackSound(pitch); } // attack_sound
	void OnFrameLeapbackBoost() { SkeletonRavager_OnFrameLeapbackBoost(); } // frame_leapback_boost
	void OnCeilingCheck() { SkeletonRavager_OnCeilingCheck(); } // ceiling_check
	void OnDoProjectile(Vector3 offset = Vector3()) { SkeletonRavager_OnDoProjectile(offset); } // do_projectile
	void OnFrameCeilingProjectile() { SkeletonRavager_OnFrameCeilingProjectile(); } // frame_ceiling_projectile
	void OnNpcAdjustProjectile() {} // npc_adjust_projectile

	// This file's events and timers by their .script names
	bool SkeletonRavager_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "ceiling_check") { OnCeilingCheck(); return true; }
		if (name == "ceiling_mode") { OnCeilingMode(); return true; }
		if (name == "ceiling_mode2") { OnCeilingMode2(); return true; }
		if (name == "claw_dodamage") { OnClawDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "clawfloor_dodamage") { OnClawfloorDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "crawl_mode") { OnCrawlMode(); return true; }
		if (name == "did_attack") { OnDidAttack(); return true; }
		if (name == "do_projectile") { OnDoProjectile(Vec(Param(params, 0))); return true; }
		if (name == "finalize_stance") { OnFinalizeStance(); return true; }
		if (name == "frame_ceiling_projectile") { OnFrameCeilingProjectile(); return true; }
		if (name == "frame_claws_on") { OnFrameClawsOn(); return true; }
		if (name == "frame_floor_swipe") { OnFrameFloorSwipe(); return true; }
		if (name == "frame_lclaw_on") { OnFrameLclawOn(); return true; }
		if (name == "frame_lclaw_on2") { OnFrameLclawOn2(); return true; }
		if (name == "frame_leapback_boost") { OnFrameLeapbackBoost(); return true; }
		if (name == "frame_rclaw_on") { OnFrameRclawOn(); return true; }
		if (name == "frame_rclaw_on2") { OnFrameRclawOn2(); return true; }
		if (name == "frame_run_swipe") { OnFrameRunSwipe(); return true; }
		if (name == "frame_slam") { OnFrameSlam(); return true; }
		if (name == "frame_swipe") { OnFrameSwipe(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_jump") { OnNpcatkJump(Float(Param(params, 0))); return true; }
		if (name == "set_no_ceiling") { OnSetNoCeiling(); return true; }
		if (name == "set_start_ceiling") { OnSetStartCeiling(); return true; }
		if (name == "set_start_crawl") { OnSetStartCrawl(); return true; }
		if (name == "set_start_stand") { OnSetStartStand(); return true; }
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		if (name == "slam_dodamage") { OnSlamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "stand_mode") { OnStandMode(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_ravager"]
shared class SkeletonRavagerScript : BaseMonsterNewScript, SkeletonRavager, BasePain, BaseJumper
{
	// Variables every script that includes this file declares
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string SOUND_PROJECTILE = "SOUND_PROJECTILE";

	// Variables declared by included files, with the value they start with in this script
	SkeletonRavagerScript()
	{
		ANIM_RUN = "anim_run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "monsters/undeadz/c_skeleton_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("claw.spr");
		Precache("monsters/skeleton_ravenous.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonRavager_FirstThink();
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
		return SkeletonRavager_DispatchEvent(name, params)
			|| BasePain_DispatchEvent(name, params)
			|| BaseJumper_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
