#pragma context server

// Converted from effects/add_dynamic_spawn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/add_dynamic_spawn"]
class AddDynamicSpawn : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	bool EFFECT_IGNORE_CLEARFX = true;
	bool DYNS_GLOBAL = false;
	string DYNS_SRADIUS = "DYNS_SRADIUS";
	float DYNS_STARTED = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string DYN_SPAWNER = "DYN_SPAWNER";
	string DYN_SPAWNER_MINS = "DYN_SPAWNER_MINS";
	string DYN_SPAWNER_MAXS = "DYN_SPAWNER_MAXS";
	bool DYNS_FLYER = false;
	bool DYNS_ACTIVE = false;
	float DYNS_FREQ = 0.0f;
	bool DYNS_FOUND_VALID = false;
	string DYNS_VALID_TARGETS = "DYNS_VALID_TARGETS";
	Vector3 DYNS_CHECK_SIGHT = Vector3();
	bool DYNS_IN_VIEW = false;
	Vector3 DYNS_SPAWN_POINT = Vector3();
	string DYNS_TEST_PLAYER = "DYNS_TEST_PLAYER";
	float DYNS_TEST_PLAYER_TRANGE = 0.0f;
	float DYNS_LOWEST_TRANGE = 0.0f;
	string DYNS_WINNER = "DYNS_WINNER";

	// Variables declared by included files, with the value they start with in this script
	AddDynamicSpawn()
	{
		EFFECT_ID = "dynamic_spawn";
		EFFECT_FLAGS = "nostack";
	}

	// unnamed block (first think)
	// This is an additional extension script that causes the spawn monster to remove itself from the map and look.
	// for a point which no player is looking at to appear in within a bounding box assigned by its msarea_monsterspawn.
	// If the "world" parameter is used, it will instead attempt to find a spawn spot within 512 (or PARAM2) units of the densest cluster of players.
	// upon finding such a point it will appear there and this script is removed.
	// (In short, left4dead zombie style spawning.)
	void AddDynamicSpawn_FirstThink()
	{
		EFFECT_IGNORE_CLEARFX = true; // need to add code function to prevent removal via clearfx
	}

	// func_dyns_test_point
	string AddDynamicSpawn_OnFuncDynsTestPoint(string teleportPoint = "")
	{
		string debug = "L_DEBUG";
		string result = "";

		Vector3 oldOrg = OriginOf(ENT_ME);

		SetOrigin(ENT_ME, Vec(teleportPoint));

		SetLocal("reg.npcmove.endpos", teleportPoint);

		float myAng = AnglesOf(ENT_ME).y;
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, myAng, 0), Vector3(-16, 0, 0)));

		SetLocal("reg.npcmove.testonly", 1);

		NpcMove(ENT_ME);

		bool isLegit = true;
		if (Float(Eval("game.ret.npcmove.dist")) == 0.0f)
		{
			isLegit = false;
			debug = "cant_move";
		}
		if (!DYNS_GLOBAL) {}

		// if !$within_box(L_TELE_POINT,0,DYN_SPAWNER_MINS,DYN_SPAWNER_MAXS) //Flooring enemies can cause them to move out of the box. This will cause enemies to never pop back in.
		// local L_IS_LEGIT 0
		// local L_DEBUG not_in_box
		if (!isLegit)
		{
			DebugPrint("func_dyns_test_point " + debug);
			SetOrigin(ENT_ME, oldOrg);

			result = "";
			result = AppendResult(result, "0");
		}
		else
		{
			DebugPrint("func_dyns_test_point valid");

			result = "";
			result = AppendResult(result, "1");
		}
		return result;
	}

	// func_dyns_findspawnpoint
	string AddDynamicSpawn_OnFuncDynsFindspawnpoint()
	{
		string player;
		float ang;
		string result = "";

		if (PlayerCount() == 1)
		{
			player = GetToken(DYNS_VALID_TARGETS, 0);
		}
		else
		{
			// This should randomly select a player to spawn at?
			int rnd = RandomInt(0, PlayerCount());
			player = GetToken(DYNS_VALID_TARGETS, rnd);
		}

		// if ( game.players == 2 )
		// {
		// *shrug* it's 50/50
		// local L_RND $rand(0,1)
		// local L_PLAYER $get_token(DYNS_VALID_TARGETS,L_RND)
		// }
		// else
		// {
		// find the most popular player, based on his proximity to all the others
		// setvard DYNS_LOWEST_TRANGE 9999
		// setvard DYNS_WINNER $get_token(DYNS_VALID_TARGETS,0)
		// setvard DYNS_NPLAYERS $get_token_amt(DYNS_VALID_TARGETS)
		// calleventloop DYNS_NPLAYERS dyns_find_popular_eloop
		// local L_PLAYER DYNS_WINNER
		// }
		Vector3 spawnPoint = OriginOf(player);
		if (GameTime() - DYNS_STARTED < 3.0f)
		{
			// favor a spot the player is facing towards, if I've not been looking too long, so we spawn where he's headed
			ang = Float(Text(ViewAnglesOf(player)));
			ang = Vec(Text(ang)).y + Random(-100, 100);
		}
		else
		{
			ang = Random(0, 359.99f);
		}

		float dist = WidthOf(ENT_ME) * 2.0f + Random(0, Float(DYNS_SRADIUS));
		float z = Random(0, 64); // float up/down a bit for more likely success on uneven terrain
		spawnPoint += RelativePosition(Vector3(0, ang, 0), Vector3(0, dist, z));

		// dbg func_dyns_findspawnpoint select $get(L_PLAYER,name) @ L_SPAWN_POINT
		result = "";
		result = AppendResult(result, Text(spawnPoint));
		return result;
	}

	// game_activate
	// ["world"] [<search_radius>]
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		if (duration == "world")
		{
			DYNS_GLOBAL = true;
			if (!amount.isEmpty())
			{
				if (Float(Left(amount, 1)) > 0.0f) // PARAM2 may also be a string representing the next addparam, so at least make sure it starts with a number...
					DYNS_SRADIUS = amount;
				else
					DYNS_SRADIUS = "512";
			}
			else
			{
				DYNS_SRADIUS = "512";
			}
		}

		// dbg $currentscript game_activate world DYNS_SRADIUS
		DYNS_STARTED = GameTime();

		SetOrigin(ENT_ME, Vector3(40000, 40000, 4000)); // may want to avoid this if DYNS_GLOBAL, and just tell players to keep their NPCs off map
		CallExternal(ENT_ME, "npcatk_suspend_ai");
		PLAYING_DEAD = "1";

		if (!DYNS_GLOBAL)
		{
			DYN_SPAWNER = GetProp(ENT_ME, "spawner");
			DYN_SPAWNER_MINS = GetProp(DYN_SPAWNER, "absmin");
			DYN_SPAWNER_MAXS = GetProp(DYN_SPAWNER, "absmax"); // So glad these work :)
		}

		// dbg $currentscript mins DYN_SPAWNER_MINS maxs DYN_SPAWNER_MAXS
		if (Truthy(GetProp(ENT_ME, "fly")))
			DYNS_FLYER = true;

		DYNS_ACTIVE = true;
		DYNS_FREQ = 0.1f;
		CallEventDelayed(0.1f, "dyns_hunt_find_location");
	}

	// dyns_hunt_find_location
	void OnDynsHuntFindLocation()
	{
		int count;
		int legit = 0;
		int playerIdx = 0;

		if (!DYNS_ACTIVE)
			return;
		CallEventDelayed(DYNS_FREQ, "dyns_hunt_find_location");

		if (PlayerCount() == 0)
			DYNS_FREQ = 1.0f;

		if (!(PlayerCount() > 0))
			return;
		DYNS_FREQ = 0.1f;
		SetVar("DYNS_TARGETS", GetPlayers());
		DYNS_FOUND_VALID = false;
		DYNS_VALID_TARGETS = "";
		if (!DYNS_GLOBAL)
		{
			count = GetTokenCount("DYNS_TARGETS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnDynsFindValidate();
			}
		}
		else
		{
			DYNS_FOUND_VALID = true;
			DYNS_VALID_TARGETS = "DYNS_TARGETS";
		}

		if (!DYNS_FOUND_VALID)
			return;

		DebugPrint("dyns_hunt_find_location");

		int rnd = RandomInt(1, 5);
		if (DYNS_GLOBAL)
			rnd = 1;

		if (rnd < 5)
		{
			// pick random spot within spawn area
			if (!DYNS_GLOBAL)
			{
				float x = Random(Vec(DYN_SPAWNER_MINS).x, Vec(DYN_SPAWNER_MAXS).x);
				float y = Random(Vec(DYN_SPAWNER_MINS).y, Vec(DYN_SPAWNER_MAXS).y);
				float z = Random(Vec(DYN_SPAWNER_MINS).z, Vec(DYN_SPAWNER_MAXS).z);
				DYNS_CHECK_SIGHT = Vector3(x, y, z);
			}
			else
			{
				// for global spawns, area is within DYN_SRADIUS of player with the least total distance between him and other players
				DYNS_CHECK_SIGHT = Vec(OnFuncDynsFindspawnpoint());
			}

			if (Text(DYNS_CHECK_SIGHT) == "none")
				return;

			// stick to ground, if I don't fly
			if (!DYNS_FLYER)
				DYNS_CHECK_SIGHT.z = GroundHeight(DYNS_CHECK_SIGHT);

			// see DYNS_CHECK_SIGHT if in view of any player
			DYNS_IN_VIEW = false;
			count = GetTokenCount("DYNS_TARGETS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnDynsCheckInview();
			}
			if (!DYNS_IN_VIEW)
			{
				// check if can move in new spawn point
				DYNS_SPAWN_POINT = DYNS_CHECK_SIGHT;
				legit = Int(OnFuncDynsTestPoint(Text(DYNS_SPAWN_POINT)));
			}
		}
		else
		{
			// pick random spot behind player, see if in view of others
			int nTargs = GetTokenCount(DYNS_VALID_TARGETS);
			if (nTargs > 1)
				playerIdx = RandomInt(0, int(nTargs - 1.0f));
			else
				playerIdx = 0;

			// pick spot behind player view, up 32-128 units + my width
			string player = GetToken(DYNS_VALID_TARGETS, playerIdx);
			Vector3 playerView = ViewAnglesOf(player);
			float playerViewYaw = playerView.y - 180.0f;
			if (playerViewYaw < 0.0f)
				playerViewYaw += 360.0f;
			playerView.y = playerViewYaw;
			Vector3 playerPos = OriginOf(player);
			float playerBack = Random(32, 128) + WidthOf(ENT_ME);
			playerPos += RelativePosition(playerView, Vector3(0, playerBack, 0));

			DYNS_CHECK_SIGHT = playerPos;
			// stick to ground, if I don't fly
			if (!DYNS_FLYER)
				DYNS_CHECK_SIGHT.z = GroundHeight(DYNS_CHECK_SIGHT);

			// check if DYNS_CHECK_SIGHT in view of any player
			DYNS_IN_VIEW = false;
			count = GetTokenCount("DYNS_TARGETS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnDynsCheckInview();
			}
			if (!DYNS_IN_VIEW)
			{
				// check if can move in new spawn point
				DYNS_SPAWN_POINT = DYNS_CHECK_SIGHT;
				legit = Int(OnFuncDynsTestPoint(Text(DYNS_SPAWN_POINT)));
			}
		}

		if (legit == 0)
			return;
		OnDynsFinalize();
	}

	// dyns_finalize
	void OnDynsFinalize()
	{
		bool dynsTestMode = false;
		if (!dynsTestMode)
		{
			PLAYING_DEAD = "0";
			CallExternal(ENT_ME, "npcatk_resume_ai");
			DYNS_ACTIVE = false;
			CallExternal(ENT_ME, "set_home_loc", OriginOf(ENT_ME));

			RemoveScript();
		}
		else
		{
			// for testing, ping, repeat process
			SetRoam(false);
			CallExternal(ENT_ME, "npcatk_suspend_ai");
			PlaySound(0, 10, "magic/cast.wav");
			DYNS_ACTIVE = false;
			CallEventDelayed(5.0f, "dyns_loop_test");
		}
	}

	// dyns_loop_test
	void OnDynsLoopTest()
	{
		OnGameActivate();
	}

	// dyns_find_validate
	void OnDynsFindValidate()
	{
		CBasePlayer@ curTarg = FindPlayer(GetToken("DYNS_TARGETS", loopIteration));
		if (!Truthy(LegacyFunction("within_box", @curTarg, 0, DYN_SPAWNER_MINS, DYN_SPAWNER_MAXS)))
			return;
		DYNS_FOUND_VALID = true;
		DYNS_VALID_TARGETS = TokenAdd(DYNS_VALID_TARGETS, EntityId(curTarg));
	}

	// dyns_check_inview
	void OnDynsCheckInview()
	{
		CBasePlayer@ curTarg = FindPlayer(GetToken("DYNS_TARGETS", loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 targAng = ViewAnglesOf(curTarg);

		if (WithinCone2D(DYNS_CHECK_SIGHT, targOrg, targAng, 30)) // might be in view, check traceline
		{
			string traceStart = Text(targOrg);
			float myHeight = HeightOf(ENT_ME);
			float traceEnd = Float(LegacyFunction("math", "vectoradd", DYNS_CHECK_SIGHT, "z", myHeight)); // trace to head
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");

			if (traceLine != Text(traceEnd))
			{
				// vision blocked by something
				return;
			}
		}
		else
		{
			return; // not in FOV
		}

		// Within sight
		DYNS_IN_VIEW = true;
	}

	string OnFuncDynsTestPoint(string teleportPoint = "") { return AddDynamicSpawn_OnFuncDynsTestPoint(teleportPoint); } // func_dyns_test_point

	string OnFuncDynsFindspawnpoint() { return AddDynamicSpawn_OnFuncDynsFindspawnpoint(); } // func_dyns_findspawnpoint

	// dyns_find_popular_eloop
	void OnDynsFindPopularEloop()
	{
		int idx = loopIteration;
		DYNS_TEST_PLAYER = GetToken(DYNS_VALID_TARGETS, idx);
		DYNS_TEST_PLAYER_TRANGE = 0.0f;
		for (int i = 0; i < 0; i++)
		{
			loopIteration = i;
			OnDynsTestPopularEeloop();
		}
		if (DYNS_TEST_PLAYER_TRANGE < 0.0f)
		{
			DYNS_LOWEST_TRANGE = DYNS_TEST_PLAYER_TRANGE;
			DYNS_WINNER = DYNS_TEST_PLAYER;
		}
	}

	// dyns_test_popular_eeloop
	void OnDynsTestPopularEeloop()
	{
		string testAgainst = GetToken(DYNS_VALID_TARGETS, loopIteration);
		Vector3 testSubjectOrg = OriginOf(DYNS_TEST_PLAYER);
		Vector3 testTargetOrg = OriginOf(testAgainst);
		DYNS_TEST_PLAYER_TRANGE += Distance(testSubjectOrg, testTargetOrg);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDynsFreq() {} // DYNS_FREQ

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AddDynamicSpawn_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dyns_check_inview") { OnDynsCheckInview(); return true; }
		if (name == "dyns_finalize") { OnDynsFinalize(); return true; }
		if (name == "dyns_find_popular_eloop") { OnDynsFindPopularEloop(); return true; }
		if (name == "dyns_find_validate") { OnDynsFindValidate(); return true; }
		if (name == "dyns_hunt_find_location") { OnDynsHuntFindLocation(); return true; }
		if (name == "dyns_loop_test") { OnDynsLoopTest(); return true; }
		if (name == "dyns_test_popular_eeloop") { OnDynsTestPopularEeloop(); return true; }
		if (name == "func_dyns_findspawnpoint") { Return(OnFuncDynsFindspawnpoint()); return true; }
		if (name == "func_dyns_test_point") { Return(OnFuncDynsTestPoint(Param(params, 0))); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
