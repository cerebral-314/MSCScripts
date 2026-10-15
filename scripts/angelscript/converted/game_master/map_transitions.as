#pragma context server

// Converted from game_master/map_transitions.script by msc_transpiler.
// Handles map transitions and systems based on transitioning.
// Handles prep for transitioning to new map
// -Calls appropriate events on players to make sure their flags get set correctly
// -Displays messages relating to map changes

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MapTransitions
{
	// Variables (an unset .script variable reads as its own name)
	string GM_DEST_TRANS = "GM_DEST_TRANS";
	bool GM_DISABLE_TRANSITIONS = false;
	bool GM_CHANGELEVEL = false;
	string DEST_MAP = "DEST_MAP";
	bool VOTE_IN_PROGRESS = false;

	// game_transition_triggered
	// 1: Transition_desc //2: DestBSP //3: local_spawn //4: dest_spawn //called when player activates a transition
	void MapTransitions_OnGameTransitionTriggered(string transDesc = "", string destMap = "", string localSpawn = "", string destSpawn = "")
	{
		GM_DEST_TRANS = destSpawn;

		if (!MapExists(destMap)) // If map doesnt exist yet, display error message
		{
			MessageAll("green", destMap + "  does not exist on this server. Perhaps this is a future transition point?");
		}
		else
		{
			CallExternal("players", "ext_set_map", destMap, localSpawn, GM_DEST_TRANS); // mark map quest data

			if (PlayerCount() > 1)
			{
				string voteTitle = "Travel to " + transDesc + "?";
				string options = "Yes!:" + destMap + ";No!:0"; // Im kinda shocked that this works. It concatenates each value to each other in L_OPTIONS

				CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", options, voteTitle, "Voting begins now!", 0);
			}
			else
			{
				OnGmManualMapChange(destMap);
			}
		}
	}

	// gm_manual_map_change
	// <map> [destspawn]
	void MapTransitions_OnGmManualMapChange(string map = "", string spawnPoint = "")
	{
		if (GM_CHANGELEVEL)
			return;
		GM_DISABLE_TRANSITIONS = true; // tells msarea_transitions to disable code side, so they don't change spawns
		GM_CHANGELEVEL = true;

		DEST_MAP = map;
		string destSpawn = spawnPoint;
		if (destSpawn.isEmpty())
			destSpawn = GM_DEST_TRANS;

		CallExternal("players", "ext_setspawn", destSpawn);

		string cmd = "echo Changelevel: " + DEST_MAP;
		ServerCommand(cmd); // Report changelevel to server

		SetGlobal("G_WEATHER_LOCK", "clear");
		SetGlobal("global.map.weather", "clear;clear;clear");
		SetGlobal("G_OVERRIDE_WEATHER_CODE", "clear;clear;clear");
		SetGlobal("G_CUR_WEATHER", "clear");
		SetGlobal("G_MAP_ADDPARAMS", 0);

		if (Truthy(GetVar("G_SERVER_LOCKED")))
		{
			cmd = "sv_password " + LegacyFunction("quote") + LegacyFunction("quote");
			ServerCommand(cmd);
		}

		if (PlayerCount() > 0)
		{
			CallExternal("players", "ext_changelevel_prep"); // clears weather
		}

		string str = "TRAVELING TO " + DEST_MAP;
		InfoMessage("all", str, "You will be reconnected shortly.");

		VOTE_IN_PROGRESS = false;

		CallEventDelayed(5.0f, "delay_changelevel");
	}

	// game_triggered
	// <map trigger fired>
	void MapTransitions_OnGameTriggered(string triggerName = "")
	{
		DebugPrint("game_triggered " + triggerName);

		if (GM_CHANGELEVEL)
			return;
		if (StartsWith(triggerName, "touch_trans_")) // This is used from invalid spawns. They try to take you back to the start of a gauntlet.
		{
			string mapToVote = LegacyFunction("string_from", triggerName, "touch_trans_");

			string voteTitle = "Change to " + mapToVote + "?"; // Create options for vote menu
			string options = "Yes!:" + mapToVote + ";No!:0";

			CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", options, voteTitle, "Voting begins now!", 0); // Send vote menu
		}
		else if (StartsWith(triggerName, "force_map_"))
		{
			string forcemap = LegacyFunction("string_from", triggerName, "force_map_");
			OnGmManualMapChange(forcemap);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameTransitionTriggered(string transDesc = "", string destMap = "", string localSpawn = "", string destSpawn = "") { MapTransitions_OnGameTransitionTriggered(transDesc, destMap, localSpawn, destSpawn); } // game_transition_triggered
	void OnGmManualMapChange(string map = "", string spawnPoint = "") { MapTransitions_OnGmManualMapChange(map, spawnPoint); } // gm_manual_map_change
	void OnGameTriggered(string triggerName = "") { MapTransitions_OnGameTriggered(triggerName); } // game_triggered

	// This file's events and timers by their .script names
	bool MapTransitions_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_transition_triggered") { OnGameTransitionTriggered(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_triggered") { OnGameTriggered(Param(params, 0)); return true; }
		if (name == "gm_manual_map_change") { OnGmManualMapChange(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "game_master/map_transitions"]
shared class MapTransitionsScript : ScriptEntity, MapTransitions
{
	// Variables every script that includes this file declares
	int BAGS_PER_PLAYER = 0;
	float BAG_COUNT = 0.0f;
	CBaseEntity@ BY_ID = null;
	string CNPCA_PAR1 = "CNPCA_PAR1";
	Vector3 CNPCA_PAR2 = Vector3();
	string CNPCA_PAR3 = "CNPCA_PAR3";
	float CNPCA_PAR4 = 0.0f;
	float CNPCA_PAR5 = 0.0f;
	float CNPCA_PAR6 = 0.0f;
	string CNPCA_PAR7 = "CNPCA_PAR7";
	string CNPCA_PAR8 = "CNPCA_PAR8";
	string CNPCB_PAR1 = "CNPCB_PAR1";
	string CNPCB_PAR2 = "CNPCB_PAR2";
	string CNPCB_PAR3 = "CNPCB_PAR3";
	CBaseEntity@ CNPCB_PAR4 = null;
	float CNPCB_PAR5 = 0.0f;
	float CNPCB_PAR6 = 0.0f;
	string CNPCB_PAR7 = "CNPCB_PAR7";
	string CNPCB_PAR8 = "CNPCB_PAR8";
	string CNPCC_PAR1 = "CNPCC_PAR1";
	string CNPCC_PAR2 = "CNPCC_PAR2";
	string CNPCC_PAR3 = "CNPCC_PAR3";
	CBaseEntity@ CNPCC_PAR4 = null;
	float CNPCC_PAR5 = 0.0f;
	float CNPCC_PAR6 = 0.0f;
	string CNPCC_PAR7 = "CNPCC_PAR7";
	string CNPCC_PAR8 = "CNPCC_PAR8";
	string CNPCD_PAR1 = "CNPCD_PAR1";
	Vector3 CNPCD_PAR2 = Vector3();
	string CNPCD_PAR3 = "CNPCD_PAR3";
	CBaseEntity@ CNPCD_PAR4 = null;
	float CNPCD_PAR5 = 0.0f;
	float CNPCD_PAR6 = 0.0f;
	string CNPCD_PAR7 = "CNPCD_PAR7";
	string CNPCD_PAR8 = "CNPCD_PAR8";
	int CONST_SPAWNS_PER_SET = 0;
	string DEMON_RAGE_USERS = "DEMON_RAGE_USERS";
	string DEMON_RAGE_USES = "DEMON_RAGE_USES";
	string DEV_ID = "DEV_ID";
	string DEV_PLAYER = "DEV_PLAYER";
	bool DQ_DEATH_CALLBACK_ARRAY_CREATED = false;
	string DQ_MONSTER_KILLED_NAME = "DQ_MONSTER_KILLED_NAME";
	Vector3 DQ_MONSTER_KILLED_ORIGIN = Vector3();
	float FD_LOOP_AMT = 0.0f;
	CBaseEntity@ FD_LOOP_TARG = null;
	bool FORGET_SPELL = false;
	string F_DIST = "F_DIST";
	bool GM_APRIL_CHECKING = false;
	bool GM_APRIL_INVALIDATED = false;
	Vector3 GM_APRIL_SPAWN_POINT = Vector3();
	float GM_BTROLLS_DEAD = 0.0f;
	string GM_COUNT_DOWN_EVENT = "GM_COUNT_DOWN_EVENT";
	float GM_COUNT_DOWN_TO = 0.0f;
	string GM_COUNT_MESSAGE = "GM_COUNT_MESSAGE";
	bool GM_DEL_QUE_ACTIVE = false;
	bool GM_DISABLE_SPAWNS = false;
	bool GM_HAD_PLAYER = false;
	bool GM_HANDLE_ACTIVATES = false;
	string GM_HP_TOKENS = "GM_HP_TOKENS";
	string GM_ITEM_NAME = "GM_ITEM_NAME";
	Vector3 GM_ITEM_ORIGIN = Vector3();
	bool GM_ITEM_RESERVE = false;
	CBaseEntity@ GM_ITEM_TARGET = null;
	string GM_ITEM_TO_GIVE = "GM_ITEM_TO_GIVE";
	int GM_LIGHT_PLAYER = 0;
	string GM_MALDORA_LIST = "GM_MALDORA_LIST";
	string GM_NEW_WEATHER = "GM_NEW_WEATHER";
	int GM_N_EPICS = 0;
	bool GM_RACE_ACTIVATE = false;
	float GM_SCRAMBLE_COUNT = 0.0f;
	string GM_SKIP_VOTE_ID = "GM_SKIP_VOTE_ID";
	string GM_SPAWN_POINT = "GM_SPAWN_POINT";
	string GM_SXBOW_RECIEVE = "GM_SXBOW_RECIEVE";
	float GM_TEMP_COUNT = 0.0f;
	string GM_TOTAL_HP = "GM_TOTAL_HP";
	float GM_TOTAL_TRIGGERED = 0.0f;
	string GM_TRIGGER_PREFIX = "GM_TRIGGER_PREFIX";
	bool GM_TRIG_ACTIVATE = false;
	bool GM_TRIG_HP_REQ = false;
	bool GM_TRIG_RACE_REQ = false;
	string GM_TRIG_TARGET = "GM_TRIG_TARGET";
	string GM_TRIG_TOKENS = "GM_TRIG_TOKENS";
	bool GM_VANISH_QUE_ACTIVE = false;
	string GOLD_AMT = "GOLD_AMT";
	string GOLD_POS = "GOLD_POS";
	float G_MAP_UPTIME = 0.0f;
	float G_NGAME_MASTERS = 0.0f;
	Vector3 HOLLOW_ONE_POS = Vector3();
	string ITEM_NAME = "ITEM_NAME";
	Vector3 ITEM_POS = Vector3();
	int LIGHTSYS_N_LIGHTS = 0;
	int LOOP_LIMIT = 0;
	string L_SV_LOCK_PASSWORD = "L_SV_LOCK_PASSWORD";
	string MAGIC_HAND_NAMES1 = "MAGIC_HAND_NAMES1";
	string MAGIC_HAND_NAMES2 = "MAGIC_HAND_NAMES2";
	string MAGIC_HAND_NAMES3 = "MAGIC_HAND_NAMES3";
	string MAGIC_HAND_SCRIPTS1 = "MAGIC_HAND_SCRIPTS1";
	string MAGIC_HAND_SCRIPTS2 = "MAGIC_HAND_SCRIPTS2";
	string MAGIC_HAND_SCRIPTS3 = "MAGIC_HAND_SCRIPTS3";
	bool MAKING_ITEM = false;
	string MALDORA_LIST = "MALDORA_LIST";
	string MENU_TARGET = "MENU_TARGET";
	bool NO_ADMINS_FOUND = false;
	float NO_VOTES = 0.0f;
	CBaseEntity@ NPC_DIED = null;
	float NUM_BAGS = 0.0f;
	float N_MALDORAS = 0.0f;
	float N_SPAWN_POINTS = 0.0f;
	string PLAYER_LIST = "PLAYER_LIST";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool PLR_FOUND_FIRST_STICK = false;
	string POINTS_ILIST = "POINTS_ILIST";
	CBaseEntity@ POTION_ID = null;
	CBaseEntity@ QITEM_CALLER = null;
	string QITEM_NAME = "QITEM_NAME";
	float ROT_STEP = 0.0f;
	float ROT_STEP_SIZE = 0.0f;
	string SHAD_TELEPOINTS = "SHAD_TELEPOINTS";
	string SHAD_TRIGGERS = "SHAD_TRIGGERS";
	int SORC_CUR_TELE_SET = 0;
	string SORC_TELE_SET1 = "SORC_TELE_SET1";
	string SORC_TELE_SET2 = "SORC_TELE_SET2";
	string SORC_TELE_SET3 = "SORC_TELE_SET3";
	int SORC_TELE_SETS = 0;
	string SORTED_TOP_PLAYERS = "SORTED_TOP_PLAYERS";
	string SPAWN_POINTS1 = "SPAWN_POINTS1";
	string SPAWN_POINTS2 = "SPAWN_POINTS2";
	string SPAWN_POINTS3 = "SPAWN_POINTS3";
	string SPAWN_POINTS4 = "SPAWN_POINTS4";
	string SPAWN_POINTS5 = "SPAWN_POINTS5";
	string SPAWN_POINTS6 = "SPAWN_POINTS6";
	string SPAWN_POINTS7 = "SPAWN_POINTS7";
	string SPAWN_POINTS8 = "SPAWN_POINTS8";
	string SPAWN_POINTS9 = "SPAWN_POINTS9";
	string SPAWN_TIME = "SPAWN_TIME";
	CBasePlayer@ SPELL_CASTER = null;
	bool SPELL_ERASE = false;
	bool SPELL_ERASE_CONFIRM = false;
	string SPELL_NAME = "SPELL_NAME";
	int SPELL_TO_FORGET_IDX = 0;
	bool STRONGEST_IDX = false;
	string STRONGEST_PLAYER_LIST = "STRONGEST_PLAYER_LIST";
	bool STRONGEST_STAT_LEVEL = false;
	string THE_CHOSEN_ONE = "THE_CHOSEN_ONE";
	bool THE_CHOSEN_ONE_IDX = false;
	int TOTAL_BALLOTS = 0;
	float TRIGGER_COUNT = 0.0f;
	float VOTES_CASTED = 0.0f;
	float VOTES_REMOVED = 0.0f;
	bool VOTE_BUSY = false;
	string VOTE_DESC = "VOTE_DESC";
	string VOTE_EVENT = "VOTE_EVENT";
	string VOTE_OPTIONS = "VOTE_OPTIONS";
	string VOTE_SILENT = "VOTE_SILENT";
	string VOTE_TALLY = "VOTE_TALLY";
	string VOTE_TITLE = "VOTE_TITLE";
	string VOTE_WINNAR_COUNT = "VOTE_WINNAR_COUNT";
	string VOTE_WINNAR_IDX = "VOTE_WINNAR_IDX";
	string VOTE_WINNERS = "VOTE_WINNERS";
	int VOTE_WINNER_COUNT = 0;
	string WIZARD_CENTER = "WIZARD_CENTER";
	float WORM_COUNT = 0.0f;
	float WORM_GOLD = 0.0f;
	CBaseEntity@ WORM_ID = null;
	string WORM_ITEM = "WORM_ITEM";
	float YES_VOTES = 0.0f;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MapTransitions_DispatchEvent(name, params);
	}
}
