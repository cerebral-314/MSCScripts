#pragma context server

// Converted from monsters/k_hollow_one.script by msc_transpiler.
// Kharaztorant Hollow One by Thothie
// level 35-40 mini-boss
// Should be mean enough not to require escort
// Remember: Thar can only be one (cuz he uses the player script)
// spinning flaming sprites that splode when near (monster npc, sprite via hollow's cl effect)
// cl guided fireball
// cl guided iceball (same thing, different sprite, aoe freeze solid)
// many tiny lil blue mists that move v. slow and drain mana until player dies (just to keep player movin)
// - these can be periodically called back en mass, moving quickly
// dodge with movement shift
// invisible+client mirror images
// flame face
// repel stun burst
// ibarrier
// hold person
// static field (constant, damages enemies in range)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/k_hollow_one"]
class KHollowOne : BaseMonsterNewScript
{
	// Constants
	string ANIM_FLOAT = "float";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "leap";
	string ANIM_PREP_DEPLOY = "ref_aim_trip";
	string ANIM_RELEASE_DEPLOY = "ref_shoot_trip";
	string ANIM_MIRROR_PREP = "ref_aim_grenade";
	string ANIM_ICE_SPIRAL = "ref_shoot_smartgun";
	string ANIM_FIRE_BREATH = "float";
	bool LHAND_ATCH = true;
	int RHAND_ATCH = 2;
	int MOUTH_ATCH = 3;
	int N_SPECIALS = 9;
	float MIRROR_DURATION = 60.0f;
	float FREQ_MIRROR = 120.0f;
	float FLIGHT_DURATION = 60.0f;
	float FREQ_FLIGHT = 90.0f;
	int FLIGHT_SPEED = 100;
	int MAX_DRAIN_SPRITES = 8;
	int DRAIN_SPRITE_SPEED = 25;
	float DRAINER_MAX_LIVE_TIME = 180.0f;
	int MP_DRAIN_RATE = -10;
	int DMG_FIREBALL = 300;
	int DMG_ICEBALL = 200;
	float DOT_ICE = 50.0f;
	float DOT_FIRE = 75.0f;
	int DOT_FIRE2 = 125;
	float DOT_POISON = 25.0f;
	float DMG_ZAP = 25.0f;
	float FREQ_DODGE = 0.0f;
	int SHIELD_RANGE = 80;
	string SOUND_SPELL_PREP = "magic/bolt_start.wav";
	string SOUND_FIRE_PREP = "magic/spookie1.wav";
	string SOUND_ICE_PREP = "magic/spookie1.wav";
	string SOUND_POP = "magic/elecidlepop.wav";
	string SOUND_FIREBALL_RELEASE = "ambience/alienflyby1.wav";
	string sOUND_MIRROR = "monsters/gonome/gonome_melee2.wav";
	string SOUND_MIRROR_OFF = "debris/beamstart15.wav";
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";
	string SOUND_POISON_BREATH = "magic/flame_loop.wav";
	string SOUND_POISON_BREATH_START = "magic/flame_loop_start.wav";
	string SOUND_DODGE = "magic/frost_reverse.wav";
	string SOUND_FLIGHT_START = "magic/vent3.wav";
	string SOUND_FLIGHT_LOOP = "magic/vent3.wav";
	float FREQ_SOUND_FLIGHT_LOOP = 5.92f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float N_DRAIN_SPRITES = 0.0f;
	float SPECIAL_CYCLE = 0.0f;
	string DRAINER_ROTATIONS = "DRAINER_ROTATIONS";
	string DRAINER_ALIVES = "DRAINER_ALIVES";
	string DRAINER_TARGS = "DRAINER_TARGS";
	string DRAINER_LOCS = "DRAINER_LOCS";
	string DRAINER_TIMES = "DRAINER_TIMES";
	string CL_IDX = "CL_IDX";
	float NEXT_SPECIAL = 0.0f;
	int DRAINER_INDEX = 0;
	string OUT_TARGET = "OUT_TARGET";
	float NEXT_ALERT = 0.0f;
	string BALL_TYPE = "BALL_TYPE";
	bool CFB_FIREBALL_ACTIVE = false;
	bool CFB_FIRST_TARGET_FOUND = false;
	Vector3 CFB_EST_ORG = Vector3();
	string CFB_EST_ANG = "CFB_EST_ANG";
	string CFB_FIREBALL_IDX = "CFB_FIREBALL_IDX";
	float CFB_FORCE_END = 0.0f;
	float CFB_NEXT_SCAN = 0.0f;
	CBaseEntity@ CFB_TARGET = null;
	string CFB_LIST = "CFB_LIST";
	bool MIRRORS_ON = false;
	float SPIN_ANG = 0.0f;
	float MIRROR_ANG = 0.0f;
	bool SPIN_ON = false;
	float SPIN_SPEED = 0.0f;
	float FADE_LEVEL = 0.0f;
	float NEXT_MIRROR = 0.0f;
	float ICE_DIST = 0.0f;
	float NEXT_SPIKE = 0.0f;
	string ICE_LIST = "ICE_LIST";
	bool FIRE_BREATH_ON = false;
	float NEXT_BURN = 0.0f;
	string BURN_LIST = "BURN_LIST";
	float NEXT_ZAP_SCAN = 0.0f;
	CBaseEntity@ ZAP_TARGET = null;
	float ZAP_TARG_RESIST = 0.0f;
	bool ZAP_ON = false;
	bool POISON_BREATH_ON = false;
	float NEXT_DODGE = 0.0f;
	string CL_IDX_SHADOW = "CL_IDX_SHADOW";
	int FLOAT_DIR = 0;
	bool FLIGHT_MODE = false;
	float NEXT_FLIGHT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	KHollowOne()
	{
		SOUND_DEATH = "x/x_pain3.wav";
	}

	// unnamed block (first think)
	void KHollowOne_FirstThink()
	{
		// base
		IS_UNHOLY = true;
		ANIM_IDLE = "idle";
		ANIM_DEATH = "die_forwards2";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		NPC_GIVE_EXP = 5000.0f;

		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 170.0f;
		ATTACK_MOVERANGE = 128.0f; // close, but don't go into melee
		NPC_RANGED = "1"; // treat as ranged (keep anti-stuck when close, etc.)
	}

