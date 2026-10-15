#pragma context server

// Converted from phlames/phlame_bird.script by msc_transpiler.
// Revenge of the Stuckabat
// bigger, fire variant, for phlame
// new tricks:
// - periodically bombs targets directly beneath it when in flight
// - uses meteors instead of poiosn spits (though fires slower)
// - repelling fire breath
// - periodically dashes to center ceiling

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/base_propelled.as"

[script "phlames/phlame_bird"]
class PhlameBird : BaseMonsterNewScript, BaseFlyerGrav, BasePropelled
{
	// Constants
	string ANIM_CEILING_LAND = "Land_ceiling";
	string ANIM_CEILING_DETATCH = "ceiling_detatch";
	string ANIM_CEILING_IDLE1 = "Subtle_fidget";
	string ANIM_CEILING_IDLE2 = "Preen_fidget";
	string ANIM_CEILING_IDLE3 = "Swing_fidget";
	string ANIM_FLY = "Flying_cycler";
	string ANIM_HOVER = "Hover_slow";
	string ANIM_BOOST = "Dive_cycler";
	float FREQ_SPIT_CYCLE = 30.0f;
	string ANIM_FLINCH1 = "Flinch_big";
	string ANIM_FLINCH2 = "Flinch_small";
	bool AS_CUSTOM_UNSTUCK = true;
	string ATTACK_BOMB = "Attack_bomb";
	string ANIM_DIVE = "Dive_cycler";
	float DMG_CLAW = 250.0f;
	float DOT_FIRE = 40.0f;
	float FREQ_HORROR_BOOST = 0.0f;
	int DMG_SPIT = 100;
	int DMG_BOMB = 400;
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
	string SOUND_SPIT = "SOUND_SPIT";
	string SOUND_CIELING_FIDGET = "monsters/demonwing/demonwing_slct.wav";
	float FREQ_BOMB = 10.0f;
	float FREQ_BOMB_CHECK = 1.0f;
	string SOUND_FIRE_BREATH = "monsters/goblin/sps_fogfire.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NO_CIELING_IDLE = true;
	float NPC_HACKED_MOVE_SPEED = 400.0f;
	bool IS_UNHOLY = false;
	float FLAP_STEP = 0.0f;
	float SPIT_FIRE_CYCLE = 0.0f;
	bool CIELING_MODE = false;
	float MIN_FLINCH_DAMAGE = 0.0f;
	bool NPC_PROPELL_SUSPEND = false;
	bool NPC_NO_MOVE = false;
	bool BFLY_SUSPEND_FLY = false;
	bool GROUND_MODE = false;
	float NEXT_CIELING_FIDGET = 0.0f;
	float GO_TO_SLEEP = 0.0f;
	float NEXT_SPIT_CYCLE = 0.0f;
	float NEXT_BOMB_SCAN = 0.0f;
	string BOMB_TARGET = "BOMB_TARGET";
	float NEXT_BOMB = 0.0f;
	float NEXT_HORROR_BOOST = 0.0f;
	float NEXT_GROUND_MODE = 0.0f;
	float NEXT_FLINCH = 0.0f;
	bool CLAW_ATTACK = false;
	bool SPIT_MODE = false;
	bool FIRE_BREATH_ON = false;
	string FB_CL_SCRIPT_ID = "FB_CL_SCRIPT_ID";
	float BREATH_YAW = 0.0f;
	string TARGET_LIST = "TARGET_LIST";
	string SPIT_TARGET = "SPIT_TARGET";
	bool PHLAME_BIRD = false;
	string MY_OWNER = "MY_OWNER";
	float NEXT_SCAN = 0.0f;
	string BREATH_TARGS = "BREATH_TARGS";
	Vector3 MY_ORG = Vector3();
	string MY_ANGLES = "MY_ANGLES";
	bool FIRE_BOMB_ATTACK = false;
	Vector3 FIRE_BOMB_POS = Vector3();
	bool IS_FIRE_BOMB = false;

	// Variables declared by included files, with the value they start with in this script
	PhlameBird()
	{
		ANIM_WALK = "Flying_cycler";
		ANIM_IDLE = "Hover_slow";
		SOUND_DEATH = "monsters/demonwing/demonwing_dead.wav";
	}

	// unnamed block (first think)
	void PhlameBird_FirstThink()
	{
		ANIM_WALK = "Flying_cycler";
		ANIM_IDLE = "Hover_slow";
		ANIM_ATTACK = "Attack_claw"; // frame_attack_claw

		ANIM_DEATH = "Hover_slow";
	}

