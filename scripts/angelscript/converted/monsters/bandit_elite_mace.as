#pragma context server

// Converted from monsters/bandit_elite_mace.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_elite.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditEliteMace
{
	// Constants
	string WEAPON = "5";
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_elite_mace"]
shared class BanditEliteMaceScript : BanditEliteScript, BanditEliteMace
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
	float FREQ_ALLYJUMP = 0.0f;
	bool HOSTILE_MODE = false;
	bool MADE_DEAL = false;
	string MY_SKILL = "MY_SKILL";
	float NEXT_ALLYJUMP = 0.0f;
	bool NPC_BATTLE_ALLY = false;
	bool OVERRIDE_BANDIT_SPAWN = false;
	bool REWARD_MODE = false;
	string SOUND_ALLY_JUMP = "SOUND_ALLY_JUMP";
	float TC_AVG_DMG_PTS = 0.0f;
	float TC_HALF_AVG_DMG_PTS = 0.0f;
	bool TC_QUAL_PLAYERS = false;
	bool USER_QUALIFIES = false;

	// Variables declared by included files, with the value they start with in this script
	BanditEliteMaceScript()
	{
		WEAPON = "5";
	}
}
