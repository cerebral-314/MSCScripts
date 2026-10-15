#pragma context server

// Converted from monsters/djinn_ogre_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DjinnOgreFire
{
	// Constants
	string ANIM_SEARCH = "idle_look";
	string ANIM_SWIPE = "attack1";
	string ANIM_HEADBUTT = "attack2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "jump";
	string ANIM_WARCRY = "warcry";
	string ANIM_BEAM = "beam";
	float ORC_HOP_DELAY = 1.0f;
	int ORC_JUMP_THRESH = 80;
	float DOT_FIRE = 20.0f;
	float DOT_FIRE_SPELL = 40.0f;
	float FREQ_SPECIAL = 0.0f;
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle2.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE5 = "bullchicken/bc_idle5.wav";
	string SOUND_DEATH = "bullchicken/bc_die1.wav";
	string SOUND_HEADBUTT = "bullchicken/bc_spithit1.wav";
	string SOUND_SWIPEHIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWIPEHIT2 = "zombie/claw_strike2.wav";
	string SOUND_SWIPEMISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPEMISS2 = "zombie/claw_miss2.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STEP1 = "player/pl_dirt1.wav";
	string SOUND_STEP2 = "player/pl_dirt2.wav";
	string SOUND_PAIN_WEAK = "bullchicken/bc_pain2.wav";
	string SOUND_PAIN_STRONG = "bullchicken/bc_pain1.wav";
	string SOUND_WARCRY = "bullchicken/bc_attackgrowl3.wav";
	string SOUND_LEAP = "bullchicken/bc_attackgrowl2.wav";
	string SOUND_LEAP_LAND = "weapons/g_bounce2.wav";
	string SOUND_FLINCH = "bullchicken/bc_pain3.wav";
	float WEAK_THRESHOLD = 1000.0f;
	string SWIPE_DAMAGE = "$rand(50,75)";
	string HEADBUTT_CHANCE = "100%";
	float HEADBUTT_FREQ = 7.0f;
	string HEADBUTT_DAMAGE = "$rand(50,75)";
	string LEAP_DAMAGE = "$rand(10,30)";
	string LEAP_STUNCHANCE = "30%";
	int LEAP_RANGE_TOOFAR = 512;
	int LEAP_RANGE_TOOCLOSE = 128;
	float FREQ_LEAP_AWAY = 0.0f;
	string ATTACK_HITCHANCE = "95%";
	string MONSTER_MODEL = "monsters/swamp_ogre.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_WALK_DEFAULT = "walk";
	string ANIM_RUN_DEFAULT = "run1";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NPC_GIVE_EXP = 0.0f;
	float LEAP_AWAY_INTERVAL = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_HEALTH = 0.0f;
	float RUN_STEP = 0.0f;
	float CUR_SPECIAL = 0.0f;
	bool DID_WARCRY = false;
	bool LEAP_ENABLED = false;
	bool HEADBUTT_DELAY = false;
	bool SWIPE_ATTACK = false;
	bool HEADBUTT_ON = false;
	float NEXT_DMG_LEAP_AWAY = 0.0f;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool SEARCH_ANIM_DELAY = false;
	bool ORC_JUMPING = false;
	bool NPC_FORCED_MOVEDEST = false;
	float NEXT_SPECIAL = 0.0f;
	bool DOING_FIRE_BURST = false;
	string BURST_TARGS = "BURST_TARGS";
	bool DOING_FIRE_STORM = false;
	float BREATH_ANG = 0.0f;
	float BREATH_COUNT = 0.0f;
	bool FIRE_BREATH_ON = false;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";
	bool CL_REFRESH_LOOP_ON = false;
	string CL_IDX = "CL_IDX";

	// unnamed block (first think)
	void DjinnOgreFire_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK_DEFAULT = "walk";
		ANIM_RUN_DEFAULT = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";

		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// unnamed block (first think)
	void DjinnOgreFire_FirstThink2()
	{
		NPC_GIVE_EXP = 1500.0f;
		LEAP_AWAY_INTERVAL = 500.0f; // leap away every time I loose this many HP (1/4th hp)

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 30;
		DROP_GOLD_MAX = 50;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "20%";
		FLINCH_DELAY = "10.0";
		FLINCH_HEALTH = 1500.0f;
	}

	// game_precache
	void DjinnOgreFire_OnGamePrecache()
	{
		PrecacheFile("monsters/djinn_ogre_fire_cl");
	}

	// npc_spawn
	void DjinnOgreFire_OnNpcSpawn(string npc = "")
	{
		SetName("Lesser Fire Djinn");
		SetHealth(2000);
		SetRace("orc");
		if (!START_SUSPEND)
			SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(2);
		SetBlood("green"); // check in code
		SetIdleAnim(ANIM_IDLE);

		SetProp(ENT_ME, "skin", 5);

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 0.5f);

		RUN_STEP = 0.0f;

		if (Truthy(GetVar("G_SHAD_PRESENT")))
		{
			SetRace("undead");
			SetProp(ENT_ME, "skin", 2);
		}
		else
		{
			SetRace("orc");
		}

		CUR_SPECIAL = 1.0f;

		if (!START_SUSPEND)
			CallEventDelayed(1.0f, "idle_sounds");
		CallEventDelayed(2.0f, "final_postspawn");
	}

	// npcatk_validatetarget
	// first spot
	void DjinnOgreFire_OnNpcatkValidatetarget(string target = "")
	{
		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
	}

	// my_target_died
	void DjinnOgreFire_OnMyTargetDied(string offender = "")
	{
		if (!CanSee("enemy"))
		{
			PlayAnim("critical", ANIM_WARCRY);
			PlaySound(0, 10, SOUND_WARCRY);
			DID_WARCRY = false;
			if (!LEAP_ENABLED)
				CallEventDelayed(1.0f, "enable_leap");
		}
	}

	// enable_leap
	void DjinnOgreFire_OnEnableLeap()
	{
		LEAP_ENABLED = true;
	}

	// npcatk_hunt
	void DjinnOgreFire_OnNpcatkHunt()
	{
		// regenerate
		if (MyHealth() < MyMaxHealth())
			GiveHealth(0.1f);

		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) <= LEAP_RANGE_TOOFAR))
			return;
		if (!(RangeTo(NPCATK_TARGET) > LEAP_RANGE_TOOCLOSE))
			return;
		if (!LEAP_ENABLED)
			return;

		if (DOING_FIRE_STORM)
			return;
		if (DOING_FIRE_BURST)
			return;

		LEAP_ENABLED = false;
		CallEventDelayed(5.0f, "enable_leap");
		OnScriptLeap(); // do not confused with model vent leap_attack
	}

	// script_leap
	void DjinnOgreFire_OnScriptLeap()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void DjinnOgreFire_OnLeapBoost()
	{
		if (I_R_FROZEN)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 100)));
	}

	// npc_selectattack
	void DjinnOgreFire_OnNpcSelectattack()
	{
		if (HEADBUTT_DELAY)
		{
			ANIM_ATTACK = ANIM_SWIPE;
		}
		else if (RandomInt(1, 100) < Float(HEADBUTT_CHANCE))
		{
			ANIM_ATTACK = ANIM_HEADBUTT;
			HEADBUTT_DELAY = true;
			CallEventDelayed(HEADBUTT_FREQ, "headbutt_reset");
		}
	}

	// headbutt_reset
	void DjinnOgreFire_OnHeadbuttReset()
	{
		HEADBUTT_DELAY = false;
	}

	// attack1
	void DjinnOgreFire_OnAttack1()
	{
		SWIPE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SWIPE_DAMAGE, ATTACK_HITCHANCE);
	}

	// attack2
	// headbut on frame 6 of attack2
	void DjinnOgreFire_OnAttack2()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), HEADBUTT_DAMAGE, ATTACK_HITCHANCE);
		HEADBUTT_ON = true;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string DjinnOgreFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (HEADBUTT_ON)
		{
			if (hit)
			{
				PlaySound(0, 10, SOUND_HEADBUTT);
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
			}
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			ANIM_ATTACK = ANIM_SWIPE;
			HEADBUTT_ON = false;
			exitSub = true;
		}
		if (exitSub)
			return result;

		// assumes swipe
		if (!SWIPE_ATTACK)
			return result;
		SWIPE_ATTACK = false;
		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
			AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(-100, 130, 120)));
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		}
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
		return result;
	}

	// game_struck
	// PARAM1 = damage
	void DjinnOgreFire_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (MyHealth() > WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_STRONG);
		if (MyHealth() <= WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_WEAK);

		if (DOING_FIRE_STORM)
			return;
		if (DOING_FIRE_BURST)
			return;

		if (damage > 200.0f)
		{
			// dbg leaping away due to damage
			if (GameTime() > NEXT_DMG_LEAP_AWAY)
			{
				NEXT_DMG_LEAP_AWAY = GameTime() + FREQ_LEAP_AWAY;
				OnLeapAway();
			}
		}
	}

	// leap_away
	void DjinnOgreFire_OnLeapAway(string target = "")
	{
		PlayAnim("critical", ANIM_LEAP);
		SetMoveDest(NPCATK_TARGET, 99999, "flee");
		CallEventDelayed(0.1f, "leap_boost");
		OnNpcatkSuspendAi("3.0");
	}

	// leap_attack
	// called from ANIM_LEAP at frame 28
	void DjinnOgreFire_OnLeapAttack()
	{
		PlaySound(0, 10, SOUND_LEAP);

		if (Truthy(LegacyFunction("cansee", "enemy", 128)))
		{
			OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), LEAP_DAMAGE, ATTACK_HITCHANCE);
			if (RandomInt(1, 100) < Float(LEAP_STUNCHANCE))
				ApplyEffect(EntityOf(ENT_LASTSEEN), "effects/debuff_stun", 5, self);
		}
	}

	// leap_done
	void DjinnOgreFire_OnLeapDone()
	{
		PlaySound(0, 10, SOUND_LEAP_LAND);
		SetMoveAnim(ANIM_RUN);
	}

	// npcatk_search_init_advanced
	void DjinnOgreFire_OnNpcatkSearchInitAdvanced()
	{
		if (SEARCH_ANIM_DELAY)
			return;
		NPC_DELAYING_UNSTUCK = "10.0";
		PlayAnim("critical", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
		SEARCH_ANIM_DELAY = true;
		CallEventDelayed(5.0f, "reset_search_anim");
	}

	// reset_search_anim
	void DjinnOgreFire_OnResetSearchAnim()
	{
		SEARCH_ANIM_DELAY = false;
	}

	// npc_flinch
	void DjinnOgreFire_OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// idle_sounds
	void DjinnOgreFire_OnIdleSounds()
	{
		CallEventDelayed(Random(3, 10), "idle_sounds");
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// run_step1
	// called from model during ANIM_RUN
	void DjinnOgreFire_OnRunStep1()
	{
		PlaySound(0, 5, SOUND_STEP1);
	}

	// run_step2
	// called from model during ANIM_RUN
	void DjinnOgreFire_OnRunStep2()
	{
		PlaySound(0, 5, SOUND_STEP2);
	}

	// npcatk_targetvalidate
	void DjinnOgreFire_OnNpcatkTargetvalidate(string target = "")
	{
		// if spotted player, start jump checks
		if (ORC_JUMPING)
			return;
		if (!IsPlayer(NPCATK_TARGET))
			return;
		ORC_JUMPING = true;
		CallEventDelayed(1.0f, "orc_jump_check");
	}

	// orc_jump_check
	void DjinnOgreFire_OnOrcJumpCheck()
	{
		if (!ORC_JUMPING)
			return;
		CallEventDelayed(ORC_HOP_DELAY, "orc_jump_check");

		if (IS_FLEEING)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		// jump at player if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > ORC_JUMP_THRESH)
			OnOrcHop();
	}

	// orc_hop
	void DjinnOgreFire_OnOrcHop()
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, 1);
		PlayAnim("critical", ANIM_LEAP);
		PlaySound(0, 10, SOUND_LEAP);
		int jumpHeight = RandomInt(550, 650);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// my_target_died
	void DjinnOgreFire_OnMyTargetDied_2(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		// stop jumping (saves CPU when monster idle)
		ORC_JUMPING = false;
	}

	// bo_zombie_mode
	void DjinnOgreFire_OnBoZombieMode()
	{
		OnNpcSuicide();
	}

	// cycle_up
	// ================ Fire bits
	void DjinnOgreFire_OnCycleUp(string reason = "")
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
	}

	// npc_targetsighted
	void DjinnOgreFire_OnNpcTargetsighted(string target = "")
	{
		bool exitSub = false;

		if (DOING_FIRE_STORM)
			return;
		if (DOING_FIRE_BURST)
			return;
		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;
		if (!(GameTime() > NEXT_SPECIAL))
			return;
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		if (CUR_SPECIAL > 3.0f)
			CUR_SPECIAL = 1.0f;
		if (CUR_SPECIAL == 3.0f && RangeTo(NPCATK_TARGET) < 512.0f)
		{
			OnDoFireBurst();
			CUR_SPECIAL += 1.0f;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CUR_SPECIAL == 2.0f && RangeTo(NPCATK_TARGET) < 512.0f)
		{
			OnDoFireBurst();
			CUR_SPECIAL += 1.0f;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CUR_SPECIAL == 1.0f && RangeTo(NPCATK_TARGET) < 256.0f)
		{
			OnDoFireStorm();
			CUR_SPECIAL += 1.0f;
			exitSub = true;
		}
		if (exitSub)
			return;
	}

	// do_fire_burst
	void DjinnOgreFire_OnDoFireBurst(Vector3 projectilePosition = Vector3())
	{
		DOING_FIRE_BURST = true;

		DoDamageEx(OriginOf(ENT_ME), 128, DOT_FIRE_SPELL, 0, ENT_ME, ENT_ME, "none", "fire_effect");

		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_WARCRY);
		PlayAnim("critical", ANIM_WARCRY);

		ClientEvent("new", "all", "effects/sfx_fire_burst", OriginOf(ENT_ME), 768, 1, Vector3(255, 128, 0));

		BURST_TARGS = FindInSphere("enemy", 768);
		if (BURST_TARGS == "none")
			return;

		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireBurstAffectTargets();
		}
		CallEventDelayed(1.5f, "end_fire_burst");
	}

	// end_fire_burst
	void DjinnOgreFire_OnEndFireBurst()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;

		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();

		DOING_FIRE_BURST = false;
	}

	// fire_burst_affect_targets
	void DjinnOgreFire_OnFireBurstAffectTargets()
	{
		int exitSub = 0;
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		if (IsPlayer(curTarg) && !IsOnGround(curTarg))
			exitSub = 0;
		if (exitSub != 0)
			return;
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE_SPELL);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// do_fire_storm
	void DjinnOgreFire_OnDoFireStorm()
	{
		DOING_FIRE_STORM = true;
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_BEAM);
		PlayAnim("critical", ANIM_WARCRY);
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;

		ClientEvent("update", "all", CL_IDX, "fire_storm_on");

		BREATH_ANG = AnglesOf(ENT_ME).y - 45.0f;
		if (BREATH_ANG < 0.0f)
			BREATH_ANG += 359.0f;
		BREATH_COUNT = 0.0f;

		CallEventDelayed(0.01f, "fire_breath_loop");
		FIRE_BREATH_ON = true;
		ServerPlaySound(1, 10, SOUND_BREATH);
	}

	// fire_breath_loop
	void DjinnOgreFire_OnFireBreathLoop()
	{
		int count;

		if (!DOING_FIRE_STORM)
			return;

		BREATH_COUNT += 1.0f;
		if (BREATH_COUNT == 45.0f)
			OnEndFireBreath();

		if (!(BREATH_COUNT < 45.0f))
			return;
		CallEventDelayed(0.05f, "fire_breath_loop");

		BREATH_ANG += 1.0f;
		if (BREATH_ANG > 359.0f)
			BREATH_ANG -= 359.0f;

		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, BREATH_ANG, 0), Vector3(0, 500, 0));
		SetMoveDest(facePos, 9999);

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.25f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 128, 0));
		CLOUD_TARGS = LegacyFunction("get_tbox", "enemy", 128, scanPoint);
		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBurnTargets();
			}
		}
	}

	// burn_targets
	void DjinnOgreFire_OnBurnTargets()
	{
		string curTarget = GetToken(CLOUD_TARGS, loopIteration);
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		ApplyEffect(curTarget, "effects/dot_fire", 10.0f, self, DOT_FIRE_SPELL);
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 800, 120)));
	}

	// end_fire_breath
	void DjinnOgreFire_OnEndFireBreath()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;

		ClientEvent("update", "all", CL_IDX, "fire_storm_off");
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		ServerPlaySound(1, 0, SOUND_BREATH);
		DOING_FIRE_STORM = false;
	}

	// final_postspawn
	void DjinnOgreFire_OnFinalPostspawn()
	{
		LEAP_AWAY_INTERVAL = HealthOf(ENT_ME) * 0.25f;

		// axe lesser from the name, if I'm ramped
		if (!(NPC_ADJ_LEVEL >= 2.0f))
			return;
		SetName("Fire Djinn");
	}

	// game_death
	void DjinnOgreFire_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (CL_IDX != "CL_IDX")
			ClientEvent("update", "all", CL_IDX, "end_fx");
	}

	// cycle_up
	void DjinnOgreFire_OnCycleUp_2(string reason = "")
	{
		if (CL_REFRESH_LOOP_ON)
			return;
		CL_REFRESH_LOOP_ON = true;
		OnRefreshClLoop();
	}

	// refresh_cl_loop
	void DjinnOgreFire_OnRefreshClLoop()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(10.0f, "refresh_cl_loop");
		if (CL_IDX != "CL_IDX")
			ClientEvent("update", "all", CL_IDX, "end_fx");

		ClientEvent("new", "all", "monsters/djinn_ogre_fire_cl", IndexOf(ENT_ME), 10.0f, DOING_FIRE_STORM);
		CL_IDX = LastClientScriptId();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { DjinnOgreFire_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DjinnOgreFire_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DjinnOgreFire_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DjinnOgreFire_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		DjinnOgreFire_OnNpcatkHunt();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		DjinnOgreFire_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DjinnOgreFire_OnMyTargetDied(offender);
		DjinnOgreFire_OnMyTargetDied_2(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnOgreFire_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		DjinnOgreFire_OnCycleUp(reason);
		DjinnOgreFire_OnCycleUp_2(reason);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		DjinnOgreFire_OnNpcSelectattack();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		DjinnOgreFire_OnNpcTargetsighted(target);
	}

	void OnNpcatkValidatetarget(string target = "") { DjinnOgreFire_OnNpcatkValidatetarget(target); } // npcatk_validatetarget
	void OnEnableLeap() { DjinnOgreFire_OnEnableLeap(); } // enable_leap
	void OnScriptLeap() { DjinnOgreFire_OnScriptLeap(); } // script_leap
	void OnLeapBoost() { DjinnOgreFire_OnLeapBoost(); } // leap_boost
	void OnHeadbuttReset() { DjinnOgreFire_OnHeadbuttReset(); } // headbutt_reset
	void OnAttack1() { DjinnOgreFire_OnAttack1(); } // attack1
	void OnAttack2() { DjinnOgreFire_OnAttack2(); } // attack2
	void OnLeapAway(string target = "") { DjinnOgreFire_OnLeapAway(target); } // leap_away
	void OnLeapAttack() { DjinnOgreFire_OnLeapAttack(); } // leap_attack
	void OnLeapDone() { DjinnOgreFire_OnLeapDone(); } // leap_done
	void OnNpcatkSearchInitAdvanced() { DjinnOgreFire_OnNpcatkSearchInitAdvanced(); } // npcatk_search_init_advanced
	void OnResetSearchAnim() { DjinnOgreFire_OnResetSearchAnim(); } // reset_search_anim
	void OnNpcFlinch(float damage = 0.0f) { DjinnOgreFire_OnNpcFlinch(damage); } // npc_flinch
	void OnIdleSounds() { DjinnOgreFire_OnIdleSounds(); } // idle_sounds
	void OnRunStep1() { DjinnOgreFire_OnRunStep1(); } // run_step1
	void OnRunStep2() { DjinnOgreFire_OnRunStep2(); } // run_step2
	void OnOrcJumpCheck() { DjinnOgreFire_OnOrcJumpCheck(); } // orc_jump_check
	void OnOrcHop() { DjinnOgreFire_OnOrcHop(); } // orc_hop
	void OnBoZombieMode() { DjinnOgreFire_OnBoZombieMode(); } // bo_zombie_mode
	void OnDoFireBurst(Vector3 projectilePosition = Vector3()) { DjinnOgreFire_OnDoFireBurst(projectilePosition); } // do_fire_burst
	void OnEndFireBurst() { DjinnOgreFire_OnEndFireBurst(); } // end_fire_burst
	void OnFireBurstAffectTargets() { DjinnOgreFire_OnFireBurstAffectTargets(); } // fire_burst_affect_targets
	void OnDoFireStorm() { DjinnOgreFire_OnDoFireStorm(); } // do_fire_storm
	void OnFireBreathLoop() { DjinnOgreFire_OnFireBreathLoop(); } // fire_breath_loop
	void OnBurnTargets() { DjinnOgreFire_OnBurnTargets(); } // burn_targets
	void OnEndFireBreath() { DjinnOgreFire_OnEndFireBreath(); } // end_fire_breath
	void OnFinalPostspawn() { DjinnOgreFire_OnFinalPostspawn(); } // final_postspawn
	void OnRefreshClLoop() { DjinnOgreFire_OnRefreshClLoop(); } // refresh_cl_loop
	void OnHeadbuttFreq() {} // HEADBUTT_FREQ
	void OnOrcHopDelay() {} // ORC_HOP_DELAY

	// This file's events and timers by their .script names
	bool DjinnOgreFire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire_burst") { OnDoFireBurst(Vec(Param(params, 0))); return true; }
		if (name == "do_fire_storm") { OnDoFireStorm(); return true; }
		if (name == "enable_leap") { OnEnableLeap(); return true; }
		if (name == "end_fire_breath") { OnEndFireBreath(); return true; }
		if (name == "end_fire_burst") { OnEndFireBurst(); return true; }
		if (name == "final_postspawn") { OnFinalPostspawn(); return true; }
		if (name == "fire_breath_loop") { OnFireBreathLoop(); return true; }
		if (name == "fire_burst_affect_targets") { OnFireBurstAffectTargets(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "headbutt_reset") { OnHeadbuttReset(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "leap_attack") { OnLeapAttack(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_done") { OnLeapDone(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "orc_jump_check") { OnOrcJumpCheck(); return true; }
		if (name == "refresh_cl_loop") { OnRefreshClLoop(); return true; }
		if (name == "reset_search_anim") { OnResetSearchAnim(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "script_leap") { OnScriptLeap(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/djinn_ogre_fire"]
shared class DjinnOgreFireScript : BaseMonsterNewScript, DjinnOgreFire
{
	// Variables every script that includes this file declares
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	bool START_SUSPEND = false;

	// Variables declared by included files, with the value they start with in this script
	DjinnOgreFireScript()
	{
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/swamp_ogre.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnOgreFire_FirstThink();
		DjinnOgreFire_FirstThink2();
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
		return DjinnOgreFire_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
