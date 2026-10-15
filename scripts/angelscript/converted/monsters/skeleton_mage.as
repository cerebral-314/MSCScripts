#pragma context server

// Converted from monsters/skeleton_mage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_pain.as"

[script "monsters/skeleton_mage"]
class SkeletonMage : BaseMonsterNewScript, BasePain
{
	// Constants
	string ANIM_PROJECTILE = "anim_projectile";
	string ANIM_SWIPE = "attack1";
	string ANIM_SLAM = "attack2";
	string ANIM_SEAL = "anim_seal";
	string ANIM_KICK = "anim_roundhouse";
	string ANIM_DEATH_IDLE = "dead_on_stomach";
	float DMG_CLAW = 50.0f;
	int DMG_SLAM = 100;
	string DMG_KICK = "100";
	int DMG_SEAL = 400;
	int DMG_PROJECTILE = 400;
	int SKELE_GOLD = 500;
	int SKELE_HEARING = 10;
	float FREQ_KICK = 30.0f;
	int ATTACK_MELERANGE = 96;
	int RANGE_PROJECTILE = 1024;
	int RANGE_SEAL = 640;
	int RANGE_SWIPE = 64;
	string SEAL_RAD = "140";
	float FREQ_CL_UPDATE = 20.0f;
	bool BPAIN_USE_PAIN = true;
	bool BPAIN_USE_FLINCH = true;
	float BPAIN_FREQ_FLINCH = 0.0f;
	float BPAIN_FLINCH_HEALTH = 0.75f;
	float BPAIN_PAIN_HEALTH = 1.0f;
	string BPAIN_FLINCH_TOKENS = "flinchsmall;flinch;bigflinch;laflinch;raflinch;llflinch;rlflinch";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/undeadz/c_shadow_hit1.wav";
	string SOUND_PAIN2 = "monsters/undeadz/c_shadow_hit2.wav";
	string SOUND_CLAW_MISS = "zombie/claw_miss1.wav";
	string SOUND_CLAW_HIT = "zombie/claw_strike1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_RANGED_ATTACK = "ANIM_RANGED_ATTACK";
	bool AM_SKELETON = false;
	string CUST_ELEMENT_LIST = "CUST_ELEMENT_LIST";
	string SKELE_DEFAULT_ANIM_WALK = "SKELE_DEFAULT_ANIM_WALK";
	string SKELE_DEFAULT_ANIM_RUN = "SKELE_DEFAULT_ANIM_RUN";
	string SKELE_DEFAULT_ANIM_IDLE = "SKELE_DEFAULT_ANIM_IDLE";
	bool SKELE_BASE_ROAM = false;
	float SWIPE_COUNT = 0.0f;
	bool KICK_ENABLED = false;
	float MISS_COUNT = 0.0f;
	float NEXT_KICK = 0.0f;
	float NEXT_CL_UPDATE = 0.0f;
	string CL_FX_IDX = "CL_FX_IDX";
	float CL_LAST_UPDATE_TIME = 0.0f;
	string PROJ_ELEMENT_TARGET = "PROJ_ELEMENT_TARGET";
	Vector3 SEAL_ORG = Vector3();
	string ELEMENT_LIST = "ELEMENT_LIST";
	float ELEMENT_IDX = 0.0f;
	string ELEMENT_TYPE = "ELEMENT_TYPE";
	Vector3 ELEMENT_COLOR = Vector3();
	int ELEMENT_SEAL_IDX = 0;
	string SOUND_ELEMENT_CHARGE = "SOUND_ELEMENT_CHARGE";
	string SOUND_ELEMENT_FIRE = "SOUND_ELEMENT_FIRE";
	string ELEMENT_EFFECT = "ELEMENT_EFFECT";
	int DOT_ELEMENT = 0;
	string PROJ_ELEMENT_TYPE = "PROJ_ELEMENT_TYPE";
	bool TOGGLE_ADD = false;
	bool RESTRICTED_ELEMENTS = false;
	string CUR_PROJ_ELEMENT = "CUR_PROJ_ELEMENT";
	bool NPC_PROXACT_IFSEEN = false;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_FOV = false;
	bool SKELE_FIRST_RAISE = false;
	string SKELE_ORG_NAME = "SKELE_ORG_NAME";

