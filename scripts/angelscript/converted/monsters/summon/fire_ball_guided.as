#pragma context server

// Converted from monsters/summon/fire_ball_guided.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FireBallGuided
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_EXPLODE = "weapons/explode3.wav";
	string SPRITE_FIRE = "firemagic.spr";
	int DETECT_RANGE = 64;
	int COLLIDE_RANGE = 16;
	string MY_SPEED = "300";
	float FREQ_HUNT = 1.0f;
	float FREQ_MOVE = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DMG = 0.0f;
	string MY_DURATION = "MY_DURATION";
	string MY_AOE = "MY_AOE";
	string FIRST_TARG = "FIRST_TARG";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MY_TARGET = "MY_TARGET";
	Vector3 MY_DEST = Vector3();
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PREV_POV = "PREV_POV";
	string PUSH_LIST = "PUSH_LIST";

	// game_dynamically_created
	// <owner> <dmg> <maxlife> <aoe> [first_targ]
	void FireBallGuided_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_BASE_DMG = Float(creatorValue2);
		MY_DURATION = damage;
		MY_AOE = skill;
		FIRST_TARG = extraValue5;

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		SetRace(RaceOf(MY_OWNER));

		if (!Truthy(OWNER_ISPLAYER))
			MY_TARGET = ScriptVarOf(MY_OWNER, "NPCATK_TARGET");
		if (Truthy(OWNER_ISPLAYER))
			MY_TARGET = EntityId(TargetOf(MY_OWNER));

		if (IsAlive(FIRST_TARG))
			MY_TARGET = FIRST_TARG;

		if (!IsAlive(MY_TARGET))
			OnFindNewTarget();

		MY_DEST = OriginOf(MY_TARGET);

		CallEventOrDelay(MY_DURATION, "go_splodie");
		IS_ACTIVE = true;
		CallEventDelayed(0.01f, "hunt_cycle");
		CallEventDelayed(0.1f, "move_cycle");

		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, Float(MY_SPEED), 0)));
	}

	// game_spawn
	void FireBallGuided_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("fire ball");
		SetHealth(30); // may make this adjustable
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
		SetModel("weapons/projectiles.mdl");
		// effect glow ent_me (255,0,0) 64 -1 -1
		PLAYING_DEAD = "1";

		SetMonsterClip(false);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		// check attatchsprite/light commands here
		PlaySound(0, 10, "weapons/rocketfire1.wav");

		SetModelBody(0, 40);
		SetIdleAnim("idle_icebolt");
		SetSolid("none");
	}

	// hunt_cycle
	void FireBallGuided_OnHuntCycle()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(FREQ_HUNT, "hunt_cycle");

		if (!IsAlive(MY_TARGET))
			OnFindNewTarget();
		if (!IsAlive(MY_TARGET))
		{
			// couldn't find a living target, just move forward based on owner's angles
			Vector3 ownerAng = AnglesOf(MY_OWNER);
			SetAngle("face", Vector3(0, ownerAng.y, 0));
			MY_DEST = RelativePosition(Vector3(0, 1000, 0));
		}
		else
		{
			MY_DEST = OriginOf(MY_TARGET);
		}

		// randomize dest a bit
		float rndFb = Random(0, 64);
		float rndRl = Random(-64, 64);
		float rndUd = Random(0, 64);
		MY_DEST += RelativePosition(Vector3(0, 0, 0), Vector3(rndRl, rndFb, rndUd));

		// if ( G_DEVELOPER_MODE )
		// {
		// effect beam point lgtning.spr 50 game.monster.origin MY_DEST (255,0,255) 255 0 0.9
		// }
		if (PREV_POV != "PREV_POV" && Text(MyOrigin()) == PREV_POV)
			OnGoSplodie();
		PREV_POV = Text(MyOrigin());

		// check for collision
		string hitWall = LegacyFunction("get_traceline", MyOrigin(), MY_DEST, "worldonly");
		if (Distance(MyOrigin(), Vec(hitWall)) < COLLIDE_RANGE)
			OnGoSplodie();

		// check for ground
		float floorZ = GroundHeight(MyOrigin());
		Vector3 floorOrg = MyOrigin();
		floorOrg.z = floorZ;
		if (!(Distance(MyOrigin(), floorOrg) < COLLIDE_RANGE))
			return;
		OnGoSplodie();
	}

	// move_cycle
	void FireBallGuided_OnMoveCycle()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(FREQ_MOVE, "move_cycle");

		if (RangeTo(MY_TARGET) < DETECT_RANGE)
			OnGoSplodie();
		SetMoveDest(MY_DEST, 9999);
		MY_DEST += RelativeVelocity(Vector3(0, Float(MY_SPEED), 0));
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, Float(MY_SPEED), 0)));
	}

	// find_new_target
	void FireBallGuided_OnFindNewTarget()
	{
		string targetList = LegacyFunction("get_tsphere", "enemy", 1024, MyOrigin());
		if (GetTokenCount(targetList) > 0)
		{
			targetList = TokenShuffle(targetList);
			MY_TARGET = GetToken(targetList, 0);
		}
		MY_DEST = OriginOf(MY_TARGET);

		if (IsAlive(MY_TARGET))
			return;
		Vector3 ownerAng = AnglesOf(MY_OWNER);
		SetAngle("face", Vector3(0, ownerAng.y, 0));
	}

	// go_splodie
	void FireBallGuided_OnGoSplodie()
	{
		int count;
		if (MY_LIGHT_SCRIPT != "MY_LIGHT_SCRIPT")
			ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		Effect("tempent", "spray", SPRITE_EXPLODE, MyOrigin(), 0, 1, 0, 0);
		SetModel("none");
		DoDamageEx(MyOrigin(), MY_AOE, MY_BASE_DMG, 0.1f, MY_OWNER, MY_OWNER, "spellcasting.fire", "fire");
		PUSH_LIST = LegacyFunction("get_tsphere", "enemy", MY_AOE, MyOrigin());
		if (PUSH_LIST != "none")
		{
			count = GetTokenCount(PUSH_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPushLoop();
			}
		}
		// attachsprite SPRITE_EXPLODE trans 20 1.0
		PlaySound(0, 10, SOUND_EXPLODE);
		// drop splodie sprite here
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// push_loop
	void FireBallGuided_OnPushLoop()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(PUSH_LIST, loopIteration));
		DebugPrint("push_loop " + NameOf(curTarget) + " of " + PUSH_LIST);
		Vector3 targetOrg = OriginOf(curTarget);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(curTarget, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110))); // a little to the left too, in case he's stuck up against a wall
	}

	// remove_me
	void FireBallGuided_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_death
	void FireBallGuided_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetModel("none");
		SetIdleAnim("none");
		SetAnimFrameRate(0);
		SetAlive(true); // without this ye get studio frame advance error
		OnGoSplodie();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { FireBallGuided_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnGameSpawn(string playerRace = "", string playerGender = "") { FireBallGuided_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnHuntCycle() { FireBallGuided_OnHuntCycle(); } // hunt_cycle
	void OnMoveCycle() { FireBallGuided_OnMoveCycle(); } // move_cycle
	void OnFindNewTarget() { FireBallGuided_OnFindNewTarget(); } // find_new_target
	void OnGoSplodie() { FireBallGuided_OnGoSplodie(); } // go_splodie
	void OnPushLoop() { FireBallGuided_OnPushLoop(); } // push_loop
	void OnRemoveMe(string caller = "") { FireBallGuided_OnRemoveMe(caller); } // remove_me
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { FireBallGuided_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnFreqHunt() {} // FREQ_HUNT
	void OnFreqMove() {} // FREQ_MOVE
	void OnMyDuration() {} // MY_DURATION

	// This file's events and timers by their .script names
	bool FireBallGuided_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "find_new_target") { OnFindNewTarget(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "hunt_cycle") { OnHuntCycle(); return true; }
		if (name == "move_cycle") { OnMoveCycle(); return true; }
		if (name == "push_loop") { OnPushLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/fire_ball_guided"]
shared class FireBallGuidedScript : ScriptEntity, FireBallGuided
{
	// Variables every script that includes this file declares
	bool AM_LIGHTNING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	string SOUND_SPAWN = "SOUND_SPAWN";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return FireBallGuided_DispatchEvent(name, params);
	}
}
