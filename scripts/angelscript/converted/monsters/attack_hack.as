#pragma context server

// Converted from monsters/attack_hack.script by msc_transpiler.
// Thothie - Attack hack script by Lord K
// - You can use this via #include if your monster's model can't attack properly
// - You will have to set ATTACK_FREQUENCY to match up the models animaitons and attacks
// - 10 is a good number, if you are uncertain as to the model animation time (about 1 attack/sec)
// - This is also useful if you want a monster to use an unusual attack animation

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AttackHack
{
	// Variables (an unset .script variable reads as its own name)
	string ATTACK_DAMAGE = "5";
	int ATTACK_FREQUENCY = 10;
	float ATTACK_COUNTER = 0.0f;

	// npcatk_attackenemy
	void AttackHack_OnNpcatkAttackenemy()
	{
		if (Float(ATTACK_DAMAGE) == 0.0f) // default to 5
			ATTACK_DAMAGE = "5";
		if (ATTACK_FREQUENCY == 0.0f) // default to 10
			ATTACK_FREQUENCY = 10;

		// attack hack script by Lord K
		OnCanReachNme();
		OnNpcAttack();
		OnNpcSelectattack(); // Give a chance to select attack anim

		SetMoveDest(ENT_LASTSEEN, MOVE_RANGE);
		PlayAnim("once", ANIM_ATTACK);

		CallEventDelayed(0.0f, "1");

		// makes attack hack look more natural
		ATTACK_COUNTER += 1.0f;
		if (ATTACK_COUNTER == ATTACK_FREQUENCY)
		{
			// do damage
			DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);

			ATTACK_COUNTER = 0.0f;
		}
	}

	// do_stuff
	void AttackHack_OnDoStuff()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcatkAttackenemy() { AttackHack_OnNpcatkAttackenemy(); } // npcatk_attackenemy
	void OnDoStuff() { AttackHack_OnDoStuff(); } // do_stuff
	void OnCanReachNme() {} // can_reach_nme
	void OnNpcAttack() {} // npc_attack
	void OnNpcSelectattack() {} // npc_selectattack

	// This file's events and timers by their .script names
	bool AttackHack_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_stuff") { OnDoStuff(); return true; }
		if (name == "npcatk_attackenemy") { OnNpcatkAttackenemy(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/attack_hack"]
shared class AttackHackScript : ScriptEntity, AttackHack
{
	// Variables every script that includes this file declares
	float ADJ_RATIO = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	string CANT_TRACK = "CANT_TRACK";
	string CANT_TURN = "CANT_TURN";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CHASE_RANGE = "CHASE_RANGE";
	bool CHICKEN_RUN = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	float CKN_TIME_END = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool CYCLED_UP = false;
	string CYCLE_TIME = "CYCLE_TIME";
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
	bool DEMON_BLOOD = false;
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
	float FINAL_ATTACK_DAMAGE = 0.0f;
	float FINAL_HITCHANCE_DAMAGE = 0.0f;
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
	bool I_R_FROZEN = false;
	float MAKE_NOISE = 0.0f;
	int MONSTER_ID = 0;
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	string MY_OLD_NAME = "MY_OLD_NAME";
	float M_ATTACK_HITRANGE = 0.0f;
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool NPCATK_FLEE_RESTORETARGET = false;
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	bool NPC_ALERTED_ALL = false;
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	bool NPC_CANSEE_TARGET = false;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	bool NPC_DELAYING_FLINCH = false;
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
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	string NPC_HEAR_TARGET = "NPC_HEAR_TARGET";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_INITIALIZED = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_MAXHP = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	int NPC_NO_AGRO = 0;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	bool NPC_QUED_FOR_DEATH = false;
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	int NPC_SPRITE_IN = 0;
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	float NPC_TARG_HALFHEIGHT = 0.0f;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	string ORIG_HUNT_AGRO = "ORIG_HUNT_AGRO";
	string ORIG_NPC_MOVE_TARGET = "ORIG_NPC_MOVE_TARGET";
	bool OUT_OF_RANGE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool PURE_FLEE = false;
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	bool SUSPEND_AI = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AttackHack_DispatchEvent(name, params);
	}
}
