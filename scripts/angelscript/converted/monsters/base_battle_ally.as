#pragma context server

// Converted from monsters/base_battle_ally.script by msc_transpiler.
// base ally system
// - for allies that follow players about and operate as combatants
// - setvard ALLY_FOLLOW_ON 0|1 to toggle follow mode
// - use callevent set_leader 1 to create a "leader" NPC, that goes where the player is facing, instead of tagging behind (kinda experimental).
// - Assumes base AI is included above it
// - todo: integrate teleport catch-up system as option
// - todo: rig up non-combatant option (follows, does not engage, attempts to flee if attacked.)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseBattleAlly
{
	// Constants
	bool NPC_FIGHTS_NPCS = true;
	string AI_NO_TARGET_STRING = "unset";
	int ALLY_MIN_DISTANCE = 42;
	int ALLY_FOLLOW_CLOSE_DIST = 60;
	int ALLY_FOLLOW_NORM_DIST = 128;
	int ALLY_MOVE_AWAY_DIST = 64;
	float ALLY_REGEN_RATIO = 0.1f;
	int ALLY_MAX_JUMP_RANGE = 600;
	float FREQ_ALLYJUMP = 0.0f;
	string ANIM_ALLY_JUMP = "jump";
	string SOUND_ALLY_JUMP = "monsters/orc/attack1.wav";
	int ALLY_JUMP_THRESHOLD = 150;

	// Variables (an unset .script variable reads as its own name)
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_BATTLE_ALLY = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	int ALLY_FOLLOW_PLR_DIST = 0;
	float ALLY_STUCK_COUNT = 0.0f;
	float ALLY_AS_UNSTUCK_ANG = 0.0f;
	string CYCLE_TIME = "CYCLE_TIME";
	float ALLY_NEXT_FAS_CHECK = 0.0f;
	float ALLY_NEXT_REGEN = 0.0f;
	float ALLY_NEXT_FOLLOW_CHECK = 0.0f;
	string ALLY_FPLAYER_LIST = "ALLY_FPLAYER_LIST";
	string ALLY_FOLLOW_PLR_ID = "ALLY_FOLLOW_PLR_ID";
	float NEXT_ALLYJUMP = 0.0f;
	float ALLY_NEXT_LEADER_UPDATE = 0.0f;
	string ALLY_LEADER_DEST = "ALLY_LEADER_DEST";
	float ALLY_JUMP_STR = 0.0f;
	float ALLY_FWD_JUMP_STR = 0.0f;
	int ALLY_OLD_DIST = 0;
	bool ALLY_IS_LEADER = false;
	bool ALLY_FOLLOW_ON = false;

	// unnamed block (first think)
	void BaseBattleAlly_FirstThink()
	{
		NPC_NO_PLAYER_DMG = true;
		NPC_BATTLE_ALLY = true;

		SetSayTextRange(2048);

		NO_STUCK_CHECKS = "1";

		NPC_ALLY_RESPONSE_RANGE = 4096.0f; // maximize ally alert range (keeps multiple allies in sync on targets)
		ALLY_FOLLOW_PLR_DIST = 128;

		// seperate stuck system for following players
		ALLY_STUCK_COUNT = 0.0f;
		ALLY_AS_UNSTUCK_ANG = 0.0f;
	}

	// npcatk_hunt
	void BaseBattleAlly_OnNpcatkHunt()
	{
		bool findNewFollow = false;
		Vector3 org = Vec("L_ORG");
		if (SUSPEND_AI)
			return;
		if (!ALLY_FOLLOW_ON)
			return;
		// dbg ALLY_FOLLOW_ON - $get(ALLY_FOLLOW_PLR_ID,name)
		float gameTime = GameTime();
		CYCLE_TIME = "0.1";

		// follow players while target unset
		if (NPCATK_TARGET != AI_NO_TARGET_STRING)
			return;

		if (gameTime > ALLY_NEXT_FAS_CHECK && IsAlive(ALLY_FOLLOW_PLR_ID))
		{
			ALLY_NEXT_FAS_CHECK = gameTime + 0.5f;
			OnAllyStuckCheck();
		}

		// ally auto-regen
		if (gameTime > ALLY_NEXT_REGEN && HealthOf(ENT_ME) < MaxHealthOf(ENT_ME))
		{
			float allyRegenAmt = MaxHealthOf(ENT_ME) * ALLY_REGEN_RATIO;
			GiveHealth(ENT_ME, allyRegenAmt);
			ALLY_NEXT_REGEN = gameTime + 1.0f;
		}
		if (SUSPEND_AI) // incase Anti-stuck triggered AI suspend
			return;

		// pick player to follow
		if (!(PlayerCount() > 0))
			return;

		if (gameTime > ALLY_NEXT_FOLLOW_CHECK)
			findNewFollow = true;
		if (!IsAlive(ALLY_FOLLOW_PLR_ID))
			findNewFollow = true;

		if (findNewFollow && ActivePlayerCount() > 0)
		{
			ALLY_NEXT_FOLLOW_CHECK = gameTime + 10.0f;
			ALLY_FPLAYER_LIST = "0";
			ALLY_FPLAYER_LIST = GetActivePlayers();
			ALLY_FPLAYER_LIST = SortEntities(ALLY_FPLAYER_LIST, "range");
			ALLY_FOLLOW_PLR_ID = GetToken(ALLY_FPLAYER_LIST, 0);
		}

		if (!IsAlive(ALLY_FOLLOW_PLR_ID))
			return;

		float allyRange = RangeTo(ALLY_FOLLOW_PLR_ID);
		string allyOrg = Text(OriginOf(ALLY_FOLLOW_PLR_ID));
		int allyRunRange = 200;
		if (ALLY_IS_LEADER)
		{
			org = OriginOf(ENT_ME);
			allyRange = Distance(org, Vec(ALLY_LEADER_DEST));
			allyOrg = ALLY_LEADER_DEST;
			allyRunRange = 64;
		}

		// jump to players if need be
		if (gameTime > NEXT_ALLYJUMP && allyRange < ALLY_MAX_JUMP_RANGE)
		{
			float myZ = OriginOf(ENT_ME).z;
			float targZ = Vec(allyOrg).z;
			if (!ALLY_IS_LEADER) // compensate for origin center (leaders are aiming for dest, so they dont do this)
				targZ -= 38.0f;

			float zDiff = targZ;
			string zDiffText;
			zDiff -= myZ;

			// dbg jump_check alv $get(ALLY_FOLLOW_PLR_ID,isalive) rng $get(ALLY_FOLLOW_PLR_ID,range) zdf Z_DIFF
			if (zDiff > ALLY_JUMP_THRESHOLD)
			{
				OnAllyHop(zDiff);
				NEXT_ALLYJUMP = gameTime + FREQ_ALLYJUMP;
			}
		}

		if (allyRange > allyRunRange)
			SetMoveAnim(ANIM_RUN);
		else
			SetMoveAnim(ANIM_WALK);

		if (RangeTo(ALLY_FOLLOW_PLR_ID) > ALLY_MIN_DISTANCE)
		{
			// if game.time > ALLY_NEXT_FLEE //sec here, trying to get out of the players way //give me a bit of time to move (not working, also nerfs the function a bit)
			if (!ALLY_IS_LEADER)
			{
				SetMoveDest(ALLY_FOLLOW_PLR_ID, ALLY_FOLLOW_PLR_DIST);
			}
			else
			{
				// leader's move to where their target player is facing
				if (GameTime() > ALLY_NEXT_LEADER_UPDATE)
				{
					ALLY_NEXT_LEADER_UPDATE = GameTime() + 0.5f;
					Vector3 moveDest = OriginOf(ALLY_FOLLOW_PLR_ID);
					string traceStart = Text(moveDest);
					Vector3 plrView = ViewAnglesOf(ALLY_FOLLOW_PLR_ID);
					moveDest += RelativePosition(plrView, Vector3(0, 640, 0));
					moveDest = Vec(LegacyFunction("get_traceline", traceStart, moveDest, "worldonly"));
					moveDest.z = GroundHeight(moveDest);
					float myWidth = WidthOf(ENT_ME);
					SetMoveDest(moveDest, myWidth);

					ALLY_LEADER_DEST = Text(moveDest);

					// dbg leader L_MOVE_DEST
					org = OriginOf(ENT_ME);
					if (Distance(moveDest, org) <= myWidth)
						SetAngle("face.y", plrView.y);

					if (Truthy(GetVar("G_DEVELOPER_MODE")))
					{
						string beamZ = Text(moveDest);
						beamZ = Text(Vec(beamZ) + Vector3(0.0f, 0.0f, 32.0f));
						Effect("beam", "point", "lgtning.spr", 20, moveDest, beamZ, Vector3(255, 0, 255), 200, 0, 0.2f);
					}
				}
			}
		}
		else
		{
			// give him some room
			SetMoveDest(ALLY_FOLLOW_PLR_ID, ALLY_MOVE_AWAY_DIST, "flee");
		}
	}

	// game_damaged
	string BaseBattleAlly_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return result;
		ALLY_NEXT_REGEN = GameTime() + 20.0f;
		return result;
	}

	// ally_follow_close
	void BaseBattleAlly_OnAllyFollowClose()
	{
		ALLY_FOLLOW_PLR_DIST = ALLY_FOLLOW_CLOSE_DIST;
	}

	// ally_follow_normal
	void BaseBattleAlly_OnAllyFollowNormal()
	{
		ALLY_FOLLOW_PLR_DIST = ALLY_FOLLOW_NORM_DIST;
	}

	// ally_hop
	// <vertical_difference> - determines jump strength
	void BaseBattleAlly_OnAllyHop(float verticalDifference = 0.0f)
	{
		DebugPrint("ally_hop");
		PlaySound(0, 10, SOUND_ALLY_JUMP);
		ALLY_JUMP_STR = verticalDifference;
		if (ALLY_JUMP_STR > 100.0f)
			CallEventDelayed(0.5f, "ally_push_forward");
		ALLY_JUMP_STR *= 5.0f;
		OnNpcatkSuspendAi("1.0");
		if (!ALLY_IS_LEADER)
		{
			ALLY_FWD_JUMP_STR = RangeTo(ALLY_FOLLOW_PLR_ID);
		}
		else
		{
			Vector3 org = OriginOf(ENT_ME);
			ALLY_FWD_JUMP_STR = Distance(org, Vec(ALLY_LEADER_DEST));
			DebugPrint("ally_hop fwd " + Text(ALLY_FWD_JUMP_STR));
		}
		PlayAnim("critical", ANIM_ALLY_JUMP);
		CallEventDelayed(0.1f, "ally_jump_boost");
	}

	// ally_jump_boost
	void BaseBattleAlly_OnAllyJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, ALLY_FWD_JUMP_STR, ALLY_JUMP_STR)));
	}

	// ally_push_forward
	void BaseBattleAlly_OnAllyPushForward()
	{
		if (!ALLY_IS_LEADER)
			SetMoveDest(ALLY_FOLLOW_PLR_ID, 9999);
		else
			SetMoveDest(ALLY_LEADER_DEST, 9999);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 110, 0)));
		float myZ = OriginOf(ENT_ME).z;
		float groundPos = GroundHeight(MyOrigin());
		myZ -= groundPos;
		if (!(myZ > 20.0f))
			return;
		CallEventDelayed(0.1f, "ally_push_forward");
	}

	// ally_stuck_check
	void BaseBattleAlly_OnAllyStuckCheck()
	{
		bool exitSub = false;
		// for navigating towards wait targets / players
		Vector3 myOrg = OriginOf(ENT_ME);
		string myDest = Eval("game.monster.movedest.origin");
		float curDist = Distance(myOrg, Vec(myDest));
		if (!(curDist >= Float(Eval("game.monster.movedest.prox"))))
			return;
		if (curDist >= ALLY_OLD_DIST)
		{
			if (ALLY_OLD_DIST != 0)
				ALLY_STUCK_COUNT += 1.0f;
		}
		else
		{
			ALLY_STUCK_COUNT = 0.0f;
			ALLY_AS_UNSTUCK_ANG = Random(-15, 15);
			ALLY_OLD_DIST = 0;
			exitSub = true;
		}
		if (exitSub)
			return;
		ALLY_OLD_DIST = int(curDist);

		if (ALLY_STUCK_COUNT > 1.0f)
		{
			DebugPrint("fsorc_friendly_stuck_check (no_progress)");
			string moveDest = Text(myOrg);
			OnNpcatkSuspendAi(Text(Random(0.5f, 1)));
			ALLY_AS_UNSTUCK_ANG += 36.0f;
			if (ALLY_AS_UNSTUCK_ANG > 359.0f)
				ALLY_AS_UNSTUCK_ANG = 0.0f;
			float myYaw = AnglesOf(ENT_ME).y + ALLY_AS_UNSTUCK_ANG;
			if (myYaw > 359.0f)
				myYaw = 0.0f;
			moveDest = Text(Vec(moveDest) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 200, 0)));
			SetMoveDest(moveDest, 1);
			ALLY_STUCK_COUNT = 0.0f;
		}
	}

	// set_leader
	// [0|1]
	void BaseBattleAlly_OnSetLeader(int isLeader = 0)
	{
		ALLY_IS_LEADER = true;
		ALLY_FOLLOW_ON = true;
		if (isLeader == 0)
			ALLY_IS_LEADER = false;
	}

	// set_follower
	void BaseBattleAlly_OnSetFollower()
	{
		ALLY_FOLLOW_ON = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcatkHunt() { BaseBattleAlly_OnNpcatkHunt(); } // npcatk_hunt
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnAllyFollowClose() { BaseBattleAlly_OnAllyFollowClose(); } // ally_follow_close
	void OnAllyFollowNormal() { BaseBattleAlly_OnAllyFollowNormal(); } // ally_follow_normal
	void OnAllyHop(float verticalDifference = 0.0f) { BaseBattleAlly_OnAllyHop(verticalDifference); } // ally_hop
	void OnAllyJumpBoost() { BaseBattleAlly_OnAllyJumpBoost(); } // ally_jump_boost
	void OnAllyPushForward() { BaseBattleAlly_OnAllyPushForward(); } // ally_push_forward
	void OnAllyStuckCheck() { BaseBattleAlly_OnAllyStuckCheck(); } // ally_stuck_check
	void OnSetLeader(int isLeader = 0) { BaseBattleAlly_OnSetLeader(isLeader); } // set_leader
	void OnSetFollower() { BaseBattleAlly_OnSetFollower(); } // set_follower
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool BaseBattleAlly_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ally_follow_close") { OnAllyFollowClose(); return true; }
		if (name == "ally_follow_normal") { OnAllyFollowNormal(); return true; }
		if (name == "ally_hop") { OnAllyHop(Float(Param(params, 0))); return true; }
		if (name == "ally_jump_boost") { OnAllyJumpBoost(); return true; }
		if (name == "ally_push_forward") { OnAllyPushForward(); return true; }
		if (name == "ally_stuck_check") { OnAllyStuckCheck(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_follower") { OnSetFollower(); return true; }
		if (name == "set_leader") { OnSetLeader(Int(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_battle_ally"]
shared class BaseBattleAllyScript : ScriptEntity, BaseBattleAlly
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool AM_FLANKING = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_IDLE = "ANIM_IDLE";
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
	float ATTACK_HITRANGE = 0.0f;
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
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CHASE_RANGE = "CHASE_RANGE";
	bool CHICKEN_RUN = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool CYCLED_UP = false;
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
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
	int FLEE_DIR = 0;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	bool FREEZE_WAS_SUSPEND = false;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	bool HAS_AI = false;
	bool HAS_INCLUDE_NPC = false;
	bool HEARD_PLAYER = false;
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
	bool I_R_FROZEN = false;
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool NO_STEP_ADJ = false;
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
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
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
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_GOING_HOME = false;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HEIGHT = 0.0f;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_IGNORE_PLAYERS = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	bool NPC_MADE_IT_HOME = false;
	float NPC_MAXHP = 0.0f;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool NPC_MOVEMENT_SUSPENDED = false;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
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
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETURNING_HOME = false;
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
	float NPC_SPAWN_TIME = 0.0f;
	int NPC_SPRITE_IN = 0;
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	bool NPC_WAS_IN_BATTLE = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	int OLD_NO_STUCK_CHECKS = 0;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_PAIN2 = "SOUND_PAIN2";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	bool SUSPEND_AI = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseBattleAlly_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseBattleAlly_DispatchEvent(name, params);
	}
}
