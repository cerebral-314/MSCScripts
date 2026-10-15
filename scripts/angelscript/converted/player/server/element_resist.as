#pragma context server

// Converted from player/server/element_resist.script by msc_transpiler.
// elemental resistance system, again, again.
// - item sends the element and % resistance, and take a unique name for register/unregistering its effect
// - similarly, titles and negative effects should be registerable this way

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ElementResist
{
	// Constants
	string PLR_RESIST_RESET = "1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0";

	// Variables (an unset .script variable reads as its own name)
	string PLR_RESIST_ELEMENTS = "PLR_RESIST_ELEMENTS";
	string PLR_RESIST_VALUES = "PLR_RESIST_VALUES";
	bool PLR_CHECK_WEAPON_RESIST = false;
	bool PLR_RESIST_UPDATE_FLAG = false;
	string OLD_RESISTANCES = "OLD_RESISTANCES";
	bool ELM_REGISTER_SILENT = false;

	// unnamed block (first think)
	void ElementResist_FirstThink()
	{
		if (!Truthy(LegacyFunction("get_array_exists", "PLR_RESIST_NAMES"))) // will be -1 if the array doesnt exist. if it doesnt, create them.
		{
			ArrayCreate("PLR_RESIST_NAMES");
			ArrayCreate("PLR_RESIST_TYPES");
			ArrayCreate("PLR_RESIST_AMTS");

			ArrayCreate("PLR_RESIST_WEAPON_IDS");
			ArrayCreate("PLR_RESIST_WEAPON_TAGS");
		}

		PLR_RESIST_ELEMENTS = "fire;lightning;cold;earth;poison;acid;holy;dark;magic;slash;blunt;pierce;all";
		PLR_RESIST_VALUES = "1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0";

		PLR_CHECK_WEAPON_RESIST = false;
	}

	// ext_register_element
	// <name> <element|remove> <% resistance>
	void ElementResist_OnExtRegisterElement(string uniqueName = "", string element = "", string resistPercent = "")
	{
		// unique name of the registered element
		// element type or "remove" to remove it
		float resistAmt = Float(resistPercent); // % resistance

		int findName = ArrayFind("PLR_RESIST_NAMES", uniqueName);

		// infomsg all "ext_register_element" RESIST_NAME RESIST_TYPE RESIST_AMT FIND_NAME
		if (element == "remove")
		{
			// remove a registered resistance
			if (findName != -1)
			{
				ArrayRemoveAt("PLR_RESIST_NAMES", findName);
				ArrayRemoveAt("PLR_RESIST_TYPES", findName);
				ArrayRemoveAt("PLR_RESIST_AMTS", findName);
				OnUpdateResistances();
			}
		}
		else
		{
			resistAmt *= 0.01f; // % to float

			if (findName != -1) // existing name?
			{
				// adjust the value of an existing array
				int oldValue = ArrayFind("PLR_RESIST_AMTS", Text(findName));
				if (oldValue != resistAmt)
				{
					ArraySet("PLR_RESIST_AMTS", findName, resistAmt); // JAN2010_15 - AUG! Bug here, fixed (forgot FIND_NAME)
				}
			}
			else
			{
				// register a new elemental resistance
				ArrayAdd("PLR_RESIST_NAMES", uniqueName);
				ArrayAdd("PLR_RESIST_TYPES", element);
				ArrayAdd("PLR_RESIST_AMTS", resistAmt);
			}

			// dbg ext_register_element add RESIST_TYPE RESIST_AMT - PLR_RESIST_AMTS
			OnUpdateResistances();
		}
	}

	// update_resistances
	void ElementResist_OnUpdateResistances()
	{
		PLR_RESIST_UPDATE_FLAG = false;
		OLD_RESISTANCES = PLR_RESIST_VALUES; // for notifying of changes
		PLR_RESIST_VALUES = PLR_RESIST_RESET; // reset all resists to 1.0
		int count = GetArrayCount("PLR_RESIST_NAMES"); // adjust resistances based on registered resist names
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCatResistances();
		}
		count = GetTokenCount(PLR_RESIST_VALUES); // actualy set takedmg levels, and notify of differences
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnApplyResistances();
		}
	}

	// cat_resistances
	// adjust resistances based on registered resist names
	void ElementResist_OnCatResistances()
	{
		int curIdx = loopIteration;
		string itemResistType = GetArray("PLR_RESIST_TYPES", Text(curIdx)); // registered item/effect's element resist type
		float itemResistAmt = Float(GetArray("PLR_RESIST_AMTS", Text(curIdx))); // registered item/effect's element resist amount
		itemResistAmt = -itemResistAmt; // we're actually subtracting from 1 (75% resistance, = 1 - 0.75 = 0.25 )
		int curResistIdx = FindToken(PLR_RESIST_ELEMENTS, itemResistType); // find index of item's element resist type on player
		float curResistAmt = Float(GetToken(PLR_RESIST_VALUES, curResistIdx)); // player's current resistance level

		// dbg cat_resistances # CUR_IDX it_type ITEM_RESIST_TYPE it_amt ITEM_RESIST_AMT cur_rst CUR_RESIST_AMT
		curResistAmt += itemResistAmt;
		if (curResistAmt < 0.0f)
			curResistAmt = 0.0f;
		PLR_RESIST_VALUES = TokenSet(PLR_RESIST_VALUES, curResistIdx, Text(curResistAmt));
	}

	// apply_resistances
	void ElementResist_OnApplyResistances()
	{
		int curIdx = loopIteration;
		string curResistType = GetToken(PLR_RESIST_ELEMENTS, curIdx);
		float curResistAmt = Float(GetToken(PLR_RESIST_VALUES, curIdx));
		SetDamageTaken(curResistType, curResistAmt);

		string oldResistAmt = GetToken(OLD_RESISTANCES, curIdx);

		if (Text(curResistAmt) != oldResistAmt)
		{
			// resistance has changed, notify player
			// convert to %
			curResistAmt *= 100.0f;
			curResistAmt -= 100.0f;
			curResistAmt = -curResistAmt;
			curResistAmt = int(curResistAmt);
			curResistAmt = Float(Text(curResistAmt) + "%");
			if (!ELM_REGISTER_SILENT)
				PlayerMessageGreen(ENT_ME, "Your resistance to " + curResistType + " is now " + Text(curResistAmt));
			ELM_REGISTER_SILENT = false;
		}
	}

	// ext_register_weapon
	// <weapon_id> <tag> <element|remove> [%amt]
	void ElementResist_OnExtRegisterWeapon(CBaseEntity@ weaponEntity = null, string tag = "", string element = "", float resistPercent = 0.0f)
	{
		if (element != "remove")
		{
			if (ArrayFind("PLR_RESIST_WEAPON_IDS", EntityId(weaponEntity)) == -1)
			{
				OnExtRegisterElement(tag, element, Text(resistPercent));
				ArrayAdd("PLR_RESIST_WEAPON_IDS", @weaponEntity);
				ArrayAdd("PLR_RESIST_WEAPON_TAGS", tag);
			}
		}
		else
		{
			OnExtRegisterElement(tag, "remove");
			int weaponIdx = ArrayFind("PLR_RESIST_WEAPON_IDS", EntityId(weaponEntity));
			ArrayRemoveAt("PLR_RESIST_WEAPON_IDS", weaponIdx);
			ArrayRemoveAt("PLR_RESIST_WEAPON_TAGS", weaponIdx);
		}

		if (int("PLR_RESIST_WEAPON_IDS".length()) >= 3)
		{
			if (!PLR_CHECK_WEAPON_RESIST)
			{
				PLR_CHECK_WEAPON_RESIST = true;
				OnCheckWeaponsLoop();
			}
		}
		else
		{
			PLR_CHECK_WEAPON_RESIST = false;
		}
	}

	// check_weapons_loop
	void ElementResist_OnCheckWeaponsLoop()
	{
		int count;

		if (!PLR_CHECK_WEAPON_RESIST)
			return;
		CallEventDelayed(5.0f, "check_weapons_loop");
		if (!PLR_IN_WORLD)
			return;
		if (!IsAlive(ENT_ME))
			return;
		int nResistWeapons = GetArrayCount("PLR_RESIST_WEAPON_IDS");
		if (nResistWeapons > 0)
		{
			count = GetArrayCount("PLR_RESIST_WEAPON_IDS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnCheckWeapons();
			}
		}
		if (int("PLR_RESIST_WEAPON_IDS".length()) < 3)
			PLR_CHECK_WEAPON_RESIST = false;
	}

	// check_weapons
	void ElementResist_OnCheckWeapons()
	{
		bool noRemove = false;

		string curWeapon = GetArray("PLR_RESIST_WEAPON_IDS", Text(loopIteration));
		if (curWeapon == EntityId(PLR_LEFT_HAND))
			noRemove = true;
		if (curWeapon == EntityId(PLR_RIGHT_HAND))
			noRemove = true;
		if (noRemove)
			return;
		OnExtRegisterElement(GetArray("PLR_RESIST_WEAPON_TAGS", curWeapon), "remove");
		ArrayRemoveAt("PLR_RESIST_WEAPON_IDS", curWeapon);
		ArrayRemoveAt("PLR_RESIST_WEAPON_TAGS", curWeapon);
	}

	// game_death
	// Removes temporary resistances after player dies.
	void ElementResist_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnExtRegisterElement("firep", "remove");
		OnExtRegisterElement("coldp", "remove");
		OnExtRegisterElement("ligip", "remove");
		OnExtRegisterElement("firip", "remove");
		OnExtRegisterElement("colip", "remove");
		OnExtRegisterElement("poiip", "remove");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnExtRegisterElement(string uniqueName = "", string element = "", string resistPercent = "") { ElementResist_OnExtRegisterElement(uniqueName, element, resistPercent); } // ext_register_element
	void OnUpdateResistances() { ElementResist_OnUpdateResistances(); } // update_resistances
	void OnCatResistances() { ElementResist_OnCatResistances(); } // cat_resistances
	void OnApplyResistances() { ElementResist_OnApplyResistances(); } // apply_resistances
	void OnExtRegisterWeapon(CBaseEntity@ weaponEntity = null, string tag = "", string element = "", float resistPercent = 0.0f) { ElementResist_OnExtRegisterWeapon(weaponEntity, tag, element, resistPercent); } // ext_register_weapon
	void OnCheckWeaponsLoop() { ElementResist_OnCheckWeaponsLoop(); } // check_weapons_loop
	void OnCheckWeapons() { ElementResist_OnCheckWeapons(); } // check_weapons
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { ElementResist_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death

	// This file's events and timers by their .script names
	bool ElementResist_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "apply_resistances") { OnApplyResistances(); return true; }
		if (name == "cat_resistances") { OnCatResistances(); return true; }
		if (name == "check_weapons") { OnCheckWeapons(); return true; }
		if (name == "check_weapons_loop") { OnCheckWeaponsLoop(); return true; }
		if (name == "ext_register_element") { OnExtRegisterElement(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "ext_register_weapon") { OnExtRegisterWeapon(EntityParam(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "update_resistances") { OnUpdateResistances(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/server/element_resist"]
shared class ElementResistScript : ScriptEntity, ElementResist
{
	// Variables every script that includes this file declares
	bool AFK_DID_FIRST_PULSE = false;
	Vector3 AFK_OLD_POS = Vector3();
	float AFK_TIME = 0.0f;
	float AFL_BURST_DOT = 0.0f;
	CBaseEntity@ ALCO_SPAWN_ITEM = null;
	string ALCO_TYPE = "ALCO_TYPE";
	string ANIM_CROUCH = "ANIM_CROUCH";
	string ANIM_CROUCHMOVE = "ANIM_CROUCHMOVE";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_JUMP = "ANIM_JUMP";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_STAND = "ANIM_STAND";
	string ANIM_STAND_IDLE = "ANIM_STAND_IDLE";
	string ANIM_SWIM = "ANIM_SWIM";
	string ANIM_TREAD = "ANIM_TREAD";
	int ANIM_TYPE_HOLD = 0;
	bool ANIM_TYPE_ONCE = false;
	bool ANIM_TYPE_WALK = false;
	string ANIM_WALK = "ANIM_WALK";
	int ARMOR_EQUIPED = 0;
	string ARMOR_OFS = "ARMOR_OFS";
	string ARMOR_TYPE = "ARMOR_TYPE";
	string BAR_STRING = "BAR_STRING";
	bool BASE_REGEN_HP = false;
	bool BASE_REGEN_MP = false;
	float BASE_REGEN_RATE = 0.0f;
	float BEAM_ROT = 0.0f;
	float BLOODSTONE_BONUS_RATE = 0.0f;
	string BLOODSTONE_EQUIPPED = "BLOODSTONE_EQUIPPED";
	float BUILD_BAR_COUNT = 0.0f;
	bool CAN_VAMPIRE_TARGET = false;
	string CURRENT_DEATH_ANIM = "CURRENT_DEATH_ANIM";
	string CVAR_HP_LIMIT = "CVAR_HP_LIMIT";
	float DEMON_BLOOD_END_TIME = 0.0f;
	bool DISPLAY_HBAR_DELAY = false;
	bool DISPLAY_PBAR_DELAY = false;
	string DISPLAY_PLAYER_HP = "DISPLAY_PLAYER_HP";
	bool DISPLAY_TARG_HP = false;
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	float EXT_DMGPOINTS = 0.0f;
	bool EXT_EFFECT_LIST = false;
	string EXT_REMOVE_EFFECT = "EXT_REMOVE_EFFECT";
	float FINAL_REGEN_HP = 0.0f;
	float FINAL_REGEN_MP = 0.0f;
	float FINAL_REGEN_RATE_HP = 0.0f;
	float FINAL_REGEN_RATE_MP = 0.0f;
	float FIRST_PARTY_MSG = 0.0f;
	bool FISSURE_ACTIVE = false;
	float FISSURE_COUNT = 0.0f;
	Vector3 FISSURE_DIR = Vector3();
	float FISSURE_DMG = 0.0f;
	Vector3 FISSURE_END = Vector3();
	float FISSURE_LENGTH = 0.0f;
	float FISSURE_MAX_COUNT = 0.0f;
	Vector3 FISSURE_ORG = Vector3();
	Vector3 FISSURE_START = Vector3();
	string FISSURE_YAW = "FISSURE_YAW";
	float FREQ_AFK_CHECK = 0.0f;
	int GAME_PVP = 0;
	bool GAUNTLET_MAP = false;
	bool GAVE_MAP_INTRO = false;
	bool HAD_FIRST_SPAWN = false;
	int HBAR_FRAMES = 0;
	CBaseEntity@ HBAR_TARGET = null;
	bool HIDE_ARMS = false;
	bool HIDE_CHEST = false;
	bool HIDE_HEAD = false;
	bool HIDE_LEGS = false;
	bool IAM_PLAYER = false;
	bool IMMUNE_VAMPIRE = false;
	bool INIT_DMGPOINTS = false;
	string IR_GLOWING = "IR_GLOWING";
	bool IS_AFK = false;
	bool I_R_FROZEN = false;
	float LAST_STRUCK_FOR = 0.0f;
	int LEAP_BACK_DRAIN = 0;
	int LEAP_SIDE_DRAIN = 0;
	string LEGS_ANIM = "LEGS_ANIM";
	string LEVELUP_SCRIPT = "LEVELUP_SCRIPT";
	string LEVEL_UP_SCRIPT = "LEVEL_UP_SCRIPT";
	string L_VOTE_TRIG = "L_VOTE_TRIG";
	float MANARING_BONUS_RATE = 0.0f;
	string MANARING_EQUIPPED = "MANARING_EQUIPPED";
	string MOTD_TXT1 = "MOTD_TXT1";
	string MOTD_TXT2 = "MOTD_TXT2";
	string MOTD_TXT3 = "MOTD_TXT3";
	string MOTD_TXT4 = "MOTD_TXT4";
	string MOTD_TXT5 = "MOTD_TXT5";
	string MOTD_TXT6 = "MOTD_TXT6";
	string MOTD_TXT7 = "MOTD_TXT7";
	float MSC_PUSH_RESIST = 0.0f;
	float MSG_COUNTER = 0.0f;
	string MSG_TEXT = "MSG_TEXT";
	string MSG_TITLE = "MSG_TITLE";
	string MY_BODY = "MY_BODY";
	string MY_CL_BODY = "MY_CL_BODY";
	string MY_GLOW_ID = "MY_GLOW_ID";
	float MY_SPAWN_TIME = 0.0f;
	string NEW_SPAWN_POS = "NEW_SPAWN_POS";
	float NEXT_DODGE = 0.0f;
	float NEXT_HAURA_SOUND = 0.0f;
	float NEXT_LEAPBACK = 0.0f;
	float NEXT_LEAPLEFT = 0.0f;
	float NEXT_LEAPRIGHT = 0.0f;
	float NEXT_PLSHIELD_SOUND = 0.0f;
	float NEXT_REPEL_SHIELD_SOUND = 0.0f;
	float NEXT_TRANS_MESSAGE = 0.0f;
	float N_RMAP_VALIDS = 0.0f;
	string OWNER_POS = "OWNER_POS";
	string OWNER_YAW = "OWNER_YAW";
	string PLAYING_DEAD = "PLAYING_DEAD";
	float PLR_2HPEN_HEAVY = 0.0f;
	string PLR_2HPEN_HEAVY_REPORT = "PLR_2HPEN_HEAVY_REPORT";
	float PLR_2HPEN_LIGHT = 0.0f;
	string PLR_2HPEN_LIGHT_REPORT = "PLR_2HPEN_LIGHT_REPORT";
	float PLR_2H_REDUCT = 0.0f;
	string PLR_ACTIVE_PETS = "PLR_ACTIVE_PETS";
	string PLR_ACTIVE_PET_TYPES = "PLR_ACTIVE_PET_TYPES";
	string PLR_ACTIVE_VIEWMODEL = "PLR_ACTIVE_VIEWMODEL";
	CBaseEntity@ PLR_ACTIVE_WEAPON = null;
	string PLR_ADD_FIRE_DOT = "PLR_ADD_FIRE_DOT";
	string PLR_ARMOR_ID = "PLR_ARMOR_ID";
	string PLR_ARROW_ID = "PLR_ARROW_ID";
	float PLR_ARROW_MENU = 0.0f;
	CBaseEntity@ PLR_BEAR_IMAGE_ID = null;
	bool PLR_BEAR_MODE = false;
	string PLR_BODY_TYPE = "PLR_BODY_TYPE";
	bool PLR_BRAVERY = false;
	bool PLR_CHECK_SUMMON_ACTIVE = false;
	string PLR_CHECK_SUMMON_ACTIVE_TYPE = "PLR_CHECK_SUMMON_ACTIVE_TYPE";
	string PLR_COMBAT_ICON = "PLR_COMBAT_ICON";
	string PLR_CORRODE_DURATION = "PLR_CORRODE_DURATION";
	float PLR_CRE_HAND = 0.0f;
	string PLR_CRE_TYPE = "PLR_CRE_TYPE";
	string PLR_CUR_TRANS = "PLR_CUR_TRANS";
	float PLR_DARK_LEVEL = 0.0f;
	int PLR_DARK_LEVEL_LOSS_RATE = 0;
	string PLR_DAURA_CL_IDX = "PLR_DAURA_CL_IDX";
	int PLR_DBURST_AOE = 0;
	float PLR_DBURST_DMG = 0.0f;
	float PLR_DBURST_DOT = 0.0f;
	float PLR_DBURST_MAXPUSH = 0.0f;
	string PLR_DBURST_ORG = "PLR_DBURST_ORG";
	bool PLR_DBURST_PUSH = false;
	float PLR_DBURST_SKILL = 0.0f;
	bool PLR_DEBUG_ARRAY_ACTIVE = false;
	int PLR_DEL_PLAYSOUND_CHAN = 0;
	int PLR_DEL_PLAYSOUND_VOL = 0;
	string PLR_DEL_PLAYSOUND_WAV = "PLR_DEL_PLAYSOUND_WAV";
	float PLR_DEVELOPER = 0.0f;
	bool PLR_DID_MOTD = false;
	bool PLR_DID_SHENDER_EVENT = false;
	float PLR_DMG = 0.0f;
	string PLR_DMG_ADJUST_FIRE = "PLR_DMG_ADJUST_FIRE";
	float PLR_DONATOR = 0.0f;
	bool PLR_EPILEPSY_ACTIVE = false;
	float PLR_EPILEPSY_COUNT = 0.0f;
	float PLR_EPILEPSY_DELAY = 0.0f;
	bool PLR_FAURA = false;
	int PLR_FAURA_AOE = 0;
	string PLR_FAURA_CLIDX = "PLR_FAURA_CLIDX";
	float PLR_FAURA_CL_RATE = 0.0f;
	string PLR_FAURA_DOT = "PLR_FAURA_DOT";
	float PLR_FAURA_NEXT_CL = 0.0f;
	string PLR_FAURA_SCAN = "PLR_FAURA_SCAN";
	bool PLR_FEAURA = false;
	int PLR_FEAURA_AOE = 0;
	string PLR_FEAURA_CLIDX = "PLR_FEAURA_CLIDX";
	string PLR_FEAURA_DOT = "PLR_FEAURA_DOT";
	float PLR_FEAURA_NEXT_CL = 0.0f;
	string PLR_FEAURA_SCAN = "PLR_FEAURA_SCAN";
	CBaseEntity@ PLR_FISTS_ID = null;
	CBaseEntity@ PLR_FOUND_PET = null;
	bool PLR_GCOD_ACTIVE = false;
	int PLR_GCOD_AOE = 0;
	string PLR_GCOD_DMG = "PLR_GCOD_DMG";
	float PLR_GCOD_DUR = 0.0f;
	Vector3 PLR_GCOD_POS = Vector3();
	string PLR_GENDER = "PLR_GENDER";
	bool PLR_GLOW_BLOCK = false;
	bool PLR_GOT_REWARD = false;
	bool PLR_HAD_MATCHED_SET = false;
	bool PLR_HAND_SET = false;
	string PLR_HAS_GLOW = "PLR_HAS_GLOW";
	bool PLR_HAS_MATCHED_SET = false;
	float PLR_HAS_TROLLCANO = 0.0f;
	bool PLR_HAURA_ACTIVE = false;
	string PLR_HAURA_CL_ID = "PLR_HAURA_CL_ID";
	string PLR_HAURA_POWER = "PLR_HAURA_POWER";
	int PLR_HAURA_RADIUS = 0;
	string PLR_HAURA_TARGETS = "PLR_HAURA_TARGETS";
	string PLR_HELM_ID = "PLR_HELM_ID";
	bool PLR_IN_COMBAT = false;
	bool PLR_IN_WORLD = false;
	float PLR_LAST_ATK_TIME = 0.0f;
	float PLR_LAST_HBAR_SHOW = 0.0f;
	CBaseEntity@ PLR_LAST_PROJECTILE = null;
	string PLR_LAST_WORN_ARMOR = "PLR_LAST_WORN_ARMOR";
	bool PLR_LCOD_ACTIVE = false;
	int PLR_LCOD_AOE = 0;
	string PLR_LCOD_DMG = "PLR_LCOD_DMG";
	float PLR_LCOD_DUR = 0.0f;
	Vector3 PLR_LCOD_POS = Vector3();
	CBaseEntity@ PLR_LEFT_HAND = null;
	bool PLR_LESSER_LEADFOOT = false;
	float PLR_LESSER_LEADFOOT_STUN = 0.0f;
	bool PLR_LIGHTS_SYNCED = false;
	string PLR_LOCAL_TRANS = "PLR_LOCAL_TRANS";
	bool PLR_LOCK_CLEAR = false;
	string PLR_LTRAN_MAXS = "PLR_LTRAN_MAXS";
	string PLR_LTRAN_MINS = "PLR_LTRAN_MINS";
	Vector3 PLR_LTRAN_ORG = Vector3();
	bool PLR_MANA_FONT = false;
	int PLR_MAX_DARK_LEVEL = 0;
	float PLR_NEXT_FSAURA_SOUND = 0.0f;
	float PLR_NEXT_GCOD_SOUND = 0.0f;
	float PLR_NEXT_HASTE = 0.0f;
	float PLR_NEXT_LCOD_SOUND = 0.0f;
	float PLR_NEXT_SCROLL = 0.0f;
	float PLR_NEXT_STUCK_ADJ = 0.0f;
	string PLR_NEXT_TRANS = "PLR_NEXT_TRANS";
	float PLR_N_ACTIVE_PETS = 0.0f;
	string PLR_OLOF_STATUS = "PLR_OLOF_STATUS";
	int PLR_ORCFOR_MUSIC = 0;
	bool PLR_PAURA = false;
	int PLR_PAURA_AOE = 0;
	string PLR_PAURA_CLIDX = "PLR_PAURA_CLIDX";
	float PLR_PAURA_CL_RATE = 0.0f;
	string PLR_PAURA_DOT = "PLR_PAURA_DOT";
	float PLR_PAURA_NEXT_CL = 0.0f;
	string PLR_PAURA_SCAN = "PLR_PAURA_SCAN";
	bool PLR_PBOLT_ACTIVE = false;
	int PLR_PBOLT_AOE = 0;
	string PLR_PBOLT_ARRAY = "PLR_PBOLT_ARRAY";
	float PLR_PBOLT_COUNTER = 0.0f;
	float PLR_PBOLT_DOT = 0.0f;
	string PLR_PBOLT_ORG = "PLR_PBOLT_ORG";
	string PLR_PBOLT_TARGS = "PLR_PBOLT_TARGS";
	string PLR_PET_IDS = "PLR_PET_IDS";
	string PLR_PET_LIST = "PLR_PET_LIST";
	string PLR_PET_TYPES = "PLR_PET_TYPES";
	bool PLR_PLSHIELD_ACTIVE = false;
	string PLR_PLSHIELD_CL_IDX = "PLR_PLSHIELD_CL_IDX";
	float PLR_PLSHIELD_DOT = 0.0f;
	int PLR_PLSHIELD_PUSH = 0;
	string PLR_PLSHIELD_TARGETS = "PLR_PLSHIELD_TARGETS";
	Vector3 PLR_PRECHEAT_POS = Vector3();
	string PLR_PREV_BODY_TYPE = "PLR_PREV_BODY_TYPE";
	float PLR_REPEL_MAX_HP = 0.0f;
	Vector3 PLR_REPEL_ORG = Vector3();
	int PLR_REPEL_PUSH_STR = 0;
	bool PLR_REPEL_SHIELD_ACTIVE = false;
	int PLR_REPEL_SHIELD_RADIUS = 0;
	string PLR_REPEL_SHIELD_SPECIAL = "PLR_REPEL_SHIELD_SPECIAL";
	string PLR_REPEL_SHIELD_TARGETS = "PLR_REPEL_SHIELD_TARGETS";
	float PLR_RESET_BANK = 0.0f;
	CBaseEntity@ PLR_RIGHT_HAND = null;
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool PLR_SFAURA_ACTIVE = false;
	string PLR_SFAURA_CL_IDX = "PLR_SFAURA_CL_IDX";
	float PLR_SFAURA_DOT = 0.0f;
	int PLR_SFAURA_GROWTH_RATE = 0;
	CBaseEntity@ PLR_SFAURA_ITEM = null;
	float PLR_SFAURA_MAXPUSH = 0.0f;
	int PLR_SFAURA_MAXSIZE = 0;
	int PLR_SFAURA_MP_COST = 0;
	float PLR_SFAURA_SIZE = 0.0f;
	string PLR_SFAURA_TARGS = "PLR_SFAURA_TARGS";
	bool PLR_SHIELD_UP = false;
	string PLR_SOCCER_TEAMSPR = "PLR_SOCCER_TEAMSPR";
	string PLR_SOUND_ARMHIT1 = "PLR_SOUND_ARMHIT1";
	string PLR_SOUND_BREATHFAST1 = "PLR_SOUND_BREATHFAST1";
	string PLR_SOUND_BREATHFAST2 = "PLR_SOUND_BREATHFAST2";
	string PLR_SOUND_BREATHFAST3 = "PLR_SOUND_BREATHFAST3";
	string PLR_SOUND_CHESTHIT1 = "PLR_SOUND_CHESTHIT1";
	string PLR_SOUND_DEATH = "PLR_SOUND_DEATH";
	string PLR_SOUND_FALLPAIN1 = "PLR_SOUND_FALLPAIN1";
	string PLR_SOUND_FALLPAIN2 = "PLR_SOUND_FALLPAIN2";
	string PLR_SOUND_FALLPAIN3 = "PLR_SOUND_FALLPAIN3";
	string PLR_SOUND_FALLPAIN4 = "PLR_SOUND_FALLPAIN4";
	string PLR_SOUND_JAB1 = "PLR_SOUND_JAB1";
	string PLR_SOUND_JAB2 = "PLR_SOUND_JAB2";
	string PLR_SOUND_LEGHIT1 = "PLR_SOUND_LEGHIT1";
	string PLR_SOUND_SHOUT1 = "PLR_SOUND_SHOUT1";
	string PLR_SOUND_STOMACHHIT1 = "PLR_SOUND_STOMACHHIT1";
	string PLR_SOUND_SWORDREADY = "PLR_SOUND_SWORDREADY";
	string PLR_SPEAR_CHARGE_LEVEL = "PLR_SPEAR_CHARGE_LEVEL";
	bool PLR_SPECIAL_WEAPON = false;
	int PLR_SPEED = 0;
	string PLR_SPIDER_AMT = "PLR_SPIDER_AMT";
	bool PLR_SPIDER_PROT = false;
	bool PLR_STARTED_AFK_CHECKS = false;
	float PLR_SUMMON_MENU_DISABLE = 0.0f;
	int PLR_SWIFT_BLADE = 0;
	string PLR_TOD_LOCK = "PLR_TOD_LOCK";
	float PLR_TOTAL_DMG = 0.0f;
	string PLR_UNIQUE_SUMMONS = "PLR_UNIQUE_SUMMONS";
	string PLR_URDUAL_RELEASE_TIME = "PLR_URDUAL_RELEASE_TIME";
	string PLR_WEATHER = "PLR_WEATHER";
	string PLR_WEATHER_BLOCK = "PLR_WEATHER_BLOCK";
	bool PLR_WRAITH_ACTIVE = false;
	bool PL_BEEN_ATTACKED = false;
	bool PL_I_R_FROZEN = false;
	string PL_PARRY = "PL_PARRY";
	float PL_TIME = 0.0f;
	bool REGEN_ON = false;
	float REGEN_RATE = 0.0f;
	string RMAP_SERIES_START = "RMAP_SERIES_START";
	string RMAP_SERIES_TITLE = "RMAP_SERIES_TITLE";
	string RMAP_TYPE = "RMAP_TYPE";
	bool RMAP_VALIDATED_GAUNTLET = false;
	string RMAP_VALID_FROM = "RMAP_VALID_FROM";
	bool SCARABS_ATTACHED = false;
	bool SCROLL_WARNING_LEVEL = false;
	bool SEND_DMG_DELAY = false;
	string SHOW_HEALTH = "SHOW_HEALTH";
	float SIZE_IDX = 0.0f;
	string SOUNDSET_HF_ARMHIT1 = "SOUNDSET_HF_ARMHIT1";
	string SOUNDSET_HF_BREATHFAST1 = "SOUNDSET_HF_BREATHFAST1";
	string SOUNDSET_HF_BREATHFAST2 = "SOUNDSET_HF_BREATHFAST2";
	string SOUNDSET_HF_BREATHFAST3 = "SOUNDSET_HF_BREATHFAST3";
	string SOUNDSET_HF_CHESTHIT1 = "SOUNDSET_HF_CHESTHIT1";
	string SOUNDSET_HF_DEATH = "SOUNDSET_HF_DEATH";
	string SOUNDSET_HF_FALLPAIN1 = "SOUNDSET_HF_FALLPAIN1";
	string SOUNDSET_HF_FALLPAIN2 = "SOUNDSET_HF_FALLPAIN2";
	string SOUNDSET_HF_FALLPAIN3 = "SOUNDSET_HF_FALLPAIN3";
	string SOUNDSET_HF_FALLPAIN4 = "SOUNDSET_HF_FALLPAIN4";
	string SOUNDSET_HF_JAB1 = "SOUNDSET_HF_JAB1";
	string SOUNDSET_HF_JAB2 = "SOUNDSET_HF_JAB2";
	string SOUNDSET_HF_LEGHIT1 = "SOUNDSET_HF_LEGHIT1";
	string SOUNDSET_HF_SHOUT1 = "SOUNDSET_HF_SHOUT1";
	string SOUNDSET_HF_STOMACHHIT1 = "SOUNDSET_HF_STOMACHHIT1";
	string SOUNDSET_HF_SWORDREADY = "SOUNDSET_HF_SWORDREADY";
	string SOUNDSET_HM_ARMHIT1 = "SOUNDSET_HM_ARMHIT1";
	string SOUNDSET_HM_BREATHFAST1 = "SOUNDSET_HM_BREATHFAST1";
	string SOUNDSET_HM_BREATHFAST2 = "SOUNDSET_HM_BREATHFAST2";
	string SOUNDSET_HM_BREATHFAST3 = "SOUNDSET_HM_BREATHFAST3";
	string SOUNDSET_HM_CHESTHIT1 = "SOUNDSET_HM_CHESTHIT1";
	string SOUNDSET_HM_DEATH = "SOUNDSET_HM_DEATH";
	string SOUNDSET_HM_FALLPAIN1 = "SOUNDSET_HM_FALLPAIN1";
	string SOUNDSET_HM_FALLPAIN2 = "SOUNDSET_HM_FALLPAIN2";
	string SOUNDSET_HM_FALLPAIN3 = "SOUNDSET_HM_FALLPAIN3";
	string SOUNDSET_HM_FALLPAIN4 = "SOUNDSET_HM_FALLPAIN4";
	string SOUNDSET_HM_JAB1 = "SOUNDSET_HM_JAB1";
	string SOUNDSET_HM_JAB2 = "SOUNDSET_HM_JAB2";
	string SOUNDSET_HM_LEGHIT1 = "SOUNDSET_HM_LEGHIT1";
	string SOUNDSET_HM_SHOUT1 = "SOUNDSET_HM_SHOUT1";
	string SOUNDSET_HM_STOMACHHIT1 = "SOUNDSET_HM_STOMACHHIT1";
	string SOUNDSET_HM_SWORDREADY = "SOUNDSET_HM_SWORDREADY";
	string SOUND_BEAR_STRUCK1 = "SOUND_BEAR_STRUCK1";
	string SOUND_BEAR_STRUCK2 = "SOUND_BEAR_STRUCK2";
	string SOUND_BEAR_STRUCK3 = "SOUND_BEAR_STRUCK3";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_LEVELUP1 = "SOUND_LEVELUP1";
	string SPIRAL_DMG = "SPIRAL_DMG";
	string SPIRAL_DMG_TYPE = "SPIRAL_DMG_TYPE";
	Vector3 SPIRAL_GLOW_COLOR = Vector3();
	string SPIRAL_SKILL = "SPIRAL_SKILL";
	string SPIRAL_SPIRTE_FILE = "SPIRAL_SPIRTE_FILE";
	Vector3 SPIRAL_SPRITE_COLOR = Vector3();
	int SPIRAL_SPRITE_FRAMES = 0;
	float SPIRAL_SPRITE_SCALE = 0.0f;
	bool STARTED_VOTE = false;
	string S_DESTNAME = "S_DESTNAME";
	string S_TRANNAME = "S_TRANNAME";
	string TARGET_PET_TYPE = "TARGET_PET_TYPE";
	string THIS_MAP = "THIS_MAP";
	string TORSO_ANIM = "TORSO_ANIM";
	string T_SPHERE = "T_SPHERE";
	string VALID_MAP_LIST_ENGLISH = "VALID_MAP_LIST_ENGLISH";
	string VALID_START_MAP = "VALID_START_MAP";
	float VAMPIRE_MULTI = 0.0f;
	bool VAMPIRE_ON = false;
	bool VOTE_DISABLED = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementResist_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ElementResist_DispatchEvent(name, params);
	}
}
