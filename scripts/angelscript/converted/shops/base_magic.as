#pragma context server

// Converted from shops/base_magic.script by msc_transpiler.
// By Thothie
// Base line items sold by most magic/pot shops
// Easier to add new items to all the magic shops through here
// Assumes base_vender

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMagic
{
	// Constants
	float MICRO_RATIO = 0.01f;
	float B_SELL_RATIO = 0.25f;
	int B_OVERCHARGE = 200;

	// Variables (an unset .script variable reads as its own name)
	string MAGIC_SHOP = "MAGIC_SHOP";

	// vendor_addstoreitems
	void BaseMagic_OnVendorAddstoreitems()
	{
		CallEventDelayed(0.1f, "bs_supplement"); // give chance for store to stock up
	}

	// bs_supplement
	void BaseMagic_OnBsSupplement()
	{
		if (MAGIC_SHOP == "MAGIC_SHOP")
			MAGIC_SHOP = "1";

		if (!Truthy(MAGIC_SHOP))
			return;

		// init (not working in main for some reason, so moved here)
		// lots of peeps got free pots during MAR2007a cuz of that ><
		// APR2007a - Shops STILL putting stuff out for free, setting the costs manually (var not passing for some stupid reason)
		// removing this, setting manually
		// if ( OVERCHARGE equals 'OVERCHARGE' ) setvard OVERCHARGE 125
		// if ( SUPERCHARGE equals 'SUPERCHARGE' ) setvard SUPERCHARGE 250
		// if ( SELL_RATIO equals 'SELL_RATIO' ) setvard SELL_RATIO 0.25
		// magic shops always stock spellbooks
		if (!Truthy(ItemExists(ENT_ME, "sheath_spellbook")))
			AddStoreItem(STORE_NAME, "sheath_spellbook", RandomInt(3, 6), B_OVERCHARGE, B_SELL_RATIO);

		OnBsEpicItem(); // call multiple times for higher end stores

		// buy scrolls from players
		if (OVERCHARGE == "OVERCHARGE") // redundancy check
			return;
		AddStoreItem(STORE_NAME, "scroll_fire_ball", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_fire_dart", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_fire_wall", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_glow", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_ice_shield", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_ice_wall", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_lightning_chain", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_lightning_storm", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_lightning_weak", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_poison", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_rejuvenate", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_summon_rat", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_summon_undead", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_volcano", 0, B_OVERCHARGE, B_SELL_RATIO);
		// addstoreitem STORE_NAME scroll2_acid_bolt 0 B_OVERCHARGE B_SELL_RATIO
		AddStoreItem(STORE_NAME, "scroll2_acid_xolt", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_blizzard", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_fire_ball", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_fire_dart", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_fire_wall", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_frost_bolt", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_frost_xolt", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_glow", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_ice_blast", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_ice_shield", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_ice_wall", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_lightning_chain", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_lightning_storm", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_lightning_weak", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_poison", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_poison_cloud", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_rejuvenate", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_summon_rat", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_summon_undead", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_turn_undead", 0, B_OVERCHARGE, B_SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_volcano", 0, B_OVERCHARGE, B_SELL_RATIO);
	}

	// bs_epic_item
	void BaseMagic_OnBsEpicItem()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnVendorAddstoreitems() { BaseMagic_OnVendorAddstoreitems(); } // vendor_addstoreitems
	void OnBsSupplement() { BaseMagic_OnBsSupplement(); } // bs_supplement
	void OnBsEpicItem() { BaseMagic_OnBsEpicItem(); } // bs_epic_item

	// This file's events and timers by their .script names
	bool BaseMagic_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bs_epic_item") { OnBsEpicItem(); return true; }
		if (name == "bs_supplement") { OnBsSupplement(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "shops/base_magic"]
shared class BaseMagicScript : ScriptEntity, BaseMagic
{
	// Variables every script that includes this file declares
	float ADJ_RATIO = 0.0f;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_STEP1 = "ANIM_STEP1";
	string ANIM_STEP10 = "ANIM_STEP10";
	string ANIM_STEP2 = "ANIM_STEP2";
	string ANIM_STEP3 = "ANIM_STEP3";
	string ANIM_STEP4 = "ANIM_STEP4";
	string ANIM_STEP5 = "ANIM_STEP5";
	string ANIM_STEP6 = "ANIM_STEP6";
	string ANIM_STEP7 = "ANIM_STEP7";
	string ANIM_STEP8 = "ANIM_STEP8";
	string ANIM_STEP9 = "ANIM_STEP9";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	float BC_END_AUTO_MOUTH_MOVE = 0.0f;
	float BC_TOTAL_MOUTH_TIME = 0.0f;
	bool BUSY_CHATTING = false;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_DELAY_STEP10 = "CHAT_DELAY_STEP10";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	string CHAT_EVENT_STEP1 = "CHAT_EVENT_STEP1";
	string CHAT_EVENT_STEP10 = "CHAT_EVENT_STEP10";
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	string CHAT_EVENT_STEP3 = "CHAT_EVENT_STEP3";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
	string CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
	string CHAT_EVENT_STEP7 = "CHAT_EVENT_STEP7";
	string CHAT_EVENT_STEP8 = "CHAT_EVENT_STEP8";
	string CHAT_EVENT_STEP9 = "CHAT_EVENT_STEP9";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_SOUND10 = "CHAT_SOUND10";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_SOUND8 = "CHAT_SOUND8";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP10 = "CHAT_STEP10";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	int CHAT_STEPS = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONV_ANIMS = "CONV_ANIMS";
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
	float FREQ_HINT_TEXT = 0.0f;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	bool HAS_BASE_CHAT_INCLUDE = false;
	bool HAS_INCLUDE_NPC = false;
	bool HAS_INCLUDE_VENDOR_CONFIRM = false;
	bool HELENA_RETURNED_HOME = false;
	bool HELENA_SAVED = false;
	float HELENA_TELE_HOME_TIME = 0.0f;
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
	float NEXT_HINT_TEXT = 0.0f;
	bool NO_CHAT = false;
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
	bool NPC_CHECK_LEVEL = false;
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
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
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
	string OVERCHARGE = "OVERCHARGE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool RAID_ON = false;
	string RQUEST_NAMES = "RQUEST_NAMES";
	CBaseEntity@ SCAREY_GUY = null;
	float SELL_RATIO = 0.0f;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	string STORE_BUYMENU = "STORE_BUYMENU";
	int STORE_CLOSED = 0;
	string STORE_NAME = "STORE_NAME";
	bool STORE_RESTOCK = false;
	bool STORE_SELLMENU = false;
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	string STORE_TRIGGERTEXT = "STORE_TRIGGERTEXT";
	int STORE_TYPE = 0;
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	string TEMP = "TEMP";
	bool TRADE_RING = false;
	bool VEND_ARMORER = false;
	string VEND_CHAT_MODE = "VEND_CHAT_MODE";
	bool VEND_CONTAINERS = false;
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_NO_GOODBYE = false;
	CBaseEntity@ VEND_USER = null;
	bool VEND_WEAPONS = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseMagic_DispatchEvent(name, params);
	}
}
