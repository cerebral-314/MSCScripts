#pragma context server

// Converted from bloodshrine/base_sorc_friendly.script by msc_transpiler.
// It would be better to use monsters/base_battle_ally for this
// This script was made before that base_battle_ally implemented, but base_battle_ally based on this script

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseSorcFriendly
{
	// Constants
	bool NPC_BATTLE_ALLY = true;
	bool NPC_FIGHTS_NPCS = true;
	Vector3 TO_SBOSS_TELE_POINT = Vector3();
	bool FSORC_DMG_REQ = false;

	// Variables (an unset .script variable reads as its own name)
	bool NPC_NO_PLAYER_DMG = false;
	int FOLLOW_PLR_DIST = 0;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float FSORC_DMG_POINTS = 0.0f;
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	float F_STUCK_COUNT = 0.0f;
	float F_AS_UNSTUCK_ANG = 0.0f;
	bool FSORC_ON = false;
	string CYCLE_TIME = "CYCLE_TIME";
	float NEXT_TEAM_ALERT = 0.0f;
	string NPCATK_TARGET = "NPCATK_TARGET";
	float NEXT_FAS_CHECK = 0.0f;
	bool BFSORC_GOING_TELE = false;
	float NEXT_REGEN = 0.0f;
	float NEXT_FOLLOW_CHECK = 0.0f;
	string FPLAYER_LIST = "FPLAYER_LIST";
	string FOLLOW_PLR_ID = "FOLLOW_PLR_ID";
	float NEXT_SORCJUMP = 0.0f;
	float UP_SORCJUMP_STR = 0.0f;
	float FWD_JUMP_STR = 0.0f;
	bool WAIT_MODE = false;
	Vector3 WAIT_POINT = Vector3();
	bool FSORC_HIT_BY_BOSS = false;
	CBaseEntity@ ZOMBIE_ID = null;
	CBaseEntity@ SBOSS_ID = null;
	Vector3 SBOSS_ORG = Vector3();
	bool BFSORC_MOVE_TELE = false;
	bool BFSORC_DID_TELE = false;
	CBaseEntity@ T_SHAMAN_ID = null;
	CBaseEntity@ T_LEADER_ID = null;
	CBaseEntity@ T_SECOND_ID = null;
	int OLD_DIST = 0;
	bool REWARD_MODE = false;
	bool AM_HUMILIATED = false;
	bool SETUP_QUALIFICATIONS = false;
	bool USER_QUALIFIES = false;
	bool TC_QUAL_PLAYERS = false;
	float TC_AVG_DMG_PTS = 0.0f;
	float TC_HALF_AVG_DMG_PTS = 0.0f;
	string SORC_FINAL_TELEDEST = "SORC_FINAL_TELEDEST";
	float FSORC_TELE_HOME_DELAY = 0.0f;

	// unnamed block (first think)
	void BaseSorcFriendly_FirstThink()
	{
		NPC_NO_PLAYER_DMG = true;
		FOLLOW_PLR_DIST = 128;

		// setvard SPELL_HEAL_MULTI 5.0
		SetSayTextRange(4096);

		NO_STUCK_CHECKS = "1";

		FSORC_DMG_POINTS = 0.0f;

		NPC_ALLY_RESPONSE_RANGE = 4096.0f;

		F_STUCK_COUNT = 0.0f;
		F_AS_UNSTUCK_ANG = 0.0f;
	}

	// ext_fsorc_init
	void BaseSorcFriendly_OnExtFsorcInit()
	{
		FSORC_ON = true;
	}

	// npc_post_spawn
	void BaseSorcFriendly_OnNpcPostSpawn()
	{
		SetMenuAutoOpen(false);
		CallEventDelayed(2.0f, "fix_step_size");
	}

	// fix_step_size
	void BaseSorcFriendly_OnFixStepSize()
	{
		SetStepSize(48);
	}

	// npcatk_hunt
	void BaseSorcFriendly_OnNpcatkHunt()
	{
		bool findNewFollow = false;
		if (SUSPEND_AI)
			return;
		if (!FSORC_ON)
			return;
		float gameTime = GameTime();
		CYCLE_TIME = "0.1";

		if (NPCATK_TARGET != "unset")
		{
			NO_STUCK_CHECKS = "0";
			if (!WAIT_MODE && gameTime > NEXT_TEAM_ALERT)
			{
				NEXT_TEAM_ALERT = gameTime + 10.0f;
				// something funky going on with them not realizing targets are dead sometimes
				// check also if SUSPEND_AI is being fuxed with, next time you see it
				if (!IsAlive(NPCATK_TARGET))
					NPCATK_TARGET = "unset";
				else
					OnDoTeamAlert();
			}
		}

		if (NPCATK_TARGET != "unset")
			return;

		if (gameTime > NEXT_FAS_CHECK)
		{
			NEXT_FAS_CHECK = GameTime() + 0.5f;
			OnFsorcFriendlyStuckCheck();
		}
		if (SUSPEND_AI) // incase AS triggered AI suspend
			return;

		if (BFSORC_MOVE_TELE && !BFSORC_DID_TELE && !BFSORC_GOING_TELE)
		{
			Vector3 myOrg = OriginOf(ENT_ME);
			if (Distance(myOrg, TO_SBOSS_TELE_POINT) < 600.0f)
			{
				BFSORC_GOING_TELE = true;
				NO_STUCK_CHECKS = "0";
				OnFsorcWait(TO_SBOSS_TELE_POINT);
			}
		}

		if (gameTime > NEXT_REGEN && HealthOf(ENT_ME) < MaxHealthOf(ENT_ME))
		{
			float regenAmt = MaxHealthOf(ENT_ME) * 0.1f;
			GiveHealth(ENT_ME, regenAmt);
			NEXT_REGEN = gameTime + 1.0f;
		}

		if (!(PlayerCount() > 0))
			return;

		if (gameTime > NEXT_FOLLOW_CHECK)
			findNewFollow = true;
		if (!IsAlive(FOLLOW_PLR_ID))
			findNewFollow = true;

		if (findNewFollow)
		{
			NEXT_FOLLOW_CHECK = gameTime + 10.0f;
			FPLAYER_LIST = "0";
			FPLAYER_LIST = GetActivePlayers();
			FPLAYER_LIST = SortEntities(FPLAYER_LIST, "range");
			FOLLOW_PLR_ID = GetToken(FPLAYER_LIST, 0);
		}

		if (RangeTo(FOLLOW_PLR_ID) > 200.0f)
			SetMoveAnim(ANIM_RUN);
		else
			SetMoveAnim(ANIM_WALK);

		if (!WAIT_MODE)
		{
			if (RangeTo(FOLLOW_PLR_ID) > 42.0f)
			{
				SetMoveDest(FOLLOW_PLR_ID, FOLLOW_PLR_DIST);
			}
			else
			{
				// give him some room
				SetMoveDest(FOLLOW_PLR_ID, 64, "flee");
			}
		}

		if (WAIT_MODE)
			SetMoveDest(WAIT_POINT, 32);

		if (!(gameTime > NEXT_SORCJUMP))
			return;

		DebugPrint("jumprange " + SORC_MAX_JUMP_RANGE + " " + ANIM_SORCJUMP);

		if (!(RangeTo(FOLLOW_PLR_ID) < SORC_MAX_JUMP_RANGE))
			return;

		float myZ = OriginOf(ENT_ME).z;
		float targZ = OriginOf(FOLLOW_PLR_ID).z - 38.0f; // compensate for origin center

		float zDiff = targZ - myZ;

		if (zDiff > ATTACK_RANGE)
		{
			OnSorcHopFriendly(zDiff);
			bool exitSub = true;
			NEXT_SORCJUMP = gameTime + FREQ_SORCJUMP;
		}
	}

	// game_damaged
	string BaseSorcFriendly_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return result;
		NEXT_REGEN = GameTime() + 20.0f;
		return result;
	}

	// bfsorc_follow_close
	void BaseSorcFriendly_OnBfsorcFollowClose()
	{
		FOLLOW_PLR_DIST = 60;
	}

	// bfsorc_follow_normal
	void BaseSorcFriendly_OnBfsorcFollowNormal()
	{
		FOLLOW_PLR_DIST = 128;
	}

	// sorc_hop_friendly
	// <vertical_difference> - determines jump strength
	void BaseSorcFriendly_OnSorcHopFriendly(float verticalDifference = 0.0f)
	{
		PlaySound(0, 10, "monsters/orc/attack1.wav");
		UP_SORCJUMP_STR = verticalDifference;
		if (UP_SORCJUMP_STR > 100.0f)
			CallEventDelayed(0.5f, "push_forward");
		UP_SORCJUMP_STR *= 5.0f;
		OnNpcatkSuspendAi("1.0");
		FWD_JUMP_STR = RangeTo(FOLLOW_PLR_ID);
		PlayAnim("critical", ANIM_SORCJUMP);
		CallEventDelayed(0.1f, "sorc_jump_boost");
	}

	// push_forward
	void BaseSorcFriendly_OnPushForward()
	{
		SetMoveDest(FOLLOW_PLR_ID, 9999);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 110, 0)));
		float myZ = OriginOf(ENT_ME).z;
		float groundPos = GroundHeight(MyOrigin());
		myZ -= groundPos;
		if (!(myZ > 20.0f))
			return;
		CallEventDelayed(0.1f, "push_forward");
	}

	// fsorc_wait
	void BaseSorcFriendly_OnFsorcWait(Vector3 waitPosition = Vector3())
	{
		WAIT_MODE = true;
		WAIT_POINT = waitPosition;
	}

	// fsorc_unwait
	void BaseSorcFriendly_OnFsorcUnwait()
	{
		WAIT_MODE = false;
	}

	// game_damaged_other
	string BaseSorcFriendly_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		FSORC_DMG_POINTS += damage;
		if (FSORC_DMG_POINTS > 10000.0f) // case overflows
			FSORC_DMG_POINTS = 10000.0f;
		return result;
	}

	// game_damaged
	string BaseSorcFriendly_OnGameDamaged_2(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (attacker is SBOSS_ID)
			FSORC_HIT_BY_BOSS = true;
		if (RangeTo(SBOSS_ID) < 256.0f) // in case immune to lightning prevents this registering
			FSORC_HIT_BY_BOSS = true;
		return result;
	}

	// fsorc_zombie_alert
	void BaseSorcFriendly_OnFsorcZombieAlert(CBaseEntity@ zombie = null)
	{
		SetMoveAnim(ANIM_RUN);
		@ZOMBIE_ID = zombie;
		OnNpcatkSettarget(EntityId(ZOMBIE_ID));
		NPCATK_TARGET = EntityId(ZOMBIE_ID);
		SetMoveDest(@ZOMBIE_ID, 64);
	}

	// ext_shadowform_boss
	void BaseSorcFriendly_OnExtShadowformBoss()
	{
		@SBOSS_ID = FindByName("shadowform_boss");
		SBOSS_ORG = OriginOf("L_SBOSS_ID");
	}

	// fsorc_move_tele
	void BaseSorcFriendly_OnFsorcMoveTele()
	{
		BFSORC_MOVE_TELE = true;
	}

	// fsorc_did_tele
	void BaseSorcFriendly_OnFsorcDidTele()
	{
		BFSORC_DID_TELE = true;
		BFSORC_MOVE_TELE = false;
		CallEventDelayed(1.0f, "fsorc_unwait");
	}

	// got_team_alert
	void BaseSorcFriendly_OnGotTeamAlert()
	{
		if (WAIT_MODE)
			return;
		if (NPCATK_TARGET != "unset")
			return;
		OnNpcatkSettarget(NPCATK_TARGET);
	}

	// do_team_alert
	void BaseSorcFriendly_OnDoTeamAlert()
	{
		@T_SHAMAN_ID = FindByName("fsorc_shaman");
		@T_LEADER_ID = FindByName("fsorc_leader");
		@T_SECOND_ID = FindByName("fsorc_second");
		if (IsAlive(T_SHAMAN_ID) && T_SHAMAN_ID !is self)
			CallExternal(T_SHAMAN_ID, "got_team_alert", NPCATK_TARGET);
		if (IsAlive(T_LEADER_ID) && T_LEADER_ID !is self)
			CallExternal(T_LEADER_ID, "got_team_alert", NPCATK_TARGET);
		if (IsAlive(T_SECOND_ID) && T_SECOND_ID !is self)
			CallExternal(T_SECOND_ID, "got_team_alert", NPCATK_TARGET);
	}

	// fsorc_friendly_stuck_check
	void BaseSorcFriendly_OnFsorcFriendlyStuckCheck()
	{
		bool exitSub = false;
		// for navigating towards wait targets / players
		Vector3 myOrg = OriginOf(ENT_ME);
		string myDest = Eval("game.monster.movedest.origin");
		float curDist = Distance(myOrg, Vec(myDest));
		if (!(curDist >= Float(Eval("game.monster.movedest.prox"))))
			return;
		if (curDist >= OLD_DIST)
		{
			if (OLD_DIST != 0)
				F_STUCK_COUNT += 1.0f;
		}
		else
		{
			F_STUCK_COUNT = 0.0f;
			F_AS_UNSTUCK_ANG = Random(-15, 15);
			OLD_DIST = 0;
			exitSub = true;
		}
		if (exitSub)
			return;
		OLD_DIST = int(curDist);

		if (F_STUCK_COUNT > 1.0f)
		{
			DebugPrint("fsorc_friendly_stuck_check (no_progress)");
			string moveDest = Text(myOrg);
			OnNpcatkSuspendAi(Text(Random(0.5f, 1)));
			F_AS_UNSTUCK_ANG += 36.0f;
			if (F_AS_UNSTUCK_ANG > 359.0f)
				F_AS_UNSTUCK_ANG = 0.0f;
			float myYaw = AnglesOf(ENT_ME).y + F_AS_UNSTUCK_ANG;
			if (myYaw > 359.0f)
				myYaw = 0.0f;
			moveDest = Text(Vec(moveDest) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 200, 0)));
			SetMoveDest(moveDest, 1);
			F_STUCK_COUNT = 0.0f;
		}
	}

	// ext_boss_dead
	void BaseSorcFriendly_OnExtBossDead()
	{
		REWARD_MODE = true;
		FOLLOW_PLR_DIST = 9999;
		SetMenuAutoOpen(true);
	}

	// reward_test
	void BaseSorcFriendly_OnRewardTest()
	{
		FSORC_HIT_BY_BOSS = true;
		FSORC_DMG_POINTS = 99999.0f;
		OnExtBossDead();
	}

	// game_menu_getoptions
	void BaseSorcFriendly_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		if (!REWARD_MODE)
			return;

		if (FSORC_DMG_POINTS < (FSORC_DMG_REQ ? 1.0f : 0.0f))
			AM_HUMILIATED = true;
		if (!FSORC_HIT_BY_BOSS)
			AM_HUMILIATED = true;

		if (AM_HUMILIATED)
		{
			menuItem.title = "Humiliated";
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
			OnChatNow("Seeing my humiliation, being saved by humans, without my having lifted a finger to save myself, should be payment enough.", "3.0", "neigh", "add_to_que");
			CallEventDelayed(6.0f, "ready_to_go");
		}

		if (AM_HUMILIATED)
			return;

		if (!SETUP_QUALIFICATIONS)
		{
			SETUP_QUALIFICATIONS = true;
			OnCheckQualify();
		}
		string userPtsText = ScriptVarOf(player, "PLR_TOTAL_DMG");
		int userPts = Int(userPtsText);
		USER_QUALIFIES = false;
		if (userPts >= TC_HALF_AVG_DMG_PTS)
			USER_QUALIFIES = true;
		DebugPrint("check_qualify req: " + Text(TC_HALF_AVG_DMG_PTS) + " has " + userPtsText + " [ " + Text(USER_QUALIFIES) + " ]");

		if (USER_QUALIFIES)
			OnGiveRewardOptions(player);
		else
			OnChatNow("I would reward you, but I find your performance as a warrior, wanting.", "3.0", "neigh", "add_to_que");
	}

	// check_qualify
	void BaseSorcFriendly_OnCheckQualify()
	{
		TC_QUAL_PLAYERS = false;
		TC_QUAL_PLAYERS = Truthy(GetActivePlayers());
		int count = GetTokenCount(Text(TC_QUAL_PLAYERS));
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTcGetAverages();
		}
		TC_AVG_DMG_PTS = Divide(TC_AVG_DMG_PTS, PlayerCount());
		TC_HALF_AVG_DMG_PTS = TC_AVG_DMG_PTS * 0.5f;
	}

	// tc_get_averages
	void BaseSorcFriendly_OnTcGetAverages()
	{
		string curPlayer = GetToken(Text(TC_QUAL_PLAYERS), loopIteration);
		TC_AVG_DMG_PTS += Float(ScriptVarOf(curPlayer, "PLR_TOTAL_DMG"));
	}

	// ready_to_go
	void BaseSorcFriendly_OnReadyToGo()
	{
		SetMenuAutoOpen(false);
		REWARD_MODE = false;
		OnReadyToGoComment();
		CallEventDelayed(FSORC_TELE_HOME_DELAY, "tele_home");
	}

	// tele_home
	void BaseSorcFriendly_OnTeleHome()
	{
		float repulseAoe = Float(Eval("game.monster.moveprox"));
		repulseAoe *= 1.5f;
		SORC_FINAL_TELEDEST = Text(OriginOf(ENT_ME));
		ClientEvent("new", "all", "effects/sfx_repulse_burst", SORC_FINAL_TELEDEST, repulseAoe, 1.0f);
		OnNpcatkSuspendAi();
		DeleteEntity(ENT_ME, "fade");
	}

	// ready_to_go_comment
	void BaseSorcFriendly_OnReadyToGoComment()
	{
		@T_SHAMAN_ID = FindByName("fsorc_shaman");
		@T_LEADER_ID = FindByName("fsorc_leader");
		@T_SECOND_ID = FindByName("fsorc_second");
		FSORC_TELE_HOME_DELAY = 3.0f;
		if (T_SHAMAN_ID is self)
		{
			FSORC_TELE_HOME_DELAY = 7.0f;
			OnChatNow("With the beast slain dead, we may now return home...", "3.0", "add_to_que");
			OnChatNow("Maybe the Great Father Torkalath was wrong to forsake your kind.", "3.0", "warcry", "add_to_que");
		}
		if (T_LEADER_ID is self)
			OnChatNow("The tale of your bravery shall not go untold among the Shadahar.", "3.0", "warcry", "add_to_que");

		if (T_SECOND_ID is self)
			OnChatNow("Thank you, once more, mighty warriors.", "3.0", "warcry", "add_to_que");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnExtFsorcInit() { BaseSorcFriendly_OnExtFsorcInit(); } // ext_fsorc_init
	void OnNpcPostSpawn() { BaseSorcFriendly_OnNpcPostSpawn(); } // npc_post_spawn
	void OnFixStepSize() { BaseSorcFriendly_OnFixStepSize(); } // fix_step_size
	void OnNpcatkHunt() { BaseSorcFriendly_OnNpcatkHunt(); } // npcatk_hunt

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseSorcFriendly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseSorcFriendly_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnBfsorcFollowClose() { BaseSorcFriendly_OnBfsorcFollowClose(); } // bfsorc_follow_close
	void OnBfsorcFollowNormal() { BaseSorcFriendly_OnBfsorcFollowNormal(); } // bfsorc_follow_normal
	void OnSorcHopFriendly(float verticalDifference = 0.0f) { BaseSorcFriendly_OnSorcHopFriendly(verticalDifference); } // sorc_hop_friendly
	void OnPushForward() { BaseSorcFriendly_OnPushForward(); } // push_forward
	void OnFsorcWait(Vector3 waitPosition = Vector3()) { BaseSorcFriendly_OnFsorcWait(waitPosition); } // fsorc_wait
	void OnFsorcUnwait() { BaseSorcFriendly_OnFsorcUnwait(); } // fsorc_unwait
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BaseSorcFriendly_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	void OnFsorcZombieAlert(CBaseEntity@ zombie = null) { BaseSorcFriendly_OnFsorcZombieAlert(zombie); } // fsorc_zombie_alert
	void OnExtShadowformBoss() { BaseSorcFriendly_OnExtShadowformBoss(); } // ext_shadowform_boss
	void OnFsorcMoveTele() { BaseSorcFriendly_OnFsorcMoveTele(); } // fsorc_move_tele
	void OnFsorcDidTele() { BaseSorcFriendly_OnFsorcDidTele(); } // fsorc_did_tele
	void OnGotTeamAlert() { BaseSorcFriendly_OnGotTeamAlert(); } // got_team_alert
	void OnDoTeamAlert() { BaseSorcFriendly_OnDoTeamAlert(); } // do_team_alert
	void OnFsorcFriendlyStuckCheck() { BaseSorcFriendly_OnFsorcFriendlyStuckCheck(); } // fsorc_friendly_stuck_check
	void OnExtBossDead() { BaseSorcFriendly_OnExtBossDead(); } // ext_boss_dead
	void OnRewardTest() { BaseSorcFriendly_OnRewardTest(); } // reward_test
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseSorcFriendly_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnCheckQualify() { BaseSorcFriendly_OnCheckQualify(); } // check_qualify
	void OnTcGetAverages() { BaseSorcFriendly_OnTcGetAverages(); } // tc_get_averages
	void OnReadyToGo() { BaseSorcFriendly_OnReadyToGo(); } // ready_to_go
	void OnTeleHome() { BaseSorcFriendly_OnTeleHome(); } // tele_home
	void OnReadyToGoComment() { BaseSorcFriendly_OnReadyToGoComment(); } // ready_to_go_comment
	void OnFsorcTeleHomeDelay() {} // FSORC_TELE_HOME_DELAY
	void OnChatNow(string text = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "", string sound4 = "") {} // chat_now
	void OnGiveRewardOptions(CBaseEntity@ player = null) {} // give_reward_options
	void OnNpcatkSettarget(string target = "", string debug = "") {} // npcatk_settarget
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool BaseSorcFriendly_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bfsorc_follow_close") { OnBfsorcFollowClose(); return true; }
		if (name == "bfsorc_follow_normal") { OnBfsorcFollowNormal(); return true; }
		if (name == "check_qualify") { OnCheckQualify(); return true; }
		if (name == "do_team_alert") { OnDoTeamAlert(); return true; }
		if (name == "ext_boss_dead") { OnExtBossDead(); return true; }
		if (name == "ext_fsorc_init") { OnExtFsorcInit(); return true; }
		if (name == "ext_shadowform_boss") { OnExtShadowformBoss(); return true; }
		if (name == "fix_step_size") { OnFixStepSize(); return true; }
		if (name == "fsorc_did_tele") { OnFsorcDidTele(); return true; }
		if (name == "fsorc_friendly_stuck_check") { OnFsorcFriendlyStuckCheck(); return true; }
		if (name == "fsorc_move_tele") { OnFsorcMoveTele(); return true; }
		if (name == "fsorc_unwait") { OnFsorcUnwait(); return true; }
		if (name == "fsorc_wait") { OnFsorcWait(Vec(Param(params, 0))); return true; }
		if (name == "fsorc_zombie_alert") { OnFsorcZombieAlert(EntityParam(params, 0)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "got_team_alert") { OnGotTeamAlert(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "ready_to_go") { OnReadyToGo(); return true; }
		if (name == "ready_to_go_comment") { OnReadyToGoComment(); return true; }
		if (name == "reward_test") { OnRewardTest(); return true; }
		if (name == "sorc_hop_friendly") { OnSorcHopFriendly(Float(Param(params, 0))); return true; }
		if (name == "tc_get_averages") { OnTcGetAverages(); return true; }
		if (name == "tele_home") { OnTeleHome(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "bloodshrine/base_sorc_friendly"]
shared class BaseSorcFriendlyScript : ScriptEntity, BaseSorcFriendly
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
	bool AM_ESCORT = false;
	bool AM_FLANKING = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_KICK = "ANIM_KICK";
	string ANIM_KNEEL = "ANIM_KNEEL";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_SORCJUMP = "ANIM_SORCJUMP";
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
	string ATTACK_ACCURACY = "ATTACK_ACCURACY";
	int ATTACK_ANIMINDEX = 0;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
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
	bool CALLED_HELP = false;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CHASE_RANGE = "CHASE_RANGE";
	bool CHAT_ABORT = false;
	string CHAT_ANIMS_ANAME = "CHAT_ANIMS_ANAME";
	bool CHAT_AUTO_FACE = false;
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_AUTO_JOB = false;
	bool CHAT_AUTO_RUMOR = false;
	bool CHAT_BUSY = false;
	string CHAT_CONV_ANIMS = "CHAT_CONV_ANIMS";
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAYS_ANAME = "CHAT_DELAYS_ANAME";
	float CHAT_END_MOVE_MOUTH = 0.0f;
	float CHAT_END_TIME = 0.0f;
	string CHAT_EVENTS_ANAME = "CHAT_EVENTS_ANAME";
	bool CHAT_FACE_ON_USE = false;
	bool CHAT_IGNORE_WHILE_BUSY = false;
	CBasePlayer@ CHAT_LAST_USED_MENU = null;
	string CHAT_LINES_ANAME = "CHAT_LINES_ANAME";
	int CHAT_MAX_LINE_LEN = 0;
	bool CHAT_MENU_ENABLE = false;
	bool CHAT_MENU_ON = false;
	bool CHAT_MOVE_MOUTH = false;
	bool CHAT_NEVER_INTERRUPT = false;
	bool CHAT_NO_CLOSE_MOUTH = false;
	string CHAT_PLAYANIM_STYLE = "CHAT_PLAYANIM_STYLE";
	bool CHAT_QUE_ACTIVE = false;
	bool CHAT_RESET_ON_NEW = false;
	string CHAT_SEQUENCE = "CHAT_SEQUENCE";
	string CHAT_SOUNDS_ANAME = "CHAT_SOUNDS_ANAME";
	float CHAT_SPOOL_OUT_ALL_COUNT = 0.0f;
	float CHAT_SPOOL_OUT_COUNT = 0.0f;
	bool CHAT_USE_BUSY_MESSAGE = false;
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHICKEN_RUN = false;
	CBaseEntity@ CHIEF_ID = null;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool CYCLED_UP = false;
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
	float CYCLE_TIME_NPC = 0.0f;
	int DEF_STEP_SIZE = 0;
	bool DEMON_BLOOD = false;
	bool DID_HELP_TIP = false;
	bool DID_SPOT_SPEECH = false;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	string DUMP_CONVO = "DUMP_CONVO";
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
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	float FLINCH_HEALTH = 0.0f;
	bool FREEZE_WAS_SUSPEND = false;
	float FREQ_SORCJUMP = 0.0f;
	float FREQ_TELE = 0.0f;
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
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = false;
	bool HAS_INCLUDE_NPC = false;
	bool HAVE_TARGET = false;
	bool HEARD_PLAYER = false;
	bool HEARD_VERIFY = false;
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	bool HIT_BY_MANABALL = false;
	bool HUNTING_PLAYER = false;
	string HUNT_AGRO = "HUNT_AGRO";
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
	bool KNEEL_MODE = false;
	string LAST_ENEMY = "LAST_ENEMY";
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MAX_ADV_SEARCHTIME = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	bool NEW_AI = false;
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool NO_CLOSE_MOUTH = false;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool NO_STEP_ADJ = false;
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
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
	int NPC_CHASE_RANGE = 0;
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
	string NPC_RANGED = "NPC_RANGED";
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
	bool ORC_JUMPER = false;
	int ORC_JUMP_CUTOFF = 0;
	int ORC_JUMP_POWER = 0;
	int ORC_JUMP_RANGE = 0;
	float ORIG_MOVERANGE = 0.0f;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYER_LIST = "PLAYER_LIST";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	int SORC_CUR_TELE_IDX = 0;
	float SORC_LRESIST = 0.0f;
	int SORC_MAX_JUMP_RANGE = 0;
	bool SORC_NO_TELE = false;
	float SORC_PRESIST = 0.0f;
	string SORC_REPULSE_TARGETS = "SORC_REPULSE_TARGETS";
	string SORC_SCAN_BEST_DIST = "SORC_SCAN_BEST_DIST";
	int SORC_SCAN_BEST_IDX = 0;
	string SORC_SCAN_BEST_SET = "SORC_SCAN_BEST_SET";
	int SORC_SCAN_IDX = 0;
	string SORC_SCAN_SET = "SORC_SCAN_SET";
	bool SORC_SUPERJUMP = false;
	bool SORC_TELEPORTS = false;
	bool SORC_TELE_CYCLE_ON = false;
	string SORC_TELE_ORG = "SORC_TELE_ORG";
	string SORC_TELE_SET1 = "SORC_TELE_SET1";
	string SORC_TELE_SET2 = "SORC_TELE_SET2";
	string SORC_TELE_SET3 = "SORC_TELE_SET3";
	int SORC_TELE_SETS = 0;
	string SOUND_ATTACK1 = "SOUND_ATTACK1";
	string SOUND_ATTACK2 = "SOUND_ATTACK2";
	string SOUND_ATTACK3 = "SOUND_ATTACK3";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_HELP = "SOUND_HELP";
	string SOUND_HIT = "SOUND_HIT";
	string SOUND_HIT2 = "SOUND_HIT2";
	string SOUND_HIT3 = "SOUND_HIT3";
	string SOUND_PAIN = "SOUND_PAIN";
	string SOUND_SHOCK1 = "SOUND_SHOCK1";
	string SOUND_SHOCK2 = "SOUND_SHOCK2";
	string SOUND_SHOCK3 = "SOUND_SHOCK3";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";
	string SOUND_WARCRY1 = "SOUND_WARCRY1";
	string SOUND_ZOMB_ALERT1 = "SOUND_ZOMB_ALERT1";
	string SOUND_ZOMB_ALERT2 = "SOUND_ZOMB_ALERT2";
	string SOUND_ZOMB_ALERT3 = "SOUND_ZOMB_ALERT3";
	string SOUND_ZOMB_ATK1 = "SOUND_ZOMB_ATK1";
	string SOUND_ZOMB_ATK2 = "SOUND_ZOMB_ATK2";
	string SOUND_ZOMB_ATK3 = "SOUND_ZOMB_ATK3";
	string SOUND_ZOMB_STRUCK1 = "SOUND_ZOMB_STRUCK1";
	string SOUND_ZOMB_STRUCK2 = "SOUND_ZOMB_STRUCK2";
	string SOUND_ZOMB_STRUCK3 = "SOUND_ZOMB_STRUCK3";
	string SPAWN_SPEECH = "SPAWN_SPEECH";
	float SPAWN_SPEECH_DELAY = 0.0f;
	string SPOT_SPEECH = "SPOT_SPEECH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	bool SUSPEND_AI = false;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseSorcFriendly_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseSorcFriendly_DispatchEvent(name, params);
	}
}
