#pragma context server

// Converted from monsters/k_alcolyte.script by msc_transpiler.
// Kharaztorant Acolytes by Thothie for AmIAnnoyingNow, from scratch
// - (experiment) this monster scales up its powers and value if there are more than 4 players on

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class KAlcolyte
{
	// Constants
	string ANIM_WALK_NORM = "walk2handed";
	string ANIM_RUN_NORM = "run2";
	string ANIM_IDLE_NORM = "idle";
	string ANIM_HOP = "jump";
	string ANIM_JUMP = "long_jump";
	string ANIM_CRAWL = "crawl";
	string ANIM_IDLE_CRAWL = "crouch_idle";
	string ANIM_ATTACK_NORM = "ref_shoot_knife";
	string ANIM_ATTACK_CRAWL = "crouch_shoot_knife";
	string ANIM_SEARCH = "look_idle";
	string ANIM_CAST_NORM = "ref_shoot_onehanded";
	string ANIM_CAST_CRAWL = "crouch_shoot_onehanded";
	string ANIM_DEATH1 = "die_simple";
	string ANIM_DEATH2 = "die_backwards1";
	string ANIM_DEATH3 = "die_backwards";
	string ANIM_DEATH4 = "die_forwards";
	string ANIM_DEATH5 = "headshot";
	string ANIM_DEATH6 = "die_spin";
	string ANIM_DEATH7 = "gutshot";
	int DMG_KNIFE = 0;
	string CHANCE_EFFECT = "30%";
	float FREQ_IDLE = 0.0f;
	int DMG_TOSS = 0;
	float PROJ_SPEED = 600.0f;
	float FREQ_LOOK = 10.0f;
	float FREQ_LOTS = 0.0f;
	float FREQ_RARE = 0.0f;
	float FREQ_NORM = 0.0f;
	float FREQ_LEAP = 5.0f;
	string SOUND_JUMP = "voices/kcult_jump.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	string SOUND_DRAW = "weapons/dagger/dagger2.wav";
	string SOUND_PARRY = "weapons/dagger/daggermetal2.wav";
	string SOUND_PAIN1 = "voices/kcult_pain3.wav";
	string SOUND_PAIN2 = "voices/kcult_pain2.wav";
	string SOUND_DEATH1 = "voices/kcult_pain1.wav";
	string SOUND_DEATH2 = "voices/kcult_die1.wav";
	string SOUND_ALERT1 = "voices/kcult_ally_alert1.wav";
	string SOUND_ALERT2 = "voices/kcult_ally_alert2.wav";
	string SOUND_IDLE = "voices/kcult_idle.wav";
	string SOUND_WARCRY1 = "voices/kcult_alert1.wav";
	string SOUND_WARCRY2 = "voices/kcult_alert2.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_BURN = "ambience/steamburst1.wav";
	string SOUND_POISON = "bullchicken/bc_bite2.wav";
	string SOUND_FREEZE = "magic/frost_forward.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk2handed";
	string ANIM_IDLE = "idle";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ALCO_TYPE = "ALCO_TYPE";
	float NEXT_AIDED_SOUND = 0.0f;
	float NEXT_LH = 0.0f;
	int JUMP_CHANCE = 0;
	int ORIG_WEAPON = 0;
	float FREQ_COMBAT = 0.0f;
	float FREQ_THROW = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string EFFECT_DUR = "EFFECT_DUR";
	float EFFECT_DMG = 0.0f;
	string SOUND_EFFECT = "SOUND_EFFECT";
	float THROW_DELAY = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool DID_WARCRY = false;
	bool STARTED_CYCLES = false;
	float SEARCH_DELAY = 0.0f;
	bool LEAP_DELAY = false;
	string K_MOVE_TYPE = "K_MOVE_TYPE";
	bool NPC_FORCED_MOVEDEST = false;
	float NINJA_JUMP = 0.0f;
	bool SOUND_EFFECT_DELAY = false;

	// unnamed block (first think)
	void KAlcolyte_FirstThink()
	{
		// anims used by base
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "ref_shoot_knife"; // { event 500 5 "attack_knife" }
		ANIM_DEATH = "die_simple";
	}

	// unnamed block (first think)
	void KAlcolyte_FirstThink2()
	{
		// stats used by base (more in npc_post_spawn below)
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 170.0f;
		ATTACK_MOVERANGE = 80.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 20);
		NPC_GIVE_EXP = 100.0f;
	}

	// npc_spawn
	void KAlcolyte_OnNpcSpawn(string npc = "")
	{
		SetName("Kharaztorant Acolyte");
		SetModel("monsters/k_alcolyte.mdl");
		// adjust health by # of players
		// local N_PLAYERS game.players
		// multiply BASE_HP N_PLAYERS
		// capvar BASE_HP 200 600
		int baseHp = RandomInt(200, 300);
		SetHealth(baseHp);
		SetRace("demon");
		SetWidth(32);
		if (!Truthy(GetVar("AM_TURRET")))
			SetHeight(72);
		if (Truthy(GetVar("AM_TURRET")))
			SetHeight(48);
		SetRoam(true);
		SetHearingSensitivity(4);

		if (Truthy(GetVar("OVERRIDE_TYPE")))
			return;
		ALCO_TYPE = RandomInt(1, 4);
	}

	// npc_post_spawn
	void KAlcolyte_OnNpcPostSpawn()
	{
		NEXT_AIDED_SOUND = GameTime() + Random(3, 5);
		NEXT_LH = GameTime() + Random(3, 5);

		SetDamageTaken("holy", 0); // not quite that evil, yet

		JUMP_CHANCE = 1;

		if (Float(ALCO_TYPE) == 1.0f)
			ALCO_TYPE = "ninja";
		if (Float(ALCO_TYPE) == 2.0f)
			ALCO_TYPE = "fire";
		if (Float(ALCO_TYPE) == 3.0f)
			ALCO_TYPE = "poison";
		if (Float(ALCO_TYPE) == 4.0f)
			ALCO_TYPE = "cold";

		int rndFace = RandomInt(1, 2);
		if (rndFace == 1) // use face 1 for initiates
			SetModelBody(1, 0);
		if (rndFace == 2)
			SetModelBody(1, 2);

		if (ALCO_TYPE == "ninja")
		{
			SetModelBody(2, 0);
			ORIG_WEAPON = 0;
			FREQ_COMBAT = FREQ_LOTS;
			SetDamageTaken("all", 0.5f);
			SetStat("parry", 100);
			FREQ_THROW = 5.0f;
			ATTACK_HITCHANCE = "90";
			JUMP_CHANCE = 2;
		}

		if (ALCO_TYPE == "fire")
		{
			SetModelBody(2, 1);
			ORIG_WEAPON = 1;
			FREQ_COMBAT = FREQ_RARE;
			EFFECT_SCRIPT = "effects/dot_fire";
			EFFECT_DUR = "5.0";
			EFFECT_DMG = 30.0f;
			SOUND_EFFECT = SOUND_BURN;
			THROW_DELAY = 1.0f;
			FREQ_THROW = 10.0f;
			CallEventDelayed(FREQ_THROW, "reset_throw_delay");
			ATTACK_HITCHANCE = "80";
		}

		if (ALCO_TYPE == "poison")
		{
			SetModelBody(2, 2);
			ORIG_WEAPON = 2;
			FREQ_COMBAT = FREQ_NORM;
			EFFECT_SCRIPT = "effects/dot_poison";
			EFFECT_DUR = "15.0";
			EFFECT_DMG = 4.0f;
			SOUND_EFFECT = SOUND_POISON;
			FREQ_THROW = 2.0f;
			THROW_DELAY = 1.0f;
			CallEventDelayed(FREQ_THROW, "reset_throw_delay");
			ATTACK_HITCHANCE = "85";
			JUMP_CHANCE = 3;
		}

		if (ALCO_TYPE == "cold")
		{
			SetModelBody(2, 3);
			ORIG_WEAPON = 3;
			FREQ_COMBAT = FREQ_RARE;
			EFFECT_SCRIPT = "effects/dot_cold";
			EFFECT_DUR = "5.0";
			EFFECT_DMG = 5.0f;
			SOUND_EFFECT = SOUND_FREEZE;
			FREQ_THROW = 10.0f;
			THROW_DELAY = 1.0f;
			CallEventDelayed(FREQ_THROW, "reset_throw_delay");
			ATTACK_HITCHANCE = "75";
		}

		if (Truthy(GetVar("I_POUNCE")))
		{
			// ambush version
			// set NPC_PROX_ACTIVATE stats in include
			SetMoveAnim(ANIM_IDLE_CRAWL);
			SetIdleAnim(ANIM_IDLE_CRAWL);
		}

		SetProp(ENT_ME, "skin", ORIG_WEAPON);

		if (Truthy(GetVar("I_POUNCE")))
			return;
		OnWalkMode();
	}

	// ambush
	// for ambush variant
	void KAlcolyte_OnAmbush()
	{
		DebugPrint("*** POUNCE ***");

		OnNpcatkResumeAi();
		OnNpcatkFaceattacker(EntityId(NPC_PROXACT_PLAYERID));
		OnRunMode();
		AS_ATTACKING = GameTime();
		CallEventDelayed(0.01f, "leap_ambush");
		OnCycleUp("ambush");
		SetMoveAnim(ANIM_RUN_NORM);
		SetIdleAnim(ANIM_IDLE_NORM);
	}

	// leap_ambush
	void KAlcolyte_OnLeapAmbush()
	{
		OnLeapAt(EntityId(NPC_PROXACT_PLAYERID));
	}

	// npc_targetsighted
	void KAlcolyte_OnNpcTargetsighted(string target = "")
	{
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
			CallEventDelayed(0.1f, "draw_sound");
		}

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_COMBAT, "do_combat_move"); // chance stance or jump away
	}

	// draw_sound
	void KAlcolyte_OnDrawSound()
	{
		PlaySound(0, 10, SOUND_DRAW);
	}

	// game_death
	void KAlcolyte_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		int rndDeath = RandomInt(1, 7);
		if (rndDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (rndDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (rndDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (rndDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;
		if (rndDeath == 6)
			ANIM_DEATH = ANIM_DEATH6;
		if (rndDeath == 7)
			ANIM_DEATH = ANIM_DEATH7;

		PlayRandomSound(0, 10, SOUND_DEATH1, SOUND_DEATH2);
	}

	// unnamed block (timer)
	void KAlcolyte_Timer()
	{
		CallEventDelayed(FREQ_IDLE, "KAlcolyte_Timer");
		if (NPCATK_TARGET != "unset")
			return;
		PlayAnim("once", ANIM_SEARCH);
		if (GameTime() > NEXT_LH)
		{
			NEXT_LH = GameTime() + Random(5, 15);
			PlaySound(0, 10, SOUND_IDLE);
		}
		DebugPrint("repeat_idle");
	}

	// reset_search_delay
	void KAlcolyte_OnResetSearchDelay()
	{
		SEARCH_DELAY = 0.0f;
	}

	// game_struck
	void KAlcolyte_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlaySound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);

		if (damage > 50.0f && !LEAP_DELAY)
		{
			LEAP_DELAY = true;
			CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
			OnLeapAway(EntityId(EntityOf(ENT_LASTSTRUCK)));
		}
	}

	// run_mode
	void KAlcolyte_OnRunMode()
	{
		K_MOVE_TYPE = "run";
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		ANIM_ATTACK = ANIM_ATTACK_NORM;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
	}

	// walk_mode
	void KAlcolyte_OnWalkMode()
	{
		K_MOVE_TYPE = "walk";
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		ANIM_ATTACK = ANIM_ATTACK_NORM;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// crawl_mode
	void KAlcolyte_OnCrawlMode()
	{
		K_MOVE_TYPE = "crawl";
		ANIM_RUN = ANIM_CRAWL;
		ANIM_WALK = ANIM_CRAWL;
		ANIM_IDLE = ANIM_IDLE_CRAWL;
		ANIM_ATTACK = ANIM_ATTACK_CRAWL;
		SetMoveAnim(ANIM_CRAWL);
		SetIdleAnim(ANIM_IDLE_CRAWL);
	}

	// leap_at
	void KAlcolyte_OnLeapAt(string target = "")
	{
		if (Truthy(GetVar("NO_JUMPS")))
			return;
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(@EntityOf(target), 9999);
		AS_ATTACKING = GameTime();
		PlaySound(0, 10, SOUND_JUMP);
		PlayAnim("critical", ANIM_JUMP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_away
	void KAlcolyte_OnLeapAway(string target = "")
	{
		if (Truthy(GetVar("NO_JUMPS")))
			return;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("0.2", "leap_away");
		SetMoveDest(@EntityOf(target), 1024, "flee");
		AS_ATTACKING = GameTime();
		PlaySound(0, 10, SOUND_JUMP);
		PlayAnim("critical", ANIM_JUMP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void KAlcolyte_OnLeapBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 75)));
	}

	// toggle_stance
	void KAlcolyte_OnToggleStance()
	{
		if (K_MOVE_TYPE != "crawl")
			CallEventDelayed(0.1f, "crawl_mode");
		if (K_MOVE_TYPE == "crawl")
			CallEventDelayed(0.1f, "run_mode");
	}

	// npcatk_hunt
	void KAlcolyte_OnNpcatkHunt()
	{
		bool exitSub = false;
		if (!CYCLED_UP)
			return;

		if (RangeTo(NPCATK_TARGET) >= ATTACK_RANGE)
		{
			if (K_MOVE_TYPE != "run" && ALCO_TYPE != "poison")
				OnRunMode();

			if (int(THROW_DELAY) == 0 && CanSee(NPCATK_TARGET))
			{
				THROW_DELAY = 1.0f;
				CallEventDelayed(FREQ_THROW, "reset_throw_delay");
				OnNpcatkFaceattacker(NPCATK_TARGET);
				PlaySound(0, 10, SOUND_THROW);
				PlayAnim("critical", ANIM_ATTACK);
				CallEventDelayed(0.1f, "do_throw");
				NINJA_JUMP = GameTime() + 2.0f;
				exitSub = true;
			}
			if (!exitSub && ALCO_TYPE == "ninja" && GameTime() > NINJA_JUMP && !LEAP_DELAY)
			{
				LEAP_DELAY = true;
				CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
				OnLeapAt(NPCATK_TARGET);
			}
		}
	}

	// reset_throw_delay
	void KAlcolyte_OnResetThrowDelay()
	{
		THROW_DELAY = 0.0f;
	}

	// swing_dodamage
	void KAlcolyte_OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (ALCO_TYPE == "ninja")
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (!(RandomInt(1, 100) < Float(CHANCE_EFFECT)))
			return;
		if (!SOUND_EFFECT_DELAY)
		{
			SOUND_EFFECT_DELAY = true;
			CallEventDelayed(5.1f, "reset_sound_effect_delay");
			PlaySound(0, 10, SOUND_EFFECT);
		}

		if (EFFECT_SCRIPT == "EFFECT_SCRIPT")
			return;
		ApplyEffect(target, EFFECT_SCRIPT, EFFECT_DUR, self, EFFECT_DMG);
	}

	// reset_sound_effect_delay
	void KAlcolyte_OnResetSoundEffectDelay()
	{
		SOUND_EFFECT_DELAY = false;
	}

	// do_combat_move
	void KAlcolyte_OnDoCombatMove()
	{
		if (Truthy(GetVar("AM_TURRET")))
			return;

		CallEventDelayed(FREQ_COMBAT, "do_combat_move");

		if (NPCATK_TARGET == "unset")
			return;

		int rndMove = RandomInt(1, 5);

		if (rndMove > JUMP_CHANCE)
			OnToggleStance();

		if (rndMove <= JUMP_CHANCE && !LEAP_DELAY)
		{
			LEAP_DELAY = true;
			CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
			OnLeapAway(NPCATK_TARGET);
		}
	}

	// reset_leap_delay
	void KAlcolyte_OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// attack_knife
	// anim event
	void KAlcolyte_OnAttackKnife()
	{
		PlaySound(0, 5, SOUND_SWING);
		float fDmgKnife = DMG_KNIFE;
		if (PlayerCount() > 4)
			fDmgKnife *= 2.0f;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, fDmgKnife, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:swing");
	}

	// game_parry
	void KAlcolyte_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		if (K_MOVE_TYPE != "crawl")
			PlayAnim("critical", ANIM_CAST_NORM);
		if (K_MOVE_TYPE == "crawl")
			PlayAnim("critical", ANIM_CAST_CRAWL);
		PlaySound(0, 10, SOUND_PARRY);
	}

	// do_throw
	void KAlcolyte_OnDoThrow()
	{
		int up = 0;
		// dbg temp do_throw K_MOVE_TYPE
		float fDmgToss = DMG_TOSS;
		if (PlayerCount() > 4)
			fDmgToss *= 2.0f;

		if (K_MOVE_TYPE != "crawl")
			up = 62;
		if (K_MOVE_TYPE == "crawl")
			up = 34;

		Vector3 pos = OriginOf(ENT_ME);
		pos.z += up;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		if (K_MOVE_TYPE != "crawl")
			TossProjectile("proj_k_knife", pos, NPCATK_TARGET, PROJ_SPEED, fDmgToss, 0.2f, "none");

		SetModelBody(2, 4);
		AS_ATTACKING = GameTime();
		OnNpcatkSuspendAi("do_throw");
		CallEventDelayed(0.5f, "do_reload");
	}

	// do_reload
	void KAlcolyte_OnDoReload()
	{
		if (K_MOVE_TYPE != "crawl")
			PlayAnim("critical", ANIM_SEARCH);
		if (K_MOVE_TYPE == "crawl")
			PlayAnim("critical", ANIM_CAST_CRAWL);
		CallEventDelayed(0.5f, "do_reload2");
	}

	// do_reload2
	void KAlcolyte_OnDoReload2()
	{
		AS_ATTACKING = GameTime();
		OnNpcatkResumeAi("reload2");
		SetModelBody(2, ORIG_WEAPON);
		PlaySound(0, 10, SOUND_DRAW);
	}

	// npcatk_lost_sight
	void KAlcolyte_OnNpcatkLostSight()
	{
		DebugPrint("npcatk_lost_sight " + Text(NEXT_LH) + " vs " + Text(GameTime()));
		if (CanSee("enemy"))
			return;
		if (GameTime() > NEXT_LH)
		{
			NEXT_LH = GameTime() + Random(5, 15);
			PlaySound(0, 10, SOUND_IDLE);
		}
		if (int(SEARCH_DELAY) != 0)
			return;
		SEARCH_DELAY = 1.0f;
		CallEventDelayed(FREQ_LOOK, "reset_search_delay");
		PlayAnim("once", ANIM_SEARCH);
		AS_ATTACKING = GameTime();
	}

	// npc_aiding_ally
	void KAlcolyte_OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		// dbg npc_aiding_ally $get(NPC_ALLY_TO_AID,name)
		CallExternal(NPC_ALLY_TO_AID, "being_aided");
	}

	// being_aided
	void KAlcolyte_OnBeingAided()
	{
		// dbg being_aided
		if (!(GameTime() > NEXT_AIDED_SOUND))
			return;
		NEXT_AIDED_SOUND = GameTime() + Random(3, 5);
		if (!CanSee(NPCATK_TARGET))
			return;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
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
		KAlcolyte_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		KAlcolyte_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KAlcolyte_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KAlcolyte_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		KAlcolyte_OnNpcatkHunt();
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		KAlcolyte_OnNpcatkLostSight();
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		KAlcolyte_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		KAlcolyte_OnNpcTargetsighted(target);
	}

	void OnAmbush() { KAlcolyte_OnAmbush(); } // ambush
	void OnLeapAmbush() { KAlcolyte_OnLeapAmbush(); } // leap_ambush
	void OnDrawSound() { KAlcolyte_OnDrawSound(); } // draw_sound
	void OnResetSearchDelay() { KAlcolyte_OnResetSearchDelay(); } // reset_search_delay
	void OnRunMode() { KAlcolyte_OnRunMode(); } // run_mode
	void OnWalkMode() { KAlcolyte_OnWalkMode(); } // walk_mode
	void OnCrawlMode() { KAlcolyte_OnCrawlMode(); } // crawl_mode
	void OnLeapAt(string target = "") { KAlcolyte_OnLeapAt(target); } // leap_at
	void OnLeapAway(string target = "") { KAlcolyte_OnLeapAway(target); } // leap_away
	void OnLeapBoost() { KAlcolyte_OnLeapBoost(); } // leap_boost
	void OnToggleStance() { KAlcolyte_OnToggleStance(); } // toggle_stance
	void OnResetThrowDelay() { KAlcolyte_OnResetThrowDelay(); } // reset_throw_delay
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { KAlcolyte_OnSwingDodamage(hit, target, start, end, damageType, damageText); } // swing_dodamage
	void OnResetSoundEffectDelay() { KAlcolyte_OnResetSoundEffectDelay(); } // reset_sound_effect_delay
	void OnDoCombatMove() { KAlcolyte_OnDoCombatMove(); } // do_combat_move
	void OnResetLeapDelay() { KAlcolyte_OnResetLeapDelay(); } // reset_leap_delay
	void OnAttackKnife() { KAlcolyte_OnAttackKnife(); } // attack_knife
	void OnDoThrow() { KAlcolyte_OnDoThrow(); } // do_throw
	void OnDoReload() { KAlcolyte_OnDoReload(); } // do_reload
	void OnDoReload2() { KAlcolyte_OnDoReload2(); } // do_reload2
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "") { KAlcolyte_OnNpcAidingAlly(allyToAid, caller); } // npc_aiding_ally
	void OnBeingAided() { KAlcolyte_OnBeingAided(); } // being_aided
	void OnFreqCombat() {} // FREQ_COMBAT
	void OnFreqLeap() {} // FREQ_LEAP
	void OnFreqLook() {} // FREQ_LOOK
	void OnFreqThrow() {} // FREQ_THROW

	// This file's events and timers by their .script names
	bool KAlcolyte_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ambush") { OnAmbush(); return true; }
		if (name == "attack_knife") { OnAttackKnife(); return true; }
		if (name == "being_aided") { OnBeingAided(); return true; }
		if (name == "crawl_mode") { OnCrawlMode(); return true; }
		if (name == "do_combat_move") { OnDoCombatMove(); return true; }
		if (name == "do_reload") { OnDoReload(); return true; }
		if (name == "do_reload2") { OnDoReload2(); return true; }
		if (name == "do_throw") { OnDoThrow(); return true; }
		if (name == "draw_sound") { OnDrawSound(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "leap_ambush") { OnLeapAmbush(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "npc_aiding_ally") { OnNpcAidingAlly(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		if (name == "reset_search_delay") { OnResetSearchDelay(); return true; }
		if (name == "reset_sound_effect_delay") { OnResetSoundEffectDelay(); return true; }
		if (name == "reset_throw_delay") { OnResetThrowDelay(); return true; }
		if (name == "run_mode") { OnRunMode(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "toggle_stance") { OnToggleStance(); return true; }
		if (name == "walk_mode") { OnWalkMode(); return true; }
		if (name == "KAlcolyte_Timer") { KAlcolyte_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/k_alcolyte"]
shared class KAlcolyteScript : BaseMonsterNewScript, KAlcolyte
{
	// Variables declared by included files, with the value they start with in this script
	KAlcolyteScript()
	{
		ANIM_WALK = "walk2handed";
		ANIM_IDLE = "idle";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_alcolyte.mdl");
		CallEventDelayed(FREQ_IDLE, "KAlcolyte_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KAlcolyte_FirstThink();
		KAlcolyte_FirstThink2();
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
		return KAlcolyte_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
