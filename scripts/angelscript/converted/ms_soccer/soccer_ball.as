#pragma context server

// Converted from ms_soccer/soccer_ball.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "ms_soccer/soccer_ball"]
class SoccerBall : DebugScript
{
	// Constants
	string BALL_WEIGHTS = "0.1;0.25;0.5;1.0;2.0";
	int SENSE_RANGE = 128;
	string SOUND_IDLE1 = "houndeye/he_idle4.wav";
	string SOUND_IDLE2 = "houndeye/he_pain1.wav";
	string SOUND_IDLE3 = "houndeye/he_pain3.wav";
	string SOUND_IDLE4 = "houndeye/he_alert2.wav";
	string SOUND_STRUCK1 = "houndeye/he_die1.wav";
	string SOUND_STRUCK2 = "houndeye/he_die2.wav";
	string SOUND_STRUCK3 = "houndeye/he_pain2.wav";
	string SOUND_STRUCK4 = "houndeye/he_pain4.wav";
	string SOUND_STRUCK5 = "houndeye/he_pain5.wav";
	string SOUND_STRUCK6 = "houndeye/he_alert3.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NPC_ATTACK_INVULN = false;
	float POINTS_RED = 0.0f;
	float POINTS_BLUE = 0.0f;
	float NEXT_BALL_WEIGHT = 0.0f;
	bool IS_SOCCER_BALL = false;
	bool SB_BLUE0 = false;
	bool SB_BLUE1 = false;
	bool SB_BLUE2 = false;
	bool SB_BLUE3 = false;
	bool SB_BLUE4 = false;
	bool SB_BLUE5 = false;
	string BLUE_SCORE_TOKENS = "BLUE_SCORE_TOKENS";
	string RED_SCORE_TOKENS = "RED_SCORE_TOKENS";
	bool SB_RED0 = false;
	bool SB_RED1 = false;
	bool SB_RED2 = false;
	bool SB_RED3 = false;
	bool SB_RED4 = false;
	bool SB_RED5 = false;
	float ADJ_PITCH = 0.0f;
	bool GAME_PAUSED = false;
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NEXT_IDLE_SOUND = 0.0f;
	CBaseEntity@ TRACK_TARGET = null;
	bool AM_HOME = false;
	CBaseEntity@ ATK_ID = null;
	Vector3 ATK_ANG = Vector3();
	bool HOME_REPEAT = false;
	bool AM_BOUNCY = false;
	float COUNT_DOWN = 0.0f;
	string COUNT_DOWN_EVENT = "COUNT_DOWN_EVENT";
	bool COUNT_DOWN_ABORT = false;
	float NEXT_BALL_BLOCK_WARN = 0.0f;
	bool GAME_WON = false;
	bool GAME_STARTED = false;
	string TWAL_TEAM_SUFFIX = "TWAL_TEAM_SUFFIX";
	float DEST_POINTS = 0.0f;
	string CUR_TOKEN_LIST = "CUR_TOKEN_LIST";

	// unnamed block (first think)
	void SoccerBall_FirstThink()
	{
		NPC_ATTACK_INVULN = true;

		POINTS_RED = 0.0f;
		POINTS_BLUE = 0.0f;
		NEXT_BALL_WEIGHT = 4.0f;

		IS_SOCCER_BALL = true;

		SB_BLUE0 = false;
		SB_BLUE1 = false;
		SB_BLUE2 = false;
		SB_BLUE3 = false;
		SB_BLUE4 = false;
		SB_BLUE5 = false;

		BLUE_SCORE_TOKENS = "0;0;0;0;0;0";
		RED_SCORE_TOKENS = "0;0;0;0;0;0";

		SB_RED0 = false;
		SB_RED1 = false;
		SB_RED2 = false;
		SB_RED3 = false;
		SB_RED4 = false;
		SB_RED5 = false;
	}

