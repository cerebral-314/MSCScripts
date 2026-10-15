#pragma context server

// Converted from monsters/k_childre.script by msc_transpiler.
// Kharaztorant Childre by Thothie, from scratch
// one of the evolutions of the Kharaztorant dragonkin

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class KChildre
{
	// Constants
	string ANIM_IDLE_NORM = "idle1";
	string ANIM_IDLE_CROUCH = "crouch_idle";
	string ANIM_WALK_NORM = "walk";
	string ANIM_RUN_NORM = "run";
	string ANIM_CRAWL = "crawl";
	string ANIM_JUMP = "jump";
	string ANIM_DEATH_BACK1 = "death1_die";
	string ANIM_DEATH_BACK2 = "back_die";
	string ANIM_DEATH_FORWARD1 = "forward_die";
	string ANIM_DEATH_CROUCH = "crouch_die";
	string PROJECTILE_SCRIPT = "proj_fire_ball";
	float FREQ_FADE = 0.0f;
	float FREQ_FIREBALL = 0.0f;
	float FREQ_RELOAD = 30.0f;
	string DMG_SWIPE = "DMG_SWIPE";
	float FREQ_IDLE = 0.0f;
	float FREQ_JUMP = 0.0f;
	string SOUND_FIREBALL = "magic/fireball_strike.wav";
	string SOUND_FLINCH = "monsters/gonome/gonome_pain3.wav";
	string SOUND_WARCRY = "monsters/gonome/gonome_melee1.wav";
	string SOUND_FADE = "monsters/gonome/gonome_melee2.wav";
	string SOUND_UNFADE = "monsters/gonome/gonome_death3.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_PAIN1 = "monsters/gonome/gonome_jumpattack.wav";
	string SOUND_PAIN2 = "monsters/gonome/gonome_melee1.wav";
	string SOUND_SWING_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWING_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_SWING_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWING_HIT2 = "zombie/claw_strike2.wav";
	string SOUND_STEP1 = "common/npc_step1.wav";
	string SOUND_STEP2 = "common/npc_step2.wav";
	string SOUND_IDLE1 = "monsters/gonome/gonome_idle1.wav";
	string SOUND_IDLE2 = "monsters/gonome/gonome_idle2.wav";
	string SOUND_IDLE3 = "monsters/gonome/gonome_idle3.wav";
	string SOUND_PARRY = "weapons/axemetal1.wav";
	string SOUND_DEATH = "bullchicken/bc_die2.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	bool NO_STEP_ADJ = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float FIREBALL_AMMO = 0.0f;
	int STEP_SIZE_NORM = 0;
	float NPC_GIVE_EXP = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	float FLINCH_HEALTH = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool DID_WARCRY = false;
	bool STARTED_CYCLES = false;
	float NEXT_FADE = 0.0f;
	string FADE_TARGET = "FADE_TARGET";
	bool DOING_FADE = false;
	bool WAS_STRUCK = false;
	float FADE_STEP = 0.0f;
	bool AM_CRAWLING = false;
	float AS_ATTACKING = 0.0f;
	bool FIREBALL_DELAY = false;
	bool FIREBALL_TOSS = false;
	bool SWIPE_ATTACK = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	bool AM_INVISIBLE = false;

	// unnamed block (first think)
	void KChildre_FirstThink()
	{
		IS_UNHOLY = true;

		// anims used by base
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "ability1_alien"; // { event 500 7 "attack_strike" }
		ANIM_DEATH = "death1_die";
		ANIM_FLINCH = "new_flinch";

		// stats used by base (more in npc_post_spawn below)
		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 200.0f;
		ATTACK_MOVERANGE = 100.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 40);
		NO_STEP_ADJ = true;
		ATTACK_HITCHANCE = "90";
		FIREBALL_AMMO = 3.0f;
		STEP_SIZE_NORM = 64;
	}

	// npc_spawn
	void KChildre_OnNpcSpawn(string npc = "")
	{
		OnChildreSpawn();
	}

	// childre_spawn
	void KChildre_OnChildreSpawn()
	{
		bool exitSub = false;

		NPC_GIVE_EXP = 200.0f;

		SetName("Kharaztorant Childre");
		SetModel("monsters/k_childre.mdl");
		SetHealth(1000);
		SetRace("demon");
		SetWidth(32);
		SetHeight(68);
		SetRoam(true);
		SetBoundingBox("npcsize");
		SetHearingSensitivity(4);
		string mapName = ToLowerCase(MapName());
		if (Contains(mapName, "helena"))
		{
			STEP_SIZE_NORM = 18;
			exitSub = true;
		}
		if (Contains(mapName, "demontemple"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (Contains(mapName, "islesofdread"))
		{
			STEP_SIZE_NORM = 24;
			exitSub = true;
		}
		if (exitSub)
			return;
		SetStepSize(STEP_SIZE_NORM);
	}

	// npc_post_spawn
	void KChildre_OnNpcPostSpawn()
	{
		// resistances
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("holy", 0.5f);
		SetDamageTaken("stun", 0.5f);

		// post-load stats used by base
		ANIM_FLINCH = "new_flinch";
		CAN_FLINCH = "1";
		FLINCH_HEALTH = 500.0f;
		FLINCH_DELAY = "5.0";
		FLINCH_CHANCE = "50";

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetStat("parry", 100);
	}

	// npc_targetsighted
	void KChildre_OnNpcTargetsighted(string target = "")
	{
		if (!CanSee("enemy"))
			return;
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			OnDoWarcry();
		}

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_FADE, "fade_check");
		CallEventDelayed(1.0f, "fireball_check");
		CallEventDelayed(1.0f, "jump_check");
	}

	// my_target_died
	void KChildre_OnMyTargetDied(string offender = "")
	{
		DID_WARCRY = false;
		PlaySound(0, 10, SOUND_IDLE1);
		PlayAnim("critical", ANIM_FLINCH);
	}

	// fade_check
	void KChildre_OnFadeCheck()
	{
		CallEventDelayed(1.0f, "fade_check");
		if (DOING_FADE)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;

		if (!(GameTime() > NEXT_FADE))
			return;
		NEXT_FADE = GameTime() + FREQ_FADE;
		OnDoFade();
	}

	// do_fade
	void KChildre_OnDoFade()
	{
		OnNpcatkFlee(NPCATK_TARGET, "2048", "3.0");
		FADE_TARGET = NPCATK_TARGET;
		DOING_FADE = true;
		OnNpcatkSuspendAi("2.0");
		SetMoveAnim(ANIM_RUN);
		WAS_STRUCK = false;
		CallEventDelayed(0.1f, "do_fade2");
		CallEventDelayed(1.0f, "resume_attack");
	}

	// do_fade2
	void KChildre_OnDoFade2()
	{
		PlaySound(0, 10, SOUND_FADE);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 200)));
		FADE_STEP = 255.0f;
		OnFadeLoop();
		OnEtherialImmunes();
	}

	// fade_loop
	void KChildre_OnFadeLoop()
	{
		FADE_STEP -= 20.0f;
		if (FADE_STEP < 0.0f)
			SetProp(ENT_ME, "renderamt", 1);
		if (!(FADE_STEP >= 0.0f))
			return;
		if (!DOING_FADE)
			return;
		CallEventDelayed(0.1f, "fade_loop");
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", FADE_STEP);
	}

	// resume_attack
	void KChildre_OnResumeAttack()
	{
		OnNpcatkResumeAi();
		SetMoveAnim(ANIM_CRAWL);
		AM_CRAWLING = true;
		if (WAS_STRUCK)
			return;
		OnChickenRun(2.0f);
		CallEventDelayed(2.1f, "invis_run2"); // run around a bit while invisible to lose target
	}

	// invis_run2
	void KChildre_OnInvisRun2()
	{
		if (WAS_STRUCK)
			return;
		if (!DOING_FADE)
			return;
		OnChickenRun(2.0f);
		CallEventDelayed(2.1f, "flank_targ");
	}

	// flank_targ
	void KChildre_OnFlankTarg()
	{
		OnNpcatkFlank(FADE_TARGET);
	}

	// do_warcry
	void KChildre_OnDoWarcry()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_IDLE_CROUCH);
		OnNpcatkFaceattacker(NPCATK_TARGET);
		PlaySound(0, 10, SOUND_WARCRY);
	}

	// fireball_check
	void KChildre_OnFireballCheck()
	{
		CallEventDelayed(1.1f, "fireball_check");
		if (!(FIREBALL_AMMO > 0.0f))
			return;
		if (DOING_FADE)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE))
			return;
		if (FIREBALL_DELAY)
			return;
		FIREBALL_DELAY = true;
		CallEventDelayed(FREQ_FIREBALL, "reset_fireball_delay");

		OnNpcatkFaceattacker(NPCATK_TARGET);
		AS_ATTACKING = GameTime();
		OnNpcatkSuspendAi();
		SetRoam(false);
		CallEventDelayed(0.1f, "do_fireball");
	}

	// reset_fireball_delay
	void KChildre_OnResetFireballDelay()
	{
		FIREBALL_DELAY = false;
	}

	// do_fireball
	void KChildre_OnDoFireball()
	{
		PlaySound(0, 10, SOUND_FIREBALL);
		FIREBALL_TOSS = true;
		PlayAnim("critical", ANIM_ATTACK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 62)), NPCATK_TARGET, 400, 200, 0, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0);
		FIREBALL_AMMO -= 1.0f;
		if (FIREBALL_AMMO == 0.0f)
			SetProp(ENT_ME, "skin", 0);
		OnNpcatkResumeAi();
		SetRoam(true);
	}

	// game_dodamage
	string KChildre_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!SWIPE_ATTACK)
			return result;
		if (hit)
			PlayRandomSound(0, 10, SOUND_SWING_HIT1, SOUND_SWING_HIT2);
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWING_MISS1, SOUND_SWING_MISS2);
		SWIPE_ATTACK = false;
		return result;
	}

	// game_parry
	void KChildre_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlaySound(0, 10, SOUND_PARRY);
	}

	// unnamed block (timer)
	void KChildre_Timer()
	{
		CallEventDelayed(FREQ_RELOAD, "KChildre_Timer");
		FIREBALL_AMMO += 1.0f;
		SetProp(ENT_ME, "skin", 1);
		if (!(FIREBALL_AMMO > 3.0f))
			return;
		FIREBALL_AMMO = 3.0f;
	}

	// become_visible
	void KChildre_OnBecomeVisible()
	{
		NEXT_FADE = GameTime() + FREQ_FADE;
		OnNormalImmunes();
		PlaySound(0, 10, SOUND_UNFADE);
		// dbg become_visible PARAM1
		DOING_FADE = false;
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// npc_flinch
	void KChildre_OnNpcFlinch(float damage = 0.0f)
	{
		int rndFlinch = RandomInt(1, 2);
		if (rndFlinch == 1)
			FLINCH_ANIM = "ANIM_FLINCH1";
		if (rndFlinch == 2)
			FLINCH_ANIM = "ANIM_FLINCH2";
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// unnamed block (timer)
	void KChildre_Timer2()
	{
		CallEventDelayed(FREQ_IDLE, "KChildre_Timer2");
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// game_death
	void KChildre_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetProp(ENT_ME, "skin", 2);
		if (DOING_FADE)
		{
			DOING_FADE = false;
			CallExternal(GetVar("GAME_MASTER"), "gm_fade_in", self);
		}

		if (RangeTo(ENT_LASTSTRUCK) > 256.0f)
			ANIM_DEATH = ANIM_DEATH_FORWARD1;
		if (RangeTo(ENT_LASTSTRUCK) <= 256.0f)
		{
			int rndDeath = RandomInt(1, 2);
			if (rndDeath == 1)
				ANIM_DEATH = ANIM_DEATH_BACK1;
			if (rndDeath == 2)
				ANIM_DEATH = ANIM_DEATH_BACK2;
		}
		if (AM_CRAWLING)
			ANIM_DEATH = ANIM_DEATH_CROUCH;
	}

	// game_struck
	void KChildre_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlaySound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);

		if (!AM_CRAWLING)
			return;
		if (!DOING_FADE)
			return;
		SetMoveAnim(ANIM_RUN);
		AM_CRAWLING = false;
		WAS_STRUCK = true;
		OnChickenRun(1.5f);
	}

	// jump_check
	void KChildre_OnJumpCheck()
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
		PlaySound(0, 10, SOUND_FADE);
	}

	// do_jump
	void KChildre_OnDoJump()
	{
		SetStepSize(1000);
		SetMoveAnim(ANIM_JUMP);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 800)));
		CallEventDelayed(0.5f, "push_forward");
		CallEventDelayed(1.0f, "jump_done");
	}

	// push_forward
	void KChildre_OnPushForward()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// jump_done
	void KChildre_OnJumpDone(string npc = "")
	{
		SetStepSize(STEP_SIZE_NORM);
		SetMoveAnim(ANIM_RUN);
	}

	// walk_step
	// model events
	void KChildre_OnWalkStep()
	{
		PlaySound(0, 4, SOUND_STEP1, SOUND_STEP2);
	}

	// run_step
	void KChildre_OnRunStep()
	{
		PlaySound(0, 10, SOUND_STEP1, SOUND_STEP2);
	}

	// attack_strike
	void KChildre_OnAttackStrike()
	{
		if (DOING_FADE && !FIREBALL_TOSS)
			OnBecomeVisible();
		SetMoveAnim(ANIM_RUN);
		AM_CRAWLING = false;
		FIREBALL_TOSS = false;
		SWIPE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_SWIPE, ATTACK_HITCHANCE, "slash");
	}

	// etherial_immunes
	void KChildre_OnEtherialImmunes()
	{
		ClearEffects();
		AM_INVISIBLE = true;
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 0);
	}

	// normal_immunes
	void KChildre_OnNormalImmunes()
	{
		AM_INVISIBLE = false;
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("poison", 1);
		SetDamageTaken("holy", 0.5f);
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
		KChildre_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		KChildre_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KChildre_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KChildre_OnNpcSpawn(npc);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		KChildre_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, KChildre_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		KChildre_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		KChildre_OnNpcTargetsighted(target);
	}

	void OnChildreSpawn() { KChildre_OnChildreSpawn(); } // childre_spawn
	void OnFadeCheck() { KChildre_OnFadeCheck(); } // fade_check
	void OnDoFade() { KChildre_OnDoFade(); } // do_fade
	void OnDoFade2() { KChildre_OnDoFade2(); } // do_fade2
	void OnFadeLoop() { KChildre_OnFadeLoop(); } // fade_loop
	void OnResumeAttack() { KChildre_OnResumeAttack(); } // resume_attack
	void OnInvisRun2() { KChildre_OnInvisRun2(); } // invis_run2
	void OnFlankTarg() { KChildre_OnFlankTarg(); } // flank_targ
	void OnDoWarcry() { KChildre_OnDoWarcry(); } // do_warcry
	void OnFireballCheck() { KChildre_OnFireballCheck(); } // fireball_check
	void OnResetFireballDelay() { KChildre_OnResetFireballDelay(); } // reset_fireball_delay
	void OnDoFireball() { KChildre_OnDoFireball(); } // do_fireball
	void OnBecomeVisible() { KChildre_OnBecomeVisible(); } // become_visible
	void OnNpcFlinch(float damage = 0.0f) { KChildre_OnNpcFlinch(damage); } // npc_flinch
	void OnJumpCheck() { KChildre_OnJumpCheck(); } // jump_check
	void OnDoJump() { KChildre_OnDoJump(); } // do_jump
	void OnPushForward() { KChildre_OnPushForward(); } // push_forward
	void OnJumpDone(string npc = "") { KChildre_OnJumpDone(npc); } // jump_done
	void OnWalkStep() { KChildre_OnWalkStep(); } // walk_step
	void OnRunStep() { KChildre_OnRunStep(); } // run_step
	void OnAttackStrike() { KChildre_OnAttackStrike(); } // attack_strike
	void OnEtherialImmunes() { KChildre_OnEtherialImmunes(); } // etherial_immunes
	void OnNormalImmunes() { KChildre_OnNormalImmunes(); } // normal_immunes
	void OnFreqFade() {} // FREQ_FADE
	void OnFreqFireball() {} // FREQ_FIREBALL
	void OnFreqJump() {} // FREQ_JUMP

	// This file's events and timers by their .script names
	bool KChildre_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_strike") { OnAttackStrike(); return true; }
		if (name == "become_visible") { OnBecomeVisible(); return true; }
		if (name == "childre_spawn") { OnChildreSpawn(); return true; }
		if (name == "do_fade") { OnDoFade(); return true; }
		if (name == "do_fade2") { OnDoFade2(); return true; }
		if (name == "do_fireball") { OnDoFireball(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "do_warcry") { OnDoWarcry(); return true; }
		if (name == "etherial_immunes") { OnEtherialImmunes(); return true; }
		if (name == "fade_check") { OnFadeCheck(); return true; }
		if (name == "fade_loop") { OnFadeLoop(); return true; }
		if (name == "fireball_check") { OnFireballCheck(); return true; }
		if (name == "flank_targ") { OnFlankTarg(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "invis_run2") { OnInvisRun2(); return true; }
		if (name == "jump_check") { OnJumpCheck(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "normal_immunes") { OnNormalImmunes(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "reset_fireball_delay") { OnResetFireballDelay(); return true; }
		if (name == "resume_attack") { OnResumeAttack(); return true; }
		if (name == "run_step") { OnRunStep(); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		if (name == "KChildre_Timer") { KChildre_Timer(); return true; }
		if (name == "KChildre_Timer2") { KChildre_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/k_childre"]
shared class KChildreScript : BaseMonsterNewScript, KChildre
{
	// Variables every script that includes this file declares
	string SPORE_POISON_DMG = "SPORE_POISON_DMG";

	// Variables declared by included files, with the value they start with in this script
	KChildreScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		NO_STEP_ADJ = true;
		SOUND_DEATH = "bullchicken/bc_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_childre.mdl");
		CallEventDelayed(FREQ_RELOAD, "KChildre_Timer");
		CallEventDelayed(FREQ_IDLE, "KChildre_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KChildre_FirstThink();
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
		return KChildre_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
