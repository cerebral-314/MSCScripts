#pragma context server

// Converted from player/externals.script by msc_transpiler.
// External Calls for various effects stored on players

#include "runtime/ScriptEntity.as"
// #include test_scripts/player_externals - not found (optional)
#include "converted/developer/player/externals.as"
// #include $currentmap_player_externals - not found (optional)
#include "converted/items/base_vampire.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerExternals
{
	// Constants
	string PLR_COMBAT_ICON = "hud/status/alpha_poison_immune";
	int PLR_LCOD_AOE = 90;
	int PLR_GCOD_AOE = 180;
	float PLR_2HPEN_LIGHT = 0.7f;
	string PLR_2HPEN_LIGHT_REPORT = "30%";
	float PLR_2HPEN_HEAVY = 0.6f;
	string PLR_2HPEN_HEAVY_REPORT = "40%";
	float VAMPIRE_MULTI = 0.35f;
	float PLR_FAURA_CL_RATE = 10.0f;
	float PLR_PAURA_CL_RATE = 30.0f;
	int PLR_SFAURA_MP_COST = 2;
	int PLR_SFAURA_MAXSIZE = 175;
	int PLR_SFAURA_GROWTH_RATE = 2;
	string SOUNDSET_HM_SWORDREADY = "player/swordready.wav";
	string SOUNDSET_HM_SHOUT1 = "player/shout1.wav";
	string SOUNDSET_HM_JAB1 = "player/jab1.wav";
	string SOUNDSET_HM_JAB2 = "player/jab2.wav";
	string SOUNDSET_HM_BREATHFAST1 = "player/breathe_fast1.wav";
	string SOUNDSET_HM_BREATHFAST2 = "player/breathe_fast2.wav";
	string SOUNDSET_HM_BREATHFAST3 = "player/breathe_fast3.wav";
	string SOUNDSET_HM_DEATH = "player/death.wav";
	string SOUNDSET_HM_CHESTHIT1 = "player/chesthit1.wav";
	string SOUNDSET_HM_STOMACHHIT1 = "player/stomachhit1.wav";
	string SOUNDSET_HM_ARMHIT1 = "player/armhit1.wav";
	string SOUNDSET_HM_LEGHIT1 = "player/leghit1.wav";
	string SOUNDSET_HM_FALLPAIN1 = "player/fallpain1.wav";
	string SOUNDSET_HM_FALLPAIN2 = "player/fallpain2.wav";
	string SOUNDSET_HM_FALLPAIN3 = "player/fallpain3.wav";
	string SOUNDSET_HM_FALLPAIN4 = "player/fallpain4.wav";
	string SOUNDSET_HF_SWORDREADY = "player/Femaleswordready.wav";
	string SOUNDSET_HF_SHOUT1 = "player/Femaleshout1.wav";
	string SOUNDSET_HF_JAB1 = "player/Femalejab1.wav";
	string SOUNDSET_HF_JAB2 = "player/Femalejab2.wav";
	string SOUNDSET_HF_BREATHFAST1 = "player/Femalebreathe_fast1.wav";
	string SOUNDSET_HF_BREATHFAST2 = "player/Femalebreathe_fast2.wav";
	string SOUNDSET_HF_BREATHFAST3 = "player/Femalebreathe_fast3.wav";
	string SOUNDSET_HF_DEATH = "player/FemaleDeath.wav";
	string SOUNDSET_HF_CHESTHIT1 = "player/Femalechesthit1.wav";
	string SOUNDSET_HF_STOMACHHIT1 = "player/Femalestomachhit1.wav";
	string SOUNDSET_HF_ARMHIT1 = "player/Femalearmhit1.wav";
	string SOUNDSET_HF_LEGHIT1 = "player/Femaleleghit1.wav";
	string SOUNDSET_HF_FALLPAIN1 = "player/Femalefallpain1.wav";
	string SOUNDSET_HF_FALLPAIN2 = "player/Femalefallpain2.wav";
	string SOUNDSET_HF_FALLPAIN3 = "player/Femalefallpain3.wav";
	string SOUNDSET_HF_FALLPAIN4 = "player/Femalefallpain4.wav";

	// Variables (an unset .script variable reads as its own name)
	bool PLR_HAND_SET = false;
	string PLR_UNIQUE_SUMMONS = "PLR_UNIQUE_SUMMONS";
	bool SCROLL_WARNING_LEVEL = false;
	string PLR_PET_TYPES = "PLR_PET_TYPES";
	string PLR_PET_IDS = "PLR_PET_IDS";
	bool EXT_EFFECT_LIST = false;
	bool IAM_PLAYER = false;
	string MY_GLOW_ID = "MY_GLOW_ID";
	string NEW_SPAWN_POS = "NEW_SPAWN_POS";
	string MY_BODY = "MY_BODY";
	string MY_CL_BODY = "MY_CL_BODY";
	bool HIDE_LEGS = false;
	bool HIDE_HEAD = false;
	bool HIDE_CHEST = false;
	bool HIDE_ARMS = false;
	int ARMOR_EQUIPED = 0;
	string ARMOR_TYPE = "ARMOR_TYPE";
	string ARMOR_OFS = "ARMOR_OFS";
	bool REGEN_ON = false;
	float REGEN_RATE = 0.0f;
	bool VAMPIRE_ON = false;
	bool IMMUNE_VAMPIRE = false;
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool I_R_FROZEN = false;
	bool PL_I_R_FROZEN = false;
	string EXT_REMOVE_EFFECT = "EXT_REMOVE_EFFECT";
	bool PLR_SPIDER_PROT = false;
	string PLR_SPIDER_AMT = "PLR_SPIDER_AMT";
	string ALCO_TYPE = "ALCO_TYPE";
	CBaseEntity@ ALCO_SPAWN_ITEM = null;
	int PLR_SWIFT_BLADE = 0;
	CBaseEntity@ PLR_LEFT_HAND = null;
	CBaseEntity@ PLR_RIGHT_HAND = null;
	CBaseEntity@ PLR_ACTIVE_WEAPON = null;
	bool PLR_SPECIAL_WEAPON = false;
	string PL_PARRY = "PL_PARRY";
	bool PLR_HAS_MATCHED_SET = false;
	float PLR_2H_REDUCT = 0.0f;
	bool PLR_HAD_MATCHED_SET = false;
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	bool VOTE_DISABLED = false;
	string OWNER_POS = "OWNER_POS";
	float BEAM_ROT = 0.0f;
	float PLR_NEXT_SCROLL = 0.0f;
	bool PLR_GOT_REWARD = false;
	string PLR_CUR_TRANS = "PLR_CUR_TRANS";
	string PLR_NEXT_TRANS = "PLR_NEXT_TRANS";
	string T_SPHERE = "T_SPHERE";
	string TARGET_PET_TYPE = "TARGET_PET_TYPE";
	CBaseEntity@ PLR_FOUND_PET = null;
	bool PLR_GLOW_BLOCK = false;
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool PLR_FAURA = false;
	string PLR_FAURA_DOT = "PLR_FAURA_DOT";
	int PLR_FAURA_AOE = 0;
	int GAME_PVP = 0;
	string PLR_FAURA_CLIDX = "PLR_FAURA_CLIDX";
	float PLR_FAURA_NEXT_CL = 0.0f;
	string PLR_FAURA_SCAN = "PLR_FAURA_SCAN";
	bool PLR_PAURA = false;
	string PLR_PAURA_DOT = "PLR_PAURA_DOT";
	int PLR_PAURA_AOE = 0;
	string PLR_PAURA_CLIDX = "PLR_PAURA_CLIDX";
	float PLR_PAURA_NEXT_CL = 0.0f;
	string PLR_PAURA_SCAN = "PLR_PAURA_SCAN";
	string PLR_PREV_BODY_TYPE = "PLR_PREV_BODY_TYPE";
	string PLR_BODY_TYPE = "PLR_BODY_TYPE";
	string PLR_LAST_WORN_ARMOR = "PLR_LAST_WORN_ARMOR";
	string PLR_HELM_ID = "PLR_HELM_ID";
	string PLR_ARMOR_ID = "PLR_ARMOR_ID";
	string PLR_TOD_LOCK = "PLR_TOD_LOCK";
	string PLR_URDUAL_RELEASE_TIME = "PLR_URDUAL_RELEASE_TIME";
	string PLR_GENDER = "PLR_GENDER";
	string PLR_SOUND_SWORDREADY = "PLR_SOUND_SWORDREADY";
	string PLR_SOUND_SHOUT1 = "PLR_SOUND_SHOUT1";
	string PLR_SOUND_JAB1 = "PLR_SOUND_JAB1";
	string PLR_SOUND_JAB2 = "PLR_SOUND_JAB2";
	string PLR_SOUND_BREATHFAST1 = "PLR_SOUND_BREATHFAST1";
	string PLR_SOUND_BREATHFAST2 = "PLR_SOUND_BREATHFAST2";
	string PLR_SOUND_BREATHFAST3 = "PLR_SOUND_BREATHFAST3";
	string PLR_SOUND_DEATH = "PLR_SOUND_DEATH";
	string PLR_SOUND_CHESTHIT1 = "PLR_SOUND_CHESTHIT1";
	string PLR_SOUND_STOMACHHIT1 = "PLR_SOUND_STOMACHHIT1";
	string PLR_SOUND_ARMHIT1 = "PLR_SOUND_ARMHIT1";
	string PLR_SOUND_LEGHIT1 = "PLR_SOUND_LEGHIT1";
	string PLR_SOUND_FALLPAIN1 = "PLR_SOUND_FALLPAIN1";
	string PLR_SOUND_FALLPAIN2 = "PLR_SOUND_FALLPAIN2";
	string PLR_SOUND_FALLPAIN3 = "PLR_SOUND_FALLPAIN3";
	string PLR_SOUND_FALLPAIN4 = "PLR_SOUND_FALLPAIN4";
	string SPIRAL_DMG = "SPIRAL_DMG";
	string SPIRAL_SKILL = "SPIRAL_SKILL";
	string SPIRAL_DMG_TYPE = "SPIRAL_DMG_TYPE";
	string SPIRAL_SPIRTE_FILE = "SPIRAL_SPIRTE_FILE";
	int SPIRAL_SPRITE_FRAMES = 0;
	float SPIRAL_SPRITE_SCALE = 0.0f;
	Vector3 SPIRAL_SPRITE_COLOR = Vector3();
	Vector3 SPIRAL_GLOW_COLOR = Vector3();
	CBaseEntity@ PLR_BEAR_IMAGE_ID = null;
	bool PLR_BEAR_MODE = false;
	string PLR_WEATHER_BLOCK = "PLR_WEATHER_BLOCK";
	float PLR_NEXT_STUCK_ADJ = 0.0f;
	string PLR_OLOF_STATUS = "PLR_OLOF_STATUS";
	bool PLR_FEAURA = false;
	string PLR_FEAURA_DOT = "PLR_FEAURA_DOT";
	int PLR_FEAURA_AOE = 0;
	string PLR_FEAURA_CLIDX = "PLR_FEAURA_CLIDX";
	float PLR_FEAURA_NEXT_CL = 0.0f;
	string PLR_FEAURA_SCAN = "PLR_FEAURA_SCAN";
	string PLR_WEATHER = "PLR_WEATHER";
	bool PLR_REPEL_SHIELD_ACTIVE = false;
	int PLR_REPEL_SHIELD_RADIUS = 0;
	string PLR_REPEL_SHIELD_SPECIAL = "PLR_REPEL_SHIELD_SPECIAL";
	string PLR_DAURA_CL_IDX = "PLR_DAURA_CL_IDX";
	string PLR_REPEL_SHIELD_TARGETS = "PLR_REPEL_SHIELD_TARGETS";
	float NEXT_REPEL_SHIELD_SOUND = 0.0f;
	float PLR_DARK_LEVEL = 0.0f;
	CBaseEntity@ PLR_LAST_PROJECTILE = null;
	float PLR_SFAURA_SIZE = 0.0f;
	CBaseEntity@ PLR_SFAURA_ITEM = null;
	float PLR_SFAURA_DOT = 0.0f;
	float PLR_SFAURA_MAXPUSH = 0.0f;
	string PLR_SFAURA_CL_IDX = "PLR_SFAURA_CL_IDX";
	bool PLR_SFAURA_ACTIVE = false;
	string PLR_SFAURA_TARGS = "PLR_SFAURA_TARGS";
	float PLR_NEXT_FSAURA_SOUND = 0.0f;
	string PLR_SPEAR_CHARGE_LEVEL = "PLR_SPEAR_CHARGE_LEVEL";
	bool PLR_HAURA_ACTIVE = false;
	int PLR_HAURA_RADIUS = 0;
	string PLR_HAURA_POWER = "PLR_HAURA_POWER";
	string PLR_HAURA_CL_ID = "PLR_HAURA_CL_ID";
	string PLR_HAURA_TARGETS = "PLR_HAURA_TARGETS";
	float NEXT_HAURA_SOUND = 0.0f;
	bool PLR_PLSHIELD_ACTIVE = false;
	float PLR_PLSHIELD_DOT = 0.0f;
	int PLR_PLSHIELD_PUSH = 0;
	string PLR_PLSHIELD_CL_IDX = "PLR_PLSHIELD_CL_IDX";
	string OWNER_YAW = "OWNER_YAW";
	string PLR_PLSHIELD_TARGETS = "PLR_PLSHIELD_TARGETS";
	float NEXT_PLSHIELD_SOUND = 0.0f;
	bool PLR_LOCK_CLEAR = false;
	bool PLR_BRAVERY = false;
	string PLR_DMG_ADJUST_FIRE = "PLR_DMG_ADJUST_FIRE";
	string PLR_ADD_FIRE_DOT = "PLR_ADD_FIRE_DOT";
	int PLR_ORCFOR_MUSIC = 0;
	float AFL_BURST_DOT = 0.0f;
	int PLR_REPEL_PUSH_STR = 0;
	float PLR_REPEL_MAX_HP = 0.0f;
	Vector3 PLR_REPEL_ORG = Vector3();
	Vector3 PLR_LCOD_POS = Vector3();
	string PLR_LCOD_DMG = "PLR_LCOD_DMG";
	float PLR_LCOD_DUR = 0.0f;
	float PLR_NEXT_LCOD_SOUND = 0.0f;
	bool PLR_LCOD_ACTIVE = false;
	Vector3 PLR_GCOD_POS = Vector3();
	string PLR_GCOD_DMG = "PLR_GCOD_DMG";
	float PLR_GCOD_DUR = 0.0f;
	float PLR_NEXT_GCOD_SOUND = 0.0f;
	bool PLR_GCOD_ACTIVE = false;
	bool PLR_WRAITH_ACTIVE = false;
	string FISSURE_YAW = "FISSURE_YAW";
	Vector3 FISSURE_START = Vector3();
	Vector3 FISSURE_END = Vector3();
	float FISSURE_LENGTH = 0.0f;
	float FISSURE_COUNT = 0.0f;
	bool FISSURE_ACTIVE = false;
	float FISSURE_DMG = 0.0f;
	float FISSURE_MAX_COUNT = 0.0f;
	Vector3 FISSURE_ORG = Vector3();
	Vector3 FISSURE_DIR = Vector3();
	bool PLR_EPILEPSY_ACTIVE = false;
	float PLR_EPILEPSY_COUNT = 0.0f;
	float PLR_EPILEPSY_DELAY = 0.0f;
	string PLR_ACTIVE_PETS = "PLR_ACTIVE_PETS";
	string PLR_ACTIVE_PET_TYPES = "PLR_ACTIVE_PET_TYPES";
	float PLR_N_ACTIVE_PETS = 0.0f;
	float PLR_SUMMON_MENU_DISABLE = 0.0f;
	CBaseEntity@ PLR_FISTS_ID = null;
	bool PLR_LESSER_LEADFOOT = false;
	float PLR_LESSER_LEADFOOT_STUN = 0.0f;
	int PLR_DEL_PLAYSOUND_CHAN = 0;
	int PLR_DEL_PLAYSOUND_VOL = 0;
	string PLR_DEL_PLAYSOUND_WAV = "PLR_DEL_PLAYSOUND_WAV";
	float PLR_CRE_HAND = 0.0f;
	string PLR_CRE_TYPE = "PLR_CRE_TYPE";
	string PLR_HAS_GLOW = "PLR_HAS_GLOW";
	string IR_GLOWING = "IR_GLOWING";
	string PLR_SOCCER_TEAMSPR = "PLR_SOCCER_TEAMSPR";
	bool PLR_DID_SHENDER_EVENT = false;
	float PLR_NEXT_HASTE = 0.0f;
	string PLR_CORRODE_DURATION = "PLR_CORRODE_DURATION";
	float PLR_RESET_BANK = 0.0f;
	bool PLR_IN_COMBAT = false;
	string PLR_LOCAL_TRANS = "PLR_LOCAL_TRANS";
	Vector3 PLR_LTRAN_ORG = Vector3();
	string PLR_LTRAN_MINS = "PLR_LTRAN_MINS";
	string PLR_LTRAN_MAXS = "PLR_LTRAN_MAXS";
	bool IS_AFK = false;
	float PLR_LAST_ATK_TIME = 0.0f;
	int PLR_PBOLT_AOE = 0;
	bool PLR_PBOLT_ACTIVE = false;
	float PLR_PBOLT_COUNTER = 0.0f;
	float PLR_PBOLT_DOT = 0.0f;
	string PLR_PBOLT_ARRAY = "PLR_PBOLT_ARRAY";
	string PLR_PBOLT_ORG = "PLR_PBOLT_ORG";
	string PLR_PBOLT_TARGS = "PLR_PBOLT_TARGS";
	string PLR_ACTIVE_VIEWMODEL = "PLR_ACTIVE_VIEWMODEL";
	bool PLR_DEBUG_ARRAY_ACTIVE = false;
	bool PLR_SHIELD_UP = false;
	string PLR_DBURST_ORG = "PLR_DBURST_ORG";
	int PLR_DBURST_AOE = 0;
	bool PLR_DBURST_PUSH = false;
	float PLR_DBURST_SKILL = 0.0f;
	float PLR_DBURST_DMG = 0.0f;
	float PLR_DBURST_DOT = 0.0f;
	float PLR_DBURST_MAXPUSH = 0.0f;

	// unnamed block (first think)
	void PlayerExternals_FirstThink()
	{
		PLR_HAND_SET = false; // future use, determines arm indexes of viewmodels
		PLR_UNIQUE_SUMMONS = "";

		SCROLL_WARNING_LEVEL = false;

		PLR_PET_TYPES = "";
		PLR_PET_IDS = "";

		EXT_EFFECT_LIST = false;

		IAM_PLAYER = true; // since $get(ent_xx,isplayer) doesn't seem to work for items

		ArrayCreate("ARRAY_JUMP_BEAM_IDS");
		ArrayCreate("ARRAY_JUMP_BEAM_TARGS");
	}

	// fake_sound_precache
	void PlayerExternals_OnFakeSoundPrecache()
	{
		// this event never happens, but should force precaches
		ServerPlaySound(1, 0, "magic/volcano_loop.wav");
		ServerPlaySound(1, 0, "weapons/polearm_spin.wav");
		ServerPlaySound(1, 0, "ambience/pulsemachine.wav");
		ServerPlaySound(1, 0, "ambience/dronemachine1.wav");
		ServerPlaySound(1, 0, "monsters/bear/c_beardire_bat1.wav");
		ServerPlaySound(1, 0, "monsters/goblin/sps_fogfire.wav");

		ServerPlaySound(1, 0, SOUNDSET_HM_SWORDREADY);
		ServerPlaySound(1, 0, SOUNDSET_HM_SHOUT1);
		ServerPlaySound(1, 0, SOUNDSET_HM_JAB1);
		ServerPlaySound(1, 0, SOUNDSET_HM_JAB2);
		ServerPlaySound(1, 0, SOUNDSET_HM_BREATHFAST1);
		ServerPlaySound(1, 0, SOUNDSET_HM_BREATHFAST2);
		ServerPlaySound(1, 0, SOUNDSET_HM_BREATHFAST3);
		ServerPlaySound(1, 0, SOUNDSET_HM_DEATH);
		ServerPlaySound(1, 0, SOUNDSET_HM_CHESTHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HM_STOMACHHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HM_ARMHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HM_LEGHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HM_FALLPAIN1);
		ServerPlaySound(1, 0, SOUNDSET_HM_FALLPAIN2);
		ServerPlaySound(1, 0, SOUNDSET_HM_FALLPAIN3);
		ServerPlaySound(1, 0, SOUNDSET_HM_FALLPAIN4);

		ServerPlaySound(1, 0, SOUNDSET_HF_SWORDREADY);
		ServerPlaySound(1, 0, SOUNDSET_HF_SHOUT1);
		ServerPlaySound(1, 0, SOUNDSET_HF_JAB1);
		ServerPlaySound(1, 0, SOUNDSET_HF_JAB2);
		ServerPlaySound(1, 0, SOUNDSET_HF_BREATHFAST1);
		ServerPlaySound(1, 0, SOUNDSET_HF_BREATHFAST2);
		ServerPlaySound(1, 0, SOUNDSET_HF_BREATHFAST3);
		ServerPlaySound(1, 0, SOUNDSET_HF_DEATH);
		ServerPlaySound(1, 0, SOUNDSET_HF_CHESTHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HF_STOMACHHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HF_ARMHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HF_LEGHIT1);
		ServerPlaySound(1, 0, SOUNDSET_HF_FALLPAIN1);
		ServerPlaySound(1, 0, SOUNDSET_HF_FALLPAIN2);
		ServerPlaySound(1, 0, SOUNDSET_HF_FALLPAIN3);
		ServerPlaySound(1, 0, SOUNDSET_HF_FALLPAIN4);
	}

	// game_scriptflag_update
	// <action> <name> [type] [value] [base_expire_time]
	void PlayerExternals_OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f)
	{
		bool checkExpire = false;

		DebugPrint("game_scriptflag_update " + action + " " + flagName + " " + flagType + " " + Text(value) + " " + Text(baseExpireTime));

		// handle flags
		// nopush
		if (Truthy(ScriptFlag(ENT_ME, "nopush", "type_exists")))
			SetNoPush(true);
		else
			SetNoPush(false);

		// handle check for expire
		if (action == "add")
			checkExpire = true;
		if (action == "edit")
		{
			// dbg game_scriptflag_update edit updated expire times
			checkExpire = true;
		}

		if (!checkExpire)
			return;

		float checkExptime = baseExpireTime;

		if (checkExptime > -1.0f)
		{
			checkExptime += 0.1f;
			CallEventDelayed(checkExptime, "check_flags_expired");
		}
	}

	// ext_set_status_flag
	// <name_id> <type> <value> <expires:secs|-1> <message:msg|none>
	void PlayerExternals_OnExtSetStatusFlag(string nameId = "", string type = "", int value = 0, int expires = 0, string message = "")
	{
		ScriptFlags(ENT_ME, "add", nameId, type, value, expires, message);
		OnCheckFlags();
	}

	// check_flags
	void PlayerExternals_OnCheckFlags()
	{
		if (Truthy(ScriptFlag(ENT_ME, "mana_regen", "type_exists")))
			OnExtManaRegenLoop();
	}

	// check_flags_expired
	void PlayerExternals_OnCheckFlagsExpired()
	{
		DebugPrint("check_flags_expired");
		ScriptFlags(ENT_ME, "remove_expired");
		CallExternal(ENT_ME, "ext_scriptflag_expired");
	}

	// ext_remove_status_flag
	// <name_id>
	void PlayerExternals_OnExtRemoveStatusFlag(string nameId = "")
	{
		ScriptFlags(ENT_ME, "remove", nameId);
	}

	// ext_remove_status_flags_type
	// <type>
	void PlayerExternals_OnExtRemoveStatusFlagsType(string flagType = "")
	{
		DebugPrint("ext_remove_status_flags_type " + flagType);
		ScriptFlags(ENT_ME, "cleartype", flagType);
	}

	// game_hitbodypart
	// <generic|head|chest|stomach|larm|rarm|rleg|lleg>
	void PlayerExternals_OnGameHitbodypart(string bodyPart = "")
	{
		DebugPrint("game_hitbodypart " + bodyPart);
		if (RandomInt(1, 5) != 1)
			return;
		if (bodyPart == "chest")
			ServerPlaySound(2, 10, PLR_SOUND_CHESTHIT1);
		if (bodyPart == "stomach")
			ServerPlaySound(2, 10, PLR_SOUND_STOMACHHIT1);
		if (bodyPart == "larm")
			ServerPlaySound(2, 10, PLR_SOUND_ARMHIT1);
		if (bodyPart == "rarm")
			ServerPlaySound(2, 10, PLR_SOUND_ARMHIT1);
		if (bodyPart == "rleg")
			ServerPlaySound(2, 10, PLR_SOUND_LEGHIT1);
		if (bodyPart == "lleg")
			ServerPlaySound(2, 10, PLR_SOUND_LEGHIT1);
	}

	// game_fall
	void PlayerExternals_OnGameFall()
	{
		// dbg game_fallpain_sound
		LegacyCommand("svplayrandomsound", 2, 10, PLR_SOUND_FALLPAIN1, PLR_SOUND_FALLPAIN2, PLR_SOUND_FALLPAIN3, PLR_SOUND_FALLPAIN4);
	}

	// set_glow_id
	void PlayerExternals_OnSetGlowId(string glowId = "")
	{
		// storing glow light ID in an effort to be able to turn it off later
		// this method never really seemed to work, it may no longer be in use
		MY_GLOW_ID = glowId;
	}

	// set_stun_prot
	void PlayerExternals_OnSetStunProt(float stunProtection = 0.0f)
	{
		SetDamageTaken("stun", stunProtection);
	}

	// set_spawn_point
	void PlayerExternals_OnSetSpawnPoint(string spawnPosition = "")
	{
		// dbg temp Set new spawn point to PARAM1
		NEW_SPAWN_POS = spawnPosition;
	}

	// register_body
	// param1 body ent to register
	void PlayerExternals_OnRegisterBody(string body = "", string clientBody = "")
	{
		// dbg temp Registered Body
		MY_BODY = body;
		MY_CL_BODY = clientBody;
	}

	// hide_body_parts
	// ARMOR_REPLACE_BODYPARTS
	void PlayerExternals_OnHideBodyParts(string bodyParts = "")
	{
		// dbg hide_body_parts got PARAM1
		HIDE_LEGS = false;
		HIDE_HEAD = false;
		HIDE_CHEST = false;
		HIDE_ARMS = false;

		// dbg 3Tokens $get_token(PARAM1,0) $get_token(PARAM1,1) $get_token(PARAM1,2)
		if (GetToken(bodyParts, 0) == "legs")
			HIDE_LEGS = true;
		if (GetToken(bodyParts, 0) == "head")
			HIDE_HEAD = true;
		if (GetToken(bodyParts, 0) == "chest")
			HIDE_CHEST = true;
		if (GetToken(bodyParts, 0) == "arms")
			HIDE_ARMS = true;
		if (GetToken(bodyParts, 1) == "legs")
			HIDE_LEGS = true;
		if (GetToken(bodyParts, 1) == "head")
			HIDE_HEAD = true;
		if (GetToken(bodyParts, 1) == "chest")
			HIDE_CHEST = true;
		if (GetToken(bodyParts, 1) == "arms")
			HIDE_ARMS = true;
		if (GetToken(bodyParts, 2) == "legs")
			HIDE_LEGS = true;
		if (GetToken(bodyParts, 2) == "head")
			HIDE_HEAD = true;
		if (GetToken(bodyParts, 2) == "chest")
			HIDE_CHEST = true;
		if (GetToken(bodyParts, 2) == "arms")
			HIDE_ARMS = true;
		if (GetToken(bodyParts, 3) == "legs")
			HIDE_LEGS = true;
		if (GetToken(bodyParts, 3) == "head")
			HIDE_HEAD = true;
		if (GetToken(bodyParts, 3) == "chest")
			HIDE_CHEST = true;
		if (GetToken(bodyParts, 3) == "arms")
			HIDE_ARMS = true;
		if (GetToken(bodyParts, 4) == "legs")
			HIDE_LEGS = true;
		if (GetToken(bodyParts, 4) == "head")
			HIDE_HEAD = true;
		if (GetToken(bodyParts, 4) == "chest")
			HIDE_CHEST = true;
		if (GetToken(bodyParts, 4) == "arms")
			HIDE_ARMS = true;

		CallExternal(MY_BODY, "hide_parts", HIDE_LEGS, HIDE_HEAD, HIDE_CHEST, HIDE_ARMS);
	}

	// wearing_armor
	// PARAM1=0|1 PARAM2=Type(platemail/leather/etc) PARAM3=offset
	void PlayerExternals_OnWearingArmor(int equipped = 0, string type = "", string offset = "")
	{
		// //dbg ArmorSent Armored PARAM1 type PARAM2 ofs PARAM3
		ARMOR_EQUIPED = equipped;
		if (equipped == 0)
		{
			ARMOR_TYPE = "none";
			ARMOR_OFS = "0";
		}
		else
		{
			ARMOR_TYPE = type;
			float incOfs = Float(offset);
			incOfs += 1.0f;
			ARMOR_OFS = offset;
		}
	}

	// potion_regen
	// p1=duration
	void PlayerExternals_OnPotionRegen(float duration = 0.0f)
	{
		if (REGEN_ON) // no stackie
			return;
		if (VAMPIRE_ON)
		{
			PlayerMessageDark(ENT_ME, "Vampire blood and regeneration potions do not mix.");
			LegacyCommand("kill", ENT_ME);
		}

		REGEN_ON = true;
		REGEN_RATE = 5.0f;
		CallEventDelayed(duration, "regen_end");
		OnRegenStart();
	}

	// regen_start
	void PlayerExternals_OnRegenStart()
	{
		if (!REGEN_ON)
			return;

		float myMaxHealth = MaxHealthOf(ENT_ME);
		float myCurHealth = HealthOf(ENT_ME);

		PlaySound(0, 10, "player/heartbeat_noloop.wav");

		if (myCurHealth < myMaxHealth)
			GiveHealth(REGEN_RATE);
		CallEventDelayed(1.0f, "regen_start");
	}

	// regen_end
	void PlayerExternals_OnRegenEnd()
	{
		if (!REGEN_ON)
			return;
		PlayerMessage(ENT_ME, "The regenerative magic fades.");
		REGEN_ON = false;
	}

	// potion_vampire
	// p1=duration
	void PlayerExternals_OnPotionVampire(float duration = 0.0f)
	{
		if (VAMPIRE_ON)
			return;
		VAMPIRE_ON = true;
		IMMUNE_VAMPIRE = true;
		OnVampireSuncheck();
		// setvard PLR_OLD_FIRE_RESIST $get_takedmg(ent_me,fire)
		CallEventDelayed(duration, "vampire_off");
	}

	// vampire_suncheck
	void PlayerExternals_OnVampireSuncheck()
	{
		if (!VAMPIRE_ON)
			return;

		// takedmg fire 0.99
		// dbg suncheck CURRENT_TIME_HOUR sky $get_sky_height(MY_POS)
		if (Float(GetVar("CURRENT_TIME_HOUR")) < 19.0f && Float(GetVar("CURRENT_TIME_HOUR")) > 5.0f)
		{
			Vector3 myPos = OriginOf(ENT_ME);
			if (Truthy(LegacyFunction("get_under_sky", myPos)) && MapName() != "sfor")
			{
				// dbg set vampire on fire ( hr CURRENT_TIME_HOUR sky $get_sky_height(MY_POS) )
				// //this is one of this sits where we really need a global DM
				// if ( BURNER_ID equals 'BURNER_ID' )
				// {
				// createnpc other/lure (20000,-20000,20000)
				// setvard BURNER_ID $get(ent_lastcreated,id)
				// callexternal BURNER_ID make_sun
				// }
				int sunDamage = 100;
				if (Float(GetVar("CURRENT_TIME_HOUR")) > 16.0f)
					sunDamage = 50;

				CallExternal(GetVar("GAME_MASTER"), "gm_setname", "The light of the sun");
				DoDamageEx(ENT_ME, "direct", sunDamage, "100%", GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", "magic_effect");
			}
		}
		// applyeffect ent_me effects/dot_fire 5.0 BURNER_ID SUN_DAMAGE 1
		CallEventDelayed(5.1f, "vampire_suncheck");
	}

	// vampire_off
	void PlayerExternals_OnVampireOff()
	{
		IMMUNE_VAMPIRE = false;
		VAMPIRE_ON = false;
		PlayerMessage(ENT_ME, "The effects of the vampire blood fade.");
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type PARAM4=dmgevent
	string PlayerExternals_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (VAMPIRE_ON)
		{
			float dmgInflicted = damage * VAMPIRE_MULTI;
			GiveHealth(dmgInflicted);

			OnTryVampireTarget(self, target, Text(dmgInflicted)); // <owner> <target> <healAmt>
		}
		return result;
	}

	// ext_playsound_kiss
	void PlayerExternals_OnExtPlaysoundKiss(int channel = 0, int volume = 0, string soundFile = "")
	{
		PlaySound(channel, volume, soundFile);
	}

	// ext_playsound
	// <WAV> [(source)] [MaxRange] //sound must be precached
	void PlayerExternals_OnExtPlaysound(int soundFile = 0, Vector3 sourceOrigin = Vector3(), string maxRange = "", string volume = "", string pitch = "")
	{
		bool exitSub = false;

		if (!maxRange.isEmpty())
		{
			Vector3 sourceOrg = sourceOrigin;
			// dbg temp $dist(game.monster.origin,SOURCE_ORG)
			if (Distance(MyOrigin(), sourceOrg) > Float(maxRange))
				exitSub = true;
		}
		if (exitSub)
			return;

		EXTPLAY_SOUND = soundFile;
		CallEventDelayed(0.1f, "ext_playsound2"); // delay 0.1 seconds to stop flood
	}

	// ext_playsound2
	void PlayerExternals_OnExtPlaysound2()
	{
		// dbg playing external req EXTPLAY_SOUND
		PlaySound(0, 10, EXTPLAY_SOUND);
	}

	// ext_rename_me
	void PlayerExternals_OnExtRenameMe(string newName = "")
	{
		SetName(newName);
	}

	// ext_play_music
	// <file>
	void PlayerExternals_OnExtPlayMusic(string file = "")
	{
		PlayMusic(ENT_ME, "combat", file);
	}

	// ext_play_music_me
	// <file>
	void PlayerExternals_OnExtPlayMusicMe(string file = "")
	{
		PlayMusic(ENT_ME, "combat", file);
	}

	// ext_setangle
	// PARAMS as setangle
	void PlayerExternals_OnExtSetangle(Vector3 angles = Vector3(), string value = "")
	{
		// dbg got PARAM1 PARAM2
		SetAngle(angles, value);
	}

	// ext_quest
	// PARAM1=quest_name PARAM2=quest_data
	void PlayerExternals_OnExtQuest(string questName = "", string questData = "")
	{
		// useful when you need to set a quest for all players
		Quest("set", ENT_ME, questName, questData);
	}

	// ext_addgold
	void PlayerExternals_OnExtAddgold(string goldAmount = "")
	{
		LegacyCommand("addgold", goldAmount);
	}

	// ext_setgold
	void PlayerExternals_OnExtSetgold(int goldAmount = 0)
	{
		SetGold(goldAmount);
	}

	// send_damage
	// same params as do damage
	void PlayerExternals_OnSendDamage(string target = "", string mode = "", string damage = "", string percent = "", string attacker = "", string effect = "", string flags = "")
	{
		// if !SEND_DMG_DELAY
		// setvard SEND_DMG_DELAY 1
		// callevent 0.2 reset_send_dmg_delay
		DoDamage(target, mode, damage, percent, attacker, effect, flags);
	}

	// give_hp
	// PARAM1 = amount to give, can be negative
	void PlayerExternals_OnGiveHp(string amount = "")
	{
		GiveHealth(amount);
	}

	// give_mp
	// PARAM1 = amount to give, can be negative
	void PlayerExternals_OnGiveMp(string amount = "")
	{
		GiveMana(amount);
	}

	// ext_invalidate
	// { [server] ext_return_relpos //used to return position relative to others
	// local MY_ORG game.monster.origin
	// vectoradd MY_ORG $relpos(PARAM1,PARAM2)
	// setvarg G_RELPOS MY_ORG
	// }
	// <PARAM1> 1|0 - marks target as invalid
	void PlayerExternals_OnExtInvalidate(string invalidFlag = "")
	{
		PLAYING_DEAD = invalidFlag;
	}

	// ext_dodamage
	// same params as do damage
	void PlayerExternals_OnExtDodamage(CBaseEntity@ target = null, string hitMode = "", float damage = 0.0f, string hitChance = "", string attacker = "", string damageSkill = "", string value = "")
	{
		DoDamage(target, hitMode, damage, hitChance, attacker, damageSkill, value);
	}

	// freeze_solid_start
	// PARAM1 = duration to freeze
	void PlayerExternals_OnFreezeSolidStart(string freezeDuration = "", string attacker = "")
	{
		// this is to tell monsters that change their move/anim speeds not to do so while frozen
		I_R_FROZEN = true;
		PL_I_R_FROZEN = true;
		// dbg will thaw in PARAM1
		CallEventOrDelay(freezeDuration, "freeze_solid_end");
	}

	// freeze_solid_end
	void PlayerExternals_OnFreezeSolidEnd(int unfrozeEarly = 0)
	{
		// dbg thaw
		I_R_FROZEN = false;
		PL_I_R_FROZEN = false;
	}

	// ext_removed_effects
	void PlayerExternals_OnExtRemovedEffects()
	{
		EXT_REMOVE_EFFECT = "unset";
	}

	// ext_spider_protect
	// <duration> <amt> <tag>
	void PlayerExternals_OnExtSpiderProtect(float duration = 0.0f, float protectAmount = 0.0f, string effectTag = "")
	{
		// immune to damage from spiders/scorps for XX seconds
		// - at the moment, this is only used by items/mana_prot_spiders
		// - spider axe has its own system - the two may stack, but shouldn't be a game breaker

		PLR_SPIDER_PROT = true;
		PLR_SPIDER_AMT = Text(protectAmount);
		CallEventDelayed(duration, "spider_protect_end");

		OnFloatToPercent(Float(PLR_SPIDER_AMT));

		PlayerMessageGreen(ENT_ME, "You are now protected from spiders ( FLOAT_RETURN )");
		ScriptFlags(ENT_ME, "add", effectTag, "spider_resist", protectAmount, duration);
	}

	// spider_protect_end
	void PlayerExternals_OnSpiderProtectEnd()
	{
		if (!PLR_SPIDER_PROT)
			return;
		PLR_SPIDER_PROT = false;
		PlayerMessage(ENT_ME, "The protection from spider magic fades.");
	}

	// float_to_percent
	// converts resistant fractions to %, returns FLOAT_RETURN
	void PlayerExternals_OnFloatToPercent(float fraction = 0.0f)
	{
		if (fraction == 0.0f) {}
		if (fraction == 1.0f) {}
		if (fraction == 0.0f)
			return;

		int floatReturn = 100;
		float incFloat = fraction * 100.0f;
		floatReturn -= int(incFloat);
	}

	// ext_set_alco_type
	void PlayerExternals_OnExtSetAlcoType(string alcoType = "", CBaseEntity@ spawnItem = null)
	{
		// set Kharaztorant alocyte type
		// - for Kharaztorant throwing knives, and possibly for future quest
		ALCO_TYPE = alcoType;
		@ALCO_SPAWN_ITEM = spawnItem;
	}

	// ext_flash_bang
	// PARAM1 = origin PARAM2 = radius PARAM3 = source_owner
	void PlayerExternals_OnExtFlashBang(Vector3 origin = Vector3(), int radius = 0, CBaseEntity@ sourceOwner = null)
	{
		if (!(Distance(MyOrigin(), origin) < radius))
			return;
		Effect("screenfade", ENT_ME, 3, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// ext_set_swift_blade
	// { [server] ext_super_lure
	// //debuggary
	// playermessage ent_me super_lure range $get(PARAM1,range) ( PARAM2 PARAM3 )
	// }
	// new parry system
	// on hold, code work to be done
	void PlayerExternals_OnExtSetSwiftBlade(float speedRatio = 0.0f)
	{
		PLR_SWIFT_BLADE = int(speedRatio);
	}

	// game_equipped
	// <handIdx> <itemID> //Called from code when a player puts an item in their hands, or when active item hands are swapped.
	void PlayerExternals_OnGameEquipped(CBaseEntity@ item = null)
	{
		OnExtSetHandId(GetProp(item, "hand_index"), item);
	}

	// ext_set_hand_id
	// <hand> <id> //Called by game_equipped above. Also called by base_item_extras when items are removed from the players hands.
	void PlayerExternals_OnExtSetHandId(string handIndex = "", CBaseEntity@ item = null)
	{
		// Hand index to where the item is trying to go

		int handpref = Int(GetProp(item, "handpref")); // 0: item wants to go in left hand. 1: item wants to go in right hand. 2: fist_bare. 3: arrow or potion (1 handed). 4: two handed item

		if (Float(handIndex) == 0.0f) // Left hand
		{
			@PLR_LEFT_HAND = item;
		}
		else if (Float(handIndex) == 1.0f) // Right hand / Two handed
		{
			@PLR_RIGHT_HAND = item;

			// In this case, it might be two handed, so check handpref too.
			if (handpref == 4) // Is two handed?
				@PLR_LEFT_HAND = null;
		}
		else if (Float(handIndex) == 2.0f) // fist_bare
		{
			@PLR_LEFT_HAND = item;
			@PLR_RIGHT_HAND = item;
		}

		@PLR_ACTIVE_WEAPON = item;
		if (Truthy(ScriptVarOf(PLR_ACTIVE_WEAPON, "SPECIAL_WEAPON")))
			PLR_SPECIAL_WEAPON = true;
		else
			PLR_SPECIAL_WEAPON = false;

		OnUpdateParry(); // Update parry
		OnSetTwoHand(); // Update dual-wield penalty
		CallEventDelayed(0.25f, "set_swift_blade"); // Set item swift blade, if active
	}

	// update_parry
	void PlayerExternals_OnUpdateParry()
	{
		float parryMulti = 1.0f;

		// calc left hand parry value
		string leftParrySkill = "skill." + ScriptVarOf(PLR_LEFT_HAND, "WEAPON_PRIMARY_SKILL");
		float leftParry = Float(GetProp(ENT_ME, leftParrySkill));
		// dbg lefthand hpref $get(PLR_LEFT_HAND,handpref) val LEFT_PARRY
		if (Float(GetProp(PLR_LEFT_HAND, "handpref")) == 2.0f) // is bare fist
			leftParry = 0.0f;
		if (Float(GetProp(PLR_LEFT_HAND, "handpref")) == 4.0f && leftParrySkill != "skill.martialarts") // If is two handed
		{
			leftParry *= 1.5f; // is two handed and not gauntlet
		}
		if (Truthy(ScriptVarOf(PLR_LEFT_HAND, "AM_SHIELD")))
		{
			leftParry = 0.0f;
			string leftParryMultiText = ScriptVarOf(PLR_LEFT_HAND, "PARRY_MULTI_OUT");
			int leftParryMulti = Int(leftParryMultiText);
			if (leftParryMultiText != "not_equipped")
				parryMulti += leftParryMulti;
		}

		// calc right hand parry value
		string rightParrySkill = "skill." + ScriptVarOf(PLR_RIGHT_HAND, "WEAPON_PRIMARY_SKILL");
		float rightParry = Float(GetProp(ENT_ME, rightParrySkill));
		// dbg righthand hpref $get(PLR_RIGHT_HAND,handpref) val RIGHT_PARRY
		if (Float(GetProp(PLR_RIGHT_HAND, "handpref")) == 2.0f) // is bare fist
			rightParry = 0.0f;
		if (Float(GetProp(PLR_RIGHT_HAND, "handpref")) == 4.0f && rightParrySkill != "skill.martialarts")
		{
			rightParry *= 1.5f; // is two handed, and not gauntlet
		}
		if (Truthy(ScriptVarOf(PLR_RIGHT_HAND, "AM_SHIELD")))
		{
			rightParry = 0.0f;
			string rightParryMultiText = ScriptVarOf(PLR_RIGHT_HAND, "PARRY_MULTI_OUT");
			int rightParryMulti = Int(rightParryMultiText);
			if (rightParryMultiText != "not_equipped")
				parryMulti += rightParryMulti;
		}

		float totalParry = rightParry + leftParry;

		if (parryMulti > 1.0f)
			parryMulti -= 1.0f;

		if (totalParry == 0.0f)
		{
			// shield + barefist = MA parry value x shieldmulti
			if (parryMulti > 1.0f)
				totalParry = SkillOf(ENT_ME, "martialarts");
		}

		totalParry *= parryMulti;
		totalParry = int(totalParry);
		string totalParryText = Text(totalParry);

		string oldParry = PL_PARRY;
		PL_PARRY = totalParryText;

		if (Float(oldParry) != Float(PL_PARRY))
			PlayerMessageYellow(ENT_ME, "Your Parry value is now " + totalParryText);
		SetStat("parry", totalParryText);
	}

	// set_two_hand
	void PlayerExternals_OnSetTwoHand()
	{
		float oldReduct;
		bool saReduct = false;
		// calc damage reduct
		string plrLeftHandType = ItemNameOf(PLR_LEFT_HAND);
		string plrRightHandType = ItemNameOf(PLR_RIGHT_HAND);

		int noReduct = Int(OnFuncGetDualwieldReduct(plrLeftHandType)); // Get if there should be dual wield reduction
		if (noReduct == 0) // Same for other item in other hand
			noReduct = Int(OnFuncGetDualwieldReduct(plrRightHandType));

		PLR_HAS_MATCHED_SET = false;
		if (Truthy(ScriptVarOf(PLR_RIGHT_HAND, "MATCHED_SET")))
		{
			string matchedSetType = ScriptVarOf(PLR_RIGHT_HAND, "MATCHED_SET_TYPE");
			if (ScriptVarOf(PLR_LEFT_HAND, "MATCHED_SET_TYPE") == matchedSetType)
			{
				noReduct = 1;
				PLR_HAS_MATCHED_SET = true;
			}
		}

		if (noReduct == 0)
		{
			oldReduct = PLR_2H_REDUCT;
			if (Contains(plrLeftHandType, "smallarms_"))
				saReduct = true;
			if (Contains(plrRightHandType, "smallarms_"))
				saReduct = true;
			if (plrLeftHandType == plrRightHandType)
				saReduct = true;

			if (saReduct)
			{
				PLR_2H_REDUCT = PLR_2HPEN_LIGHT; // 0.7
				if (oldReduct != PLR_2H_REDUCT)
					PlayerMessageYellow(ENT_ME, "Dual-wield penalty: " + PLR_2HPEN_LIGHT_REPORT + " (off-hand is light or matches)");
			}
			else
			{
				PLR_2H_REDUCT = PLR_2HPEN_HEAVY; // 0.6
				if (oldReduct != PLR_2H_REDUCT)
					PlayerMessageYellow(ENT_ME, "Dual-wield penalty: " + PLR_2HPEN_HEAVY_REPORT);
			}
		}
		else
		{
			oldReduct = PLR_2H_REDUCT;
			PLR_2H_REDUCT = 1.0f;
			if (oldReduct != PLR_2H_REDUCT && !PLR_HAS_MATCHED_SET)
				PlayerMessageYellow(ENT_ME, "No dual-wield penalty.");

			if (PLR_HAS_MATCHED_SET)
			{
				if (!PLR_HAD_MATCHED_SET)
				{
					PlayerMessageYellow(ENT_ME, "No dual-wield penalty due to matched set!");
					PLR_HAD_MATCHED_SET = true;
				}
			}
			else
			{
				PLR_HAD_MATCHED_SET = false;
			}
		}
	}

	// func_get_dualwield_reduct
	// <scriptname> //Returns 1 or 0 depending on whether or not the weapon has dual wield penalty
	string PlayerExternals_OnFuncGetDualwieldReduct(string weaponScript = "")
	{
		string result = "";

		bool noReduct = false;

		if (StartsWith(weaponScript, "bows_"))
			noReduct = true;
		else if (StartsWith(weaponScript, "shield"))
			noReduct = true;
		else if (StartsWith(weaponScript, "armor_"))
			noReduct = true;
		else if (StartsWith(weaponScript, "magic_hand_"))
			noReduct = true;
		else if (StartsWith(weaponScript, "fist_")) // bare fist
			noReduct = true;
		else if (Contains(weaponScript, "gauntlet"))
			noReduct = true;
		else if (weaponScript == "0") // empty
			noReduct = true;
		else if (StartsWith(weaponScript, "item")) // off hand not a weapon
			noReduct = true;
		else if (StartsWith(weaponScript, "mana")) // off hand not a weapon
			noReduct = true;
		else if (StartsWith(weaponScript, "health")) // off hand not a weapon
			noReduct = true;
		else if (StartsWith(weaponScript, "skin")) // off hand not a weapon
			noReduct = true;

		result = "";
		result = AppendResult(result, Text(noReduct));
		return result;
	}

	// set_swift_blade
	void PlayerExternals_OnSetSwiftBlade()
	{
		bool exitSub = false;
		float curSpeed;
		float curStrike;

		// dbg set_swift_blade PLR_SWIFT_BLADE
		CBaseEntity@ activeWeapon = ActiveItemOf(ENT_ME);

		string activeScript = ItemNameOf(activeWeapon);

		if (Contains(activeScript, "bows_"))
			exitSub = true;
		if (exitSub)
			return;

		if (Contains(activeScript, "magic_hand_"))
			exitSub = true;
		if (exitSub)
			return;

		if (PLR_SWIFT_BLADE == 0)
		{
			if (Truthy(ScriptVarOf(activeWeapon, "ITEM_SWIFT_BLADE")))
				CallExternal(activeWeapon, "ext_item_swift_blade", "remove");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!Truthy(ScriptVarOf(activeWeapon, "ITEM_SWIFT_BLADE")))
		{
			curSpeed = Float(LegacyFunction("get_attackprop", @activeWeapon, 0, "delay.end"));
			curStrike = Float(LegacyFunction("get_attackprop", @activeWeapon, 0, "delay.strike"));
		}
		else
		{
			curSpeed = Float(ScriptVarOf(activeWeapon, "ITEM_BASE_SPEED"));
			curStrike = Float(ScriptVarOf(activeWeapon, "ITEM_BASE_STRIKE"));
		}

		CallExternal(activeWeapon, "ext_item_swift_blade", curSpeed, curStrike);

		curSpeed *= PLR_SWIFT_BLADE;
		curStrike *= PLR_SWIFT_BLADE;
		curStrike *= 0.75f;

		float viewanimSpeed = Float(ScriptVarOf(activeWeapon, "BWEAPON_BASE_ANIM_SPEED"));
		if (curSpeed > 0.0f)
			viewanimSpeed = Divide(viewanimSpeed, curSpeed);
		SetViewModelProp(activeWeapon, "animspeed", viewanimSpeed);

		SetAttackProp(activeWeapon, 0, "delay.end", curSpeed);
		SetAttackProp(activeWeapon, 0, "delay.strike", curStrike);
	}

	// ext_sphere_token_x
	// TYPE_SCAN SCAN_RANGE
	void PlayerExternals_OnExtSphereTokenX(string scanType = "", float scanRange = 0.0f)
	{
		PLR_SCAN_TOKEN = FindInSphere(scanType, scanRange);
	}

	// ext_sphere_token
	// TYPE_SCAN SCAN_RANGE SCAN_ORIGIN
	void PlayerExternals_OnExtSphereToken(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3())
	{
		PLR_SCAN_TOKEN = LegacyFunction("get_tsphere", scanType, scanRange, scanOrigin);
	}

	// ext_sphere_token_byrange
	// SEP2010_07
	void PlayerExternals_OnExtSphereTokenByrange(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3())
	{
		PLR_SCAN_TOKEN = LegacyFunction("get_tsphere", scanType, scanRange, scanOrigin);
		if (PLR_SCAN_TOKEN == "none")
			return;
		PLR_SCAN_TOKEN = SortEntities(PLR_SCAN_TOKEN, "range");
	}

	// ext_box_token
	// TYPE_SCAN SCAN_RANGE SCAN_ORIGIN
	void PlayerExternals_OnExtBoxToken(string scanType = "", int scanRange = 0, string scanOrigin = "")
	{
		PLR_SCAN_TOKEN = LegacyFunction("get_tbox", scanType, scanRange, scanOrigin);
	}

	// ext_set_vote_delay
	void PlayerExternals_OnExtSetVoteDelay()
	{
		VOTE_DISABLED = true;
		CallEventDelayed(20.0f, "reset_vote_delay");
	}

	// reset_vote_delay
	void PlayerExternals_OnResetVoteDelay()
	{
		VOTE_DISABLED = false;
	}

	// ext_reset_names
	void PlayerExternals_OnExtResetNames()
	{
		Quest("set", ENT_ME, "n", 0);
	}

	// ext_send_tele_point
	// (origin)
	void PlayerExternals_OnExtSendTelePoint(string teleportPosition = "")
	{
		// teleport to a specific point with fx
		PlaySound(0, 10, "magic/spawn.wav");
		SetOrigin(self, Vec(teleportPosition));
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			PlayerMessageGreen(ENT_ME, "ext_send_tele_point " + teleportPosition);
		OWNER_POS = teleportPosition;
		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnBeamFx2();
		}
	}

	// beam_fx2
	void PlayerExternals_OnBeamFx2()
	{
		Vector3 beamStart = Vec(OWNER_POS);
		Vector3 beamEnd = Vec(OWNER_POS);

		beamStart += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, -32));
		beamEnd += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, 128));
		Effect("beam", "point", "lgtning.spr", 100, beamStart, beamEnd, Vector3(255, 0, 255), 200, 16, 3);

		BEAM_ROT += 20.0f;
	}

	// ext_set_next_scroll
	void PlayerExternals_OnExtSetNextScroll()
	{
		// external used by scrolls to mark next time scrolls will be allowed to be used
		PLR_NEXT_SCROLL = GameTime() + 5.0f;
	}

	// ext_set_reward
	void PlayerExternals_OnExtSetReward(int rewardGiven = 0)
	{
		PLR_GOT_REWARD = rewardGiven != 0;
	}

	// game_drain_death
	// PARAM1 = drainer
	void PlayerExternals_OnGameDrainDeath(CBaseEntity@ attacker = null)
	{
		// dbg DRAIN DEATH
		DoDamage(ENT_ME, "direct", 100, "100%", @attacker, "target");
	}

	// ext_set_map
	// use ext_set_status_flag instead
	// { ext_nopush
	// nopush PARAM1
	// //dbg nopush set to PARAM1
	// }
	// use ext_set_status_flag instead
	// { ext_nopush_on
	// nopush 1
	// if ( PARAM2 > 0 ) callevent PARAM2 ext_nopush_off
	// }
	// use ext_set_status_flag_instead
	// { ext_nopush_off
	// playermessage The stability magic fades...
	// nopush 0
	// mapname local_spawn dest_spawn
	void PlayerExternals_OnExtSetMap(string mapName = "", string localSpawn = "", string destSpawn = "")
	{
		// dbg ext_set_map PARAM1 PARAM2 PARAM3
		Quest("set", ENT_ME, "m", ToLowerCase(mapName));
		Quest("set", ENT_ME, "d", localSpawn); // actually using local trans, next trans set on map change
		LegacyCommand("settrans", ENT_ME, localSpawn);

		PLR_CUR_TRANS = localSpawn;
		PLR_NEXT_TRANS = destSpawn;
		// to avoid error
		CallEventDelayed(0.1f, "ext_set_transitions");
	}

	// ext_setspawn
	// <spawn_name>
	void PlayerExternals_OnExtSetspawn(string spawnName = "")
	{
		DebugPrint("ext_setspawn " + spawnName);
		LegacyCommand("settrans", ENT_ME, spawnName);
		Quest("set", ENT_ME, "d", spawnName);
	}

	// ext_set_transitions
	void PlayerExternals_OnExtSetTransitions()
	{
		// dbg settrans PLR_CUR_TRANS PLR_NEXT_TRANS
		if (!PLR_IN_WORLD)
			return;
		LegacyCommand("settrans", ENT_ME, PLR_CUR_TRANS);
	}

	// ext_scan_pet
	// { ext_add_pet //type, ID
	// token.add PLR_PET_TYPES PARAM1
	// token.add PLR_PET_IDS PARAM2
	// }
	// { ext_remove_pet //type, ID
	// local PET_IDX $get_find_token(PLR_PET_TYPES,PARAM1)
	// if ( PET_IDX > -1 )
	// {
	// token.del PLR_PET_TYPES PET_IDX
	// token.del PLR_PET_IDS PET_IDX
	// }
	// }
	void PlayerExternals_OnExtScanPet(string petType = "")
	{
		T_SPHERE = FindInSphere("enemy", 512);
		TARGET_PET_TYPE = petType;
		if (T_SPHERE == "none")
			return;
		int count = GetTokenCount(T_SPHERE);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnExtScanPetLoop();
		}
	}

	// ext_scan_pet_loop
	void PlayerExternals_OnExtScanPetLoop()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(T_SPHERE, loopIteration));
		string petType = ScriptVarOf(curTarget, "NPC_PET_TYPE");
		if (petType != TARGET_PET_TYPE)
			return;
		@PLR_FOUND_PET = curTarget;
	}

	// ext_set_frozen
	// { ext_return_relpos_vec //return an adjusted self-relative position SEP2009_17 - fixed, was useless old way as was using coord type $relpos()
	// setvard EXT_RELPOS $relpos(PARAM1,PARAM2,PARAM3)
	// }
	// { ext_fireball_test
	// if !CFB_FIREBALL_ACTIVE //one at a time
	// setvard CFB_FIREBALL_ACTIVE 1
	// setvard CFB_FIRST_TARGET_FOUND 0
	// setvard CFB_EST_ORG $relpos(0,32,0)
	// local START_ANGS $get(ent_me,viewangles)
	// setvard CFB_EST_ANG START_ANGS
	// local PLR_TARGET $get(ent_me,target)
	// if ( $get(PLR_TARGET,isalive) )
	// {
	// if $get(PLR_TARGET,relationship,ent_me) equals enemy
	// if !$get(PLR_TARGET,scriptvar,'PLAYING_DEAD')
	// setvard CFB_TARGET PLR_TARGET
	// }
	// clientevent new all monsters/summon/client_side_iceball CFB_EST_ORG START_ANGS
	// setvard CFB_FIREBALL_IDX game.script.last_sent_id
	// callevent 0.1 cfb_fireball_loop
	// setvard CFB_FORCE_END game.time
	// add CFB_FORCE_END 20.0
	// }
	// { cfb_fireball_loop
	// if CFB_FIREBALL_ACTIVE
	// callevent 0.5 cfb_fireball_loop
	// if ( game.time > CFB_NEXT_SCAN )
	// {
	// setvard CFB_NEXT_SCAN game.time
	// add CFB_NEXT_SCAN 2.0
	// if ( !$get(CFB_TARGET,isalive) )
	// {
	// local OWNER_ORG $get(ent_me,origin)
	// local TARGET_TOKENS $get_tsphere(enemy,256,CFB_EST_ORG) 	//try and see if $get_sphere is fixed - can't remember
	// if TARGET_TOKENS isnot none
	// if ( $get_token_amt(TARGET_TOKENS) > 1 ) token.scramble TARGET_TOKENS //not important when player is owner, but may prevent targeting same player every time
	// local TEST_TARG $get_token(TARGET_TOKENS,0)
	// if $get(TEST_TARG,isalive)
	// if !$get(TEST_TARG,scriptvar,'PLAYING_DEAD')
	// setvard CFB_TARGET TEST_TARG
	// dbg *** cfb_fireball_loop: targeting $get(CFB_TARGET,id)
	// if !CFB_FIRST_TARGET_FOUND
	// setvard CFB_FIRST_TARGET_FOUND 1
	// local ANG_TO_TARG $angles3d(CFB_EST_ORG,TARG_ORG)
	// }
	// else
	// {
	// local SCAN_DOWN CFB_EST_ORG
	// vectoradd SCAN_DOWN z -32 //scan down a lil bit, cuz yer aiming at heads
	// local TARGET_TOKENS $get_tsphere(enemy,64,SCAN_DOWN)
	// if TARGET_TOKENS isnot none
	// callevent cfb_explode "hit_nme"
	// }
	// }
	// if CFB_FIREBALL_ACTIVE //case exploded
	// if ( $get(CFB_TARGET,isalive) )
	// {
	// local TARG_ORG $get(CFB_TARGET,origin)
	// vectoradd TARG_ORG z $get(CFB_TARGET,height) //aim for the head! ;)
	// if ( G_DEVELOPER_MODE ) gplayermessage ent_me Fireball Tracking: $get(CFB_TARGET,name)
	// local ANG_TO_TARG $angles3d(CFB_EST_ORG,TARG_ORG)
	// vectorset ANG_TO_TARG x $neg($vec.x(ANG_TO_TARG))
	// clientevent update all CFB_FIREBALL_IDX svr_update_fireball_vec ANG_TO_TARG
	// setvard CFB_EST_ANG ANG_TO_TARG
	// vectoradd CFB_EST_ORG $relvel(ANG_TO_TARG,$vec(0,60,0))
	// }
	// else
	// {
	// vectoradd CFB_EST_ORG $relvel(CFB_EST_ANG,$vec(0,60,0))
	// }
	// local TRACE_DEST CFB_EST_ORG
	// vectoradd TRACE_DEST $relvel(CFB_EST_ANG,$vec(0,60,0))
	// local TRACE_RESULT $get_traceline(CFB_EST_ORG,TRACE_DEST,worldonly)
	// if ( TRACE_RESULT isnot TRACE_DEST ) callevent cfb_explode "hitwall"
	// if ( G_DEVELOPER_MODE )
	// {
	// //show where I *think* the fireball is
	// local BEAM_START CFB_EST_ORG
	// local BEAM_END TRACE_DEST
	// effect beam point lgtning.spr 100 BEAM_START BEAM_END (255,0,255) 200 16 3
	// }
	// if CFB_FIREBALL_ACTIVE //case sploded
	// if game.time > CFB_FORCE_END
	// callevent cfb_explode "time_out"
	// }
	// { cfb_explode
	// setvard CFB_FIREBALL_ACTIVE 0
	// if ( G_DEVELOPER_MODE ) gplayermessage ent_me Fireball Explode: PARAM1
	// clientevent update all CFB_FIREBALL_IDX fireball_explode
	// callevent 1.0 cfb_fireball_release
	// //scan/dodamage aoe here
	// setvard CFB_LIST $get_tsphere(enemy,128,CFB_EST_ORG)
	// if CFB_LIST isnot none
	// if $get_token_amt(CFB_LIST) > 0
	// local CFB_DMG 200
	// xdodamage CFB_EST_ORG 128 CFB_DMG 0 ent_me ent_me skill.fire fire
	// calleventloop $get_token_amt(CFB_LIST) cfb_affect_targets
	// }
	// { cfb_affect_targets
	// local CHECK_ENT $get_token(CFB_LIST,game.script.iteration)
	// local TARGET_ORG $get(CHECK_ENT,origin)
	// local TARG_ANG $angles(CFB_EST_ORG,TARGET_ORG)
	// local NEW_YAW TARG_ANG
	// setvelocity CHECK_ENT $relvel($vec(0,NEW_YAW,0),$vec(0,1000,0))
	// }
	// { cfb_fireball_end
	// dbg cfb_fireball_end
	// clientevent update all CFB_FIREBALL_IDX fireball_end
	// callevent 1.0 cfb_fireball_release
	// }
	// { cfb_fireball_release
	// dbg cfb_fireball_release
	// setvard CFB_FIREBALL_ACTIVE 0
	// }
	// Thothie FEB2009_19 - allow frozen status from things other than freeze_solid
	// <duration>
	void PlayerExternals_OnExtSetFrozen(string duration = "")
	{
		I_R_FROZEN = true;
		ScriptFlags(ENT_ME, "add", "ext_set_frozen", "nopush", 1, duration, "none");
		CallEventOrDelay(duration, "ext_set_unfrozen");
	}

	// ext_set_unfrozen
	void PlayerExternals_OnExtSetUnfrozen()
	{
		I_R_FROZEN = false;
	}

	// ext_glow_block
	// Thothie FEB2009_21 - allow blocking of Glow spell
	void PlayerExternals_OnExtGlowBlock(int blockFlag = 0)
	{
		PLR_GLOW_BLOCK = blockFlag != 0;
		if (PLR_GLOW_BLOCK)
		{
			if (Truthy(PLR_HAS_GLOW))
			{
				PlaySound(2, 10, "magic/elecidlepop.wav");
				PlayerMessage(ENT_ME, "Your light is snuffed out!");
				CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "remove", IndexOf(ENT_ME), Vector3(0, 0, 0), "RAD_RATIO");
				OnExtSetGlow("0");
			}
		}
		else
		{
			PlayerMessage(ENT_ME, "You have left the influence of the dark force.");
		}
	}

	// ext_ent_list_sort
	// Jelly's external scan+sort SEP2009_17
	// SCAN_TYPE SCAN_RANGE SCAN_ORIGIN SORT_TYPE:range|hp|maxhp|mp|maxmp
	void PlayerExternals_OnExtEntListSort(string scanFilter = "", string searchRange = "", string searchOrigin = "", string sortBy = "")
	{
		OnExtSphereToken(scanFilter, Int(searchRange), Vec(searchOrigin));
		PLR_SCAN_TOKEN_SORTED = SortEntities(PLR_SCAN_TOKEN, sortBy);
	}

	// ext_fire_aura_activate
	// Thothie JAN2010_02 fire aura (for items/armor_faura)
	// <dot> <size>
	void PlayerExternals_OnExtFireAuraActivate(string dot = "", int size = 0)
	{
		if (PLR_FAURA)
			return;
		PLR_FAURA = true;
		PLR_FAURA_DOT = dot;
		PLR_FAURA_AOE = size;

		// dbg ext_fire_aura_activate dot PLR_FAURA_DOT aoe PLR_FAURA_AOE
		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "items/armor_faura_cl", IndexOf(ENT_ME), PLR_FAURA_AOE, PLR_FAURA_CL_RATE);
		PLR_FAURA_CLIDX = LastClientScriptId();
		PLR_FAURA_NEXT_CL = GameTime() + PLR_FAURA_CL_RATE;
		OnFireAuraLoop();
	}

	// fire_aura_loop
	void PlayerExternals_OnFireAuraLoop()
	{
		if (!PLR_FAURA)
			return;
		CallEventDelayed(1.0f, "fire_aura_loop");

		float gameTime = GameTime();

		if (gameTime > PLR_FAURA_NEXT_CL)
		{
			ClientEvent("new", "all", "items/armor_faura_cl", IndexOf(ENT_ME), PLR_FAURA_AOE, PLR_FAURA_CL_RATE);
			PLR_FAURA_CLIDX = LastClientScriptId();
			PLR_FAURA_NEXT_CL = gameTime + PLR_FAURA_CL_RATE;
		}

		if (!IsAlive(ENT_ME))
			return;
		float scanAoe = PLR_FAURA_AOE * 3.0f;
		PLR_FAURA_SCAN = FindInSphere("enemy", scanAoe); // scan extra distance to make up for monster width
		// dbg fire_aura_loop PLR_FAURA_SCAN
		if (PLR_FAURA_SCAN == "none")
			return;
		// dbg fire_aura_loop $get_token_amt(PLR_FAURA_SCAN) PLR_FAURA_SCAN
		int count = GetTokenCount(PLR_FAURA_SCAN);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFireAuraBurn();
		}
	}

	// fire_aura_burn
	void PlayerExternals_OnFireAuraBurn()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_FAURA_SCAN, loopIteration));

		if (!(RangeTo(curTarg) < PLR_FAURA_AOE))
			return;

		if (RelationshipOf(curTarg, ENT_ME) != "enemy")
			return;
		if (GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		if (!IS_AFK)
			ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, PLR_FAURA_DOT, "spellcasting.fire");
	}

	// ext_fire_aura_remove
	void PlayerExternals_OnExtFireAuraRemove()
	{
		PLR_FAURA = false;
		ClientEvent("update", "all", PLR_FAURA_CLIDX, "remove_me");
	}

	// ext_poison_aura_activate
	// Thothie JAN2010_06 poison aura (for items/armor_paura)
	// <dot> <size>
	void PlayerExternals_OnExtPoisonAuraActivate(string dot = "", int size = 0)
	{
		if (PLR_PAURA)
			return;
		PLR_PAURA = true;
		PLR_PAURA_DOT = dot;
		PLR_PAURA_AOE = size;

		// dbg ext_poison_aura_activate dot PLR_PAURA_DOT aoe PLR_PAURA_AOE
		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), PLR_PAURA_AOE, PLR_PAURA_CL_RATE);
		PLR_PAURA_CLIDX = LastClientScriptId();
		PLR_PAURA_NEXT_CL = GameTime() + PLR_PAURA_CL_RATE;
		OnPoisonAuraLoop();
	}

	// poison_aura_loop
	void PlayerExternals_OnPoisonAuraLoop()
	{
		if (!PLR_PAURA)
			return;
		CallEventDelayed(1.0f, "poison_aura_loop");

		float gameTime = GameTime();

		if (gameTime > PLR_PAURA_NEXT_CL)
		{
			ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), PLR_PAURA_AOE, PLR_PAURA_CL_RATE);
			PLR_PAURA_CLIDX = LastClientScriptId();
			PLR_PAURA_NEXT_CL = gameTime + PLR_PAURA_CL_RATE;
		}

		if (!IsAlive(ENT_ME))
			return;
		PLR_PAURA_SCAN = FindInSphere("enemy", PLR_PAURA_AOE);
		// dbg poison_aura_loop PLR_PAURA_SCAN
		if (PLR_PAURA_SCAN == "none")
			return;
		// dbg poison_aura_loop $get_token_amt(PLR_PAURA_SCAN) PLR_PAURA_SCAN
		int count = GetTokenCount(PLR_PAURA_SCAN);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonAuraBurn();
		}
	}

	// poison_aura_burn
	void PlayerExternals_OnPoisonAuraBurn()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_PAURA_SCAN, loopIteration));
		if (RelationshipOf(curTarg, ENT_ME) != "enemy")
			return;
		if (GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		if (!IS_AFK)
			ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, PLR_PAURA_DOT, "spellcasting.affliction");
	}

	// ext_poison_aura_remove
	void PlayerExternals_OnExtPoisonAuraRemove()
	{
		PLR_PAURA = false;
		ClientEvent("update", "all", PLR_PAURA_CLIDX, "remove_me");
	}

	// ext_setmodelbody
	void PlayerExternals_OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0)
	{
		// dbg ext_setmodelbody got PARAM1 PARAM2
		SetModelBody(bodyGroup, submodel);
	}

	// ext_setbodytype
	// [normal|leather|platemail|bear] <armor_id|remove> //(send no params to restore previous state)
	void PlayerExternals_OnExtSetbodytype(string bodyType = "", string armorId = "")
	{
		// if ( G_DEVELOPER_MODE ) messageall green ext_setbodytype PARAM1
		PLR_PREV_BODY_TYPE = PLR_BODY_TYPE;
		PLR_BODY_TYPE = bodyType;

		// vanishing armor fix? - Dravus
		if (armorId != "remove" && !armorId.isEmpty())
			PLR_LAST_WORN_ARMOR = armorId;

		float genderAdj = 1.0f;
		if (PLR_GENDER == "female")
		{
			if (RaceOf(ENT_ME) == "human")
				genderAdj += 1.0f;
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				MessageAll("green", "ext_setbodytype is_female");
			DebugPrint("ext_setbodytype Set female bodytype");
		}

		if (bodyType.isEmpty())
		{
			// no new body type specified, use old body type
			PLR_BODY_TYPE = PLR_PREV_BODY_TYPE;
		}
		else
		{
			// new body type set, change old type
			PLR_PREV_BODY_TYPE = PLR_BODY_TYPE;
		}

		if (PLR_BODY_TYPE == "normal")
		{
			SetModelBody(0, int(genderAdj)); // legs
			SetModelBody(1, int(genderAdj)); // heads
			SetModelBody(2, int(genderAdj)); // torso
			SetModelBody(3, int(genderAdj)); // arms
		}
		if (PLR_BODY_TYPE == "leather")
		{
			SetModelBody(0, int(genderAdj)); // legs
			SetModelBody(1, int(genderAdj)); // heads
			SetModelBody(2, 0); // torso
			SetModelBody(3, int(genderAdj)); // arms
		}
		if (PLR_BODY_TYPE == "platemail")
		{
			SetModelBody(0, 0); // legs
			SetModelBody(1, int(genderAdj)); // heads
			SetModelBody(2, 0); // torso
			SetModelBody(3, 0); // arms
		}
	}

	// ext_register_helm
	void PlayerExternals_OnExtRegisterHelm(string helmId = "")
	{
		PLR_HELM_ID = helmId;
		if (PLR_HELM_ID == "none")
			return;
		CallClientItemEvent(PLR_HELM_ID, "game_show", RaceOf(ENT_ME), GenderOf(ENT_ME), "ext_register_helm");
	}

	// ext_register_armor
	void PlayerExternals_OnExtRegisterArmor(string armorId = "")
	{
		PLR_ARMOR_ID = armorId;
		if (PLR_ARMOR_ID == "none")
			return;
		CallClientItemEvent(PLR_ARMOR_ID, "barmor_update_vest", RaceOf(ENT_ME), GenderOf(ENT_ME), "ext_register_armor");
	}

	// ext_dwarf_test
	void PlayerExternals_OnExtDwarfTest()
	{
		SetModelBody(0, 1); // heads 0=normal 1=no_head
		SetModelBody(1, 2); // bodies 0=normal 1=no_chest 2=no_nuttin
		SetModelBody(2, 1); // race 0=none 1=dwarf
		OnExtHideArmor();
	}

	// ext_hide_armor
	void PlayerExternals_OnExtHideArmor()
	{
		CallExternal(PLR_HELM_ID, "ext_hide");
	}

	// ext_setheadtype
	// old ref model version
	// if ( PARAM1 equals normal )
	// {
	// setmodelbody 0 0 //legs
	// setmodelbody 1 0 //head
	// setmodelbody 2 0 //chest
	// setmodelbody 3 0 //arms
	// }
	// if ( PARAM1 equals leather )
	// {
	// setmodelbody 0 0 //legs
	// setmodelbody 1 0 //head
	// setmodelbody 2 1 //chest
	// setmodelbody 3 0 //arms
	// }
	// if ( PARAM1 equals platemail )
	// {
	// setmodelbody 0 1 //legs
	// setmodelbody 1 0 //head
	// setmodelbody 2 1 //chest
	// setmodelbody 3 1 //arms
	// }
	// if ( PARAM1 equals bear )
	// {
	// setmodelbody 0 1 //legs
	// setmodelbody 1 1 //head
	// setmodelbody 2 1 //chest
	// setmodelbody 3 1 //arms
	// }
	// }
	// <index> ( 0-show_head 1-hide_head )
	void PlayerExternals_OnExtSetheadtype(int headIndex = 0)
	{
		// new ref
		float genderAdj = 0.0f;
		if (PLR_GENDER == "female" && RaceOf(ENT_ME) == "human")
			genderAdj += 2.0f;
		headIndex += int(genderAdj);
		SetModelBody(0, headIndex);
	}

	// ext_setmodel
	// just a test
	void PlayerExternals_OnExtSetmodel()
	{
		SetModel("dwarf/reference.mdl");
	}

	// ext_setrender
	void PlayerExternals_OnExtSetrender(string renderMode = "")
	{
	}

	// ext_tod_lock
	void PlayerExternals_OnExtTodLock(string timeOfDay = "")
	{
		PLR_TOD_LOCK = timeOfDay;
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "lock_tod", PLR_TOD_LOCK);
	}

	// ext_viewdist
	void PlayerExternals_OnExtViewdist(string viewDistance = "")
	{
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "set_view_dist", viewDistance);
	}

	// ext_urdual_slow
	// Thothie - FEB2010_01 - Urdual/smallarms haste exploit prevention
	void PlayerExternals_OnExtUrdualSlow(string releaseTime = "")
	{
		PLR_URDUAL_RELEASE_TIME = releaseTime;
	}

	// ext_set_gender
	void PlayerExternals_OnExtSetGender()
	{
		PLR_GENDER = GenderOf(ENT_ME); // sometimes externals and main don't seem to share vars, so setting this again here
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "set_cl_gender_race", GenderOf(ENT_ME), RaceOf(ENT_ME));
		if (PLR_GENDER == "female")
		{
			ClientCommand(ENT_ME, "ms_clgender 1");
			// setmodelbody 0 2
			// setmodelbody 1 3
			SetModelBody(0, 2);
			SetModelBody(1, 2);
			SetModelBody(2, 2);
			SetModelBody(3, 2);
			PLR_SOUND_SWORDREADY = SOUNDSET_HF_SWORDREADY;
			PLR_SOUND_SHOUT1 = SOUNDSET_HF_SHOUT1;
			PLR_SOUND_JAB1 = SOUNDSET_HF_JAB1;
			PLR_SOUND_JAB2 = SOUNDSET_HF_JAB2;
			PLR_SOUND_BREATHFAST1 = SOUNDSET_HF_BREATHFAST1;
			PLR_SOUND_BREATHFAST2 = SOUNDSET_HF_BREATHFAST2;
			PLR_SOUND_BREATHFAST3 = SOUNDSET_HF_BREATHFAST3;
			PLR_SOUND_DEATH = SOUNDSET_HF_DEATH;
			PLR_SOUND_CHESTHIT1 = SOUNDSET_HF_CHESTHIT1;
			PLR_SOUND_STOMACHHIT1 = SOUNDSET_HF_STOMACHHIT1;
			PLR_SOUND_ARMHIT1 = SOUNDSET_HF_ARMHIT1;
			PLR_SOUND_LEGHIT1 = SOUNDSET_HF_LEGHIT1;
			PLR_SOUND_FALLPAIN1 = SOUNDSET_HF_FALLPAIN1;
			PLR_SOUND_FALLPAIN2 = SOUNDSET_HF_FALLPAIN2;
			PLR_SOUND_FALLPAIN3 = SOUNDSET_HF_FALLPAIN3;
			PLR_SOUND_FALLPAIN4 = SOUNDSET_HF_FALLPAIN4;
		}
		else
		{
			ClientCommand(ENT_ME, "ms_clgender 0");
			// setmodelbody 0 0
			// setmodelbody 1 0
			SetModelBody(0, 1);
			SetModelBody(1, 1);
			SetModelBody(2, 1);
			SetModelBody(3, 1);
			PLR_SOUND_SWORDREADY = SOUNDSET_HM_SWORDREADY; // $get(ent_owner,scriptvar,'PLR_SOUND_SWORDREADY')
			PLR_SOUND_SHOUT1 = SOUNDSET_HM_SHOUT1; // $get(ent_owner,scriptvar,'PLR_SOUND_SHOUT1')
			PLR_SOUND_JAB1 = SOUNDSET_HM_JAB1; // $get(ent_owner,scriptvar,'PLR_SOUND_JAB1')
			PLR_SOUND_JAB2 = SOUNDSET_HM_JAB2; // $get(ent_owner,scriptvar,'PLR_SOUND_JAB2')
			PLR_SOUND_BREATHFAST1 = SOUNDSET_HM_BREATHFAST1; // $get(ent_owner,scriptvar,'PLR_SOUND_BREATHFAST1')
			PLR_SOUND_BREATHFAST2 = SOUNDSET_HM_BREATHFAST2; // $get(ent_owner,scriptvar,'PLR_SOUND_BREATHFAST2')
			PLR_SOUND_BREATHFAST3 = SOUNDSET_HM_BREATHFAST3; // $get(ent_owner,scriptvar,'PLR_SOUND_BREATHFAST3')
			PLR_SOUND_DEATH = SOUNDSET_HM_DEATH;
			PLR_SOUND_CHESTHIT1 = SOUNDSET_HM_CHESTHIT1;
			PLR_SOUND_STOMACHHIT1 = SOUNDSET_HM_STOMACHHIT1;
			PLR_SOUND_ARMHIT1 = SOUNDSET_HM_ARMHIT1;
			PLR_SOUND_LEGHIT1 = SOUNDSET_HM_LEGHIT1;
			PLR_SOUND_FALLPAIN1 = SOUNDSET_HM_FALLPAIN1;
			PLR_SOUND_FALLPAIN2 = SOUNDSET_HM_FALLPAIN2;
			PLR_SOUND_FALLPAIN3 = SOUNDSET_HM_FALLPAIN3;
			PLR_SOUND_FALLPAIN4 = SOUNDSET_HM_FALLPAIN4;
		}
	}

	// ext_helm_expar
	void PlayerExternals_OnExtHelmExpar()
	{
		// dbg calling_game_show_on $get(PLR_HELM_ID,name) [ $get(PLR_HELM_ID,index) ]
		ClientEvent("update", ENT_ME, IndexOf(PLR_HELM_ID), "game_show", RaceOf(ENT_ME), GenderOf(ENT_ME), "ext_helm_expar");
	}

	// ext_set_spiral
	// <type> <dmg>
	void PlayerExternals_OnExtSetSpiral(string spiralKind = "", string damage = "")
	{
		SPIRAL_DMG = damage;

		SPIRAL_SKILL = "archery";

		// recache xfireball3.spr
		// recache firemagic.spr
		if (spiralKind == "fire")
		{
			SPIRAL_DMG_TYPE = "fire_effect";
			SPIRAL_SPIRTE_FILE = "rjet1.spr";
			SPIRAL_SPRITE_FRAMES = 5;
			SPIRAL_SPRITE_SCALE = 0.75f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 255, 255);
			SPIRAL_GLOW_COLOR = Vector3(255, 0, 0);
		}

		if (spiralKind == "cold")
		{
			SPIRAL_DMG_TYPE = "cold_effect";
			SPIRAL_SPIRTE_FILE = "char_breath.spr";
			SPIRAL_SPRITE_FRAMES = 1;
			SPIRAL_SPRITE_SCALE = 2.5f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 255, 255);
			SPIRAL_GLOW_COLOR = Vector3(128, 128, 255);
		}

		if (spiralKind == "lightning")
		{
			SPIRAL_DMG_TYPE = "lightning_effect";
			SPIRAL_SPIRTE_FILE = "3dmflaora.spr";
			SPIRAL_SPRITE_FRAMES = 1;
			SPIRAL_SPRITE_SCALE = 0.5f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 255, 0);
			SPIRAL_GLOW_COLOR = Vector3(255, 255, 0);
		}
	}

	// ext_bear_mode
	void PlayerExternals_OnExtBearMode(CBaseEntity@ bearImageId = null)
	{
		if (PLR_BEAR_MODE)
			return;
		@PLR_BEAR_IMAGE_ID = bearImageId;
		PLR_BEAR_MODE = true;

		// cl method abandoned
		// clientevent new all effects/sfx_bear_overlay $get(ent_me,index)
		// setvard PLR_BEAR_CL_INDEX game.script.last_sent_id
		// lock method abandoned
		// callevent ext_removed_effects lock
		OnExtInvis();

		ScriptFlags(ENT_ME, "add", "bear", "nopush", 1, -1, "none");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 256, 10, 1, 256);
	}

	// ext_bear_mode_end
	void PlayerExternals_OnExtBearModeEnd()
	{
		if (!PLR_BEAR_MODE)
			return;

		PLR_BEAR_MODE = false;

		OnExtVisible();

		ScriptFlags(ENT_ME, "remove", "bear");
	}

	// ext_test
	void PlayerExternals_OnExtTest(string value = "", string value2 = "", string value3 = "", string value4 = "")
	{
		DebugPrint("test vent " + value + " " + value2 + " " + value3 + " " + value4);
	}

	// ext_block_weather
	// <0|1>
	void PlayerExternals_OnExtBlockWeather(string flag = "")
	{
		PLR_WEATHER_BLOCK = flag;
	}

	// ext_stam
	void PlayerExternals_OnExtStam(string drainAmount = "")
	{
		LegacyCommand("drainstamina", ENT_ME, drainAmount);
	}

	// ext_stuck_adj
	void PlayerExternals_OnExtStuckAdj()
	{
		if (!(GameTime() > PLR_NEXT_STUCK_ADJ))
			return;
		PLR_NEXT_STUCK_ADJ = GameTime() + 5.0f;
		Vector3 adjOrg = OriginOf(ENT_ME);
		adjOrg.z += 8.0f;
		string traceStart = Text(adjOrg);
		string traceEnd = Text(adjOrg);
		traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, 38.0f));
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			PlayerMessageDark(ENT_ME, "[/STUCK]: Not enough head room to adjust up.");
		else
			SetOrigin(ENT_ME, adjOrg);
	}

	// ext_olof_setstatus
	void PlayerExternals_OnExtOlofSetstatus(string status = "")
	{
		// dbg ext_olof_setstatus PLR_OLOF_STATUS
		PLR_OLOF_STATUS = status;
		if (status == "reset") // debuggary
			PLR_OLOF_STATUS = "PLR_OLOF_STATUS";
	}

	// ext_reset_model
	// external for redisplaying model when new players connect
	void PlayerExternals_OnExtResetModel()
	{
		// if ( PLR_BEAR_MODE )
		// {
		// setmodelbody 0 1
		// setmodelbody 1 2
		// }
		// if !PLR_BEAR_MODE
		OnExtSetGender();
		CallEventDelayed(0.1f, "ext_setbodytype");
	}

	// ext_invis
	void PlayerExternals_OnExtInvis()
	{
		// hide player and items
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 1); // use 1 instead of 0 or some functions fail do to sys thinking not rendering
		CallExternal("all", "ext_render_items", self, 5, 0);
	}

	// ext_visible
	void PlayerExternals_OnExtVisible()
	{
		// restore player and items
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		CallExternal("all", "ext_render_items", self, 0, 255);
	}

	// ext_acid_feaura_activate
	// { hold_person_end
	// callevent ext_remove_status_flag hold_person
	// }
	// CMD JUN2010 poison aura (for items/blunt_gauntlets_fe1 and 2)
	// Deos acid damage so it can be used with items/armor_paura
	// <dot> <size>
	void PlayerExternals_OnExtAcidFeauraActivate(string dotDamage = "", int radius = 0)
	{
		if (PLR_FEAURA)
			return;
		PLR_FEAURA = true;
		PLR_FEAURA_DOT = dotDamage;
		PLR_FEAURA_AOE = radius;

		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), PLR_FEAURA_AOE, PLR_PAURA_CL_RATE); // May as well use the same refresh rate
		PLR_FEAURA_CLIDX = LastClientScriptId();
		PLR_FEAURA_NEXT_CL = GameTime() + PLR_PAURA_CL_RATE;
		OnAcidFeauraLoop();
	}

	// acid_feaura_loop
	void PlayerExternals_OnAcidFeauraLoop()
	{
		if (!PLR_FEAURA)
			return;
		CallEventDelayed(1.0f, "acid_feaura_loop");

		float gameTime = GameTime();

		if (gameTime > PLR_FEAURA_NEXT_CL)
		{
			ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), PLR_FEAURA_AOE, PLR_PAURA_CL_RATE);
			PLR_FEAURA_CLIDX = LastClientScriptId();
			PLR_FEAURA_NEXT_CL = gameTime + PLR_PAURA_CL_RATE;
		}

		if (!IsAlive(ENT_ME))
			return;
		PLR_FEAURA_SCAN = FindInSphere("enemy", PLR_FEAURA_AOE);
		if (PLR_FEAURA_SCAN == "none")
			return;
		int count = GetTokenCount(PLR_FEAURA_SCAN);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAcidFeauraBurn();
		}
	}

	// acid_feaura_burn
	void PlayerExternals_OnAcidFeauraBurn()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_FEAURA_SCAN, loopIteration));
		if (RelationshipOf(curTarg, ENT_ME) != "enemy")
			return;
		if (GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		if (!IS_AFK)
			ApplyEffect(curTarg, "effects/dot_acid", 5.0f, self, PLR_FEAURA_DOT, "spellcasting.affliction");
	}

	// ext_acid_feaura_remove
	void PlayerExternals_OnExtAcidFeauraRemove()
	{
		PLR_FEAURA = false;
		ClientEvent("update", "all", PLR_FEAURA_CLIDX, "remove_me");
	}

	// ext_weather_change
	void PlayerExternals_OnExtWeatherChange(string weather = "")
	{
		if (!PLR_IN_WORLD)
			return;

		// dbg ext_change_weather PARAM1
		PLR_WEATHER = weather;

		if (GetVar("G_WEATHER_LOCK") != "0")
			PLR_WEATHER = GetVar("G_WEATHER_LOCK");
		else if (PLR_LOCK_CLEAR)
			PLR_WEATHER = "clear";

		if (PLR_WEATHER == "storm")
			PLR_WEATHER = "rain_storm";

		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "weather_change", PLR_WEATHER);
	}

	// ext_weather_force_change
	void PlayerExternals_OnExtWeatherForceChange(string weather = "")
	{
		// dbg ext_weather_force_change PARAM1
		PLR_WEATHER = weather;

		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "weather_force_change", weather);
	}

	// ext_repel_shield
	// <duration> <radius> [special_effect]
	void PlayerExternals_OnExtRepelShield(float duration = 0.0f, int radius = 0, string specialEffect = "")
	{
		// dbg ext_repel_shield PARAM1 PARAM2 PARAM3
		CallEventDelayed(duration, "ext_end_repel_shield");
		PLR_REPEL_SHIELD_ACTIVE = true;
		PLR_REPEL_SHIELD_RADIUS = radius;
		PLR_REPEL_SHIELD_SPECIAL = specialEffect;
		GAME_PVP = (IsPvp() ? 1 : 0);
		OnLoopRepelShield();

		if (PLR_REPEL_SHIELD_SPECIAL == "darkfire")
		{
			ClientEvent("new", "all", "effects/sfx_raura", IndexOf(ENT_ME), duration);
			PLR_DAURA_CL_IDX = LastClientScriptId();
			ServerPlaySound(1, 10, "magic/chant_loop.wav");
		}
	}

	// loop_repel_shield
	void PlayerExternals_OnLoopRepelShield()
	{
		if (!PLR_REPEL_SHIELD_ACTIVE)
			return;
		CallEventDelayed(0.2f, "loop_repel_shield");
		PLR_REPEL_SHIELD_TARGETS = FindInSphere("enemy", PLR_REPEL_SHIELD_RADIUS);
		// dbg loop_repel_shield PLR_REPEL_SHIELD_RADIUS PLR_REPEL_SHIELD_TARGETS
		if (PLR_REPEL_SHIELD_TARGETS == "none")
			return;
		int count = GetTokenCount(PLR_REPEL_SHIELD_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargetsRepelShield();
		}
	}

	// affect_targets_repel_shield
	void PlayerExternals_OnAffectTargetsRepelShield()
	{
		bool exitSub = false;
		bool doPush = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_REPEL_SHIELD_TARGETS, loopIteration));
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		if (PLR_REPEL_SHIELD_SPECIAL == "darkfire")
		{
			float shadowDmg = SkillOf(ENT_ME, "spellcasting.affliction");
			// multiply SHADOW_DMG 0.25
			ApplyEffect(curTarg, "effects/dot_dark", 5, self, shadowDmg, "swordsmanship");
		}

		float targHp = HealthOf(curTarg);
		float myHpX = MaxHealthOf(ENT_ME) * 4.0f;
		if (targHp < 1500.0f)
			doPush = true;
		if (targHp < myHpX)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		if (GameTime() > NEXT_REPEL_SHIELD_SOUND)
		{
			NEXT_REPEL_SHIELD_SOUND = GameTime() + 0.5f;
			PlaySound(0, 5, "doors/aliendoor3.wav");
		}
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// ext_end_repel_shield
	void PlayerExternals_OnExtEndRepelShield()
	{
		if (PLR_REPEL_SHIELD_SPECIAL == "darkfire")
		{
			ClientEvent("update", "all", PLR_DAURA_CL_IDX, "remove_fx");
			ServerPlaySound(1, 0, "magic/chant_loop.wav");
		}
		// dbg ext_end_repel_shield
		PLR_REPEL_SHIELD_ACTIVE = false;
	}

	// ext_set_dark_level
	// <rating>
	void PlayerExternals_OnExtSetDarkLevel(float rating = 0.0f)
	{
		PLR_DARK_LEVEL = rating;
		Quest("set", ENT_ME, "dl", PLR_DARK_LEVEL);
		CallExternal(ENT_ME, "player_calc_holy_resistance");
	}

	// ext_tossprojectile
	// <projectile scriptname> <view|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //New projectile parameters, more in line with xdodamage
	void PlayerExternals_OnExtTossprojectile(string projectile = "", string view = "", string target = "", int speed = 0, string damage = "", int cof = 0, string skill = "", string value = "", string value2 = "")
	{
		TossProjectile(projectile, view, target, speed, damage, cof, skill, value, value2); // last two parms here for no particular reason
		@PLR_LAST_PROJECTILE = EntityOf(ENT_LASTPROJECTILE);
	}

	// ext_sfaura_start
	// Shadowfire aura for blade of same name (slowly expands, pushes targs away)
	void PlayerExternals_OnExtSfauraStart(CBaseEntity@ item = null)
	{
		PLR_SFAURA_SIZE = 65.0f;
		@PLR_SFAURA_ITEM = item; // id of item that started it
		GAME_PVP = (IsPvp() ? 1 : 0);
		PLR_SFAURA_DOT = SkillOf(ENT_ME, "spellcasting.fire") * 0.5f;
		PLR_SFAURA_MAXPUSH = MaxHealthOf(ENT_ME) * 4.0f;
		float sizeRatio = Divide(PLR_SFAURA_SIZE, PLR_SFAURA_MAXSIZE);
		ClientEvent("new", "all", "effects/sfx_sfaura", IndexOf(ENT_ME), sizeRatio, 20.0f);
		PLR_SFAURA_CL_IDX = LastClientScriptId();
		ServerPlaySound(1, 10, "ambience/rocketrumble1.wav");
		PLR_SFAURA_ACTIVE = true;
		OnSfauraLoop();
		CallEventDelayed(20.0f, "sfaura_fx_refresh");
	}

	// sfaura_loop
	void PlayerExternals_OnSfauraLoop()
	{
		if (!PLR_SFAURA_ACTIVE)
			return;

		if (ManaOf(ENT_ME) <= 10.0f)
		{
			PlayerMessageDark(ENT_ME, "Shadowfire Blade: Insufficient mana for Shadowfire Aura");
			OnExtSfauraEnd();
		}

		CallEventDelayed(0.2f, "sfaura_loop");
		GiveMana(ENT_ME, -PLR_SFAURA_MP_COST);

		if (PLR_SFAURA_SIZE < PLR_SFAURA_MAXSIZE)
			PLR_SFAURA_SIZE += PLR_SFAURA_GROWTH_RATE;
		if (PLR_SFAURA_SIZE > PLR_SFAURA_MAXSIZE)
		{
			// dbg sfaura_server_maxsize
			PLR_SFAURA_SIZE = PLR_SFAURA_MAXSIZE;
		}

		PLR_SFAURA_TARGS = FindInSphere("enemy", PLR_SFAURA_SIZE);

		// dbg sfaura_loop [ PLR_SFAURA_SIZE ] PLR_SFAURA_TARGS
		if (PLR_SFAURA_TARGS == "none")
			return;
		int count = GetTokenCount(PLR_SFAURA_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSfauraAffectTargets();
		}
	}

	// sfaura_affect_targets
	void PlayerExternals_OnSfauraAffectTargets()
	{
		bool exitSub = false;
		bool doPush = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_SFAURA_TARGS, loopIteration));
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		Vector3 traceStart = OriginOf(ENT_ME);
		Vector3 traceEnd = OriginOf(curTarg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != Text(traceEnd))
			return;

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, PLR_SFAURA_DOT, "swordsmanship");

		float resistRoll = 1.0f - Random(0, 1);
		float fireResist = DamageTakenOf(curTarg, "fire");
		if (!(resistRoll < fireResist))
			return;

		if (GameTime() > PLR_NEXT_FSAURA_SOUND)
		{
			PLR_NEXT_FSAURA_SOUND = GameTime() + 1.0f;
			PlaySound(0, 5, "ambience/flameburst1.wav");
		}

		if (HealthOf(curTarg) < 1500.0f)
			doPush = true;
		if (HealthOf(curTarg) < PLR_SFAURA_MAXPUSH)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// sfaura_fx_refresh
	void PlayerExternals_OnSfauraFxRefresh()
	{
		if (!PLR_SFAURA_ACTIVE)
			return;

		float sizeRatio = Divide(PLR_SFAURA_SIZE, PLR_SFAURA_MAXSIZE);

		ServerPlaySound(1, 10, "ambience/rocketrumble1.wav");

		// dbg sfaura_fx_refresh SIZE_RATIO
		ClientEvent("new", "all", "effects/sfx_sfaura", IndexOf(ENT_ME), sizeRatio, 20.0f);
		PLR_SFAURA_CL_IDX = LastClientScriptId();
		CallEventDelayed(20.0f, "sfaura_fx_refresh");
	}

	// ext_sfaura_end
	// 'remote' indicates end request from item
	void PlayerExternals_OnExtSfauraEnd(string endSource = "")
	{
		ServerPlaySound(1, 0, "ambience/rocketrumble1.wav");
		PLR_SFAURA_ACTIVE = false;
		ClientEvent("update", "all", PLR_SFAURA_CL_IDX, "remove_fx");
		if (endSource != "remote")
			CallExternal(PLR_SFAURA_ITEM, "ext_faura_ended");
	}

	// ext_toss_spear
	// <charge_level> <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none>
	void PlayerExternals_OnExtTossSpear(string chargeLevel = "", string projectile = "", string sourceOrigin = "", string target = "", string speed = "", int damage = 0, string cof = "", string skill = "")
	{
		PLR_SPEAR_CHARGE_LEVEL = chargeLevel;
		TossProjectile(projectile, sourceOrigin, target, speed, damage, cof, skill);
		@PLR_LAST_PROJECTILE = EntityOf(ENT_LASTPROJECTILE);
	}

	// ext_holy_aura
	// <duration> <radius> <power>
	void PlayerExternals_OnExtHolyAura(float duration = 0.0f, int radius = 0, string power = "")
	{
		// dbg ext_holy_aura PARAM1 PARAM2 PARAM3
		if (PLR_HAURA_ACTIVE)
			return;

		CallEventDelayed(duration, "ext_end_holy_aura");
		PLR_HAURA_ACTIVE = true;
		PLR_HAURA_RADIUS = radius;
		PLR_HAURA_POWER = power;
		OnLoopHolyAura();
		ServerPlaySound(2, 10, "ambience/alien_powernode.wav");

		float auraSize = PLR_HAURA_RADIUS * 1.5f;
		float auraMdlOfs = 25.0f;
		if (PLR_HAURA_RADIUS > 256)
			auraMdlOfs += 1.0f;
		ClientEvent("new", "all", "effects/sfx_seal_follow", IndexOf(ENT_ME), 10.0f, auraMdlOfs, 1, Vector3(255, 200, 0), auraSize);
		PLR_HAURA_CL_ID = LastClientScriptId();
		CallEventDelayed(10.0f, "holy_aura_refresh");
	}

	// holy_aura_refresh
	void PlayerExternals_OnHolyAuraRefresh()
	{
		if (!PLR_HAURA_ACTIVE)
			return;
		float auraSize = PLR_HAURA_RADIUS * 1.5f;
		float auraMdlOfs = 25.0f;
		if (PLR_HAURA_RADIUS > 256)
			auraMdlOfs += 1.0f;
		ClientEvent("new", "all", "effects/sfx_seal_follow", IndexOf(ENT_ME), 10.0f, auraMdlOfs, 1, Vector3(255, 200, 0), auraSize);
		PLR_HAURA_CL_ID = LastClientScriptId();
		CallEventDelayed(10.0f, "holy_aura_refresh");
	}

	// loop_holy_aura
	void PlayerExternals_OnLoopHolyAura()
	{
		if (!PLR_HAURA_ACTIVE)
			return;
		CallEventDelayed(0.5f, "loop_holy_aura");
		PLR_HAURA_TARGETS = FindInSphere("any", PLR_HAURA_RADIUS);
		// dbg loop_holy_aura PLR_HAURA_RADIUS PLR_HAURA_TARGETS
		if (PLR_HAURA_TARGETS == "none")
			return;
		int count = GetTokenCount(PLR_HAURA_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargetsHolyAura();
		}
	}

	// affect_targets_holy_aura
	void PlayerExternals_OnAffectTargetsHolyAura()
	{
		bool healTarget = false;
		bool exitSub = false;
		bool doPush = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_HAURA_TARGETS, loopIteration));
		if (RelationshipOf(curTarg, ENT_ME) == "ally")
			healTarget = true;
		if (IsPlayer(curTarg))
			healTarget = true;
		if (Truthy(ScriptVarOf(curTarg, "PLAYING_DEAD")) && !IsPlayer(curTarg))
			healTarget = false;

		if (healTarget)
		{
			ApplyEffect(curTarg, "effects/effect_rejuv2", 0, PLR_HAURA_POWER, self);
			exitSub = true;
		}
		if (exitSub)
			return;

		float nmeUnholy = DamageTakenOf(curTarg, "holy");
		if (!(nmeUnholy > 0.0f))
			return;

		if (!Truthy(LegacyFunction("can_damage", @curTarg, ENT_ME)))
			return;

		float targHp = HealthOf(curTarg);
		float myHpX = SkillOf(ENT_ME, "spellcasting.divination") * 100.0f;
		if (targHp < 1500.0f)
			doPush = true;
		if (targHp < myHpX)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		if (GameTime() > NEXT_HAURA_SOUND)
		{
			NEXT_HAURA_SOUND = GameTime() + 0.5f;
			PlaySound(0, 5, "doors/aliendoor3.wav");
		}
		float pushStr = 300.0f * nmeUnholy;
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, pushStr, 0)));
	}

	// ext_end_holy_aura
	void PlayerExternals_OnExtEndHolyAura()
	{
		if (PLR_HAURA_ACTIVE)
		{
			ServerPlaySound(2, 0, "ambience/alien_powernode.wav");
			ClientEvent("update", "all", PLR_HAURA_CL_ID, "remove_fx");
		}
		PLR_HAURA_ACTIVE = false;
	}

	// ext_setskin
	// debug, no workie
	void PlayerExternals_OnExtSetskin(string skinName = "")
	{
		SetProp(ENT_ME, "skin", skinName);
	}

	// ext_pole_lshield
	void PlayerExternals_OnExtPoleLshield()
	{
		if (PLR_PLSHIELD_ACTIVE)
			return;
		PLR_PLSHIELD_ACTIVE = true;
		PLR_PLSHIELD_DOT = SkillOf(ENT_ME, "spellcasting.lightning") * 0.25f;
		PLR_PLSHIELD_PUSH = 500; // const
		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "items/polearms_ph_spin_cl", IndexOf(ENT_ME));
		PLR_PLSHIELD_CL_IDX = LastClientScriptId();
		ServerPlaySound(1, 10, "magic/bolt_loop.wav");
		OnPoleLshieldLoop();
	}

	// pole_lshield_loop
	void PlayerExternals_OnPoleLshieldLoop()
	{
		bool exitSub = false;
		if (!PLR_PLSHIELD_ACTIVE)
			return;
		CallEventDelayed(0.5f, "pole_lshield_loop");

		GiveMana(ENT_ME, -1);
		if (ManaOf(ENT_ME) <= 1.0f)
		{
			PlayerMessageDark(ENT_ME, "Stormpharaoh's Lance: Insufficient mana for Lightning Shield");
			OnExtPoleLshieldEnd();
			exitSub = true;
		}
		if (exitSub)
			return;

		Vector3 scanLoc = OriginOf(ENT_ME);
		OWNER_YAW = Text(AnglesOf(ENT_ME).y);
		scanLoc += RelativePosition(Vector3(0, Float(OWNER_YAW), 0), Vector3(0, 64, 0));
		PLR_PLSHIELD_TARGETS = LegacyFunction("get_tsphere", "enemy", 64, scanLoc);
		if (PLR_PLSHIELD_TARGETS == "none")
			return;
		int count = GetTokenCount(PLR_PLSHIELD_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoleLshieldAffectTargets();
		}
	}

	// pole_lshield_affect_targets
	void PlayerExternals_OnPoleLshieldAffectTargets()
	{
		bool exitSub = false;
		CBaseEntity@ curTarget = FindEntity(GetToken(PLR_PLSHIELD_TARGETS, loopIteration));
		if (GAME_PVP == 0 && IsPlayer(curTarget))
			exitSub = true;
		if (exitSub)
			return;

		float pushStr = PLR_PLSHIELD_PUSH * DamageTakenOf(curTarget, "lightning");
		AddVelocity(curTarget, RelativePosition(Vector3(0, Float(OWNER_YAW), 0), Vector3(0, pushStr, 10)));
		ApplyEffect(curTarget, "effects/dot_lightning", 5.0f, self, PLR_PLSHIELD_DOT);

		if (GameTime() > NEXT_PLSHIELD_SOUND)
		{
			NEXT_PLSHIELD_SOUND = GameTime() + 0.5f;
			PlaySound(2, 5, "magic/bolt_end.wav");
		}
	}

	// ext_pole_lshield_end
	void PlayerExternals_OnExtPoleLshieldEnd()
	{
		if (PLR_PLSHIELD_ACTIVE)
		{
			ServerPlaySound(1, 0, "magic/bolt_loop.wav");
			ClientEvent("update", "all", PLR_PLSHIELD_CL_IDX, "end_fx");
		}
		PLR_PLSHIELD_ACTIVE = false;
	}

	// svilla_music
	void PlayerExternals_OnSvillaMusic()
	{
		DebugPrint("svilla_music " + GetVar("G_SORCV_FRIENDLY"));

		if (Truthy(GetVar("G_SORCV_FRIENDLY")))
		{
			// haunted_desert.mp3
			PlayMusic(ENT_ME, "combat", "PathAnubis.mp3");
		}
		else
		{
			PlayMusic(ENT_ME, "combat", "crimson_field.mp3");
		}
	}

	// svilla_music2
	void PlayerExternals_OnSvillaMusic2()
	{
		DebugPrint("svilla_music2 " + GetVar("G_SORCV_FRIENDLY"));

		if (Truthy(GetVar("G_SORCV_FRIENDLY")))
			PlayMusic(ENT_ME, "combat", "haunted_desert.mp3");
		else
			PlayMusic(ENT_ME, "combat", "crimson_field.mp3");
	}

	// ext_stop_music
	void PlayerExternals_OnExtStopMusic()
	{
		PlayMusic(ENT_ME, "stop");
	}

	// ext_svilla_hostile
	void PlayerExternals_OnExtSvillaHostile()
	{
		SetGlobal("G_SORCV_FRIENDLY", 0);
	}

	// ext_weather_set_clear
	// temp debug
	// { [shared]
	// repeatdelay 1.0
	// if ( game.clientside )
	// {
	// local MY_ID game.localplayer.index
	// local MY_ORG $getcl(MY_ID,origin)
	// local MY_ANG $getcl(MY_ID,viewangles)
	// vectoradd MY_ORG z 36
	// local TRACE_START MY_ORG
	// local TRACE_END MY_ORG
	// vectoradd TRACE_END $relpos(MY_ANG,$vec(0,100,0))
	// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
	// local TRACE_LINE_CONTENTS $get_traceline(TRACE_START,TRACE_END,contents)
	// if ( TRACE_LINE isnot TRACE_END )
	// {
	// local TRACE_HITWALL 1
	// }
	// else
	// {
	// local TRACE_HITWALL 0
	// }
	// dbg TRACE_LINE hit TRACE_HITWALL ang MY_ANG
	// cleffect beam_points TRACE_START TRACE_LINE lgtning.spr 0.5 1 0.01 255 1 1 (255,0,255)
	// }
	// }
	void PlayerExternals_OnExtWeatherSetClear()
	{
		PLR_LOCK_CLEAR = true;
		OnExtWeatherChange("clear");
	}

	// ext_weather_manual_change
	void PlayerExternals_OnExtWeatherManualChange(string weather = "")
	{
		PLR_LOCK_CLEAR = false;
		OnExtWeatherChange(weather);
	}

	// trig_srocv_player_on_shelf
	void PlayerExternals_OnTrigSrocvPlayerOnShelf()
	{
		CBaseEntity@ alchId = FindByName("sorc_alchie");
		CallExternal(alchId, "ext_player_on_shelf");
	}

	// trig_srocv_player_on_table
	void PlayerExternals_OnTrigSrocvPlayerOnTable()
	{
		CBaseEntity@ alchId = FindByName("sorc_alchie");
		CallExternal(alchId, "ext_player_on_table");
	}

	// ext_bravery
	void PlayerExternals_OnExtBravery()
	{
		PlayerMessageGreen(ENT_ME, "You will take no penalty for your next death");
		PLR_BRAVERY = true;
		PlaySound(0, 10, "voices/human/male_guard_hail.wav");
	}

	// ext_dmg_adjust
	// <type> <ratio>
	void PlayerExternals_OnExtDmgAdjust(string damageType = "", string ratio = "")
	{
		if (damageType == "fire")
			PLR_DMG_ADJUST_FIRE = ratio;
	}

	// ext_dmg_add_dot
	// <type> <ratio>
	void PlayerExternals_OnExtDmgAddDot(string damageType = "", string ratio = "")
	{
		if (damageType == "fire")
			PLR_ADD_FIRE_DOT = ratio;
	}

	// trig_damage
	// using scriptflag sys isntead
	// { ext_mana_font_start //<amt>
	// if ( PARAM1 > PLR_MANA_FONT_AMT ) setvard PLR_MANA_FONT_AMT PARAM1
	// if !PLR_MANA_FONT
	// setvard PLR_MANA_FONT 1
	// callevent mana_font_loop
	// }
	// { mana_font_loop
	// if PLR_MANA_FONT
	// callevent 1.0 mana_font_loop
	// if $get(ent_me,mp) < $get(ent_me,maxmp)
	// givemp ent_me PLR_MANA_FONT_AMT
	// }
	// <name>;<dmg>;<dmg_type> - called by a map brush with scriptevent
	void PlayerExternals_OnTrigDamage(string triggerName = "", string damage = "", string damageType = "")
	{
		// infomsg ent_me trig_damage $stradd(PARAM1,-,PARAM2,-,PARAM3)
		string trigDmgType = damageType + "_effect";
		CallExternal(GetVar("GAME_MASTER"), "gm_setname", triggerName);
		DoDamageEx(ENT_ME, "direct", damage, "100%", GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", trigDmgType);
	}

	// ext_playrandomsound
	void PlayerExternals_OnExtPlayrandomsound(int channel = 0, int volume = 0, string attenuation = "", string pitch = "", string sound1 = "", string sound2 = "", string sound3 = "", string sound4 = "", string sound5 = "")
	{
		bool exitSub = false;

		if (sound1.isEmpty())
		{
			PlayRandomSound(channel, volume, attenuation, pitch);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (sound2.isEmpty())
		{
			PlayRandomSound(channel, volume, attenuation, pitch, sound1);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (sound3.isEmpty())
		{
			PlayRandomSound(channel, volume, attenuation, pitch, sound1, sound2);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (sound4.isEmpty())
		{
			PlayRandomSound(channel, volume, attenuation, pitch, sound1, sound2, sound3);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (sound5.isEmpty())
		{
			PlayRandomSound(channel, volume, attenuation, pitch, sound1, sound2, sound3, sound4);
			exitSub = true;
		}
		if (exitSub)
			return;
		PlayRandomSound(channel, volume, attenuation, pitch, sound1, sound2, sound3, sound4, sound5);
	}

	// ext_orcfor_boss_musak
	// <stage> [boss_org]
	void PlayerExternals_OnExtOrcforBossMusak(int stage = 0, Vector3 bossOrigin = Vector3())
	{
		if (stage == 1)
		{
			PLR_ORCFOR_MUSIC = 1;
			PlayMusic(ENT_ME, "combat", "seruboss1.mp3");
		}

		if (stage == 2 && PLR_ORCFOR_MUSIC != 2)
		{
			PLR_ORCFOR_MUSIC = 2;
			PlayMusic(ENT_ME, "combat", "seruboss2.mp3");
		}

		if (stage == 3)
		{
			Vector3 myOrg = OriginOf(ENT_ME);
			Vector3 bossOrg = bossOrigin;
			if (Distance(myOrg, bossOrg) < 768.0f)
				PlayMusic(ENT_ME, "stop");
		}
	}

	// ext_gabe_musak
	// <stage> [boss_org]
	void PlayerExternals_OnExtGabeMusak(string stage = "")
	{
		if (stage == "stop")
			PlayMusic(ENT_ME, "stop");
		else
			PlayMusic(ENT_ME, "combat", "gabe1.mp3");
	}

	// ext_changelevel_prep
	void PlayerExternals_OnExtChangelevelPrep()
	{
		OnExtWeatherForceChange("clear");
	}

	// ext_bank_lock
	void PlayerExternals_OnExtBankLock()
	{
		ApplyEffect(ENT_ME, "effects/effect_templock");
		CallEventDelayed(1.0f, "ext_bank_lock_release");
	}

	// ext_bank_lock_release
	void PlayerExternals_OnExtBankLockRelease()
	{
		CallExternal(ENT_ME, "ext_end_templock");
	}

	// ext_alance_init
	void PlayerExternals_OnExtAlanceInit()
	{
		GAME_PVP = (IsPvp() ? 1 : 0);
		AFL_BURST_DOT = SkillOf(ENT_ME, "spellcasting.affliction") * 0.75f;
	}

	// alance_dodamage
	void PlayerExternals_OnAlanceDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		bool doPush = false;

		// dbg alance_dodamage PARAM1 $get(PARAM2,name)
		if (!hit)
			return;
		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		ApplyEffect(target, "effects/dot_poison", 5.0f, self, AFL_BURST_DOT);

		float targHp = HealthOf(target);
		float myHpX = MaxHealthOf(ENT_ME) * 4.0f;
		if (targHp < 1500.0f)
			doPush = true;
		if (targHp < myHpX)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// ext_drainstamina
	void PlayerExternals_OnExtDrainstamina(string amount = "")
	{
		LegacyCommand("drainstamina", ENT_ME, amount);
	}

	// ext_clbeam
	void PlayerExternals_OnExtClbeam()
	{
		string beamTarg = FindInSphere("enemy", 1024);
		beamTarg = GetToken(beamTarg, 0);
		// dbg ext_clbeam $get(BEAM_TARG,name)
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "set_test_beam", IndexOf(ENT_ME), IndexOf(beamTarg));
	}

	// ext_repel_burst
	// <burst_dmg> <radius> <falloff> <skill|none> <dmg_type> <strength> <maxhp> [dot_effect] [dot_dur] [dot_dmg]
	void PlayerExternals_OnExtRepelBurst(int burstDamage = 0, int radius = 0, int falloff = 0, string damageType = "", string damageSkill = "", int strength = 0, float maxHp = 0.0f, Vector3 origin = Vector3())
	{
		PLR_REPEL_PUSH_STR = strength;
		PLR_REPEL_MAX_HP = maxHp;

		PLR_REPEL_ORG = origin;

		if (!StartsWith(Text(PLR_REPEL_ORG), "("))
			PLR_REPEL_ORG = OriginOf(ENT_ME);

		DoDamageEx(PLR_REPEL_ORG, radius, burstDamage, falloff, ENT_ME, ENT_ME, damageSkill, damageType, "dmgevent:repel");
	}

	// repel_dodamage
	void PlayerExternals_OnRepelDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		OnExtRepel(target, PLR_REPEL_ORG, PLR_REPEL_PUSH_STR, 110, PLR_REPEL_MAX_HP, 0); // externals_shared}
	}

	// ext_repel
	// <target> <origin> <strength> [vboost] [maxhp] [override:0|1]
	void PlayerExternals_OnExtRepel(CBaseEntity@ target = null, Vector3 origin = Vector3(), float strength = 0.0f, int verticalBoost = 0, float maxTargetHp = 0.0f, int overrideFlag = 0)
	{
		// we're just doing this far too often, centralizing it in externals
		// this should be in externals_shared
		Vector3 targOrg = OriginOf(target);
		float pushvel = strength;

		DebugPrint("ext_repel vel " + Text(pushvel) + " max " + Text(maxTargetHp) + " vs. " + Text(HealthOf(target)) + " [ " + NameOf(target) + " ]");

		if (maxTargetHp > 0.0f)
		{
			float targHp = HealthOf(target);
			if (targHp > maxTargetHp) // too strong to push
				return;
			// decrease push if targ hp > 50% of max push hp
			if (targHp > maxTargetHp * 0.5f)
			{
				float ratio = 1.0f - Divide(targHp, maxTargetHp);
				pushvel *= ratio;
			}
		}

		// dbg ext_repel reduced rat L_RATIO fpush L_PUSHVEL
		DebugPrint("ext_repel fvel " + Text(pushvel));

		float newAng = AnglesTo(origin, targOrg);

		if (overrideFlag != 0)
			AddVelocity(target, RelativeVelocity(Vector3(0, newAng, 0), Vector3(0, pushvel, verticalBoost)), "override");
		else
			AddVelocity(target, RelativeVelocity(Vector3(0, newAng, 0), Vector3(0, pushvel, verticalBoost)));
	}

	// ext_lcod
	// <origin> <dmg> <duration>
	void PlayerExternals_OnExtLcod(Vector3 origin = Vector3(), string damage = "", float duration = 0.0f)
	{
		PLR_LCOD_POS = origin;
		PLR_LCOD_DMG = damage;
		PLR_LCOD_DUR = duration;

		// sound.play3d ambience/alien_minddrill.wav 10 PLR_LCOD_POS 0.8 2 //testing (works - though not sure about channel)
		Vector3 clPos = PLR_LCOD_POS;
		clPos.z = GroundHeight(PLR_LCOD_POS);
		// add G_COD_SOUNDCHAN 1
		// if ( G_COD_SOUNDCHAN > 8 ) setvarg G_COD_SOUNDCHAN 1
		// svplaysound 5 8 ambience/pulsemachine.wav
		LegacyCommand("svsound.play3d", "magic/pulsemachine_noloop.wav", 8, PLR_LCOD_POS, 0.8f, 5, 100);
		PLR_NEXT_LCOD_SOUND = GameTime() + 1.88f;

		ClientEvent("new", "all", "effects/sfx_cod", clPos, PLR_LCOD_DUR, 3, 98); // 5-6 for larger
		PLR_LCOD_ACTIVE = true;
		OnLcodLoop();
		CallEventDelayed(PLR_LCOD_DUR, "lcod_end");
	}

	// lcod_loop
	void PlayerExternals_OnLcodLoop()
	{
		if (!PLR_LCOD_ACTIVE)
			return;
		CallEventDelayed(1.0f, "lcod_loop");
		// dbg lcod_loop pos PLR_LCOD_POS dmg PLR_LCOD_DMG dur PLR_LCOD_DUR aoe PLR_LCOD_AOE
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(PLR_LCOD_POS, PLR_LCOD_AOE, PLR_LCOD_DMG, 0, ENT_ME, ENT_ME, "spellcasting.affliction", "dark_effect");

		if (!(GameTime() > PLR_NEXT_LCOD_SOUND))
			return;
		LegacyCommand("svsound.play3d", "magic/pulsemachine_noloop.wav", 8, PLR_LCOD_POS, 0.8f, 5, 100);
		PLR_NEXT_LCOD_SOUND = GameTime() + 1.88f;
	}

	// lcod_end
	void PlayerExternals_OnLcodEnd()
	{
		// svplaysound 5 0 ambience/pulsemachine.wav
		// svsound.play3d ambience/pulsemachine.wav 0 $get(ent_me,origin) 0.8 5 100 //doesnt stop the sound
		PLR_LCOD_ACTIVE = false;
	}

	// ext_gcod
	// <origin> <dmg> <duration>
	void PlayerExternals_OnExtGcod(Vector3 origin = Vector3(), string damage = "", float duration = 0.0f)
	{
		PLR_GCOD_POS = origin;
		PLR_GCOD_DMG = damage;
		PLR_GCOD_DUR = duration;

		Vector3 clPos = PLR_GCOD_POS;
		clPos.z = GroundHeight(PLR_GCOD_POS);
		// add G_COD_SOUNDCHAN 1
		// if ( G_COD_SOUNDCHAN > 8 ) setvarg G_COD_SOUNDCHAN 1
		// svplaysound 3 10 ambience/pulsemachine.wav
		LegacyCommand("svsound.play3d", "magic/pulsemachine_noloop.wav", 10, PLR_GCOD_POS, 0.8f, 3, 100);
		PLR_NEXT_GCOD_SOUND = GameTime() + 1.88f;

		ClientEvent("new", "all", "effects/sfx_cod", clPos, PLR_GCOD_DUR, 5, 196); // 5-6 for larger
		PLR_GCOD_ACTIVE = true;
		OnGcodLoop();
		CallEventDelayed(PLR_GCOD_DUR, "gcod_end");
	}

	// gcod_loop
	void PlayerExternals_OnGcodLoop()
	{
		if (!PLR_GCOD_ACTIVE)
			return;
		CallEventDelayed(0.5f, "gcod_loop");
		DoDamageEx(PLR_GCOD_POS, PLR_GCOD_AOE, PLR_GCOD_DMG, 0, ENT_ME, ENT_ME, "spellcasting.affliction", "dark_effect");

		if (!(GameTime() > PLR_NEXT_GCOD_SOUND))
			return;
		LegacyCommand("svsound.play3d", "magic/pulsemachine_noloop.wav", 10, PLR_GCOD_POS, 0.8f, 3, 100);
		PLR_NEXT_GCOD_SOUND = GameTime() + 1.88f;
	}

	// gcod_end
	void PlayerExternals_OnGcodEnd()
	{
		// svplaysound 3 0 ambience/pulsemachine.wav
		// svsound.play3d ambience/pulsemachine.wav 0 $get(ent_me,origin) 0.8 3 100 //doesn't stop it
		PLR_GCOD_ACTIVE = false;
	}

	// ext_wraith_active
	// <status:0-dead|1-alive>
	void PlayerExternals_OnExtWraithActive(int status = 0)
	{
		PLR_WRAITH_ACTIVE = status != 0;
	}

	// ext_fissure
	// test
	void PlayerExternals_OnExtFissure()
	{
		string myYaw = Text(ViewAnglesOf(ENT_ME)); // use angles.yaw on monsters
		myYaw = Text(Vec(myYaw).y);

		FISSURE_YAW = myYaw;
		FISSURE_START = OriginOf(ENT_ME);
		// vectorset FISSURE_START z $get_ground_height(FISSURE_START)
		FISSURE_END = FISSURE_START;
		FISSURE_END += RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(0, 768, 0));
		FISSURE_END.z = GroundHeight(FISSURE_END);
		FISSURE_END.z += 32.0f;

		string traceLine = LegacyFunction("get_traceline", FISSURE_START, FISSURE_END, "worldonly");

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			Effect("beam", "point", "lgtning.spr", 10, FISSURE_START, FISSURE_END, Vector3(255, 0, 255), 255, 0, 10);

		// //go up, then trace down to find ground
		// vectoradd FISSURE_END z 128
		// local L_END_DOWN FISSURE_END
		// vectorset L_END_DOWN z -1024
		// setvard FISSURE_END $get_traceline(FISSURE_END,L_END_DOWN,worldonly)
		// local TRACE_START FISSURE_START
		// local TRACE_END FISSURE_END
		// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
		// if ( G_DEVELOPER_MODE )
		// {
		// effect beam point lgtning.spr 10 TRACE_START TRACE_END (255,0,255) 255 0 10
		// }
		FISSURE_LENGTH = Distance(FISSURE_START, FISSURE_END);

		FISSURE_COUNT = 0.0f;
		FISSURE_ACTIVE = true;

		FISSURE_DMG = SkillOf(ENT_ME, "spellcasting.fire");

		// very tempent spammy, might need a G_FISSURE_COUNT check
		bool noRocks = false;
		if (GetVar("G_FISSURES") == "G_FISSURES")
			SetGlobal("G_FISSURES", 0);
		LegacyCommand("add", "G_FISSURES", 1);
		if (Float(GetVar("G_FISSURES")) > 1.0f)
			noRocks = true;
		ClientEvent("new", "all", "effects/sfx_fissure", FISSURE_START, FISSURE_YAW, FISSURE_END, FISSURE_LENGTH, noRocks);

		FISSURE_COUNT = 0.0f;
		FISSURE_MAX_COUNT = Divide(FISSURE_LENGTH, 78.0f);
		if (FISSURE_MAX_COUNT < 1.0f)
			FISSURE_MAX_COUNT = 1.0f;
		FISSURE_ORG = FISSURE_START;
		FISSURE_DIR = DirectionTo(FISSURE_ORG, FISSURE_END);
		OnFissureLoop();
	}

	// fissure_loop
	void PlayerExternals_OnFissureLoop()
	{
		FISSURE_COUNT += 1.0f;
		Vector3 fissureCheckPos = FISSURE_ORG;
		Vector3 fissureMoveamt = FISSURE_DIR * (78.0f * FISSURE_COUNT);
		fissureCheckPos += fissureMoveamt;
		fissureCheckPos.z += 128.0f;
		fissureCheckPos.z = GroundHeight(fissureCheckPos);
		DoDamageEx(fissureCheckPos, 78, FISSURE_DMG, "100%", ENT_ME, ENT_ME, "spellcasting.fire", "fire_effect", "dmgevent:fissure");
		if (FISSURE_COUNT < FISSURE_MAX_COUNT)
			CallEventDelayed(0.20f, "fissure_loop");
		else
			LegacyCommand("subtract", "G_FISSURES", 1);
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string vecUp = Text(fissureCheckPos);
			vecUp = Text(Vec(vecUp) + Vector3(0.0f, 0.0f, 64.0f));
			Effect("beam", "point", "lgtning.spr", 10, fissureCheckPos, vecUp, Vector3(255, 0, 255), 255, 0, 5);
		}
	}

	// fissure_dodamage
	// old way
	// { fissure_loop
	// if FISSURE_ACTIVE
	// callevent 0.5 fissure_loop
	// local BEAM_START FISSURE_START
	// local BEAM_DIR $dir(BEAM_START,FISSURE_END)
	// local BEAM_END FISSURE_START
	// vectoradd BEAM_END z 32
	// vectormultiply BEAM_DIR 128
	// vectoradd BEAM_END BEAM_DIR
	// add FISSURE_COUNT 1
	// local CUR_FISSURE_LENGTH FISSURE_COUNT
	// multiply CUR_FISSURE_LENGTH 128
	// if ( CUR_FISSURE_LENGTH >  FISSURE_LENGTH )
	// {
	// dbg fissure_stopped ( FISSURE_COUNT )
	// setvard FISSURE_ACTIVE 0
	// subtract G_FISSURES 1
	// }
	// //effect beam point lgtning.spr 10 BEAM_START BEAM_END (255,0,255) 255 0 3.0
	// //whisker
	// local L_BEAM_END BEAM_END
	// local L_BEAM_START BEAM_START
	// vectoradd L_BEAM_END $relpos($vec(0,FISSURE_YAW,0),$vec(-32,0,0))
	// vectoradd L_BEAM_START $relpos($vec(0,FISSURE_YAW,0),$vec(32,0,0))
	// xdodamage L_BEAM_START L_BEAM_END FISSURE_DMG 100% ent_me ent_me spellcasting.fire fire dmgevent:fissure;nodecal
	// //effect beam point lgtning.spr 10 L_BEAM_START L_BEAM_END (255,0,255) 255 0 3.0
	// local L_BEAM_END BEAM_END
	// local L_BEAM_START BEAM_START
	// vectoradd L_BEAM_END $relpos($vec(0,FISSURE_YAW,0),$vec(32,0,0))
	// vectoradd L_BEAM_START $relpos($vec(0,FISSURE_YAW,0),$vec(-32,0,0))
	// xdodamage L_BEAM_START L_BEAM_END FISSURE_DMG 100% ent_me ent_me spellcasting.fire fire dmgevent:fissure;nodecal
	// //effect beam point lgtning.spr 10 L_BEAM_START L_BEAM_END (255,0,255) 255 0 3.0
	// setvard FISSURE_START BEAM_END
	// vectorset FISSURE_START z $get_ground_height(FISSURE_START)
	// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
	// }
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) DmgType DmgAmt
	void PlayerExternals_OnFissureDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		if (!hit)
			return;
		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		if (RelationshipOf(ENT_ME, @target) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, FISSURE_DMG);

		float targHp = HealthOf(target);
		float maxHpPush = MaxHealthOf(ENT_ME) * 3.0f;
		if (maxHpPush < 2000.0f)
			maxHpPush = 2000.0f;
		if (!(targHp < maxHpPush))
			return;

		// local TARG_YAW $get(PARAM2,angles.yaw)
		int rndRl = RandomInt(1, 2);
		if (rndRl == 1)
			rndRl = 400;
		if (rndRl == 2)
			rndRl = -400;
		SetVelocity(target, RelativeVelocity(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndRl, 0, 110)));
	}

	// ext_summon_unique
	// <tag>
	void PlayerExternals_OnExtSummonUnique(string summonTag = "")
	{
		PLR_UNIQUE_SUMMONS = TokenAdd(PLR_UNIQUE_SUMMONS, summonTag);
	}

	// ext_unsummon_unique
	// <tag>
	void PlayerExternals_OnExtUnsummonUnique(string summonTag = "")
	{
		int tokenIdx = FindToken(PLR_UNIQUE_SUMMONS, summonTag);
		PLR_UNIQUE_SUMMONS = TokenRemove(PLR_UNIQUE_SUMMONS, tokenIdx);
	}

	// ext_epilepsy_time_begin
	void PlayerExternals_OnExtEpilepsyTimeBegin()
	{
		LegacyCommand("hud.addimgicon", ENT_ME, "bepilepsy2", "bepilepsy2", 15, 20, 75, 60, 0.25f);
		PLR_EPILEPSY_ACTIVE = true;
		PLR_EPILEPSY_COUNT = 0.0f;
		PLR_EPILEPSY_DELAY = 0.5f;
		PlayMusic(ENT_ME, "combat", "b-b-b-beetlejuice.mp3");
		CallEventDelayed(0.25f, "epilepsy_loop");
		LegacyCommand("hud.addimgicon", ENT_ME, "bepilepsy1", "bepilepsy1", 15, 20, 75, 60, 4.0f);
	}

	// epilepsy_loop
	void PlayerExternals_OnEpilepsyLoop()
	{
		if (!PLR_EPILEPSY_ACTIVE)
			return;

		CallEventDelayed(PLR_EPILEPSY_DELAY, "epilepsy_loop");

		float dur = PLR_EPILEPSY_DELAY * 0.5f;
		LegacyCommand("hud.addimgicon", ENT_ME, "bepilepsy2", "bepilepsy2", 15, 20, 75, 60, dur);

		PLR_EPILEPSY_COUNT += 0.5f;
		if (PLR_EPILEPSY_COUNT > 4.0f)
		{
			LegacyCommand("hud.addimgicon", ENT_ME, "bepilepsy1", "bepilepsy1", 15, 20, 75, 60, 1.0f);
			PLR_EPILEPSY_DELAY = 0.05f;
		}
		if (PLR_EPILEPSY_COUNT > 25.0f)
			PLR_EPILEPSY_ACTIVE = false;
	}

	// ext_epilepsy_time_end
	void PlayerExternals_OnExtEpilepsyTimeEnd()
	{
		PlayMusic(ENT_ME, "combat", "UndeadX1Fortress.mp3");
	}

	// ext_summon_register_pet
	// <id>
	void PlayerExternals_OnExtSummonRegisterPet(CBaseEntity@ pet = null)
	{
		if (PLR_ACTIVE_PETS == "PLR_ACTIVE_PETS")
			PLR_ACTIVE_PETS = "";
		if (PLR_ACTIVE_PET_TYPES == "PLR_ACTIVE_PET_TYPES")
			PLR_ACTIVE_PET_TYPES = "";
		PLR_ACTIVE_PETS = TokenAdd(PLR_ACTIVE_PETS, EntityId(pet));
		PLR_ACTIVE_PET_TYPES = TokenAdd(PLR_ACTIVE_PET_TYPES, ScriptVarOf(pet, "COMPANION_TYPE"));
		// dbg ext_summon_register_pet PLR_ACTIVE_PETS PLR_ACTIVE_PET_TYPES
		if (Text(PLR_N_ACTIVE_PETS) == "PLR_N_ACTIVE_PETS")
			PLR_N_ACTIVE_PETS = 1.0f;
		else
			PLR_N_ACTIVE_PETS += 1.0f;
	}

	// ext_summon_pets_new
	// <player> <script>
	void PlayerExternals_OnExtSummonPetsNew(CBasePlayer@ player = null, string petScript = "")
	{
		bool exitSub = false;
		PLR_SUMMON_MENU_DISABLE = GameTime() + 5.0f;

		if (PLR_ACTIVE_PETS == "PLR_ACTIVE_PETS")
			PLR_ACTIVE_PETS = "";
		if (PLR_ACTIVE_PET_TYPES == "PLR_ACTIVE_PET_TYPES")
			PLR_ACTIVE_PET_TYPES = "";
		string summonScript = "monsters/companion/" + petScript;
		string myYawText = Text(ViewAnglesOf(ENT_ME));
		float myYaw = Vec(myYawText).y;
		Vector3 summonPos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));
		summonPos.z = GroundHeight(summonPos);
		CreateNpc(summonScript, summonPos, self);

		// dbg ext_summon_pets_new SUMMON_POS $get(ent_lastcreated,id)
		SetLocal("reg.npcmove.endpos", summonPos);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", "z", 16);
		SetLocal("reg.npcmove.testonly", 0);
		LegacyCommand("npcmove", ENT_LASTCREATED, "none");

		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			PLR_SUMMON_MENU_DISABLE = GameTime(); // reset delay
			PlayerMessageDark(ENT_ME, "You cannot summon pet here");
			DeleteEntity(ENT_LASTCREATED);
			exitSub = true;
		}
		if (exitSub)
			return;

		PLR_ACTIVE_PETS = TokenAdd(PLR_ACTIVE_PETS, EntityId(EntityOf(ENT_LASTCREATED)));
		PLR_ACTIVE_PET_TYPES = TokenAdd(PLR_ACTIVE_PET_TYPES, ScriptVarOf(ENT_LASTCREATED, "COMPANION_TYPE"));
		if (Text(PLR_N_ACTIVE_PETS) == "PLR_N_ACTIVE_PETS")
			PLR_N_ACTIVE_PETS = 1.0f;
		else
			PLR_N_ACTIVE_PETS += 1.0f;
	}

	// ext_unsummon_pets_new
	// <player> <petid> <from_pet:0|1>
	void PlayerExternals_OnExtUnsummonPetsNew(CBasePlayer@ player = null, CBaseEntity@ pet = null, int petRequested = 0)
	{
		PLR_SUMMON_MENU_DISABLE = GameTime() + 5.0f;

		int petIdx = FindToken(PLR_ACTIVE_PETS, EntityId(pet));
		PLR_ACTIVE_PETS = TokenRemove(PLR_ACTIVE_PETS, petIdx);

		string petType = ScriptVarOf(pet, "COMPANION_TYPE");
		int petTypeIdx = FindToken(PLR_ACTIVE_PET_TYPES, petType);
		// dbg ext_unsummon_pets_new PET_TYPE PET_TYPE_IDX PLR_ACTIVE_PET_TYPES
		PLR_ACTIVE_PET_TYPES = TokenRemove(PLR_ACTIVE_PET_TYPES, petTypeIdx);

		PLR_N_ACTIVE_PETS -= 1.0f;
		if (petRequested != 0)
			return;
		CallExternal(pet, "companion_unsummon");
	}

	// ext_ice_staff_on
	void PlayerExternals_OnExtIceStaffOn()
	{
		ServerPlaySound(2, 10, "magic/freezeray_loop.wav");
	}

	// ext_ice_staff_off
	void PlayerExternals_OnExtIceStaffOff()
	{
		ServerPlaySound(2, 0, "magic/freezeray_loop.wav");
	}

	// ext_register_fists
	void PlayerExternals_OnExtRegisterFists(CBaseEntity@ fistsId = null)
	{
		DebugPrint("ext_register_fists");
		@PLR_FISTS_ID = fistsId;
	}

	// ext_lesser_leadfoot
	// { ext_kick
	// callexternal PLR_FISTS_ID kickatk_start
	// callclitemevent PLR_FISTS_ID kickatk_start
	// }
	void PlayerExternals_OnExtLesserLeadfoot(float stunAmount = 0.0f)
	{
		SetDamageTaken("stun", stunAmount);
		PLR_LESSER_LEADFOOT = true;
		PLR_LESSER_LEADFOOT_STUN = stunAmount;

		string str = Text(PLR_LESSER_LEADFOOT_STUN * 100.0f);
		str = Text(int(100.0f - Float(str))) + "%";
		if (!IsNoPush(ENT_ME))
			PlayerMessageGreen(ENT_OWNER, "Your stun resistance is now " + str);
	}

	// ext_delay_playsound
	// <delay> <chan> <vol> <wave>
	void PlayerExternals_OnExtDelayPlaysound(float delay = 0.0f, int channel = 0, int volume = 0, string soundFile = "")
	{
		PLR_DEL_PLAYSOUND_CHAN = channel;
		PLR_DEL_PLAYSOUND_VOL = volume;
		PLR_DEL_PLAYSOUND_WAV = soundFile;
		CallEventDelayed(delay, "ext_delay_playsound2");
	}

	// ext_delay_playsound2
	void PlayerExternals_OnExtDelayPlaysound2()
	{
		PlaySound(PLR_DEL_PLAYSOUND_CHAN, PLR_DEL_PLAYSOUND_VOL, PLR_DEL_PLAYSOUND_WAV);
	}

	// ext_tosscre
	// <hand> <type>
	void PlayerExternals_OnExtTosscre(float hand = 0.0f, string type = "")
	{
		Vector3 ofs;
		PLR_CRE_HAND = hand;
		PLR_CRE_TYPE = type;
		if (PLR_CRE_HAND == 1.0f)
			ofs = RelativePosition(Vector3(20, 20, 18));
		else
			ofs = RelativePosition(Vector3(-20, 20, 18));

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_crescent", ofs, "none", 200, 0, 0, "none");
		@PLR_LAST_PROJECTILE = EntityOf(ENT_LASTPROJECTILE);
	}

	// ext_set_glow
	void PlayerExternals_OnExtSetGlow(string glowEnabled = "")
	{
		PLR_HAS_GLOW = glowEnabled;
		IR_GLOWING = glowEnabled; // for older scripts
		if (Truthy(PLR_HAS_GLOW))
			return;
		CallEventDelayed(0.1f, "restore_item_lights"); // player lost his glow, relight any glow items
	}

	// restore_item_lights
	void PlayerExternals_OnRestoreItemLights()
	{
		CallExternal("all", "ext_restore_item_lights");
	}

	// ext_teleportfx1
	void PlayerExternals_OnExtTeleportfx1()
	{
		CallEventDelayed(0.1f, "ext_teleportfx1_delay");
	}

	// ext_teleportfx1_delay
	void PlayerExternals_OnExtTeleportfx1Delay()
	{
		Vector3 myFeet = OriginOf(ENT_ME);
		myFeet.z = GroundHeight(myFeet);
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "cl_tele1_fx", myFeet);
	}

	// ext_teleportfx2
	void PlayerExternals_OnExtTeleportfx2()
	{
		PlaySound(0, 10, "debris/beamstart8.wav");
	}

	// extsoc_show_scores
	// <red> <blue>
	void PlayerExternals_OnExtsocShowScores(float redScore = 0.0f, float blueScore = 0.0f)
	{
		int gameWon = 0;

		DebugPrint("extsoc_show_scores");

		float sprDur = 3.0f;
		if (redScore == 5.0f)
			gameWon = 1;
		if (blueScore == 5.0f)
			gameWon = 2;
		if (gameWon > 0)
			sprDur = 10.0f;

		int scoreSprite = int(redScore);
		string scoreSpriteText = Text(scoreSprite) + "_red";
		LegacyCommand("hud.addimgicon", ENT_ME, scoreSpriteText, "sc1", 20, 10, 20, 30, sprDur);

		scoreSprite = int(blueScore);
		scoreSpriteText = Text(scoreSprite) + "_blue";
		LegacyCommand("hud.addimgicon", ENT_ME, scoreSpriteText, "sc2", 60, 10, 20, 30, sprDur);

		LegacyCommand("hud.addimgicon", ENT_ME, "red", "sc3", 20, 0, 20, 10, sprDur);
		LegacyCommand("hud.addimgicon", ENT_ME, "vs", "sc4", 40, 0, 20, 10, sprDur);
		LegacyCommand("hud.addimgicon", ENT_ME, "blue", "sc5", 60, 0, 20, 10, sprDur);

		if (gameWon > 0)
		{
			if (gameWon == 1)
			{
				LegacyCommand("hud.addimgicon", ENT_ME, "red_wins", "sc6", 25, 40, 50, 25, 1.0f);
				PLR_SOCCER_TEAMSPR = "red_wins";
				CallEventDelayed(2.0f, "extsoc_flash_win");
				CallEventDelayed(4.0f, "extsoc_flash_win");
				CallEventDelayed(6.0f, "extsoc_flash_win");
				CallEventDelayed(8.0f, "extsoc_flash_win");
			}
			else
			{
				LegacyCommand("hud.addimgicon", ENT_ME, "blue_wins", "sc6", 25, 40, 50, 25, 1.0f);
				PLR_SOCCER_TEAMSPR = "blue_wins";
				CallEventDelayed(2.0f, "extsoc_flash_win");
				CallEventDelayed(4.0f, "extsoc_flash_win");
				CallEventDelayed(6.0f, "extsoc_flash_win");
				CallEventDelayed(8.0f, "extsoc_flash_win");
			}
		}
	}

	// extsoc_flash_win
	void PlayerExternals_OnExtsocFlashWin()
	{
		LegacyCommand("hud.addimgicon", ENT_ME, PLR_SOCCER_TEAMSPR, "sc6", 25, 40, 50, 25, 1.5f);
	}

	// ext_hud_icon
	// <icon> <refname> <x%> <y%> <h%> <w%> <duration>
	void PlayerExternals_OnExtHudIcon(int icon = 0, string refName = "", int xPercent = 0, int yPercent = 0, int heightPercent = 0, int widthPercent = 0, float duration = 0.0f)
	{
		LegacyCommand("hud.addimgicon", ENT_ME, icon, refName, xPercent, yPercent, heightPercent, widthPercent, duration);
	}

	// ext_shender_telfdoor
	void PlayerExternals_OnExtShenderTelfdoor()
	{
		DebugPrint("ext_shender_telfdoor " + Text(PLR_DID_SHENDER_EVENT));
		OnExtDarkenbloom();
		if (PLR_DID_SHENDER_EVENT)
			return;
		CBaseEntity@ winElf = FindByName("telf_win");
		if (IsAlive(winElf) && Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GM_BUNNY_KILLED")))
		{
			PLR_DID_SHENDER_EVENT = true;
			CallExternal(winElf, "ext_bunny_comment");
		}
	}

	// ext_conflict
	void PlayerExternals_OnExtConflict()
	{
		LegacyCommand("conflictcheck");
	}

	// ext_dumpvars
	void PlayerExternals_OnExtDumpvars()
	{
		LegacyCommand("conflictcheck", "dumpvars");
	}

	// ext_showflags
	void PlayerExternals_OnExtShowflags()
	{
		string test = LegacyFunction("get_scriptflag", ENT_ME, "listall");
	}

	// ext_svplaysound_kiss
	void PlayerExternals_OnExtSvplaysoundKiss(int channel = 0, int volume = 0, string sound = "", float attenuation = 0.0f, int pitch = 0)
	{
		DebugPrint("ext_svplaysound_kiss " + channel + " " + volume + " " + sound + " " + Text(attenuation) + " " + pitch);
		ServerPlaySound(channel, volume, sound, attenuation, pitch);
	}

	// ext_clear_valid_gauntlets
	// reset gauntlet validator when final boss killed
	void PlayerExternals_OnExtClearValidGauntlets()
	{
		Quest("set", ENT_ME, "mv", 0);
		Quest("set", ENT_ME, "m", 0);
	}

	// ext_haste_cooldown
	// <cooldown>
	void PlayerExternals_OnExtHasteCooldown(float cooldown = 0.0f)
	{
		PLR_NEXT_HASTE = GameTime() + cooldown;
	}

	// ext_register_corrode
	void PlayerExternals_OnExtRegisterCorrode(string duration = "")
	{
		PLR_CORRODE_DURATION = duration;
	}

	// ext_clevent_me
	void PlayerExternals_OnExtCleventMe(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), eventName, value, value2, value3, value4, value5, value6, value7);
	}

	// ext_clevent_all
	void PlayerExternals_OnExtCleventAll(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), eventName, value, value2, value3, value4, value5, value6, value7);
	}

	// ext_mana_regen_loop
	void PlayerExternals_OnExtManaRegenLoop()
	{
		if (!Truthy(ScriptFlag(ENT_ME, "mana_regen", "type_exists")))
			return;
		CallEventDelayed(1.0f, "ext_mana_regen_loop");
		float curMp = ManaOf(ENT_ME);
		float maxMp = MaxManaOf(ENT_ME);
		if (curMp < maxMp)
		{
			maxMp -= curMp;
			GiveMana(maxMp);
		}
	}

	// ext_arrow_hit
	// <idx|world> <dmgstring> <origin> - from items/proj_arrow_cl
	void PlayerExternals_OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		// dbg ext_arrow_hit PARAM1 PARAM2 PARAM3
		if (hit != "world")
		{
			CBaseEntity@ targId = EntityOf(hit);
			// dmgstring: <basedmg>;<dmgtype>;<weapon_idx>;<proj_itemname>
			string baseDmg = GetToken(EntityId(hitEntity), 0);
			string baseDmgType = GetToken(EntityId(hitEntity), 1);
			string weaponIdx = GetToken(EntityId(hitEntity), 2);
			string projName = GetToken(EntityId(hitEntity), 3);

			CBaseEntity@ weaponId = EntityOf(weaponIdx);

			// dbg ext_arrow_hit weapon $get(L_WEAPON_ID,name) idx L_WEAPON_IDX
			// figure final damage by skill ratio
			string finalDmgText = baseDmg;
			float finalDmg = Float(finalDmgText);
			string stat = "skill.";
			string baseStat = ScriptVarOf(weaponId, "WEAPON_PRIMARY_SKILL");
			stat += baseStat + ".power.ratio";
			finalDmg *= Float(GetProp(ENT_ME, stat));
			finalDmgText = Text(finalDmg);
			int dmgMulti = Int(ScriptVarOf(weaponId, "WEAPON_DMG_MULTI"));
			if (dmgMulti > 0)
			{
				finalDmg *= dmgMulti;
				finalDmgText = Text(finalDmg);
			}

			// dbg ext_arrow_hit L_FINAL_DMG [ L_STAT = $get(ent_me,L_STAT) ]
			bool specialDmg = false;

			// if ( L_PROJ_NAME equals blah ) <special handling>
			// set local L_SPECIAL_DMG 1 if needed to abort local damage
			if (projName == "proj_arrow_gholy")
			{
				float holyDmg = SkillOf(ENT_ME, "spellcasting.divination") + 5.0f;
				CallExternal(targId, "turn_undead", holyDmg, self);
			}
			else if (projName == "proj_arrow_fbow")
			{
				int freezeManaCost = 10;
				float cdotDmg = SkillOf(ENT_ME, "spellcasting.ice");
				string fdotDmgText;
				float fdotDmg = 0.0f;
				cdotDmg = Divide(cdotDmg, 1.8f);
				fdotDmg = Divide(fdotDmg, 2.0f);
				fdotDmgText = Text(fdotDmg);

				int projType = 0;
				if (ManaOf(ENT_ME) >= freezeManaCost)
					projType = RandomInt(0, 1);
				if (projType == 0)
				{
					ApplyEffect(targId, "effects/dot_cold", Random(5, 10), self, cdotDmg, "spellcasting.ice");
				}
				else
				{
					GiveMana(ENT_ME, -0.0f);
					ApplyEffect(targId, "effects/dot_cold_freeze", 8.0f, self, fdotDmgText, "spellcasting.ice");
				}
			}
			else if (projName == "proj_arrow_frost")
				ApplyEffect(targId, "effects/dot_cold", RandomInt(5, 10), self, 5, "archery");
			else if (projName == "proj_arrow_gpoison")
				ApplyEffect(targId, "effects/dot_poison", RandomInt(5, 10), self, Random(12, 33), "archery");
			else if (projName == "proj_arrow_lightning")
				ApplyEffect(targId, "effects/dot_lightning", RandomInt(5, 10), self, Random(10, 25), "archery");
			else if (projName == "proj_arrow_poison")
				ApplyEffect(targId, "effects/dot_poison", 15, self, Random(2, 3), 0, "archery");

			if (!specialDmg)
				DoDamageEx(@targId, "direct", finalDmgText, "100%", ENT_ME, @weaponId, baseStat, baseDmgType);
		}
		else
		{
			// no good, arrow no longer exists
			// local L_ARROW_IDX $get_by_idx(PARAM4,id)
			// callexternal L_ARROW_IDX strike_target L_TARG_ID
			// hitworld effects here (same insane if else as above, but atm, no arrows do this, unlike some bolts, which don't use this system.)
			DebugPrint("ext_arrow_hit hit world @ " + Text(startPosition));
		}
	}

	// ext_reset_bank
	void PlayerExternals_OnExtResetBank()
	{
		PLR_RESET_BANK += 1.0f;
		if (PLR_RESET_BANK == 1.0f)
		{
			ConsoleMessage(ENT_ME, "WARNING: This will delete ALL items in your Galat chest and cannot be undone!");
			ConsoleMessage(ENT_ME, "Type resetbank again to confirm!");
		}
		else
		{
			PLR_RESET_BANK = 0.0f;
			Quest("set", ENT_ME, "b0", 0);
			Quest("set", ENT_ME, "b1", 0);
			Quest("set", ENT_ME, "b2", 0);
			Quest("set", ENT_ME, "b3", 0);
			Quest("set", ENT_ME, "b4", 0);
			Quest("set", ENT_ME, "b5", 0);
			Quest("set", ENT_ME, "b6", 0);
			Quest("set", ENT_ME, "b7", 0);
			Quest("set", ENT_ME, "b8", 0);
			Quest("set", ENT_ME, "b9", 0);
			ConsoleMessage(ENT_ME, "Your Galat Chest bank strings have been reset.");
		}
	}

	// ext_targeted_by_mob
	// <targeter>
	void PlayerExternals_OnExtTargetedByMob(CBaseEntity@ attacker = null)
	{
		if (!IsAlive(attacker))
			return;

		string combatTag = "combat" + IndexOf(attacker);
		ScriptFlags(ENT_ME, "add", combatTag, "combat");

		if (Truthy(GetVar("G_DEVELOPER_MODE")) && !PLR_IN_COMBAT && Truthy(ScriptFlag(ENT_ME, "combat", "type_exists")))
		{
			AddStatusIcon(ENT_ME, PLR_COMBAT_ICON, "combat", 9999);
			PlayerMessageBlue(ENT_ME, "!!!!!! entered combat !!!!!!");
		}

		PLR_IN_COMBAT = true;
	}

	// ext_untargeted_by_mob
	// <targeter>
	void PlayerExternals_OnExtUntargetedByMob(CBaseEntity@ attacker = null)
	{
		string combatTag = "combat" + IndexOf(attacker);
		ScriptFlags(ENT_ME, "remove", combatTag);
		if (!Truthy(ScriptFlag(ENT_ME, "combat", "type_exists")))
		{
			if (Truthy(GetVar("G_DEVELOPER_MODE")) && PLR_IN_COMBAT)
			{
				PlayerMessageBlue(ENT_ME, "====== exited combat ======");
				LegacyCommand("hud.killstatusicon", ENT_ME, "combat");
			}
			PLR_IN_COMBAT = false;
		}
	}

	// game_touched_local_trans
	// <title> <trans_id> <req_all_players> <mins> <maxs> <respawn_name|none>
	void PlayerExternals_OnGameTouchedLocalTrans(string transTitle = "", string transId = "", string reqAllPlayers = "", string mins = "", string maxs = "", string respawnName = "")
	{
		string title = "L_TITLE";
		if (PLR_LOCAL_TRANS == transId)
			return;
		DebugPrint("game_touched_local_trans " + transTitle + " " + transId + " " + reqAllPlayers + " " + mins + " " + maxs);
		if (!StartsWith(transTitle, "_"))
			title = "Local transition to " + transTitle;
		else
			title = LegacyFunction("string_from", title, "_");

		string desc = "Push (Enter) to activate."; // $get(ent_me,keybind,+use) would be nice here
		if (Truthy(reqAllPlayers))
		{
			// if game.players.noafk > 1
			desc += " Requires all active players be present.";
		}

		InfoMessage(ENT_ME, title, desc);

		PLR_LOCAL_TRANS = transId;
		PLR_LTRAN_ORG = OriginOf(ENT_ME);
		PLR_LTRAN_MINS = mins;
		PLR_LTRAN_MAXS = maxs;

		if (respawnName != "none")
			OnExtSetspawn(respawnName);

		OnLoopCheckLocalTrans();
	}

	// loop_check_local_trans
	void PlayerExternals_OnLoopCheckLocalTrans()
	{
		if (PLR_LOCAL_TRANS == "none")
			return;
		if (!Truthy(LegacyFunction("within_box", ENT_ME, Vector3(0, 0, 0), PLR_LTRAN_MINS, PLR_LTRAN_MAXS))) // $dist(MY_ORG,PLR_LTRAN_ORG) > 256
		{
			PLR_LOCAL_TRANS = "none";
			DebugPrint("loop_check_local_trans EXITED LTRANS");
		}
		else
		{
			CallEventDelayed(1.0f, "loop_check_local_trans");
		}
	}

	// ext_setspawn
	// <spawn_name>
	void PlayerExternals_OnExtSetspawn_2(string spawnName = "")
	{
		DebugPrint("ext_setspawn " + spawnName);
		LegacyCommand("settrans", ENT_ME, spawnName);
		Quest("set", ENT_ME, "d", spawnName);
	}

	// ext_remove_afk
	void PlayerExternals_OnExtRemoveAfk()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")) && IS_AFK)
			PlayerMessageBlue(ENT_ME, "====== No longer afk");
		IS_AFK = false;
		PLR_LAST_ATK_TIME = GameTime();
	}

	// ext_poison_bolt
	// <origin>
	void PlayerExternals_OnExtPoisonBolt(string origin = "")
	{
		DebugPrint("ext_poison_bolt " + origin);
		float pboltDuration = 15.0f;
		PLR_PBOLT_AOE = 64; // sloppy to set here, but for ease of reference

		// move up a bit, if we hit ground
		// if ( $vec.z(L_PBOLT_LOC) == $get_ground_height(L_PBOLT_LOC) )
		// {
		// local L_HALF_UP L_PBOLT_AOE
		// multiply L_HALF_UP 0.5
		// vectoradd L_PBOLT_LOC z L_HALF_UP
		// }
		ScriptFlags(ENT_ME, "add", "stack_pbolt", "pbolt", origin, pboltDuration);
		ClientEvent("new", "all", "effects/sfx_poison_cloud", origin, PLR_PBOLT_AOE, pboltDuration);
		if (PLR_PBOLT_ACTIVE)
			return;
		GAME_PVP = (IsPvp() ? 1 : 0);
		PLR_PBOLT_ACTIVE = true;
		PLR_PBOLT_COUNTER = 0.0f;
		PLR_PBOLT_DOT = SkillOf(ENT_ME, "spellcasting.affliction");
		OnExtPoisonBoltLoop();
	}

	// ext_poison_bolt_loop
	void PlayerExternals_OnExtPoisonBoltLoop()
	{
		// nice thing about this setup is we shouldn't have to do anything in game_scriptflags
		if (!PLR_PBOLT_ACTIVE)
			return;

		PLR_PBOLT_ARRAY = ScriptFlag(ENT_ME, "pbolt", "type_array");

		if (PLR_PBOLT_ARRAY != "none")
		{
			float nbolts = GetArrayCount(PLR_PBOLT_ARRAY) - 1.0f;
			if (PLR_PBOLT_COUNTER > nbolts) // bolt expired during last loop, or there's only 1 active bolt
				PLR_PBOLT_COUNTER = 0.0f;
			PLR_PBOLT_ORG = GetArray(PLR_PBOLT_ARRAY, Text(PLR_PBOLT_COUNTER));
			OnExtPoisonBoltDmg();

			float boltScanSpeed = 1.0f;

			if (nbolts > 0.0f)
				boltScanSpeed = Divide(boltScanSpeed, nbolts);
			if (boltScanSpeed < 0.1f) // max scans = 1/0.2secs
				boltScanSpeed = 0.2f;

			PLR_PBOLT_COUNTER += 1.0f;

			CallEventDelayed(boltScanSpeed, "ext_poison_bolt_loop");
		}
		else
		{
			PLR_PBOLT_ACTIVE = false;
		}
	}

	// ext_poison_bolt_dmg
	void PlayerExternals_OnExtPoisonBoltDmg()
	{
		Vector3 scanPoint = Vec(PLR_PBOLT_ORG);
		scanPoint.z += 32.0f; // in case the ground is uneven

		// nice thought, but too mean when stacked
		// xdodamage L_SCAN_POINT PLR_PBOLT_AOE PLR_PBOLT_DOT 0.1 ent_me ent_me spellcasting.affliction poison_effect dmgevent:pbolt_cloud
		PLR_PBOLT_TARGS = LegacyFunction("get_tsphere", "enemy", PLR_PBOLT_AOE, scanPoint);
		// dbg ext_poison_bolt_dmg PLR_PBOLT_TARGS @ PLR_PBOLT_ORG
		if (PLR_PBOLT_TARGS == "none")
			return;
		int count = GetTokenCount(PLR_PBOLT_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnExtPoisonBoltAffect();
		}
	}

	// ext_poison_bolt_affect
	void PlayerExternals_OnExtPoisonBoltAffect()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(PLR_PBOLT_TARGS, loopIteration));
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(curTarg, "effects/dot_poison", 10.0f, self, PLR_PBOLT_DOT, "spellcasting.affliction");
	}

	// ext_speak
	// while this is possible, turned out to be no good in the desired context, as calling script events in a loop, causes only the first script event to be recieved
	// { game_make_array //<array_name> <value> [clear:0|1] [modify_idx+1] - called by code to make or add to array (remember to dupe on monsters/externals)
	// dbg game_make_array PARAM1 PARAM2 PARAM3 PARAM4 # PARAM5
	// if ( PARAM3 )
	// {
	// if $get_array(L_ARRAY_NAME,exists)
	// //dbg game_make_array clear array
	// array.clear L_ARRAY_NAME
	// }
	// if ( !$get_array(L_ARRAY_NAME,exists) )
	// {
	// //dbg game_make_array create array
	// array.create L_ARRAY_NAME
	// }
	// if ( !PARAM4 )
	// {
	// //dbg game_make_array add array entry PARAM2
	// array.add L_ARRAY_NAME PARAM2
	// }
	// else
	// {
	// //dbg game_make_array edit array entryidx PARAM4 to PARAM2
	// local L_IDX PARAM4
	// subtract L_IDX 1
	// array.set L_ARRAY_NAME PARAM4 PARAM2
	// }
	// }
	// <"text">
	void PlayerExternals_OnExtSpeak(string text = "")
	{
		// saytextrange 2048
		SayText(text);
	}

	// ext_saytextrange
	// <value>
	void PlayerExternals_OnExtSaytextrange(int range = 0)
	{
		SetSayTextRange(range);
	}

	// ext_req_viewmodel_idx
	// spariment
	void PlayerExternals_OnExtReqViewmodelIdx()
	{
		DebugPrint("requesting viewmodel idx...");
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "ext_svreq_viewmodel_idx");
	}

	// ext_rec_viewmodel_idx
	void PlayerExternals_OnExtRecViewmodelIdx(string viewmodelIndex = "")
	{
		PLR_ACTIVE_VIEWMODEL = viewmodelIndex;
		CBaseEntity@ viewmodelId = EntityOf(PLR_ACTIVE_VIEWMODEL);
		DebugPrint("Got viewmodelidx " + PLR_ACTIVE_VIEWMODEL + " [ " + EntityId(viewmodelId) + " ]");
		Effect("beam", "follow", "lgtning.spr", @viewmodelId, 1, 30, 30.0f, 200, Vector3(255, 0, 0));
		SetProp(viewmodelId, "rendermode", 5);
		SetProp(viewmodelId, "renderamt", 255);
	}

	// ext_remove_effect
	void PlayerExternals_OnExtRemoveEffect(string effectName = "")
	{
		DebugPrint("ext_remove_effect " + effectName);
		LegacyCommand("removeeffect", ENT_ME, effectName);
	}

	// ext_clientcmd
	void PlayerExternals_OnExtClientcmd(string command = "")
	{
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "ext_cl_clientcmd", command);
	}

	// ext_set_fquest
	void PlayerExternals_OnExtSetFquest()
	{
		string felQuest = GetQuestData(ENT_ME, "f");
		if (felQuest == "complete")
		{
			HelpTip(ENT_ME, "generic", "Repeatable Quest Acquired", "The quest is completed upon acquisition of one of the Shards of the Felewyn Blade.");
			Quest("set", ENT_ME, "f", 1);
		}
		else if (GetToken(felQuest, 0) != "1")
		{
			HelpTip(ENT_ME, "generic", "Quest Acquired For First Time", "The quest is completed upon acquisition of one of the Shards of the Felewyn Blade.");
			Quest("set", ENT_ME, "f", 1);
		}
	}

	// ext_debug_que
	// <msg>
	void PlayerExternals_OnExtDebugQue(string message = "")
	{
		if (!Truthy(GetArray("ARRAY_DEBUG", "exists")))
			ArrayCreate("ARRAY_DEBUG");

		ArrayAdd("ARRAY_DEBUG", message);

		if (PLR_DEBUG_ARRAY_ACTIVE)
			return;
		PLR_DEBUG_ARRAY_ACTIVE = true;
		OnExtDebugQueLoop();
	}

	// ext_debug_que_loop
	void PlayerExternals_OnExtDebugQueLoop()
	{
		if (!PLR_DEBUG_ARRAY_ACTIVE)
			return;
		string out_ = GetArray("ARRAY_DEBUG", "0");
		if (int(out_.length()) > 100)
		{
			string lout = Left(out_, 100) + "*";
		}
		ConsoleMessage(ENT_ME, out_);
		ArrayRemoveAt("ARRAY_DEBUG", 0);
		if (GetArrayCount("ARRAY_DEBUG") > 0)
			CallEventDelayed(0.1f, "ext_debug_que_loop");
		else
			PLR_DEBUG_ARRAY_ACTIVE = false;
	}

	// ext_quake_fx
	// <duration> //<startsnd> <loopsnd>
	void PlayerExternals_OnExtQuakeFx(float duration = 0.0f)
	{
		PlaySound(1, 10, "magic/volcano_start.wav", 0.8f, 60);
		ServerPlaySound(2, 10, "magic/volcano_loop.wav", 0.8f, 60);
		ClientEvent("new", ENT_ME, "effects/sfx_quake", IndexOf(ENT_ME), 1, 256, duration);
		Effect("screenshake", OriginOf(ENT_ME), 50, 10, duration, 512);
		CallEventDelayed(duration, "ext_quake_fx_end");
	}

	// ext_quake_fx_end
	void PlayerExternals_OnExtQuakeFxEnd()
	{
		ServerPlaySound(2, 0, "magic/volcano_loop.wav");
	}

	// ext_iexist_test
	void PlayerExternals_OnExtIexistTest(string itemName = "", string amount = "")
	{
		ConsoleMessage(ENT_ME, "item_exist_test " + LegacyFunction("item_exists", ENT_ME, itemName, amount));
	}

	// ext_shield_up
	// 0|1
	void PlayerExternals_OnExtShieldUp(int raised = 0)
	{
		if (raised != 0)
		{
			PLR_SHIELD_UP = true;
			ScriptFlags(ENT_ME, "add", "shieldnp", "nopush", 1, -1, "none");
		}
		else
		{
			PLR_SHIELD_UP = false;
			ScriptFlags(ENT_ME, "remove", "shieldnp");
		}
	}

	// ext_dburst
	// <origin> <rad> <repell:0|1> <sound:0|1>
	void PlayerExternals_OnExtDburst(string origin = "", int radius = 0, int repelFlag = 0, int playSound = 0)
	{
		PLR_DBURST_ORG = origin;
		PLR_DBURST_AOE = radius;
		PLR_DBURST_PUSH = repelFlag != 0;
		GAME_PVP = (IsPvp() ? 1 : 0);

		PLR_DBURST_SKILL = SkillOf(ENT_ME, "spellcasting.affliction");
		PLR_DBURST_DMG = PLR_DBURST_SKILL * 3.0f;
		PLR_DBURST_DOT = PLR_DBURST_SKILL * 0.5f;

		PLR_DBURST_MAXPUSH = MaxHealthOf(ENT_ME) * 4.0f;

		ClientEvent("new", "all", "effects/sfx_dburst", PLR_DBURST_ORG, PLR_DBURST_AOE, playSound);

		// setvard PLR_BSFAURA_CL_IDX game.script.last_sent_id
		// svplaysound 1 10 magic/temple.wav - handel in cl effect
		DoDamageEx(PLR_DBURST_ORG, PLR_DBURST_AOE, PLR_DBURST_DMG, 0.1f, ENT_ME, ENT_ME, "spellcasting.affliction", "dark_effect", "dmgevent:dburst");
	}

	// dburst_dodamage
	void PlayerExternals_OnDburstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool doPush = false;
		if (!hit)
			return;
		if (IsPlayer(target) && GAME_PVP == 0)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_dark", 15.0f, self, PLR_DBURST_DOT, "spellcasting.affliction");

		if (!PLR_DBURST_PUSH)
			return;

		float targHp = HealthOf(target);
		if (targHp < PLR_DBURST_MAXPUSH)
			doPush = true;
		if (!doPush)
			return;
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(Vec(PLR_DBURST_ORG), targOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 1000, 0)));
	}

	// ext_environment_change
	void PlayerExternals_OnExtEnvironmentChange(string environment = "")
	{
		OnExtTodLock(environment);
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "environment_change", environment);
	}

	// ext_change_sky
	void PlayerExternals_OnExtChangeSky(string skyName = "")
	{
		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "change_sky", skyName);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnFakeSoundPrecache() { PlayerExternals_OnFakeSoundPrecache(); } // fake_sound_precache
	void OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f) { PlayerExternals_OnGameScriptflagUpdate(action, flagName, flagType, value, baseExpireTime); } // game_scriptflag_update
	void OnExtSetStatusFlag(string nameId = "", string type = "", int value = 0, int expires = 0, string message = "") { PlayerExternals_OnExtSetStatusFlag(nameId, type, value, expires, message); } // ext_set_status_flag
	void OnCheckFlags() { PlayerExternals_OnCheckFlags(); } // check_flags
	void OnCheckFlagsExpired() { PlayerExternals_OnCheckFlagsExpired(); } // check_flags_expired
	void OnExtRemoveStatusFlag(string nameId = "") { PlayerExternals_OnExtRemoveStatusFlag(nameId); } // ext_remove_status_flag
	void OnExtRemoveStatusFlagsType(string flagType = "") { PlayerExternals_OnExtRemoveStatusFlagsType(flagType); } // ext_remove_status_flags_type
	void OnGameHitbodypart(string bodyPart = "") { PlayerExternals_OnGameHitbodypart(bodyPart); } // game_hitbodypart
	void OnGameFall() { PlayerExternals_OnGameFall(); } // game_fall
	void OnSetGlowId(string glowId = "") { PlayerExternals_OnSetGlowId(glowId); } // set_glow_id
	void OnSetStunProt(float stunProtection = 0.0f) { PlayerExternals_OnSetStunProt(stunProtection); } // set_stun_prot
	void OnSetSpawnPoint(string spawnPosition = "") { PlayerExternals_OnSetSpawnPoint(spawnPosition); } // set_spawn_point
	void OnRegisterBody(string body = "", string clientBody = "") { PlayerExternals_OnRegisterBody(body, clientBody); } // register_body
	void OnHideBodyParts(string bodyParts = "") { PlayerExternals_OnHideBodyParts(bodyParts); } // hide_body_parts
	void OnWearingArmor(int equipped = 0, string type = "", string offset = "") { PlayerExternals_OnWearingArmor(equipped, type, offset); } // wearing_armor
	void OnPotionRegen(float duration = 0.0f) { PlayerExternals_OnPotionRegen(duration); } // potion_regen
	void OnRegenStart() { PlayerExternals_OnRegenStart(); } // regen_start
	void OnRegenEnd() { PlayerExternals_OnRegenEnd(); } // regen_end
	void OnPotionVampire(float duration = 0.0f) { PlayerExternals_OnPotionVampire(duration); } // potion_vampire
	void OnVampireSuncheck() { PlayerExternals_OnVampireSuncheck(); } // vampire_suncheck
	void OnVampireOff() { PlayerExternals_OnVampireOff(); } // vampire_off
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return PlayerExternals_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	void OnExtPlaysoundKiss(int channel = 0, int volume = 0, string soundFile = "") { PlayerExternals_OnExtPlaysoundKiss(channel, volume, soundFile); } // ext_playsound_kiss
	void OnExtPlaysound(int soundFile = 0, Vector3 sourceOrigin = Vector3(), string maxRange = "", string volume = "", string pitch = "") { PlayerExternals_OnExtPlaysound(soundFile, sourceOrigin, maxRange, volume, pitch); } // ext_playsound
	void OnExtPlaysound2() { PlayerExternals_OnExtPlaysound2(); } // ext_playsound2
	void OnExtRenameMe(string newName = "") { PlayerExternals_OnExtRenameMe(newName); } // ext_rename_me
	void OnExtPlayMusic(string file = "") { PlayerExternals_OnExtPlayMusic(file); } // ext_play_music
	void OnExtPlayMusicMe(string file = "") { PlayerExternals_OnExtPlayMusicMe(file); } // ext_play_music_me
	void OnExtSetangle(Vector3 angles = Vector3(), string value = "") { PlayerExternals_OnExtSetangle(angles, value); } // ext_setangle
	void OnExtQuest(string questName = "", string questData = "") { PlayerExternals_OnExtQuest(questName, questData); } // ext_quest
	void OnExtAddgold(string goldAmount = "") { PlayerExternals_OnExtAddgold(goldAmount); } // ext_addgold
	void OnExtSetgold(int goldAmount = 0) { PlayerExternals_OnExtSetgold(goldAmount); } // ext_setgold
	void OnSendDamage(string target = "", string mode = "", string damage = "", string percent = "", string attacker = "", string effect = "", string flags = "") { PlayerExternals_OnSendDamage(target, mode, damage, percent, attacker, effect, flags); } // send_damage
	void OnGiveHp(string amount = "") { PlayerExternals_OnGiveHp(amount); } // give_hp
	void OnGiveMp(string amount = "") { PlayerExternals_OnGiveMp(amount); } // give_mp
	void OnExtInvalidate(string invalidFlag = "") { PlayerExternals_OnExtInvalidate(invalidFlag); } // ext_invalidate
	void OnExtDodamage(CBaseEntity@ target = null, string hitMode = "", float damage = 0.0f, string hitChance = "", string attacker = "", string damageSkill = "", string value = "") { PlayerExternals_OnExtDodamage(target, hitMode, damage, hitChance, attacker, damageSkill, value); } // ext_dodamage
	void OnFreezeSolidStart(string freezeDuration = "", string attacker = "") { PlayerExternals_OnFreezeSolidStart(freezeDuration, attacker); } // freeze_solid_start
	void OnFreezeSolidEnd(int unfrozeEarly = 0) { PlayerExternals_OnFreezeSolidEnd(unfrozeEarly); } // freeze_solid_end
	void OnExtRemovedEffects() { PlayerExternals_OnExtRemovedEffects(); } // ext_removed_effects
	void OnExtSpiderProtect(float duration = 0.0f, float protectAmount = 0.0f, string effectTag = "") { PlayerExternals_OnExtSpiderProtect(duration, protectAmount, effectTag); } // ext_spider_protect
	void OnSpiderProtectEnd() { PlayerExternals_OnSpiderProtectEnd(); } // spider_protect_end
	void OnFloatToPercent(float fraction = 0.0f) { PlayerExternals_OnFloatToPercent(fraction); } // float_to_percent
	void OnExtSetAlcoType(string alcoType = "", CBaseEntity@ spawnItem = null) { PlayerExternals_OnExtSetAlcoType(alcoType, spawnItem); } // ext_set_alco_type
	void OnExtFlashBang(Vector3 origin = Vector3(), int radius = 0, CBaseEntity@ sourceOwner = null) { PlayerExternals_OnExtFlashBang(origin, radius, sourceOwner); } // ext_flash_bang
	void OnExtSetSwiftBlade(float speedRatio = 0.0f) { PlayerExternals_OnExtSetSwiftBlade(speedRatio); } // ext_set_swift_blade
	void OnGameEquipped(CBaseEntity@ item = null) { PlayerExternals_OnGameEquipped(item); } // game_equipped
	void OnExtSetHandId(string handIndex = "", CBaseEntity@ item = null) { PlayerExternals_OnExtSetHandId(handIndex, item); } // ext_set_hand_id
	void OnUpdateParry() { PlayerExternals_OnUpdateParry(); } // update_parry
	void OnSetTwoHand() { PlayerExternals_OnSetTwoHand(); } // set_two_hand
	string OnFuncGetDualwieldReduct(string weaponScript = "") { return PlayerExternals_OnFuncGetDualwieldReduct(weaponScript); } // func_get_dualwield_reduct
	void OnSetSwiftBlade() { PlayerExternals_OnSetSwiftBlade(); } // set_swift_blade
	void OnExtSphereTokenX(string scanType = "", float scanRange = 0.0f) { PlayerExternals_OnExtSphereTokenX(scanType, scanRange); } // ext_sphere_token_x
	void OnExtSphereToken(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3()) { PlayerExternals_OnExtSphereToken(scanType, scanRange, scanOrigin); } // ext_sphere_token
	void OnExtSphereTokenByrange(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3()) { PlayerExternals_OnExtSphereTokenByrange(scanType, scanRange, scanOrigin); } // ext_sphere_token_byrange
	void OnExtBoxToken(string scanType = "", int scanRange = 0, string scanOrigin = "") { PlayerExternals_OnExtBoxToken(scanType, scanRange, scanOrigin); } // ext_box_token
	void OnExtSetVoteDelay() { PlayerExternals_OnExtSetVoteDelay(); } // ext_set_vote_delay
	void OnResetVoteDelay() { PlayerExternals_OnResetVoteDelay(); } // reset_vote_delay
	void OnExtResetNames() { PlayerExternals_OnExtResetNames(); } // ext_reset_names
	void OnExtSendTelePoint(string teleportPosition = "") { PlayerExternals_OnExtSendTelePoint(teleportPosition); } // ext_send_tele_point
	void OnBeamFx2() { PlayerExternals_OnBeamFx2(); } // beam_fx2
	void OnExtSetNextScroll() { PlayerExternals_OnExtSetNextScroll(); } // ext_set_next_scroll
	void OnExtSetReward(int rewardGiven = 0) { PlayerExternals_OnExtSetReward(rewardGiven); } // ext_set_reward
	void OnGameDrainDeath(CBaseEntity@ attacker = null) { PlayerExternals_OnGameDrainDeath(attacker); } // game_drain_death
	void OnExtSetMap(string mapName = "", string localSpawn = "", string destSpawn = "") { PlayerExternals_OnExtSetMap(mapName, localSpawn, destSpawn); } // ext_set_map

	// ext_setspawn
	void OnExtSetspawn(string spawnName = "")
	{
		PlayerExternals_OnExtSetspawn(spawnName);
		PlayerExternals_OnExtSetspawn_2(spawnName);
	}

	void OnExtSetTransitions() { PlayerExternals_OnExtSetTransitions(); } // ext_set_transitions
	void OnExtScanPet(string petType = "") { PlayerExternals_OnExtScanPet(petType); } // ext_scan_pet
	void OnExtScanPetLoop() { PlayerExternals_OnExtScanPetLoop(); } // ext_scan_pet_loop
	void OnExtSetFrozen(string duration = "") { PlayerExternals_OnExtSetFrozen(duration); } // ext_set_frozen
	void OnExtSetUnfrozen() { PlayerExternals_OnExtSetUnfrozen(); } // ext_set_unfrozen
	void OnExtGlowBlock(int blockFlag = 0) { PlayerExternals_OnExtGlowBlock(blockFlag); } // ext_glow_block
	void OnExtEntListSort(string scanFilter = "", string searchRange = "", string searchOrigin = "", string sortBy = "") { PlayerExternals_OnExtEntListSort(scanFilter, searchRange, searchOrigin, sortBy); } // ext_ent_list_sort
	void OnExtFireAuraActivate(string dot = "", int size = 0) { PlayerExternals_OnExtFireAuraActivate(dot, size); } // ext_fire_aura_activate
	void OnFireAuraLoop() { PlayerExternals_OnFireAuraLoop(); } // fire_aura_loop
	void OnFireAuraBurn() { PlayerExternals_OnFireAuraBurn(); } // fire_aura_burn
	void OnExtFireAuraRemove() { PlayerExternals_OnExtFireAuraRemove(); } // ext_fire_aura_remove
	void OnExtPoisonAuraActivate(string dot = "", int size = 0) { PlayerExternals_OnExtPoisonAuraActivate(dot, size); } // ext_poison_aura_activate
	void OnPoisonAuraLoop() { PlayerExternals_OnPoisonAuraLoop(); } // poison_aura_loop
	void OnPoisonAuraBurn() { PlayerExternals_OnPoisonAuraBurn(); } // poison_aura_burn
	void OnExtPoisonAuraRemove() { PlayerExternals_OnExtPoisonAuraRemove(); } // ext_poison_aura_remove
	void OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0) { PlayerExternals_OnExtSetmodelbody(bodyGroup, submodel); } // ext_setmodelbody
	void OnExtSetbodytype(string bodyType = "", string armorId = "") { PlayerExternals_OnExtSetbodytype(bodyType, armorId); } // ext_setbodytype
	void OnExtRegisterHelm(string helmId = "") { PlayerExternals_OnExtRegisterHelm(helmId); } // ext_register_helm
	void OnExtRegisterArmor(string armorId = "") { PlayerExternals_OnExtRegisterArmor(armorId); } // ext_register_armor
	void OnExtDwarfTest() { PlayerExternals_OnExtDwarfTest(); } // ext_dwarf_test
	void OnExtHideArmor() { PlayerExternals_OnExtHideArmor(); } // ext_hide_armor
	void OnExtSetheadtype(int headIndex = 0) { PlayerExternals_OnExtSetheadtype(headIndex); } // ext_setheadtype
	void OnExtSetmodel() { PlayerExternals_OnExtSetmodel(); } // ext_setmodel
	void OnExtSetrender(string renderMode = "") { PlayerExternals_OnExtSetrender(renderMode); } // ext_setrender
	void OnExtTodLock(string timeOfDay = "") { PlayerExternals_OnExtTodLock(timeOfDay); } // ext_tod_lock
	void OnExtViewdist(string viewDistance = "") { PlayerExternals_OnExtViewdist(viewDistance); } // ext_viewdist
	void OnExtUrdualSlow(string releaseTime = "") { PlayerExternals_OnExtUrdualSlow(releaseTime); } // ext_urdual_slow
	void OnExtSetGender() { PlayerExternals_OnExtSetGender(); } // ext_set_gender
	void OnExtHelmExpar() { PlayerExternals_OnExtHelmExpar(); } // ext_helm_expar
	void OnExtSetSpiral(string spiralKind = "", string damage = "") { PlayerExternals_OnExtSetSpiral(spiralKind, damage); } // ext_set_spiral
	void OnExtBearMode(CBaseEntity@ bearImageId = null) { PlayerExternals_OnExtBearMode(bearImageId); } // ext_bear_mode
	void OnExtBearModeEnd() { PlayerExternals_OnExtBearModeEnd(); } // ext_bear_mode_end
	void OnExtTest(string value = "", string value2 = "", string value3 = "", string value4 = "") { PlayerExternals_OnExtTest(value, value2, value3, value4); } // ext_test
	void OnExtBlockWeather(string flag = "") { PlayerExternals_OnExtBlockWeather(flag); } // ext_block_weather
	void OnExtStam(string drainAmount = "") { PlayerExternals_OnExtStam(drainAmount); } // ext_stam
	void OnExtStuckAdj() { PlayerExternals_OnExtStuckAdj(); } // ext_stuck_adj
	void OnExtOlofSetstatus(string status = "") { PlayerExternals_OnExtOlofSetstatus(status); } // ext_olof_setstatus
	void OnExtResetModel() { PlayerExternals_OnExtResetModel(); } // ext_reset_model
	void OnExtInvis() { PlayerExternals_OnExtInvis(); } // ext_invis
	void OnExtVisible() { PlayerExternals_OnExtVisible(); } // ext_visible
	void OnExtAcidFeauraActivate(string dotDamage = "", int radius = 0) { PlayerExternals_OnExtAcidFeauraActivate(dotDamage, radius); } // ext_acid_feaura_activate
	void OnAcidFeauraLoop() { PlayerExternals_OnAcidFeauraLoop(); } // acid_feaura_loop
	void OnAcidFeauraBurn() { PlayerExternals_OnAcidFeauraBurn(); } // acid_feaura_burn
	void OnExtAcidFeauraRemove() { PlayerExternals_OnExtAcidFeauraRemove(); } // ext_acid_feaura_remove
	void OnExtWeatherChange(string weather = "") { PlayerExternals_OnExtWeatherChange(weather); } // ext_weather_change
	void OnExtWeatherForceChange(string weather = "") { PlayerExternals_OnExtWeatherForceChange(weather); } // ext_weather_force_change
	void OnExtRepelShield(float duration = 0.0f, int radius = 0, string specialEffect = "") { PlayerExternals_OnExtRepelShield(duration, radius, specialEffect); } // ext_repel_shield
	void OnLoopRepelShield() { PlayerExternals_OnLoopRepelShield(); } // loop_repel_shield
	void OnAffectTargetsRepelShield() { PlayerExternals_OnAffectTargetsRepelShield(); } // affect_targets_repel_shield
	void OnExtEndRepelShield() { PlayerExternals_OnExtEndRepelShield(); } // ext_end_repel_shield
	void OnExtSetDarkLevel(float rating = 0.0f) { PlayerExternals_OnExtSetDarkLevel(rating); } // ext_set_dark_level
	void OnExtTossprojectile(string projectile = "", string view = "", string target = "", int speed = 0, string damage = "", int cof = 0, string skill = "", string value = "", string value2 = "") { PlayerExternals_OnExtTossprojectile(projectile, view, target, speed, damage, cof, skill, value, value2); } // ext_tossprojectile
	void OnExtSfauraStart(CBaseEntity@ item = null) { PlayerExternals_OnExtSfauraStart(item); } // ext_sfaura_start
	void OnSfauraLoop() { PlayerExternals_OnSfauraLoop(); } // sfaura_loop
	void OnSfauraAffectTargets() { PlayerExternals_OnSfauraAffectTargets(); } // sfaura_affect_targets
	void OnSfauraFxRefresh() { PlayerExternals_OnSfauraFxRefresh(); } // sfaura_fx_refresh
	void OnExtSfauraEnd(string endSource = "") { PlayerExternals_OnExtSfauraEnd(endSource); } // ext_sfaura_end
	void OnExtTossSpear(string chargeLevel = "", string projectile = "", string sourceOrigin = "", string target = "", string speed = "", int damage = 0, string cof = "", string skill = "") { PlayerExternals_OnExtTossSpear(chargeLevel, projectile, sourceOrigin, target, speed, damage, cof, skill); } // ext_toss_spear
	void OnExtHolyAura(float duration = 0.0f, int radius = 0, string power = "") { PlayerExternals_OnExtHolyAura(duration, radius, power); } // ext_holy_aura
	void OnHolyAuraRefresh() { PlayerExternals_OnHolyAuraRefresh(); } // holy_aura_refresh
	void OnLoopHolyAura() { PlayerExternals_OnLoopHolyAura(); } // loop_holy_aura
	void OnAffectTargetsHolyAura() { PlayerExternals_OnAffectTargetsHolyAura(); } // affect_targets_holy_aura
	void OnExtEndHolyAura() { PlayerExternals_OnExtEndHolyAura(); } // ext_end_holy_aura
	void OnExtSetskin(string skinName = "") { PlayerExternals_OnExtSetskin(skinName); } // ext_setskin
	void OnExtPoleLshield() { PlayerExternals_OnExtPoleLshield(); } // ext_pole_lshield
	void OnPoleLshieldLoop() { PlayerExternals_OnPoleLshieldLoop(); } // pole_lshield_loop
	void OnPoleLshieldAffectTargets() { PlayerExternals_OnPoleLshieldAffectTargets(); } // pole_lshield_affect_targets
	void OnExtPoleLshieldEnd() { PlayerExternals_OnExtPoleLshieldEnd(); } // ext_pole_lshield_end
	void OnSvillaMusic() { PlayerExternals_OnSvillaMusic(); } // svilla_music
	void OnSvillaMusic2() { PlayerExternals_OnSvillaMusic2(); } // svilla_music2
	void OnExtStopMusic() { PlayerExternals_OnExtStopMusic(); } // ext_stop_music
	void OnExtSvillaHostile() { PlayerExternals_OnExtSvillaHostile(); } // ext_svilla_hostile
	void OnExtWeatherSetClear() { PlayerExternals_OnExtWeatherSetClear(); } // ext_weather_set_clear
	void OnExtWeatherManualChange(string weather = "") { PlayerExternals_OnExtWeatherManualChange(weather); } // ext_weather_manual_change
	void OnTrigSrocvPlayerOnShelf() { PlayerExternals_OnTrigSrocvPlayerOnShelf(); } // trig_srocv_player_on_shelf
	void OnTrigSrocvPlayerOnTable() { PlayerExternals_OnTrigSrocvPlayerOnTable(); } // trig_srocv_player_on_table
	void OnExtBravery() { PlayerExternals_OnExtBravery(); } // ext_bravery
	void OnExtDmgAdjust(string damageType = "", string ratio = "") { PlayerExternals_OnExtDmgAdjust(damageType, ratio); } // ext_dmg_adjust
	void OnExtDmgAddDot(string damageType = "", string ratio = "") { PlayerExternals_OnExtDmgAddDot(damageType, ratio); } // ext_dmg_add_dot
	void OnTrigDamage(string triggerName = "", string damage = "", string damageType = "") { PlayerExternals_OnTrigDamage(triggerName, damage, damageType); } // trig_damage
	void OnExtPlayrandomsound(int channel = 0, int volume = 0, string attenuation = "", string pitch = "", string sound1 = "", string sound2 = "", string sound3 = "", string sound4 = "", string sound5 = "") { PlayerExternals_OnExtPlayrandomsound(channel, volume, attenuation, pitch, sound1, sound2, sound3, sound4, sound5); } // ext_playrandomsound
	void OnExtOrcforBossMusak(int stage = 0, Vector3 bossOrigin = Vector3()) { PlayerExternals_OnExtOrcforBossMusak(stage, bossOrigin); } // ext_orcfor_boss_musak
	void OnExtGabeMusak(string stage = "") { PlayerExternals_OnExtGabeMusak(stage); } // ext_gabe_musak
	void OnExtChangelevelPrep() { PlayerExternals_OnExtChangelevelPrep(); } // ext_changelevel_prep
	void OnExtBankLock() { PlayerExternals_OnExtBankLock(); } // ext_bank_lock
	void OnExtBankLockRelease() { PlayerExternals_OnExtBankLockRelease(); } // ext_bank_lock_release
	void OnExtAlanceInit() { PlayerExternals_OnExtAlanceInit(); } // ext_alance_init
	void OnAlanceDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { PlayerExternals_OnAlanceDodamage(hit, target, start, end, damageType, damageText); } // alance_dodamage
	void OnExtDrainstamina(string amount = "") { PlayerExternals_OnExtDrainstamina(amount); } // ext_drainstamina
	void OnExtClbeam() { PlayerExternals_OnExtClbeam(); } // ext_clbeam
	void OnExtRepelBurst(int burstDamage = 0, int radius = 0, int falloff = 0, string damageType = "", string damageSkill = "", int strength = 0, float maxHp = 0.0f, Vector3 origin = Vector3()) { PlayerExternals_OnExtRepelBurst(burstDamage, radius, falloff, damageType, damageSkill, strength, maxHp, origin); } // ext_repel_burst
	void OnRepelDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { PlayerExternals_OnRepelDodamage(hit, target, start, end, damageType, damageText); } // repel_dodamage
	void OnExtRepel(CBaseEntity@ target = null, Vector3 origin = Vector3(), float strength = 0.0f, int verticalBoost = 0, float maxTargetHp = 0.0f, int overrideFlag = 0) { PlayerExternals_OnExtRepel(target, origin, strength, verticalBoost, maxTargetHp, overrideFlag); } // ext_repel
	void OnExtLcod(Vector3 origin = Vector3(), string damage = "", float duration = 0.0f) { PlayerExternals_OnExtLcod(origin, damage, duration); } // ext_lcod
	void OnLcodLoop() { PlayerExternals_OnLcodLoop(); } // lcod_loop
	void OnLcodEnd() { PlayerExternals_OnLcodEnd(); } // lcod_end
	void OnExtGcod(Vector3 origin = Vector3(), string damage = "", float duration = 0.0f) { PlayerExternals_OnExtGcod(origin, damage, duration); } // ext_gcod
	void OnGcodLoop() { PlayerExternals_OnGcodLoop(); } // gcod_loop
	void OnGcodEnd() { PlayerExternals_OnGcodEnd(); } // gcod_end
	void OnExtWraithActive(int status = 0) { PlayerExternals_OnExtWraithActive(status); } // ext_wraith_active
	void OnExtFissure() { PlayerExternals_OnExtFissure(); } // ext_fissure
	void OnFissureLoop() { PlayerExternals_OnFissureLoop(); } // fissure_loop
	void OnFissureDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { PlayerExternals_OnFissureDodamage(hit, target, start, end, damageType, damageText); } // fissure_dodamage
	void OnExtSummonUnique(string summonTag = "") { PlayerExternals_OnExtSummonUnique(summonTag); } // ext_summon_unique
	void OnExtUnsummonUnique(string summonTag = "") { PlayerExternals_OnExtUnsummonUnique(summonTag); } // ext_unsummon_unique
	void OnExtEpilepsyTimeBegin() { PlayerExternals_OnExtEpilepsyTimeBegin(); } // ext_epilepsy_time_begin
	void OnEpilepsyLoop() { PlayerExternals_OnEpilepsyLoop(); } // epilepsy_loop
	void OnExtEpilepsyTimeEnd() { PlayerExternals_OnExtEpilepsyTimeEnd(); } // ext_epilepsy_time_end
	void OnExtSummonRegisterPet(CBaseEntity@ pet = null) { PlayerExternals_OnExtSummonRegisterPet(pet); } // ext_summon_register_pet
	void OnExtSummonPetsNew(CBasePlayer@ player = null, string petScript = "") { PlayerExternals_OnExtSummonPetsNew(player, petScript); } // ext_summon_pets_new
	void OnExtUnsummonPetsNew(CBasePlayer@ player = null, CBaseEntity@ pet = null, int petRequested = 0) { PlayerExternals_OnExtUnsummonPetsNew(player, pet, petRequested); } // ext_unsummon_pets_new
	void OnExtIceStaffOn() { PlayerExternals_OnExtIceStaffOn(); } // ext_ice_staff_on
	void OnExtIceStaffOff() { PlayerExternals_OnExtIceStaffOff(); } // ext_ice_staff_off
	void OnExtRegisterFists(CBaseEntity@ fistsId = null) { PlayerExternals_OnExtRegisterFists(fistsId); } // ext_register_fists
	void OnExtLesserLeadfoot(float stunAmount = 0.0f) { PlayerExternals_OnExtLesserLeadfoot(stunAmount); } // ext_lesser_leadfoot
	void OnExtDelayPlaysound(float delay = 0.0f, int channel = 0, int volume = 0, string soundFile = "") { PlayerExternals_OnExtDelayPlaysound(delay, channel, volume, soundFile); } // ext_delay_playsound
	void OnExtDelayPlaysound2() { PlayerExternals_OnExtDelayPlaysound2(); } // ext_delay_playsound2
	void OnExtTosscre(float hand = 0.0f, string type = "") { PlayerExternals_OnExtTosscre(hand, type); } // ext_tosscre
	void OnExtSetGlow(string glowEnabled = "") { PlayerExternals_OnExtSetGlow(glowEnabled); } // ext_set_glow
	void OnRestoreItemLights() { PlayerExternals_OnRestoreItemLights(); } // restore_item_lights
	void OnExtTeleportfx1() { PlayerExternals_OnExtTeleportfx1(); } // ext_teleportfx1
	void OnExtTeleportfx1Delay() { PlayerExternals_OnExtTeleportfx1Delay(); } // ext_teleportfx1_delay
	void OnExtTeleportfx2() { PlayerExternals_OnExtTeleportfx2(); } // ext_teleportfx2
	void OnExtsocShowScores(float redScore = 0.0f, float blueScore = 0.0f) { PlayerExternals_OnExtsocShowScores(redScore, blueScore); } // extsoc_show_scores
	void OnExtsocFlashWin() { PlayerExternals_OnExtsocFlashWin(); } // extsoc_flash_win
	void OnExtHudIcon(int icon = 0, string refName = "", int xPercent = 0, int yPercent = 0, int heightPercent = 0, int widthPercent = 0, float duration = 0.0f) { PlayerExternals_OnExtHudIcon(icon, refName, xPercent, yPercent, heightPercent, widthPercent, duration); } // ext_hud_icon
	void OnExtShenderTelfdoor() { PlayerExternals_OnExtShenderTelfdoor(); } // ext_shender_telfdoor
	void OnExtConflict() { PlayerExternals_OnExtConflict(); } // ext_conflict
	void OnExtDumpvars() { PlayerExternals_OnExtDumpvars(); } // ext_dumpvars
	void OnExtShowflags() { PlayerExternals_OnExtShowflags(); } // ext_showflags
	void OnExtSvplaysoundKiss(int channel = 0, int volume = 0, string sound = "", float attenuation = 0.0f, int pitch = 0) { PlayerExternals_OnExtSvplaysoundKiss(channel, volume, sound, attenuation, pitch); } // ext_svplaysound_kiss
	void OnExtClearValidGauntlets() { PlayerExternals_OnExtClearValidGauntlets(); } // ext_clear_valid_gauntlets
	void OnExtHasteCooldown(float cooldown = 0.0f) { PlayerExternals_OnExtHasteCooldown(cooldown); } // ext_haste_cooldown
	void OnExtRegisterCorrode(string duration = "") { PlayerExternals_OnExtRegisterCorrode(duration); } // ext_register_corrode
	void OnExtCleventMe(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { PlayerExternals_OnExtCleventMe(eventName, value, value2, value3, value4, value5, value6, value7); } // ext_clevent_me
	void OnExtCleventAll(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { PlayerExternals_OnExtCleventAll(eventName, value, value2, value3, value4, value5, value6, value7); } // ext_clevent_all
	void OnExtManaRegenLoop() { PlayerExternals_OnExtManaRegenLoop(); } // ext_mana_regen_loop
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3()) { PlayerExternals_OnExtArrowHit(hit, hitEntity, startPosition); } // ext_arrow_hit
	void OnExtResetBank() { PlayerExternals_OnExtResetBank(); } // ext_reset_bank
	void OnExtTargetedByMob(CBaseEntity@ attacker = null) { PlayerExternals_OnExtTargetedByMob(attacker); } // ext_targeted_by_mob
	void OnExtUntargetedByMob(CBaseEntity@ attacker = null) { PlayerExternals_OnExtUntargetedByMob(attacker); } // ext_untargeted_by_mob
	void OnGameTouchedLocalTrans(string transTitle = "", string transId = "", string reqAllPlayers = "", string mins = "", string maxs = "", string respawnName = "") { PlayerExternals_OnGameTouchedLocalTrans(transTitle, transId, reqAllPlayers, mins, maxs, respawnName); } // game_touched_local_trans
	void OnLoopCheckLocalTrans() { PlayerExternals_OnLoopCheckLocalTrans(); } // loop_check_local_trans
	void OnExtRemoveAfk() { PlayerExternals_OnExtRemoveAfk(); } // ext_remove_afk
	void OnExtPoisonBolt(string origin = "") { PlayerExternals_OnExtPoisonBolt(origin); } // ext_poison_bolt
	void OnExtPoisonBoltLoop() { PlayerExternals_OnExtPoisonBoltLoop(); } // ext_poison_bolt_loop
	void OnExtPoisonBoltDmg() { PlayerExternals_OnExtPoisonBoltDmg(); } // ext_poison_bolt_dmg
	void OnExtPoisonBoltAffect() { PlayerExternals_OnExtPoisonBoltAffect(); } // ext_poison_bolt_affect
	void OnExtSpeak(string text = "") { PlayerExternals_OnExtSpeak(text); } // ext_speak
	void OnExtSaytextrange(int range = 0) { PlayerExternals_OnExtSaytextrange(range); } // ext_saytextrange
	void OnExtReqViewmodelIdx() { PlayerExternals_OnExtReqViewmodelIdx(); } // ext_req_viewmodel_idx
	void OnExtRecViewmodelIdx(string viewmodelIndex = "") { PlayerExternals_OnExtRecViewmodelIdx(viewmodelIndex); } // ext_rec_viewmodel_idx
	void OnExtRemoveEffect(string effectName = "") { PlayerExternals_OnExtRemoveEffect(effectName); } // ext_remove_effect
	void OnExtClientcmd(string command = "") { PlayerExternals_OnExtClientcmd(command); } // ext_clientcmd
	void OnExtSetFquest() { PlayerExternals_OnExtSetFquest(); } // ext_set_fquest
	void OnExtDebugQue(string message = "") { PlayerExternals_OnExtDebugQue(message); } // ext_debug_que
	void OnExtDebugQueLoop() { PlayerExternals_OnExtDebugQueLoop(); } // ext_debug_que_loop
	void OnExtQuakeFx(float duration = 0.0f) { PlayerExternals_OnExtQuakeFx(duration); } // ext_quake_fx
	void OnExtQuakeFxEnd() { PlayerExternals_OnExtQuakeFxEnd(); } // ext_quake_fx_end
	void OnExtIexistTest(string itemName = "", string amount = "") { PlayerExternals_OnExtIexistTest(itemName, amount); } // ext_iexist_test
	void OnExtShieldUp(int raised = 0) { PlayerExternals_OnExtShieldUp(raised); } // ext_shield_up
	void OnExtDburst(string origin = "", int radius = 0, int repelFlag = 0, int playSound = 0) { PlayerExternals_OnExtDburst(origin, radius, repelFlag, playSound); } // ext_dburst
	void OnDburstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { PlayerExternals_OnDburstDodamage(hit, target, start, end, damageType, damageText); } // dburst_dodamage
	void OnExtEnvironmentChange(string environment = "") { PlayerExternals_OnExtEnvironmentChange(environment); } // ext_environment_change
	void OnExtChangeSky(string skyName = "") { PlayerExternals_OnExtChangeSky(skyName); } // ext_change_sky
	void OnLBoltScanSpeed() {} // L_BOLT_SCAN_SPEED
	void OnLCheckExptime() {} // L_CHECK_EXPTIME
	void OnLDur() {} // L_DUR
	void OnPlrEpilepsyDelay() {} // PLR_EPILEPSY_DELAY
	void OnPlrGcodDur() {} // PLR_GCOD_DUR
	void OnPlrLcodDur() {} // PLR_LCOD_DUR
	void OnExtDarkenbloom() {} // ext_darkenbloom

	// This file's events and timers by their .script names
	bool PlayerExternals_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "acid_feaura_burn") { OnAcidFeauraBurn(); return true; }
		if (name == "acid_feaura_loop") { OnAcidFeauraLoop(); return true; }
		if (name == "affect_targets_holy_aura") { OnAffectTargetsHolyAura(); return true; }
		if (name == "affect_targets_repel_shield") { OnAffectTargetsRepelShield(); return true; }
		if (name == "alance_dodamage") { OnAlanceDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "beam_fx2") { OnBeamFx2(); return true; }
		if (name == "check_flags") { OnCheckFlags(); return true; }
		if (name == "check_flags_expired") { OnCheckFlagsExpired(); return true; }
		if (name == "dburst_dodamage") { OnDburstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "epilepsy_loop") { OnEpilepsyLoop(); return true; }
		if (name == "ext_acid_feaura_activate") { OnExtAcidFeauraActivate(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "ext_acid_feaura_remove") { OnExtAcidFeauraRemove(); return true; }
		if (name == "ext_addgold") { OnExtAddgold(Param(params, 0)); return true; }
		if (name == "ext_alance_init") { OnExtAlanceInit(); return true; }
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "ext_bank_lock") { OnExtBankLock(); return true; }
		if (name == "ext_bank_lock_release") { OnExtBankLockRelease(); return true; }
		if (name == "ext_bear_mode") { OnExtBearMode(EntityParam(params, 0)); return true; }
		if (name == "ext_bear_mode_end") { OnExtBearModeEnd(); return true; }
		if (name == "ext_block_weather") { OnExtBlockWeather(Param(params, 0)); return true; }
		if (name == "ext_box_token") { OnExtBoxToken(Param(params, 0), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_bravery") { OnExtBravery(); return true; }
		if (name == "ext_change_sky") { OnExtChangeSky(Param(params, 0)); return true; }
		if (name == "ext_changelevel_prep") { OnExtChangelevelPrep(); return true; }
		if (name == "ext_clbeam") { OnExtClbeam(); return true; }
		if (name == "ext_clear_valid_gauntlets") { OnExtClearValidGauntlets(); return true; }
		if (name == "ext_clevent_all") { OnExtCleventAll(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "ext_clevent_me") { OnExtCleventMe(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "ext_clientcmd") { OnExtClientcmd(Param(params, 0)); return true; }
		if (name == "ext_conflict") { OnExtConflict(); return true; }
		if (name == "ext_dburst") { OnExtDburst(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Int(Param(params, 3))); return true; }
		if (name == "ext_debug_que") { OnExtDebugQue(Param(params, 0)); return true; }
		if (name == "ext_debug_que_loop") { OnExtDebugQueLoop(); return true; }
		if (name == "ext_delay_playsound") { OnExtDelayPlaysound(Float(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "ext_delay_playsound2") { OnExtDelayPlaysound2(); return true; }
		if (name == "ext_dmg_add_dot") { OnExtDmgAddDot(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_dmg_adjust") { OnExtDmgAdjust(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_dodamage") { OnExtDodamage(EntityParam(params, 0), Param(params, 1), Float(Param(params, 2)), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "ext_drainstamina") { OnExtDrainstamina(Param(params, 0)); return true; }
		if (name == "ext_dumpvars") { OnExtDumpvars(); return true; }
		if (name == "ext_dwarf_test") { OnExtDwarfTest(); return true; }
		if (name == "ext_end_holy_aura") { OnExtEndHolyAura(); return true; }
		if (name == "ext_end_repel_shield") { OnExtEndRepelShield(); return true; }
		if (name == "ext_ent_list_sort") { OnExtEntListSort(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ext_environment_change") { OnExtEnvironmentChange(Param(params, 0)); return true; }
		if (name == "ext_epilepsy_time_begin") { OnExtEpilepsyTimeBegin(); return true; }
		if (name == "ext_epilepsy_time_end") { OnExtEpilepsyTimeEnd(); return true; }
		if (name == "ext_fire_aura_activate") { OnExtFireAuraActivate(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "ext_fire_aura_remove") { OnExtFireAuraRemove(); return true; }
		if (name == "ext_fissure") { OnExtFissure(); return true; }
		if (name == "ext_flash_bang") { OnExtFlashBang(Vec(Param(params, 0)), Int(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "ext_gabe_musak") { OnExtGabeMusak(Param(params, 0)); return true; }
		if (name == "ext_gcod") { OnExtGcod(Vec(Param(params, 0)), Param(params, 1), Float(Param(params, 2))); return true; }
		if (name == "ext_glow_block") { OnExtGlowBlock(Int(Param(params, 0))); return true; }
		if (name == "ext_haste_cooldown") { OnExtHasteCooldown(Float(Param(params, 0))); return true; }
		if (name == "ext_helm_expar") { OnExtHelmExpar(); return true; }
		if (name == "ext_hide_armor") { OnExtHideArmor(); return true; }
		if (name == "ext_holy_aura") { OnExtHolyAura(Float(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_hud_icon") { OnExtHudIcon(Int(Param(params, 0)), Param(params, 1), Int(Param(params, 2)), Int(Param(params, 3)), Int(Param(params, 4)), Int(Param(params, 5)), Float(Param(params, 6))); return true; }
		if (name == "ext_ice_staff_off") { OnExtIceStaffOff(); return true; }
		if (name == "ext_ice_staff_on") { OnExtIceStaffOn(); return true; }
		if (name == "ext_iexist_test") { OnExtIexistTest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_invalidate") { OnExtInvalidate(Param(params, 0)); return true; }
		if (name == "ext_invis") { OnExtInvis(); return true; }
		if (name == "ext_lcod") { OnExtLcod(Vec(Param(params, 0)), Param(params, 1), Float(Param(params, 2))); return true; }
		if (name == "ext_lesser_leadfoot") { OnExtLesserLeadfoot(Float(Param(params, 0))); return true; }
		if (name == "ext_mana_regen_loop") { OnExtManaRegenLoop(); return true; }
		if (name == "ext_olof_setstatus") { OnExtOlofSetstatus(Param(params, 0)); return true; }
		if (name == "ext_orcfor_boss_musak") { OnExtOrcforBossMusak(Int(Param(params, 0)), Vec(Param(params, 1))); return true; }
		if (name == "ext_play_music") { OnExtPlayMusic(Param(params, 0)); return true; }
		if (name == "ext_play_music_me") { OnExtPlayMusicMe(Param(params, 0)); return true; }
		if (name == "ext_playrandomsound") { OnExtPlayrandomsound(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "ext_playsound") { OnExtPlaysound(Int(Param(params, 0)), Vec(Param(params, 1)), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "ext_playsound2") { OnExtPlaysound2(); return true; }
		if (name == "ext_playsound_kiss") { OnExtPlaysoundKiss(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_poison_aura_activate") { OnExtPoisonAuraActivate(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "ext_poison_aura_remove") { OnExtPoisonAuraRemove(); return true; }
		if (name == "ext_poison_bolt") { OnExtPoisonBolt(Param(params, 0)); return true; }
		if (name == "ext_poison_bolt_affect") { OnExtPoisonBoltAffect(); return true; }
		if (name == "ext_poison_bolt_dmg") { OnExtPoisonBoltDmg(); return true; }
		if (name == "ext_poison_bolt_loop") { OnExtPoisonBoltLoop(); return true; }
		if (name == "ext_pole_lshield") { OnExtPoleLshield(); return true; }
		if (name == "ext_pole_lshield_end") { OnExtPoleLshieldEnd(); return true; }
		if (name == "ext_quake_fx") { OnExtQuakeFx(Float(Param(params, 0))); return true; }
		if (name == "ext_quake_fx_end") { OnExtQuakeFxEnd(); return true; }
		if (name == "ext_quest") { OnExtQuest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_rec_viewmodel_idx") { OnExtRecViewmodelIdx(Param(params, 0)); return true; }
		if (name == "ext_register_armor") { OnExtRegisterArmor(Param(params, 0)); return true; }
		if (name == "ext_register_corrode") { OnExtRegisterCorrode(Param(params, 0)); return true; }
		if (name == "ext_register_fists") { OnExtRegisterFists(EntityParam(params, 0)); return true; }
		if (name == "ext_register_helm") { OnExtRegisterHelm(Param(params, 0)); return true; }
		if (name == "ext_remove_afk") { OnExtRemoveAfk(); return true; }
		if (name == "ext_remove_effect") { OnExtRemoveEffect(Param(params, 0)); return true; }
		if (name == "ext_remove_status_flag") { OnExtRemoveStatusFlag(Param(params, 0)); return true; }
		if (name == "ext_remove_status_flags_type") { OnExtRemoveStatusFlagsType(Param(params, 0)); return true; }
		if (name == "ext_removed_effects") { OnExtRemovedEffects(); return true; }
		if (name == "ext_rename_me") { OnExtRenameMe(Param(params, 0)); return true; }
		if (name == "ext_repel") { OnExtRepel(EntityParam(params, 0), Vec(Param(params, 1)), Float(Param(params, 2)), Int(Param(params, 3)), Float(Param(params, 4)), Int(Param(params, 5))); return true; }
		if (name == "ext_repel_burst") { OnExtRepelBurst(Int(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2)), Param(params, 3), Param(params, 4), Int(Param(params, 5)), Float(Param(params, 6)), Vec(Param(params, 7))); return true; }
		if (name == "ext_repel_shield") { OnExtRepelShield(Float(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_req_viewmodel_idx") { OnExtReqViewmodelIdx(); return true; }
		if (name == "ext_reset_bank") { OnExtResetBank(); return true; }
		if (name == "ext_reset_model") { OnExtResetModel(); return true; }
		if (name == "ext_reset_names") { OnExtResetNames(); return true; }
		if (name == "ext_saytextrange") { OnExtSaytextrange(Int(Param(params, 0))); return true; }
		if (name == "ext_scan_pet") { OnExtScanPet(Param(params, 0)); return true; }
		if (name == "ext_scan_pet_loop") { OnExtScanPetLoop(); return true; }
		if (name == "ext_send_tele_point") { OnExtSendTelePoint(Param(params, 0)); return true; }
		if (name == "ext_set_alco_type") { OnExtSetAlcoType(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "ext_set_dark_level") { OnExtSetDarkLevel(Float(Param(params, 0))); return true; }
		if (name == "ext_set_fquest") { OnExtSetFquest(); return true; }
		if (name == "ext_set_frozen") { OnExtSetFrozen(Param(params, 0)); return true; }
		if (name == "ext_set_gender") { OnExtSetGender(); return true; }
		if (name == "ext_set_glow") { OnExtSetGlow(Param(params, 0)); return true; }
		if (name == "ext_set_hand_id") { OnExtSetHandId(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "ext_set_map") { OnExtSetMap(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "ext_set_next_scroll") { OnExtSetNextScroll(); return true; }
		if (name == "ext_set_reward") { OnExtSetReward(Int(Param(params, 0))); return true; }
		if (name == "ext_set_spiral") { OnExtSetSpiral(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_set_status_flag") { OnExtSetStatusFlag(Param(params, 0), Param(params, 1), Int(Param(params, 2)), Int(Param(params, 3)), Param(params, 4)); return true; }
		if (name == "ext_set_swift_blade") { OnExtSetSwiftBlade(Float(Param(params, 0))); return true; }
		if (name == "ext_set_transitions") { OnExtSetTransitions(); return true; }
		if (name == "ext_set_unfrozen") { OnExtSetUnfrozen(); return true; }
		if (name == "ext_set_vote_delay") { OnExtSetVoteDelay(); return true; }
		if (name == "ext_setangle") { OnExtSetangle(Vec(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "ext_setbodytype") { OnExtSetbodytype(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_setgold") { OnExtSetgold(Int(Param(params, 0))); return true; }
		if (name == "ext_setheadtype") { OnExtSetheadtype(Int(Param(params, 0))); return true; }
		if (name == "ext_setmodel") { OnExtSetmodel(); return true; }
		if (name == "ext_setmodelbody") { OnExtSetmodelbody(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "ext_setrender") { OnExtSetrender(Param(params, 0)); return true; }
		if (name == "ext_setskin") { OnExtSetskin(Param(params, 0)); return true; }
		if (name == "ext_setspawn") { OnExtSetspawn(Param(params, 0)); return true; }
		if (name == "ext_sfaura_end") { OnExtSfauraEnd(Param(params, 0)); return true; }
		if (name == "ext_sfaura_start") { OnExtSfauraStart(EntityParam(params, 0)); return true; }
		if (name == "ext_shender_telfdoor") { OnExtShenderTelfdoor(); return true; }
		if (name == "ext_shield_up") { OnExtShieldUp(Int(Param(params, 0))); return true; }
		if (name == "ext_showflags") { OnExtShowflags(); return true; }
		if (name == "ext_speak") { OnExtSpeak(Param(params, 0)); return true; }
		if (name == "ext_sphere_token") { OnExtSphereToken(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2))); return true; }
		if (name == "ext_sphere_token_byrange") { OnExtSphereTokenByrange(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2))); return true; }
		if (name == "ext_sphere_token_x") { OnExtSphereTokenX(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "ext_spider_protect") { OnExtSpiderProtect(Float(Param(params, 0)), Float(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_stam") { OnExtStam(Param(params, 0)); return true; }
		if (name == "ext_stop_music") { OnExtStopMusic(); return true; }
		if (name == "ext_stuck_adj") { OnExtStuckAdj(); return true; }
		if (name == "ext_summon_pets_new") { OnExtSummonPetsNew(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "ext_summon_register_pet") { OnExtSummonRegisterPet(EntityParam(params, 0)); return true; }
		if (name == "ext_summon_unique") { OnExtSummonUnique(Param(params, 0)); return true; }
		if (name == "ext_svilla_hostile") { OnExtSvillaHostile(); return true; }
		if (name == "ext_svplaysound_kiss") { OnExtSvplaysoundKiss(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Int(Param(params, 4))); return true; }
		if (name == "ext_targeted_by_mob") { OnExtTargetedByMob(EntityParam(params, 0)); return true; }
		if (name == "ext_teleportfx1") { OnExtTeleportfx1(); return true; }
		if (name == "ext_teleportfx1_delay") { OnExtTeleportfx1Delay(); return true; }
		if (name == "ext_teleportfx2") { OnExtTeleportfx2(); return true; }
		if (name == "ext_test") { OnExtTest(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ext_tod_lock") { OnExtTodLock(Param(params, 0)); return true; }
		if (name == "ext_toss_spear") { OnExtTossSpear(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Int(Param(params, 5)), Param(params, 6), Param(params, 7)); return true; }
		if (name == "ext_tosscre") { OnExtTosscre(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "ext_tossprojectile") { OnExtTossprojectile(Param(params, 0), Param(params, 1), Param(params, 2), Int(Param(params, 3)), Param(params, 4), Int(Param(params, 5)), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "ext_unsummon_pets_new") { OnExtUnsummonPetsNew(PlayerParam(params, 0), EntityParam(params, 1), Int(Param(params, 2))); return true; }
		if (name == "ext_unsummon_unique") { OnExtUnsummonUnique(Param(params, 0)); return true; }
		if (name == "ext_untargeted_by_mob") { OnExtUntargetedByMob(EntityParam(params, 0)); return true; }
		if (name == "ext_urdual_slow") { OnExtUrdualSlow(Param(params, 0)); return true; }
		if (name == "ext_viewdist") { OnExtViewdist(Param(params, 0)); return true; }
		if (name == "ext_visible") { OnExtVisible(); return true; }
		if (name == "ext_weather_change") { OnExtWeatherChange(Param(params, 0)); return true; }
		if (name == "ext_weather_force_change") { OnExtWeatherForceChange(Param(params, 0)); return true; }
		if (name == "ext_weather_manual_change") { OnExtWeatherManualChange(Param(params, 0)); return true; }
		if (name == "ext_weather_set_clear") { OnExtWeatherSetClear(); return true; }
		if (name == "ext_wraith_active") { OnExtWraithActive(Int(Param(params, 0))); return true; }
		if (name == "extsoc_flash_win") { OnExtsocFlashWin(); return true; }
		if (name == "extsoc_show_scores") { OnExtsocShowScores(Float(Param(params, 0)), Float(Param(params, 1))); return true; }
		if (name == "fake_sound_precache") { OnFakeSoundPrecache(); return true; }
		if (name == "fire_aura_burn") { OnFireAuraBurn(); return true; }
		if (name == "fire_aura_loop") { OnFireAuraLoop(); return true; }
		if (name == "fissure_dodamage") { OnFissureDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "fissure_loop") { OnFissureLoop(); return true; }
		if (name == "float_to_percent") { OnFloatToPercent(Float(Param(params, 0))); return true; }
		if (name == "freeze_solid_end") { OnFreezeSolidEnd(Int(Param(params, 0))); return true; }
		if (name == "freeze_solid_start") { OnFreezeSolidStart(Param(params, 0), Param(params, 1)); return true; }
		if (name == "func_get_dualwield_reduct") { Return(OnFuncGetDualwieldReduct(Param(params, 0))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_drain_death") { OnGameDrainDeath(EntityParam(params, 0)); return true; }
		if (name == "game_equipped") { OnGameEquipped(EntityParam(params, 0)); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitbodypart") { OnGameHitbodypart(Param(params, 0)); return true; }
		if (name == "game_scriptflag_update") { OnGameScriptflagUpdate(Param(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4))); return true; }
		if (name == "game_touched_local_trans") { OnGameTouchedLocalTrans(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "gcod_end") { OnGcodEnd(); return true; }
		if (name == "gcod_loop") { OnGcodLoop(); return true; }
		if (name == "give_hp") { OnGiveHp(Param(params, 0)); return true; }
		if (name == "give_mp") { OnGiveMp(Param(params, 0)); return true; }
		if (name == "hide_body_parts") { OnHideBodyParts(Param(params, 0)); return true; }
		if (name == "holy_aura_refresh") { OnHolyAuraRefresh(); return true; }
		if (name == "lcod_end") { OnLcodEnd(); return true; }
		if (name == "lcod_loop") { OnLcodLoop(); return true; }
		if (name == "loop_check_local_trans") { OnLoopCheckLocalTrans(); return true; }
		if (name == "loop_holy_aura") { OnLoopHolyAura(); return true; }
		if (name == "loop_repel_shield") { OnLoopRepelShield(); return true; }
		if (name == "poison_aura_burn") { OnPoisonAuraBurn(); return true; }
		if (name == "poison_aura_loop") { OnPoisonAuraLoop(); return true; }
		if (name == "pole_lshield_affect_targets") { OnPoleLshieldAffectTargets(); return true; }
		if (name == "pole_lshield_loop") { OnPoleLshieldLoop(); return true; }
		if (name == "potion_regen") { OnPotionRegen(Float(Param(params, 0))); return true; }
		if (name == "potion_vampire") { OnPotionVampire(Float(Param(params, 0))); return true; }
		if (name == "regen_end") { OnRegenEnd(); return true; }
		if (name == "regen_start") { OnRegenStart(); return true; }
		if (name == "register_body") { OnRegisterBody(Param(params, 0), Param(params, 1)); return true; }
		if (name == "repel_dodamage") { OnRepelDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "reset_vote_delay") { OnResetVoteDelay(); return true; }
		if (name == "restore_item_lights") { OnRestoreItemLights(); return true; }
		if (name == "send_damage") { OnSendDamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "set_glow_id") { OnSetGlowId(Param(params, 0)); return true; }
		if (name == "set_spawn_point") { OnSetSpawnPoint(Param(params, 0)); return true; }
		if (name == "set_stun_prot") { OnSetStunProt(Float(Param(params, 0))); return true; }
		if (name == "set_swift_blade") { OnSetSwiftBlade(); return true; }
		if (name == "set_two_hand") { OnSetTwoHand(); return true; }
		if (name == "sfaura_affect_targets") { OnSfauraAffectTargets(); return true; }
		if (name == "sfaura_fx_refresh") { OnSfauraFxRefresh(); return true; }
		if (name == "sfaura_loop") { OnSfauraLoop(); return true; }
		if (name == "spider_protect_end") { OnSpiderProtectEnd(); return true; }
		if (name == "svilla_music") { OnSvillaMusic(); return true; }
		if (name == "svilla_music2") { OnSvillaMusic2(); return true; }
		if (name == "trig_damage") { OnTrigDamage(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "trig_srocv_player_on_shelf") { OnTrigSrocvPlayerOnShelf(); return true; }
		if (name == "trig_srocv_player_on_table") { OnTrigSrocvPlayerOnTable(); return true; }
		if (name == "update_parry") { OnUpdateParry(); return true; }
		if (name == "vampire_off") { OnVampireOff(); return true; }
		if (name == "vampire_suncheck") { OnVampireSuncheck(); return true; }
		if (name == "wearing_armor") { OnWearingArmor(Int(Param(params, 0)), Param(params, 1), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/externals"]
shared class PlayerExternalsScript : DeveloperPlayerExternalsScript, PlayerExternals, BaseVampire
{
	// Variables declared by included files, with the value they start with in this script
	PlayerExternalsScript()
	{
		PLR_COMBAT_ICON = "hud/status/alpha_poison_immune";
		PLR_LCOD_AOE = 90;
		PLR_GCOD_AOE = 180;
		PLR_2HPEN_LIGHT = 0.7f;
		PLR_2HPEN_LIGHT_REPORT = "30%";
		PLR_2HPEN_HEAVY = 0.6f;
		PLR_2HPEN_HEAVY_REPORT = "40%";
		VAMPIRE_MULTI = 0.35f;
		PLR_FAURA_CL_RATE = 10.0f;
		PLR_PAURA_CL_RATE = 30.0f;
		PLR_SFAURA_MP_COST = 2;
		PLR_SFAURA_MAXSIZE = 175;
		PLR_SFAURA_GROWTH_RATE = 2;
		SOUNDSET_HM_SWORDREADY = "player/swordready.wav";
		SOUNDSET_HM_SHOUT1 = "player/shout1.wav";
		SOUNDSET_HM_JAB1 = "player/jab1.wav";
		SOUNDSET_HM_JAB2 = "player/jab2.wav";
		SOUNDSET_HM_BREATHFAST1 = "player/breathe_fast1.wav";
		SOUNDSET_HM_BREATHFAST2 = "player/breathe_fast2.wav";
		SOUNDSET_HM_BREATHFAST3 = "player/breathe_fast3.wav";
		SOUNDSET_HM_DEATH = "player/death.wav";
		SOUNDSET_HM_CHESTHIT1 = "player/chesthit1.wav";
		SOUNDSET_HM_STOMACHHIT1 = "player/stomachhit1.wav";
		SOUNDSET_HM_ARMHIT1 = "player/armhit1.wav";
		SOUNDSET_HM_LEGHIT1 = "player/leghit1.wav";
		SOUNDSET_HM_FALLPAIN1 = "player/fallpain1.wav";
		SOUNDSET_HM_FALLPAIN2 = "player/fallpain2.wav";
		SOUNDSET_HM_FALLPAIN3 = "player/fallpain3.wav";
		SOUNDSET_HM_FALLPAIN4 = "player/fallpain4.wav";
		SOUNDSET_HF_SWORDREADY = "player/Femaleswordready.wav";
		SOUNDSET_HF_SHOUT1 = "player/Femaleshout1.wav";
		SOUNDSET_HF_JAB1 = "player/Femalejab1.wav";
		SOUNDSET_HF_JAB2 = "player/Femalejab2.wav";
		SOUNDSET_HF_BREATHFAST1 = "player/Femalebreathe_fast1.wav";
		SOUNDSET_HF_BREATHFAST2 = "player/Femalebreathe_fast2.wav";
		SOUNDSET_HF_BREATHFAST3 = "player/Femalebreathe_fast3.wav";
		SOUNDSET_HF_DEATH = "player/FemaleDeath.wav";
		SOUNDSET_HF_CHESTHIT1 = "player/Femalechesthit1.wav";
		SOUNDSET_HF_STOMACHHIT1 = "player/Femalestomachhit1.wav";
		SOUNDSET_HF_ARMHIT1 = "player/Femalearmhit1.wav";
		SOUNDSET_HF_LEGHIT1 = "player/Femaleleghit1.wav";
		SOUNDSET_HF_FALLPAIN1 = "player/Femalefallpain1.wav";
		SOUNDSET_HF_FALLPAIN2 = "player/Femalefallpain2.wav";
		SOUNDSET_HF_FALLPAIN3 = "player/Femalefallpain3.wav";
		SOUNDSET_HF_FALLPAIN4 = "player/Femalefallpain4.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("magic/volcano_loop.wav");
		Precache("weapons/polearm_spin.wav");
		Precache("ambience/pulsemachine.wav");
		Precache("ambience/dronemachine1.wav");
		Precache("monsters/bear/c_beardire_bat1.wav");
		Precache("monsters/goblin/sps_fogfire.wav");
		Precache("player/swordready.wav");
		Precache("player/shout1.wav");
		Precache("player/jab1.wav");
		Precache("player/jab2.wav");
		Precache("player/breathe_fast1.wav");
		Precache("player/breathe_fast2.wav");
		Precache("player/breathe_fast3.wav");
		Precache("player/death.wav");
		Precache("player/chesthit1.wav");
		Precache("player/stomachhit1.wav");
		Precache("player/armhit1.wav");
		Precache("player/leghit1.wav");
		Precache("player/fallpain1.wav");
		Precache("player/fallpain2.wav");
		Precache("player/fallpain3.wav");
		Precache("player/fallpain4.wav");
		Precache("player/Femaleswordready.wav");
		Precache("player/Femaleshout1.wav");
		Precache("player/Femalejab1.wav");
		Precache("player/Femalejab2.wav");
		Precache("player/Femalebreathe_fast1.wav");
		Precache("player/Femalebreathe_fast2.wav");
		Precache("player/Femalebreathe_fast3.wav");
		Precache("player/FemaleDeath.wav");
		Precache("player/Femalechesthit1.wav");
		Precache("player/Femalestomachhit1.wav");
		Precache("player/Femalearmhit1.wav");
		Precache("player/Femaleleghit1.wav");
		Precache("player/Femalefallpain1.wav");
		Precache("player/Femalefallpain2.wav");
		Precache("player/Femalefallpain3.wav");
		Precache("player/Femalefallpain4.wav");
		Precache("dwarf/reference.mdl");
		Precache("magic/chant_loop.wav");
		Precache("ambience/rocketrumble1.wav");
		Precache("ambience/alien_powernode.wav");
		Precache("magic/bolt_loop.wav");
		Precache("magic/pulsemachine_noloop.wav");
		Precache("magic/freezeray_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerExternals_DispatchEvent(name, params)
			|| BaseVampire_DispatchEvent(name, params)
			|| DeveloperPlayerExternalsScript::DispatchEvent(name, params);
	}
}
