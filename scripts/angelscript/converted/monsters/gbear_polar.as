#pragma context server

// Converted from monsters/gbear_polar.script by msc_transpiler.
// first of the new bear models
// base for the other greater bears using the similar model

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GbearPolar
{
	// Constants
	string ANIM_RUN_NORM = "run";
	string ANIM_WALK_NORM = "walk";
	string ANIM_IDLE_NORM = "idle";
	string ANIM_ATTACK1 = "attack1";
	string ANIM_ATTACK2 = "attack2";
	string ANIM_ATTACK3 = "attack3";
	string ANIM_LUNGE1 = "long_attack1";
	string ANIM_LUNGE2 = "long_attack2";
	string ANIM_LUNGE3 = "long_attack_throw";
	string ANIM_BREATH_START = "breath_start";
	string ANIM_BREATH_LOOP = "breath_loop";
	string ANIM_WARCRY1 = "warcry";
	string ANIM_WARCRY2 = "alert";
	string ANIM_LOOK1 = "sniff_left";
	string ANIM_LOOK2 = "sniff_right";
	string ANIM_PUSHL = "attack_pushl";
	string ANIM_PUSHR = "attack_pushr";
	string ANIM_SWIM = "swim";
	string SOUND_ATTACK1 = "monsters/bear/c_bear_atk1.wav";
	string SOUND_ATTACK2 = "monsters/bear/c_bear_atk2.wav";
	string SOUND_ATTACK3 = "monsters/bear/c_bear_atk3.wav";
	string SOUND_PAIN1 = "monsters/bear/c_bear_hit1.wav";
	string SOUND_PAIN2 = "monsters/bear/c_bear_hit2.wav";
	string SOUND_PAIN3 = "monsters/bear/c_bear_bat1.wav";
	string SOUND_PAIN4 = "monsters/bear/c_bear_bat2.wav";
	string SOUND_DEATH = "monsters/bear/c_bear_dead.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_WARCRY = "monsters/bear/c_beardire_bat1.wav";
	string SOUND_RUNSTEP1 = "monsters/bear/giantbearstep1.wav";
	string SOUND_RUNSTEP2 = "monsters/bear/giantbearstep2.wav";
	string SOUND_SWIM1 = "player/pl_wade1.wav";
	string SOUND_SWIM2 = "player/pl_wade2.wav";
	string SOUND_SWIM3 = "player/pl_wade3.wav";
	string SOUND_SWIM4 = "player/pl_wade4.wav";
	string SOUND_DIVE = "body/splash1.wav";
	int ATTACK_RANGE_NORM = 125;
	int ATTACK_HITRANGE_NORM = 150;
	int ATTACK_HITRANGE_SWIM = 300;
	int ATTACK_RANGE_LUNGE_MIN = 175;
	int ATTACK_RANGE_LUNGE_MAX = 250;
	float DMG_CLAW = 0.0f;
	float DMG_BURST = 200.0f;
	float BREATH_DURATION = 4.0f;
	float FREQ_LUNGE = 2.0f;
	float FREQ_FLINCH = 20.0f;
	float FREQ_STOMP = 0.0f;
	float FREQ_FX_REFRESH = 45.0f;
	float FREQ_BREATH = 0.0f;
	float FREQ_SWIM_SOUND = 5.0f;
	string MONSTER_MODEL = "monsters/bear_polar.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float MSC_PUSH_RESIST = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float RUN_STEP = 0.0f;
	float NPC_HALF_HEALTH = 0.0f;
	bool DID_WARCRY = false;
	float AS_ATTACKING = 0.0f;
	float NEXT_BREATH = 0.0f;
	float NEXT_BREATH_OFF_CHECK = 0.0f;
	bool SWIMMING_MODE = false;
	float NEXT_STOMP = 0.0f;
	float NEXT_SWIM_SOUND = 0.0f;
	float NEXT_LUNGE = 0.0f;
	float NEXT_FLINCH = 0.0f;
	Vector3 BURST_START = Vector3();
	string BURST_TARGS = "BURST_TARGS";
	string CLIENT_FX_ID = "CLIENT_FX_ID";
	string BREATH_ON = "BREATH_ON";
	string BREATH_TARGS = "BREATH_TARGS";

	// unnamed block (first think)
	void GbearPolar_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack1"; // frame_run_step
		ANIM_DEATH = "longdeath";

		ANIM_FLINCH = "flinch"; // custom flinch
	}

	// unnamed block (first think)
	void GbearPolar_FirstThink2()
	{
		MSC_PUSH_RESIST = 0.5f; // "weighted"

		NPC_GIVE_EXP = 500.0f;

		MOVE_RANGE = "150";
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
	}

	// npc_spawn
	void GbearPolar_OnNpcSpawn(string npc = "")
	{
		SetName("Greater Polar Bear");
		SetModel(MONSTER_MODEL);
		SetWidth(96);
		SetHeight(96);
		SetRoam(true);
		SetHearingSensitivity(6);
		SetRace("wildanimal");
		SetHealth(3000);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.25f);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		RUN_STEP = 0.0f;

		CallEventDelayed(2.0f, "get_finals");
	}

	// get_finals
	void GbearPolar_OnGetFinals()
	{
		NPC_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;
		if (NO_FROSTY_BREATH)
			return;
		if (NO_BREATH_ATTACK)
			return;
		OnRefreshClFx();
	}

	// npc_targetsighted
	void GbearPolar_OnNpcTargetsighted(string target = "")
	{
		if (DID_WARCRY)
			return;
		DID_WARCRY = true;

		int rndWarcry = RandomInt(1, 2);
		AS_ATTACKING = GameTime() + 5.0f;
		SetRoam(false);
		if (rndWarcry == 1)
			PlayAnim("critical", ANIM_WARCRY1);
		if (rndWarcry == 2)
			PlayAnim("critical", ANIM_WARCRY2);

		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// cycle_down
	void GbearPolar_OnCycleDown()
	{
		DID_WARCRY = false;
	}

	// npcatk_hunt
	void GbearPolar_OnNpcatkHunt()
	{
		int fwdBoost = 0;
		float zDiff = 0.0f;

		if (GameTime() > NEXT_BREATH_OFF_CHECK && !NO_BREATH_ATTACK)
		{
			// suspect if bear not visible during breath off CL command it may stay on
			// so double check here
			NEXT_BREATH_OFF_CHECK = GameTime() + 10.0f;
			if (!Truthy(BREATH_ON))
				ClientEvent("update", "all", CLIENT_FX_ID, "breath_off");
		}

		if (IsInWater(ENT_ME))
		{
			if (!SWIMMING_MODE)
			{
				PlaySound(2, 10, SOUND_DIVE);
				SetGravity(0.75f);
				if (RangeTo(NPCATK_TARGET) < 200.0f)
					SetGravity(0);
				SWIMMING_MODE = true;
				ANIM_RUN = "swim";
				ANIM_WALK = "swim";
				ANIM_IDLE = "swim";
				SetMoveAnim("swim");
				SetIdleAnim("swim");
				ATTACK_HITRANGE = ATTACK_HITRANGE_SWIM;
			}
		}
		else if (SWIMMING_MODE)
		{
			SetGravity(1);
			SWIMMING_MODE = false;
			ANIM_RUN = ANIM_RUN_NORM;
			ANIM_WALK = ANIM_WALK_NORM;
			ANIM_IDLE = ANIM_IDLE_NORM;
			SetMoveAnim(ANIM_RUN_NORM);
			SetIdleAnim(ANIM_IDLE_NORM);
			ATTACK_HITRANGE = ATTACK_HITRANGE_NORM;

			// try to make sure we've *actually* been on land a bit before we do these two
			float timePlus5 = GameTime() + 5.0f;
			if (timePlus5 > NEXT_STOMP)
				NEXT_STOMP = timePlus5 + Random(10, 15);
			if (timePlus5 > NEXT_BREATH)
			{
				NEXT_BREATH = timePlus5;
				NEXT_STOMP += Random(15, 20);
			}
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (SWIMMING_MODE)
		{
			if (Range2DTo(NPCATK_TARGET) < 200.0f)
			{
				SetGravity(0);
			}
			else
			{
				fwdBoost = 100;
				SetGravity(0.75f);
			}

			if (GameTime() > NEXT_SWIM_SOUND)
			{
				NEXT_SWIM_SOUND = GameTime() + FREQ_SWIM_SOUND;
				PlayRandomSound(1, 10, SOUND_SWIM1, SOUND_SWIM2, SOUND_SWIM3, SOUND_SWIM4);
			}

			ATTACK_HITRANGE = ATTACK_HITRANGE_SWIM;
			float moveDestZ = Vec(Eval("game.monster.movedest.origin")).z;
			float myZ = OriginOf(ENT_ME).z;
			if (moveDestZ > myZ && IsInWater(ENT_ME))
			{
				zDiff = moveDestZ - myZ;
				if (zDiff > 50.0f)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, fwdBoost, 5)));
			}
			if (moveDestZ < myZ)
			{
				zDiff = myZ - moveDestZ;
				if (zDiff > 50.0f)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, fwdBoost, -50)));
			}

			SetAngle("face", Vector3(0, Float(Eval("game.monster.angles.yaw")), 0)); // so I dont ramp up on things
		}

		if (SWIMMING_MODE)
			return;

		float targRange = RangeTo(NPCATK_TARGET);

		if (targRange < ATTACK_RANGE_LUNGE_MAX && targRange > ATTACK_RANGE_LUNGE_MIN && GameTime() > NEXT_LUNGE)
		{
			int rndLunge = RandomInt(1, 3);
			ATTACK_RANGE = ATTACK_RANGE_LUNGE_MAX;
			ATTACK_HITRANGE = ATTACK_RANGE_LUNGE_MAX;
			if (rndLunge == 1)
				ANIM_ATTACK = "long_attack1";
			if (rndLunge == 2)
				ANIM_ATTACK = "long_attack2";
			if (rndLunge == 3)
				ANIM_ATTACK = "long_attack_throw";
		}

		if (GameTime() > NEXT_STOMP && targRange < ATTACK_RANGE_LUNGE_MIN)
			ANIM_ATTACK = ANIM_WARCRY1;

		if (NO_BREATH_ATTACK)
			return;

		if (GameTime() > NEXT_BREATH && targRange < 600.0f)
			ANIM_ATTACK = "breath_start";
	}

	// ext_bear_swim
	// called by map brushes near water
	void GbearPolar_OnExtBearSwim()
	{
		bool goSwim = false;
		// dont jump into water without good reason
		if (NPCATK_TARGET != "unset")
			goSwim = true;
		if (HUNTING_PLAYER)
			goSwim = true;
		if (!goSwim)
			return;
		SetMonsterClip(false); // ignore monsterclip and hit the water
	}

	// ext_bear_unswim
	// further from water, resume clipping as normal
	void GbearPolar_OnExtBearUnswim()
	{
		SetMonsterClip(true);
	}

	// frame_attack
	void GbearPolar_OnFrameAttack()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, "90%", "slash");
		float rndLr = Random(-100, 100);
		PlayRandomSound(0, 5, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndLr, 110, 110)));
		int rndAtk = RandomInt(1, 3);
		if (rndAtk == 1)
			ANIM_ATTACK = "attack1";
		if (rndAtk == 2)
			ANIM_ATTACK = "attack2";
		if (rndAtk == 3)
			ANIM_ATTACK = "attack3";
		if (NO_FROSTY_BREATH)
			return;
		if (RandomInt(1, 3) == 1)
			ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
	}

	// frame_long_attack
	void GbearPolar_OnFrameLongAttack()
	{
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = ATTACK_RANGE_NORM;
		ATTACK_HITRANGE = ATTACK_HITRANGE_NORM;
		NEXT_LUNGE = GameTime() + FREQ_LUNGE;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (!NO_FROSTY_BREATH)
			ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
		DoDamage(NPCATK_TARGET, ATTACK_RANGE_LUNGE_MAX, DMG_CLAW, "90%", "slash");
		float rndLr = Random(-200, 200);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndLr, 300, 110)));
	}

	// frame_long_attack_throw
	void GbearPolar_OnFrameLongAttackThrow()
	{
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = ATTACK_RANGE_NORM;
		ATTACK_HITRANGE = ATTACK_HITRANGE_NORM;
		NEXT_LUNGE = GameTime() + FREQ_LUNGE;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (!NO_FROSTY_BREATH)
			ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
		DoDamage(NPCATK_TARGET, ATTACK_RANGE_LUNGE_MAX, DMG_CLAW, "90%", "slash");
		float rndLr = Random(-200, 200);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndLr, 1000, 200)));
	}

	// game_struck
	void GbearPolar_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool painSound = false;

		if (HealthOf(ENT_ME) < NPC_HALF_HEALTH && GameTime() > NEXT_FLINCH)
		{
			NEXT_FLINCH = GameTime() + FREQ_FLINCH;
			PlayAnim("critical", ANIM_FLINCH);
			painSound = true;
		}

		if (!painSound)
		{
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3, SOUND_PAIN4, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		}
		else
		{
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3, SOUND_PAIN4);
			if (!NO_FROSTY_BREATH)
				ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
		}
	}

	// frame_warcry
	void GbearPolar_OnFrameWarcry()
	{
		PlaySound(0, 10, SOUND_WARCRY);
		if (!NO_FROSTY_BREATH)
			ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
		ANIM_ATTACK = "attack1";
	}

	// frame_land
	void GbearPolar_OnFrameLand()
	{
		NEXT_STOMP = GameTime() + FREQ_STOMP;
		ANIM_ATTACK = "attack1";
		CallEventDelayed(1.0f, "restore_roam");
		BURST_START = RelativePosition(Vector3(0, 150, 0));
		ClientEvent("new", "all", "effects/sfx_stun_burst", BURST_START, 256, 0);
		BURST_TARGS = LegacyFunction("get_tsphere", "enemy", 256, BURST_START);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// burst_affect_targets
	void GbearPolar_OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		ApplyEffect(curTarg, "effects/debuff_stun", 8.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = BURST_START;
		float newYaw = AnglesTo(myOrg, targOrg);
		DoDamageEx(curTarg, "direct", DMG_BURST, "100%", ENT_ME, ENT_ME, "none", "blunt");
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
	}

	// frame_alert
	void GbearPolar_OnFrameAlert()
	{
		CallEventDelayed(1.0f, "restore_roam");
		PlaySound(0, 10, SOUND_WARCRY);
		if (NO_FROSTY_BREATH)
			return;
		ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath");
	}

	// restore_roam
	void GbearPolar_OnRestoreRoam()
	{
		SetRoam(true);
	}

	// frame_run_step
	void GbearPolar_OnFrameRunStep()
	{
		RUN_STEP += 1.0f;
		if (RUN_STEP == 1.0f)
		{
			PlaySound(0, 5, SOUND_RUNSTEP1);
		}
		else
		{
			PlaySound(0, 5, SOUND_RUNSTEP2);
			RUN_STEP = 0.0f;
		}
	}

	// refresh_cl_fx
	void GbearPolar_OnRefreshClFx()
	{
		if (!IsAlive(ENT_ME))
			return;
		if (NO_FROSTY_BREATH)
			return;
		if (NO_BREATH_ATTACK)
			return;
		ClientEvent("new", "all", "monsters/gbear_polar_cl", IndexOf(ENT_ME), FREQ_FX_REFRESH, BREATH_ON);
		CLIENT_FX_ID = LastClientScriptId();
		CallEventDelayed(FREQ_FX_REFRESH, "refresh_cl_fx");
	}

	// frame_breath_go
	void GbearPolar_OnFrameBreathGo()
	{
		PlaySound(0, 10, SOUND_WARCRY);
		OnDoBreath();
	}

	// do_breath
	void GbearPolar_OnDoBreath()
	{
		NEXT_BREATH = GameTime() + FREQ_BREATH;

		PlaySound(0, 10, "magic/cold_breath.wav");

		SetRoam(false);
		OnNpcatkSuspendAi(Text(BREATH_DURATION));
		OnNpcatkSuspendMovement(ANIM_BREATH_LOOP, Text(BREATH_DURATION));

		ClientEvent("update", "all", CLIENT_FX_ID, "breath_on");

		BREATH_ON = "1";
		OnBreathLoop();
		CallEventDelayed(BREATH_DURATION, "breath_end");
	}

	// breath_loop
	void GbearPolar_OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.5f, "breath_loop");
		BREATH_TARGS = FindInSphere("enemy", 768);
		if (BREATH_TARGS == "none")
			return;
		int count = GetTokenCount(BREATH_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void GbearPolar_OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		ApplyEffect(curTarg, "effects/dot_cold_freeze", 6.0f, self, 10.0f);
		if (!(RangeTo(curTarg) < 200.0f))
			return;
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, 800, 110)));
	}

	// breath_end
	void GbearPolar_OnBreathEnd()
	{
		ANIM_ATTACK = "attack1";
		CallEventDelayed(1.0f, "restore_roam");
		BREATH_ON = "0";
		ClientEvent("update", "all", CLIENT_FX_ID, "breath_off");
	}

	// game_death
	void GbearPolar_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NO_FROSTY_BREATH)
			return;
		ClientEvent("update", "all", CLIENT_FX_ID, "quick_breath_last");
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
		GbearPolar_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		GbearPolar_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		GbearPolar_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GbearPolar_OnNpcatkHunt();
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		GbearPolar_OnCycleDown();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		GbearPolar_OnNpcTargetsighted(target);
	}

	void OnGetFinals() { GbearPolar_OnGetFinals(); } // get_finals
	void OnExtBearSwim() { GbearPolar_OnExtBearSwim(); } // ext_bear_swim
	void OnExtBearUnswim() { GbearPolar_OnExtBearUnswim(); } // ext_bear_unswim
	void OnFrameAttack() { GbearPolar_OnFrameAttack(); } // frame_attack
	void OnFrameLongAttack() { GbearPolar_OnFrameLongAttack(); } // frame_long_attack
	void OnFrameLongAttackThrow() { GbearPolar_OnFrameLongAttackThrow(); } // frame_long_attack_throw
	void OnFrameWarcry() { GbearPolar_OnFrameWarcry(); } // frame_warcry
	void OnFrameLand() { GbearPolar_OnFrameLand(); } // frame_land
	void OnBurstAffectTargets() { GbearPolar_OnBurstAffectTargets(); } // burst_affect_targets
	void OnFrameAlert() { GbearPolar_OnFrameAlert(); } // frame_alert
	void OnRestoreRoam() { GbearPolar_OnRestoreRoam(); } // restore_roam
	void OnFrameRunStep() { GbearPolar_OnFrameRunStep(); } // frame_run_step
	void OnRefreshClFx() { GbearPolar_OnRefreshClFx(); } // refresh_cl_fx
	void OnFrameBreathGo() { GbearPolar_OnFrameBreathGo(); } // frame_breath_go
	void OnDoBreath() { GbearPolar_OnDoBreath(); } // do_breath
	void OnBreathLoop() { GbearPolar_OnBreathLoop(); } // breath_loop
	void OnBreathAffectTargets() { GbearPolar_OnBreathAffectTargets(); } // breath_affect_targets
	void OnBreathEnd() { GbearPolar_OnBreathEnd(); } // breath_end
	void OnBreathDuration() {} // BREATH_DURATION
	void OnFreqFxRefresh() {} // FREQ_FX_REFRESH

	// This file's events and timers by their .script names
	bool GbearPolar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_end") { OnBreathEnd(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "ext_bear_swim") { OnExtBearSwim(); return true; }
		if (name == "ext_bear_unswim") { OnExtBearUnswim(); return true; }
		if (name == "frame_alert") { OnFrameAlert(); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "frame_breath_go") { OnFrameBreathGo(); return true; }
		if (name == "frame_land") { OnFrameLand(); return true; }
		if (name == "frame_long_attack") { OnFrameLongAttack(); return true; }
		if (name == "frame_long_attack_throw") { OnFrameLongAttackThrow(); return true; }
		if (name == "frame_run_step") { OnFrameRunStep(); return true; }
		if (name == "frame_warcry") { OnFrameWarcry(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_finals") { OnGetFinals(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "refresh_cl_fx") { OnRefreshClFx(); return true; }
		if (name == "restore_roam") { OnRestoreRoam(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/gbear_polar"]
shared class GbearPolarScript : BaseMonsterNewScript, GbearPolar
{
	// Variables every script that includes this file declares
	bool NO_BREATH_ATTACK = false;
	bool NO_FROSTY_BREATH = false;
	string NPC_BASE_EXP = "NPC_BASE_EXP";

	// Variables declared by included files, with the value they start with in this script
	GbearPolarScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/bear/c_bear_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bear_polar.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GbearPolar_FirstThink();
		GbearPolar_FirstThink2();
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
		return GbearPolar_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
