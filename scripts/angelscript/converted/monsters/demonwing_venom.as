#pragma context server

// Converted from monsters/demonwing_venom.script by msc_transpiler.
// Revenge of the Stuckabat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/base_propelled.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DemonwingVenom
{
	// Constants
	string ANIM_CEILING_LAND = "Land_ceiling";
	string ANIM_CEILING_DETATCH = "ceiling_detatch";
	string ANIM_CEILING_IDLE1 = "Subtle_fidget";
	string ANIM_CEILING_IDLE2 = "Preen_fidget";
	string ANIM_CEILING_IDLE3 = "Swing_fidget";
	string ANIM_FLY = "Flying_cycler";
	string ANIM_HOVER = "Hover";
	string ANIM_BOOST = "Dive_cycler";
	float FREQ_SPIT_CYCLE = 30.0f;
	string ANIM_DEATH_FLY_MODE = "Death_fall_simple";
	string ANIM_DEATH_GROUND_MODE = "Die_on_ground";
	string ANIM_FLINCH1 = "Flinch_big";
	string ANIM_FLINCH2 = "Flinch_small";
	bool AS_CUSTOM_UNSTUCK = true;
	string DOT_EFFECT = "effects/dot_poison";
	string SPIT_PROJECTILE = "proj_poison_spit2";
	float DMG_CLAW = 200.0f;
	float DOT_DMG = 20.0f;
	float FREQ_HORROR_BOOST = 0.0f;
	int DMG_SPIT = 50;
	float FREQ_SWITCH_GROUND_MODE = 60.0f;
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string SOUND_HOVER = "monsters/bat/flap_big.wav";
	string SOUND_ATTACK1 = "monsters/demonwing/demonwing_atk1.wav";
	string SOUND_ATTACK2 = "monsters/demonwing/demonwing_atk2.wav";
	string SOUND_ATTACK3 = "monsters/demonwing/demonwing_atk3.wav";
	string SOUND_ALERT1 = "monsters/demonwing/demonwing_bat1.wav";
	string SOUND_ALERT2 = "monsters/demonwing/demonwing_bat2.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/demonwing/demonwing_hit1.wav";
	string SOUND_PAIN2 = "monsters/demonwing/demonwing_hit2.wav";
	string SOUND_DEATH = "monsters/demonwing/demonwing_dead.wav";
	string SOUND_SPIT = "bullchicken/bc_attack2.wav";
	string SOUND_CIELING_FIDGET = "monsters/demonwing/demonwing_slct.wav";
	string MONSTER_NAME = "Demonwing";
	int MONSTER_SKIN_IDX = 1;
	float MONSTER_HP = 3000.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "Flying_cycler";
	string ANIM_IDLE = "Hover_slow";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_DEATH = "ANIM_DEATH";
	float NPC_GIVE_EXP = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float FLAP_STEP = 0.0f;
	bool CIELING_MODE = false;
	float MIN_FLINCH_DAMAGE = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool NPC_PROPELL_SUSPEND = false;
	string CANT_TURN = "CANT_TURN";
	bool NPC_NO_MOVE = false;
	bool BFLY_SUSPEND_FLY = false;
	bool GROUND_MODE = false;
	float NEXT_CIELING_FIDGET = 0.0f;
	float GO_TO_SLEEP = 0.0f;
	float NEXT_SPIT_CYCLE = 0.0f;
	float NEXT_HORROR_BOOST = 0.0f;
	float NEXT_GROUND_MODE = 0.0f;
	bool NO_CIELING_IDLE = false;
	float NEXT_FLINCH = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool CLAW_ATTACK = false;
	bool NPC_FORCED_MOVEDEST = false;
	float AS_UNSTUCK_ANG = 0.0f;
	bool SPIT_MODE = false;
	string TARGET_LIST = "TARGET_LIST";
	string SPIT_TARGET = "SPIT_TARGET";
	string MY_MASTER = "MY_MASTER";
	bool IS_SUMMONED = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	int NPC_SPRITE_IN = 0;

	// unnamed block (first think)
	void DemonwingVenom_FirstThink()
	{
		ANIM_ATTACK = "Attack_claw"; // frame_attack_claw

		ANIM_RUN = "Flying_cycler";
		ANIM_WALK = "Flying_cycler";
		ANIM_IDLE = "Hover_slow";

		ANIM_DEATH = "Death_fall_simple";
	}

	// unnamed block (first think)
	void DemonwingVenom_FirstThink2()
	{
		NPC_GIVE_EXP = 600.0f;

		ATTACK_RANGE = 72.0f;
		ATTACK_HITRANGE = 72.0f;
	}

	// npc_spawn
	void DemonwingVenom_OnNpcSpawn(string npc = "")
	{
		SetName(MONSTER_NAME);
		SetModel("monsters/demonwing.mdl");
		SetProp(ENT_ME, "skin", MONSTER_SKIN_IDX);
		SetHealth(MONSTER_HP);
		SetWidth(32);
		SetHeight(32);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetRace("demon");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(4);

		FLAP_STEP = 0.0f;

		CallEventDelayed(2.0f, "final_props");

		CallEventDelayed(0.01f, "check_ceiling");
	}

	// check_ceiling
	void DemonwingVenom_OnCheckCeiling()
	{
		if (NO_CIELING_IDLE)
			SetHearingSensitivity(8);

		if (NO_CIELING_IDLE)
			return;
		OnNpcatkSuspendAi("2.0");
		CIELING_MODE = true;
		CallEventDelayed(0.1f, "stick_ceiling");
	}

	// final_props
	void DemonwingVenom_OnFinalProps()
	{
		MIN_FLINCH_DAMAGE = MaxHealthOf(ENT_ME) * 0.05f;
	}

	// stick_ceiling
	void DemonwingVenom_OnStickCeiling()
	{
		if (NO_CIELING_IDLE)
			return;
		if (IS_SUMMONED)
			return;
		SetRoam(false);
		NO_STUCK_CHECKS = "1";
		NPC_PROPELL_SUSPEND = true;
		CANT_TURN = "1";
		NPC_NO_MOVE = true;
		SetGravity(0);
		SetHearingSensitivity(4);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 800)));
		BFLY_SUSPEND_FLY = true;
		CIELING_MODE = true;
		GROUND_MODE = false;
		PlayAnim("critical", ANIM_CEILING_LAND);
		ANIM_IDLE = ANIM_CEILING_IDLE1;
		ANIM_WALK = ANIM_CEILING_IDLE1;
		ANIM_RUN = ANIM_CEILING_IDLE1;
		SetMoveAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		NEXT_CIELING_FIDGET = GameTime() + Random(3, 6);
	}

	// npcatk_hunt
	void DemonwingVenom_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (IS_SUMMONED && !IsAlive(MY_MASTER))
			OnNpcSuicide();

		if (NPCATK_TARGET == "unset")
		{
			if (CIELING_MODE)
			{
				SetGravity(0);
				SetVelocity(ENT_ME, Vector3(0, 0, 800));
				if (GameTime() > NEXT_CIELING_FIDGET)
				{
					NEXT_CIELING_FIDGET = GameTime() + Random(3, 6);
					int rndIdle = RandomInt(1, 2);
					if (rndIdle == 1)
					{
						PlayAnim("once", ANIM_CEILING_IDLE2);
						PlaySound(0, 10, SOUND_CIELING_FIDGET);
					}
					if (rndIdle == 2)
						PlayAnim("once", ANIM_CEILING_IDLE3);
				}
			}

			if (!CIELING_MODE && !NO_CIELING_IDLE && GameTime() > GO_TO_SLEEP)
				OnStickCeiling();
		}

		if (NPCATK_TARGET == "unset")
			return;

		GO_TO_SLEEP = GameTime() + 10.0f;

		if (I_R_FROZEN)
			return;

		if (CIELING_MODE)
			OnDetatchFromCieling();

		if (GameTime() > NEXT_SPIT_CYCLE && CanSee(NPCATK_TARGET))
		{
			NEXT_SPIT_CYCLE = GameTime() + FREQ_SPIT_CYCLE;
			OnDoSpitCycle();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;

		if (SPIT_MODE)
			return;

		if (!(GameTime() > NEXT_HORROR_BOOST))
			return;
		NEXT_HORROR_BOOST = GameTime() + FREQ_HORROR_BOOST;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		ServerPlaySound(2, 10, "SOUND_FLAP");
		PlayAnim("once", ANIM_BOOST);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 0)));
	}

	// detatch_from_cieling
	void DemonwingVenom_OnDetatchFromCieling()
	{
		NEXT_HORROR_BOOST = GameTime() + 6.0f;

		NEXT_SPIT_CYCLE = GameTime() + FREQ_SPIT_CYCLE;

		SetHearingSensitivity(8);

		CANT_TURN = "0";
		NPC_NO_MOVE = false;
		SetMoveDest(NPCATK_TARGET, 9999);
		SetGravity(0);

		CallEventDelayed(3.0f, "frame_detatch_done"); // just in case the anim doesn't hit

		OnNpcatkSuspendAi("1.0");
		OnFlyMode();
		PlayAnim("critical", ANIM_CEILING_DETATCH);
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		CIELING_MODE = false;

		NEXT_GROUND_MODE = GameTime() + FREQ_SWITCH_GROUND_MODE;
	}

	// frame_detatch_done
	void DemonwingVenom_OnFrameDetatchDone()
	{
		BFLY_SUSPEND_FLY = false;
		NO_STUCK_CHECKS = "0";
		NPC_PROPELL_SUSPEND = false;
		SetRoam(true);
	}

	// fly_mode
	void DemonwingVenom_OnFlyMode()
	{
		SetGravity(0);
		ANIM_IDLE = ANIM_HOVER;
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_FLY);
		SetIdleAnim(ANIM_HOVER);
	}

	// set_no_ceiling_idle
	void DemonwingVenom_OnSetNoCeilingIdle()
	{
		NO_CIELING_IDLE = true;
	}

	// game_struck
	void DemonwingVenom_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool exitSub = false;
		// manual flinch
		if (GameTime() > NEXT_FLINCH && damage > MIN_FLINCH_DAMAGE)
		{
			NEXT_FLINCH = GameTime() + Random(10, 20);
			OnNpcatkSuspendAi("1.0");
			AS_ATTACKING = GameTime() + 5.0f;
			if (RandomInt(1, 2) == 1)
				PlayAnim("critical", ANIM_FLINCH1);
			else
				PlayAnim("critical", ANIM_FLINCH2);
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -300, 0)));
			exitSub = true;
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2);
		}
		if (exitSub)
			return;
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
	}

	// frame_flap
	void DemonwingVenom_OnFrameFlap()
	{
		FLAP_STEP += 1.0f;
		if (FLAP_STEP == 1.0f)
		{
			ServerPlaySound(2, 5, SOUND_FLAP1);
		}
		else
		{
			ServerPlaySound(2, 5, SOUND_FLAP2);
			FLAP_STEP = 0.0f;
		}
	}

	// frame_attack_claw
	void DemonwingVenom_OnFrameAttackClaw()
	{
		if (SPIT_MODE)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		CLAW_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "90%", "slash");
	}

	// game_dodamage
	string DemonwingVenom_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (CLAW_ATTACK && RandomInt(1, 4) == 1)
			ApplyEffect(target, DOT_EFFECT, 5.0f, self, DOT_DMG);
		CLAW_ATTACK = false;
		return result;
	}

	// npc_stuck
	void DemonwingVenom_OnNpcStuck()
	{
		if (!SUSPEND_AI)
			OnAsNpcatkSuspendAi(AS_WIGGLE_DURATION);
		NPC_FORCED_MOVEDEST = true;
		Vector3 moveDest = OriginOf(ENT_ME);
		AS_UNSTUCK_ANG += 36.0f;
		if (AS_UNSTUCK_ANG > 359.0f)
			AS_UNSTUCK_ANG -= 359.0f;
		// dbg npcatk_anti_stuck stuck_count STUCK_COUNT ang AS_UNSTUCK_ANG
		moveDest += RelativePosition(Vector3(0, AS_UNSTUCK_ANG, 0), Vector3(0, 1000, 0));
		SetMoveDest(moveDest, AS_MOVEPROX); // I'd love to have them trace along a wall, but I can't figure how to pull that.
		PlayAnim("once", ANIM_RUN);

		float rndUd = Random(-200, 200);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, rndUd)));
	}

	// do_spit_cycle
	void DemonwingVenom_OnDoSpitCycle()
	{
		OnNpcatkSuspendAi();
		NPC_PROPELL_SUSPEND = true;
		ANIM_WALK = ANIM_HOVER;
		ANIM_RUN = ANIM_HOVER;
		ANIM_IDLE = ANIM_HOVER;
		SetMoveAnim(ANIM_HOVER);
		SetIdleAnim(ANIM_HOVER);
		SPIT_MODE = true;
		OnDoSpitCycleLoop();
		CallEventDelayed(5.0f, "end_spit_cycle");
	}

	// do_spit_cycle_loop
	void DemonwingVenom_OnDoSpitCycleLoop()
	{
		if (!SPIT_MODE)
			return;
		CallEventDelayed(1.0f, "do_spit_cycle_loop");
		TARGET_LIST = FindInSphere("enemy", 2048);
		if (TARGET_LIST == "none")
			return;
		TARGET_LIST = TokenShuffle(TARGET_LIST);
		SPIT_TARGET = "0";
		int count = GetTokenCount(TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPickTarget();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
		if (!IsAlive(SPIT_TARGET))
			return;
		SetMoveDest(SPIT_TARGET, 9999);
		ServerPlaySound(2, 10, SOUND_SPIT);
		PlayAnim("once", ANIM_ATTACK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(SPIT_PROJECTILE, RelativePosition(Vector3(0, 0, -8)), SPIT_TARGET, 300, DMG_SPIT, 1, "none");
	}

	// pick_target
	void DemonwingVenom_OnPickTarget()
	{
		if (IsAlive(SPIT_TARGET))
			return;
		string curTarg = GetToken(TARGET_LIST, loopIteration);
		Vector3 traceStart = OriginOf(ENT_ME);
		Vector3 traceEnd = OriginOf(curTarg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != Text(traceEnd))
			return;
		SPIT_TARGET = curTarg;
	}

	// end_spit_cycle
	void DemonwingVenom_OnEndSpitCycle()
	{
		OnNpcatkResumeAi();
		NPC_PROPELL_SUSPEND = false;
		SPIT_MODE = false;
		ANIM_IDLE = ANIM_HOVER;
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_FLY);
		SetIdleAnim(ANIM_HOVER);
		NEXT_SPIT_CYCLE = GameTime() + FREQ_SPIT_CYCLE;
	}

	// game_dynamically_created
	void DemonwingVenom_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// imediately pick target
		// remove if mum dies
		// remove in 60 secs
		NO_CIELING_IDLE = true;
		MY_MASTER = creatorValue1;
		IS_SUMMONED = true;
		NPC_USES_HANDLE_EVENTS = true;
		NPC_SPRITE_IN = 2;
		CallEventDelayed(60.0f, "baby_suicide");
		CallEventDelayed(0.1f, "instant_target");
	}

	// instant_target
	void DemonwingVenom_OnInstantTarget()
	{
		string getTarget = FindInSphere("enemy", 1024);
		if (getTarget == "none")
			return;
		OnCycleUp("instant_target");
		getTarget = SortEntities(getTarget, "range");
		OnNpcatkSettarget(GetToken(getTarget, 0));
	}

	// baby_suicide
	void DemonwingVenom_OnBabySuicide()
	{
		OnNpcSuicide();
	}

	// npc_death
	void DemonwingVenom_OnNpcDeath()
	{
		if (!IS_SUMMONED)
			return;
		CallExternal(MY_MASTER, "babbie_died");
		DeleteEntity(ENT_ME, "fade");
	}

	// fake_precache
	void DemonwingVenom_OnFakePrecache()
	{
		ServerPlaySound(0, 0, "monsters/bat/flap_big1.wav");
		ServerPlaySound(0, 0, "monsters/bat/flap_big2.wav");
		ServerPlaySound(0, 0, "monsters/bat/flap_big.wav");
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
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
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
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		DemonwingVenom_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DemonwingVenom_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DemonwingVenom_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		DemonwingVenom_OnNpcatkHunt();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DemonwingVenom_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
	}

	void OnCheckCeiling() { DemonwingVenom_OnCheckCeiling(); } // check_ceiling
	void OnFinalProps() { DemonwingVenom_OnFinalProps(); } // final_props
	void OnStickCeiling() { DemonwingVenom_OnStickCeiling(); } // stick_ceiling
	void OnDetatchFromCieling() { DemonwingVenom_OnDetatchFromCieling(); } // detatch_from_cieling
	void OnFrameDetatchDone() { DemonwingVenom_OnFrameDetatchDone(); } // frame_detatch_done
	void OnFlyMode() { DemonwingVenom_OnFlyMode(); } // fly_mode
	void OnSetNoCeilingIdle() { DemonwingVenom_OnSetNoCeilingIdle(); } // set_no_ceiling_idle
	void OnFrameFlap() { DemonwingVenom_OnFrameFlap(); } // frame_flap
	void OnFrameAttackClaw() { DemonwingVenom_OnFrameAttackClaw(); } // frame_attack_claw
	void OnNpcStuck() { DemonwingVenom_OnNpcStuck(); } // npc_stuck
	void OnDoSpitCycle() { DemonwingVenom_OnDoSpitCycle(); } // do_spit_cycle
	void OnDoSpitCycleLoop() { DemonwingVenom_OnDoSpitCycleLoop(); } // do_spit_cycle_loop
	void OnPickTarget() { DemonwingVenom_OnPickTarget(); } // pick_target
	void OnEndSpitCycle() { DemonwingVenom_OnEndSpitCycle(); } // end_spit_cycle
	void OnInstantTarget() { DemonwingVenom_OnInstantTarget(); } // instant_target
	void OnBabySuicide() { DemonwingVenom_OnBabySuicide(); } // baby_suicide
	void OnNpcDeath() { DemonwingVenom_OnNpcDeath(); } // npc_death
	void OnFakePrecache() { DemonwingVenom_OnFakePrecache(); } // fake_precache
	void OnAsNpcatkSuspendAi(float value = 0.0f, string value2 = "") {} // as_npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool DemonwingVenom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "baby_suicide") { OnBabySuicide(); return true; }
		if (name == "check_ceiling") { OnCheckCeiling(); return true; }
		if (name == "detatch_from_cieling") { OnDetatchFromCieling(); return true; }
		if (name == "do_spit_cycle") { OnDoSpitCycle(); return true; }
		if (name == "do_spit_cycle_loop") { OnDoSpitCycleLoop(); return true; }
		if (name == "end_spit_cycle") { OnEndSpitCycle(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "final_props") { OnFinalProps(); return true; }
		if (name == "fly_mode") { OnFlyMode(); return true; }
		if (name == "frame_attack_claw") { OnFrameAttackClaw(); return true; }
		if (name == "frame_detatch_done") { OnFrameDetatchDone(); return true; }
		if (name == "frame_flap") { OnFrameFlap(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "instant_target") { OnInstantTarget(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_stuck") { OnNpcStuck(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "set_no_ceiling_idle") { OnSetNoCeilingIdle(); return true; }
		if (name == "stick_ceiling") { OnStickCeiling(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/demonwing_venom"]
shared class DemonwingVenomScript : BaseMonsterNewScript, DemonwingVenom, BaseFlyerGrav, BasePropelled
{
	// Variables every script that includes this file declares
	string NPC_BASE_EXP = "NPC_BASE_EXP";

	// Variables declared by included files, with the value they start with in this script
	DemonwingVenomScript()
	{
		ANIM_WALK = "Flying_cycler";
		ANIM_IDLE = "Hover_slow";
		SOUND_DEATH = "monsters/demonwing/demonwing_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/demonwing.mdl");
		Precache("monsters/bat/flap_big1.wav");
		Precache("monsters/bat/flap_big2.wav");
		Precache("bullchicken/bc_attack2.wav");
		Precache("monsters/bat/flap_big.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DemonwingVenom_FirstThink();
		DemonwingVenom_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DemonwingVenom_DispatchEvent(name, params)
			|| BaseFlyerGrav_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
