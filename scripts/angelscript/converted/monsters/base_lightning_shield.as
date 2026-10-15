#pragma context server

// Converted from monsters/base_lightning_shield.script by msc_transpiler.
// Lightning Shield Base by Thothie
// Usage (see init area for constants)
// - By default this shield activates whenever a player gets close to the monster
// - If you set LSHIELD_PASSIVE to 0 you can, instead, manually activate the shield for a specific duration via callevent lshield_activate <time>
// - It is suggested that you suspend the AI, and play a looping animation during this time
// - You can toggle the default (passive) shield by setvard LSHIELD_PASSIVE 0
// - If you are using the passive variety (activates only when near) there is no need to use the lshield_activate event

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseLightningShield
{
	// Constants
	bool LSHIELD_PASSIVE = true;
	int LSHIELD_RADIUS = 96;
	int DMG_LSHIELD = 100;
	int LSHIELD_REPELL_STRENGTH = 1000;
	int LSHIELD_V_CENTER = 36;
	int CHANNEL_ZAP_START = 3;
	bool CHANNEL_ZAP_LOOP = true;
	string LSHIELD_CLFX_SCRIPT = "effects/sfx_lightning_shield";
	string LSHIELD_DMG_TYPE = "lightning_effect";
	float LSHIELD_FREQ_UPDATE = 0.5f;
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";

	// Variables (an unset .script variable reads as its own name)
	bool LSHIELD_PASSIVE_ENABLE = false;
	float LSHIELD_NEXT_UPDATE = 0.0f;
	bool LSHIELD_FX_ON = false;
	float LSHIELD_NEXT_SCAN = 0.0f;
	CBaseEntity@ LSHIELD_TARGET = null;
	int LSHIELD_CL_IDX = 0;
	bool LSHIELD_ACTIVE = false;
	float LSHIELD_DURATION = 0.0f;

	// unnamed block (first think)
	void BaseLightningShield_FirstThink()
	{
		LSHIELD_PASSIVE_ENABLE = true; // you can toggle the passive lightning shield with this setvard
	}

	// npcatk_hunt
	void BaseLightningShield_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (!LSHIELD_PASSIVE)
			return;
		if (!LSHIELD_PASSIVE_ENABLE)
			return;
		if (LSHIELD_ACTIVE) // just in case some silly scripter tries to combine the two types
			return;

		if (NPCATK_TARGET != "unset" && GameTime() > LSHIELD_NEXT_SCAN)
			OnLshieldScan();

		if (!IsAlive(LSHIELD_TARGET))
		{
			OnLshieldPassiveFxOff();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (RangeTo(LSHIELD_TARGET) <= LSHIELD_RADIUS)
			OnLshieldPassiveZapTarget();
		else
			OnLshieldPassiveFxOff();
	}

	// lshield_passive_zap_target
	void BaseLightningShield_OnLshieldPassiveZapTarget()
	{
		if (!LSHIELD_FX_ON)
			OnLshieldPassiveFxStart();
		if (GameTime() > LSHIELD_NEXT_UPDATE)
		{
			LSHIELD_NEXT_UPDATE = GameTime() + LSHIELD_FREQ_UPDATE;
			ClientEvent("update", "all", LSHIELD_CL_IDX, "lshield_on", 0.5f);
		}
		DoDamage(LSHIELD_TARGET, "direct", DMG_LSHIELD, "100%", ENT_ME, LSHIELD_DMG_TYPE);
		float zapTargResist = DamageTakenOf(LSHIELD_TARGET, "lightning");
		float zapRoll = Random(0, 2);
		// dbg targresist ZAP_TARG_RESIST vs. ZAP_ROLL
		if (!(zapRoll < zapTargResist))
			return;
		Vector3 targOrg = OriginOf(LSHIELD_TARGET);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(LSHIELD_TARGET, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, LSHIELD_REPELL_STRENGTH, 10)));
	}

	// lshield_passive_fx_start
	void BaseLightningShield_OnLshieldPassiveFxStart()
	{
		LSHIELD_FX_ON = true;
		PlaySound((CHANNEL_ZAP_LOOP ? 1 : 0), 10, SOUND_ZAP_LOOP);
		PlaySound(CHANNEL_ZAP_START, 10, SOUND_ZAP_START);
		if (LSHIELD_CL_IDX == 0)
			OnLshieldStartClFx(10.1f);
	}

	// lshield_passive_fx_off
	void BaseLightningShield_OnLshieldPassiveFxOff()
	{
		if (!LSHIELD_FX_ON)
			return;
		LSHIELD_FX_ON = false;
		PlaySound((CHANNEL_ZAP_LOOP ? 1 : 0), 0, SOUND_ZAP_LOOP);
	}

	// lshield_scan
	void BaseLightningShield_OnLshieldScan()
	{
		LSHIELD_NEXT_SCAN = GameTime() + 1.0f; // scan once a second

		string lshieldList = FindInSphere("enemy", LSHIELD_RADIUS);
		if (lshieldList == "none")
			return;
		if (GetTokenCount(lshieldList) > 1)
			lshieldList = TokenShuffle(lshieldList);
		@LSHIELD_TARGET = FindEntity(GetToken(lshieldList, 0));
	}

	// lshield_start_cl_fx
	void BaseLightningShield_OnLshieldStartClFx(float delay = 0.0f)
	{
		ClientEvent("new", "all", LSHIELD_CLFX_SCRIPT, IndexOf(ENT_ME), LSHIELD_RADIUS, 10.0f, LSHIELD_V_CENTER, 1);
		LSHIELD_CL_IDX = Int(LastClientScriptId());
		CallEventDelayed(delay, "lshield_reset_fx");
	}

	// lshield_reset_fx
	void BaseLightningShield_OnLshieldResetFx()
	{
		LSHIELD_CL_IDX = 0;
	}

	// lshield_activate
	// ======================================================================== Activated Variant
	// <duration>
	void BaseLightningShield_OnLshieldActivate(float duration = 0.0f)
	{
		LSHIELD_ACTIVE = true;
		LSHIELD_DURATION = duration;
		OnLshieldLoop();
		CallEventDelayed(LSHIELD_DURATION, "lshield_toggle_off");

		LSHIELD_FX_ON = true;
		PlaySound((CHANNEL_ZAP_LOOP ? 1 : 0), 10, SOUND_ZAP_LOOP);
		PlaySound(CHANNEL_ZAP_START, 10, SOUND_ZAP_START);
		if (LSHIELD_CL_IDX == 0)
			OnLshieldStartActiveClFx();
	}

	// lshield_start_active_cl_fx
	// <duration>
	void BaseLightningShield_OnLshieldStartActiveClFx()
	{
		ClientEvent("new", "all", LSHIELD_CLFX_SCRIPT, IndexOf(ENT_ME), LSHIELD_RADIUS, LSHIELD_DURATION, LSHIELD_V_CENTER, 0);
	}

	// lshield_toggle_off
	void BaseLightningShield_OnLshieldToggleOff()
	{
		LSHIELD_ACTIVE = false;
		LSHIELD_FX_ON = false;
		PlaySound((CHANNEL_ZAP_LOOP ? 1 : 0), 0, SOUND_ZAP_LOOP);
		DebugPrint("lshield_toggle_off");
	}

	// lshield_loop
	void BaseLightningShield_OnLshieldLoop()
	{
		if (!LSHIELD_ACTIVE)
			return;
		CallEventDelayed(0.1f, "lshield_loop");
		if (GameTime() > LSHIELD_NEXT_SCAN)
			OnLshieldScan();
		if (!IsAlive(LSHIELD_TARGET))
			return;
		if (!(RangeTo(LSHIELD_TARGET) <= LSHIELD_RADIUS))
			return;

		DoDamage(LSHIELD_TARGET, "direct", DMG_LSHIELD, "100%", ENT_ME, LSHIELD_DMG_TYPE);
		float zapTargResist = DamageTakenOf(LSHIELD_TARGET, "lightning");
		float zapRoll = Random(0, 2);
		DebugPrint("lshield_loop " + Text(zapRoll) + " vs " + Text(zapTargResist));
		if (!(zapRoll < zapTargResist))
			return;
		Vector3 targOrg = OriginOf(LSHIELD_TARGET);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(LSHIELD_TARGET, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, LSHIELD_REPELL_STRENGTH, 10)));
	}

	// game_death
	// ======================================================================== Clear FX on death
	void BaseLightningShield_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// client fx will expire by itself
		if (LSHIELD_FX_ON)
			PlaySound((CHANNEL_ZAP_LOOP ? 1 : 0), 0, SOUND_ZAP_LOOP);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcatkHunt() { BaseLightningShield_OnNpcatkHunt(); } // npcatk_hunt
	void OnLshieldPassiveZapTarget() { BaseLightningShield_OnLshieldPassiveZapTarget(); } // lshield_passive_zap_target
	void OnLshieldPassiveFxStart() { BaseLightningShield_OnLshieldPassiveFxStart(); } // lshield_passive_fx_start
	void OnLshieldPassiveFxOff() { BaseLightningShield_OnLshieldPassiveFxOff(); } // lshield_passive_fx_off
	void OnLshieldScan() { BaseLightningShield_OnLshieldScan(); } // lshield_scan
	void OnLshieldStartClFx(float delay = 0.0f) { BaseLightningShield_OnLshieldStartClFx(delay); } // lshield_start_cl_fx
	void OnLshieldResetFx() { BaseLightningShield_OnLshieldResetFx(); } // lshield_reset_fx
	void OnLshieldActivate(float duration = 0.0f) { BaseLightningShield_OnLshieldActivate(duration); } // lshield_activate
	void OnLshieldStartActiveClFx() { BaseLightningShield_OnLshieldStartActiveClFx(); } // lshield_start_active_cl_fx
	void OnLshieldToggleOff() { BaseLightningShield_OnLshieldToggleOff(); } // lshield_toggle_off
	void OnLshieldLoop() { BaseLightningShield_OnLshieldLoop(); } // lshield_loop
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnLshieldDuration() {} // LSHIELD_DURATION

	// This file's events and timers by their .script names
	bool BaseLightningShield_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "lshield_activate") { OnLshieldActivate(Float(Param(params, 0))); return true; }
		if (name == "lshield_loop") { OnLshieldLoop(); return true; }
		if (name == "lshield_passive_fx_off") { OnLshieldPassiveFxOff(); return true; }
		if (name == "lshield_passive_fx_start") { OnLshieldPassiveFxStart(); return true; }
		if (name == "lshield_passive_zap_target") { OnLshieldPassiveZapTarget(); return true; }
		if (name == "lshield_reset_fx") { OnLshieldResetFx(); return true; }
		if (name == "lshield_scan") { OnLshieldScan(); return true; }
		if (name == "lshield_start_active_cl_fx") { OnLshieldStartActiveClFx(); return true; }
		if (name == "lshield_start_cl_fx") { OnLshieldStartClFx(Float(Param(params, 0))); return true; }
		if (name == "lshield_toggle_off") { OnLshieldToggleOff(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_lightning_shield"]
shared class BaseLightningShieldScript : ScriptEntity, BaseLightningShield
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
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
	bool HAS_INCLUDE_NPC = false;
	bool HAVE_TARGET = false;
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
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool IS_FLEEING = false;
	bool IS_HUNTING = false;
	CBaseEntity@ I_HEARD = null;
	bool I_R_FROZEN = false;
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
	bool NPC_FIGHTS_NPCS = false;
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
	float ORIG_MOVERANGE = 0.0f;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	bool SUSPEND_AI = false;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseLightningShield_DispatchEvent(name, params);
	}
}
