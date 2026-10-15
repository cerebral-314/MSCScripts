#pragma context server

// Converted from dq/templates/bases/dq_generic_reward.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqGenericReward
{
	// Variables (an unset .script variable reads as its own name)
	bool USING_GENERIC_REWARD = false;
	bool QUEST_REWARD_TAKEN = false;

	// unnamed block (first think)
	void DqGenericReward_FirstThink()
	{
		USING_GENERIC_REWARD = true;

		ArrayCreate("A_QUEST_PARTICIPANTS"); // The A_ stands for array. Jus tryin' out some prefixes to see if it looks more gooder
	}

	// quest_activate
	// Called from dq/quests/bases/dq_base_quests
	void DqGenericReward_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		int count;

		if (QUEST_REWARD_ALL)
		{
			string players = "";
			players = GetActivePlayers();
			count = GetTokenCount(players);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnGetQuestParticipantsLoop(players);
			}
		}
	}

	// quest_taker_updated
	void DqGenericReward_OnQuestTakerUpdated()
	{
		if (!QUEST_REWARD_ALL)
		{
			int arrayAmt = GetArrayCount("A_QUEST_PARTICIPANTS");
			if (arrayAmt > 0)
			{
				for (int i = 0; i < arrayAmt; i++)
				{
					loopIteration = i;
					OnClearArrayLoop();
				}
			}
			OnAddQuestParticipant(EntityId(QUEST_TAKER));
		}
	}

	// quest_complete
	void DqGenericReward_OnQuestComplete(CBasePlayer@ questPlayer = null)
	{
		int playerIdx = ArrayFind("A_QUEST_PARTICIPANTS", EntityId(questPlayer));

		if (playerIdx != -1)
		{
			ArrayRemoveAt("A_QUEST_PARTICIPANTS", playerIdx);

			if (!QUEST_REWARD_ALL)
			{
				if (!QUEST_REWARD_TAKEN)
				{
					QUEST_REWARD_TAKEN = true;
					OnQuestReward(questPlayer);
				}
			}
			else
			{
				OnQuestReward(questPlayer);
			}
		}
	}

	// quest_reward
	// PARAM1 = PlayerID
	void DqGenericReward_OnQuestReward(CBasePlayer@ rewardPlayer = null)
	{
		if (QUEST_REWARD_TYPE == "map")
			UseTrigger(QUEST_REWARD_EVENT);
		else if (QUEST_REWARD_TYPE == "script")
			CallEventOrDelay(QUEST_REWARD_EVENT, @rewardPlayer);
		else if (QUEST_REWARD_TYPE == "gm")
			CallExternal(GetVar("GAME_MASTER"), QUEST_REWARD_EVENT, @rewardPlayer);

		if (GetArrayCount("A_QUEST_PARTICIPANTS") == 0)
		{
			SetMenuAutoOpen(false);
			OnDeleteFadeMe(); // This event is in dq/quests/bases/dq_base_quests
		}
	}

	// game_menu_getoptions
	void DqGenericReward_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (QUEST_MODE == QUEST_COMPLETE)
		{
			if (!QUEST_REWARD_ALL)
			{
				if (!QUEST_REWARD_TAKEN && player is QUEST_TAKER)
					OnBuildQuestCompleteMenu(player);
			}
			else if (ArrayFind("A_QUEST_PARTICIPANTS", "L_PLAYER_ID") != -1) // The A_QUEST_PARTICIPANTS is from dq_base
				OnBuildQuestCompleteMenu(player);
		}
	}

	// get_quest_participants_loop
	// Stock events
	void DqGenericReward_OnGetQuestParticipantsLoop(string participants = "")
	{
		string player = GetToken(participants, loopIteration);
		OnAddQuestParticipant(player);
	}

	// add_quest_participant
	void DqGenericReward_OnAddQuestParticipant(string participant = "")
	{
		ArrayAdd("A_QUEST_PARTICIPANTS", participant);
	}

	// build_quest_complete_menu
	void DqGenericReward_OnBuildQuestCompleteMenu(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = QUEST_COMPLETE_TEXT;
		menuItem.type = "callback";
		menuItem.data = EntityId(player);
		menuItem.callback = "quest_complete";
		RegisterMenuItem(menuItem);
	}

	// clear_array_loop
	void DqGenericReward_OnClearArrayLoop()
	{
		ArrayRemoveAt("A_QUEST_PARTICIPANTS", 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnQuestActivate(CBasePlayer@ menuOwner = null) { DqGenericReward_OnQuestActivate(menuOwner); } // quest_activate
	void OnQuestTakerUpdated() { DqGenericReward_OnQuestTakerUpdated(); } // quest_taker_updated
	void OnQuestComplete(CBasePlayer@ questPlayer = null) { DqGenericReward_OnQuestComplete(questPlayer); } // quest_complete
	void OnQuestReward(CBasePlayer@ rewardPlayer = null) { DqGenericReward_OnQuestReward(rewardPlayer); } // quest_reward
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { DqGenericReward_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnGetQuestParticipantsLoop(string participants = "") { DqGenericReward_OnGetQuestParticipantsLoop(participants); } // get_quest_participants_loop
	void OnAddQuestParticipant(string participant = "") { DqGenericReward_OnAddQuestParticipant(participant); } // add_quest_participant
	void OnBuildQuestCompleteMenu(CBasePlayer@ player = null) { DqGenericReward_OnBuildQuestCompleteMenu(player); } // build_quest_complete_menu
	void OnClearArrayLoop() { DqGenericReward_OnClearArrayLoop(); } // clear_array_loop
	void OnQuestRewardEvent() {} // QUEST_REWARD_EVENT
	void OnDeleteFadeMe() {} // delete_fade_me

	// This file's events and timers by their .script names
	bool DqGenericReward_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_quest_participant") { OnAddQuestParticipant(Param(params, 0)); return true; }
		if (name == "build_quest_complete_menu") { OnBuildQuestCompleteMenu(PlayerParam(params, 0)); return true; }
		if (name == "clear_array_loop") { OnClearArrayLoop(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "get_quest_participants_loop") { OnGetQuestParticipantsLoop(Param(params, 0)); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_complete") { OnQuestComplete(PlayerParam(params, 0)); return true; }
		if (name == "quest_reward") { OnQuestReward(PlayerParam(params, 0)); return true; }
		if (name == "quest_taker_updated") { OnQuestTakerUpdated(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/templates/bases/dq_generic_reward"]
shared class DqGenericRewardScript : ScriptEntity, DqGenericReward
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	string AI_NO_TARGET_STRING = "AI_NO_TARGET_STRING";
	float ALLY_AS_UNSTUCK_ANG = 0.0f;
	int ALLY_FOLLOW_CLOSE_DIST = 0;
	int ALLY_FOLLOW_NORM_DIST = 0;
	bool ALLY_FOLLOW_ON = false;
	int ALLY_FOLLOW_PLR_DIST = 0;
	string ALLY_FOLLOW_PLR_ID = "ALLY_FOLLOW_PLR_ID";
	string ALLY_FPLAYER_LIST = "ALLY_FPLAYER_LIST";
	float ALLY_FWD_JUMP_STR = 0.0f;
	bool ALLY_IS_LEADER = false;
	float ALLY_JUMP_STR = 0.0f;
	int ALLY_JUMP_THRESHOLD = 0;
	string ALLY_LEADER_DEST = "ALLY_LEADER_DEST";
	int ALLY_MAX_JUMP_RANGE = 0;
	int ALLY_MIN_DISTANCE = 0;
	int ALLY_MOVE_AWAY_DIST = 0;
	float ALLY_NEXT_FAS_CHECK = 0.0f;
	float ALLY_NEXT_FOLLOW_CHECK = 0.0f;
	float ALLY_NEXT_LEADER_UPDATE = 0.0f;
	float ALLY_NEXT_REGEN = 0.0f;
	int ALLY_OLD_DIST = 0;
	float ALLY_REGEN_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
	float ALLY_STUCK_COUNT = 0.0f;
	bool AM_FLANKING = false;
	bool AM_INVINCIBLE = false;
	bool AM_SITTING = false;
	string ANIM_ALLY_JUMP = "ANIM_ALLY_JUMP";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_SIT_IDLE = "ANIM_SIT_IDLE";
	string ANIM_SIT_IDLE_CONVO1 = "ANIM_SIT_IDLE_CONVO1";
	string ANIM_SIT_IDLE_CONVO2 = "ANIM_SIT_IDLE_CONVO2";
	string ANIM_SIT_IDLE_NOLANTERN = "ANIM_SIT_IDLE_NOLANTERN";
	string ANIM_SIT_IDLE_WOUNDED = "ANIM_SIT_IDLE_WOUNDED";
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
	string ATTACK2_ACCURACY = "ATTACK2_ACCURACY";
	int ATTACK2_CHANCE = 0;
	string ATTACK2_DAMAGE = "ATTACK2_DAMAGE";
	float ATTACK2_DAMAGE_MULT = 0.0f;
	string ATTACK_ACCURACY = "ATTACK_ACCURACY";
	int ATTACK_ANIMINDEX = 0;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	float ATTACK_DAMAGE_MULT = 0.0f;
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
	string BS_SOUND_STRUCK1 = "BS_SOUND_STRUCK1";
	string BS_SOUND_STRUCK2 = "BS_SOUND_STRUCK2";
	string BS_SOUND_STRUCK3 = "BS_SOUND_STRUCK3";
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
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CUSTOM_LANTERN_COLOR = "CUSTOM_LANTERN_COLOR";
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
	string DUMP_CONVO = "DUMP_CONVO";
	string DWARF_COMVO_ANIMS = "DWARF_COMVO_ANIMS";
	string DWARF_CONVO_ANIMS = "DWARF_CONVO_ANIMS";
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
	float FREQ_ALLYJUMP = 0.0f;
	float FREQ_LANTERNCL_REFRESH = 0.0f;
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
	int HEALTH_MULT = 0;
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
	string INIT_IDLE_MODE = "INIT_IDLE_MODE";
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool IS_FLEEING = false;
	bool IS_HUNTING = false;
	int IS_LEADER = 0;
	CBaseEntity@ I_HEARD = null;
	bool I_R_FROZEN = false;
	bool LANTERN_ACTIVE = false;
	string LANTERN_CL_IDX = "LANTERN_CL_IDX";
	string LANTERN_COLOR = "LANTERN_COLOR";
	bool LANTERN_HAND_INDEX = false;
	int LANTERN_HAND_SUBMODEL = 0;
	bool LANTERN_ON = false;
	bool LANTERN_SET = false;
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MAX_ADV_SEARCHTIME = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	string MONSTER_MODEL = "MONSTER_MODEL";
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	bool NEW_AI = false;
	int NEW_HEIGHT = 0;
	string NEW_NAME = "NEW_NAME";
	string NEW_RACE = "NEW_RACE";
	int NEW_WIDTH = 0;
	float NEXT_ALLYJUMP = 0.0f;
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_DZOMB_FLEE = 0.0f;
	float NEXT_HITFRUST_RECORD = 0.0f;
	float NEXT_LANTERNCL_REFRESH = 0.0f;
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
	float NPC_ATN_FLINCH = 0.0f;
	float NPC_ATN_IDLE = 0.0f;
	float NPC_ATN_PAIN = 0.0f;
	float NPC_ATN_STRUCK = 0.0f;
	bool NPC_ATTACK_MISS = false;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	bool NPC_BATTLE_ALLY = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	float NPC_BS_HALF_HEALTH = 0.0f;
	bool NPC_CANSEE_TARGET = false;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	int NPC_CHASE_RANGE = 0;
	float NPC_CLOSEIN_RANGE = 0.0f;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_COULD_SEE_TARGET = false;
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	string NPC_CUR_MATERIAL_TYPE = "NPC_CUR_MATERIAL_TYPE";
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
	bool NPC_FLINCH_ALLOW_SUSPEND_AI = false;
	bool NPC_FLINCH_ALLOW_SUSPEND_MOVEMENT = false;
	bool NPC_FLINCH_DISABLE_ONCE = false;
	float NPC_FLINCH_THRESH = 0.0f;
	float NPC_FLINCH_TIME = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_FLINCH = 0.0f;
	float NPC_FREQ_IDLE = 0.0f;
	float NPC_FREQ_PAIN = 0.0f;
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
	string NPC_MATERIAL_TYPE = "NPC_MATERIAL_TYPE";
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
	float NPC_NEXT_FLINCH = 0.0f;
	float NPC_NEXT_IDLE = 0.0f;
	float NPC_NEXT_PAIN = 0.0f;
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
	string NPC_PAIN_LEVEL = "NPC_PAIN_LEVEL";
	int NPC_PITCH_FLINCH = 0;
	int NPC_PITCH_IDLE = 0;
	int NPC_PITCH_PAIN = 0;
	int NPC_PITCH_STRUCK = 0;
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
	int NPC_STRUCK_CHANNEL = 0;
	string NPC_STRUCK_SOUND_EVENT = "NPC_STRUCK_SOUND_EVENT";
	int NPC_STRUCK_VOL = 0;
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_USE_FLINCH = false;
	bool NPC_USE_IDLE = false;
	bool NPC_USE_PAIN = false;
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
	CBasePlayer@ OFFER_MENU_ID = null;
	int OLD_NO_STUCK_CHECKS = 0;
	float ORIG_MOVERANGE = 0.0f;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_ACTIVE = "QUEST_ACTIVE";
	int QUEST_ACTIVE_COMBATANT = 0;
	string QUEST_ACTIVE_TEXT = "QUEST_ACTIVE_TEXT";
	string QUEST_ASKING = "QUEST_ASKING";
	string QUEST_ASKING_TEXT = "QUEST_ASKING_TEXT";
	int QUEST_COMBATANT = 0;
	string QUEST_COMPLETE = "QUEST_COMPLETE";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_COMPLETE_TEXT = "QUEST_COMPLETE_TEXT";
	int QUEST_CURRENTLY_COMBATING = 0;
	string QUEST_DATA1 = "QUEST_DATA1";
	bool QUEST_EXPERT_COMBATANT = false;
	string QUEST_FADE_ON_COMPLETE = "QUEST_FADE_ON_COMPLETE";
	string QUEST_FAILED = "QUEST_FAILED";
	string QUEST_FINISHED_CHAT = "QUEST_FINISHED_CHAT";
	string QUEST_FINISHED_SOUND = "QUEST_FINISHED_SOUND";
	int QUEST_FOLLOWER = 0;
	string QUEST_GIVER_NAME = "QUEST_GIVER_NAME";
	string QUEST_INTRO_CHAT = "QUEST_INTRO_CHAT";
	string QUEST_INTRO_SOUND = "QUEST_INTRO_SOUND";
	string QUEST_MODE = "QUEST_MODE";
	bool QUEST_REWARD_ALL = false;
	string QUEST_REWARD_EVENT = "QUEST_REWARD_EVENT";
	string QUEST_REWARD_TYPE = "QUEST_REWARD_TYPE";
	CBasePlayer@ QUEST_TAKER = null;
	float QUEST_TAKER_MAXHP = 0.0f;
	string QUEST_TYPE = "QUEST_TYPE";
	string QUEST_WAITING = "QUEST_WAITING";
	string QUEST_WAITING_TEXT = "QUEST_WAITING_TEXT";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	int SET_SIEGE_MODE = 0;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_ALERT1 = "SOUND_ALERT1";
	string SOUND_ALERT2 = "SOUND_ALERT2";
	string SOUND_ALERT3 = "SOUND_ALERT3";
	string SOUND_ALLY_JUMP = "SOUND_ALLY_JUMP";
	string SOUND_ATTACK1 = "SOUND_ATTACK1";
	string SOUND_ATTACK2 = "SOUND_ATTACK2";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_FLINCH1 = "SOUND_FLINCH1";
	string SOUND_FLINCH2 = "SOUND_FLINCH2";
	string SOUND_FLINCH3 = "SOUND_FLINCH3";
	string SOUND_PAIN = "SOUND_PAIN";
	string SOUND_PAIN1 = "SOUND_PAIN1";
	string SOUND_PAIN2 = "SOUND_PAIN2";
	string SOUND_PAIN3 = "SOUND_PAIN3";
	string SOUND_STRUCK = "SOUND_STRUCK";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	string SUBMODEL_GROUPS = "SUBMODEL_GROUPS";
	bool SUSPEND_AI = false;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";
	bool USE_LANTERN = false;
	string USE_SKIN = "USE_SKIN";
	bool USING_BASE_QUEST = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqGenericReward_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqGenericReward_DispatchEvent(name, params);
	}
}
