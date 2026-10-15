#pragma context server

// Converted from monsters/beetle_base.script by msc_transpiler.
// Beetlejuice! Beetlejuice! Beetlejuice! By thothie.
// Base for fire, poison, and death beetles

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BeetleBase
{
	// Constants
	string ANIM_RUN_DEFAULT = "bug_run";
	string ANIM_WALK_DEFAULT = "bug_walk";
	string ANIM_IDLE_DEFAULT = "bug_idle";
	string ANIM_ATTACK_LEAP = "bug_leapatk";
	string ANIM_ATTACK_CLAW = "bug_claw_up";
	string ANIM_ATTACK_GORE = "bug_gore";
	string ANIM_ATTACK_SLAM = "bug_slam";
	string ANIM_TO_BACK = "bug_toback";
	string ANIM_BACK_TO_FEET = "bug_backtofeet";
	string ANIM_IDLE_ONBACK = "bug_onback";
	string ANIM_DEATH_ONBACK = "bug_back_to_death";
	string ANIM_DEATH_NORMAL = "bug_death";
	string ANIM_FLY = "bug_jump";
	string ANIM_SPECIAL = "bug_conjure";
	string ANIM_RISE_FROM_GROUND = "bug_rise";
	string ANIM_RAWR = "bug_rawr";
	string ANIM_ALERT = "bug_alert";
	int BBET_SIZE = 1;
	bool BBET_CAN_FLY = true;
	bool BBET_CAN_LEAP = true;
	bool BBET_CAN_SLAM = false;
	int BBET_GORE_PUSH_STR = 400;
	int BBET_FAKE_DEATH = 0;
	float BBET_MAX_FLY_TIME = 8.0f;
	bool BBET_HORN = false;
	float FREQ_ALERT = 10.0f;
	float FREQ_SEARCH = 10.0f;
	float FREQ_FORCE_GORE = 15.0f;
	float FREQ_SLAM = 0.0f;
	float FREQ_FLY = 0.0f;
	float FREQ_FLY_LEAP = 0.0f;
	int AOE_GORE = 96;
	float DMG_SLASH = 60.0f;
	int DMG_GORE = 120;
	int DMG_LEAP = 300;
	int DMG_SLAM = 400;
	string ATTACK_HITCHANCE = "90%";
	string DMGTYPE_GORE = "pierce";
	string BBET_CL_SCRIPT = "monsters/beetle_base_cl";
	string SOUND_ATTACK1 = "monsters/beetle/attack_single1.wav";
	string SOUND_ATTACK2 = "monsters/beetle/attack_single2.wav";
	string SOUND_ATTACK3 = "monsters/beetle/attack_single3.wav";
	string SOUND_SWIPE = "zombie/claw_miss1.wav";
	string SOUND_GROWL = "monsters/beetle/distract1.wav";
	string SOUND_DIG1 = "monsters/beetle/dig1.wav";
	string SOUND_DIG2 = "monsters/beetle/dig2.wav";
	string SOUND_DIGWARN = "monsters/beetle/rumble1.wav";
	string SOUND_IDLE1 = "monsters/beetle/idle1.wav";
	string SOUND_IDLE2 = "monsters/beetle/idle2.wav";
	string SOUND_IDLE3 = "monsters/beetle/idle3.wav";
	string SOUND_IDLE4 = "monsters/beetle/idle4.wav";
	string SOUND_IDLE5 = "monsters/beetle/idle5.wav";
	string SOUND_FLY_LOOP = "monsters/beetle/fly1.wav";
	string SOUND_CHITTER_LOOP = "monsters/beetle/charge_loop1.wav";
	string SOUND_LAND = "monsters/beetle/land1.wav";
	string SOUND_SLAM = "magic/boom.wav";
	string SOUND_PAIN1 = "monsters/beetle/pain1.wav";
	string SOUND_PAIN2 = "monsters/beetle/pain2.wav";
	string SOUND_STRUCK1 = "monsters/beetle/shell_impact1.wav";
	string SOUND_STRUCK2 = "monsters/beetle/shell_impact2.wav";
	string SOUND_STRUCK3 = "monsters/beetle/shell_impact3.wav";
	string SOUND_STRUCK4 = "monsters/beetle/shell_impact4.wav";
	string SOUND_GIBBED = "monsters/beetle/squashed.wav";
	string SOUND_DEATH = "monsters/beetle/pain2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "bug_walk";
	string ANIM_IDLE = "bug_idle";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string BBET_LARGE_MODEL = "monsters/beetles.mdl";
	string BBET_GIANT_MODEL = "monsters/beetles_giant.mdl";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	int ATTACK_RANGE_LEAP = 0;
	int ATTACK_HITRANGE_LEAP = 0;
	int ATTACK_RANGE_GORE = 0;
	int ATTACK_HITRANGE_GORE = 0;
	int ATTACK_RANGE_CLAW = 0;
	int ATTACK_HITRANGE_CLAW = 0;
	int BBET_SLAM_RADIUS = 0;
	int BBET_BURROW_CLOUD_RADIUS = 0;
	int BBET_WILL_FAKE_DEATH = 0;
	float BBET_HALF_HP = 0.0f;
	float BBET_NEXT_FLY_LEAP = 0.0f;
	float NEXT_SLAM = 0.0f;
	float NEXT_ALERT = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool BBET_DID_GROWL = false;
	float NEXT_SEARCH = 0.0f;
	float NEXT_FORCE_GORE = 0.0f;
	bool GORE_ATTACK = false;
	bool LEAP_ATTACK = false;
	bool BBET_BURROWER = false;
	float BBET_RENDERAMT = 0.0f;
	bool BBET_RISE_FINALIZED = false;
	bool BBET_DID_FAKE_DEATH = false;
	bool BBET_ONBACK = false;
	bool BBET_FLY_LEAP = false;
	bool BBET_FLYING = false;
	string BBET_WINGS_CL_IDX = "BBET_WINGS_CL_IDX";
	bool NPC_NO_ATTACK = false;
	float BBET_NEXT_FLY = 0.0f;
	bool BBET_WAITING_TO_DROP = false;

	// unnamed block (first think)
	void BeetleBase_FirstThink()
	{
		// base anims
		ANIM_WALK = "bug_walk";
		ANIM_IDLE = "bug_idle";
		ANIM_RUN = "bug_run";
		ANIM_ATTACK = "bug_leapatk";
		ANIM_DEATH = "bug_death";
		ANIM_FLINCH = "bug_flinch"; // suggest bug_flinch2 for larger beetles
	}

	// unnamed block (first think)
	void BeetleBase_FirstThink2()
	{
		// precache model to be used in top script
		BBET_LARGE_MODEL = "monsters/beetles.mdl";
		BBET_GIANT_MODEL = "monsters/beetles_giant.mdl";
	}

	// game_spawn
	void BeetleBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (BBET_SIZE == 1)
		{
			// large beetle
			SetModel(BBET_LARGE_MODEL);
			SetWidth(40);
			SetHeight(40);
			ATTACK_MOVERANGE = 48.0f;
			ATTACK_RANGE = 130.0f;
			ATTACK_HITRANGE = 160.0f;
			ATTACK_RANGE_LEAP = 150;
			ATTACK_HITRANGE_LEAP = 175;
			ATTACK_RANGE_GORE = 64;
			ATTACK_HITRANGE_GORE = 100;
			ATTACK_RANGE_CLAW = 32;
			ATTACK_HITRANGE_CLAW = 64;
			BBET_SLAM_RADIUS = 128;
			BBET_BURROW_CLOUD_RADIUS = 64;
		}

		if (BBET_SIZE == 2)
		{
			// giant beetle
			SetModel(BBET_GIANT_MODEL);
			SetWidth(72);
			SetHeight(72);
			ATTACK_MOVERANGE = 64.0f;
			ATTACK_RANGE = 80.0f;
			ATTACK_HITRANGE = 150.0f;
			ATTACK_RANGE_GORE = 80;
			ATTACK_HITRANGE_GORE = 150;
			ATTACK_RANGE_CLAW = 48;
			ATTACK_HITRANGE_CLAW = 96;
			BBET_SLAM_RADIUS = 256;
			BBET_BURROW_CLOUD_RADIUS = 128;
		}

		SetRace("spider");
		SetHearingSensitivity(4);
		SetRoam(true);

		if (!BBET_BURROWER)
		{
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_WALK);
		}

		BBET_WILL_FAKE_DEATH = BBET_FAKE_DEATH;

		OnBeetleSpawn();
	}

	// npc_post_spawn
	void BeetleBase_OnNpcPostSpawn()
	{
		BBET_HALF_HP = Divide(MaxHealthOf(ENT_ME), 2.0f);
		if (BBET_SIZE == 2) // to stop big bugs from crawling on top of the weed ones
			SetStepSize(16);
	}

	// npcatk_hunt
	// =================== Main Cycle
	void BeetleBase_OnNpcatkHunt()
	{
		if (!BBET_CAN_FLY)
			return;
		if (BBET_ONBACK)
			return;
		if (SUSPEND_AI)
			return;
		if (BBET_FLYING)
			return;
		if (I_R_FROZEN)
			return;
		if (!(GameTime() > BBET_NEXT_FLY))
			return;
		if (NPCATK_TARGET != "unset")
		{
			if (RangeTo(NPCATK_TARGET) < 800.0f)
			{
				float myZ = OriginOf(ENT_ME).z;
				float targZ = OriginOf(NPCATK_TARGET).z;
				if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
					targZ -= 38.0f;

				float zDiff = targZ - myZ;
				if (zDiff > 64.0f)
					OnBbetFlyStart();
			}

			if (RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE && GameTime() > BBET_NEXT_FLY_LEAP)
			{
				BBET_NEXT_FLY_LEAP = GameTime() + FREQ_FLY_LEAP;
				OnBbetFlyLeap();
			}
		}
	}

	// npc_selectattack
	void BeetleBase_OnNpcSelectattack()
	{
		float targRange = RangeTo(NPCATK_TARGET);
		if (BBET_CAN_LEAP && targRange < ATTACK_RANGE_LEAP && targRange > ATTACK_RANGE_GORE)
			ANIM_ATTACK = ANIM_ATTACK_LEAP;

		if (targRange < ATTACK_RANGE_GORE && targRange > ATTACK_RANGE_CLAW)
			ANIM_ATTACK = ANIM_ATTACK_GORE;

		if (targRange < ATTACK_RANGE_CLAW)
		{
			ANIM_ATTACK = ANIM_ATTACK_CLAW;
			if (GameTime() > NEXT_FORCE_GORE)
			{
				ANIM_ATTACK = ANIM_ATTACK_GORE; // reset NEXT_FORCE_GORE in attack anim
			}
		}

		if (BBET_CAN_SLAM)
		{
			if (GameTime() > NEXT_SLAM) // reset in anim event
				ANIM_ATTACK = ANIM_ATTACK_SLAM;
		}
	}

	// cycle_up
	void BeetleBase_OnCycleUp(string reason = "")
	{
		if (BBET_CAN_SLAM)
			NEXT_SLAM = GameTime() + FREQ_SLAM;

		if (BBET_CAN_FLY)
		{
			if (RandomInt(1, 2) == 1) // so they don't all take flight at once
				BBET_NEXT_FLY_LEAP = GameTime() + FREQ_FLY_LEAP;
		}

		if (!(GameTime() > NEXT_ALERT))
			return;
		NEXT_ALERT = GameTime() + FREQ_ALERT;
		AS_ATTACKING = GameTime();
		int rndAnim = RandomInt(1, 2);
		if (rndAnim == 1)
			PlayAnim("critical", ANIM_ALERT);
		if (rndAnim == 2)
			PlayAnim("critical", ANIM_RAWR);
		PlaySound(0, 10, SOUND_GROWL);
	}

	// npc_targetsighted
	void BeetleBase_OnNpcTargetsighted(string target = "")
	{
		if (BBET_DID_GROWL)
			return;
		BBET_DID_GROWL = true;
		AS_ATTACKING = GameTime();
		int rndAnim = RandomInt(1, 2);
		if (rndAnim == 1)
			PlayAnim("critical", ANIM_ALERT);
		if (rndAnim == 2)
			PlayAnim("critical", ANIM_RAWR);
		PlaySound(0, 10, SOUND_GROWL);
	}

	// cycle_down
	void BeetleBase_OnCycleDown()
	{
		BBET_DID_GROWL = false;
	}

	// npcatk_lost_sight
	void BeetleBase_OnNpcatkLostSight()
	{
		if (!(GameTime() > NEXT_SEARCH))
			return;
		NEXT_SEARCH = GameTime() + FREQ_SEARCH;
		PlayAnim("once", ANIM_ALERT);
		PlaySound(0, 10, SOUND_GROWL);
	}

	// frame_gore_start
	// =================== Anim Events
	void BeetleBase_OnFrameGoreStart()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// frame_gore
	void BeetleBase_OnFrameGore()
	{
		NEXT_FORCE_GORE = GameTime() + FREQ_FORCE_GORE;
		GORE_ATTACK = true;
		if (BBET_SIZE == 1)
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_GORE, DMG_GORE, ATTACK_HITCHANCE, DMGTYPE_GORE);
		else
			DoDamageEx(AttachmentPositionOf(ENT_ME, BBET_HORN), AOE_GORE, DMG_GORE, 0, ENT_ME, ENT_ME, "none", DMGTYPE_GORE);
		CallEventDelayed(0.1f, "bbet_reset_gore_attack"); // time delay in case AOE hits multiple targs
	}

	// frame_leap_start
	void BeetleBase_OnFrameLeapStart()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		ServerPlaySound(1, 10, SOUND_CHITTER_LOOP);
	}

	// frame_leap_attack1
	void BeetleBase_OnFrameLeapAttack1()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_LEAP, DMG_LEAP, ATTACK_HITCHANCE, "slash");
		LEAP_ATTACK = true;
		PlaySound(0, 5, SOUND_LAND);
		ServerPlaySound(1, 0, SOUND_CHITTER_LOOP);
	}

	// frame_claw_up
	void BeetleBase_OnFrameClawUp()
	{
		if (RandomInt(1, 5) != 1)
			PlaySound(0, 10, SOUND_SWIPE);
		else
			PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE_CLAW, DMG_LEAP, ATTACK_HITCHANCE, "slash");
	}

	// bbet_reset_gore_attack
	void BeetleBase_OnBbetResetGoreAttack()
	{
		GORE_ATTACK = false;
	}

	// game_dodamage
	string BeetleBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (GORE_ATTACK && Exists(target))
			AddVelocity(target, RelativeVelocity(Vector3(-10, BBET_GORE_PUSH_STR, 110)));

		if (LEAP_ATTACK && Exists(target))
			AddVelocity(target, RelativeVelocity(Vector3(-10, BBET_GORE_PUSH_STR, 110)));

		LEAP_ATTACK = false; // gore attack reset via delay instead
		return result;
	}

	// frame_rise_done
	void BeetleBase_OnFrameRiseDone()
	{
		OnBbetRiseComplete();
	}

	// frame_slam_start
	void BeetleBase_OnFrameSlamStart()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// frame_slam
	void BeetleBase_OnFrameSlam()
	{
		PlayRandomSound(0, 10, SOUND_SLAM);
		NEXT_SLAM = GameTime() + FREQ_SLAM;
		OnBeetleSlam(); // to be handled in top script
	}

	// frame_on_back
	void BeetleBase_OnFrameOnBack()
	{
		PlayAnim("critical", ANIM_IDLE_ONBACK);
	}

	// set_burrower
	// =================== Add Params
	void BeetleBase_OnSetBurrower()
	{
		BBET_BURROWER = true;
		SetProp(ENT_ME, "rendermode", 1);
		SetProp(ENT_ME, "renderamt", 0);
		SetIdleAnim(ANIM_RISE_FROM_GROUND);
		SetMoveAnim(ANIM_RISE_FROM_GROUND);
		CallEventDelayed(0.1f, "bbet_burrower_effect");
	}

	// bbet_burrower_effect
	void BeetleBase_OnBbetBurrowerEffect()
	{
		Vector3 effectOrg = OriginOf(ENT_ME);
		effectOrg.z = GroundHeight(MyOrigin());
		PlaySound(0, 10, SOUND_DIG1);
		ClientEvent("new", "all", BBET_CL_SCRIPT, "burrow", effectOrg, BBET_BURROW_CLOUD_RADIUS);
		BBET_RENDERAMT = 0.0f;
		OnBbetBurrowerEffectFadein();
		PlayAnim("critical", ANIM_RISE_FROM_GROUND);
	}

	// bbet_burrower_effect_fadein
	void BeetleBase_OnBbetBurrowerEffectFadein()
	{
		BBET_RENDERAMT += 50.0f;
		if (BBET_RENDERAMT > 255.0f)
			BBET_RENDERAMT = 255.0f;
		SetProp(ENT_ME, "renderamt", BBET_RENDERAMT);
		if (BBET_RENDERAMT < 255.0f)
			CallEventDelayed(0.1f, "bbet_burrower_effect_fadein");
		if (BBET_RENDERAMT != 255.0f)
			return;
		SetProp(ENT_ME, "rendermode", 0);
		CallEventDelayed(2.0f, "bbet_rise_complete");
	}

	// bbet_rise_complete
	void BeetleBase_OnBbetRiseComplete()
	{
		if (BBET_RISE_FINALIZED)
			return;
		BBET_RISE_FINALIZED = true;
		PlaySound(0, 10, SOUND_DIG2);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// game_death
	// =================== El Morte
	void BeetleBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ServerPlaySound(1, 0, SOUND_CHITTER_LOOP);
		ServerPlaySound(2, 0, SOUND_FLY_LOOP);
		if (BBET_ONBACK)
			ANIM_DEATH = ANIM_DEATH_ONBACK;
		else
			ANIM_DEATH = ANIM_DEATH_NORMAL;
	}

	// game_struck
	// =================== Fake Death
	void BeetleBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlaySound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_PAIN1, SOUND_PAIN2);
		if (BBET_WILL_FAKE_DEATH == 0)
			return;
		if (BBET_DID_FAKE_DEATH)
			return;
		if (BBET_FLYING)
			return;
		if (!(HealthOf(ENT_ME) < BBET_HALF_HP))
			return;
		BBET_DID_FAKE_DEATH = true;
		OnBbetFakeDeath();
	}

	// bbet_fake_death
	void BeetleBase_OnBbetFakeDeath()
	{
		OnNpcatkSuspendMovement(ANIM_IDLE_ONBACK);
		PlayAnim("critical", ANIM_TO_BACK);
		BBET_ONBACK = true;
		CallEventDelayed(Random(4, 8), "bbet_get_up");
	}

	// bbet_get_up
	void BeetleBase_OnBbetGetUp()
	{
		OnNpcatkResumeMovement();
		PlayAnim("critical", ANIM_BACK_TO_FEET);
		BBET_ONBACK = false;
	}

	// unnamed block (timer)
	// =================== Idle Noises (or maybe just random noises)
	void BeetleBase_Timer()
	{
		CallEventDelayed(Random(8, 15), "BeetleBase_Timer");
		if (!IsAlive(ENT_ME))
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// bbet_fly_leap
	// =================== Flight (called from main cycle)
	void BeetleBase_OnBbetFlyLeap()
	{
		BBET_FLY_LEAP = true;
		OnBbetFlyStart();
	}

	// bbet_fly_start
	void BeetleBase_OnBbetFlyStart()
	{
		BBET_FLYING = true;
		SetGravity(0);
		SetModelBody(1, 1);
		BBET_WINGS_CL_IDX = LastClientScriptId();
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 200)));
		if (!BBET_FLY_LEAP)
			CallEventDelayed(BBET_MAX_FLY_TIME, "bbet_end_flight");
		else
			CallEventDelayed(2.0f, "bbet_end_flight");
		SetMoveAnim(ANIM_FLY);
		ANIM_WALK = ANIM_FLY;
		ANIM_RUN = ANIM_FLY;
		NPC_NO_ATTACK = true;
		ServerPlaySound(2, 10, SOUND_FLY_LOOP);
	}

	// npcatk_hunt
	void BeetleBase_OnNpcatkHunt_2()
	{
		float rndLr = 0.0f;
		float myGround = 0.0f;
		if (!BBET_FLYING)
			return;
		if (!IsAlive(ENT_ME)) // not sure if needed, think hunt cycle stops on death
			return;
		if (NPCATK_TARGET != "unset")
		{
			if (!BBET_FLY_LEAP)
			{
				float myZ = OriginOf(ENT_ME).z;
				float targZ = OriginOf(NPCATK_TARGET).z;
				if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
					targZ -= 38.0f;

				float zDiff = targZ - myZ;

				if (zDiff > 64.0f)
				{
					if (zDiff < 384.0f)
					{
						SetGravity(0);
						rndLr = Random(-10, 10);
						int fwdSpeed = 110;
						if (RangeTo(NPCATK_TARGET) > 400.0f)
							fwdSpeed = 210;
						AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, fwdSpeed, 200)));
					}
					else
					{
						// too high
						SetGravity(0.5f);
						if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
						{
							OnBbetEndFlight();
						}
						else
						{
							// but don't hit ground either
							myGround = GroundHeight(MyOrigin());
							if (MyOrigin().z == myGround)
								AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 110, 200)));
						}
					}
				}
				else
				{
					SetGravity(0.5f);
					if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
					{
						OnBbetEndFlight();
					}
					else
					{
						// on level, but dont get stuck on ground
						myGround = GroundHeight(MyOrigin());
						if (MyOrigin().z == myGround)
						{
							DebugPrint("stuck_ground");
							AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 110, 150)));
						}
					}
				}
			}
			else
			{
				// just leaping at target (short flight)
				if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
				{
					OnBbetEndFlight();
				}
				else
				{
					DebugPrint("leap_flight");
					SetGravity(0.5f);
					rndLr = Random(-10, 10);
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, 150, 200)));
				}
			}
		}
		else
		{
			OnBbetEndFlight();
		}

		if (!BBET_FLYING)
			return;
		if (!(STUCK_COUNT >= 1.0f))
			return;
		OnBbetEndFlight();
	}

	// bbet_end_flight
	void BeetleBase_OnBbetEndFlight()
	{
		if (!BBET_FLYING)
			return;

		BBET_NEXT_FLY = GameTime() + FREQ_FLY;

		BBET_FLYING = false;
		BBET_FLY_LEAP = false;
		ServerPlaySound(2, 0, SOUND_FLY_LOOP);
		SetGravity(1);
		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		SetMoveAnim(ANIM_RUN);
		NPC_NO_ATTACK = false;
		SetModelBody(1, 0);
		Vector3 myPos = OriginOf(ENT_ME);
		float groundZ = GroundHeight(myPos);
		if (myPos.z == groundZ)
			return;
		BBET_WAITING_TO_DROP = true;
		CallEventDelayed(5.0f, "bbet_stop_waiting_for_drop");
		OnBbetWaitToDropLoop();
	}

	// bbet_stop_waiting_for_drop
	void BeetleBase_OnBbetStopWaitingForDrop()
	{
		BBET_WAITING_TO_DROP = false;
	}

	// bbet_wait_to_drop_loop
	void BeetleBase_OnBbetWaitToDropLoop()
	{
		if (!BBET_WAITING_TO_DROP)
			return;

		Vector3 myPos = OriginOf(ENT_ME);
		float groundZ = GroundHeight(myPos);
		if (myPos.z != groundZ)
		{
			CallEventDelayed(0.1f, "bbet_wait_to_drop_loop");
		}
		else
		{
			PlaySound(0, 10, SOUND_LAND);
			BBET_WAITING_TO_DROP = false;
		}
	}

	// freeze_solid
	void BeetleBase_OnFreezeSolid()
	{
		if (!BBET_FLYING)
			return;
		OnBbetEndFlight();
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
		BeetleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		BeetleBase_OnNpcPostSpawn();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BeetleBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BeetleBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BeetleBase_OnNpcatkHunt();
		BeetleBase_OnNpcatkHunt_2();
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		BeetleBase_OnNpcatkLostSight();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BeetleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		BeetleBase_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		BeetleBase_OnCycleDown();
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BeetleBase_OnNpcSelectattack();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BeetleBase_OnNpcTargetsighted(target);
	}

	void OnFrameGoreStart() { BeetleBase_OnFrameGoreStart(); } // frame_gore_start
	void OnFrameGore() { BeetleBase_OnFrameGore(); } // frame_gore
	void OnFrameLeapStart() { BeetleBase_OnFrameLeapStart(); } // frame_leap_start
	void OnFrameLeapAttack1() { BeetleBase_OnFrameLeapAttack1(); } // frame_leap_attack1
	void OnFrameClawUp() { BeetleBase_OnFrameClawUp(); } // frame_claw_up
	void OnBbetResetGoreAttack() { BeetleBase_OnBbetResetGoreAttack(); } // bbet_reset_gore_attack
	void OnFrameRiseDone() { BeetleBase_OnFrameRiseDone(); } // frame_rise_done
	void OnFrameSlamStart() { BeetleBase_OnFrameSlamStart(); } // frame_slam_start
	void OnFrameSlam() { BeetleBase_OnFrameSlam(); } // frame_slam
	void OnFrameOnBack() { BeetleBase_OnFrameOnBack(); } // frame_on_back
	void OnSetBurrower() { BeetleBase_OnSetBurrower(); } // set_burrower
	void OnBbetBurrowerEffect() { BeetleBase_OnBbetBurrowerEffect(); } // bbet_burrower_effect
	void OnBbetBurrowerEffectFadein() { BeetleBase_OnBbetBurrowerEffectFadein(); } // bbet_burrower_effect_fadein
	void OnBbetRiseComplete() { BeetleBase_OnBbetRiseComplete(); } // bbet_rise_complete
	void OnBbetFakeDeath() { BeetleBase_OnBbetFakeDeath(); } // bbet_fake_death
	void OnBbetGetUp() { BeetleBase_OnBbetGetUp(); } // bbet_get_up
	void OnBbetFlyLeap() { BeetleBase_OnBbetFlyLeap(); } // bbet_fly_leap
	void OnBbetFlyStart() { BeetleBase_OnBbetFlyStart(); } // bbet_fly_start
	void OnBbetEndFlight() { BeetleBase_OnBbetEndFlight(); } // bbet_end_flight
	void OnBbetStopWaitingForDrop() { BeetleBase_OnBbetStopWaitingForDrop(); } // bbet_stop_waiting_for_drop
	void OnBbetWaitToDropLoop() { BeetleBase_OnBbetWaitToDropLoop(); } // bbet_wait_to_drop_loop
	void OnFreezeSolid() { BeetleBase_OnFreezeSolid(); } // freeze_solid
	void OnBbetMaxFlyTime() {} // BBET_MAX_FLY_TIME
	void OnBeetleSlam() {} // beetle_slam
	void OnBeetleSpawn() {} // beetle_spawn

	// This file's events and timers by their .script names
	bool BeetleBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bbet_burrower_effect") { OnBbetBurrowerEffect(); return true; }
		if (name == "bbet_burrower_effect_fadein") { OnBbetBurrowerEffectFadein(); return true; }
		if (name == "bbet_end_flight") { OnBbetEndFlight(); return true; }
		if (name == "bbet_fake_death") { OnBbetFakeDeath(); return true; }
		if (name == "bbet_fly_leap") { OnBbetFlyLeap(); return true; }
		if (name == "bbet_fly_start") { OnBbetFlyStart(); return true; }
		if (name == "bbet_get_up") { OnBbetGetUp(); return true; }
		if (name == "bbet_reset_gore_attack") { OnBbetResetGoreAttack(); return true; }
		if (name == "bbet_rise_complete") { OnBbetRiseComplete(); return true; }
		if (name == "bbet_stop_waiting_for_drop") { OnBbetStopWaitingForDrop(); return true; }
		if (name == "bbet_wait_to_drop_loop") { OnBbetWaitToDropLoop(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "frame_claw_up") { OnFrameClawUp(); return true; }
		if (name == "frame_gore") { OnFrameGore(); return true; }
		if (name == "frame_gore_start") { OnFrameGoreStart(); return true; }
		if (name == "frame_leap_attack1") { OnFrameLeapAttack1(); return true; }
		if (name == "frame_leap_start") { OnFrameLeapStart(); return true; }
		if (name == "frame_on_back") { OnFrameOnBack(); return true; }
		if (name == "frame_rise_done") { OnFrameRiseDone(); return true; }
		if (name == "frame_slam") { OnFrameSlam(); return true; }
		if (name == "frame_slam_start") { OnFrameSlamStart(); return true; }
		if (name == "freeze_solid") { OnFreezeSolid(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "set_burrower") { OnSetBurrower(); return true; }
		if (name == "BeetleBase_Timer") { BeetleBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/beetle_base"]
shared class BeetleBaseScript : BaseMonsterNewScript, BeetleBase
{
	// Variables declared by included files, with the value they start with in this script
	BeetleBaseScript()
	{
		ANIM_WALK = "bug_walk";
		ANIM_IDLE = "bug_idle";
		SOUND_DEATH = "monsters/beetle/pain2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleBase_FirstThink();
		BeetleBase_FirstThink2();
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
		return BeetleBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
