#pragma context server

// Converted from NPCs/dwarf_lantern_base.script by msc_transpiler.
// centralizing this cuz a lotta dwarves are gonna be using it

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfLanternBase
{
	// Constants
	float FREQ_LANTERNCL_REFRESH = 30.0f;
	int LANTERN_HAND_SUBMODEL = 1;
	bool LANTERN_HAND_INDEX = true;
	string LANTERN_COLOR = "LANTERN_COLOR";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_LANTERNCL_REFRESH = 0.0f;
	bool LANTERN_ACTIVE = false;
	string LANTERN_CL_IDX = "LANTERN_CL_IDX";
	bool LANTERN_ON = false;
	bool LANTERN_SET = false;
	string CUSTOM_LANTERN_COLOR = "CUSTOM_LANTERN_COLOR";

	// game_precache
	void DwarfLanternBase_OnGamePrecache()
	{
	}

	// npcatk_hunt
	void DwarfLanternBase_OnNpcatkHunt()
	{
		string lanternColor;
		if (!LANTERN_ON)
			return;
		if (!(GameTime() > NEXT_LANTERNCL_REFRESH))
			return;
		NEXT_LANTERNCL_REFRESH = GameTime() + FREQ_LANTERNCL_REFRESH;

		if (!LANTERN_ACTIVE)
		{
			LANTERN_ACTIVE = true;
			SetModelBody(2, LANTERN_HAND_SUBMODEL);
		}

		if (CUSTOM_LANTERN_COLOR != "CUSTOM_LANTERN_COLOR")
			lanternColor = CUSTOM_LANTERN_COLOR;
		else
			lanternColor = LANTERN_COLOR;
		ClientEvent("new", "all", "NPCs/dwarf_lantern_cl", IndexOf(ENT_ME), LANTERN_HAND_INDEX, lanternColor, FREQ_LANTERNCL_REFRESH);
		LANTERN_CL_IDX = LastClientScriptId();
	}

	// set_lantern
	void DwarfLanternBase_OnSetLantern(string lanternColor = "")
	{
		LANTERN_ON = true;
		LANTERN_SET = true;
		if (lanternColor == "0")
		{
			// so we can turn it back off
			ClientEvent("update", "all", LANTERN_CL_IDX, "end_fx");
			SetModelBody(2, 0);
			LANTERN_ON = false;
			LANTERN_ACTIVE = false;
		}
		else if (StartsWith(lanternColor, "("))
			CUSTOM_LANTERN_COLOR = lanternColor;
	}

	// game_death
	// . createdyn 1 events "set_follower;set_lantern"
	void DwarfLanternBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("update", "all", LANTERN_CL_IDX, "end_fx");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { DwarfLanternBase_OnGamePrecache(); } // game_precache
	void OnNpcatkHunt() { DwarfLanternBase_OnNpcatkHunt(); } // npcatk_hunt
	void OnSetLantern(string lanternColor = "") { DwarfLanternBase_OnSetLantern(lanternColor); } // set_lantern
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death

	// This file's events and timers by their .script names
	bool DwarfLanternBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_lantern") { OnSetLantern(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/dwarf_lantern_base"]
shared class DwarfLanternBaseScript : ScriptEntity, DwarfLanternBase
{
	// Variables every script that includes this file declares
	float ADJ_RATIO = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
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
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_DELAY = "FLINCH_DELAY";
	bool FREEZE_WAS_SUSPEND = false;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	bool HAS_INCLUDE_NPC = false;
	bool HIT_BY_MANABALL = false;
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IMMUNE_VAMPIRE = false;
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool I_R_FROZEN = false;
	float MAKE_NOISE = 0.0f;
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	string MY_OLD_NAME = "MY_OLD_NAME";
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
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
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_MAXHP = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
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
	bool NPC_SUMMON = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DwarfLanternBase_DispatchEvent(name, params);
	}
}