	// unnamed block (first think)
	void PhlameBird_FirstThink2()
	{
		NPC_GIVE_EXP = 5000.0f;

		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 180.0f;

		NO_CIELING_IDLE = true; // never ceiling idle
		NPC_HACKED_MOVE_SPEED = 400.0f;
	}

	// game_dodamage
	string PhlameBird_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (CLAW_ATTACK && RandomInt(1, 4) == 1)
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		CLAW_ATTACK = false;

		if (FIRE_BOMB_ATTACK && hit && RelationshipOf(target, ENT_ME) == "enemy")
		{
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);

			Vector3 targOrg = OriginOf(target);
			Vector3 myOrg = FIRE_BOMB_POS;
			float newYaw = AnglesTo(myOrg, targOrg);
			AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
		}
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
		if (FIRE_BREATH_ON)
			ClientEvent("update", "all", FB_CL_SCRIPT_ID, "end_fx");

		if (!PHLAME_BIRD)
			return;
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		SetAnimFrameRate(0);
		SetAnimMoveSpeed(0);
		SetMoveSpeed(0);
		CallExternal(MY_OWNER, "transform_return", OriginOf(ENT_ME));
		DeleteEntity(ENT_ME);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		if (creatorValue2 == "phlame")
			PHLAME_BIRD = true;
		MY_OWNER = creatorValue1;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
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

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Phlame Transformed");
		SetModel("monsters/demonwing_large.mdl");
		SetHealth(10000);
		SetWidth(64);
		SetHeight(96);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetRace("demon");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(4);

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 1.5f);

		IS_UNHOLY = true;

		FLAP_STEP = 0.0f;

		CallEventDelayed(2.0f, "final_props");

		if (NO_CIELING_IDLE)
			SetHearingSensitivity(8);

		SPIT_FIRE_CYCLE = 0.0f;

		if (NO_CIELING_IDLE)
			return;
		OnNpcatkSuspendAi("2.0");
		CIELING_MODE = true;
		CallEventDelayed(0.1f, "stick_ceiling");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		bool exitSub = false;

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

		if (GameTime() > NEXT_BOMB_SCAN && !SPIT_MODE)
		{
			NEXT_BOMB_SCAN = GameTime() + 0.0f;
			Vector3 bombPoint = OriginOf(ENT_ME);
			bombPoint.z = GroundHeight(bombPoint);

			// make sure i'm at least 100 units from ground
			float myZ = OriginOf(ENT_ME).z;
			if (myZ > bombPoint.z)
			{
				myZ -= bombPoint.z;
				if (myZ < 100.0f)
					exitSub = true;
			}
			else
			{
				float bombZ = bombPoint.z - myZ;
				if (myZ < 100.0f)
					exitSub = true;
			}
			if (!exitSub)
			{
				BOMB_TARGET = LegacyFunction("get_tsphere", "enemy", 128, bombPoint);
				if (BOMB_TARGET != "none")
				{
					BOMB_TARGET = GetToken(BOMB_TARGET, 0);
					if (GameTime() > NEXT_BOMB)
					{
						NEXT_BOMB = GameTime() + FREQ_BOMB;
						PlayAnim("critical", ATTACK_BOMB);
					}
				}
			}
		}

		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;

		if (SPIT_MODE)
			return;

		if (!(GameTime() > NEXT_HORROR_BOOST))
			return;
		NEXT_HORROR_BOOST = GameTime() + FREQ_HORROR_BOOST;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		PlaySound(0, 10, SOUND_HOVER);
		PlayAnim("once", ANIM_BOOST);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 0)));
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, PhlameBird_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// final_props
	void OnFinalProps()
	{
		MIN_FLINCH_DAMAGE = MaxHealthOf(ENT_ME) * 0.05f;
		NPC_DID_DEATH = true; // custom death
	}

	// stick_ceiling
	void OnStickCeiling()
	{
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

	// detatch_from_cieling
	void OnDetatchFromCieling()
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
	void OnFrameDetatchDone()
	{
		BFLY_SUSPEND_FLY = false;
		NO_STUCK_CHECKS = "0";
		NPC_PROPELL_SUSPEND = false;
		SetRoam(true);
	}

	// fly_mode
	void OnFlyMode()
	{
		SetGravity(0);
		ANIM_IDLE = ANIM_HOVER;
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_FLY);
		SetIdleAnim(ANIM_HOVER);
	}

	// set_no_ceiling_idle
	void OnSetNoCeilingIdle()
	{
		NO_CIELING_IDLE = true;
	}

	// frame_flap
	void OnFrameFlap()
	{
		FLAP_STEP += 1.0f;
		if (FLAP_STEP == 1.0f)
		{
			PlaySound(0, 10, SOUND_FLAP1);
		}
		else
		{
			PlaySound(0, 10, SOUND_FLAP2);
			FLAP_STEP = 0.0f;
		}
	}

	// frame_attack_claw
	void OnFrameAttackClaw()
	{
		if (SPIT_MODE)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		CLAW_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "90%", "slash");
	}

	// npc_stuck
	void OnNpcStuck()
	{
		if (!SUSPEND_AI)
			OnAsNpcatkSuspendAi(AS_WIGGLE_DURATION);
		NPC_FORCED_MOVEDEST = true;
		Vector3 moveDest = MY_ORG;
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
	void OnDoSpitCycle()
	{
		OnNpcatkSuspendAi();
		NPC_PROPELL_SUSPEND = true;
		ANIM_WALK = ANIM_HOVER;
		ANIM_RUN = ANIM_HOVER;
		ANIM_IDLE = ANIM_HOVER;
		SetMoveAnim(ANIM_HOVER);
		SetIdleAnim(ANIM_HOVER);

		SPIT_FIRE_CYCLE += 1.0f;
		if (SPIT_FIRE_CYCLE == 1.0f)
		{
			SPIT_MODE = true;
			OnDoSpitCycleLoop();
			CallEventDelayed(5.0f, "end_spit_cycle");
		}
		else
		{
			SPIT_MODE = true;
			OnDoFireBreathLoop();
			FIRE_BREATH_ON = true;
			ClientEvent("new", "all", "phlames/phlame_bird_cl", IndexOf(ENT_ME), 10.0f);
			FB_CL_SCRIPT_ID = LastClientScriptId();
			PlaySound(0, 10, SOUND_FIRE_BREATH);
			BREATH_YAW = AnglesOf(ENT_ME).y;
			OnFireBreathLoop();
			CallEventDelayed(10.0f, "end_fire_breath");

			SPIT_FIRE_CYCLE = 0.0f;
		}
	}

	// do_spit_cycle_loop
	void OnDoSpitCycleLoop()
	{
		if (!SPIT_MODE)
			return;
		CallEventDelayed(2.0f, "do_spit_cycle_loop");
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
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
		PlaySound(0, 10, SOUND_SPIT);
		PlayAnim("once", ANIM_ATTACK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_bomb", RelativePosition(Vector3(0, 0, -16)), SPIT_TARGET, 300, DMG_BOMB, 1, "none");
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0.0f);
	}

	// pick_target
	void OnPickTarget()
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
	void OnEndSpitCycle()
	{
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		NPC_PROPELL_SUSPEND = false;
		SPIT_MODE = false;
		ANIM_IDLE = ANIM_HOVER;
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_FLY);
		SetIdleAnim(ANIM_HOVER);
		NEXT_SPIT_CYCLE = GameTime() + FREQ_SPIT_CYCLE;

		// delay bombing for a bit
		NEXT_BOMB_SCAN = GameTime() + 0.0f;
		OnCenterDash();
	}

	// frame_attack_bomb
	// newer
	void OnFrameAttackBomb()
	{
		TossProjectile("proj_fire_bomb", RelativePosition(Vector3(0, 0, -16)), BOMB_TARGET, 300, DMG_BOMB, 1, "none");
	}

	// fire_breath_loop
	void OnFireBreathLoop()
	{
		if (!FIRE_BREATH_ON)
			return;
		CallEventDelayed(0.1f, "fire_breath_loop");
		BREATH_YAW += 4.0f;
		if (BREATH_YAW > 359.99f)
			BREATH_YAW -= 359.99f;
		Vector3 facePos = OriginOf(ENT_ME);
		facePos += RelativePosition(Vector3(0, BREATH_YAW, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);
		SetVelocity(ENT_ME, Vector3(0, 0, 0));

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 1.0f;

		BREATH_TARGS = FindInSphere("enemy", 512);
		if (BREATH_TARGS == "none")
			return;
		MY_ORG = OriginOf(ENT_ME);
		MY_ANGLES = Text(AnglesOf(ENT_ME));
		int count = GetTokenCount(BREATH_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, 1000, 110)));
	}

	// end_fire_breath
	void OnEndFireBreath()
	{
		FIRE_BREATH_ON = false;
		NPC_PROPELL_SUSPEND = false;
		SPIT_MODE = false;
		ANIM_IDLE = ANIM_HOVER;
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_FLY);
		SetIdleAnim(ANIM_HOVER);
		NEXT_SPIT_CYCLE = GameTime() + FREQ_SPIT_CYCLE;
		PlayAnim("break");
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		OnCenterDash();
	}

	// center_dash
	void OnCenterDash()
	{
		SetRoam(false);
		PlayAnim("critical", ANIM_DIVE);
		string centerPoint = ScriptVarOf(MY_OWNER, "NPC_HOME_LOC");
		SetMoveDest(centerPoint, 1);
		DebugPrint("center_dash " + centerPoint);
		PlaySound(0, 10, SOUND_FLAP2);
		CallEventDelayed(0.1f, "center_dash_boost");
		CallEventDelayed(1.5f, "center_dash_stop");
	}

	// center_dash_boost
	void OnCenterDashBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, 300)));
	}

	// center_dash_stop
	void OnCenterDashStop()
	{
		SetRoam(true);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 0)));
	}

	// ext_fire_bomb
	// <land point> - called by proj_fire_bomb
	void OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		FIRE_BOMB_ATTACK = true;
		FIRE_BOMB_POS = landPosition;
		IS_FIRE_BOMB = true;
		DoDamageEx(FIRE_BOMB_POS, 250, DMG_BOMB, 0.1f, ENT_ME, ENT_ME, "none", "blunt");
		// dodamage FIRE_BOMB_POS 200 DMG_BOMB 100% 0.05 reflective blunt
		CallEventDelayed(0.1f, "fire_bomb_reset");
	}

	// fire_bomb_reset
	void OnFireBombReset()
	{
		FIRE_BOMB_ATTACK = false;
	}

	// frame_flap_panic
	void OnFrameFlapPanic()
	{
		PlaySound(0, 10, SOUND_HOVER);
		CallEventDelayed(0.1f, "frame_flap_panic2");
	}

	// frame_flap_panic2
	void OnFrameFlapPanic2()
	{
		PlaySound(0, 10, SOUND_HOVER);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

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

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
	}

	void OnAsNpcatkSuspendAi(float value = 0.0f, string value2 = "") {} // as_npcatk_suspend_ai
	void OnDoFireBreathLoop() {} // do_fire_breath_loop

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/demonwing_large.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PhlameBird_FirstThink();
		PhlameBird_FirstThink2();
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
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "center_dash") { OnCenterDash(); return true; }
		if (name == "center_dash_boost") { OnCenterDashBoost(); return true; }
		if (name == "center_dash_stop") { OnCenterDashStop(); return true; }
		if (name == "detatch_from_cieling") { OnDetatchFromCieling(); return true; }
		if (name == "do_spit_cycle") { OnDoSpitCycle(); return true; }
		if (name == "do_spit_cycle_loop") { OnDoSpitCycleLoop(); return true; }
		if (name == "end_fire_breath") { OnEndFireBreath(); return true; }
		if (name == "end_spit_cycle") { OnEndSpitCycle(); return true; }
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "final_props") { OnFinalProps(); return true; }
		if (name == "fire_bomb_reset") { OnFireBombReset(); return true; }
		if (name == "fire_breath_loop") { OnFireBreathLoop(); return true; }
		if (name == "fly_mode") { OnFlyMode(); return true; }
		if (name == "frame_attack_bomb") { OnFrameAttackBomb(); return true; }
		if (name == "frame_attack_claw") { OnFrameAttackClaw(); return true; }
		if (name == "frame_detatch_done") { OnFrameDetatchDone(); return true; }
		if (name == "frame_flap") { OnFrameFlap(); return true; }
		if (name == "frame_flap_panic") { OnFrameFlapPanic(); return true; }
		if (name == "frame_flap_panic2") { OnFrameFlapPanic2(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_stuck") { OnNpcStuck(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "set_no_ceiling_idle") { OnSetNoCeilingIdle(); return true; }
		if (name == "stick_ceiling") { OnStickCeiling(); return true; }
		return BaseFlyerGrav_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
