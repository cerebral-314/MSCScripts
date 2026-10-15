#pragma context server

// Converted from monsters/bludgeon_gaz_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BludgeonGazBase
{
	// Constants
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 1;
	int GOLD_PER_BAG = 50;
	int GOLD_RADIUS = 128;
	int GOLD_MAX_BAGS = 8;
	string ANIM_TRICK = "idle2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "longjump";
	string ANIM_THROW = "m_attack1";
	string ANIM_THROW_HOLD = "m_attack1";
	string ANIM_HAMMER = "m_attack2";
	string ANIM_WARCRY = "warcry";
	int LEAP_RANGE = 220;
	int STEP_SIZE_NORM = 48;
	float FREQ_IDLE = 0.0f;
	float FREQ_LEAP = 10.0f;
	float FREQ_THROW = 0.0f;
	float FREQ_JUMP = 0.0f;
	float FREQ_STOMP = 0.0f;
	float FREQ_CHARGE = 0.0f;
	int DMG_SWING = 0;
	int DMG_STUN = 0;
	float DOT_BURN = 0.0f;
	float DOT_POISON = 0.0f;
	int DMG_CHARGE = 0;
	int DMG_THROW = 80;
	string CHANCE_STUN = "10%";
	string SOUND_LEAP = "monsters/bludgeon/bludgeonattack2.wav";
	string SOUND_WARCRY = "monsters/bludgeon/bludgeon_gaz_bat2.wav";
	string SOUND_ALERT = "monsters/bludgeon/bludgeon_gaz_bat1.wav";
	string SOUND_SWING_MISS = "zombie/claw_miss2.wav";
	string SOUND_SWING_HIT = "zombie/claw_strike1.wav";
	string SOUND_ATTACK1 = "monsters/bludgeon/bludgeon_gaz_atk1.wav";
	string SOUND_ATTACK2 = "monsters/bludgeon/bludgeon_gaz_atk2.wav";
	string SOUND_ATTACK3 = "monsters/bludgeon/bludgeon_gaz_atk3.wav";
	string SOUND_THROW = "monsters/bludgeon/bludgeon_gaz_snort.wav";
	string SOUND_DEATH = "monsters/bludgeon/bludgeon_gaz_death.wav";
	string SOUND_IDLE1 = "monsters/bludgeon/bludgeon_gaz_ask.wav";
	string SOUND_IDLE2 = "monsters/bludgeon/bludgeon_gaz_answer.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_PAIN = "monsters/bludgeon/bludgeon_gaz_pain.wav";
	string SOUND_SPELL = "monsters/bludgeon/bludgeon_gaz_spell.wav";
	string SOUND_SNORT = "monsters/bludgeon/bludgeon_gaz_snort.wav";
	string SOUND_STEP1 = "gonarch/gon_step1.wav";
	string SOUND_STEP2 = "gonarch/gon_step2.wav";
	string SOUND_LAND = "garg/gar_step2.wav";
	string SOUND_CHARGE_START = "monsters/bludgeon/bludgeon_gaz_snort.wav";
	string SOUND_CHARGE_GO = "monsters/bludgeon/bludgeondeath2.wav";
	string SOUND_BURN = "ambience/steamburst1.wav";
	string MONSTER_MODEL = "monsters/bludgeon_gaz.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float SWING_STEP = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool IS_UNHOLY = false;
	bool DID_WARCRY = false;
	bool CHARGE_DELAY = false;
	string CHARGE_TARGET = "CHARGE_TARGET";
	float AS_ATTACKING = 0.0f;
	bool LEAP_DELAY = false;
	float THROW_DELAY = 0.0f;
	bool THROWING_AXE = false;
	string MY_AXE = "MY_AXE";
	Vector3 CHARGE_DEST = Vector3();
	float CHARGE_COUNT = 0.0f;
	bool AM_CHARGING = false;
	string CHARGE_LIST = "CHARGE_LIST";
	bool SWING_ATTACK = false;
	bool AM_DEMON = false;
	bool AM_HAMMER = false;
	bool CYCLES_STARTED = false;
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string POISON_TARGETS = "POISON_TARGETS";

	// unnamed block (first think)
	void BludgeonGazBase_FirstThink()
	{
		// anims used by base
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "m_attack1";
		ANIM_FLINCH = "flinch2";
		ANIM_DEATH = "death";
	}

	// unnamed block (first think)
	void BludgeonGazBase_FirstThink2()
	{
		// stats used by base
		ATTACK_MOVERANGE = 48.0f;
		ATTACK_RANGE = 110.0f;
		ATTACK_HITRANGE = 180.0f;
		CAN_FLINCH = "1";
		ATTACK_HITCHANCE = "80";
	}

	// npc_spawn
	void BludgeonGazBase_OnNpcSpawn(string npc = "")
	{
		SetModel(MONSTER_MODEL);
		SetWidth(32);
		SetHeight(96);

		if (!Truthy(GetVar("AM_MINI")))
			SetName("Bludgeon");
		if (Truthy(GetVar("AM_MINI")))
			SetName("Young Bludgeon");
		if (!AM_HAMMER)
			OnAxeMode();
		if (AM_HAMMER)
			OnHammerMode();
		SetDamageTaken("all", 0.6f);
		SetRace("demon");
		SetRoam(true);
		SetHearingSensitivity(4);
		SWING_STEP = 0.0f;

		if (AM_DEMON)
			OnDemonMode();
		if (Truthy(GetVar("AM_CORRUPT")))
			OnCorruptMode();
	}

	// axe_mode
	void BludgeonGazBase_OnAxeMode()
	{
		SetHealth(2000);
		DebugPrint("Axer");
		NPC_GIVE_EXP = 450.0f;
		SetModelBody(4, 1);
	}

	// hammer_mode
	void BludgeonGazBase_OnHammerMode()
	{
		SetHealth(3000);
		DebugPrint("Hammah");
		NPC_GIVE_EXP = 550.0f;
		SetModelBody(4, 2);
	}

	// demon_mode
	void BludgeonGazBase_OnDemonMode()
	{
		if (!NPC_CUSTOM_NAME)
		{
			if (!Truthy(GetVar("AM_MINI")))
				SetName("Demon Bludgeon");
			if (Truthy(GetVar("AM_MINI")))
				SetName("Young Demon Bludgeon");
		}
		SetProp(ENT_ME, "skin", 1);
		IS_UNHOLY = true;
		SetDamageTaken("all", 0.4f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 0.25f);
		NPC_GIVE_EXP *= 3.0f;
	}

	// corrupt_mode
	void BludgeonGazBase_OnCorruptMode()
	{
		if (!NPC_CUSTOM_NAME)
		{
			if (!Truthy(GetVar("AM_MINI")))
				SetName("Corrupted Bludgeon");
			if (Truthy(GetVar("AM_MINI")))
				SetName("Young Corrupted Bludgeon");
		}
		SetProp(ENT_ME, "skin", 2);
		IS_UNHOLY = true;
		SetDamageTaken("all", 0.4f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 0.25f);
		NPC_GIVE_EXP *= 3.0f;
		CallEventDelayed(0.1f, "poison_aura");
		CallEventDelayed(0.1f, "poison_aura_scan");
	}

	// npc_post_spawn
	void BludgeonGazBase_OnNpcPostSpawn()
	{
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		if (AM_HAMMER)
			ANIM_ATTACK = ANIM_HAMMER;
	}

	// npc_targetsighted
	void BludgeonGazBase_OnNpcTargetsighted(string target = "")
	{
		bool exitSub = false;

		if (I_R_FROZEN)
			return;

		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			int warcryType = RandomInt(1, 2);
			if (warcryType == 1)
			{
				PlayAnim("critical", "warcry");
				PlaySound(0, 10, SOUND_WARCRY);
			}
			if (warcryType == 2)
				PlaySound(0, 10, SOUND_ALERT);

			if (!AM_HAMMER)
			{
				// axers don't open with charge, since they can throw
				CHARGE_DELAY = true;
				CallEventDelayed(FREQ_CHARGE, "reset_charge_delay");
			}
		}

		float targetRange = RangeTo(NPCATK_TARGET);

		if (!(targetRange > ATTACK_RANGE))
			return;

		if (!CHARGE_DELAY && !I_R_FROZEN)
		{
			CHARGE_TARGET = NPCATK_TARGET;
			AS_ATTACKING = GameTime() + 20.0f;
			CHARGE_DELAY = true;
			CallEventDelayed(FREQ_CHARGE, "reset_charge_delay");
			OnNpcatkSuspendAi();
			SetMoveAnim("charge_start");
			SetIdleAnim("charge_start");
			PlayAnim("critical", "charge_start");
			CallEventDelayed(1.0f, "do_charge");
			PlaySound(0, 10, SOUND_CHARGE_START);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (targetRange < LEAP_RANGE && !THROWING_AXE && !LEAP_DELAY && !AM_CHARGING)
		{
			LEAP_DELAY = true;
			CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
			AS_ATTACKING = GameTime() + 20.0f;
			PlaySound(0, 10, SOUND_LEAP);
			SetMoveAnim(ANIM_LEAP);
			PlayAnim("critical", ANIM_LEAP);
		}

		if (targetRange > LEAP_RANGE && !AM_HAMMER && int(THROW_DELAY) == 0)
		{
			THROW_DELAY = 1.0f;
			AS_ATTACKING = GameTime() + 20.0f;
			THROWING_AXE = true;
			PlaySound(0, 10, SOUND_THROW);
			OnNpcatkSuspendAi();
			SetIdleAnim(ANIM_THROW_HOLD);
			SetMoveAnim(ANIM_THROW_HOLD);
			SetRoam(false);
			PlayAnim("break");
			PlayAnim("hold", ANIM_THROW);
			CallEventDelayed(0.5f, "throw_axe");
		}
	}

	// throw_axe
	void BludgeonGazBase_OnThrowAxe()
	{
		SetModelBody(4, 0);
		Vector3 targDest = OriginOf(NPCATK_TARGET);
		targDest += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, ATTACK_RANGE, 0));
		Vector3 traceStart = MyOrigin();
		traceStart.z += 32.0f;
		string traceTarg = LegacyFunction("get_traceline", traceStart, "TARGET_DEST", "worldonly");
		string traceDest = traceTarg;
		if (!IsPlayer(NPCATK_TARGET))
			targDest.z += HeightOf(NPCATK_TARGET);
		CreateNpc("monsters/summon/bludgeon_axe", RelativePosition(Vector3(0, 40, 48)), self, targDest, DMG_THROW);
		MY_AXE = ENT_LASTCREATED;
		OnThrowAxeLoop();
	}

	// throw_axe_loop
	void BludgeonGazBase_OnThrowAxeLoop()
	{
		if (!THROWING_AXE)
			return;
		SetMoveDest(MY_AXE, 9999);
		CallEventDelayed(0.1f, "throw_axe_loop");
	}

	// reset_throw_delay
	void BludgeonGazBase_OnResetThrowDelay()
	{
		THROW_DELAY = 0.0f;
	}

	// do_charge
	void BludgeonGazBase_OnDoCharge()
	{
		SetMoveSpeed(3);
		CHARGE_DEST = OriginOf(CHARGE_TARGET);
		CHARGE_DEST += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 256, 0));
		SetMoveAnim("charge");
		SetIdleAnim("charge");
		CHARGE_COUNT = 0.0f;
		AM_CHARGING = true;
		PlaySound(0, 10, SOUND_CHARGE_GO);
		OnChargeLoop();
	}

	// charge_loop
	void BludgeonGazBase_OnChargeLoop()
	{
		int count;
		CHARGE_COUNT += 1.0f;
		SetMoveDest(CHARGE_DEST, 20);
		if (CHARGE_COUNT == 30.0f)
			OnEndCharge();

		if (Distance(CHARGE_DEST, MyOrigin()) < ATTACK_MOVERANGE)
			OnEndCharge();

		if (!AM_CHARGING)
			return;
		// dodamage $relpos(0,32,0) 96 0 100% 0.0 reflective target
		CallEventDelayed(0.1f, "charge_loop");

		Vector3 scanLoc = RelativePosition(Vector3(0, 32, 0));
		CHARGE_LIST = LegacyFunction("get_tsphere", "enemy", 96, scanLoc);
		if (CHARGE_LIST != "none")
		{
			PlaySound(0, 10, SOUND_STRUCK1);
			count = GetTokenCount(CHARGE_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnChargeAffectTargets();
			}
		}
	}

	// charge_affect_targets
	void BludgeonGazBase_OnChargeAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(CHARGE_LIST, loopIteration));
		float lrRand = Random(-200, 200);
		AddVelocity(curTarg, RelativeVelocity(Vector3(lrRand, 600, 110)));
		// applyeffect CUR_TARG effects/generic_damage DMG_CHARGE $get(ent_me,id) 0 blunt
		DoDamage(curTarg, "direct", DMG_CHARGE, "100%", ENT_ME, "blunt");
	}

	// end_charge
	void BludgeonGazBase_OnEndCharge()
	{
		AM_CHARGING = false;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetMoveSpeed(1);
		OnNpcatkResumeAi();
	}

	// swing_dodamage
	void BludgeonGazBase_OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (AM_DEMON)
			ApplyEffect(target, "effects/dot_fire", 3, self, DOT_BURN);

		if (Truthy(GetVar("AM_CORRUPT")))
			ApplyEffect(target, "effects/dot_poison", 10.0f, self, DOT_POISON);

		if (SWING_ATTACK)
		{
			if (!hit)
				PlaySound(0, 10, SOUND_SWING_MISS);
			if (hit)
			{
				PlaySound(0, 10, SOUND_SWING_HIT);
				AddVelocity(target, RelativeVelocity(Vector3(-100, 130, 120)));
				SWING_ATTACK = false;
			}
		}

		if (AM_HAMMER && hit && RandomInt(1, 100) < Float(CHANCE_STUN) && RangeTo(target) < ATTACK_HITRANGE)
		{
			ApplyEffect(target, "effects/debuff_stun", 5, self);
			PlaySound(0, 10, SOUND_SNORT);
		}
	}

	// reset_charge_delay
	void BludgeonGazBase_OnResetChargeDelay()
	{
		CHARGE_DELAY = false;
	}

	// reset_leap_delay
	void BludgeonGazBase_OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// game_struck
	void BludgeonGazBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN);
	}

	// unnamed block (timer)
	void BludgeonGazBase_Timer()
	{
		CallEventDelayed(FREQ_IDLE, "BludgeonGazBase_Timer");

		if (NPCATK_TARGET != "unset")
			return;

		int rndIdle = RandomInt(1, 2);
		if (rndIdle == 1)
		{
			PlaySound(0, 10, SOUND_IDLE1);
			PlayAnim("critical", ANIM_TRICK);
		}

		if (rndIdle == 2)
		{
			PlaySound(0, 10, SOUND_IDLE2);
			PlayAnim("critical", ANIM_WARCRY);
		}
	}

	// ext_bd_toggle
	// model debugarry
	void BludgeonGazBase_OnExtBdToggle()
	{
		bool exitSub = false;
		if (SUSPEND_AI)
		{
			SetRoam(true);
			OnNpcatkResumeAi();
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!SUSPEND_AI)
		{
			SetRoam(false);
			OnNpcatkSuspendAi();
		}
	}

	// ext_follow
	void BludgeonGazBase_OnExtFollow(string target = "")
	{
		SetMoveDest(target, ATTACK_MOVERANGE);
	}

	// ext_playanim
	void BludgeonGazBase_OnExtPlayanim(string animation = "")
	{
		PlayAnim("critical", animation);
	}

	// ext_demon
	void BludgeonGazBase_OnExtDemon(string skin = "")
	{
		AM_DEMON = true;
		SetProp(ENT_ME, "skin", skin);
	}

	// ext_hammer
	void BludgeonGazBase_OnExtHammer()
	{
		AM_HAMMER = true;
		SetModelBody(4, 2);
	}

	// ext_axe
	void BludgeonGazBase_OnExtAxe()
	{
		AM_HAMMER = false;
		SetModelBody(4, 1);
	}

	// cycle_up
	void BludgeonGazBase_OnCycleUp(string reason = "")
	{
		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		OnJumpCheck();
	}

	// jump_check
	// jump at target if way above me
	void BludgeonGazBase_OnJumpCheck()
	{
		CallEventDelayed(FREQ_JUMP, "jump_check");

		if (NPCATK_TARGET == "unset")
			return;

		float targZ = OriginOf(NPCATK_TARGET).z;
		float myZ = MyOrigin().z;
		float zDiff = targZ - myZ;
		// dbg temp z_targ TARG_Z z_me MY_Z z_diff Z_DIFF
		if (!(zDiff > ATTACK_RANGE))
			return;
		OnNpcatkFaceattacker(NPCATK_TARGET);
		CallEventDelayed(0.1f, "do_jump");
		PlaySound(0, 10, SOUND_LEAP);
	}

	// do_jump
	void BludgeonGazBase_OnDoJump()
	{
		SetStepSize(1000);
		SetMoveAnim(ANIM_JUMP);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 800)));
		CallEventDelayed(0.5f, "push_forward");
		CallEventDelayed(1.0f, "jump_done");
	}

	// push_forward
	void BludgeonGazBase_OnPushForward()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// jump_done
	void BludgeonGazBase_OnJumpDone(string npc = "")
	{
		SetStepSize(STEP_SIZE_NORM);
		SetMoveAnim(ANIM_RUN);
	}

	// leap_land
	// anim events
	void BludgeonGazBase_OnLeapLand()
	{
		SetMoveAnim(ANIM_RUN);
		PlaySound(0, 10, SOUND_LAND);
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 128, 0, DMG_STUN);
	}

	// attack1
	void BludgeonGazBase_OnAttack1()
	{
		SWING_ATTACK = true;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWING, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:swing");
		if (THROWING_AXE)
			SetAnimFrameRate(0.0001f);
	}

	// attack2
	void BludgeonGazBase_OnAttack2()
	{
		OnAttack1();
	}

	// walk_step
	void BludgeonGazBase_OnWalkStep()
	{
	}

	// run_step
	void BludgeonGazBase_OnRunStep()
	{
		PlaySound(0, 10, SOUND_STEP1, SOUND_STEP2);
	}

	// swing_start
	void BludgeonGazBase_OnSwingStart()
	{
		SWING_STEP += 1.0f;
		if (!(SWING_STEP > 2.0f))
			return;
		SWING_STEP = 0.0f;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// my_target_died
	void BludgeonGazBase_OnMyTargetDied(string offender = "")
	{
		PlayAnim("once", "warcry");
		PlaySound(0, 10, SOUND_SPELL);
	}

	// catch_axe
	// called extermally from bludgeon_axe upon return
	void BludgeonGazBase_OnCatchAxe()
	{
		OnNpcatkResumeAi();
		PlayAnim("break");
		SetRoam(true);
		THROWING_AXE = false;
		SetModelBody(4, 1);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		CallEventDelayed(FREQ_THROW, "reset_throw_delay");
		SetAnimFrameRate(1);
	}

	// chest_b_castle_bonus
	// external param
	void BludgeonGazBase_OnChestBCastleBonus()
	{
		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "100%";
		CONTAINER_SCRIPT = "chests/lostcaverns2";
	}

	// poison_aura
	void BludgeonGazBase_OnPoisonAura()
	{
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), 96, 19.0f);
		CallEventDelayed(20.0f, "poison_aura");
	}

	// poison_aura_scan
	void BludgeonGazBase_OnPoisonAuraScan()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.5f, "poison_aura_scan");
		if (NPCATK_TARGET == "unset")
			return;
		if (AM_CHARGING)
			return;
		POISON_TARGETS = FindInSphere("enemy", 96);
		if (POISON_TARGETS == "none")
			return;
		int count = GetTokenCount(POISON_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonAuraAffect();
		}
	}

	// poison_aura_affect
	void BludgeonGazBase_OnPoisonAuraAffect()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(POISON_TARGETS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, DOT_POISON);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BludgeonGazBase_OnNpcPostSpawn();
	}

	// ext_playanim
	void OnExtPlayanim(string animation = "")
	{
		MonstersExternals_OnExtPlayanim(animation); // monsters/externals
		BludgeonGazBase_OnExtPlayanim(animation);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BludgeonGazBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BludgeonGazBase_OnNpcSpawn(npc);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		BludgeonGazBase_OnMyTargetDied(offender);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		BludgeonGazBase_OnCycleUp(reason);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BludgeonGazBase_OnNpcTargetsighted(target);
	}

	void OnAxeMode() { BludgeonGazBase_OnAxeMode(); } // axe_mode
	void OnHammerMode() { BludgeonGazBase_OnHammerMode(); } // hammer_mode
	void OnDemonMode() { BludgeonGazBase_OnDemonMode(); } // demon_mode
	void OnCorruptMode() { BludgeonGazBase_OnCorruptMode(); } // corrupt_mode
	void OnThrowAxe() { BludgeonGazBase_OnThrowAxe(); } // throw_axe
	void OnThrowAxeLoop() { BludgeonGazBase_OnThrowAxeLoop(); } // throw_axe_loop
	void OnResetThrowDelay() { BludgeonGazBase_OnResetThrowDelay(); } // reset_throw_delay
	void OnDoCharge() { BludgeonGazBase_OnDoCharge(); } // do_charge
	void OnChargeLoop() { BludgeonGazBase_OnChargeLoop(); } // charge_loop
	void OnChargeAffectTargets() { BludgeonGazBase_OnChargeAffectTargets(); } // charge_affect_targets
	void OnEndCharge() { BludgeonGazBase_OnEndCharge(); } // end_charge
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { BludgeonGazBase_OnSwingDodamage(hit, target, start, end, damageType, damageText); } // swing_dodamage
	void OnResetChargeDelay() { BludgeonGazBase_OnResetChargeDelay(); } // reset_charge_delay
	void OnResetLeapDelay() { BludgeonGazBase_OnResetLeapDelay(); } // reset_leap_delay
	void OnExtBdToggle() { BludgeonGazBase_OnExtBdToggle(); } // ext_bd_toggle
	void OnExtFollow(string target = "") { BludgeonGazBase_OnExtFollow(target); } // ext_follow
	void OnExtDemon(string skin = "") { BludgeonGazBase_OnExtDemon(skin); } // ext_demon
	void OnExtHammer() { BludgeonGazBase_OnExtHammer(); } // ext_hammer
	void OnExtAxe() { BludgeonGazBase_OnExtAxe(); } // ext_axe
	void OnJumpCheck() { BludgeonGazBase_OnJumpCheck(); } // jump_check
	void OnDoJump() { BludgeonGazBase_OnDoJump(); } // do_jump
	void OnPushForward() { BludgeonGazBase_OnPushForward(); } // push_forward
	void OnJumpDone(string npc = "") { BludgeonGazBase_OnJumpDone(npc); } // jump_done
	void OnLeapLand() { BludgeonGazBase_OnLeapLand(); } // leap_land
	void OnAttack1() { BludgeonGazBase_OnAttack1(); } // attack1
	void OnAttack2() { BludgeonGazBase_OnAttack2(); } // attack2
	void OnWalkStep() { BludgeonGazBase_OnWalkStep(); } // walk_step
	void OnRunStep() { BludgeonGazBase_OnRunStep(); } // run_step
	void OnSwingStart() { BludgeonGazBase_OnSwingStart(); } // swing_start
	void OnCatchAxe() { BludgeonGazBase_OnCatchAxe(); } // catch_axe
	void OnChestBCastleBonus() { BludgeonGazBase_OnChestBCastleBonus(); } // chest_b_castle_bonus
	void OnPoisonAura() { BludgeonGazBase_OnPoisonAura(); } // poison_aura
	void OnPoisonAuraScan() { BludgeonGazBase_OnPoisonAuraScan(); } // poison_aura_scan
	void OnPoisonAuraAffect() { BludgeonGazBase_OnPoisonAuraAffect(); } // poison_aura_affect
	void OnFreqCharge() {} // FREQ_CHARGE
	void OnFreqJump() {} // FREQ_JUMP
	void OnFreqLeap() {} // FREQ_LEAP
	void OnFreqThrow() {} // FREQ_THROW

	// This file's events and timers by their .script names
	bool BludgeonGazBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "axe_mode") { OnAxeMode(); return true; }
		if (name == "catch_axe") { OnCatchAxe(); return true; }
		if (name == "charge_affect_targets") { OnChargeAffectTargets(); return true; }
		if (name == "charge_loop") { OnChargeLoop(); return true; }
		if (name == "chest_b_castle_bonus") { OnChestBCastleBonus(); return true; }
		if (name == "corrupt_mode") { OnCorruptMode(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "demon_mode") { OnDemonMode(); return true; }
		if (name == "do_charge") { OnDoCharge(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "end_charge") { OnEndCharge(); return true; }
		if (name == "ext_axe") { OnExtAxe(); return true; }
		if (name == "ext_bd_toggle") { OnExtBdToggle(); return true; }
		if (name == "ext_demon") { OnExtDemon(Param(params, 0)); return true; }
		if (name == "ext_follow") { OnExtFollow(Param(params, 0)); return true; }
		if (name == "ext_hammer") { OnExtHammer(); return true; }
		if (name == "ext_playanim") { OnExtPlayanim(Param(params, 0)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "hammer_mode") { OnHammerMode(); return true; }
		if (name == "jump_check") { OnJumpCheck(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "leap_land") { OnLeapLand(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "poison_aura") { OnPoisonAura(); return true; }
		if (name == "poison_aura_affect") { OnPoisonAuraAffect(); return true; }
		if (name == "poison_aura_scan") { OnPoisonAuraScan(); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "reset_charge_delay") { OnResetChargeDelay(); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		if (name == "reset_throw_delay") { OnResetThrowDelay(); return true; }
		if (name == "run_step") { OnRunStep(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swing_start") { OnSwingStart(); return true; }
		if (name == "throw_axe") { OnThrowAxe(); return true; }
		if (name == "throw_axe_loop") { OnThrowAxeLoop(); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		if (name == "BludgeonGazBase_Timer") { BludgeonGazBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bludgeon_gaz_base"]
shared class BludgeonGazBaseScript : BaseMonsterNewScript, BludgeonGazBase
{
	// Variables declared by included files, with the value they start with in this script
	BludgeonGazBaseScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_DEATH = "monsters/bludgeon/bludgeon_gaz_death.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("monsters/bludgeon_gaz.mdl");
		CallEventDelayed(FREQ_IDLE, "BludgeonGazBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BludgeonGazBase_FirstThink();
		BludgeonGazBase_FirstThink2();
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
		return BludgeonGazBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
