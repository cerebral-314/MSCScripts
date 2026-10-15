#pragma context server

// Converted from monsters/summon/rock_storm.script by msc_transpiler.
// Storm of rocks with FX, by Thothie
// PARAM1 owner
// PARAM2 # of rocks (up to 4)
// PARAM3 damage
// PARAM4 radius, ie. horizontal distance from master to begin
// PARAM5 height, ie. vertical distance to raise rocks to (if ceiling detected, should automagically lower)

#include "runtime/ScriptEntity.as"

[script "monsters/summon/rock_storm"]
class RockStorm : ScriptEntity
{
	// Constants
	string ROCK_SCRIPT = "monsters/summon/rock";
	string SOUND_LEVITATE = "fans/fan4on.wav";
	string SOUND_SPIN = "magic/fan4_noloop.wav";
	float DUR_SPIN = 1.74f;
	string SOUND_SUMMON = "magic/volcano_start.wav";
	bool ROCKA_OFS = false;
	int ROCKB_OFS = 90;
	int ROCKC_OFS = 180;
	int ROCKD_OFS = 270;
	int RAISE_MAX = 20;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	Vector3 MY_OWNER_POS = Vector3();
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string NUMBER_ROCKS = "NUMBER_ROCKS";
	float OWNER_GROUND = 0.0f;
	float MY_BASE_DAMAGE = 0.0f;
	string MY_DISTANCE = "MY_DISTANCE";
	bool FIRE_ROCK = false;
	float MY_VERTICAL = 0.0f;
	float MY_JUMP_SIZE = 0.0f;
	string ROCKS_CENTER = "ROCKS_CENTER";
	Vector3 ROCKA_START = Vector3();
	CBaseEntity@ ROCKA_ID = null;
	float RAISE_COUNT = 0.0f;
	Vector3 ROCKB_START = Vector3();
	CBaseEntity@ ROCKB_ID = null;
	Vector3 ROCKC_START = Vector3();
	CBaseEntity@ ROCKC_ID = null;
	Vector3 ROCKD_START = Vector3();
	CBaseEntity@ ROCKD_ID = null;
	float SPIN_COUNT = 0.0f;
	float ROCKS_THROWN = 0.0f;
	string CURRENT_TARGET = "CURRENT_TARGET";
	float ROT_ADJ = 0.0f;
	float ROCKS_CV = 0.0f;
	string ROCK_TARGETS = "ROCK_TARGETS";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// defining in hopes of fixing damage scan
		// name Rock Storm
		// blood none
		// hp 1
		SetModel("null.mdl");
		SetInvincible(true);
		SetNoPush(true);
		SetWidth(1);
		SetHeight(1);
		SetSolid("none");
		// hearingsensitivity 10
		PLAYING_DEAD = "1"; // not a valid target
	}

	// game_dynamically_created
	// { game_heardsound //this not working for some reason
	// local HEARD_ID $get(ent_lastheard,id)
	// ////dbg temp heard $get(HEARD_ID,name)
	// if $get(HEARD_ID,relationship,MY_OWNER) isnot ally
	// setvard CURRENT_TARGET HEARD_ID
	// ////dbg temp H-Scan Acquired $get(CURRENT_TARGET,name)
	// }
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_OWNER_POS = OriginOf(MY_OWNER);
		MY_OWNER_RACE = RaceOf(MY_OWNER);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		NUMBER_ROCKS = creatorValue2;
		OWNER_GROUND = GroundHeight(MY_OWNER_POS);
		MY_BASE_DAMAGE = Float(damage);
		MY_DISTANCE = skill;

		FIRE_ROCK = false;
		if (!extraValue6.isEmpty())
			FIRE_ROCK = true;

		DebugPrint("game_dynamically_created owner " + NameOf(creatorValue1) + " org " + Text(MY_OWNER_POS) + " race " + MY_OWNER_RACE + " #rcks " + NUMBER_ROCKS + " dmg " + Text(MY_BASE_DAMAGE) + " dist " + MY_DISTANCE + " vert " + extraValue5 + " fire " + Text(FIRE_ROCK));

		SetRace(MY_OWNER_RACE);

		// if ( NUMBER_ROCKS == 0 ) //dbg Umm... No rocks? WRONG PARAMETERS!
		// calculate vertical line to raise to (def: 32 units above master's head)
		float ownerX = MY_OWNER_POS.x;
		float ownerY = MY_OWNER_POS.y;
		float ownerZ = MY_OWNER_POS.z;
		MY_VERTICAL = OWNER_GROUND + Float(extraValue5);
		Vector3 traceEnd = Vector3(ownerX, ownerY, MY_VERTICAL);
		string traceVert = LegacyFunction("get_traceline", MY_OWNER_POS, traceEnd, "worldonly");
		if (Distance(Vec(traceVert), traceEnd) > 0.0f)
		{
			// trace hit ceiling before reached intended hover height
			// set max hover at ceiling instead (so rocks don't spawn off map)
			// //dbg tracelin hit ceiling, lowering rock raiseto from MY_VERTICAL to $vec.z(TRACE_VERT)
			MY_VERTICAL = Vec(traceVert).z;
			traceEnd = Vector3(ownerX, ownerY, MY_VERTICAL);
		}

		// calculate distance from ground to hover plane, and thus size of jumps to make to reach during 20 step raising
		Vector3 myOwnerGpos = Vector3(ownerX, ownerY, OWNER_GROUND);
		float distToHover = Distance(myOwnerGpos, traceEnd);
		MY_JUMP_SIZE = Divide(distToHover, 20.0f);

		ROCKS_CENTER = Text(myOwnerGpos);

		// //dbg temp got Owner $get(MY_OWNER,name) nRocks NUMBER_ROCKS dmg MY_BASE_DAMAGE startdist MY_DISTANCE raiseto MY_VERTICAL ground OWNER_GROUND inc MY_JUMP_SIZE axis ROCKS_CENTER headdist DIST_TO_HOVER
		CallEventDelayed(0.1f, "rocks_begin");
	}

	// rocks_begin
	void OnRocksBegin()
	{
		// summon rocks at feet
		if (Float(NUMBER_ROCKS) >= 1.0f)
		{
			ROCKA_START = Vec(ROCKS_CENTER);
			ROCKA_START += RelativePosition(Vector3(0, (ROCKA_OFS ? 1.0f : 0.0f), 0), Vector3(0, Float(MY_DISTANCE), 0));
			CreateNpc(ROCK_SCRIPT, ROCKA_START, MY_OWNER, FIRE_ROCK);
			@ROCKA_ID = EntityOf(ENT_LASTCREATED);
		}

		if (Float(NUMBER_ROCKS) >= 2.0f)
			CallEventDelayed(0.1f, "setup_rockb");
		if (Float(NUMBER_ROCKS) >= 3.0f)
			CallEventDelayed(0.2f, "setup_rockc");
		if (Float(NUMBER_ROCKS) >= 4.0f)
			CallEventDelayed(0.25f, "setup_rockd");

		PlaySound(0, 10, SOUND_SUMMON);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 255, 20, 3.0f, 256); // <position> <amplitude> <frequency> <duration> <radius>

		CallEventDelayed(0.2f, "levitate_noise");

		RAISE_COUNT = 0.0f;
		// //dbg temp raising rocks
		CallEventDelayed(0.3f, "rocks_raise");
	}

	// setup_rockb
	void OnSetupRockb()
	{
		ROCKB_START = Vec(ROCKS_CENTER);
		ROCKB_START += RelativePosition(Vector3(0, ROCKB_OFS, 0), Vector3(0, Float(MY_DISTANCE), 0));
		CreateNpc(ROCK_SCRIPT, ROCKB_START, MY_OWNER, FIRE_ROCK);
		@ROCKB_ID = EntityOf(ENT_LASTCREATED);
	}

	// setup_rockc
	void OnSetupRockc()
	{
		ROCKC_START = Vec(ROCKS_CENTER);
		ROCKC_START += RelativePosition(Vector3(0, ROCKC_OFS, 0), Vector3(0, Float(MY_DISTANCE), 0));
		CreateNpc(ROCK_SCRIPT, ROCKC_START, MY_OWNER, FIRE_ROCK);
		@ROCKC_ID = EntityOf(ENT_LASTCREATED);
	}

	// setup_rockd
	void OnSetupRockd()
	{
		ROCKD_START = Vec(ROCKS_CENTER);
		ROCKD_START += RelativePosition(Vector3(0, ROCKD_OFS, 0), Vector3(0, Float(MY_DISTANCE), 0));
		CreateNpc(ROCK_SCRIPT, ROCKD_START, MY_OWNER, FIRE_ROCK);
		@ROCKD_ID = EntityOf(ENT_LASTCREATED);
	}

	// levitate_noise
	void OnLevitateNoise()
	{
		PlaySound(0, 10, SOUND_LEVITATE);
	}

	// rocks_raise
	void OnRocksRaise()
	{
		float angAdj = 0.0f;

		RAISE_COUNT += 1.0f;

		if (RAISE_COUNT == RAISE_MAX)
		{
			SPIN_COUNT = ROT_ADJ;
			ROCKS_THROWN = 0.0f;
			OnRocksSpin();
			OnSpinNoise();
			CURRENT_TARGET = "unset";
			if (Float(NUMBER_ROCKS) >= 1.0f)
				CallEventDelayed(4.5f, "find_targets");
			if (Float(NUMBER_ROCKS) >= 1.0f)
				CallEventDelayed(5.0f, "rocka_throw");
			CURRENT_TARGET = "unset";
			if (Float(NUMBER_ROCKS) >= 2.0f)
				CallEventDelayed(5.5f, "find_targets");
			if (Float(NUMBER_ROCKS) >= 2.0f)
				CallEventDelayed(6.0f, "rockb_throw");
			CURRENT_TARGET = "unset";
			if (Float(NUMBER_ROCKS) >= 3.0f)
				CallEventDelayed(6.5f, "find_targets");
			if (Float(NUMBER_ROCKS) >= 3.0f)
				CallEventDelayed(7.0f, "rockc_throw");
			CURRENT_TARGET = "unset";
			if (Float(NUMBER_ROCKS) >= 4.0f)
				CallEventDelayed(7.5f, "find_targets");
			if (Float(NUMBER_ROCKS) >= 4.0f)
				CallEventDelayed(8.0f, "rockd_throw");
			CallEventDelayed(9.5f, "find_targets");
			CallEventDelayed(10.0f, "force_all_rock_throw");
		}

		// //dbg temp spinning rocks
		if (!(RAISE_COUNT < RAISE_MAX))
			return;
		CallEventDelayed(0.1f, "rocks_raise");

		ROT_ADJ = RAISE_COUNT * 10.0f;

		ROCKS_CV = RAISE_COUNT * MY_JUMP_SIZE;

		// add ROCKS_CV $vec.z(OWNER_GROUND)
		if (Float(NUMBER_ROCKS) >= 1.0f)
		{
			Vector3 rockaPos = Vec(ROCKS_CENTER);
			angAdj = (ROCKA_OFS ? 1.0f : 0.0f) + ROT_ADJ;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockaPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKA_ID, rockaPos);
		}

		// //dbg temp ROCKApos ROCKA_POS raisecnt ( RAISE_COUNT * MY_JUMP_SIZE ) rockvert ROCKS_CV numrocks NUMBER_ROCKS
		if (Float(NUMBER_ROCKS) >= 2.0f)
		{
			Vector3 rockbPos = Vec(ROCKS_CENTER);
			angAdj = ROCKB_OFS + ROT_ADJ;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockbPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKB_ID, rockbPos);
		}

		if (Float(NUMBER_ROCKS) >= 3.0f)
		{
			Vector3 rockcPos = Vec(ROCKS_CENTER);
			angAdj = ROCKC_OFS + ROT_ADJ;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockcPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKC_ID, rockcPos);
		}

		if (Float(NUMBER_ROCKS) >= 4.0f)
		{
			Vector3 rockdPos = Vec(ROCKS_CENTER);
			angAdj = ROCKD_OFS + ROT_ADJ;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockdPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKD_ID, rockdPos);
		}
	}

	// spin_noise
	void OnSpinNoise()
	{
		PlaySound(0, 10, SOUND_SPIN);
		if (!(ROCKS_THROWN < Float(NUMBER_ROCKS)))
			return;
		CallEventDelayed(DUR_SPIN, "spin_noise");
	}

	// rocks_spin
	void OnRocksSpin()
	{
		float angAdj = 0.0f;

		SPIN_COUNT += 10.0f;
		if (SPIN_COUNT > 359.0f)
			SPIN_COUNT = 0.0f;

		if (ROCKS_THROWN == Float(NUMBER_ROCKS))
			OnRemoveMe();

		if (!(ROCKS_THROWN < Float(NUMBER_ROCKS)))
			return;
		CallEventDelayed(0.1f, "rocks_spin");

		if (Exists(ROCKA_ID))
		{
			Vector3 rockaPos = Vec(ROCKS_CENTER);
			angAdj = (ROCKA_OFS ? 1.0f : 0.0f) + SPIN_COUNT;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockaPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKA_ID, rockaPos);
		}

		if (Exists(ROCKB_ID))
		{
			Vector3 rockbPos = Vec(ROCKS_CENTER);
			angAdj = ROCKB_OFS + SPIN_COUNT;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockbPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKB_ID, rockbPos);
		}

		if (Exists(ROCKC_ID))
		{
			Vector3 rockcPos = Vec(ROCKS_CENTER);
			angAdj = ROCKC_OFS + SPIN_COUNT;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockcPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKC_ID, rockcPos);
		}

		if (Exists(ROCKD_ID))
		{
			Vector3 rockdPos = Vec(ROCKS_CENTER);
			angAdj = ROCKD_OFS + SPIN_COUNT;
			if (angAdj > 359.0f)
				angAdj -= 359.0f;
			rockdPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, Float(MY_DISTANCE), ROCKS_CV));
			SetOrigin(ROCKD_ID, rockdPos);
		}
	}

	// find_targets
	void OnFindTargets()
	{
		if (IsAlive(CURRENT_TARGET))
			return;
		CURRENT_TARGET = "unset";
		ROCK_TARGETS = TokenShuffle(LegacyFunction("get_tsphere", "enemy", 1024, ROCKS_CENTER));
		int count = GetTokenCount(ROCK_TARGETS);
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
	}

	// pick_target
	void OnPickTarget()
	{
		CBaseEntity@ curEnt = FindEntity(GetToken(ROCK_TARGETS, loopIteration));
		if (!IsAlive(curEnt))
			return;
		if (RelationshipOf(curEnt, MY_OWNER) != "enemy")
			return;
		CURRENT_TARGET = EntityId(curEnt);
		DebugPrint("Selected_Target " + NameOf(CURRENT_TARGET));
	}

	// rocka_throw
	void OnRockaThrow()
	{
		CURRENT_TARGET = "unset";
		OnFindTargets();
		OnCheckTarg2();

		// //dbg temp Target is $get(CURRENT_TARGET,name)
		Vector3 targetPos = OriginOf(CURRENT_TARGET);
		Vector3 rockaPos = OriginOf(ROCKA_ID);
		string traceFire = LegacyFunction("get_traceline", rockaPos, targetPos, "worldonly");
		if (traceFire != Text(targetPos))
		{
			// dbg temp ROCKA Unable to fire, trace made no line ( TRACE_FIRE vs TARGET_POS $dist(TARGET_POS,TRACE_FIRE) )
			CallEventDelayed(0.5f, "rocka_throw"); // try again in a bit
		}
		else
		{
			ROCKS_THROWN += 1.0f;
			// //dbg temp throwing ROCKA ( ROCKS_THROWN / NUMBER_ROCKS )
			CallExternal(ROCKA_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		}
	}

	// rockb_throw
	void OnRockbThrow()
	{
		CURRENT_TARGET = "unset";
		OnFindTargets();
		OnCheckTarg2();

		Vector3 targetPos = OriginOf(CURRENT_TARGET);
		Vector3 rockbPos = OriginOf(ROCKB_ID);
		string traceFire = LegacyFunction("get_traceline", rockbPos, targetPos, "worldonly");
		if (traceFire != Text(targetPos))
		{
			// //dbg temp ROCKB Unable to fire, trace made no line ( $dist(TARGET_POS,TRACE_FIRE) )
			CURRENT_TARGET = "unset";
			OnFindTargets();
			CallEventDelayed(0.5f, "rockb_throw"); // try again in a bit
		}
		else
		{
			ROCKS_THROWN += 1.0f;
			// //dbg temp throwing ROCKB ( ROCKS_THROWN / NUMBER_ROCKS )
			CallExternal(ROCKB_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		}
	}

	// rockc_throw
	void OnRockcThrow()
	{
		CURRENT_TARGET = "unset";
		OnFindTargets();
		OnCheckTarg2();

		Vector3 targetPos = OriginOf(CURRENT_TARGET);
		Vector3 rockcPos = OriginOf(ROCKC_ID);
		string traceFire = LegacyFunction("get_traceline", rockcPos, targetPos, "worldonly");
		if (traceFire != Text(targetPos))
		{
			// //dbg temp ROCKC Unable to fire, trace made no line ( $dist(TARGET_POS,TRACE_FIRE) )
			CURRENT_TARGET = "unset";
			OnFindTargets();
			CallEventDelayed(0.5f, "rockc_throw"); // try again in a bit
		}
		else
		{
			ROCKS_THROWN += 1.0f;
			// //dbg temp throwing ROCKC ( ROCKS_THROWN / NUMBER_ROCKS )
			CallExternal(ROCKC_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		}
	}

	// rockd_throw
	void OnRockdThrow()
	{
		CURRENT_TARGET = "unset";
		OnFindTargets();
		OnCheckTarg2();

		Vector3 targetPos = OriginOf(CURRENT_TARGET);
		Vector3 rockdPos = OriginOf(ROCKD_ID);
		string traceFire = LegacyFunction("get_traceline", rockdPos, targetPos, "worldonly");
		if (traceFire != Text(targetPos))
		{
			// //dbg temp ROCKD Unable to fire, trace made no line ( $dist(TARGET_POS,TRACE_FIRE) )
			CURRENT_TARGET = "unset";
			OnFindTargets();
			CallEventDelayed(0.5f, "rockd_throw"); // try again in a bit
		}
		else
		{
			ROCKS_THROWN += 1.0f;
			// //dbg temp throwing ROCKD ( ROCKS_THROWN / NUMBER_ROCKS )
			CallExternal(ROCKD_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		}
	}

	// force_all_rock_throw
	void OnForceAllRockThrow()
	{
		// times up, toss all the rocks, regardless of available line of fire
		OnCheckTarg2();
		if (Exists(ROCKA_ID))
			CallExternal(ROCKA_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		if (Exists(ROCKB_ID))
			CallExternal(ROCKB_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		if (Exists(ROCKC_ID))
			CallExternal(ROCKC_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		if (Exists(ROCKD_ID))
			CallExternal(ROCKD_ID, "toss_rock", CURRENT_TARGET, MY_BASE_DAMAGE);
		ROCKS_THROWN = Float(NUMBER_ROCKS);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		CallExternal(MY_OWNER, "ext_rock_storm_end");
		CallEventDelayed(0.1f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// check_targ
	void OnCheckTarg2()
	{
		if (IsAlive(CURRENT_TARGET))
			return;
		DebugPrint("rock_storm check_targ " + NameOf(CURRENT_TARGET) + " is invalid, using alternate");
		// scan found no targets, setup based on master's
		if (Truthy(OWNER_ISPLAYER))
			CURRENT_TARGET = EntityId(TargetOf(MY_OWNER));
		if (!Truthy(OWNER_ISPLAYER))
			CURRENT_TARGET = ScriptVarOf(MY_OWNER, "NPCATK_TARGET");
		if (!IsAlive(CURRENT_TARGET))
		{
			// STILL not valid, try old style
			CURRENT_TARGET = ScriptVarOf(MY_OWNER, "HUNT_LASTTARGET");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDurSpin() {} // DUR_SPIN

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_targ") { OnCheckTarg2(); return true; }
		if (name == "find_targets") { OnFindTargets(); return true; }
		if (name == "force_all_rock_throw") { OnForceAllRockThrow(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "levitate_noise") { OnLevitateNoise(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		if (name == "rocka_throw") { OnRockaThrow(); return true; }
		if (name == "rockb_throw") { OnRockbThrow(); return true; }
		if (name == "rockc_throw") { OnRockcThrow(); return true; }
		if (name == "rockd_throw") { OnRockdThrow(); return true; }
		if (name == "rocks_begin") { OnRocksBegin(); return true; }
		if (name == "rocks_raise") { OnRocksRaise(); return true; }
		if (name == "rocks_spin") { OnRocksSpin(); return true; }
		if (name == "setup_rockb") { OnSetupRockb(); return true; }
		if (name == "setup_rockc") { OnSetupRockc(); return true; }
		if (name == "setup_rockd") { OnSetupRockd(); return true; }
		if (name == "spin_noise") { OnSpinNoise(); return true; }
		return false;
	}
}