	// unnamed block (timer)
	void SoccerBall_Timer()
	{
		CallEventDelayed(0.1f, "SoccerBall_Timer");
		if (SpeedOf(ENT_ME) > 50.0f)
			PlayAnim("once", "spin_horizontal_slow");
		if (SpeedOf(ENT_ME) > 200.0f)
			PlayAnim("once", "spin_horizontal_fast");

		// dbg $get(ent_me,speed)
		if (!IsAlive(TRACK_TARGET))
			return;

		if (RangeTo(TRACK_TARGET) < SENSE_RANGE)
		{
			if (SpeedOf(ENT_ME) > 0.0f)
			{
				ADJ_PITCH = -1.1f;
				SetProp(ENT_ME, "controller0", ADJ_PITCH);
			}
			if (SpeedOf(ENT_ME) == 0.0f)
			{
				SetMoveDest(@TRACK_TARGET, 9999);

				Vector3 targOrg = OriginOf(TRACK_TARGET);
				Vector3 angToTarg = Angles3DTo(MyOrigin(), targOrg);
				angToTarg.x = -angToTarg.x;
				ADJ_PITCH = angToTarg.x + 20.0f; // down a bit
				if (ADJ_PITCH > -1.1f)
					ADJ_PITCH = -1.1f;
				SetProp(ENT_ME, "controller0", ADJ_PITCH);
				// dbg trackang  ADJ_PITCH
				if (GameTime() > NEXT_IDLE_SOUND)
				{
					NEXT_IDLE_SOUND = GameTime() + Random(20, 30);
					PlayAnim("once", "idle_scared");
					LegacyCommand("svplayrandomsound", 4, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4);
				}
			}
		}
		else
		{
			if (ADJ_PITCH > -1.1f)
				ADJ_PITCH -= 0.1f;
			if (ADJ_PITCH < -1.1f)
				ADJ_PITCH += 0.1f;
			if (SpeedOf(ENT_ME) > 0.0f)
				ADJ_PITCH = -1.1f;
			SetProp(ENT_ME, "controller0", ADJ_PITCH);
		}
	}

	// game_damaged
	string SoccerBall_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (GAME_PAUSED)
		{
			if (!GAME_STARTED)
				InfoMessage(attacker, "CLICK THE BALL TO BEGIN", "Click USE on the ball to begin the game...");
			// callexternal $get_by_name(sorc_sayer) say_instruct
			PlayerMessageDark(attacker, "Ball not yet in play...");
		}

		AM_HOME = false;
		result = AppendResult(result, "0.0");
		LegacyCommand("svplayrandomsound", 2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5, SOUND_STRUCK6);
		@ATK_ID = attacker;
		ATK_ANG = ViewAnglesOf(attacker);

		CallEventDelayed(0.1f, "adj_vel");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Soccer Ball");
		SetModel("soccer/soccer_ball.mdl");
		SetWidth(32);
		SetHeight(38);

		SetUniqueName("soccer_ball");

		SetHearingSensitivity(2);

		SetGravity(1);

		SetRace("hated");
		SetHealth(1);

		ADJ_PITCH = -1.1f;

		SetIdleAnim("idle_standard");
		SetMoveAnim("idle_standard");

		SetSayTextRange(4096);

		SetMonsterClip(true);

		SetMenuAutoOpen(true);

		GAME_PAUSED = true;

		SetNoPush(true);

