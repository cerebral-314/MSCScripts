#pragma context server

// Converted from monsters/burning_one.script by msc_transpiler.
// Nasty undead ice thing (kind of a variant on The Hollow One, for more general [non-K-Cult] usage)
// - *Guided Ice ball
// - *Ice Breath (duckable)
// - *Hold Person Spell
// - *Palpatine Attack
// - Ice spikes in cone
// - *Weak (white) lightning shield
// - *Dodge
// - At 50% health, hood comes off - no more ice breath
// - At 20% health, robe comes off in flames - less magic attacks - goes instead for agro melee/jumpies
// - Maybe flight (check for headroom)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_lightning_shield.as"

[script "monsters/burning_one"]
class MonstersBurningOne : BaseMonsterNewScript, BaseLightningShield
{
	// Constants
	string ANIM_RUN_SKELE_MODE = "run";
	string ANIM_JUMP = "jump";
	string ANIM_LONG_JUMP = "long_jump";
	string ANIM_THROW = "ref_shoot_crowbar";
	string ANIM_SHOOT = "ref_shoot_smartgun";
	string ANIM_DEPLOY = "ref_shoot_grenade";
	string ANIM_SKELE_SWIPE = "ref_shoot_crowbar";
	string ANIM_SKELE_DUCK_SWIPE = "crouch_shoot_crowbar";
	string ANIM_LIMP_WRIST = "ref_aim_crowbar";
	string ANIM_PREP_DEPLOY = "ref_aim_trip";
	string ANIM_RELEASE_DEPLOY = "ref_shoot_trip";
	string ANIM_MIRROR_PREP = "ref_aim_grenade";
	string ANIM_ICE_SPIRAL = "ref_shoot_smartgun";
	string ANIM_ICE_BREATH = "float";
	string ANIM_DUCK_IDLE = "crouch_idle";
	string ANIM_DUCK_MOVE = "crawl";
	string ANIM_DUCK_BEAM = "crouch_shoot_smartgun";
	string ANIM_DUCK_THROW = "crouch_shoot_grenade";
	string ANIM_DUCK_ATTACK = "crouch_shoot_crowbar";
	string ANIM_DUCK_RPG = "crouch_shoot_rpg";
	string ANIM_DUCK_SPELL = "crouch_shoot_trip";
	string LSHIELD_CLFX_SCRIPT = "monsters/burning_one_lshield_cl";
	int LSHIELD_RADIUS = 64;
	int N_SPECIALS = 4;
	string CL_PRIMARY_SCRIPT = "monsters/burning_one_cl";
	int ATTACK_RANGE_MELEE = 96;
	int ATTACK_HITRANGE_MELEE = 160;
	int ATTACK_MOVERANGE_MELEE = 64;
	int ATTACK_MOVERANGE_LONG = 256;
	bool LHAND_ATCH = true;
	int RHAND_ATCH = 2;
	int MOUTH_ATCH = 3;
	float FREQ_DODGE = 4.0f;
	int DOT_ICE_BALL = 200;
	int DMG_ICE_BALL = 800;
	int DOT_ICE_CAGE = 200;
	int DMG_PALPATINE = 75;
	string DMG_SWIPE = "200";
	int DOT_FROST = 200;
	float FREQ_JUMP = 0.0f;
	float FREQ_DUCK_SWITCH = 0.0f;
	string SOUND_ICEBALL_RELEASE = "ambience/alienflyby1.wav";
	string SOUND_ICE_PREP = "magic/spookie1.wav";
	string SOUND_DODGE = "magic/frost_reverse.wav";
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";
	string SOUND_SCREAM = "monsters/spooky_scream.wav";
	string SOUND_SWIPE1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPE2 = "zombie/claw_miss2.wav";
	string SOUND_SWIPE3 = "monsters/goblin/c_gargoyle_atk1.wav";
	string SOUND_SWIPE4 = "monsters/goblin/c_gargoyle_atk2.wav";
	string SOUND_PAIN1 = "monsters/goblin/c_gargoyle_hit1.wav";
	string SOUND_PAIN2 = "monsters/goblin/c_gargoyle_hit2.wav";
	string SOUND_SKELE_LAUGH1 = "monsters/goblin/c_gargoyle_bat1.wav";
	string SOUND_SKELE_LAUGH2 = "monsters/goblin/c_gargoyle_bat2.wav";
	string SOUND_FREEZE_SLAP = "monsters/goblin/c_gargoyle_atk3.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float SPECIAL_CYCLE = 0.0f;
	float PROJ_HOLD_DURATION = 0.0f;
	string DEF_ANIM_WALK = "DEF_ANIM_WALK";
	string DEF_ANIM_RUN = "DEF_ANIM_RUN";
	string DEF_ANIM_IDLE = "DEF_ANIM_IDLE";
	int DID_INTRO = 0;
	bool SHENDER_MAP = false;
	float HALF_HP = 0.0f;
	float NEXT_SPECIAL = 0.0f;
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
	float NEXT_DODGE = 0.0f;
	bool DID_SUMMONS = false;
	float NEXT_TOUCH_ZAP = 0.0f;
	CBaseEntity@ LSHIELD_TARGET = null;
	float SPIN_ANG = 0.0f;
	bool SPIN_ON = false;
	string FREEZE_SCRIPT_IDX = "FREEZE_SCRIPT_IDX";
	bool ICE_BREATH_ON = false;
	float NEXT_FREEZE = 0.0f;
	string FREEZE_LIST = "FREEZE_LIST";
	bool PALPATINE_ON = false;
	string PALPATINE_TARGETS = "PALPATINE_TARGETS";
	int SPECIAL_OVERRIDE = 0;
	bool DUCK_MODE = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string REPULSE_LIST = "REPULSE_LIST";
	bool SWIPE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	MonstersBurningOne()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle";
		SOUND_DEATH = "monsters/goblin/c_gargoyle_dead.wav";
	}

	// unnamed block (first think)
	void MonstersBurningOne_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle";
		ANIM_DEATH = "die_forwards2";
	}

	// unnamed block (first think)
	void MonstersBurningOne_FirstThink2()
	{
		// base stats
		IS_UNHOLY = true;
		ATTACK_RANGE = 256.0f;
		ATTACK_MOVERANGE = 256.0f;
		ATTACK_HITRANGE = 256.0f;
		NPC_NO_ATTACK = true;
		NPC_GIVE_EXP = 8000.0f;

		// custom stats
		SPECIAL_CYCLE = 0.0f;

		PROJ_HOLD_DURATION = 20.0f; // used by proj_hold_person

		SetCallback("touch", "enable");
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string MonstersBurningOne_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg game_damaged stg1 STAGE_ONE_DONE stg2 STAGE_TWO_DONE hp $get(ent_me,hp) vs STAGE_TWO_THRESH
		if (SHENDER_MAP && HealthOf(ENT_ME) < HALF_HP && !DID_SUMMONS)
		{
			DID_SUMMONS = true;
			UseTrigger("spawn_ruins_summons");
		}

		if (PALPATINE_ON && RangeTo(attacker) < 256.0f)
			SetMoveDest(@attacker, 9999);

		if (PALPATINE_ON)
			return result;
		if (!(RangeTo(attacker) > 128.0f))
			return result;
		if (!(damage > 75.0f))
			return result;
		OnShadowShift();
		return result;
	}

	// game_touch
	// ==================================== Lightning Shield Extras
	string MonstersBurningOne_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!LSHIELD_PASSIVE_ENABLE)
			return result;
		if (!(GameTime() > NEXT_TOUCH_ZAP))
			return result;
		NEXT_TOUCH_ZAP = GameTime() + 0.1f; // careful not to overload - touch goes off every server think
		if (RelationshipOf(ENT_ME, @other) != "enemy")
			return result;
		@LSHIELD_TARGET = other;
		OnLshieldPassiveZapTarget();
		return result;
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string MonstersBurningOne_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (SWIPE_ATTACK && RandomInt(1, 3) == 1 && hit && RelationshipOf(target, ENT_ME) == "enemy")
		{
			PlayRandomSound(2, 10, SOUND_FREEZE_SLAP);
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FROST);
			SWIPE_ATTACK = false;
		}
		return result;
	}

	// unnamed block (timer)
	void MonstersBurningOne_Timer()
	{
		CallEventDelayed(20.0f, "MonstersBurningOne_Timer");

		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 0), 256, 20.0f);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/client_side_fireball");
		PrecacheFile("effects/sfx_motionblur_perm");
		PrecacheFile("monsters/burning_one_cl");
	}

	// game_dynamically_created
	// ==================================== Debugary
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		if (!(Float(creatorValue1) > 0.0f))
			return;
		SPECIAL_OVERRIDE = Int(creatorValue1);
	}

	// npc_spawn
	// ==================================== Init
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Burning One");
		SetRace("demon"); // ease of placement
		SetWidth(32);
		SetHeight(80);
		SetModel("monsters/hollow_one.mdl");
		SetRoam(false);
		SetHealth(9000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1);
		SetProp(ENT_ME, "skin", 0);
		SetModelBody(0, 2);
		SetModelBody(1, 3);
		SetHearingSensitivity(10);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetRoam(true);

		DEF_ANIM_WALK = ANIM_WALK;
		DEF_ANIM_RUN = ANIM_RUN;
		DEF_ANIM_IDLE = ANIM_IDLE;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield

		if (NPCATK_TARGET == "unset")
			return;

		if (GameTime() > NEXT_SPECIAL) // special frequency varies with type
			OnDoSpecial();

		if (GameTime() > NEXT_DODGE && RangeTo(NPCATK_TARGET) < 96.0f)
			OnShadowShift();
	}

	// my_target_died
	// ==================================== Melee (skele mode)
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		PlayRandomSound(0, 10, SOUND_SKELE_LAUGH1, SOUND_SKELE_LAUGH2);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MonstersBurningOne_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	// ==================================== Hunt Cycle
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (DID_INTRO == 0)
		{
			DID_INTRO = 1;
			if (ToLowerCase(MapName()) == "shender_east")
			{
				SHENDER_MAP = true;
				HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
				UseTrigger("spawn_ruins_escort");
				// callexternal players ext_play_music_me 1.5 insanity.mp3
				ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 0), 256, 20.0f);
			}
		}
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, MonstersBurningOne_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// resume_movement
	void OnResumeMovement()
	{
		ANIM_WALK = DEF_ANIM_WALK;
		ANIM_RUN = DEF_ANIM_RUN;
		ANIM_IDLE = DEF_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);
	}

	// suspend_movement
	// <hold_animation>
	void OnSuspendMovement(string holdAnimation = "")
	{
		ANIM_WALK = holdAnimation;
		ANIM_RUN = holdAnimation;
		ANIM_IDLE = holdAnimation;
		SetMoveAnim(holdAnimation);
		SetIdleAnim(holdAnimation);
		SetRoam(false);
	}

	// do_special
	// ==================================== Spellz Cycle
	void OnDoSpecial()
	{
		if (!IsAlive(ENT_ME))
			return;

		SPECIAL_CYCLE += 1.0f;
		if (SPECIAL_CYCLE > N_SPECIALS)
			SPECIAL_CYCLE = 1.0f;

		if (Truthy(GetVar("G_DEVELOPER_MODE")) && SPECIAL_OVERRIDE > 0)
			SPECIAL_CYCLE = SPECIAL_OVERRIDE;

		if (SPECIAL_CYCLE == 1.0f)
		{
			DebugPrint("do_special: iceball");

			OnPrepIceball();
			NEXT_SPECIAL = GameTime() + 25.0f; // will be reset when fireball expires/explodes
		}

		if (SPECIAL_CYCLE == 2.0f)
		{
			OnDoIceBreath();
			NEXT_SPECIAL = GameTime() + 10.0f;
		}

		if (SPECIAL_CYCLE == 3.0f)
		{
			OnPrepHoldPerson();
			NEXT_SPECIAL = GameTime() + 5.0f;
		}

		if (SPECIAL_CYCLE == 4.0f && !DUCK_MODE)
		{
			OnDoPalpatine();
			NEXT_SPECIAL = GameTime() + 10.0f;
		}
	}

	// prep_iceball
	// ==================================== Iceball Handling
	void OnPrepIceball()
	{
		CallEventDelayed(2.0f, "prep_iceball2");

		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, LHAND_ATCH, ENT_ME, RHAND_ATCH, Vector3(255, 128, 0), 200, 200, 2.0f);
		PlaySound(0, 10, SOUND_ICE_PREP);
	}

	// prep_iceball2
	void OnPrepIceball2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);
		PlaySound(0, 10, SOUND_ICEBALL_RELEASE);
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
		ClientEvent("new", "all", "monsters/summon/client_side_fireball", CFB_EST_ORG, startAngs);
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
		DoDamageEx(CFB_EST_ORG, 128, DMG_ICE_BALL, 0, ENT_ME, ENT_ME, "none", "fire_effect");
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
		ApplyEffect(checkEnt, "effects/dot_fire", 5.0f, self, DOT_ICE_BALL);
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

	// prep_hold_person
	// ==================================== Hold Person Spell
	void OnPrepHoldPerson()
	{
		CallEventDelayed(2.0f, "prep_hold_person2");

		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_PREP_DEPLOY);
		SetIdleAnim(ANIM_PREP_DEPLOY);
		SetMoveAnim(ANIM_PREP_DEPLOY);

		ClientEvent("new", "all", CL_PRIMARY_SCRIPT, "hand_sprites", IndexOf(ENT_ME), 2.0f, Vector3(64, 64, 255));
		PlaySound(0, 10, SOUND_ICE_PREP);
	}

	// prep_hold_person2
	void OnPrepHoldPerson2()
	{
		PlayAnim("critical", ANIM_RELEASE_DEPLOY);
		PlaySound(0, 10, SOUND_ICEBALL_RELEASE);
		OnNpcatkResumeAi();
		OnResumeMovement();

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_hold_person", RelativePosition(Vector3(0, 0, 24)), NPCATK_TARGET, 50, 0, 0, "none");
	}

	// shadow_shift
	// ==================================== Shadow Shift (Dodge)
	void OnShadowShift()
	{
		if (!(GameTime() > NEXT_DODGE))
			return;
		NEXT_DODGE = GameTime() + FREQ_DODGE;

		ClientEvent("persist", "all", "effects/sfx_motionblur_temp", IndexOf(ENT_ME), 0, 1, 3.0f);
		float rndAng = Random(0, 359);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, rndAng, 0), Vector3(0, 1000, 0)));
		PlaySound(0, 10, SOUND_DODGE);
		CallEventDelayed(0.25f, "stop_shadow_shift");
	}

	// stop_shadow_shift
	void OnStopShadowShift()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return MonstersBurningOne_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// do_ice_breath
	// ==================================== Ice Breath
	void OnDoIceBreath()
	{
		OnNpcatkSuspendAi();
		OnSuspendMovement(ANIM_ICE_BREATH);
		PlayAnim("critical", ANIM_ICE_BREATH);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		SPIN_ON = true;
		SPIN_ANG -= 45.0f;
		if (SPIN_ANG < 0.0f)
			SPIN_ANG += 359.0f;
		ServerPlaySound(1, 10, SOUND_BREATH);
		ClientEvent("new", "all", CL_PRIMARY_SCRIPT, "ice_breath", IndexOf(ENT_ME), 8.0f); // kh_fire_breath_on
		FREEZE_SCRIPT_IDX = LastClientScriptId();
		OnIceBreathSpin();
		CallEventDelayed(8.0f, "stop_ice_breath_spin");
		ICE_BREATH_ON = true;
	}

	// stop_ice_breath_spin
	void OnStopIceBreathSpin()
	{
		ServerPlaySound(1, 0, SOUND_BREATH);
		ClientEvent("update", "all", FREEZE_SCRIPT_IDX, "ice_breath_off");
		SPIN_ON = false;
		OnResumeMovement();
		OnNpcatkResumeAi();
		NEXT_SPECIAL = GameTime() + 1.0f;
		ICE_BREATH_ON = false;
	}

	// ice_breath_spin
	void OnIceBreathSpin()
	{
		int count;
		if (!SPIN_ON)
			return;
		CallEventDelayed(0.05f, "ice_breath_spin");
		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SetMoveDest(facePos, 9999);
		// clientevent update all CL_IDX kh_fire_breath $get(ent_me,angles.yaw)
		if (GameTime() > NEXT_FREEZE)
		{
			NEXT_FREEZE = GameTime() + 0.5f;

			FREEZE_LIST = FindInSphere("enemy", 512);
			if (FREEZE_LIST != "none")
			{
				count = GetTokenCount(FREEZE_LIST);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnFreezeTargets();
				}
			}
		}

		SPIN_ANG += 10.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;
	}

	// freeze_targets
	void OnFreezeTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(FREEZE_LIST, loopIteration));
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		if (!(HeightOf(curTarget) > 36.0f)) // duckable
			return;
		DebugPrint("freeze_targets " + NameOf(curTarget));
		ApplyEffect(curTarget, "effects/dot_fire", 10.0f, self, DOT_ICE_CAGE);

		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		SetVelocity(curTarget, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 500, 0)));
	}

	// do_palpatine
	// ==================================== Palpatine
	void OnDoPalpatine()
	{
		ATTACK_MOVERANGE = ATTACK_MOVERANGE_LONG;
		SetMoveDest(NPCATK_TARGET, 9999);
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi();
		OnSuspendMovement(ANIM_PREP_DEPLOY); // ANIM_LIMP_WRIST

		ClientEvent("new", "all", CL_PRIMARY_SCRIPT, "palpatine", IndexOf(ENT_ME), 8.0f);
		PlaySound(0, 10, SOUND_ZAP_START);
		ServerPlaySound(1, 10, SOUND_ZAP_LOOP);
		PALPATINE_ON = true;
		CallEventDelayed(8.0f, "palpatine_end");
		OnPalpatineLoop();
	}

	// palpatine_end
	void OnPalpatineEnd()
	{
		PALPATINE_ON = false;
		OnNpcatkResumeAi();
		OnResumeMovement();
		ServerPlaySound(1, 0, SOUND_ZAP_LOOP);
	}

	// palpatine_loop
	void OnPalpatineLoop()
	{
		if (!PALPATINE_ON)
			return;
		CallEventDelayed(0.1f, "palpatine_loop");
		// setangle face $vec(0,PALPATINE_YAW,0)
		PALPATINE_TARGETS = FindInSphere("enemy", 256);
		if (PALPATINE_TARGETS == "none")
			return;
		// dbg palpatine_loop PALPATINE_TARGETS
		int count = GetTokenCount(PALPATINE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPalpatineShockTargs();
		}
	}

	// palpatine_shock_targs
	void OnPalpatineShockTargs()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(PALPATINE_TARGETS, loopIteration));
		if (!IsAlive(curTarg))
			return;
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 0.75f))
			return;
		// kinda wish we had a cone damage function - but I suspect it wouldn't be all that more efficient
		if (!(HeightOf(curTarg) > 36.0f))
			return;
		DoDamage(curTarg, "direct", DMG_PALPATINE, "100%", ENT_ME, "lightning_effect");
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, 200, 110)));
	}

	// toggle_duck_mode
	// ==================================== Duck
	void OnToggleDuckMode()
	{
		bool exitSub = false;
		if (DUCK_MODE)
		{
			DUCK_MODE = true;
			ANIM_ATTACK = ANIM_SKELE_DUCK_SWIPE;
			ANIM_WALK = ANIM_DUCK_MOVE;
			ANIM_RUN = ANIM_DUCK_MOVE;
			ANIM_IDLE = ANIM_DUCK_IDLE;
			DEF_ANIM_WALK = ANIM_WALK;
			DEF_ANIM_RUN = ANIM_RUN;
			DEF_ANIM_IDLE = ANIM_IDLE;
			SetMoveAnim(ANIM_RUN);
			SetIdleAnim(ANIM_IDLE);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!DUCK_MODE)
		{
			DUCK_MODE = false;
			ANIM_ATTACK = ANIM_SKELE_SWIPE;
			ANIM_WALK = "walk";
			ANIM_RUN = "run";
			ANIM_IDLE = "idle";
			DEF_ANIM_WALK = ANIM_WALK;
			DEF_ANIM_RUN = ANIM_RUN;
			DEF_ANIM_IDLE = ANIM_IDLE;
			SetMoveAnim(ANIM_RUN);
			SetIdleAnim(ANIM_IDLE);
		}
	}

	// leap_away
	// ==================================== Leap Away
	void OnLeapAway(string target = "")
	{
		OnNpcatkSuspendAi("2.0");
		CallEventDelayed(2.0f, "force_leap_end");
		OnSuspendMovement(ANIM_LONG_JUMP);
		AS_ATTACKING = GameTime() + 5.0f;
		if (!IsAlive(target))
			SetMoveDest(NPCATK_TARGET, 1024, "flee");
		else
			SetMoveDest(target, 1024, "flee");

		NPC_FORCED_MOVEDEST = true;
		PlayAnim("critical", ANIM_LONG_JUMP);
		OnRepulseArea();
		CallEventDelayed(0.1f, "leap_away_boost");
	}

	// leap_away_boost
	void OnLeapAwayBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, 800)));
	}

	// frame_long_jump_land
	void OnFrameLongJumpLand()
	{
		OnNpcatkResumeAi();
		OnResumeMovement();
	}

	// force_leap_end
	void OnForceLeapEnd()
	{
		OnNpcatkResumeAi();
		OnResumeMovement();
	}

	// repulse_area
	void OnRepulseArea()
	{
		PlaySound(0, 10, "magic/boom.wav");
		ClientEvent("new", "all", CL_PRIMARY_SCRIPT, "repulse", OriginOf(ENT_ME), 128);
		REPULSE_LIST = FindInSphere("any", 128);
		if (REPULSE_LIST == "none")
			return;
		int count = GetTokenCount(REPULSE_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRepulseTargets();
		}
	}

	// repulse_targets
	void OnRepulseTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPULSE_LIST, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 10)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/hollow_one.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(20.0f, "MonstersBurningOne_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersBurningOne_FirstThink();
		MonstersBurningOne_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cfb_affect_targets") { OnCfbAffectTargets(); return true; }
		if (name == "cfb_explode") { OnCfbExplode(); return true; }
		if (name == "cfb_fireball_end") { OnCfbFireballEnd(); return true; }
		if (name == "cfb_fireball_loop") { OnCfbFireballLoop(); return true; }
		if (name == "cfb_fireball_release") { OnCfbFireballRelease(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_ice_breath") { OnDoIceBreath(); return true; }
		if (name == "do_palpatine") { OnDoPalpatine(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "force_leap_end") { OnForceLeapEnd(); return true; }
		if (name == "frame_long_jump_land") { OnFrameLongJumpLand(); return true; }
		if (name == "freeze_targets") { OnFreezeTargets(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "ice_breath_spin") { OnIceBreathSpin(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away_boost") { OnLeapAwayBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "palpatine_end") { OnPalpatineEnd(); return true; }
		if (name == "palpatine_loop") { OnPalpatineLoop(); return true; }
		if (name == "palpatine_shock_targs") { OnPalpatineShockTargs(); return true; }
		if (name == "prep_hold_person") { OnPrepHoldPerson(); return true; }
		if (name == "prep_hold_person2") { OnPrepHoldPerson2(); return true; }
		if (name == "prep_iceball") { OnPrepIceball(); return true; }
		if (name == "prep_iceball2") { OnPrepIceball2(); return true; }
		if (name == "repulse_area") { OnRepulseArea(); return true; }
		if (name == "repulse_targets") { OnRepulseTargets(); return true; }
		if (name == "resume_movement") { OnResumeMovement(); return true; }
		if (name == "shadow_shift") { OnShadowShift(); return true; }
		if (name == "start_ball") { OnStartBall(); return true; }
		if (name == "stop_ice_breath_spin") { OnStopIceBreathSpin(); return true; }
		if (name == "stop_shadow_shift") { OnStopShadowShift(); return true; }
		if (name == "suspend_movement") { OnSuspendMovement(Param(params, 0)); return true; }
		if (name == "toggle_duck_mode") { OnToggleDuckMode(); return true; }
		if (name == "MonstersBurningOne_Timer") { MonstersBurningOne_Timer(); return true; }
		return BaseLightningShield_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
