#pragma context server

// Converted from monsters/base_flyer.script by msc_transpiler.
// attempts to fix the flight AI by Thothie

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseFlyer
{
	// Constants
	float BF_CHECK_FREQ = 0.2f;
	float BF_RETREAT_TIME = 1.0f;
	Vector3 BF_UNSTUCK_ADJ = Vector3();

	// Variables (an unset .script variable reads as its own name)
	float FLIGHT_CHECK_FREQ = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	Vector3 FLY_OLD_POS = Vector3();
	bool FLIGHT_SCANNING = false;
	bool BOUNCED = false;
	bool BF_NO_STUCK = false;
	Vector3 NEW_DEST = Vector3();

	// unnamed block (first think)
	void BaseFlyer_FirstThink()
	{
		FLIGHT_CHECK_FREQ = BF_CHECK_FREQ;
		NO_STUCK_CHECKS = "1";
	}

	// game_spawn
	void BaseFlyer_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// setbbox npcsize
		// callevent 2.0 flight_check
		CallEventDelayed(0.2f, "setup_flight");
	}

	// setup_flight
	void BaseFlyer_OnSetupFlight()
	{
		// setvard DISTANCE_THRESH MONSTER_WIDTH
		// multiply DISTANCE_THRESH 2
		// setprop ent_me movetype const.movetype.fly
		FLY_OLD_POS = Vec(Eval("game.monster.pos"));
	}

	// npcatk_targetvalidate
	void BaseFlyer_OnNpcatkTargetvalidate(string target = "")
	{
		if (FLIGHT_SCANNING)
			return;
		FLIGHT_SCANNING = true;
		CallEventDelayed(1.0f, "flight_check");
	}

	// flight_check
	void BaseFlyer_OnFlightCheck()
	{
		float flyMoved = Distance(FLY_OLD_POS, MyOrigin());

		string hitWall = LegacyFunction("get_traceline", MyOrigin(), Eval("game.monster.movedest"), "worldonly");
		if (hitWall != Eval("game.monster.movedest") && Distance(MyOrigin(), Vec(Eval("game.monster.movedest"))) < 50.0f)
		{
			OnNpcatkSuspendAi("0.2");
			OnDoOneEighty();
			SetMoveDest(NEW_DEST, 20);
			CallEventDelayed(0.1f, "bat_boost");
		}

		if (flyMoved == 0.0f && !BF_NO_STUCK)
		{
			OnNpcatkSuspendAi("0.2");
			BOUNCED = true;
			FLIGHT_CHECK_FREQ = BF_RETREAT_TIME;
			if (!CanSee("enemy"))
			{
				OnDoOneEighty();
				// //dbg unstucking NEW_DEST MY_ANGLES
				SetMoveDest(NEW_DEST, 20);
				CallEventDelayed(0.1f, "bat_boost");
			}
		}
		if (flyMoved != 0.0f && !BF_NO_STUCK && BOUNCED)
		{
			// //dbg resetting vel
			BOUNCED = false;
			FLIGHT_CHECK_FREQ = BF_CHECK_FREQ;
		}

		FLY_OLD_POS = MyOrigin();
		CallEventDelayed(FLIGHT_CHECK_FREQ, "flight_check");
	}

	// npc_selectattack
	void BaseFlyer_OnNpcSelectattack()
	{
		FLY_OLD_POS = Vector3(20000, 20000, 20000);
	}

	// bf_suspend_stuck
	void BaseFlyer_OnBfSuspendStuck(string duration = "")
	{
		CallEventOrDelay(duration, "bf_resume_stuck");
		BF_NO_STUCK = true;
	}

	// bf_resume_stuck
	void BaseFlyer_OnBfResumeStuck()
	{
		FLY_OLD_POS = Vector3(20000, 20000, 20000);
		BF_NO_STUCK = false;
	}

	// bat_boost
	void BaseFlyer_OnBatBoost()
	{
		AddVelocity(ENT_ME, BF_UNSTUCK_ADJ);
		CallEventDelayed(1.0f, "bf_reset_target");
	}

	// bf_reset_target
	void BaseFlyer_OnBfResetTarget()
	{
		SetMoveDest(GetVar("NPCATK_TARGET"), Eval("game.monster.moveprox"));
	}

	// do_one_eighty2
	void BaseFlyer_OnDoOneEighty2()
	{
		float myYaw = MyAngles().y + 180.0f;
		if (myYaw > 359.0f)
			myYaw -= 359.0f;
		float myPitch = MyAngles().x + 180.0f;
		if (myPitch > 359.0f)
			myPitch -= 359.0f;
		NEW_DEST = RelativePosition(Vector3(0, myPitch, 0), Vector3(0, 1000, 0));
	}

	// do_one_eighty2
	void BaseFlyer_OnDoOneEighty2_2()
	{
		float myYaw = MyAngles().y + 180.0f;
		if (myYaw > 359.0f)
			myYaw -= 359.0f;
		float myPitch = MyAngles().x + 180.0f;
		if (myPitch > 359.0f)
			myPitch -= 359.0f;
		float myRoll = MyAngles().z + 180.0f;
		if (myRoll > 359.0f)
			myRoll -= 359.0f;
		NEW_DEST = RelativePosition(Vector3(myPitch, myYaw, myRoll), Vector3(0, 1000, 0));
	}

	// do_rand_tweedee
	void BaseFlyer_OnDoRandTweedee()
	{
		int myPitch = RandomInt(0, 359);
		int myYaw = RandomInt(0, 359);
		int myRoll = RandomInt(0, 359);
		NEW_DEST = RelativePosition(Vector3(myPitch, myYaw, myRoll), Vector3(0, 1000, 0));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseFlyer_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSetupFlight() { BaseFlyer_OnSetupFlight(); } // setup_flight
	void OnNpcatkTargetvalidate(string target = "") { BaseFlyer_OnNpcatkTargetvalidate(target); } // npcatk_targetvalidate
	void OnFlightCheck() { BaseFlyer_OnFlightCheck(); } // flight_check
	void OnNpcSelectattack() { BaseFlyer_OnNpcSelectattack(); } // npc_selectattack
	void OnBfSuspendStuck(string duration = "") { BaseFlyer_OnBfSuspendStuck(duration); } // bf_suspend_stuck
	void OnBfResumeStuck() { BaseFlyer_OnBfResumeStuck(); } // bf_resume_stuck
	void OnBatBoost() { BaseFlyer_OnBatBoost(); } // bat_boost
	void OnBfResetTarget() { BaseFlyer_OnBfResetTarget(); } // bf_reset_target

	// do_one_eighty2
	void OnDoOneEighty2()
	{
		BaseFlyer_OnDoOneEighty2();
		BaseFlyer_OnDoOneEighty2_2();
	}

	void OnDoRandTweedee() { BaseFlyer_OnDoRandTweedee(); } // do_rand_tweedee
	void OnFlightCheckFreq() {} // FLIGHT_CHECK_FREQ
	void OnDoOneEighty() {} // do_one_eighty
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool BaseFlyer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bat_boost") { OnBatBoost(); return true; }
		if (name == "bf_reset_target") { OnBfResetTarget(); return true; }
		if (name == "bf_resume_stuck") { OnBfResumeStuck(); return true; }
		if (name == "bf_suspend_stuck") { OnBfSuspendStuck(Param(params, 0)); return true; }
		if (name == "do_one_eighty2") { OnDoOneEighty2(); return true; }
		if (name == "do_rand_tweedee") { OnDoRandTweedee(); return true; }
		if (name == "flight_check") { OnFlightCheck(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "setup_flight") { OnSetupFlight(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_flyer"]
shared class BaseFlyerScript : ScriptEntity, BaseFlyer
{
	// Variables every script that includes this file declares
	float AS_ATTACKING = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseFlyer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseFlyer_DispatchEvent(name, params);
	}
}
