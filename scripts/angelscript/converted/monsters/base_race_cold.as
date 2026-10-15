#pragma context server

// Converted from monsters/base_race_cold.script by msc_transpiler.
// alias

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_ice_race.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseRaceCold
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_race_cold"]
shared class BaseRaceColdScript : BaseIceRaceScript, BaseRaceCold
{
	// Variables every script that includes this file declares
	int AIM_RATIO = 0;
	string ANIM_DBLPUNCH = "ANIM_DBLPUNCH";
	string ANIM_PUNCH = "ANIM_PUNCH";
	string ANIM_THROW = "ANIM_THROW";
	float ATTACK_MOVERANGE = 0.0f;
	int ATTACK_SPEED = 0;
	string CANT_TRACK = "CANT_TRACK";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	float CKN_TIME_END = 0.0f;
	float COMBAT_REPOS = 0.0f;
	bool DID_WARCRY = false;
	bool DO_THROW = false;
	int DROP_GOLD_MAX = 0;
	int DROP_GOLD_MIN = 0;
	float FINAL_ATTACK_DAMAGE = 0.0f;
	float FINAL_HITCHANCE_DAMAGE = 0.0f;
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string HUNT_AGRO = "HUNT_AGRO";
	int MELE_HITRANGE = 0;
	int MELE_RANGE = 0;
	float M_ATTACK_HITRANGE = 0.0f;
	bool NPCATK_FLEE_RESTORETARGET = false;
	bool NPC_DELAYING_FLINCH = false;
	string NPC_HEAR_TARGET = "NPC_HEAR_TARGET";
	bool NPC_INITIALIZED = false;
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	float NPC_TARG_HALFHEIGHT = 0.0f;
	string ORIG_HUNT_AGRO = "ORIG_HUNT_AGRO";
	string ORIG_NPC_MOVE_TARGET = "ORIG_NPC_MOVE_TARGET";
	bool OUT_OF_RANGE = false;
	bool PURE_FLEE = false;
	string PUSH_VEL = "PUSH_VEL";
	string ROCK_DAMAGE = "ROCK_DAMAGE";
	int ROCK_RANGE = 0;
	string SOUND_ATTACK = "SOUND_ATTACK";
	string SOUND_IDLE = "SOUND_IDLE";
	string SOUND_PAIN = "SOUND_PAIN";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";
	string SOUND_WALK1 = "SOUND_WALK1";
	string SOUND_WALK2 = "SOUND_WALK2";
	int SWING_RANGE = 0;
}
