#pragma context server

// Converted from monsters/summon/doom_plant.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DoomPlant
{
	// Constants
	int PLANT_HITCHANCE = 95;
	string SHRUB_IDLE_ANIMS = "thornplant2_idle1_1;thornplant2_idle1_2;thornplant2_idle3_1;thornplant2_idle3_2;";
	string BUSH_IDLE_ANIMS = "thornplant2_2_idle1;thornplant2_2_idle2;thornplant2_2_idle3;thornplant2_2_idle4_1;thornplant2_2_idle4_2;";
	string TREE_IDLE_ANIMS = "thornplant2_3_idle1;thornplant2_3_idle2;thornplant2_3_idle3;thornplant2_3_idle4;thornplant2_3_idle5;";
	int MELE_RANGE = 96;
	float FREQ_GROW = 40.0f;
	float FREQ_SHOOT = 1.0f;
	float FREQ_SPORE = 10.0f;
	string MODEL_LEVEL1 = "monsters/dewm_shrub.mdl";
	string MODEL_LEVEL2 = "monsters/dewm_bush.mdl";
	string MODEL_LEVEL3 = "monsters/dewm_tree.mdl";
	string GIB_MODEL = "cactusgibs.mdl";
	string SOUND_GIB = "debris/bustflesh1.wav";
	string SOUND_SLASH = "zombie/claw_miss1.wav";
	string SOUND_SCRATCH = "headcrab/hc_attack1.wav";
	string SOUND_SPORE = "weapons/bow/crossbow.wav";
	string SOUND_GROW = "weapons/bow/stretch.wav";
	string SOUND_STRUCK1 = "weapons/xbow_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/xbow_hitbod2.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	string MY_DURATION = "MY_DURATION";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	bool IAM_SUMMONED = false;
	bool GROWING = false;
	bool FIRST_SET_DONE = false;
	bool REPULSE = false;
	int SCAN_RANGE = 0;
	float PLANT_LEVEL = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool SHOOTING = false;
	bool SHOOT_DELAY = false;
	float SPORE_DELAY = 0.0f;
	CBaseEntity@ ATTACK_TARGET = null;
	string SPORE_POISON_DMG = "SPORE_POISON_DMG";
	string ANIM_IDLE = "ANIM_IDLE";
	float NEXT_GROW = 0.0f;

	// game_dynamically_created
	// <owner> <base_dmg> [duration]
	void DoomPlant_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		bool exitSub = false;

		if (!IsAlive(creatorValue1))
		{
			// assume spanwed for testing
			MY_OWNER = EntityId(self);
			MY_DMG = "20";
			MY_DURATION = "";
			OWNER_ISPLAYER = "0";
			GAME_PVP = (IsPvp() ? 1 : 0);
			SetRace("demon");
			exitSub = true;
		}
		if (exitSub)
			return;

		IAM_SUMMONED = true;

		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		MY_DURATION = damage;

		OWNER_ISPLAYER = EntityId(EntityOf(creatorValue1));
		GAME_PVP = (IsPvp() ? 1 : 0);

		SetRace(RaceOf(creatorValue1));

		if (!MY_DURATION.isEmpty())
			CallEventOrDelay(MY_DURATION, "plant_die");
	}

	// game_spawn
	void DoomPlant_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetBlood("green");

		if (!Truthy(GetVar("START_STAGE")))
			OnSetupPlantLevel1();
		if (Float(GetVar("START_STAGE")) == 2.0f)
			OnSetupPlantLevel2();
		if (Float(GetVar("START_STAGE")) == 3.0f)
			OnSetupPlantLevel3();

		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("stun", 0);

		SetWidth(40);
		SetHeight(96);

		SetInvincible(true);

		SetHearingSensitivity(11);

		GROWING = true;
		SetSolid("none");
		SetBoundingBox("none");
		PlaySound(0, 10, SOUND_GROW);
		if (!Truthy(GetVar("START_STAGE")))
			PlayAnim("critical", "thornplant2_grow");
		if (Float(GetVar("START_STAGE")) == 2.0f)
			PlayAnim("critical", "thornplant2_2_grow");
		if (Float(GetVar("START_STAGE")) == 3.0f)
			PlayAnim("critical", "thornplant2_3_grow");
		FIRST_SET_DONE = false;
		CallEventDelayed(5.0f, "undo_invinc");
		REPULSE = true;
		OnRepulseLoop();
		OnSetNextGrow();

		SetBlood("green");

		CreateNpc("monsters/summon/ibarrier", MyOrigin(), self, 60, 1, 1, 1, 0, 1);
	}

	// game_postspawn
	void DoomPlant_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		if (IAM_SUMMONED)
			return;
		MY_OWNER = EntityId(self);
		MY_DMG = "20";
		MY_DURATION = "";
		OWNER_ISPLAYER = "0";
		GAME_PVP = (IsPvp() ? 1 : 0);
		SetRace("demon");
		bool exitSub = true;
	}

	// game_precache
	void DoomPlant_OnGamePrecache()
	{
	}

	// undo_invinc
	void DoomPlant_OnUndoInvinc()
	{
		OnEndRepulse();
		SetInvincible(false);
		SetSolid("box");
		SetBoundingBox("npcsize");
		FIRST_SET_DONE = true;
	}

	// repulse_loop
	void DoomPlant_OnRepulseLoop()
	{
		if (!REPULSE)
			return;
		CallEventDelayed(0.1f, "repulse_loop");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 96, 0.0f, "100%", 0.0f, "reflective", "target");
	}

	// end_repulse
	void DoomPlant_OnEndRepulse()
	{
		REPULSE = false;
	}

	// game_dodamage
	string DoomPlant_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!REPULSE)
			return result;
		if (target is self)
			return result;

		if (!(RangeTo(target) < 128.0f))
			return result;
		SetAngle("face", @target);
		float myYaw = MyAngles().y;
		SetAngle("face", Vector3(0, myYaw, 0));
		AddVelocity(target, RelativeVelocity(Vector3(0, 1000, 100)));
		return result;
	}

	// setup_plant_level1
	void DoomPlant_OnSetupPlantLevel1()
	{
		SetName("Doom Shrub");
		float fHp = Float(MY_DMG);
		if (MY_DMG == "MY_DMG") // MY_DMG hadn't parsed yet
			CallEventDelayed(0.1f, "setup_plant_level1");
		fHp *= 2.0f;
		if (NPC_HP_MULTI > 1.0f)
			fHp *= NPC_HP_MULTI;
		SetHealth(fHp);
		SetModel(MODEL_LEVEL1);
		if (FIRST_SET_DONE)
		{
			SetSolid("box");
			SetBoundingBox("npcsize");
			DebugPrint("set solid");
		}
		SCAN_RANGE = 96;
		PLANT_LEVEL = 1.0f;
		ANIM_ATTACK = "thornplant2_attack";
		ANIM_DEATH = "thornplant2_harvest";
		OnSelectIdleAnim();
		SetIdleAnim(ANIM_IDLE);
	}

	// setup_plant_level2
	void DoomPlant_OnSetupPlantLevel2()
	{
		SetName("Doom Bush");
		float fHp = Float(MY_DMG);
		fHp *= 10.0f;
		if (NPC_HP_MULTI > 1.0f)
			fHp *= NPC_HP_MULTI;
		SetHealth(fHp);
		SetModel(MODEL_LEVEL2);
		SetSolid("box");
		SetBoundingBox("npcsize");
		SCAN_RANGE = 512;
		PLANT_LEVEL = 2.0f;
		ANIM_ATTACK = "thornplant2_2_attack";
		ANIM_DEATH = "thornplant2_2_harvest";
		OnSelectIdleAnim();
		SetIdleAnim(ANIM_IDLE);
	}

	// setup_plant_level3
	void DoomPlant_OnSetupPlantLevel3()
	{
		SetName("Doom Tree");
		float fHp = Float(MY_DMG);
		fHp *= 50.0f;
		if (NPC_HP_MULTI > 1.0f)
			fHp *= NPC_HP_MULTI;
		SetHealth(fHp);
		SetModel(MODEL_LEVEL3);
		SetSolid("box");
		SetBoundingBox("npcsize");
		SCAN_RANGE = 1024;
		PLANT_LEVEL = 3.0f;
		ANIM_ATTACK = "thornplant2_3_attack";
		ANIM_DEATH = "thornplant2_3_harvest";
		OnSelectIdleAnim();
		SetIdleAnim(ANIM_IDLE);
	}

	// grow_done
	void DoomPlant_OnGrowDone()
	{
		GROWING = false;
		SHOOTING = false;
		SHOOT_DELAY = false;
		SPORE_DELAY = 0.0f;
		SetSolid("box");
		SetBoundingBox("npcsize");
	}

	// grow_next_level
	void DoomPlant_OnGrowNextLevel()
	{
		if (GROWING)
			return;

		if (!(GameTime() > NEXT_GROW))
			return;
		OnSetNextGrow();

		if (PLANT_LEVEL == 2.0f)
			CallEventDelayed(0.2f, "grow_level3");
		if (PLANT_LEVEL == 1.0f)
			CallEventDelayed(0.2f, "grow_level2");
		REPULSE = true;
		OnRepulseLoop();
		CallEventDelayed(1.0f, "end_repulse");
	}

	// grow_level2
	void DoomPlant_OnGrowLevel2()
	{
		SHOOTING = false;
		OnSetupPlantLevel2();
		GROWING = true;
		PlaySound(0, 10, SOUND_GROW);
		PlayAnim("critical", "thornplant2_2_grow");
	}

	// grow_level3
	void DoomPlant_OnGrowLevel3()
	{
		SHOOTING = false;
		OnSetupPlantLevel3();
		GROWING = true;
		PlaySound(0, 10, SOUND_GROW);
		PlayAnim("critical", "thornplant2_3_grow");
	}

	// attack_done
	// called from model
	void DoomPlant_OnAttackDone()
	{
		SHOOTING = false;
		if (PLANT_LEVEL == 1.0f)
			SHOOT_DELAY = false;
		if (PLANT_LEVEL > 1.0f)
			CallEventDelayed(FREQ_SHOOT, "reset_shoot_delay");
	}

	// unnamed block (timer)
	void DoomPlant_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(1.0f, "DoomPlant_Timer");

		// scan for enemies
		if (SHOOTING)
			return;
		if (GROWING)
			return;
		if (SHOOT_DELAY)
			return;

		CBaseEntity@ targetEnt = null;

		if (CanSee("enemy") && RangeTo(ENT_LASTSEEN) < SCAN_RANGE && !Truthy(ScriptVarOf(ENT_LASTSEEN, PLAYING_DEAD)))
			@targetEnt = EntityOf(ENT_LASTSEEN);

		if (targetEnt !is null)
		{
			if (Truthy(OWNER_ISPLAYER) && IsPlayer(targetEnt) && GAME_PVP == 0)
				exitSub = true;
			if (!exitSub)
				OnAttackTarget2(targetEnt);
		}
	}

	// attack_target
	void DoomPlant_OnAttackTarget2(CBaseEntity@ target = null)
	{
		if (SHOOT_DELAY)
			return;
		if (SHOOTING)
			return;
		if (I_R_FROZEN)
			return;
		SHOOT_DELAY = true;
		@ATTACK_TARGET = target;
		SetMoveDest(@ATTACK_TARGET, 9999);
		PlayAnim("critical", ANIM_ATTACK);
		SHOOTING = true;
		OnAttackLoop();
		if (PLANT_LEVEL != 3.0f)
			return;
		if (int(SPORE_DELAY) != 0)
			return;
		SPORE_DELAY = 1.0f;
		CallEventDelayed(FREQ_SPORE, "reset_spore_delay");
		OnFireSpore();
	}

	// attack_loop
	void DoomPlant_OnAttackLoop()
	{
		if (!SHOOTING)
			return;
		CallEventDelayed(0.5f, "attack_loop");

		SetMoveDest(@ATTACK_TARGET, 9999);

		if (!(RangeTo(ATTACK_TARGET) < SCAN_RANGE))
			return;

		if (PLANT_LEVEL == 1.0f)
		{
			PlaySound(0, 10, SOUND_SLASH);
			DoDamage(ATTACK_TARGET, SCAN_RANGE, MY_DMG, PLANT_HITCHANCE, "slash");
		}
		if (PLANT_LEVEL == 2.0f)
		{
			PlaySound(0, 10, SOUND_SLASH);
			DoDamage(ATTACK_TARGET, MELE_RANGE, MY_DMG, PLANT_HITCHANCE, "slash");

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_thorn", RelativePosition(Vector3(0, 32, -16)), @ATTACK_TARGET, 1000, MY_DMG, 0.1f, "none");
		}
		if (PLANT_LEVEL == 3.0f)
		{
			PlaySound(0, 10, SOUND_SLASH);
			DoDamage(ATTACK_TARGET, MELE_RANGE, MY_DMG, PLANT_HITCHANCE, "slash");
			TossProjectile("proj_thorn", RelativePosition(Vector3(0, 32, 16)), @ATTACK_TARGET, 1000, MY_DMG, 0.1f, "none");
			TossProjectile("proj_thorn", RelativePosition(Vector3(0, 32, 16)), @ATTACK_TARGET, 800, MY_DMG, 1, "none");
			if (RangeTo(ATTACK_TARGET) < MELE_RANGE && RandomInt(1, 10) == 1)
				ApplyEffect(ATTACK_TARGET, "effects/debuff_stun", 3.0f, self);
		}
	}

	// fire_spore
	void DoomPlant_OnFireSpore()
	{
		PlaySound(0, 10, SOUND_SPORE);
		float sporeDamage = Float(MY_DMG);
		sporeDamage *= 4.0f;
		SPORE_POISON_DMG = MY_DMG; // read by proj_spore
		TossProjectile("proj_spore", RelativePosition(Vector3(0, 32, 16)), @ATTACK_TARGET, 500, sporeDamage, 0.1f, "none");
	}

	// game_dodamage
	string DoomPlant_OnGameDodamage_2(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (PLANT_LEVEL == 1.0f && hit)
			PlaySound(0, 10, SOUND_SCRATCH);

		if (PLANT_LEVEL == 2.0f && hit && SHOOTING && RangeTo(ATTACK_TARGET) < MELE_RANGE)
			PlaySound(0, 10, SOUND_SCRATCH);

		if (PLANT_LEVEL == 3.0f && hit && SHOOTING && RangeTo(ATTACK_TARGET) < MELE_RANGE)
			PlaySound(0, 10, SOUND_SCRATCH);
		return result;
	}

	// reset_spore_delay
	void DoomPlant_OnResetSporeDelay()
	{
		SPORE_DELAY = 0.0f;
	}

	// reset_shoot_delay
	void DoomPlant_OnResetShootDelay()
	{
		SHOOT_DELAY = false;
	}

	// unnamed block (timer)
	void DoomPlant_Timer2()
	{
		CallEventDelayed(3.0f, "DoomPlant_Timer2");

		// idle anims
		if (SHOOTING)
			return;
		if (GROWING)
			return;
		OnSelectIdleAnim();
		PlayAnim("once", ANIM_IDLE);
	}

	// select_idle_anim
	void DoomPlant_OnSelectIdleAnim()
	{
		string idleAnims = "IDLE_ANIMS";
		if (PLANT_LEVEL == 1.0f)
			idleAnims = SHRUB_IDLE_ANIMS;
		if (PLANT_LEVEL == 2.0f)
			idleAnims = BUSH_IDLE_ANIMS;
		if (PLANT_LEVEL == 3.0f)
			idleAnims = TREE_IDLE_ANIMS;

		float nidleAnims = GetTokenCount(idleAnims) - 1.0f;
		int rndIdle = RandomInt(0, int(nidleAnims));
		ANIM_IDLE = GetToken(idleAnims, rndIdle);
	}

	// game_death
	void DoomPlant_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetAlive(true);
		GROWING = true;
		SetInvincible(true);
		PlayAnim("critical", ANIM_DEATH);
		// stop instantly re-growing
		OnSetNextGrow();
	}

	// shrink_done
	// called from model
	void DoomPlant_OnShrinkDone()
	{
		bool exitSub = false;

		GROWING = false;
		SHOOTING = false;
		SHOOT_DELAY = false;
		SPORE_DELAY = 0.0f;
		SetInvincible(false);
		REPULSE = true;
		OnRepulseLoop();
		CallEventDelayed(1.0f, "end_repulse");

		PLANT_LEVEL -= 1.0f;

		if (PLANT_LEVEL == 2.0f)
		{
			CallEventDelayed(0.1f, "setup_plant_level2");
			// if ( !OWNER_ISPLAYER ) callevent FREQ_GROW grow_next_level
			exitSub = true;
		}
		if (exitSub)
			return;

		if (PLANT_LEVEL == 1.0f)
		{
			CallEventDelayed(0.1f, "setup_plant_level1");
			// if ( !OWNER_ISPLAYER ) callevent FREQ_GROW grow_next_level
			exitSub = true;
		}
		if (exitSub)
			return;

		if (PLANT_LEVEL == 0.0f)
		{
			PlaySound(0, 10, SOUND_GIB);
			Effect("tempent", "gibs", GIB_MODEL, RelativePosition(Vector3(0, 0, 0)), 1.0f, 100, 30, 20, 4.0f);
			CallExternal(MY_OWNER, "plant_died");
			DebugPrint("died");
			SetSolid("none");
			SetBoundingBox("none");
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 0);
			SetModel("none");
			DeleteEntity(ENT_ME);
		}
	}

	// game_struck
	void DoomPlant_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// game_damaged
	string DoomPlant_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg temp game.monster.hp / game.monster.maxhp
		@ATTACK_TARGET = EntityOf(ENT_LASTSTRUCK); // 100% retaliate
		SetMoveDest(@EntityOf(ENT_LASTSTRUCK), 9999);
		if (SHOOTING)
			return result;
		if (PLANT_LEVEL > 1.0f)
			OnAttackTarget2(ATTACK_TARGET);
		return result;
	}

	// game_heardsound
	void DoomPlant_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (SHOOTING)
			return;
		if (GROWING)
			return;
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);

		if (RelationshipOf(lastHeard, MY_OWNER) != "enemy")
			return;
		SetMoveDest(@lastHeard, 9999);
		if (PLANT_LEVEL > 1.0f)
			OnAttackTarget2(lastHeard);
		if (PLANT_LEVEL == 1.0f && RangeTo(lastHeard) < MELE_RANGE)
			OnAttackTarget2(lastHeard);
	}

	// unnamed block (timer)
	void DoomPlant_Timer3()
	{
		CallEventDelayed(5.0f, "DoomPlant_Timer3");
		// check if can grow
		if (!(PLANT_LEVEL < 3.0f))
			return;
		OnGrowNextLevel();
	}

	// master_stuck
	void DoomPlant_OnMasterStuck()
	{
		if (!(RangeTo("MY_MASTER") < 256.0f))
			return;
		SetSolid("none");
		AddVelocity(MY_OWNER, RelativeVelocity(Vector3(0, 1000, 100)));
		CallEventDelayed(0.2f, "resume_solid");
	}

	// resume_solid
	void DoomPlant_OnResumeSolid()
	{
		SetSolid("box");
	}

	// set_next_grow
	void DoomPlant_OnSetNextGrow()
	{
		NEXT_GROW = GameTime() + FREQ_GROW;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DoomPlant_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		DoomPlant_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		DoomPlant_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
	}

	void OnGamePrecache() { DoomPlant_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		DoomPlant_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		DoomPlant_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	void OnUndoInvinc() { DoomPlant_OnUndoInvinc(); } // undo_invinc
	void OnRepulseLoop() { DoomPlant_OnRepulseLoop(); } // repulse_loop
	void OnEndRepulse() { DoomPlant_OnEndRepulse(); } // end_repulse

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, DoomPlant_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DoomPlant_OnGameDodamage_2(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnSetupPlantLevel1() { DoomPlant_OnSetupPlantLevel1(); } // setup_plant_level1
	void OnSetupPlantLevel2() { DoomPlant_OnSetupPlantLevel2(); } // setup_plant_level2
	void OnSetupPlantLevel3() { DoomPlant_OnSetupPlantLevel3(); } // setup_plant_level3
	void OnGrowDone() { DoomPlant_OnGrowDone(); } // grow_done
	void OnGrowNextLevel() { DoomPlant_OnGrowNextLevel(); } // grow_next_level
	void OnGrowLevel2() { DoomPlant_OnGrowLevel2(); } // grow_level2
	void OnGrowLevel3() { DoomPlant_OnGrowLevel3(); } // grow_level3
	void OnAttackDone() { DoomPlant_OnAttackDone(); } // attack_done
	void OnAttackTarget2(CBaseEntity@ target = null) { DoomPlant_OnAttackTarget2(target); } // attack_target
	void OnAttackLoop() { DoomPlant_OnAttackLoop(); } // attack_loop
	void OnFireSpore() { DoomPlant_OnFireSpore(); } // fire_spore
	void OnResetSporeDelay() { DoomPlant_OnResetSporeDelay(); } // reset_spore_delay
	void OnResetShootDelay() { DoomPlant_OnResetShootDelay(); } // reset_shoot_delay
	void OnSelectIdleAnim() { DoomPlant_OnSelectIdleAnim(); } // select_idle_anim
	void OnShrinkDone() { DoomPlant_OnShrinkDone(); } // shrink_done
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return DoomPlant_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { DoomPlant_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnMasterStuck() { DoomPlant_OnMasterStuck(); } // master_stuck
	void OnResumeSolid() { DoomPlant_OnResumeSolid(); } // resume_solid
	void OnSetNextGrow() { DoomPlant_OnSetNextGrow(); } // set_next_grow
	void OnFreqShoot() {} // FREQ_SHOOT
	void OnFreqSpore() {} // FREQ_SPORE
	void OnMyDuration() {} // MY_DURATION

	// This file's events and timers by their .script names
	bool DoomPlant_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_done") { OnAttackDone(); return true; }
		if (name == "attack_loop") { OnAttackLoop(); return true; }
		if (name == "attack_target") { OnAttackTarget2(EntityParam(params, 0)); return true; }
		if (name == "end_repulse") { OnEndRepulse(); return true; }
		if (name == "fire_spore") { OnFireSpore(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "grow_done") { OnGrowDone(); return true; }
		if (name == "grow_level2") { OnGrowLevel2(); return true; }
		if (name == "grow_level3") { OnGrowLevel3(); return true; }
		if (name == "grow_next_level") { OnGrowNextLevel(); return true; }
		if (name == "master_stuck") { OnMasterStuck(); return true; }
		if (name == "repulse_loop") { OnRepulseLoop(); return true; }
		if (name == "reset_shoot_delay") { OnResetShootDelay(); return true; }
		if (name == "reset_spore_delay") { OnResetSporeDelay(); return true; }
		if (name == "resume_solid") { OnResumeSolid(); return true; }
		if (name == "select_idle_anim") { OnSelectIdleAnim(); return true; }
		if (name == "set_next_grow") { OnSetNextGrow(); return true; }
		if (name == "setup_plant_level1") { OnSetupPlantLevel1(); return true; }
		if (name == "setup_plant_level2") { OnSetupPlantLevel2(); return true; }
		if (name == "setup_plant_level3") { OnSetupPlantLevel3(); return true; }
		if (name == "shrink_done") { OnShrinkDone(); return true; }
		if (name == "undo_invinc") { OnUndoInvinc(); return true; }
		if (name == "DoomPlant_Timer") { DoomPlant_Timer(); return true; }
		if (name == "DoomPlant_Timer2") { DoomPlant_Timer2(); return true; }
		if (name == "DoomPlant_Timer3") { DoomPlant_Timer3(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/doom_plant"]
shared class DoomPlantScript : BaseNpcScript, DoomPlant
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("cactusgibs.mdl");
		Precache("monsters/dewm_shrub.mdl");
		Precache("monsters/dewm_bush.mdl");
		Precache("monsters/dewm_tree.mdl");
		CallEventDelayed(1.0f, "DoomPlant_Timer");
		CallEventDelayed(3.0f, "DoomPlant_Timer2");
		CallEventDelayed(5.0f, "DoomPlant_Timer3");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DoomPlant_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
