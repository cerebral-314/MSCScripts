#pragma context server

// Converted from monsters/fw_alcolyte.script by msc_transpiler.
// Kharaztorant Acolytes by Thothie for AmIAnnoyingNow, from scratch
// - (experiment) this monster scales up its powers and value if there are more than 4 players on

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/fw_alcolyte"]
class FwAlcolyte : BaseMonsterNewScript
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
	float FREQ_LOOK = 0.0f;
	float FREQ_LOTS = 0.0f;
	float FREQ_RARE = 0.0f;
	float FREQ_NORM = 0.0f;
	float FREQ_LEAP = 5.0f;
	string SOUND_JUMP1 = "voices/phlame/vs_ndrawlm_atk1.wav";
	string SOUND_JUMP2 = "voices/phlame/vs_ndrawlm_atk2.wav";
	string SOUND_JUMP3 = "voices/phlame/vs_ndrawlm_atk3.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	string SOUND_DRAW = "weapons/dagger/dagger2.wav";
	string SOUND_PARRY = "weapons/dagger/daggermetal2.wav";
	string SOUND_PAIN1 = "voices/phlame/vs_ndrawlm_hit1.wav";
	string SOUND_PAIN2 = "voices/phlame/vs_ndrawlm_hit2.wav";
	string SOUND_PAIN3 = "voices/phlame/vs_ndrawlm_hit3.wav";
	string SOUND_DEATH1 = "voices/phlame/vs_ndrawlm_dead.wav";
	string SOUND_DEATH2 = "voices/phlame/vs_ndrawlm_hit3.wav";
	string SOUND_ALERT1 = "voices/phlame/vs_ndrawlm_attk.wav";
	string SOUND_ALERT2 = "voices/phlame/vs_ndrawlm_bat1.wav";
	string SOUND_ALERT3 = "voices/phlame/vs_ndrawlm_help.wav";
	string SOUND_IDLE = "voices/phlame/vs_ndrawlm_haha.wav";
	string SOUND_WARCRY1 = "voices/phlame/vs_ndrawlm_bat2.wav";
	string SOUND_WARCRY2 = "voices/phlame/vs_ndrawlm_bat3.wav";
	string SOUND_WARCRY3 = "voices/phlame/vs_ndrawlm_bat1.wav";
	string SOUND_WARCRY4 = "voices/phlame/vs_ndrawlm_attk.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_LOST_SIGHT1 = "voices/phlame/vs_ndrawlm_attk.wav";
	string SOUND_LOST_SIGHT2 = "voices/phlame/vs_ndrawlm_bat1.wav";
	string SOUND_LOST_SIGHT3 = "voices/phlame/vs_ndrawlm_bat2.wav";
	string SOUND_LOST_SIGHT4 = "voices/phlame/vs_ndrawlm_bat3.wav";
	string SOUND_LOST_SIGHT5 = "voices/phlame/vs_ndrawlm_warn.wav";
	string SOUND_VICTORY1 = "voices/phlame/vs_ndrawlm_vict.wav";
	string SOUND_BURN = "ambience/steamburst1.wav";
	string SOUND_POISON = "bullchicken/bc_bite2.wav";
	string SOUND_FREEZE = "magic/frost_forward.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ALCO_TYPE = "ALCO_TYPE";
	int JUMP_CHANCE = 0;
	int ORIG_WEAPON = 0;
	float FREQ_COMBAT = 0.0f;
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string EFFECT_DUR = "EFFECT_DUR";
	float EFFECT_DMG = 0.0f;
	string SOUND_EFFECT = "SOUND_EFFECT";
	float THROW_DELAY = 0.0f;
	float FREQ_THROW = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float SEARCH_DELAY = 0.0f;
	bool DID_WARCRY = false;
	bool STARTED_CYCLES = false;
	bool LEAP_DELAY = false;
	string K_MOVE_TYPE = "K_MOVE_TYPE";
	float NINJA_JUMP = 0.0f;
	bool SOUND_EFFECT_DELAY = false;
	bool DID_AID_ALERT = false;
	float G_LAST_VICTORY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	FwAlcolyte()
	{
		ANIM_WALK = "walk2handed";
		ANIM_IDLE = "idle";
	}

	// unnamed block (first think)
	void FwAlcolyte_FirstThink()
	{
		// anims used by base
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "ref_shoot_knife"; // { event 500 5 "attack_knife" }
		ANIM_DEATH = "die_simple";
	}

	// unnamed block (first think)
	void FwAlcolyte_FirstThink2()
	{
		// stats used by base (more in npc_post_spawn below)
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 170.0f;
		ATTACK_MOVERANGE = 80.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 20);
		NPC_GIVE_EXP = 120.0f;
	}

	// unnamed block (timer)
	void FwAlcolyte_Timer()
	{
		CallEventDelayed(FREQ_IDLE, "FwAlcolyte_Timer");
		if (NPCATK_TARGET != "unset")
			return;
		PlayAnim("once", ANIM_SEARCH);
		PlaySound(0, 10, SOUND_IDLE);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

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

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared

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

		// local RND_FACE $rand(1,2)
		// if ( RND_FACE == 1 ) setmodelbody 1 0 //use face 1 for initiates
		// if ( RND_FACE == 2 ) setmodelbody 1 2
		if (ALCO_TYPE == "fire")
		{
			SetModelBody(2, 0);
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

		SetProp(ENT_ME, "skin", ORIG_WEAPON);

		OnWalkMode();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(2, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);

		if (damage > 50.0f && !LEAP_DELAY)
		{
			LEAP_DELAY = true;
			CallEventDelayed(FREQ_LEAP, "reset_leap_delay");
			OnLeapAway(EntityId(EntityOf(ENT_LASTSTRUCK)));
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Phlame Acolyte");
		SetModel("monsters/fire_alcolyte.mdl");
		SetProp(ENT_ME, "skin", 1);
		// adjust health by # of players
		// local N_PLAYERS game.players
		// multiply BASE_HP N_PLAYERS
		// capvar BASE_HP 200 600
		int baseHp = RandomInt(200, 300);
		SetHealth(baseHp);
		SetRace("demon");
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetHearingSensitivity(4);

		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("cold", 1.25f);

		ALCO_TYPE = "2";
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
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

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (CanSee("enemy"))
			return;
		if (!(GameTime() > SEARCH_DELAY))
			return;
		SEARCH_DELAY = GameTime() + FREQ_LOOK;
		PlayRandomSound(0, 10, SOUND_LOST_SIGHT1, SOUND_LOST_SIGHT2, SOUND_LOST_SIGHT3, SOUND_LOST_SIGHT4, SOUND_LOST_SIGHT5);
		PlayAnim("once", ANIM_SEARCH);
		AS_ATTACKING = GameTime();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DebugPrint("my_target_died");
		if (!(GameTime() > G_LAST_VICTORY))
			return;
		G_LAST_VICTORY = GameTime() + 30.0f;
		PlaySound(0, 10, SOUND_VICTORY1);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		if (K_MOVE_TYPE != "crawl")
			PlayAnim("critical", ANIM_CAST_NORM);
		if (K_MOVE_TYPE == "crawl")
			PlayAnim("critical", ANIM_CAST_CRAWL);
		PlaySound(0, 10, SOUND_PARRY);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!DID_WARCRY)
		{
			SEARCH_DELAY = GameTime() + FREQ_LOOK;
			DID_WARCRY = true;
			PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2, SOUND_WARCRY3, SOUND_WARCRY4);
			CallEventDelayed(0.1f, "draw_sound");
		}

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_COMBAT, "do_combat_move"); // chance stance or jump away
	}

	// ambush
	// for ambush variant
	void OnAmbush()
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
	void OnLeapAmbush()
	{
		OnLeapAt(EntityId(NPC_PROXACT_PLAYERID));
	}

	// draw_sound
	void OnDrawSound()
	{
		PlaySound(0, 10, SOUND_DRAW);
	}

	// reset_search_delay
	void OnResetSearchDelay()
	{
		SEARCH_DELAY = 0.0f;
	}

	// run_mode
	void OnRunMode()
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
	void OnWalkMode()
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
	void OnCrawlMode()
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
	void OnLeapAt(string target = "")
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(@EntityOf(target), 9999);
		AS_ATTACKING = GameTime();
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2, SOUND_JUMP3);
		PlayAnim("critical", ANIM_JUMP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_away
	void OnLeapAway(string target = "")
	{
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("0.2", "leap_away");
		SetMoveDest(@EntityOf(target), 1024, "flee");
		AS_ATTACKING = GameTime();
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2, SOUND_JUMP3);
		PlayAnim("critical", ANIM_JUMP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 75)));
	}

	// toggle_stance
	void OnToggleStance()
	{
		if (K_MOVE_TYPE != "crawl")
			CallEventDelayed(0.1f, "crawl_mode");
		if (K_MOVE_TYPE == "crawl")
			CallEventDelayed(0.1f, "run_mode");
	}

	// reset_throw_delay
	void OnResetThrowDelay()
	{
		THROW_DELAY = 0.0f;
	}

	// swing_dodamage
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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
	void OnResetSoundEffectDelay()
	{
		SOUND_EFFECT_DELAY = false;
	}

	// do_combat_move
	void OnDoCombatMove()
	{
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
	void OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// attack_knife
	// anim event
	void OnAttackKnife()
	{
		PlaySound(0, 5, SOUND_SWING);
		float fDmgKnife = DMG_KNIFE;
		if (PlayerCount() > 4)
			fDmgKnife *= 2.0f;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, fDmgKnife, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:swing");
	}

	// do_throw
	void OnDoThrow()
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
		TossProjectile("proj_k_knife", pos, NPCATK_TARGET, PROJ_SPEED, fDmgToss, 0.2f, "none");

		SetModelBody(2, 1);
		AS_ATTACKING = GameTime();
		OnNpcatkSuspendAi("do_throw");
		CallEventDelayed(0.5f, "do_reload");
	}

	// do_reload
	void OnDoReload()
	{
		if (K_MOVE_TYPE != "crawl")
			PlayAnim("critical", ANIM_SEARCH);
		if (K_MOVE_TYPE == "crawl")
			PlayAnim("critical", ANIM_CAST_CRAWL);
		CallEventDelayed(0.5f, "do_reload2");
	}

	// do_reload2
	void OnDoReload2()
	{
		AS_ATTACKING = GameTime();
		OnNpcatkResumeAi("reload2");
		SetModelBody(2, 0);
		PlaySound(0, 10, SOUND_DRAW);
	}

	// npc_aiding_ally
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		// dbg npc_aiding_ally $get(NPC_ALLY_TO_AID,name)
		CallExternal(NPC_ALLY_TO_AID, "being_aided");
	}

	// being_aided
	void OnBeingAided()
	{
		// dbg being_aided
		if (!CanSee(NPCATK_TARGET))
			return;
		if (DID_AID_ALERT)
			return;
		DID_AID_ALERT = true;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqCombat() {} // FREQ_COMBAT
	void OnFreqLeap() {} // FREQ_LEAP
	void OnFreqThrow() {} // FREQ_THROW

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fire_alcolyte.mdl");
		CallEventDelayed(FREQ_IDLE, "FwAlcolyte_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FwAlcolyte_FirstThink();
		FwAlcolyte_FirstThink2();
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
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
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
		if (name == "FwAlcolyte_Timer") { FwAlcolyte_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
