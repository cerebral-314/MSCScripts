#pragma context server

// Converted from old_helena/base_old_helena_npc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseOldHelenaNpc
{
	// Constants
	string SOUND_HELP1 = "scientist/sci_fear1.wav";
	string SOUND_HELP2 = "scientist/sci_fear2.wav";
	string SOUND_HELP3 = "scientist/sci_fear3.wav";
	string SOUND_HELP4 = "scientist/sci_fear4.wav";
	string SOUND_HELP5 = "scientist/sci_pain1.wav";
	string SOUND_HELP6 = "scientist/sci_pain2.wav";
	string SOUND_HELP7 = "scientist/sci_pain3.wav";
	string SOUND_HELP8 = "scientist/sci_pain4.wav";
	string SOUND_HELP9 = "scientist/sci_pain5.wav";
	string SOUND_DEATH1 = "scientist/scream1.wav";
	string SOUND_DEATH2 = "scientist/scream2.wav";
	string SOUND_DEATH3 = "scientist/scream3.wav";
	string SOUND_DEATH4 = "scientist/scream4.wav";
	float FREQ_WARN = 5.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	bool WARN_DELAY = false;
	float LAST_STRUCK_TIME = 0.0f;
	bool NPC_REPORT_ITEMS = false;

	// unnamed block (first think)
	void BaseOldHelenaNpc_FirstThink()
	{
		ANIM_DEATH = "death";
	}

	// game_spawn
	void BaseOldHelenaNpc_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetNoPush(true);
		SetSayTextRange(1024);

		CallEventDelayed(0.1f, "critical_npc");
	}

	// reset_warn_delay
	void BaseOldHelenaNpc_OnResetWarnDelay()
	{
		WARN_DELAY = false;
	}

	// game_struck
	void BaseOldHelenaNpc_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetIdleAnim("crouch_idle");
		PlayAnim("critical", "crouch_idle");
		LAST_STRUCK_TIME = GameTime() + 9.0f;
		CallEventDelayed(10.0f, "check_unfear");
		PlayRandomSound(0, 10, SOUND_HELP1, SOUND_HELP2, SOUND_HELP3, SOUND_HELP4, SOUND_HELP5, SOUND_HELP6, SOUND_HELP7, SOUND_HELP8, SOUND_HELP9);

		int randScream = RandomInt(1, 4);
		if (randScream == 1)
			SayText("Help! Help!");
		if (randScream == 2)
			SayText("Over here!");
		if (randScream == 3)
			SayText("Save me!");
		if (randScream == 4)
			SayText("The orcs! Save me from the orcs!");
	}

	// check_unfear
	void BaseOldHelenaNpc_OnCheckUnfear()
	{
		if (!(GameTime() > LAST_STRUCK_TIME))
			return;
		SetIdleAnim("idle1");
		PlayAnim("critical", "idle1");
	}

	// game_death
	// moved to base_npc
	// { game_death
	// local INFO_TITLE "A CRITICAL NPC HAS DIED!"
	// local INFO_MSG $get(ent_me,name)
	// stradd INFO_MSG " has been slain! "
	// subtract G_NPC_REMAIN 1
	// //	subtract G_NPC_REMAIN 1
	// //	stradd INFO_MSG "("
	// //	stradd INFO_MSG G_NPC_REMAIN
	// //	stradd INFO_MSG "/5 critical NPC's remain!)
	// infomsg all INFO_TITLE INFO_MSG
	void BaseOldHelenaNpc_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_DEATH1, SOUND_DEATH2, SOUND_DEATH3);
	}

	// old_helena_warboss_died
	void BaseOldHelenaNpc_OnOldHelenaWarbossDied()
	{
		NPC_REPORT_ITEMS = true;
		SetInvincible(true);
		SetIdleAnim("idle1");
	}

	// game_damaged
	string BaseOldHelenaNpc_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!IsPlayer(attacker))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnResetWarnDelay() { BaseOldHelenaNpc_OnResetWarnDelay(); } // reset_warn_delay
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnCheckUnfear() { BaseOldHelenaNpc_OnCheckUnfear(); } // check_unfear
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseOldHelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnOldHelenaWarbossDied() { BaseOldHelenaNpc_OnOldHelenaWarbossDied(); } // old_helena_warboss_died
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BaseOldHelenaNpc_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// This file's events and timers by their .script names
	bool BaseOldHelenaNpc_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_unfear") { OnCheckUnfear(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "reset_warn_delay") { OnResetWarnDelay(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "old_helena/base_old_helena_npc"]
shared class BaseOldHelenaNpcScript : ScriptEntity, BaseOldHelenaNpc
{
	// Variables every script that includes this file declares
	float ADJ_RATIO = 0.0f;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
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

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseOldHelenaNpc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseOldHelenaNpc_DispatchEvent(name, params);
	}
}