		CallEventDelayed(0.1f, "get_home_pos");
		CallEventDelayed(1.0f, "update_scoreboards");
	}

	// get_home_pos
	void OnGetHomePos()
	{
		SetGlobal("G_CHRISTMAS_MODE", 0);
		NPC_HOME_LOC = Text(OriginOf(ENT_ME));
		PlayAnim("critical", "idle_standard");
		NEXT_IDLE_SOUND = GameTime() + Random(20, 30);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (!(RangeTo(lastHeard) < SENSE_RANGE))
			return;
		@TRACK_TARGET = lastHeard;
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return SoccerBall_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ext_kicked
	void OnExtKicked()
	{
		LegacyCommand("svplayrandomsound", 2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5, SOUND_STRUCK6);
	}

	// adj_vel
	void OnAdjVel(string target = "")
	{
		// in theory, gives players a bit more control over the ball, based on the pitch ang
		if (!IsPlayer(target))
			return;
		Vector3 myVel = VelocityOf(ENT_ME);
		ATK_ANG.x = -ATK_ANG.x;
		// (no effect in .script: vectorset needs x, y or z) vectorset MY_VEL $relvel(ATK_ANG,MY_VEL)
		SetVelocity(ENT_ME, myVel);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		bool optResetScores = false;
		bool sorcsActive = false;

		if (!GAME_STARTED)
		{
			menuItem.title = "BEGIN GAME!";
			menuItem.type = "callback";
			menuItem.data = "1";
			menuItem.callback = "soc_game_begin";
			RegisterMenuItem(menuItem);
		}

		string ballWeightMenu = "Set ball weight to " + GetToken(BALL_WEIGHTS, int(NEXT_BALL_WEIGHT));

		menuItem.title = ballWeightMenu;
		menuItem.type = "callback";
		menuItem.callback = "set_weight";
		RegisterMenuItem(menuItem);

		if (!AM_BOUNCY)
		{
			menuItem.title = "Bouncy Ball";
			menuItem.type = "callback";
			menuItem.data = "1";
			menuItem.callback = "set_bouncy";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Less Bouncy";
			menuItem.type = "callback";
			menuItem.data = "0";
			menuItem.callback = "set_bouncy";
			RegisterMenuItem(menuItem);
		}

		menuItem.title = "Move Ball Home";
		menuItem.type = "callback";
		menuItem.callback = "reset_ball";
		RegisterMenuItem(menuItem);

		if (POINTS_RED != 0.0f)
			optResetScores = true;
		if (POINTS_BLUE != 0.0f)
			optResetScores = true;
		if (optResetScores)
		{
			menuItem.title = "Reset Scores";
			menuItem.type = "callback";
			menuItem.callback = "reset_scores";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			menuItem.title = "DELETE BALL";
			menuItem.type = "callback";
			menuItem.callback = "menu_dev_delete";
			RegisterMenuItem(menuItem);
		}

		if (!GAME_STARTED)
			return;
		if (!GAME_PAUSED)
		{
			menuItem.title = "Call Timeout";
			menuItem.type = "callback";
			menuItem.callback = "call_timeout";
			RegisterMenuItem(menuItem);
		}
		else
		{
			if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GMSOC_RED_TEAM_ACTIVE")))
				sorcsActive = true;
			if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GMSOC_BLUE_TEAM_ACTIVE")))
				sorcsActive = true;
			if (sorcsActive)
			{
				menuItem.title = "Reset Positions";
				menuItem.type = "callback";
				menuItem.callback = "reset_sorcs";
				RegisterMenuItem(menuItem);
			}

			menuItem.title = "Call Time In";
			menuItem.type = "callback";
			menuItem.callback = "call_timein";
			RegisterMenuItem(menuItem);
		}
	}

	// menu_dev_delete
	void OnMenuDevDelete()
	{
		DeleteEntity(ENT_ME);
	}

	// reset_sorcs
	void OnResetSorcs(CBasePlayer@ player = null)
	{
		string outMsg = NameOf(player) + " reset sorc positions";
		InfoMessage("all", "SORCS RESET", outMsg);
		CallExternal("all", "extsoc_reset");
	}

	// call_timeout
	void OnCallTimeout(CBasePlayer@ entity = null)
	{
		string outMsg = NameOf(entity) + " called time out";
		InfoMessage("all", "TIME OUT!", outMsg);
		CallExternal("all", "ext_soccer_timeout");
		OnPauseGame();
	}

	// call_timein
	void OnCallTimein(CBasePlayer@ entity = null)
	{
		string outMsg = NameOf(entity) + " called time in";
		InfoMessage("all", "TIME IN!", outMsg);
		CallExternal("all", "ext_soccer_timein");
		OnUnpauseGame();
	}

	// reset_ball
	void OnResetBall(CBasePlayer@ player = null)
	{
		string outMsg = NameOf(player) + " sent the ball home";
		InfoMessage("all", "BALL RESET", outMsg);
		AM_HOME = false;
		SetOrigin(ENT_ME, Vector3(5000, 5000, -5000));
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		SetProp(ENT_ME, "velocity", Vector3(0, 0, 0));
		HOME_REPEAT = true;
		OnMoveBallHome();
	}

	// reset_scores
	void OnResetScores(CBasePlayer@ player = null)
	{
		string outMsg = NameOf(player) + " reset the scores";
		InfoMessage("all", "SCORES RESET", outMsg);
		POINTS_BLUE = 0.0f;
		POINTS_RED = 0.0f;
		OnUpdateScoreboards();
	}

	// set_weight
	void OnSetWeight(CBasePlayer@ entity = null)
	{
		SetGravity(Float(GetToken(BALL_WEIGHTS, int(NEXT_BALL_WEIGHT))));
		string outMsg = NameOf(entity) + " changed ball weight to ";
		outMsg += GetToken(BALL_WEIGHTS, int(NEXT_BALL_WEIGHT));
		InfoMessage("all", "BALL WEIGHT CHANGE", outMsg);
		NEXT_BALL_WEIGHT += 1.0f;
		if (NEXT_BALL_WEIGHT >= GetTokenCount(BALL_WEIGHTS))
			NEXT_BALL_WEIGHT = 0.0f;
	}

	// set_bouncy
	void OnSetBouncy(CBasePlayer@ target = null, int enabled = 0)
	{
		string outMsg;
		if (enabled != 0)
		{
			AM_BOUNCY = true;
			outMsg = NameOf(target) + " made the ball bouncier!";
			InfoMessage("all", "BOUNCY BALL", outMsg);
			SetProp(ENT_ME, "movetype", 10);
		}
		else
		{
			AM_BOUNCY = false;
			outMsg = NameOf(target) + " restored the ball to normal.";
			InfoMessage("all", "NOT SO BOUNCY BALL", outMsg);
			SetProp(ENT_ME, "movetype", 4);
		}
	}

	// ext_blue_scores_goal
	void OnExtBlueScoresGoal()
	{
		POINTS_BLUE += 1.0f;
		OnUpdateScoreboards();
		CallExternal("players", "extsoc_show_scores", POINTS_RED, POINTS_BLUE);

		// callexternal $get_by_name(soc_sayer) msg_blue_scores
		OnDoGoal("blue");
	}

	// ext_red_scores_goal
	void OnExtRedScoresGoal()
	{
		POINTS_RED += 1.0f;
		OnUpdateScoreboards();
		CallExternal("players", "extsoc_show_scores", POINTS_RED, POINTS_BLUE);

		// callexternal $get_by_name(soc_sayer) msg_red_scores
		OnDoGoal("red");
	}

	// do_goal
	void OnDoGoal(string team = "")
	{
		bool exitSub = false;
		SetOrigin(ENT_ME, Vector3(5000, 5000, -5000));
		OnPauseGame();
		CallExternal("all", "extsoc_score", ToLowerCase(team));
		string outMsg = "RED: " + int(POINTS_RED) + " BLUE: " + int(POINTS_BLUE);

		if (team == "red")
			InfoMessage("all", "RED SCORES", outMsg);
		if (team == "blue")
			InfoMessage("all", "BLUE SCORES", outMsg);

		// do fanfair - have npc's cheer/jeer
		if (POINTS_RED == 5.0f)
		{
			OnDoGameWin();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (POINTS_BLUE == 5.0f)
		{
			OnDoGameWin();
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(3.0f, "resume_after_score1");
	}

	// resume_after_score1
	void OnResumeAfterScore1()
	{
		CallExternal("all", "extsoc_reset");

		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GMSOC_RED_TEAM_ACTIVE"))) // respawn anyone who died
			UseTrigger("spawn_red_team");
		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GMSOC_BLUE_TEAM_ACTIVE"))) // respawn anyone who died
			UseTrigger("spawn_blue_team");
		CallEventDelayed(5.0f, "resume_after_score2");
		COUNT_DOWN = 5.0f;
		COUNT_DOWN_EVENT = "unpause_game";
		OnDoCountdown();
		AM_HOME = false;
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		SetProp(ENT_ME, "velocity", Vector3(0, 0, 0));
		OnMoveBallHome();
	}

	// do_countdown
	void OnDoCountdown()
	{
		if (COUNT_DOWN > 1.0f)
			CallEventDelayed(1.0f, "do_countdown");

		if (!AM_HOME)
		{
			OnMoveBallHome();
			COUNT_DOWN_ABORT = true;
			COUNT_DOWN = 5.0f;
		}
		else
		{
			COUNT_DOWN_ABORT = false;
		}
		if (COUNT_DOWN_ABORT)
			return;

		CallExternal("players", "ext_hud_icon", int(COUNT_DOWN), "cnt", 40, 0, 20, 30, 0.75f);
		// callexternal $get_by_name(soc_sayer) msg_countdown COUNT_DOWN
		string outMsg = Text(int(COUNT_DOWN)) + "...";
		MessageAll("green", outMsg);

		COUNT_DOWN -= 1.0f;

		if (COUNT_DOWN <= 0.0f)
			CallEventOrDelay(COUNT_DOWN_EVENT);
	}

	// resume_after_score2
	void OnResumeAfterScore2()
	{
		if (AM_HOME)
		{
			COUNT_DOWN_ABORT = false;
		}
		else
		{
			SetVelocity(ENT_ME, Vector3(0, 0, 0));
			SetProp(ENT_ME, "velocity", Vector3(0, 0, 0));
			OnMoveBallHome();
			COUNT_DOWN_ABORT = true;
			COUNT_DOWN = 5.0f;
			CallEventDelayed(0.1f, "resume_after_score2");
		}
	}

	// move_ball_home
	void OnMoveBallHome()
	{
		Vector3 curPos = OriginOf(ENT_ME);
		SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
		// test position
		SetLocal("reg.npcmove.endpos", NPC_HOME_LOC);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 0, 16)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, "NPCATK_TARGET"); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			// failed, calling event should try again in a sec
			DebugPrint("extsoc_reset blocked");
			SetOrigin(ENT_ME, curPos);
			if (HOME_REPEAT)
				CallEventDelayed(0.1f, "move_ball_home");
			if (GameTime() > NEXT_BALL_BLOCK_WARN)
			{
				InfoMessage("all", "BALL BLOCKED", "Please step away from the ball spawn...");
				NEXT_BALL_BLOCK_WARN = GameTime() + 10.0f;
			}
		}
		else
		{
			// callexternal $get_by_name(soc_sayer) msg_ball_stuck
			HOME_REPEAT = false;
			AM_HOME = true;
		}
	}

	// pause_game
	void OnPauseGame()
	{
		GAME_PAUSED = true;
		SetNoPush(true);
		CallExternal("all", "extsoc_pause_game");
	}

	// unpause_game
	void OnUnpauseGame()
	{
		GAME_PAUSED = false;
		SetNoPush(false);
		CallExternal("all", "extsoc_unpause_game");
	}

	// soc_game_begin
	void OnSocGameBegin()
	{
		POINTS_RED = 0.0f;
		POINTS_BLUE = 0.0f;
		OnUpdateScoreboards();
		// callexternal $get_by_name(soc_sayer) msg_game_begins
		if (GAME_WON)
		{
			// one a previous game, so reset sorcs
			CallExternal("all", "extsoc_reset");
			GAME_WON = false;
		}
		GAME_STARTED = true;
		CallEventDelayed(1.0f, "soc_game_begin2");
	}

	// soc_game_begin2
	void OnSocGameBegin2()
	{
		COUNT_DOWN = 5.0f;
		COUNT_DOWN_EVENT = "unpause_game";
		OnDoCountdown();
	}

	// do_game_win
	// <red|blue:1|2>
	void OnDoGameWin()
	{
		GAME_STARTED = false;
		GAME_WON = true;
		HOME_REPEAT = true;
		OnMoveBallHome();
	}

	// ext_say_scores
	void OnExtSayScores()
	{
		CallExternal("players", "extsoc_show_scores", POINTS_RED, POINTS_BLUE);
	}

	// ext_send_menu
	// <target>
	void OnExtSendMenu(CBaseEntity@ target = null)
	{
		OpenMenu(target);
	}

	// update_scoreboards
	void OnUpdateScoreboards()
	{
		DebugPrint("update_scoreboards blue_before: " + BLUE_SCORE_TOKENS);
		TWAL_TEAM_SUFFIX = "blue";
		DEST_POINTS = POINTS_BLUE;
		CUR_TOKEN_LIST = BLUE_SCORE_TOKENS;
		int count = GetTokenCount(BLUE_SCORE_TOKENS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnUpdateTwals();
		}
		BLUE_SCORE_TOKENS = CUR_TOKEN_LIST;
		DebugPrint("update_scoreboards blue_after: " + BLUE_SCORE_TOKENS);

		DebugPrint("update_scoreboards red_before: " + RED_SCORE_TOKENS);
		TWAL_TEAM_SUFFIX = "red";
		DEST_POINTS = POINTS_RED;
		CUR_TOKEN_LIST = RED_SCORE_TOKENS;
		count = GetTokenCount(RED_SCORE_TOKENS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnUpdateTwals();
		}
		RED_SCORE_TOKENS = CUR_TOKEN_LIST;
		DebugPrint("update_scoreboards red_after: " + RED_SCORE_TOKENS);
	}

	// update_twals
	void OnUpdateTwals()
	{
		int curIdx = loopIteration;
		string twalName = "twal_score_" + TWAL_TEAM_SUFFIX + curIdx;

		if (curIdx == DEST_POINTS)
		{
			if (Float(GetToken(CUR_TOKEN_LIST, curIdx)) == 0.0f)
			{
				CUR_TOKEN_LIST = TokenSet(CUR_TOKEN_LIST, curIdx, "1");
				UseTrigger(twalName);
				DebugPrint("turning " + twalName + " on [ " + CUR_TOKEN_LIST + " ]");
			}
		}
		else if (Float(GetToken(CUR_TOKEN_LIST, curIdx)) == 1.0f)
		{
			CUR_TOKEN_LIST = TokenSet(CUR_TOKEN_LIST, curIdx, "0");
			UseTrigger(twalName);
			DebugPrint("turning " + twalName + " off [ " + CUR_TOKEN_LIST + " ]");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCountDownEvent() {} // COUNT_DOWN_EVENT

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("soccer/soccer_ball.mdl");
		Precache("houndeye/he_idle4.wav");
		Precache("houndeye/he_pain1.wav");
		Precache("houndeye/he_pain3.wav");
		Precache("houndeye/he_alert2.wav");
		Precache("houndeye/he_die1.wav");
		Precache("houndeye/he_die2.wav");
		Precache("houndeye/he_pain2.wav");
		Precache("houndeye/he_pain4.wav");
		Precache("houndeye/he_pain5.wav");
		Precache("houndeye/he_alert3.wav");
		CallEventDelayed(0.1f, "SoccerBall_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SoccerBall_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "adj_vel") { OnAdjVel(Param(params, 0)); return true; }
		if (name == "call_timein") { OnCallTimein(PlayerParam(params, 0)); return true; }
		if (name == "call_timeout") { OnCallTimeout(PlayerParam(params, 0)); return true; }
		if (name == "do_countdown") { OnDoCountdown(); return true; }
		if (name == "do_game_win") { OnDoGameWin(); return true; }
		if (name == "do_goal") { OnDoGoal(Param(params, 0)); return true; }
		if (name == "ext_blue_scores_goal") { OnExtBlueScoresGoal(); return true; }
		if (name == "ext_kicked") { OnExtKicked(); return true; }
		if (name == "ext_red_scores_goal") { OnExtRedScoresGoal(); return true; }
		if (name == "ext_say_scores") { OnExtSayScores(); return true; }
		if (name == "ext_send_menu") { OnExtSendMenu(EntityParam(params, 0)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_home_pos") { OnGetHomePos(); return true; }
		if (name == "menu_dev_delete") { OnMenuDevDelete(); return true; }
		if (name == "move_ball_home") { OnMoveBallHome(); return true; }
		if (name == "pause_game") { OnPauseGame(); return true; }
		if (name == "reset_ball") { OnResetBall(PlayerParam(params, 0)); return true; }
		if (name == "reset_scores") { OnResetScores(PlayerParam(params, 0)); return true; }
		if (name == "reset_sorcs") { OnResetSorcs(PlayerParam(params, 0)); return true; }
		if (name == "resume_after_score1") { OnResumeAfterScore1(); return true; }
		if (name == "resume_after_score2") { OnResumeAfterScore2(); return true; }
		if (name == "set_bouncy") { OnSetBouncy(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "set_weight") { OnSetWeight(PlayerParam(params, 0)); return true; }
		if (name == "soc_game_begin") { OnSocGameBegin(); return true; }
		if (name == "soc_game_begin2") { OnSocGameBegin2(); return true; }
		if (name == "unpause_game") { OnUnpauseGame(); return true; }
		if (name == "update_scoreboards") { OnUpdateScoreboards(); return true; }
		if (name == "update_twals") { OnUpdateTwals(); return true; }
		if (name == "SoccerBall_Timer") { SoccerBall_Timer(); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