	// Variables declared by included files, with the value they start with in this script
	SkeletonMage()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "walk";
		SOUND_DEATH = "monsters/undeadz/c_skeltwiz_bat1.wav";
	}

	// unnamed block (first think)
	void SkeletonMage_FirstThink()
	{
		NPC_GIVE_EXP = 600.0f;

		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "walk";
		ANIM_ATTACK = "anim_projectile";
		ANIM_DEATH = "dieforward";

		ANIM_RANGED_ATTACK = "anim_projectile";

		NPC_RANGED = "1";
		ATTACK_MOVERANGE = 600.0f;
		ATTACK_RANGE = 1024.0f;
		ATTACK_HITRANGE = 1024.0f;
		DROP_GOLD = 1;
		AM_SKELETON = true;

		CUST_ELEMENT_LIST = "";
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, "magic/sps_fogfire.wav");
		ServerPlaySound(0, 0, "magic/cold_breath.wav");
		ServerPlaySound(0, 0, "magic/bolt_loop.wav");
		ServerPlaySound(0, 0, "magic/flame_loop.wav");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ClientEvent("update", "all", CL_FX_IDX, "end_effect");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OnSkeletonAttribs();
		OnSkeleSpawn();

		SKELE_DEFAULT_ANIM_WALK = ANIM_WALK;
		SKELE_DEFAULT_ANIM_RUN = ANIM_RUN;
		SKELE_DEFAULT_ANIM_IDLE = ANIM_IDLE;

		DROP_GOLD_AMT = SKELE_GOLD;

		SKELE_BASE_ROAM = true;

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetRoam(true);
		SetHearingSensitivity(SKELE_HEARING);
		SetBlood("none");
		SetRace("undead");

		CallEventDelayed(0.5f, "reduce_xp_by_element");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (GameTime() > NEXT_CL_UPDATE)
			OnUpdateClFx();

		if (NPCATK_TARGET != "unset" && MISS_COUNT > 5.0f)
		{
			MISS_COUNT = 0.0f;
			if (!NPC_IS_TURRET)
				OnChickenRun(Random(3, 5));
		}
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		float timeSinceLastUpdate = GameTime() - CL_LAST_UPDATE_TIME;
		if (timeSinceLastUpdate > 5.0f)
			LegacyCommand("clientevent", "update_cl_fx");
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// may need delays, as these may spam
		if (ELEMENT_TYPE == "ELEMENT_TYPE")
			OnPickElement();

		if (RangeTo(NPCATK_TARGET) < RANGE_PROJECTILE)
			ANIM_ATTACK = ANIM_PROJECTILE;
		if (RangeTo(NPCATK_TARGET) < RANGE_SEAL)
		{
			ANIM_ATTACK = ANIM_RANGED_ATTACK; // switches with each use
		}
		if (RangeTo(NPCATK_TARGET) < RANGE_SWIPE)
		{
			if (SWIPE_COUNT < 4.0f)
				ANIM_ATTACK = ANIM_SWIPE;
			else
				ANIM_ATTACK = ANIM_SLAM;

			if (KICK_ENABLED && GameTime() > NEXT_KICK)
				ANIM_ATTACK = ANIM_KICK;
		}
	}

	// reduce_xp_by_element
	void OnReduceXpByElement()
	{
		// reduce XP by 10% per element removed
		if (!RESTRICTED_ELEMENTS)
			return;
		float shortElements = 4.0f;
		int curElements = GetTokenCount(CUST_ELEMENT_LIST);

		shortElements -= curElements;
		if (shortElements > 0.0f)
		{
			shortElements *= 0.1f;
			float xpReduct = 1.0f - shortElements;
			OnExtReductXp(xpReduct);
		}
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SetName("Skeletal Mage");
		SetHealth(5000);
		SetModel("monsters/skeletonDX.mdl");
		SetWidth(32);
		SetHeight(72);
	}

	// skeleton_attribs
	void OnSkeletonAttribs()
	{
		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("poison", 0);
	}

	// frame_swipe
	void OnFrameSwipe()
	{
		SWIPE_COUNT += 1.0f;
		if (!KICK_ENABLED && SWIPE_COUNT > 2.0f)
			KICK_ENABLED = true;
		DoDamageEx(NPCATK_TARGET, ATTACK_MELERANGE, DMG_CLAW, "90%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:swipe");
	}

	// frame_slam
	void OnFrameSlam()
	{
		SWIPE_COUNT = 0.0f;
		DoDamageEx(NPCATK_TARGET, ATTACK_MELERANGE, DMG_SLAM, "80%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:slam");
	}

	// swipe_dodamage
	void OnSwipeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
		{
			PlaySound(0, 10, SOUND_CLAW_MISS, 0.8f, Random(125, 175));
		}
		else
		{
			MISS_COUNT = 0.0f;
			PlaySound(0, 10, SOUND_CLAW_HIT, 0.8f, Random(125, 175));
			if (RelationshipOf(target, ENT_ME) == "enemy")
				OnApplyElementDot(target);
		}
	}

	// slam_dodamage
	void OnSlamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
		{
			PlaySound(0, 10, SOUND_CLAW_MISS, 0.8f, Random(125, 175));
		}
		else
		{
			MISS_COUNT = 0.0f;
			PlaySound(0, 10, SOUND_CLAW_HIT, 0.8f, Random(125, 175));
			if (RelationshipOf(target, ENT_ME) == "enemy")
			{
				AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
				ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
				OnApplyElementDot(target);
			}
		}
	}

	// frame_kick_start
	void OnFrameKickStart()
	{
		NEXT_KICK = GameTime() + FREQ_KICK;
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 2, 1, 1.5f, 255, Vector3(128, 128, 255));
	}

	// frame_kick_land
	void OnFrameKickLand()
	{
		DoDamageEx(NPCATK_TARGET, ATTACK_MELERANGE, DMG_KICK, "100%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:kick");
	}

	// kick_dodamage
	void OnKickDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
		{
			PlaySound(0, 10, SOUND_CLAW_MISS, 0.8f, Random(60, 80));
		}
		else
		{
			PlaySound(0, 10, SOUND_CLAW_HIT, 0.8f, Random(60, 80));
			MISS_COUNT = 0.0f;
			if (RelationshipOf(target, ENT_ME) == "enemy")
			{
				AddVelocity(target, RelativeVelocity(Vector3(0, 2000, 200)));
				ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
				OnApplyElementDot(target);
			}
		}
	}

	// update_cl_fx
	void OnUpdateClFx()
	{
		NEXT_CL_UPDATE = GameTime() + FREQ_CL_UPDATE;
		float dur = FREQ_CL_UPDATE + 0.1f;
		if (CL_FX_IDX != "CL_FX_IDX")
			ClientEvent("update", "all", CL_FX_IDX, "end_effect");
		ClientEvent("new", "all", "monsters/skeleton_mage_cl", IndexOf(ENT_ME), dur);
		CL_FX_IDX = LastClientScriptId();
		CL_LAST_UPDATE_TIME = GameTime();
	}

	// frame_projectile_start
	void OnFrameProjectileStart()
	{
		MISS_COUNT += 1.0f;
		OnPickElement();
		PlaySound(0, 10, SOUND_ELEMENT_CHARGE); // set by pick_element
		ClientEvent("update", "all", CL_FX_IDX, "show_orb", ELEMENT_COLOR);
	}

	// frame_projectile_fire
	void OnFrameProjectileFire()
	{
		PlaySound(0, 10, SOUND_ELEMENT_FIRE); // set by pick_element
		ClientEvent("update", "all", CL_FX_IDX, "hide_orb");
		PROJ_ELEMENT_TARGET = NPCATK_TARGET;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_elemental_guided", AttachmentPositionOf(ENT_ME, 0), "none", 100, 0, 10, "none");
		if (!(RangeTo(NPCATK_TARGET) < RANGE_SEAL))
			return;
		ANIM_RANGED_ATTACK = ANIM_SEAL;
	}

	// frame_seal_start
	void OnFrameSealStart()
	{
		OnPickElement(); // sets seal model body too
		SEAL_ORG = OriginOf(NPCATK_TARGET);
		SEAL_ORG.z = GroundHeight(SEAL_ORG);
		ClientEvent("update", "all", CL_FX_IDX, "show_seal_warning", SEAL_ORG, SEAL_RAD, ELEMENT_SEAL_IDX, ELEMENT_COLOR);
	}

	// frame_seal_create
	void OnFrameSealCreate()
	{
		ClientEvent("new", "all", "effects/sfx_seal_instant", SEAL_ORG, ELEMENT_TYPE, SEAL_RAD, ELEMENT_SEAL_IDX);
		SEAL_ORG.z += 32.0f; // in case of uneven terrain
		string dmgType = ELEMENT_TYPE + "_effect";
		DoDamageEx(SEAL_ORG, SEAL_RAD, DMG_SEAL, 0, ENT_ME, ENT_ME, "none", dmgType, "dmgevent:seal");

		ANIM_RANGED_ATTACK = ANIM_PROJECTILE;
	}

	// seal_dodamage
	void OnSealDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnApplyElementDot(target);
		MISS_COUNT = 0.0f;
	}

	// apply_element_dot
	// <target> [element]
	void OnApplyElementDot(CBaseEntity@ target = null, string element = "")
	{
		if (ELEMENT_TYPE == "ELEMENT_TYPE") // case I get jumped early
			OnPickElement();

		string elementType = ELEMENT_TYPE;
		string elementEffect = ELEMENT_EFFECT;
		int dotElement = DOT_ELEMENT;

		if (!element.isEmpty())
			elementType = element;

		if (elementType != ELEMENT_TYPE)
		{
			// element requested does not match current setting, find appropriate effect
			if (elementType == "fire")
			{
				elementEffect = "effects/dot_fire";
				dotElement = 100;
			}
			else if (elementType == "cold")
			{
				dotElement = 30;
			}
			else if (elementType == "lightning")
			{
				elementEffect = "effects/dot_lightning";
				dotElement = 75;
			}
			else if (elementType == "poison")
			{
				elementEffect = "effects/dot_poison";
				dotElement = 50;
			}
		}

		// cold has special handling below
		if (elementType != "cold")
			ApplyEffect(target, elementEffect, 5.0f, self, dotElement);
		else if (DamageTakenOf(target, "cold") < 0.75f)
			ApplyEffect(target, "effects/dot_cold", 5.0f, self, dotElement);
		else
			ApplyEffect(target, "effects/dot_cold_freeze", 5.0f, self, dotElement);
	}

	// pick_element
	// pick a random element
	void OnPickElement()
	{
		bool exitSub = false;

		if (RESTRICTED_ELEMENTS)
			ELEMENT_LIST = CUST_ELEMENT_LIST;
		else
			ELEMENT_LIST = "fire;cold;lightning;poison";

		float nElements = GetTokenCount(ELEMENT_LIST) - 1.0f;

		if (ELEMENT_IDX > nElements)
			ELEMENT_IDX = 0.0f;

		ELEMENT_TYPE = GetToken(ELEMENT_LIST, int(ELEMENT_IDX));

		if (ELEMENT_TYPE == "fire")
		{
			ELEMENT_COLOR = Vector3(255, 0, 0);
			ELEMENT_SEAL_IDX = 32;
			SOUND_ELEMENT_CHARGE = "magic/fireball_powerup.wav";
			SOUND_ELEMENT_FIRE = "magic/fireball_strike.wav";
			ELEMENT_EFFECT = "effects/dot_fire";
			DOT_ELEMENT = 100;
		}
		else if (ELEMENT_TYPE == "cold")
		{
			ELEMENT_COLOR = Vector3(128, 128, 255);
			ELEMENT_SEAL_IDX = 33;
			SOUND_ELEMENT_CHARGE = "magic/frost_reverse.wav";
			SOUND_ELEMENT_FIRE = "magic/ice_strike2.wav";
			DOT_ELEMENT = 30;
		}
		else if (ELEMENT_TYPE == "lightning")
		{
			ELEMENT_COLOR = Vector3(255, 255, 0);
			ELEMENT_SEAL_IDX = 34;
			SOUND_ELEMENT_CHARGE = "magic/bolt_start.wav";
			SOUND_ELEMENT_FIRE = "magic/bolt_end.wav";
			ELEMENT_EFFECT = "effects/dot_lightning";
			DOT_ELEMENT = 75;
		}
		else if (ELEMENT_TYPE == "poison")
		{
			ELEMENT_COLOR = Vector3(0, 255, 0);
			ELEMENT_SEAL_IDX = 35;
			SOUND_ELEMENT_CHARGE = "bullchicken/bc_attack1.wav";
			SOUND_ELEMENT_FIRE = "bullchicken/bc_attack3.wav";
			ELEMENT_EFFECT = "effects/dot_poison";
			DOT_ELEMENT = 50;
		}

		PROJ_ELEMENT_TYPE = ELEMENT_TYPE;

		if (TOGGLE_ADD)
		{
			TOGGLE_ADD = false;
			exitSub = true;
		}
		else
		{
			TOGGLE_ADD = true;
		}
		if (exitSub)
			return;

		ELEMENT_IDX += 1.0f;
	}

	// use_fire
	// add params
	// options to restrict elements
	void OnUseFire()
	{
		RESTRICTED_ELEMENTS = true;
		CUST_ELEMENT_LIST = TokenAdd(CUST_ELEMENT_LIST, "fire");
	}

	// use_cold
	void OnUseCold()
	{
		RESTRICTED_ELEMENTS = true;
		CUST_ELEMENT_LIST = TokenAdd(CUST_ELEMENT_LIST, "cold");
	}

	// use_lightning
	void OnUseLightning()
	{
		RESTRICTED_ELEMENTS = true;
		CUST_ELEMENT_LIST = TokenAdd(CUST_ELEMENT_LIST, "lightning");
	}

	// use_poison
	void OnUsePoison()
	{
		RESTRICTED_ELEMENTS = true;
		CUST_ELEMENT_LIST = TokenAdd(CUST_ELEMENT_LIST, "poison");
	}

	// ext_proj_elemental_hit
	// <origin> <element> - called by projectile
	void OnExtProjElementalHit(Vector3 origin = Vector3(), string element = "")
	{
		CUR_PROJ_ELEMENT = element;
		string dmgType = CUR_PROJ_ELEMENT + "_effect";
		DoDamageEx(origin, 128, DMG_PROJECTILE, 0.1f, ENT_ME, ENT_ME, "none", dmgType, "dmgevent:proj");
	}

	// proj_dodamage
	void OnProjDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnApplyElementDot(target, CUR_PROJ_ELEMENT);
	}

	// skeleton_wakeup_call
	// =================== Copy pasta'd from skeletal archer, but untested
	// ms_npcscript event - wake up all sleeping skeles
	void OnSkeletonWakeupCall()
	{
		OnSkeletonWakeUp();
	}

	// make_sleeper
	// additional parameter - play dead until player near
	void OnMakeSleeper()
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		SetInvincible(true);
		SetMoveDest("none");
		OnNpcatkSuspendAi();
		NPC_PROXACT_TRIPPED = false;
		NPC_PROXACT_IFSEEN = false;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "128";
		NPC_PROXACT_EVENT = "skeleton_wake_up";
		NPC_PROXACT_FOV = false;
		PLAYING_DEAD = "1";

		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetIdleAnim(ANIM_DEATH_IDLE);
		SetMoveAnim(ANIM_DEATH_IDLE);
		PlayAnim("critical", ANIM_DEATH_IDLE);
	}

	// skele_target_disturber
	void OnSkeleTargetDisturber()
	{
		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkSettarget(EntityId(NPC_PROXACT_PLAYERID));
		@NPC_PROXACT_PLAYERID = null;
	}

	// skeleton_wake_up
	void OnSkeletonWakeUp()
	{
		SKELE_FIRST_RAISE = true;
		OnSkeleRebirth();
	}

	// skele_hide_name
	void OnSkeleHideName()
	{
		SKELE_ORG_NAME = Eval("game.monster.name.full");
		SetRace("none");
		SetName("");
	}

	// skele_refresh_name
	void OnSkeleRefreshName()
	{
		if (SKELE_ORG_NAME != "SKELE_ORG_NAME")
		{
			SetName(SKELE_ORG_NAME);
			SetRace("undead");
		}
	}

	// make_deep_sleeper
	// additional paramater - play dead until awakened via event
	void OnMakeDeepSleeper()
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		PLAYING_DEAD = "1";
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetMoveDest("none");
		SKELE_FIRST_RAISE = true;
		SetIdleAnim(ANIM_DEATH_IDLE);
		SetMoveAnim(ANIM_DEATH_IDLE);
		PlayAnim("critical", ANIM_DEATH_IDLE);
		OnNpcatkSuspendAi();
		SetInvincible(true);
	}

	// skele_stone_sleep
	void OnSkeleStoneSleep()
	{
		SetHearingSensitivity(0);
		PLAYING_DEAD = "1";
		OnSkeleHideName();
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		SetMoveAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		SetAnimFrameRate(0);
		SetInvincible(true);
		SetRoam(false);
		OnNpcatkSuspendAi();
		PlayAnim("hold", ANIM_IDLE);
		SetMoveDest("none");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

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

	void OnSkeleRebirth() {} // skele_rebirth

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("magic/sps_fogfire.wav");
		Precache("magic/cold_breath.wav");
		Precache("magic/bolt_loop.wav");
		Precache("magic/flame_loop.wav");
		Precache("monsters/skeletonDX.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonMage_FirstThink();
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
		if (name == "apply_element_dot") { OnApplyElementDot(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "ext_proj_elemental_hit") { OnExtProjElementalHit(Vec(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "frame_kick_land") { OnFrameKickLand(); return true; }
		if (name == "frame_kick_start") { OnFrameKickStart(); return true; }
		if (name == "frame_projectile_fire") { OnFrameProjectileFire(); return true; }
		if (name == "frame_projectile_start") { OnFrameProjectileStart(); return true; }
		if (name == "frame_seal_create") { OnFrameSealCreate(); return true; }
		if (name == "frame_seal_start") { OnFrameSealStart(); return true; }
		if (name == "frame_slam") { OnFrameSlam(); return true; }
		if (name == "frame_swipe") { OnFrameSwipe(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "kick_dodamage") { OnKickDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "make_deep_sleeper") { OnMakeDeepSleeper(); return true; }
		if (name == "make_sleeper") { OnMakeSleeper(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_element") { OnPickElement(); return true; }
		if (name == "proj_dodamage") { OnProjDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "reduce_xp_by_element") { OnReduceXpByElement(); return true; }
		if (name == "seal_dodamage") { OnSealDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "skele_hide_name") { OnSkeleHideName(); return true; }
		if (name == "skele_refresh_name") { OnSkeleRefreshName(); return true; }
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		if (name == "skele_stone_sleep") { OnSkeleStoneSleep(); return true; }
		if (name == "skele_target_disturber") { OnSkeleTargetDisturber(); return true; }
		if (name == "skeleton_attribs") { OnSkeletonAttribs(); return true; }
		if (name == "skeleton_wake_up") { OnSkeletonWakeUp(); return true; }
		if (name == "skeleton_wakeup_call") { OnSkeletonWakeupCall(); return true; }
		if (name == "slam_dodamage") { OnSlamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swipe_dodamage") { OnSwipeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "update_cl_fx") { OnUpdateClFx(); return true; }
		if (name == "use_cold") { OnUseCold(); return true; }
		if (name == "use_fire") { OnUseFire(); return true; }
		if (name == "use_lightning") { OnUseLightning(); return true; }
		if (name == "use_poison") { OnUsePoison(); return true; }
		return BasePain_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
