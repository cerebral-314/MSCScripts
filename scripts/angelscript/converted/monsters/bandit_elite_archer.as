#pragma context server

// Converted from monsters/bandit_elite_archer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_elite.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditEliteArcher
{
	// Constants
	string WEAPON = "0";
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_elite_archer"]
shared class BanditEliteArcherScript : BanditEliteScript, BanditEliteArcher
{
	// Variables every script that includes this file declares
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
	float ALLY_STUCK_COUNT = 0.0f;
	string ANIM_ALLY_JUMP = "ANIM_ALLY_JUMP";
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
	bool CHAT_TEMP_NO_AUTO_FACE = false;
	bool CHAT_USE_BUSY_MESSAGE = false;
	bool CHAT_USE_CONV_ANIMS = false;
	string DUMP_CONVO = "DUMP_CONVO";
	float FREQ_ALLYJUMP = 0.0f;
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = false;
	bool HOSTILE_MODE = false;
	bool MADE_DEAL = false;
	string MY_SKILL = "MY_SKILL";
	float NEXT_ALLYJUMP = 0.0f;
	bool NPC_BATTLE_ALLY = false;
	Vector3 NPC_HBAR_ADJ = Vector3();
	string NPC_PROXACT_DELAY = "NPC_PROXACT_DELAY";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_FOV = false;
	bool NPC_PROXACT_IFSEEN = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	bool NPC_PROX_ACTIVATE = false;
	bool OVERRIDE_BANDIT_SPAWN = false;
	bool REWARD_MODE = false;
	string SOUND_ALLY_JUMP = "SOUND_ALLY_JUMP";
	float TC_AVG_DMG_PTS = 0.0f;
	float TC_HALF_AVG_DMG_PTS = 0.0f;
	bool TC_QUAL_PLAYERS = false;
	bool USER_QUALIFIES = false;

	// Variables declared by included files, with the value they start with in this script
	BanditEliteArcherScript()
	{
		WEAPON = "0";
	}
}
