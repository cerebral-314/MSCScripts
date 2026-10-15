#pragma context server

// Converted from monsters/summon/acid_ball_guided.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/acid_ball_guided"]
class AcidBallGuided : ScriptEntity
{
	// Constants
	string SOUND_EXPLODE = "bullchicken/bc_bite3.wav";
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
	float MY_DOT = 0.0f;
	string PUSH_LIST = "PUSH_LIST";

	// game_dynamically_created
	// <owner> <dmg> <maxlife> <aoe> [first_targ]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
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
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("acid ball");
		SetHealth(30); // may make this adjustable
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
		SetModel("weapons/projectiles.mdl");
		// effect glow ent_me (255,0,0) 64 -1 -1
		PLAYING_DEAD = "1";

		SetMonsterClip(false);

		// setprop ent_me rendermode 5
		// setprop ent_me renderamt 255
		// check attatchsprite/light commands here
		PlaySound(0, 10, "bullchicken/bc_attack3.wav");

		SetModelBody(0, 6);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 16, -1, -1);
		SetIdleAnim("idle_icebolt");
		SetSolid("none");

		SetProp(ENT_ME, "scale", 2.0f);
	}

	// hunt_cycle
	void OnHuntCycle()
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
	void OnMoveCycle()
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
	void OnFindNewTarget()
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
	void OnGoSplodie()
	{
		int count;
		// effect tempent spray SPRITE_EXPLODE game.monster.origin 0 1 0 0
		SetModel("none");
		DoDamageEx(MyOrigin(), MY_AOE, MY_BASE_DMG, 0.1f, MY_OWNER, MY_OWNER, "spellcasting.affliction", "acid");
		MY_DOT = MY_BASE_DMG * 0.1f;
		PUSH_LIST = FindInSphere("enemy", Float(MY_AOE));
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
		ClientEvent("new", "all", "effects/sfx_acid_splash", OriginOf(ENT_ME));
		// drop splodie sprite here
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// push_loop
	void OnPushLoop()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(PUSH_LIST, loopIteration));

		ApplyEffect(curTarg, "effects/dot_poison", 5, MY_OWNER, MY_DOT);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetModel("none");
		SetIdleAnim("none");
		SetAnimFrameRate(0);
		SetAlive(true); // without this ye get studio frame advance error
		OnGoSplodie();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqHunt() {} // FREQ_HUNT
	void OnFreqMove() {} // FREQ_MOVE
	void OnMyDuration() {} // MY_DURATION

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