	// game_precache
	void KHollowOne_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/client_side_fireball");
		PrecacheFile("monsters/summon/client_side_iceball");
	}

	// game_precache
	void KHollowOne_OnGamePrecache_2()
	{
		PrecacheFile("effects/sfx_motionblur_perm");
	}

	// npcatk_hunt
	void KHollowOne_OnNpcatkHunt()
	{
		if (SUSPEND_AI)
			return;

		if (NPCATK_TARGET != "unset")
		{
			if (GameTime() > NEXT_SPECIAL)
				OnDoSpecial();
			if (GameTime() > NEXT_ZAP_SCAN)
				OnZapScan();
		}
	}

	// unnamed block (timer)
	void KHollowOne_Timer()
	{
		CallEventDelayed(1.0f, "KHollowOne_Timer");
		if (N_DRAIN_SPRITES > 0.0f)
		{
			for (int i = 0; i < 8; i++)
			{
				loopIteration = i;
				OnTrackDrainSprites();
			}
		}
	}

	// npcatk_hunt
	void KHollowOne_OnNpcatkHunt_2()
	{
		if (IsAlive(ZAP_TARGET))
		{
			if (RangeTo(ZAP_TARGET) <= SHIELD_RANGE)
			{
				if (!ZAP_ON)
				{
					ServerPlaySound(2, 10, SOUND_ZAP_LOOP);
					PlaySound(0, 10, SOUND_ZAP_START);
					ZAP_TARG_RESIST = DamageTakenOf(ZAP_TARGET, "lightning");
					ClientEvent("update", "all", CL_IDX, "kh_zap_target_on", IndexOf(ZAP_TARGET));
				}

				ZAP_ON = true;
				DoDamage(ZAP_TARGET, "direct", DMG_ZAP, "100%", ENT_ME, "lightning_effect"); // no parry
				if (Random(0, 1) < ZAP_TARG_RESIST)
				{
					// addvelocity ZAP_TARGET $relvel(0,200,110)
					Vector3 targetOrg = OriginOf(ZAP_TARGET);
					float targAng = AnglesTo(MyOrigin(), targetOrg);
					int newYaw = int(targAng);
					AddVelocity(ZAP_TARGET, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 200, 110)));
				}
			}
			else
			{
				ZAP_ON = false;
				ServerPlaySound(2, 0, SOUND_ZAP_LOOP);
				ClientEvent("update", "all", CL_IDX, "kh_zap_target_off");
			}
		}
		else if (ZAP_ON)
		{
			ZAP_ON = false;
			ServerPlaySound(2, 0, SOUND_ZAP_LOOP);
			ClientEvent("update", "all", CL_IDX, "kh_zap_target_off");
		}
	}

	// game_damaged
	// ================================ SHADOW SHIFT ======================================
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string KHollowOne_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";

		if (!IsAlive(ENT_ME))
			return result;
		if (!(HealthOf(ENT_ME) > damage))
			return result;

		if (FLIGHT_MODE)
		{
			if (Contains(damageType, "effect"))
				exitSub = true;
			if (!exitSub && RandomInt(1, 10) == 1)
				OnNpcatkFlee(EntityId(attacker), "4096", "5.0");
		}

		if (FLIGHT_MODE) // no shadow dodging in flight
			return result;
		if (MIRRORS_ON) // no shadow dodging with mirrors up
			return result;
		if (POISON_BREATH_ON) // not during poison breath (cheap)
			return result;

		if (Contains(damageType, "effect")) // dont dodge for DOT
			exitSub = true;
		if (exitSub)
			return result;

		if (!(GameTime() > NEXT_DODGE))
			return result;
		NEXT_DODGE = GameTime() + FREQ_DODGE;

		ClientEvent("persist", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0, 0);
		CL_IDX_SHADOW = LastClientScriptId();

		float rndAng = Random(0, 359);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, rndAng, 0), Vector3(0, 1000, 0)));

		PlaySound(0, 10, SOUND_DODGE);

		CallEventDelayed(0.25f, "stop_shadow_shift");
		return result;
	}

	// npcatk_hunt
	void KHollowOne_OnNpcatkHunt_3()
	{
		if (!FLIGHT_MODE)
			return;

		Vector3 myPos = OriginOf(ENT_ME);
		string myUp = Text(myPos);
		myUp = Text(Vec(myUp) + Vector3(0.0f, 0.0f, 96.0f));
		string myDown = Text(myPos);
		myDown = Text(Vec(myDown) + Vector3(0.0f, 0.0f, -32.0f));
		string scanUp = LegacyFunction("get_traceline", myPos, myUp, "worldonly");
		string scanDown = LegacyFunction("get_traceline", myPos, myDown, "worldonly");

		FLOAT_DIR = 1;

		if (scanUp != myUp)
			FLOAT_DIR = -25;
		if (scanDown != myDown)
			FLOAT_DIR = 25;

		float maxHeight = GroundHeight(myPos) + 384.0f;
		if (myPos.z >= maxHeight)
			FLOAT_DIR = -25;

		// local MY_VEL $get(ent_me,velocity)
		// vectoradd MY_VEL $relvel(0,0,FLOAT_DIR)
		// setvelocity ent_me MY_VEL
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, FLOAT_DIR)));
	}

	// game_precache
	void OnGamePrecache()
	{
		KHollowOne_OnGamePrecache();
		KHollowOne_OnGamePrecache_2();
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (POISON_BREATH_ON)
			ServerPlaySound(1, 0, SOUND_POISON_BREATH);
		if (FIRE_BREATH_ON)
			ServerPlaySound(1, 0, SOUND_BREATH);
		// if ( MIRRORS_ON ) clientevent update all CL_IDX kh_mirrors_off
		// if ( FLIGHT_MODE ) clientevent update all CL_IDX kh_flight_sprites 0
		SetGravity(1);
		SetVelocity(ENT_ME, Vec(Text(0)));
		SetAnimMoveSpeed(0);
		ClientEvent("update", "all", CL_IDX, "kh_end_effects");
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		if (CFB_FIREBALL_ACTIVE)
			OnCfbExplode();
		CallExternal(GetVar("GAME_MASTER"), "gm_hollow_one_died", OriginOf(ENT_ME));
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		// not summoned, but for debuggary
		SPECIAL_CYCLE = Float(creatorValue1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Kharaztorant Hollow One");

		SetModel("monsters/hollow_one.mdl");
		SetWidth(32);
		SetHeight(80);
		SetIdleAnim("idle");
		SetMoveAnim("walk");

		SetHearingSensitivity(2);

		SetRoam(false);
		SetHealth(8000);
		SetRace("demon");
		SetDamageTaken("all", 0.4f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("poison", 0);

		OnNpcatkSuspendAttack(); // custom hunt system

		N_DRAIN_SPRITES = 0.0f;
		SPECIAL_CYCLE = 0.0f;

		DRAINER_ROTATIONS = "1;2;3;4;5;6;7;8";
		DRAINER_ALIVES = "0;0;0;0;0;0;0;0";
		DRAINER_TARGS = "1;2;3;4;5;6;7;8";
		DRAINER_LOCS = "1;2;3;4;5;6;7;8";
		DRAINER_TIMES = "1;2;3;4;5;6;7;8";

		CL_IDX = Eval("const.localplayer.scriptID"); // hope this "const" doesn't change :|
		ClientEvent("update", "all", CL_IDX, "kh_setup", IndexOf(ENT_ME));
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		KHollowOne_OnNpcatkHunt();
		KHollowOne_OnNpcatkHunt_2();
		KHollowOne_OnNpcatkHunt_3();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		// prevent "sticky noises"
		if (POISON_BREATH_ON)
			ServerPlaySound(1, 0, SOUND_POISON_BREATH);
		if (FIRE_BREATH_ON)
			ServerPlaySound(1, 0, SOUND_BREATH);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		SetRoam(false);
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
		SetRoam(true);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		SetRoam(true);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		OnNpcatkGoHome();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, KHollowOne_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_made_it_home
	void OnNpcMadeItHome()
	{
		SetRoam(false);
	}

	// do_special
	void OnDoSpecial()
	{
		NEXT_SPECIAL = GameTime() + 10.0f; // will reset when we know WHICH special

		SPECIAL_CYCLE += 1.0f;

		if (MIRRORS_ON)
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 1); // in case glow shell renders invis and fux up cl effects
		}

		if (SPECIAL_CYCLE > N_SPECIALS)
			SPECIAL_CYCLE = 1.0f;

		// create blue flame
		if (SPECIAL_CYCLE == 1.0f && N_DRAIN_SPRITES < MAX_DRAIN_SPRITES)
		{
			DebugPrint("do_special: spawn_drain_sprite");

			OnSpawnDrainSprite();
			NEXT_SPECIAL = GameTime() + 10.0f;
		}

		if (SPECIAL_CYCLE == 2.0f)
		{
			DebugPrint("do_special: fireball");

			OnPrepFireball();
			NEXT_SPECIAL = GameTime() + 25.0f; // will be reset when fireball expires/explodes
		}

		if (SPECIAL_CYCLE == 3.0f)
		{
			DebugPrint("do_special: iceball");

			OnPrepIceball();
			NEXT_SPECIAL = GameTime() + 25.0f; // will be reset when fireball expires/explodes
		}

		if (SPECIAL_CYCLE == 4.0f)
		{
			if (FLIGHT_MODE)
			{
				SPECIAL_CYCLE += 1.0f;
				NEXT_SPECIAL = GameTime();
			}
			if (!FLIGHT_MODE)
			{
				DebugPrint("do_special: fire breath");
				OnDoFireBreath(); // no prep, just go
				NEXT_SPECIAL = GameTime() + 10.0f;
			}
		}

		if (SPECIAL_CYCLE == 5.0f)
		{
			DebugPrint("do_special: ice spiral");
			OnPrepIceSpiral(); // no prep (despite the name), just go
			NEXT_SPECIAL = GameTime() + 10.0f;
		}

		if (SPECIAL_CYCLE == 6.0f)
		{
			if (FLIGHT_MODE)
			{
				SPECIAL_CYCLE += 1.0f;
				NEXT_SPECIAL = GameTime();
			}
			if (!FLIGHT_MODE)
			{
				DebugPrint("do_special: poison breath");
				OnDoPoisonBreath(); // no prep (despite the name), just go
				NEXT_SPECIAL = GameTime() + 10.0f;
			}
		}

		if (SPECIAL_CYCLE == 7.0f)
		{
			DebugPrint("do_special: hold person");
			OnPrepHoldPerson();
			NEXT_SPECIAL = GameTime() + 10.0f;
		}

		if (SPECIAL_CYCLE == 8.0f)
		{
			if (FLIGHT_MODE)
			{
				SPECIAL_CYCLE += 1.0f;
				NEXT_SPECIAL = GameTime();
			}
			if (!FLIGHT_MODE)
			{
				if (MIRRORS_ON)
				{
					SPECIAL_CYCLE += 1.0f;
					NEXT_SPECIAL = GameTime();
				}
				if (!MIRRORS_ON)
				{
					if (GameTime() <= NEXT_MIRROR)
					{
						SPECIAL_CYCLE += 1.0f;
						NEXT_SPECIAL = GameTime();
					}
					if (GameTime() > NEXT_MIRROR)
					{
						DebugPrint("do_special: mirror image");
						OnPrepMirrors();
						NEXT_SPECIAL = GameTime() + 10.0f;
					}
				}
			}
		}

		if (SPECIAL_CYCLE == 9.0f)
		{
			DebugPrint("do_special: attempt flight");

			if (FLIGHT_MODE)
			{
				DebugPrint("attempt_flight: canceled, already in flight");
				SPECIAL_CYCLE += 1.0f;
				NEXT_SPECIAL = GameTime();
			}
			if (!FLIGHT_MODE)
			{
				if (MIRRORS_ON)
				{
					DebugPrint("attempt_flight: canceled, mirror image up");
					SPECIAL_CYCLE += 1.0f;
					NEXT_SPECIAL = GameTime();
				}
				if (!MIRRORS_ON)
				{
					if (GameTime() <= NEXT_FLIGHT)
					{
						DebugPrint("attempt_flight: canceled, too soon since light flight");
						SPECIAL_CYCLE += 1.0f;
						NEXT_SPECIAL = GameTime();
					}
					if (GameTime() > NEXT_FLIGHT)
					{
						OnPrepFlightMode();
						NEXT_SPECIAL = GameTime() + 10.0f;
					}
				}
			}
		}
	}

	// spawn_drain_sprite
	// ====================================== DRAIN SPRITE HANDLING =============================
	void OnSpawnDrainSprite()
	{
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		DRAINER_INDEX = -1;
		DebugPrint("spawn_drain_sprite alives: " + DRAINER_ALIVES);
		for (int i = 0; i < 8; i++)
		{
			loopIteration = i;
			OnFindFreeDrainerIndex();
		}

		N_DRAIN_SPRITES += 1.0f;

		Effect("beam", "ents", "lgtning.spr", 5, ENT_ME, LHAND_ATCH, ENT_ME, RHAND_ATCH, Vector3(32, 64, 255), 200, 100, 2.0f);
		PlaySound(0, 10, SOUND_SPELL_PREP);

		CallEventDelayed(2.0f, "spawn_drain_sprite2");
	}

	// find_free_drainer_index
	void OnFindFreeDrainerIndex()
	{
		if (!(DRAINER_INDEX < 0))
			return;
		int curIdx = loopIteration;
		int isAlive = Int(GetToken(DRAINER_ALIVES, curIdx));
		if (isAlive == 0)
		{
			DRAINER_INDEX = curIdx;
			DebugPrint("find_free_drainer_index: Found Free ( " + DRAINER_INDEX + " )");
		}
	}

	// spawn_drain_sprite2
	void OnSpawnDrainSprite2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);

		// pick a nearby target
		string targList = FindInBox("enemy", 512);

		OUT_TARGET = NPCATK_TARGET; // just in case somethin dies below

		CallEventDelayed(0.1f, "spawn_drain_sprite3");

		if (targList == "none")
			return;
		if (GetTokenCount(targList) > 1)
			targList = TokenShuffle(targList);
		OUT_TARGET = GetToken(targList, 0);
	}

	// spawn_drain_sprite3
	void OnSpawnDrainSprite3()
	{
		DebugPrint("Using target " + NameOf(OUT_TARGET));

		PlaySound(0, 10, SOUND_POP);
		Vector3 spawnLoc = AttachmentPositionOf(ENT_ME, LHAND_ATCH);
		string moveDest = Text(spawnLoc);
		Vector3 targOrg = OriginOf(OUT_TARGET);
		Vector3 targAng = Angles3DTo(spawnLoc, targOrg);
		moveDest = Text(Vec(moveDest) + RelativeVelocity(targAng, Vector3(0, DRAIN_SPRITE_SPEED, 0)));
		moveDest = Text(WithX(Vec(moveDest), -Vec(moveDest).x));
		ClientEvent("update", "all", CL_IDX, "kh_make_drain_sprite", spawnLoc, DRAINER_INDEX, targAng);
		DRAINER_TARGS = TokenSet(DRAINER_TARGS, DRAINER_INDEX, OUT_TARGET);
		DRAINER_LOCS = TokenSet(DRAINER_LOCS, DRAINER_INDEX, Text(spawnLoc));
		DRAINER_TIMES = TokenSet(DRAINER_TIMES, DRAINER_INDEX, Text(GameTime()));
		DRAINER_ROTATIONS = TokenSet(DRAINER_ROTATIONS, DRAINER_INDEX, Text(RandomInt(0, 359)));
		DRAINER_ALIVES = TokenSet(DRAINER_ALIVES, DRAINER_INDEX, "1");
		OnResumeMovement();
		OnNpcatkResumeAi();
		NEXT_SPECIAL = GameTime() + 1.0f;
	}

	// resume_movement
	void OnResumeMovement()
	{
		if (!FLIGHT_MODE)
		{
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
		}
		else
		{
			SetMoveAnim(ANIM_FLOAT);
			SetIdleAnim(ANIM_FLOAT);
		}
	}

	// stop_movement
	void OnStopMovement()
	{
	}

	// track_drain_sprites
	void OnTrackDrainSprites()
	{
		bool isDraining = false;
		int curIdx = loopIteration;
		int isAlive = Int(GetToken(DRAINER_ALIVES, curIdx));
		if (isAlive == 0)
			return;

		string myTarg = GetToken(DRAINER_TARGS, curIdx);
		Vector3 myOrg = Vec(GetToken(DRAINER_LOCS, curIdx));
		float myOrbitAng = Float(GetToken(DRAINER_ROTATIONS, curIdx));
		int myTime = Int(GetToken(DRAINER_TIMES, curIdx));

		Vector3 targOrg = OriginOf(myTarg);

		string myDest = Text(targOrg);

		float targHeightAdj = Divide(HeightOf(myTarg), 2.0f); // will orbit around heads of players, and wastes of monsters
		myDest = Text(Vec(myDest) + RelativePosition(Vector3(0, myOrbitAng, 0), Vector3(0, 32, targHeightAdj)));

		float targMp = ManaOf(myTarg);

		if (Distance(myOrg, targOrg) < 64.0f)
		{
			// dbg Drainer: Near Target [ MY_ORBIT_ANG ]
			// drain and orbit
			GiveMana(myTarg, MP_DRAIN_RATE);
			if (GameTime() > NEXT_ALERT && targMp > 0.0f)
			{
				NEXT_ALERT = GameTime() + 2.0f;
				PlayerMessage(myTarg, "A corpse-light is draining your mana!");
				isDraining = true;
			}

			if (targMp <= 0.0f)
			{
				PlayerMessage(NPCATK_TARGET, "Your soul has been drained by a corpse light!");
				DoDamage(NPCATK_TARGET, "direct", 99999, "100%", ENT_ME, "target");
				ClientEvent("update", "all", CL_IDX, "kh_sprite_splode", myOrg);
				DRAINER_ALIVES = TokenSet(DRAINER_ALIVES, curIdx, "0");
				isAlive = 0;
				N_DRAIN_SPRITES -= 1.0f;
				DebugPrint("Drainer: popped");
			}
			else
			{
				// orbit
				myOrbitAng += 45.0f;
				DRAINER_ROTATIONS = TokenSet(DRAINER_ROTATIONS, curIdx, Text(myOrbitAng));
			}
		}

		if (isAlive == 0)
			return;

		float timeAlive = GameTime() - myTime;
		if (timeAlive > DRAINER_MAX_LIVE_TIME)
		{
			ClientEvent("update", "all", CL_IDX, "kh_sprite_splode", myOrg);
			DRAINER_ALIVES = TokenSet(DRAINER_ALIVES, curIdx, "0");
			isAlive = 0;
			N_DRAIN_SPRITES -= 1.0f;
			DebugPrint("Drainer: Timed out");
		}

		if (isAlive == 0)
			return;

		if (!IsAlive(myTarg))
		{
			ClientEvent("update", "all", CL_IDX, "kh_sprite_splode", myOrg);
			DRAINER_ALIVES = TokenSet(DRAINER_ALIVES, curIdx, "0");
			isAlive = 0;
			N_DRAIN_SPRITES -= 1.0f;
			DebugPrint("Drainer: Target Died");
		}

		if (isAlive == 0)
			return;

		Vector3 destAng = Angles3DTo(myOrg, Vec(myDest));
		destAng.x = -destAng.x;
		// dbg sv_update_drainer: $get(MY_TARG,name) TARG_ORG
		ClientEvent("update", "all", CL_IDX, "kh_make_drain_sprite", myOrg, curIdx, destAng, isDraining);
		string oldOrg = Text(myOrg);
		myOrg += RelativeVelocity(destAng, Vector3(0, DRAIN_SPRITE_SPEED, 0));
		DRAINER_LOCS = TokenSet(DRAINER_LOCS, curIdx, Text(myOrg)); // stores progressive origin
	}

	// prep_fireball
	// ====================================== FIRE/ICEBALL HANDLING =============================
	void OnPrepFireball()
	{
		CallEventDelayed(2.0f, "prep_fireball2");

		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		ClientEvent("update", "all", CL_IDX, "kh_hand_sprites", 2.0f, Vector3(255, 128, 96));
		PlaySound(0, 10, SOUND_FIRE_PREP);
	}

	// prep_fireball2
	void OnPrepFireball2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);
		PlaySound(0, 10, SOUND_FIREBALL_RELEASE);
		OnNpcatkResumeAi();
		OnResumeMovement();
		BALL_TYPE = "fire";
		OnStartBall();
	}

	// prep_iceball
	void OnPrepIceball()
	{
		CallEventDelayed(2.0f, "prep_iceball2");

		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, LHAND_ATCH, ENT_ME, RHAND_ATCH, Vector3(128, 164, 255), 200, 200, 2.0f);
		PlaySound(0, 10, SOUND_ICE_PREP);
	}

	// prep_iceball2
	void OnPrepIceball2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);
		PlaySound(0, 10, SOUND_FIREBALL_RELEASE);
		OnNpcatkResumeAi();
		OnResumeMovement();
		BALL_TYPE = "ice";
		OnStartBall();
	}

	// start_ball
	void OnStartBall()
	{
		if (CFB_FIREBALL_ACTIVE) // one at a time
			return;
		CFB_FIREBALL_ACTIVE = true;
		CFB_FIRST_TARGET_FOUND = false;
		CFB_EST_ORG = RelativePosition(Vector3(0, 32, 0));
		Vector3 startAngs = AnglesOf(ENT_ME);
		CFB_EST_ANG = Text(startAngs);
		if (BALL_TYPE == "fire")
			ClientEvent("new", "all", "monsters/summon/client_side_fireball", CFB_EST_ORG, startAngs);
		if (BALL_TYPE == "ice")
			ClientEvent("new", "all", "monsters/summon/client_side_iceball", CFB_EST_ORG, startAngs);
		CFB_FIREBALL_IDX = LastClientScriptId();
		CallEventDelayed(0.1f, "cfb_fireball_loop");
		CFB_FORCE_END = GameTime() + 20.0f;
	}

	// cfb_fireball_loop
	void OnCfbFireballLoop()
	{
		string targetTokens = "TARGET_TOKENS";
		Vector3 targOrg = Vec("TARG_ORG");
		Vector3 angToTarg = Vec("ANG_TO_TARG");
		if (!CFB_FIREBALL_ACTIVE)
			return;
		CallEventDelayed(0.5f, "cfb_fireball_loop");
		if (GameTime() > CFB_NEXT_SCAN)
		{
			CFB_NEXT_SCAN = GameTime() + 2.0f;
			if (!IsAlive(CFB_TARGET))
			{
				Vector3 ownerOrg = OriginOf(ENT_ME);
				targetTokens = LegacyFunction("get_tsphere", "enemy", 512, CFB_EST_ORG); // try and see if $get_sphere is fixed - can't remember
				if (targetTokens != "none")
				{
					if (GetTokenCount(targetTokens) > 1) // not important when player is owner, but may prevent targeting same player every time
						targetTokens = TokenShuffle(targetTokens);
					CBaseEntity@ testTarg = FindEntity(GetToken(targetTokens, 0));
					if (IsAlive(testTarg) && !Truthy(ScriptVarOf(testTarg, "PLAYING_DEAD")))
					{
						@CFB_TARGET = testTarg;
						// dbg *** cfb_fireball_loop: targeting $get(CFB_TARGET,id)
						if (!CFB_FIRST_TARGET_FOUND)
						{
							CFB_FIRST_TARGET_FOUND = true;
							angToTarg = Angles3DTo(CFB_EST_ORG, targOrg);
						}
					}
				}
			}
			else
			{
				Vector3 scanDown = CFB_EST_ORG;
				// vectoradd SCAN_DOWN z -32 //scan down a lil bit, cuz yer aiming at heads
				targetTokens = LegacyFunction("get_tsphere", "enemy", 96, scanDown);
				if (targetTokens != "none")
					OnCfbExplode();
			}
		}

		if (!CFB_FIREBALL_ACTIVE) // case exploded
			return;

		if (IsAlive(CFB_TARGET))
		{
			targOrg = OriginOf(CFB_TARGET);
			if (!IsPlayer(CFB_TARGET)) // aim for the heads of monsters
				targOrg.z += HeightOf(CFB_TARGET);

			// if ( G_DEVELOPER_MODE ) gplayermessage ent_me Fireball Tracking: $get(CFB_TARGET,name)
			angToTarg = Angles3DTo(CFB_EST_ORG, targOrg);
			angToTarg.x = -angToTarg.x;
			ClientEvent("update", "all", CFB_FIREBALL_IDX, "svr_update_fireball_vec", angToTarg, CFB_EST_ORG);
			CFB_EST_ANG = Text(angToTarg);
			CFB_EST_ORG += RelativeVelocity(angToTarg, Vector3(0, 60, 0));
		}
		else
		{
			CFB_EST_ORG += RelativeVelocity(Vec(CFB_EST_ANG), Vector3(0, 60, 0));
		}

		Vector3 traceDest = CFB_EST_ORG + RelativeVelocity(Vec(CFB_EST_ANG), Vector3(0, 60, 0));
		string traceResult = LegacyFunction("get_traceline", CFB_EST_ORG, traceDest, "worldonly");
		if (traceResult != Text(traceDest))
			OnCfbExplode();

		// if ( G_DEVELOPER_MODE )
		// {
		// //show where I *think* the fireball is
		// local BEAM_START CFB_EST_ORG
		// local BEAM_END TRACE_DEST
		// effect beam point lgtning.spr 100 BEAM_START BEAM_END (255,0,255) 200 16 3
		// }
		if (!CFB_FIREBALL_ACTIVE) // case sploded
			return;
		if (!(GameTime() > CFB_FORCE_END))
			return;
		OnCfbExplode();
	}

	// cfb_explode
	void OnCfbExplode()
	{
		// do next special sooner
		NEXT_SPECIAL = GameTime() + 1.0f;

		CFB_FIREBALL_ACTIVE = false;
		// if ( G_DEVELOPER_MODE ) gplayermessage ent_me Fireball Explode: PARAM1
		ClientEvent("update", "all", CFB_FIREBALL_IDX, "fireball_explode");
		CallEventDelayed(0.1f, "cfb_fireball_release");
		// scan/dodamage aoe here
		CFB_LIST = LegacyFunction("get_tsphere", "enemy", 128, CFB_EST_ORG);
		if (CFB_LIST == "none")
			return;
		if (!(GetTokenCount(CFB_LIST) > 0))
			return;
		// xdodamage CFB_EST_ORG 128 DMG_FIREBALL 0 ent_me ent_me skill.fire fire
		// dodamage CFB_EST_ORG 128 DMG_FIREBALL 100% 0 reflective fire
		int count = GetTokenCount(CFB_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCfbAffectTargets();
		}
	}

	// cfb_affect_targets
	void OnCfbAffectTargets()
	{
		CBaseEntity@ checkEnt = FindEntity(GetToken(CFB_LIST, loopIteration));

		Vector3 targetOrg = OriginOf(checkEnt);
		float targAng = AnglesTo(CFB_EST_ORG, targetOrg);
		int newYaw = int(targAng);
		SetVelocity(checkEnt, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
		if (BALL_TYPE == "fire")
		{
			DoDamage(checkEnt, "direct", DMG_FIREBALL, "100%", ENT_ME, "fire");
			ApplyEffect(checkEnt, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		}
		if (BALL_TYPE == "ice")
		{
			// dodamage CHECK_ENT direct DMG_ICEBALL 100% ent_me cold
			ApplyEffect(checkEnt, "effects/dot_cold", 5.0f, self, DOT_ICE);
		}
	}

	// cfb_fireball_end
	void OnCfbFireballEnd()
	{
		DebugPrint("cfb_fireball_end");
		ClientEvent("update", "all", CFB_FIREBALL_IDX, "fireball_end");
		CallEventDelayed(0.1f, "cfb_fireball_release");
	}

	// cfb_fireball_release
	void OnCfbFireballRelease()
	{
		DebugPrint("cfb_fireball_release");
		CFB_FIREBALL_ACTIVE = false;
	}

	// prep_mirrors
	// ================================ MIRROR IMAGE ======================================
	// This won't fool anyone, but it'll look neat ;)
	void OnPrepMirrors()
	{
		PlaySound(0, 10, "SOUND_MIRROR");
		MIRRORS_ON = true;
		OnStopMovement();
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_MIRROR_PREP);
		SetIdleAnim(ANIM_MIRROR_PREP);
		PlayAnim("critical", ANIM_MIRROR_PREP);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		MIRROR_ANG = SPIN_ANG;
		SPIN_ON = true;
		SPIN_SPEED = 1.0f;
		FADE_LEVEL = 255.0f;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderfx", 16);
		OnMirrorSpin();
		CallEventDelayed(3.0f, "stop_mirror_spin");
		ClientEvent("update", "all", CL_IDX, "kh_spawn_mirrors", "monsters/hollow_one.mdl", OriginOf(ENT_ME), SPIN_ANG);
	}

	// stop_mirror_spin
	void OnStopMirrorSpin()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 1); // if we use renderamt 0, the client effects can't find the model attachments
		SetProp(ENT_ME, "renderfx", 0);

		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		CallEventDelayed(MIRROR_DURATION, "end_mirror_fx");
	}

	// mirror_spin
	void OnMirrorSpin()
	{
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "mirror_spin");
		FADE_LEVEL -= 10.0f;
		if (FADE_LEVEL < 0.0f)
			FADE_LEVEL = 0.0f;
		DebugPrint(Text(FADE_LEVEL));
		SetProp(ENT_ME, "renderamt", FADE_LEVEL);
		SPIN_ANG += SPIN_SPEED;
		SPIN_SPEED += 1.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);
	}

	// end_mirror_fx
	void OnEndMirrorFx()
	{
		NEXT_MIRROR = GameTime() + FREQ_MIRROR;
		MIRRORS_ON = false;
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		PlaySound(0, 10, SOUND_MIRROR_OFF);
		ClientEvent("update", "all", CL_IDX, "kh_mirrors_off");
	}

	// prep_ice_spiral
	// ================================ ICE SPIRAL ======================================
	void OnPrepIceSpiral()
	{
		OnStopMovement();
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_ICE_SPIRAL);
		SetIdleAnim(ANIM_ICE_SPIRAL);
		PlayAnim("critical", ANIM_ICE_SPIRAL);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		SPIN_ON = true;
		ICE_DIST = 32.0f;
		OnIceSpiralSpin();
		CallEventDelayed(4.0f, "stop_ice_spiral_spin");
	}

	// stop_ice_spiral_spin
	void OnStopIceSpiralSpin()
	{
		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		NEXT_SPECIAL = GameTime() + 1.0f;
	}

	// ice_spiral_spin
	void OnIceSpiralSpin()
	{
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "ice_spiral_spin");
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);

		if (GameTime() > NEXT_SPIKE)
		{
			NEXT_SPIKE = GameTime() + 0.25f;

			Vector3 freezeTarget = OriginOf(ENT_ME);
			freezeTarget += RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, ICE_DIST, 0));
			OnFreezeArea(freezeTarget);
			ICE_DIST += 16.0f;
		}

		SPIN_ANG += 10.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
	}

	// freeze_area
	void OnFreezeArea(Vector3 freezePosition = Vector3())
	{
		Vector3 icePos = freezePosition;
		icePos.z = GroundHeight(icePos);
		ICE_LIST = LegacyFunction("get_tbox", "enemy", 96, icePos);
		ClientEvent("update", "all", CL_IDX, "kh_ice_spikes", icePos);
		if (ICE_LIST == "none")
			return;
		int nIceList = GetTokenCount(ICE_LIST);
		if (!(nIceList > 0))
			return;
		for (int i = 0; i < nIceList; i++)
		{
			loopIteration = i;
			OnFreezeTargets();
		}
	}

	// freeze_targets
	void OnFreezeTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(ICE_LIST, loopIteration));
		ApplyEffect(curTarget, "effects/dot_cold_freeze", 10.0f, self, DOT_ICE);
	}

	// do_fire_breath
	// ================================ FIRE BREATH ======================================
	void OnDoFireBreath()
	{
		OnStopMovement();
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_FIRE_BREATH);
		SetIdleAnim(ANIM_FIRE_BREATH);
		PlayAnim("critical", ANIM_FIRE_BREATH);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		SPIN_ON = true;
		SPIN_ANG -= 45.0f;
		if (SPIN_ANG < 0.0f)
			SPIN_ANG += 359.0f;
		ServerPlaySound(1, 10, SOUND_BREATH);
		ClientEvent("update", "all", CL_IDX, "kh_fire_breath_on", "explode1.spr");
		OnFireBreathSpin();
		CallEventDelayed(8.0f, "stop_fire_breath_spin");
		FIRE_BREATH_ON = true;
	}

	// stop_fire_breath_spin
	void OnStopFireBreathSpin()
	{
		ServerPlaySound(1, 0, SOUND_BREATH);
		ClientEvent("update", "all", CL_IDX, "kh_fire_breath_off");
		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		NEXT_SPECIAL = GameTime() + 1.0f;
		FIRE_BREATH_ON = false;
	}

	// fire_breath_spin
	void OnFireBreathSpin()
	{
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "fire_breath_spin");
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);
		// clientevent update all CL_IDX kh_fire_breath $get(ent_me,angles.yaw)
		if (GameTime() > NEXT_BURN)
		{
			NEXT_BURN = GameTime() + 0.5f;

			Vector3 burnTarget = OriginOf(ENT_ME);
			// vectoradd BURN_TARGET $relpos($vec(0,SPIN_ANG,0),$vec(0,256,0))
			BURN_LIST = LegacyFunction("get_tsphere", "enemy", 512, burnTarget);
			int nBurnList = GetTokenCount(BURN_LIST);
			// dbg fire_breath_spin BURN_LIST
			if (nBurnList > 0)
			{
				for (int i = 0; i < nBurnList; i++)
				{
					loopIteration = i;
					OnBurnTargets();
				}
			}
		}

		SPIN_ANG += 10.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
	}

	// burn_targets
	void OnBurnTargets()
	{
		string curTarget = GetToken(BURN_LIST, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		if (!(HeightOf(curTarget) > 36.0f)) // duckable
			return;
		ApplyEffect(curTarget, "effects/dot_fire", 10.0f, self, DOT_FIRE2);
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 300, 120)));
	}

	// zap_scan
	// ================================ Lightning Shield ======================================
	void OnZapScan()
	{
		NEXT_ZAP_SCAN = GameTime() + 1.0f;

		string zapList = FindInSphere("enemy", 64);
		if (zapList == "none")
			return;
		if (GetTokenCount(zapList) > 1)
			zapList = TokenShuffle(zapList);
		@ZAP_TARGET = FindEntity(GetToken(zapList, 0));
	}

	// do_poison_breath
	// ================================ POISON BREATH ======================================
	// - Same as fire breath - shoulda used some switches, but oh well, lazy
	void OnDoPoisonBreath()
	{
		OnStopMovement();
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_FIRE_BREATH);
		SetIdleAnim(ANIM_FIRE_BREATH);
		PlayAnim("critical", ANIM_FIRE_BREATH);
		SPIN_ANG = AnglesOf(ENT_ME).y + 180.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
		SPIN_ON = true;
		ServerPlaySound(1, 10, SOUND_POISON_BREATH);
		PlaySound(0, 10, SOUND_POISON_BREATH_START);
		CallEventDelayed(0.06f, "cl_breath_on");
		OnPoisonBreathSpin();
		CallEventDelayed(8.0f, "stop_poison_breath_spin");
		POISON_BREATH_ON = true;
	}

	// cl_breath_on
	void OnClBreathOn()
	{
		// slight delay to give him a chance to 180 around
		// - this effect is v. debilitating so I want to give players a chance to duck
		ClientEvent("update", "all", CL_IDX, "kh_poison_breath_on", "poison_cloud.spr");
	}

	// stop_poison_breath_spin
	void OnStopPoisonBreathSpin()
	{
		ServerPlaySound(1, 0, SOUND_POISON_BREATH);
		ClientEvent("update", "all", CL_IDX, "kh_poison_breath_off");
		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		NEXT_SPECIAL = GameTime() + 1.0f;
		POISON_BREATH_ON = false;
	}

	// poison_breath_spin
	void OnPoisonBreathSpin()
	{
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "poison_breath_spin");
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);
		// clientevent update all CL_IDX kh_fire_breath $get(ent_me,angles.yaw)
		if (GameTime() > NEXT_BURN)
		{
			NEXT_BURN = GameTime() + 0.5f;

			Vector3 burnTarget = OriginOf(ENT_ME);
			// vectoradd BURN_TARGET $relpos($vec(0,SPIN_ANG,0),$vec(0,256,0))
			BURN_LIST = LegacyFunction("get_tsphere", "enemy", 512, burnTarget);
			int nBurnList = GetTokenCount(BURN_LIST);
			// dbg fire_breath_spin BURN_LIST
			if (nBurnList > 0)
			{
				for (int i = 0; i < nBurnList; i++)
				{
					loopIteration = i;
					OnPoisonTargets();
				}
			}
		}

		SPIN_ANG += 10.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
	}

	// poison_targets
	void OnPoisonTargets()
	{
		string curTarget = GetToken(BURN_LIST, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		if (!(HeightOf(curTarget) > 36.0f)) // duckable
			return;
		ApplyEffect(curTarget, "effects/dot_poison_blind", 10.0f, self, DOT_POISON, 0, 0, "none");
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 200, 110)));
	}

	// stop_shadow_shift
	void OnStopShadowShift()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
		ClientEvent("remove", "all", CL_IDX_SHADOW);
	}

	// prep_hold_person
	// ================================ HOLD PERSON ======================================
	void OnPrepHoldPerson()
	{
		CallEventDelayed(2.0f, "prep_hold_person2");

		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		ClientEvent("update", "all", CL_IDX, "kh_hand_sprites", 2.0f, Vector3(255, 255, 255));
		PlaySound(0, 10, SOUND_FIRE_PREP);
	}

	// prep_hold_person2
	void OnPrepHoldPerson2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);
		PlaySound(0, 10, SOUND_FIREBALL_RELEASE);
		OnNpcatkResumeAi();
		OnResumeMovement();

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_hold_person", RelativePosition(Vector3(0, 0, 24)), NPCATK_TARGET, 50, 0, 0, "none");
	}

	// prep_flight_mode
	// ================================ FLIGHT MODE ======================================
	void OnPrepFlightMode()
	{
		PlaySound(0, 10, SOUND_FLIGHT_START);
		CallEventDelayed(FREQ_SOUND_FLIGHT_LOOP, "flight_sound");
		FLOAT_DIR = -25;
		FLIGHT_MODE = true;
		OnStopMovement();
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_MIRROR_PREP);
		SetIdleAnim(ANIM_MIRROR_PREP);
		PlayAnim("critical", ANIM_MIRROR_PREP);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		MIRROR_ANG = SPIN_ANG;
		SPIN_ON = true;
		SPIN_SPEED = 1.0f;
		FADE_LEVEL = 255.0f;
		OnFlightModeSpinup();
		CallEventDelayed(2.0f, "stop_flight_mode_spinup");

		ClientEvent("update", "all", CL_IDX, "kh_flight_sprites", 1);
		CallEventOrDelay(SOUND_FLIGHT_LOOP, "flight_sound");
	}

	// stop_flight_mode_spinup
	void OnStopFlightModeSpinup()
	{
		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		CallEventDelayed(FLIGHT_DURATION, "end_flight_mode");
		SetGravity(0);
		NEXT_SPECIAL = GameTime() + 1.0f;
	}

	// flight_mode_spinup
	void OnFlightModeSpinup()
	{
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "mirror_spin");
		SPIN_ANG += SPIN_SPEED;
		SPIN_SPEED += 1.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);
	}

	// end_flight_mode
	void OnEndFlightMode()
	{
		SetGravity(1);
		FLIGHT_MODE = false;
		NEXT_FLIGHT = GameTime() + FREQ_FLIGHT;
		ClientEvent("update", "all", CL_IDX, "kh_flight_sprites", 0);
	}

	// game_movingto_dest
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (!FLIGHT_MODE)
			return;
		SetAnimMoveSpeed(FLIGHT_SPEED);
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		if (!FLIGHT_MODE)
			return;
		SetAnimMoveSpeed(0);
	}

	// flight_sound
	void OnFlightSound()
	{
		if (!FLIGHT_MODE)
			return;
		PlaySound(0, 10, SOUND_FLIGHT_LOOP);
		CallEventDelayed(FREQ_SOUND_FLIGHT_LOOP, "flight_sound");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFlightDuration() {} // FLIGHT_DURATION
	void OnFreqSoundFlightLoop() {} // FREQ_SOUND_FLIGHT_LOOP
	void OnMirrorDuration() {} // MIRROR_DURATION
	void OnSoundFlightLoop() {} // SOUND_FLIGHT_LOOP

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("explode1.spr");
		Precache("monsters/hollow_one.mdl");
		Precache("magic/flame_loop.wav");
		Precache("monsters/goblin/sps_fogfire.wav");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(1.0f, "KHollowOne_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KHollowOne_FirstThink();
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
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "cfb_affect_targets") { OnCfbAffectTargets(); return true; }
		if (name == "cfb_explode") { OnCfbExplode(); return true; }
		if (name == "cfb_fireball_end") { OnCfbFireballEnd(); return true; }
		if (name == "cfb_fireball_loop") { OnCfbFireballLoop(); return true; }
		if (name == "cfb_fireball_release") { OnCfbFireballRelease(); return true; }
		if (name == "cl_breath_on") { OnClBreathOn(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire_breath") { OnDoFireBreath(); return true; }
		if (name == "do_poison_breath") { OnDoPoisonBreath(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "end_flight_mode") { OnEndFlightMode(); return true; }
		if (name == "end_mirror_fx") { OnEndMirrorFx(); return true; }
		if (name == "find_free_drainer_index") { OnFindFreeDrainerIndex(); return true; }
		if (name == "fire_breath_spin") { OnFireBreathSpin(); return true; }
		if (name == "flight_mode_spinup") { OnFlightModeSpinup(); return true; }
		if (name == "flight_sound") { OnFlightSound(); return true; }
		if (name == "freeze_area") { OnFreezeArea(Vec(Param(params, 0))); return true; }
		if (name == "freeze_targets") { OnFreezeTargets(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "ice_spiral_spin") { OnIceSpiralSpin(); return true; }
		if (name == "mirror_spin") { OnMirrorSpin(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_made_it_home") { OnNpcMadeItHome(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "poison_breath_spin") { OnPoisonBreathSpin(); return true; }
		if (name == "poison_targets") { OnPoisonTargets(); return true; }
		if (name == "prep_fireball") { OnPrepFireball(); return true; }
		if (name == "prep_fireball2") { OnPrepFireball2(); return true; }
		if (name == "prep_flight_mode") { OnPrepFlightMode(); return true; }
		if (name == "prep_hold_person") { OnPrepHoldPerson(); return true; }
		if (name == "prep_hold_person2") { OnPrepHoldPerson2(); return true; }
		if (name == "prep_ice_spiral") { OnPrepIceSpiral(); return true; }
		if (name == "prep_iceball") { OnPrepIceball(); return true; }
		if (name == "prep_iceball2") { OnPrepIceball2(); return true; }
		if (name == "prep_mirrors") { OnPrepMirrors(); return true; }
		if (name == "resume_movement") { OnResumeMovement(); return true; }
		if (name == "spawn_drain_sprite") { OnSpawnDrainSprite(); return true; }
		if (name == "spawn_drain_sprite2") { OnSpawnDrainSprite2(); return true; }
		if (name == "spawn_drain_sprite3") { OnSpawnDrainSprite3(); return true; }
		if (name == "start_ball") { OnStartBall(); return true; }
		if (name == "stop_fire_breath_spin") { OnStopFireBreathSpin(); return true; }
		if (name == "stop_flight_mode_spinup") { OnStopFlightModeSpinup(); return true; }
		if (name == "stop_ice_spiral_spin") { OnStopIceSpiralSpin(); return true; }
		if (name == "stop_mirror_spin") { OnStopMirrorSpin(); return true; }
		if (name == "stop_movement") { OnStopMovement(); return true; }
		if (name == "stop_poison_breath_spin") { OnStopPoisonBreathSpin(); return true; }
		if (name == "stop_shadow_shift") { OnStopShadowShift(); return true; }
		if (name == "track_drain_sprites") { OnTrackDrainSprites(); return true; }
		if (name == "zap_scan") { OnZapScan(); return true; }
		if (name == "KHollowOne_Timer") { KHollowOne_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
