#pragma context server

// Converted from world/server/maps.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Maps
{

	// unnamed block (first think)
	void Maps_FirstThink()
	{
		SetGlobal("MAPS_HIDDEN", "challs;keledrosruins;nashalrath;undermines;underpath;undercliffs");
		SetGlobal("MAPS_MAZE", "goblintown");
		SetGlobal("MAPS_GAUNTLET", "highlands_msc;lostcastle_msc;skycastle;orcplace2_beta;ww2b;ww3d;old_helena;lodagond-2;lodagond-3;lodagond-4;nashalrath;the_wall2");
		SetGlobal("MAPS_GAUNTLET_START", "lowlands;lodagond-1;ww1;the_wall;old_helena;nashalrath");

		SetGlobal("MAPS_UNCONNECTEDS", 2);
		SetGlobal("MAPS_UNCONNECTED1", "ms_quest;char_recover;guildmaster;cleicert;foutpost;lodagond-1;island1;lostcaverns;ms_underworldv2;orc_arena;pvp_archery;pvp_arena;unrest;unrest2;unrest2_beta1;ww1;pvp_canyons;canyons;ocean_crossing;smugglers_cove;isles_dread1;");
		SetGlobal("MAPS_UNCONNECTED2", "kfortress;gertenheld_cave;islesofdread2_old;the_wall;catacombs;bloodshrine;ms_soccer;shender_east;nightmare_edana;m2_quest;gertenhell");

		SetGlobal("G_NOT_ON_FN", "test_scripts");

		// ======== Gauntlet Map Array
		if (GetGlobalArrayCount("G_ARRAY_RMAPS") == -1)
		{
			GlobalArrayCreate("G_ARRAY_RMAPS");
			GlobalArrayCreate("G_ARRAY_RMAPS_TYPES");
			GlobalArrayCreate("G_ARRAY_RMAPS_CONNECTORS");

			GlobalArrayAdd("G_ARRAY_RMAPS", "highlands_msc");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lowlands;Curse of the Bear Gods");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lostcastle_msc;lowlands");

			GlobalArrayAdd("G_ARRAY_RMAPS", "lostcastle_msc");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lowlands");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "highlands_msc;skycastle;orcplace2_beta");

			GlobalArrayAdd("G_ARRAY_RMAPS", "skycastle");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lowlands;Curse of the Bear Gods");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lostcastle_msc");

			GlobalArrayAdd("G_ARRAY_RMAPS", "orcplace2_beta");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lowlands;Curse of the Bear Gods");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lostcastle_msc");

			GlobalArrayAdd("G_ARRAY_RMAPS", "ww2b");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;ww1;World Walker");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "ww1");

			GlobalArrayAdd("G_ARRAY_RMAPS", "ww3d");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;ww1;World Walker");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "ww2b");

			GlobalArrayAdd("G_ARRAY_RMAPS", "old_helena");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "helena");

			GlobalArrayAdd("G_ARRAY_RMAPS", "lodagond-2");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lodagond-1;The Lodagond Skyfortress");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lodagond-1");

			GlobalArrayAdd("G_ARRAY_RMAPS", "lodagond-3");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lodagond-1;The Lodagond Skyfortress");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lodagond-2");

			GlobalArrayAdd("G_ARRAY_RMAPS", "lodagond-4");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;lodagond-1;The Lodagond Skyfortress");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "lodagond-3");

			GlobalArrayAdd("G_ARRAY_RMAPS", "challs");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "sfor;ms_wicardoven");

			GlobalArrayAdd("G_ARRAY_RMAPS", "keledrosruins");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "keledrosprelude2");

			GlobalArrayAdd("G_ARRAY_RMAPS", "nashalrath");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "daragoth");

			GlobalArrayAdd("G_ARRAY_RMAPS", "goblintown");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "mscave");

			GlobalArrayAdd("G_ARRAY_RMAPS", "the_wall2");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "series;the_wall;The Wall (West)");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "the_wall;fcaverns");

			GlobalArrayAdd("G_ARRAY_RMAPS", "undermines");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "underpath;underkeep;undercrypt");

			GlobalArrayAdd("G_ARRAY_RMAPS", "underpath");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "undercliffs;gatecity;undercaves;undermines;underkeep;understream");

			GlobalArrayAdd("G_ARRAY_RMAPS", "undercliffs");
			GlobalArrayAdd("G_ARRAY_RMAPS_TYPES", "hidden");
			GlobalArrayAdd("G_ARRAY_RMAPS_CONNECTORS", "underpath;underkeep;bloodrose");
		}
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/maps"]
shared class MapsScript : ScriptEntity, Maps
{
	// Variables every script that includes this file declares
	string BETA_TIMESTAMP = "BETA_TIMESTAMP";
	CBaseEntity@ CALLING_PLAYER = null;
	bool CAN_VOTE = false;
	string CREST_SELECTION = "CREST_SELECTION";
	float CUSTOM_COUNT = 0.0f;
	float FREQ_WEATHER = 0.0f;
	bool HIGH_IDX = false;
	bool HIGH_SCORE = false;
	string LEADING_GUILDS = "LEADING_GUILDS";
	float LISTMAPS_COUNT = 0.0f;
	string LISTMAPS_MSG_EPC = "LISTMAPS_MSG_EPC";
	string LISTMAPS_MSG_HAR = "LISTMAPS_MSG_HAR";
	string LISTMAPS_MSG_LOW = "LISTMAPS_MSG_LOW";
	string LISTMAPS_MSG_MED = "LISTMAPS_MSG_MED";
	string LISTMAPS_MSG_VHR = "LISTMAPS_MSG_VHR";
	string LISTMAPS_START = "LISTMAPS_START";
	string LISTMAPS_STOP = "LISTMAPS_STOP";
	string LISTMAPS_TARGET = "LISTMAPS_TARGET";
	string LTNG_SND = "LTNG_SND";
	CBaseEntity@ L_VOTE_CALLER = null;
	int MAP_VOTE_DELAY = 0;
	string POINTS_NLIST = "POINTS_NLIST";
	string POINTS_PLIST = "POINTS_PLIST";
	string POINTS_TNLIST = "POINTS_TNLIST";
	string POINTS_TPLIST = "POINTS_TPLIST";
	string RESIST_NAMES = "RESIST_NAMES";
	string RESIST_VALUES = "RESIST_VALUES";
	string SCRIPT_SFX1 = "SCRIPT_SFX1";
	string SOUND_RAIN = "SOUND_RAIN";
	string SPRITE_MIST = "SPRITE_MIST";
	string SPRITE_RIPPLE = "SPRITE_RIPPLE";
	string SPRITE_SPLASH = "SPRITE_SPLASH";
	string TEST_PLR = "TEST_PLR";
	bool TIMESET_DELAY = false;
	int TIME_UPDATE_INTERVAL = 0;
	string TIP_TEXT = "TIP_TEXT";
	bool WARNED_DRIDJE = false;
	bool WEATHERSET_DELAY = false;
	string WEATHER_SPRITE = "WEATHER_SPRITE";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Maps_FirstThink();
	}
}
