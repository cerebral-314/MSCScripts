#pragma context server

// Converted from ms_soccer/base_soccer.script by msc_transpiler.
// note that this script must come before AI includes

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseSoccer
{
	// Constants
	bool NPC_EXTRA_VALIDATIONS = true;

	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ BALL_ID = null;
	bool SUSPEND_AI = false;
	string GOAL_RAD = "GOAL_RAD";
	string CHASE_RANGE = "CHASE_RANGE";
	int NPC_CHASE_RANGE = 0;
	bool SPEED_INCREASED = false;
	bool SPEED_DECREASED = false;
	string BALL_HOME = "BALL_HOME";
	string BLUE_GOAL_LOC = "BLUE_GOAL_LOC";
	string RED_GOAL_LOC = "RED_GOAL_LOC";
	float DEF_MOVE_RANGE = 0.0f;
	float BALL_OOMF = 0.0f;
	string NME_GOAL_LOC = "NME_GOAL_LOC";
	float DRIBBLE_COUNT = 0.0f;
	string NPC_RANGED = "NPC_RANGED";
	bool NPC_NO_MOVE = false;
	float BASE_MOVESPEED = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float NEXT_BALL_BLOCK_WARN = 0.0f;
	int AM_TEAM = 0;
	string TEAM_NAME = "TEAM_NAME";
	bool AM_DEFENSE = false;
	float NEXT_REGEN = 0.0f;
	float LAST_ON_GROUND = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float NEXT_JUMP = 0.0f;
	string OLD_BALL_ORG = "OLD_BALL_ORG";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool SET_FINAL = false;

	// unnamed block (first think)
	void BaseSoccer_FirstThink()
	{
		@BALL_ID = FindByName("soccer_ball");
		if (Truthy(ScriptVarOf(BALL_ID, "GAME_PAUSED")))
			SUSPEND_AI = true;
		GOAL_RAD = "124";

		CHASE_RANGE = "8000";
		NPC_CHASE_RANGE = 8000;
	}

	// game_spawn
	void BaseSoccer_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(2.0f, "soccer_finalize");
		CallEventDelayed(0.5f, "soc_spawn_stuck_check");
		SPEED_INCREASED = false;
		SPEED_DECREASED = false;
	}

	// soccer_finalize
	void BaseSoccer_OnSoccerFinalize()
	{
		string myName;
		@BALL_ID = FindByName("soccer_ball");
		BALL_HOME = ScriptVarOf(BALL_ID, "NPC_HOME_LOC");
		BLUE_GOAL_LOC = EntityId(FindByName("blue_goal_ref"));
		BLUE_GOAL_LOC = Text(OriginOf(BLUE_GOAL_LOC));
		RED_GOAL_LOC = EntityId(FindByName("red_goal_ref"));
		RED_GOAL_LOC = Text(OriginOf(RED_GOAL_LOC));
		DEF_MOVE_RANGE = ATTACK_MOVERANGE;
		BALL_OOMF = 0.0f;

		if (AM_TEAM == 1)
			NME_GOAL_LOC = BLUE_GOAL_LOC;
		else
			NME_GOAL_LOC = RED_GOAL_LOC;

		DRIBBLE_COUNT = 0.0f;

		NPC_RANGED = "0";

		// if ( AM_GOALIE ) setvard NPC_NO_MOVE 1 //manual moves
		// if ( AM_DEFENSE ) setvard NPC_NO_MOVE 1 //verified moves
		// all scripts either use verified or custom moves
		NPC_NO_MOVE = true;

		if (AM_TEAM == 1)
			myName = "Red ";
		else
			myName = "Blue ";

		string nameSuffix = "Wingman";
		if (AM_DEFENSE)
			nameSuffix = "Defender";
		if (Truthy(GetVar("AM_LEADER")))
			nameSuffix = "Leader";
		if (Truthy(GetVar("AM_GOALIE")))
			nameSuffix = "Goalkeeper";

		myName += nameSuffix;

		SetName(myName);

		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void BaseSoccer_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = "Remove ";
		LegacyCommand("stradd", "reg.mitem.title", NameOf(ENT_ME));
		menuItem.type = "callback";
		menuItem.callback = "menu_remove";
		RegisterMenuItem(menuItem);

		bool restoreNormOption = false;
		if (SPEED_INCREASED)
			restoreNormOption = true;
		if (SPEED_DECREASED)
			restoreNormOption = true;

		if (restoreNormOption)
		{
			menuItem.title = "Restore Normal Speed";
			menuItem.type = "callback";
			menuItem.callback = "menu_normal";
			RegisterMenuItem(menuItem);

			menuItem.title = "Set all ";
			LegacyCommand("stradd", "reg.mitem.title", TEAM_NAME);
			LegacyCommand("stradd", "reg.mitem.title", " Team Normal Speed");
			menuItem.type = "callback";
			menuItem.callback = "menu_normal_all";
			RegisterMenuItem(menuItem);
		}

		if (!SPEED_INCREASED)
		{
			menuItem.title = "Make Faster";
			menuItem.type = "callback";
			menuItem.callback = "menu_faster";
			RegisterMenuItem(menuItem);

			menuItem.title = "Make All ";
			LegacyCommand("stradd", "reg.mitem.title", TEAM_NAME);
			LegacyCommand("stradd", "reg.mitem.title", " Team Faster");
			menuItem.type = "callback";
			menuItem.callback = "menu_faster_all";
			RegisterMenuItem(menuItem);
		}

		if (!SPEED_DECREASED)
		{
			menuItem.title = "Make Slower";
			menuItem.type = "callback";
			menuItem.callback = "menu_slower";
			RegisterMenuItem(menuItem);

			menuItem.title = "Make All ";
			LegacyCommand("stradd", "reg.mitem.title", TEAM_NAME);
			LegacyCommand("stradd", "reg.mitem.title", " Team Slower");
			menuItem.type = "callback";
			menuItem.callback = "menu_slower_all";
			RegisterMenuItem(menuItem);
		}
	}

	// menu_faster
	// ========== MAKE FASTER BEGIN
	void BaseSoccer_OnMenuFaster(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " increased speed on a " + NameOf(ENT_ME);
		InfoMessage("all", "ORC SPEED INCREASED", outMsg);
		OnMakeFaster();
	}

	// menu_faster_all
	void BaseSoccer_OnMenuFasterAll(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " increased speed on all " + TEAM_NAME + " Team orcs";
		InfoMessage("all", "TEAM SPEED INCREASED", outMsg);
		OnMakeFaster();
		CallExternal("all", "extsorc_make_team_faster", AM_TEAM);
	}

	// extsorc_make_team_faster
	void BaseSoccer_OnExtsorcMakeTeamFaster(int team = 0)
	{
		if (AM_TEAM != team)
			return;
		OnMakeFaster();
	}

	// make_faster
	void BaseSoccer_OnMakeFaster()
	{
		PlayAnim("critical", ANIM_IDLE);
		SPEED_INCREASED = true;
		SPEED_DECREASED = false;
		// movespeed 1.5
		SetAnimMoveSpeed(1.5f);
		SetAnimFrameRate(1.5f);
		BASE_MOVESPEED = 1.5f;
		BASE_FRAMERATE = "1.5";
	}

	// menu_slower
	// ========== MAKE SLOWER BEGIN
	void BaseSoccer_OnMenuSlower(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " reduced speed on a " + NameOf(ENT_ME);
		InfoMessage("all", "ORC SPEED DECREASED", outMsg);
		OnMakeSlower();
	}

	// menu_slower_all
	void BaseSoccer_OnMenuSlowerAll(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " reduced speed on all " + TEAM_NAME + " Team orcs";
		InfoMessage("all", "TEAM SPEED DECREASED", outMsg);
		OnMakeSlower();
		CallExternal("all", "extsorc_make_team_slower", AM_TEAM);
	}

	// extsorc_make_team_slower
	void BaseSoccer_OnExtsorcMakeTeamSlower(int team = 0)
	{
		if (AM_TEAM != team)
			return;
		OnMakeSlower();
	}

	// make_slower
	void BaseSoccer_OnMakeSlower()
	{
		PlayAnim("critical", ANIM_IDLE);
		SPEED_INCREASED = false;
		SPEED_DECREASED = true;
		// movespeed 0.5
		SetAnimMoveSpeed(0.5f);
		SetAnimFrameRate(0.5f);
		BASE_MOVESPEED = 0.5f;
		BASE_FRAMERATE = "0.5";
	}

	// menu_remove
	void BaseSoccer_OnMenuRemove(CBasePlayer@ target = null)
	{
		SetOrigin(ENT_ME, Vector3(20000, -20000, -10000));
		string outMsg = NameOf(target) + " removed a " + NameOf(ENT_ME) + " from the field.";
		InfoMessage("all", "ORC REMOVED FROM FIELD", outMsg);
		CallEventDelayed(0.1f, "npc_suicide");
	}

	// menu_normal
	// ========== MAKE NORMAL BEGIN
	void BaseSoccer_OnMenuNormal(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " restored normal speed on a " + NameOf(ENT_ME);
		InfoMessage("all", "ORC SPEED DECREASED", outMsg);
		OnMakeNormal();
	}

	// menu_normal_all
	void BaseSoccer_OnMenuNormalAll(CBasePlayer@ target = null)
	{
		string outMsg = NameOf(target) + " restored normal speed on all " + TEAM_NAME + " Team orcs";
		InfoMessage("all", "TEAM SPEED DECREASED", outMsg);
		OnMakeNormal();
		CallExternal("all", "extsorc_make_team_normal", AM_TEAM);
	}

	// extsorc_make_team_normal
	void BaseSoccer_OnExtsorcMakeTeamNormal(int team = 0)
	{
		if (AM_TEAM != team)
			return;
		OnMakeNormal();
	}

	// make_normal
	void BaseSoccer_OnMakeNormal()
	{
		PlayAnim("critical", ANIM_IDLE);
		SPEED_INCREASED = false;
		SPEED_DECREASED = false;
		// movespeed 1.0
		SetAnimMoveSpeed(1);
		SetAnimFrameRate(1);
		BASE_MOVESPEED = 1.0f;
		BASE_FRAMERATE = "1.0";
	}

	// soc_spawn_stuck_check
	void BaseSoccer_OnSocSpawnStuckCheck()
	{
		SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
		SetLocal("reg.npcmove.endpos", NPC_HOME_LOC);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 0, 16)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			// failed, try again in a sec
			DebugPrint("soc_spawn_stuck_check blocked");
			SetOrigin(ENT_ME, Vector3(5000, -5000, -5000));
			CallEventDelayed(1.0f, "soc_spawn_stuck_check");
			if (GameTime() > NEXT_BALL_BLOCK_WARN)
			{
				InfoMessage("all", "ORC BLOCKED", "An orc is blocked...");
				NEXT_BALL_BLOCK_WARN = GameTime() + 10.0f;
			}
		}
	}

	// setsoc_blue
	void BaseSoccer_OnSetsocBlue()
	{
		AM_TEAM = 2;
		SetProp(ENT_ME, "skin", 1);
		TEAM_NAME = "Blue";
	}

	// setsoc_red
	void BaseSoccer_OnSetsocRed()
	{
		AM_TEAM = 1;
		SetProp(ENT_ME, "skin", 0);
		TEAM_NAME = "Red";
	}

	// setsoc_goalrad
	void BaseSoccer_OnSetsocGoalrad(string goalRadius = "")
	{
		GOAL_RAD = goalRadius;
	}

	// ext_soc_blue_remove
	void BaseSoccer_OnExtSocBlueRemove()
	{
		if (AM_TEAM != 2)
			return;
		OnNpcSuicide();
	}

	// ext_soc_red_remove
	void BaseSoccer_OnExtSocRedRemove()
	{
		if (AM_TEAM != 1)
			return;
		OnNpcSuicide();
	}

	// setsoc_def
	void BaseSoccer_OnSetsocDef()
	{
		// dbg is halfback (don't cross mid point)
		AM_DEFENSE = true;
	}

	// npcatk_hunt
	void BaseSoccer_OnNpcatkHunt()
	{
		if (GameTime() > NEXT_REGEN)
		{
			NEXT_REGEN = GameTime() + 1.0f;
			if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME))
			{
				float giveAmt = MaxHealthOf(ENT_ME) * 0.05f;
				GiveHealth(ENT_ME, giveAmt);
			}
		}

		if (IS_FLEEING)
			return;
		if (SUSPEND_AI)
			return;

		if (Truthy(ScriptVarOf(BALL_ID, "GAME_PAUSED")))
		{
			SUSPEND_AI = true;
		}
		else
		{
			float lastSuspendPlus5 = NPC_LAST_SUSPEND_AI + 5.0f;
			if (GameTime() > lastSuspendPlus5) // got suspended for more than 5 secs for some reason
				OnNpcatkResumeAi();
		}

		if (Truthy(ScriptVarOf(BALL_ID, "GAME_PAUSED")))
			return;

		if (NPCATK_TARGET == "unset" && !AM_DEFENSE)
			OnNpcatkSettarget(EntityId(BALL_ID));

		if (IsOnGround(ENT_ME))
		{
			LAST_ON_GROUND = GameTime();
		}
		else
		{
			float lastOnGroundPlus = LAST_ON_GROUND + 5.0f;
			if (GameTime() > lastOnGroundPlus)
			{
				LAST_ON_GROUND = GameTime();
				// I've been off the ground for an awfully long time
				// run randomly a bit - maybe I've stuck the ball
				DebugPrint("in_air_too_long chicken_run");
				OnChickenRun(Random(3, 5));
			}
		}

		Vector3 ballOrg = OriginOf(BALL_ID);

		if (AM_DEFENSE)
		{
			// half backs don't wander beyond the map center
			// which side they stay on is based on team
			// always assume blue team is west of ball (+)
			// ...and red is east of ball (-)
			float ballHomeX = Vec(BALL_HOME).x;
			float destX = Vec(Eval("game.monster.movedest.origin")).x;
			// dbg DEST_X vs BALL_HOME_X
			if (AM_TEAM == 1)
			{
				// red team
				if (destX > ballHomeX)
				{
					// dbg am_defense ball_out_of_range DEST_X vs BALL_HOME_X
					ATTACK_MOVERANGE = 9999.0f; // don't go any further
					MOVE_RANGE = "9999";
				}
				else
				{
					ATTACK_MOVERANGE = DEF_MOVE_RANGE;
					MOVE_RANGE = Text(DEF_MOVE_RANGE);
				}
			}
			else
			{
				// blue team
				if (destX < ballHomeX)
				{
					// dbg am_defense ball_out_of_range DEST_X vs BALL_HOME_X
					ATTACK_MOVERANGE = 9999.0f; // don't go any further
					MOVE_RANGE = "9999";
				}
				else
				{
					ATTACK_MOVERANGE = DEF_MOVE_RANGE;
					MOVE_RANGE = Text(DEF_MOVE_RANGE);
				}
			}
		}

		if (Truthy(GetVar("AM_GOALIE")))
		{
			// dont wander outside goalie box, but try to stay paralell with ball
			if (Distance(Vec(NPC_HOME_LOC), ballOrg) > Float(GOAL_RAD))
			{
				// draw line from goal center to ball, 112 units long
				Vector3 ballDir = DirectionTo(Vec(NPC_HOME_LOC), ballOrg) * Float(GOAL_RAD);
				Vector3 moveDest = Vec(NPC_HOME_LOC);
				moveDest += ballDir;
				moveDest.z = GroundHeight(moveDest);
				SetMoveDest(moveDest, ATTACK_MOVERANGE);
			}
			else
			{
				// if ( G_DEVELOPER_MODE )
				// {
				// local DEBUG_BEAM_START MOVE_DEST
				// local DEBUG_BEAM_END MOVE_DEST
				// vectoradd DEBUG_BEAM_END z 64
				// effect beam point lgtning.spr 20 DEBUG_BEAM_START DEBUG_BEAM_END (255,0,255) 200 0 1.0
				// }
				SetMoveDest(ballOrg, ATTACK_MOVERANGE);
			}

			Vector3 myOrg = OriginOf(ENT_ME);
			string destOrg = Eval("game.monster.movedest.origin");

			if (Distance(myOrg, Vec(destOrg)) < ATTACK_MOVERANGE)
			{
				// setmovedest BALL_ID 9999 //close as we're gonna get - just stare longingly at ball
				Vector3 angToBall = Angles3DTo(myOrg, ballOrg);
				SetAngle("face", Vector3(0, angToBall.y, 0));
			}
		}
	}

	// soc_kickball
	void BaseSoccer_OnSocKickball()
	{
		string targOrg;
		string myGoalLoc;
		bool exitSub = false;
		bool doDribble = false;
		// find my goal
		// dbg soc_kickball
		if (AM_TEAM == 1)
		{
			targOrg = BLUE_GOAL_LOC;
			myGoalLoc = RED_GOAL_LOC;
		}
		else
		{
			targOrg = RED_GOAL_LOC;
			myGoalLoc = BLUE_GOAL_LOC;
		}

		Vector3 ballOrg = OriginOf(BALL_ID);
		Vector3 myOrg = OriginOf(ENT_ME);

		// figure if I am closer to my goal than the ball is, if so, try to jump over it
		if (!Truthy(GetVar("AM_GOALIE")))
		{
			float ballFromGoal = Distance(ballOrg, Vec(targOrg));
			float myFromGoal = Distance(myOrg, Vec(targOrg));
			if (myFromGoal < ballFromGoal && IsOnGround(BALL_ID) && GameTime() > NEXT_JUMP)
			{
				NEXT_JUMP = GameTime() + Random(1, 3);
				OnSocJumpOverBall();
				exitSub = true;
			}
		}
		else
		{
			// if I am a goalie, and the ball is closer to my own team's goal
			// break anim, and hopefully I'll try to pick it up on the next attack
			float myFromMyGoal = Distance(myOrg, Vec(myGoalLoc));
			float ballFromMyGoal = Distance(ballOrg, Vec(myGoalLoc));
			// dbg soc_kickball am_goalie BALL_FROM_MY_GOAL vs MY_FROM_MY_GOAL
			if (ballFromMyGoal < myFromMyGoal)
			{
				DebugPrint("soc_kickball am_goalie break");
				PlayAnim("break");
				PlayAnim("once", GetVar("ANIM_SCOOP_BALL"));
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		// all is well, figure angle between ball and goal
		float targAng = AnglesTo(ballOrg, Vec(targOrg));

		// figure if ent between me and goal, if so, dribble
		// (goalie's dont dribble)
		if (!Truthy(GetVar("AM_GOALIE")))
		{
			string traceStart = Text(ballOrg);
			traceStart = Text(Vec(traceStart) + Vector3(0.0f, 0.0f, 32.0f));
			string traceEnd = Text(Vec(targOrg) + Vector3(0.0f, 0.0f, 32.0f));
			// vectoradd TRACE_START $relpos(TARG_ANG,$vec(0,40,0)) //add a bit so our trace doesn't hit the ball
			Vector3 traceDir = DirectionTo(Vec(traceStart), Vec(traceEnd)) * 64.0f;
			traceStart = Text(Vec(traceStart) + traceDir);
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "ent");
			int dribbleChance = 10;
			if (IsAlive(traceLine))
			{
				dribbleChance = 75;
				DebugPrint("dribble_check " + NameOf(traceLine));
			}
			// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 20 TRACE_START TRACE_END (255,0,0) 200 0 1.0
			// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 20 TRACE_START TRACE_END (0,255,0) 200 0 1.0
			// dbg dribble_check DRIBBLE_CHANCE
			if (RandomInt(1, 100) < dribbleChance)
				doDribble = true;
		}

		float rndF = Random(200, 400);
		float rndV = Random(110, 200);
		float rndLr = 0.0f;
		if (Truthy(GetVar("AM_LEADER")))
		{
			rndF *= 1.5f;
			rndV *= 1.5f;
		}

		if (doDribble)
		{
			DRIBBLE_COUNT += 1.0f;
			if (DRIBBLE_COUNT == 1.0f)
				rndLr = Random(-300, -100);
			if (DRIBBLE_COUNT == 2.0f)
			{
				rndLr = Random(100, 300);
				DRIBBLE_COUNT = 0.0f;
			}
			DebugPrint("doing_dribble " + Text(rndLr));
		}

		// dbg sorc_kickball range $get(BALL_ID,range) vs ATTACK_HITRANGE
		// be nice to have a function
		// if ball is on mah head
		// head butt
		// meanwhile - extend range if ball maybe on mah head
		float hitrange = ATTACK_RANGE;
		if (NPC_VADJSTING)
			hitrange = 9999.0f;
		if (!(RangeTo(BALL_ID) < hitrange)) // ball might have moved before kick landed
			return;

		// dbg sorc_kickball $vec.yaw(TARG_ANG) lr RND_LR v RND_V f RND_F
		if (Distance(Vec(OLD_BALL_ORG), ballOrg) < 50.0f)
		{
			// balls been stuck here awhile, kick harder
			if (!Truthy(GetVar("AM_GOALIE"))) // goalies tend to get the ball in the same spot a lot
			{
				if (BALL_OOMF < 1.0f)
					BALL_OOMF = 1.0f;
				BALL_OOMF += 0.2f;
				DebugPrint("oomf_ball " + Text(BALL_OOMF));
				rndV *= BALL_OOMF;

				if (BALL_OOMF > 5.0f)
				{
					// wtf - MOVE - gonna run off in frustration for a bit
					DebugPrint("ZOMGWTF oomf_ball");
					BALL_OOMF = 0.0f;
					OnNpcatkFlee(EntityId(BALL_ID), "640", Text(Random(3.5f, 6)));
				}
			}
		}
		else
		{
			BALL_OOMF = 0.0f;
		}
		OLD_BALL_ORG = Text(ballOrg);

		CallExternal(BALL_ID, "ext_kicked");
		AddVelocity(BALL_ID, RelativeVelocity(Vector3(0, Vec(Text(targAng)).y, 0), Vector3(rndLr, rndF, rndV)));
	}

	// npc_selectattack
	void BaseSoccer_OnNpcSelectattack()
	{
		string targOrg;
		string myGoalLoc;
		Vector3 ballOrg = OriginOf(BALL_ID);
		Vector3 myOrg = OriginOf(ENT_ME);

		if (AM_TEAM == 1)
		{
			targOrg = BLUE_GOAL_LOC;
			myGoalLoc = RED_GOAL_LOC;
		}
		else
		{
			targOrg = RED_GOAL_LOC;
			myGoalLoc = BLUE_GOAL_LOC;
		}

		// if goalie, and ball is closer to goal than I am, try to pick it up
		if (Truthy(GetVar("AM_GOALIE")))
		{
			float ballFromMyGoal = Distance(ballOrg, Vec(myGoalLoc));
			float myFromMyGoal = Distance(myOrg, Vec(myGoalLoc));

			// dbg BALL_FROM_MY_GOAL vs MY_FROM_MY_GOAL ( $get(BALL_ID,onground) [ rad $dist(NPC_HOME_LOC,MY_ORG) ])
			if (ballFromMyGoal < myFromMyGoal)
			{
				if (Distance(Vec(NPC_HOME_LOC), myOrg) < Float(GOAL_RAD))
				{
					if (IsOnGround(BALL_ID))
						ANIM_ATTACK = GetVar("ANIM_SCOOP_BALL");
					else
						ANIM_ATTACK = ANIM_KICK;
				}
				else
				{
					ANIM_ATTACK = ANIM_KICK;
				}
			}
			else
			{
				ANIM_ATTACK = ANIM_KICK;
			}
		}
		else
		{
			// if not a goalie, and I'm closer to nme goal than the ball
			// try to jump over it
			float ballFromGoal = Distance(ballOrg, Vec(targOrg));
			float myFromGoal = Distance(myOrg, Vec(targOrg));
			if (myFromGoal < ballFromGoal && IsOnGround(BALL_ID))
			{
				OnSocJumpOverBall();
				bool exitSub = true;
			}
		}
	}

	// extsoc_game_start
	void BaseSoccer_OnExtsocGameStart()
	{
		if (SET_FINAL)
		{
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_RUN);
			SET_FINAL = false;
		}
		OnNpcatkResumeAi();
		if (AM_DEFENSE)
			return;
		if (Truthy(GetVar("AM_GOALIE")))
			return;
		OnNpcatkSettarget(EntityId(BALL_ID));
	}

	// extsoc_reset
	void BaseSoccer_OnExtsocReset()
	{
		OnSocStopMovement();
		OnNpcatkSuspendAi();
		OnExtsocResetLoop();
	}

	// extsoc_reset_loop
	void BaseSoccer_OnExtsocResetLoop()
	{
		Vector3 curPos = OriginOf(ENT_ME);
		SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
		SetAngle("face", Vector3(0, NPC_HOME_ANG.y, 0));
		// test position
		SetLocal("reg.npcmove.endpos", NPC_HOME_LOC);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 0, 16)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			// failed, try again in a sec
			DebugPrint("extsoc_reset blocked");
			SetOrigin(ENT_ME, curPos);
			CallEventDelayed(0.1f, "extsoc_reset_loop");
		}
	}

	// extsoc_pause_game
	void BaseSoccer_OnExtsocPauseGame()
	{
		OnSocStopMovement();
		OnNpcatkSuspendAi();
	}

	// extsoc_unpause_game
	void BaseSoccer_OnExtsocUnpauseGame()
	{
		OnExtsocGameStart();
	}

	// extsoc_score
	// <winner:red|blue>
	void BaseSoccer_OnExtsocScore(string winner = "")
	{
		bool gameOver = false;
		OnSocStopMovement();

		if (Float(ScriptVarOf(BALL_ID, "POINTS_BLUE")) == 5.0f)
			gameOver = true;
		if (Float(ScriptVarOf(BALL_ID, "POINTS_RED")) == 5.0f)
			gameOver = true;

		if (gameOver)
			SET_FINAL = true;
		else
			SET_FINAL = false;

		if (winner == "red")
		{
			if (AM_TEAM == 1)
				OnSocRoundWin();
			else
				OnSocRoundLose();
		}
		else if (AM_TEAM == 2)
			OnSocRoundWin();
		else
			OnSocRoundLose();
	}

	// soc_round_win
	void BaseSoccer_OnSocRoundWin()
	{
		OnSocStopMovement();
		if (RandomInt(1, 2) == 1)
		{
			// playrandomsound 0 10 SOUND_ROUND_WIN1 SOUND_ROUND_WIN2
			PlayAnim("critical", ANIM_ROUND_WIN1);
			if (SET_FINAL)
			{
				SetIdleAnim(ANIM_ROUND_WIN1);
				SetMoveAnim(ANIM_ROUND_WIN1);
			}
		}
		else
		{
			// playrandomsound 0 10 SOUND_ROUND_WIN1 SOUND_ROUND_WIN2
			PlayAnim("critical", ANIM_ROUND_WIN2);
			if (SET_FINAL)
			{
				SetIdleAnim(ANIM_ROUND_WIN2);
				SetMoveAnim(ANIM_ROUND_WIN2);
			}
		}
	}

	// soc_round_lose
	void BaseSoccer_OnSocRoundLose()
	{
		OnSocStopMovement();
		if (RandomInt(1, 2) == 1)
		{
			// playrandomsound 0 10 SOUND_ROUND_WIN1 SOUND_ROUND_LOSE
			PlayAnim("critical", ANIM_ROUND_LOST1);
			if (SET_FINAL)
			{
				SetIdleAnim(ANIM_ROUND_LOST1);
				SetMoveAnim(ANIM_ROUND_LOST1);
			}
		}
		else
		{
			// playrandomsound 0 10 SOUND_ROUND_WIN1 SOUND_ROUND_WIN2
			PlayAnim("critical", ANIM_ROUND_LOST2);
			if (SET_FINAL)
			{
				SetIdleAnim(ANIM_ROUND_LOST2);
				SetMoveAnim(ANIM_ROUND_LOST2);
			}
		}
	}

	// soc_jump_over_ball
	void BaseSoccer_OnSocJumpOverBall()
	{
		PlayAnim("break");
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(@BALL_ID, 9999);
		PlayAnim("critical", GetVar("ANIM_JUMP"));
	}

	// soc_stop_movement
	void BaseSoccer_OnSocStopMovement()
	{
		SetMoveDest("none");
		SetRoam(false);
	}

	// npcatk_setmovedest
	void BaseSoccer_OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		bool isBall = false;
		float destX = 0.0f;

		if (IS_FLEEING)
			SetMoveDest(destination, range);

		if (IS_FLEEING)
			return;
		if (Truthy(GetVar("AM_GOALIE"))) // goalie handles movement think side
			return;

		// favor side of ball near your own goal
		if (IsAlive(destination) && destination == EntityId(BALL_ID))
		{
			isBall = true;
			destination = Text(OriginOf(destination));
		}

		if (isBall)
		{
			if (AM_TEAM == 1)
				destination = Text(Vec(destination) + RelativePosition(Vector3(0, 0, 0), Vector3(0, -40, 0)));
			else
				destination = Text(Vec(destination) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 40, 0)));
		}

		// if ( G_DEVELOPER_MODE )
		// {
		// local DEBUG_BEAM_START PARAM1
		// local DEBUG_BEAM_END PARAM1
		// vectoradd DEBUG_BEAM_END z 64
		// if ( AM_TEAM == 1 ) local L_COLOR (255,0,0)
		// if ( AM_TEAM == 2 ) local L_COLOR (0,0,255)
		// effect beam point lgtning.spr 20 DEBUG_BEAM_START DEBUG_BEAM_END L_COLOR 200 0 0.2
		// }
		// defenders ignore ball on wrong side of field
		if (AM_DEFENSE)
		{
			float ballHomeX = Vec(BALL_HOME).x;
			if (IsAlive(destination))
				destX = OriginOf(destination).x;
			else
				destX = Vec(destination).x;

			if (AM_TEAM == 1)
			{
				// red team is west side (x-of ball org)
				if (destX > ballHomeX)
				{
					// dbg am_defense MD_ball_out_of_range DEST_X vs BALL_HOME_X
					if (Range2DTo(BALL_ID) < 256.0f)
					{
						range = "9999";
					}
					else if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > 32.0f)
					{
						destination = NPC_HOME_LOC;
						range = "16";
					}
					else
					{
						destination = EntityId(BALL_ID);
						range = "9999";
					}
				}
			}
			else
			{
				// blue team is east side (x+of ball org)
				if (destX < ballHomeX)
				{
					// dbg am_defense MD_ball_out_of_range DEST_X vs BALL_HOME_X
					if (Range2DTo(BALL_ID) < 256.0f)
					{
						range = "9999";
					}
					else if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > 32.0f)
					{
						destination = NPC_HOME_LOC;
						range = "16";
					}
					else
					{
						destination = EntityId(BALL_ID);
						range = "9999";
					}
				}
			}
		}

		SetMoveDest(destination, range);
	}

	// soc_ball_scoop
	void BaseSoccer_OnSocBallScoop()
	{
		bool madeGrab = false;
		if (RangeTo(BALL_ID) < ATTACK_RANGE && IsOnGround(BALL_ID))
		{
			SetOrigin(BALL_ID, RelativePosition(Vector3(0, 0, -400)));
			SetModelBody(1, 1);
			madeGrab = true;
			SetMoveDest(NME_GOAL_LOC, 9999);
			OnNpcatkSuspendAi();
			OnNpcatkSuspendMovement(GetVar("ANIM_SCOOP_BALL"));
		}
		if (madeGrab)
			return;
		PlayAnim("break");
	}

	// soc_ball_release
	void BaseSoccer_OnSocBallRelease()
	{
		OnNpcatkResumeMovement();
		SetMoveDest(NME_GOAL_LOC, 9999);
		SetModelBody(1, 0);
		Vector3 ballReturnOrg = OriginOf(ENT_ME);
		float myYaw = AnglesOf(ENT_ME).y;
		ballReturnOrg += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, NPC_HALF_WIDTH, NPC_HEIGHT));
		SetOrigin(BALL_ID, ballReturnOrg);
		SetVelocity(BALL_ID, RelativeVelocity(Vector3(0, myYaw, 0), Vector3(0, 300, 200)));
		OnNpcatkResumeAi();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseSoccer_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSoccerFinalize() { BaseSoccer_OnSoccerFinalize(); } // soccer_finalize
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseSoccer_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnMenuFaster(CBasePlayer@ target = null) { BaseSoccer_OnMenuFaster(target); } // menu_faster
	void OnMenuFasterAll(CBasePlayer@ target = null) { BaseSoccer_OnMenuFasterAll(target); } // menu_faster_all
	void OnExtsorcMakeTeamFaster(int team = 0) { BaseSoccer_OnExtsorcMakeTeamFaster(team); } // extsorc_make_team_faster
	void OnMakeFaster() { BaseSoccer_OnMakeFaster(); } // make_faster
	void OnMenuSlower(CBasePlayer@ target = null) { BaseSoccer_OnMenuSlower(target); } // menu_slower
	void OnMenuSlowerAll(CBasePlayer@ target = null) { BaseSoccer_OnMenuSlowerAll(target); } // menu_slower_all
	void OnExtsorcMakeTeamSlower(int team = 0) { BaseSoccer_OnExtsorcMakeTeamSlower(team); } // extsorc_make_team_slower
	void OnMakeSlower() { BaseSoccer_OnMakeSlower(); } // make_slower
	void OnMenuRemove(CBasePlayer@ target = null) { BaseSoccer_OnMenuRemove(target); } // menu_remove
	void OnMenuNormal(CBasePlayer@ target = null) { BaseSoccer_OnMenuNormal(target); } // menu_normal
	void OnMenuNormalAll(CBasePlayer@ target = null) { BaseSoccer_OnMenuNormalAll(target); } // menu_normal_all
	void OnExtsorcMakeTeamNormal(int team = 0) { BaseSoccer_OnExtsorcMakeTeamNormal(team); } // extsorc_make_team_normal
	void OnMakeNormal() { BaseSoccer_OnMakeNormal(); } // make_normal
	void OnSocSpawnStuckCheck() { BaseSoccer_OnSocSpawnStuckCheck(); } // soc_spawn_stuck_check
	void OnSetsocBlue() { BaseSoccer_OnSetsocBlue(); } // setsoc_blue
	void OnSetsocRed() { BaseSoccer_OnSetsocRed(); } // setsoc_red
	void OnSetsocGoalrad(string goalRadius = "") { BaseSoccer_OnSetsocGoalrad(goalRadius); } // setsoc_goalrad
	void OnExtSocBlueRemove() { BaseSoccer_OnExtSocBlueRemove(); } // ext_soc_blue_remove
	void OnExtSocRedRemove() { BaseSoccer_OnExtSocRedRemove(); } // ext_soc_red_remove
	void OnSetsocDef() { BaseSoccer_OnSetsocDef(); } // setsoc_def
	void OnNpcatkHunt() { BaseSoccer_OnNpcatkHunt(); } // npcatk_hunt
	void OnSocKickball() { BaseSoccer_OnSocKickball(); } // soc_kickball
	void OnNpcSelectattack() { BaseSoccer_OnNpcSelectattack(); } // npc_selectattack
	void OnExtsocGameStart() { BaseSoccer_OnExtsocGameStart(); } // extsoc_game_start
	void OnExtsocReset() { BaseSoccer_OnExtsocReset(); } // extsoc_reset
	void OnExtsocResetLoop() { BaseSoccer_OnExtsocResetLoop(); } // extsoc_reset_loop
	void OnExtsocPauseGame() { BaseSoccer_OnExtsocPauseGame(); } // extsoc_pause_game
	void OnExtsocUnpauseGame() { BaseSoccer_OnExtsocUnpauseGame(); } // extsoc_unpause_game
	void OnExtsocScore(string winner = "") { BaseSoccer_OnExtsocScore(winner); } // extsoc_score
	void OnSocRoundWin() { BaseSoccer_OnSocRoundWin(); } // soc_round_win
	void OnSocRoundLose() { BaseSoccer_OnSocRoundLose(); } // soc_round_lose
	void OnSocJumpOverBall() { BaseSoccer_OnSocJumpOverBall(); } // soc_jump_over_ball
	void OnSocStopMovement() { BaseSoccer_OnSocStopMovement(); } // soc_stop_movement
	void OnNpcatkSetmovedest(string destination = "", string range = "") { BaseSoccer_OnNpcatkSetmovedest(destination, range); } // npcatk_setmovedest
	void OnSocBallScoop() { BaseSoccer_OnSocBallScoop(); } // soc_ball_scoop
	void OnSocBallRelease() { BaseSoccer_OnSocBallRelease(); } // soc_ball_release
	void OnChickenRun(float duration = 0.0f) {} // chicken_run
	void OnNpcSuicide(string suicideMode = "") {} // npc_suicide
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") {} // npcatk_flee
	void OnNpcatkResumeAi(string target = "") {} // npcatk_resume_ai
	void OnNpcatkResumeMovement() {} // npcatk_resume_movement
	void OnNpcatkSettarget(string target = "", string debug = "") {} // npcatk_settarget
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai
	void OnNpcatkSuspendMovement(string idleAnim = "", string duration = "") {} // npcatk_suspend_movement

	// This file's events and timers by their .script names
	bool BaseSoccer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_soc_blue_remove") { OnExtSocBlueRemove(); return true; }
		if (name == "ext_soc_red_remove") { OnExtSocRedRemove(); return true; }
		if (name == "extsoc_game_start") { OnExtsocGameStart(); return true; }
		if (name == "extsoc_pause_game") { OnExtsocPauseGame(); return true; }
		if (name == "extsoc_reset") { OnExtsocReset(); return true; }
		if (name == "extsoc_reset_loop") { OnExtsocResetLoop(); return true; }
		if (name == "extsoc_score") { OnExtsocScore(Param(params, 0)); return true; }
		if (name == "extsoc_unpause_game") { OnExtsocUnpauseGame(); return true; }
		if (name == "extsorc_make_team_faster") { OnExtsorcMakeTeamFaster(Int(Param(params, 0))); return true; }
		if (name == "extsorc_make_team_normal") { OnExtsorcMakeTeamNormal(Int(Param(params, 0))); return true; }
		if (name == "extsorc_make_team_slower") { OnExtsorcMakeTeamSlower(Int(Param(params, 0))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_faster") { OnMakeFaster(); return true; }
		if (name == "make_normal") { OnMakeNormal(); return true; }
		if (name == "make_slower") { OnMakeSlower(); return true; }
		if (name == "menu_faster") { OnMenuFaster(PlayerParam(params, 0)); return true; }
		if (name == "menu_faster_all") { OnMenuFasterAll(PlayerParam(params, 0)); return true; }
		if (name == "menu_normal") { OnMenuNormal(PlayerParam(params, 0)); return true; }
		if (name == "menu_normal_all") { OnMenuNormalAll(PlayerParam(params, 0)); return true; }
		if (name == "menu_remove") { OnMenuRemove(PlayerParam(params, 0)); return true; }
		if (name == "menu_slower") { OnMenuSlower(PlayerParam(params, 0)); return true; }
		if (name == "menu_slower_all") { OnMenuSlowerAll(PlayerParam(params, 0)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "setsoc_blue") { OnSetsocBlue(); return true; }
		if (name == "setsoc_def") { OnSetsocDef(); return true; }
		if (name == "setsoc_goalrad") { OnSetsocGoalrad(Param(params, 0)); return true; }
		if (name == "setsoc_red") { OnSetsocRed(); return true; }
		if (name == "soc_ball_release") { OnSocBallRelease(); return true; }
		if (name == "soc_ball_scoop") { OnSocBallScoop(); return true; }
		if (name == "soc_jump_over_ball") { OnSocJumpOverBall(); return true; }
		if (name == "soc_kickball") { OnSocKickball(); return true; }
		if (name == "soc_round_lose") { OnSocRoundLose(); return true; }
		if (name == "soc_round_win") { OnSocRoundWin(); return true; }
		if (name == "soc_spawn_stuck_check") { OnSocSpawnStuckCheck(); return true; }
		if (name == "soc_stop_movement") { OnSocStopMovement(); return true; }
		if (name == "soccer_finalize") { OnSoccerFinalize(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "ms_soccer/base_soccer"]
shared class BaseSoccerScript : ScriptEntity, BaseSoccer
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
	bool AM_FLANKING = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_KICK = "ANIM_KICK";
	string ANIM_ROUND_LOST1 = "ANIM_ROUND_LOST1";
	string ANIM_ROUND_LOST2 = "ANIM_ROUND_LOST2";
	string ANIM_ROUND_WIN1 = "ANIM_ROUND_WIN1";
	string ANIM_ROUND_WIN2 = "ANIM_ROUND_WIN2";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	bool AS_CAN_MOVE = false;
	int AS_CRITICAL_THRESH = 0;
	int AS_DIST_THRESH = 0;
	bool AS_FIRST_STUCK = false;
	Vector3 AS_FLEE_POINT = Vector3();
	float AS_HITBACK_FRUST = 0.0f;
	float AS_HITBACK_FRUST_RUNS = 0.0f;
	float AS_IN_RANGE_CLICKS = 0.0f;
	float AS_LAST_HIT = 0.0f;
	string AS_LAST_POS = "AS_LAST_POS";
	bool AS_LAST_POS_SET = false;
	float AS_LAST_STRIKE = 0.0f;
	float AS_MAX_ATTACK_TIME = 0.0f;
	float AS_MISS_COUNT = 0.0f;
	string AS_MOVEPROX = "AS_MOVEPROX";
	float AS_NEXT_CHECK = 0.0f;
	Vector3 AS_SPAWN_POINT = Vector3();
	bool AS_STARTED = false;
	float AS_STUCK_FREQ = 0.0f;
	bool AS_TELE_OUT = false;
	Vector3 AS_TELE_POINT = Vector3();
	int AS_TELE_THRESH = 0;
	float AS_UNSTUCK_ANG = 0.0f;
	float AS_WIGGLE_DURATION = 0.0f;
	int ATTACK_ANIMINDEX = 0;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	bool BAST_DID_INIT = false;
	bool BAST_FIRST_TEST = false;
	float BAST_FWD = 0.0f;
	float BAST_MOB_HEIGHT_ADJ = 0.0f;
	string BAST_PLAYER_LIST = "BAST_PLAYER_LIST";
	float BAST_ROT = 0.0f;
	bool BAST_SPAWNCHECK = false;
	Vector3 BAST_SPAWN_POS = Vector3();
	bool BAST_STUCK_DID_INIT = false;
	bool BAST_TELEPORTING = false;
	string BAST_TEST_PLAYER = "BAST_TEST_PLAYER";
	float BAST_VFLOAT = 0.0f;
	float BMS_RENDERAMT = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	bool CHICKEN_RUN = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool CYCLED_UP = false;
	string CYCLE_TIME = "CYCLE_TIME";
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
	float CYCLE_TIME_NPC = 0.0f;
	int DEF_STEP_SIZE = 0;
	bool DEMON_BLOOD = false;
	bool DID_HELP_TIP = false;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	bool EFFECT_DAMAGE_DELAY = false;
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string ENTITY_ENEMY = "ENTITY_ENEMY";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	float FD_LOOP_COUNT = 0.0f;
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	Vector3 FLEESTUCK_OLDPOS = Vector3();
	int FLEE_DIR = 0;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float FLEE_STUCKCHECK_FREQ = 0.0f;
	int FLEE_STUCK_COUNT = 0;
	string FLEE_TARGET = "FLEE_TARGET";
	float FLEE_TIME = 0.0f;
	bool FLINCHED_RECENTLY = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	float FLINCH_HEALTH = 0.0f;
	bool FREEZE_WAS_SUSPEND = false;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	float HACK_ATTACK_DELAY = 0.0f;
	float HACK_DAMAGE_DELAY = 0.0f;
	bool HACK_DELAYING_ATTACK = false;
	bool HAS_AI = false;
	bool HAS_INCLUDE_NPC = false;
	bool HAVE_TARGET = false;
	bool HEARD_PLAYER = false;
	bool HEARD_VERIFY = false;
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	bool HIT_BY_MANABALL = false;
	bool HUNTING_PLAYER = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IMMUNE_VAMPIRE = false;
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool IS_FLEEING = false;
	bool IS_HUNTING = false;
	CBaseEntity@ I_HEARD = null;
	bool I_R_FROZEN = false;
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MAX_ADV_SEARCHTIME = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	int MONSTER_WIDTH = 0;
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	bool NEW_AI = false;
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	CBaseEntity@ NPC_ALLY_TO_AID = null;
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_MISS = false;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	bool NPC_CANSEE_TARGET = false;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	float NPC_CLOSEIN_RANGE = 0.0f;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_COULD_SEE_TARGET = false;
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	float NPC_DBL_MOVEPROX = 0.0f;
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	float NPC_DELAY_RETALITATE = 0.0f;
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
	bool NPC_DID_STEP_ADJ = false;
	float NPC_DIE_NT_BASE = 0.0f;
	bool NPC_DIE_NT_FIRST_RUN = false;
	float NPC_DIE_NT_NEXT_CHECK = 0.0f;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	float NPC_DMG_MULTI = 0.0f;
	bool NPC_DOT_COLD = false;
	float NPC_DOT_COLD_RATIO = 0.0f;
	bool NPC_DOT_FIRE = false;
	float NPC_DOT_FIRE_RATIO = 0.0f;
	bool NPC_DOT_LIGHTNING = false;
	float NPC_DOT_LIGHTNING_RATIO = 0.0f;
	bool NPC_DOT_POISON = false;
	float NPC_DOT_POISON_RATIO = 0.0f;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	float NPC_DO_ON_DIE = 0.0f;
	float NPC_DO_ON_SPOT = 0.0f;
	bool NPC_DO_SPAWN_SOUND = false;
	bool NPC_DUMP_XP = false;
	float NPC_EVENT_COUNTER = 0.0f;
	float NPC_EXP_FINAL = 0.0f;
	float NPC_EXP_REDUCT = 0.0f;
	int NPC_FADEIN_RATE = 0;
	bool NPC_FADEIN_SET = false;
	float NPC_FADE_IN_SPEED = 0.0f;
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	int NPC_FRUST_THRESHOLD = 0;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_GOING_HOME = false;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HALF_WIDTH = 0.0f;
	bool NPC_HAS_TARGET = false;
	float NPC_HEIGHT = 0.0f;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_HUNTING_BLIND = false;
	bool NPC_IGNORE_PLAYERS = false;
	bool NPC_INALLY = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	Vector3 NPC_LAST_ORIGIN = Vector3();
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	string NPC_LOST_TARGET = "NPC_LOST_TARGET";
	bool NPC_MADE_IT_HOME = false;
	float NPC_MAXHP = 0.0f;
	float NPC_MAX_RANGE = 0.0f;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool NPC_MOVEMENT_SUSPENDED = false;
	string NPC_MOVEPROX = "NPC_MOVEPROX";
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
	float NPC_NEXT_RETALITATE = 0.0f;
	float NPC_NEXT_RHOME_WIGGLE = 0.0f;
	int NPC_NO_AGRO = 0;
	bool NPC_NO_ATTACK = false;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_OLD_ANIM_IDLE = "NPC_OLD_ANIM_IDLE";
	string NPC_OLD_ANIM_RUN = "NPC_OLD_ANIM_RUN";
	string NPC_OLD_ANIM_WALK = "NPC_OLD_ANIM_WALK";
	string NPC_OLD_ROAM = "NPC_OLD_ROAM";
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROX_LOOP = false;
	bool NPC_QUED_FOR_DEATH = false;
	string NPC_RANGE_TYPE = "NPC_RANGE_TYPE";
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETALIATING = false;
	bool NPC_RETURNING_HOME = false;
	bool NPC_ROAMING_HOME = false;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	Vector3 NPC_SPAWN_ANGLES = Vector3();
	Vector3 NPC_SPAWN_LOC = Vector3();
	float NPC_SPAWN_PRED1 = 0.0f;
	float NPC_SPAWN_PRED2 = 0.0f;
	float NPC_SPAWN_TIME = 0.0f;
	int NPC_SPRITE_IN = 0;
	string NPC_STOREHUNTSTATE_ADVANCED = "NPC_STOREHUNTSTATE_ADVANCED";
	string NPC_STOREHUNTSTATE_MLK = "NPC_STOREHUNTSTATE_MLK";
	float NPC_STORE_HP = 0.0f;
	string NPC_STORE_LOST_TARGET = "NPC_STORE_LOST_TARGET";
	string NPC_STORE_TARGET = "NPC_STORE_TARGET";
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_VADJSTING = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	int NPC_WANDER_RANGE = 0;
	bool NPC_WAS_IN_BATTLE = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	int OLD_NO_STUCK_CHECKS = 0;
	float ORIG_MOVERANGE = 0.0f;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseSoccer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseSoccer_DispatchEvent(name, params);
	}
}
