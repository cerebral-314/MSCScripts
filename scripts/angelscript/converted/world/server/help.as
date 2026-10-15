#pragma context server

// Converted from world/server/help.script by msc_transpiler.
// Includes functionality relating to displaying help information for players

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Help
{
	// Variables (an unset .script variable reads as its own name)
	string LISTMAPS_MSG_LOW = "LISTMAPS_MSG_LOW";
	string LISTMAPS_MSG_MED = "LISTMAPS_MSG_MED";
	string LISTMAPS_MSG_HAR = "LISTMAPS_MSG_HAR";
	string LISTMAPS_MSG_VHR = "LISTMAPS_MSG_VHR";
	string LISTMAPS_MSG_EPC = "LISTMAPS_MSG_EPC";
	string LISTMAPS_START = "LISTMAPS_START";
	string LISTMAPS_STOP = "LISTMAPS_STOP";
	string LISTMAPS_TARGET = "LISTMAPS_TARGET";
	float LISTMAPS_COUNT = 0.0f;
	float CUSTOM_COUNT = 0.0f;

	// unnamed block (first think)
	void Help_FirstThink()
	{
		// map list by difficulty
		// consider moving to book function
		LISTMAPS_MSG_LOW = "=========== Low level maps (up to ~200hp) ===========";
		LISTMAPS_MSG_MED = "=========== Medium level maps (~150hp-600hp) ===========";
		LISTMAPS_MSG_HAR = "=========== Hard level maps (~600hp-1000hp) ===========";
		LISTMAPS_MSG_VHR = "=========== Very Hard level maps (~1000hp-1500hp) ===========";
		LISTMAPS_MSG_EPC = "=========== Epic level maps (>1500hp + Apostle) ===========";

		ArrayCreate("ARRAY_MAPLIST_LOW");
		ArrayAdd("ARRAY_MAPLIST_LOW", "deralia (safe)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "edana (safe)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "ms_town (safe)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "helena (safe, except during raids, where it can self-adjust up to medium)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "ms_quest (almost safe)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "msc_tutorial (can technically complete without combat)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "edanasewers");
		ArrayAdd("ARRAY_MAPLIST_LOW", "thornlands (spitting spiders can be a bit mean)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "ms_caves (empty, save for a thornlands boss spider)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "gertenheld_cape");
		ArrayAdd("ARRAY_MAPLIST_LOW", "chapel (beware under the church floorboards)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "mines");
		ArrayAdd("ARRAY_MAPLIST_LOW", "ms_swamp (empty, save for a few skeletons)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "challs");
		ArrayAdd("ARRAY_MAPLIST_LOW", "goblintown (hidden)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "island1");
		ArrayAdd("ARRAY_MAPLIST_LOW", "m2_quest");
		ArrayAdd("ARRAY_MAPLIST_LOW", "gertenheld_forest (beware of goblin cheif)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "heras (beware of lobbing troll)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "sfor (up to glowing slime forest area)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "gatecity (above dzombie area) (hidden)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "mscave (beware fire shamans)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "isle (beware lobbing trolls and hidden brawler)");
		ArrayAdd("ARRAY_MAPLIST_LOW", "lowlands (start of 'Curse of the Bear Gods' series)");

		ArrayCreate("ARRAY_MAPLIST_MEDIUM");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "keledrosprelude2 (Beware the Ice Troll)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "orcplace2_beta ('Curse of the Bear Gods', starts at lowlands)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "smugglers_cove");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "daragoth (beware trolls)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "sfor (beyond slime forest area)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "orc_for (self-adjusted low)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ms_underworldv2 (crappy throw-back map)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ww1 (Start of 'World Walker' series)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ww2b ('World Walker', starts at ww1)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "keledrosruins (hidden)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "unrest");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "unrest2_beta1");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "calruin2");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "highlands_msc ('Curse of the Bear Gods', starts at lowlands)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "lostcastle_msc ('Curse of the Bear Gods', starts at lowlands)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "keledrosprelude2 (Ice Troll Battle)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "b_castle");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "gatecity (dzombie area) (hidden)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "lostcaverns");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ara (long siege is long)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "bloodrose (up through Slithar)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "Cleicert");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ww3d ('World Walker', starts at ww1)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "idemarks_tower");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "skycastle ('Curse of the Bear Gods', starts at lowlands)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "demontemple");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "the_keep (random final boss maybe mean though)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ms_snow");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "foutpost");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "oceancrossing");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "ms_wicardoven");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "islesofdread1");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "islesofdread2_old");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "nightmare_edana (self-adjusts medium-hard)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "catacombs (self-adjusts medium-hard)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "dragooncaves");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "islesofdread2");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "bloodrose (after Slithar)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "underpath (self adjusted low)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "undermines", "(self", "adjusted", "low)\"");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "thanatos");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "lodagond-2 ('Lodagond' series, starts at Lodagond-1)");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "nightmare_thornlands");
		ArrayAdd("ARRAY_MAPLIST_MEDIUM", "phobia (beware final boss)");

		ArrayCreate("ARRAY_MAPLIST_HARD");
		ArrayAdd("ARRAY_MAPLIST_HARD", "aleyesu");
		ArrayAdd("ARRAY_MAPLIST_HARD", "lodagond-3 ('Lodagond' series, starts at Lodagond-1)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "old_helena");
		ArrayAdd("ARRAY_MAPLIST_HARD", "aluhandra2");
		ArrayAdd("ARRAY_MAPLIST_HARD", "gertenheld_cave");
		ArrayAdd("ARRAY_MAPLIST_HARD", "lodagond-1 (start of 'Lodagond' series)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "deraliasewers");
		ArrayAdd("ARRAY_MAPLIST_HARD", "catacombs (self-adjusts medium-hard)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "tundra");
		ArrayAdd("ARRAY_MAPLIST_HARD", "umulak");
		ArrayAdd("ARRAY_MAPLIST_HARD", "kfortress");
		ArrayAdd("ARRAY_MAPLIST_HARD", "gertenhell");
		ArrayAdd("ARRAY_MAPLIST_HARD", "orc_for (self-adjusted high)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "lodagond-4 ('Lodagond' series, starts at Lodagond-1)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "undercliffs (self adjusted low)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "underpath (self adjusted high)");
		ArrayAdd("ARRAY_MAPLIST_HARD", "sorc_villa (though safe, in some conditions)");

		ArrayCreate("ARRAY_MAPLIST_VHARD");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "shad_palace");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "bloodshrine");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "undermines (self adjusted high)");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "shender_east (self-adjusted min)");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "hunderswamp_north");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "the_wall");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "the_wall2");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "phlames");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "undercliffs (self adjusted high)");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "nashalrath (hidden)");
		ArrayAdd("ARRAY_MAPLIST_VHARD", "shender_east (self-adjusted max, nightmare battle self-adjusts near-epic)");

		ArrayCreate("ARRAY_MAPLIST_EPIC");
		ArrayAdd("ARRAY_MAPLIST_EPIC", "(none available as of yet)");
	}

	// game_playercmd
	void Help_OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		bool listingCustom = false;

		if (command == "listmaps")
		{
			// dbg listmaps LISTMAPS_TARGET
			if (LISTMAPS_TARGET != "LISTMAPS_TARGET" && LISTMAPS_TARGET != EntityId(EntityOf(ENT_CURRENTPLAYER)))
				ConsoleMessage(ENT_CURRENTPLAYER, "One moment, listmaps system is helping " + NameOf(LISTMAPS_TARGET));
			if (argument.isEmpty())
			{
				float hp = MaxHealthOf(ENT_CURRENTPLAYER);
				if (hp <= 150.0f)
				{
					LISTMAPS_START = "low";
					LISTMAPS_STOP = "low";
				}
				else if (hp > 150.0f)
				{
					if (hp > 200.0f)
					{
						LISTMAPS_START = "low";
						LISTMAPS_STOP = "medium";
					}
					if (hp >= 600.0f)
					{
						LISTMAPS_START = "hard";
						LISTMAPS_STOP = "hard";
					}
					if (hp >= 800.0f)
					{
						LISTMAPS_START = "hard";
						LISTMAPS_STOP = "vhard";
					}
					if (hp >= 1500.0f)
					{
						LISTMAPS_START = "vhard";
						LISTMAPS_STOP = "epic";
					}
				}
				listingCustom = true;
				ConsoleMessage(ENT_CURRENTPLAYER, "Listing maps recommended for your character level: " + LISTMAPS_START + " to " + LISTMAPS_STOP);
				ConsoleMessage(ENT_CURRENTPLAYER, "To list more maps, try listmaps [difficulty] or listmaps all");
			}
			else
			{
				LISTMAPS_START = "none";
				LISTMAPS_STOP = "none";
				if (argument == "low")
				{
					LISTMAPS_START = "low";
					LISTMAPS_STOP = "low";
				}
				if (argument == "medium")
				{
					LISTMAPS_START = "medium";
					LISTMAPS_STOP = "medium";
				}
				if (argument == "hard")
				{
					LISTMAPS_START = "hard";
					LISTMAPS_STOP = "hard";
				}
				if (argument == "vhard")
				{
					LISTMAPS_START = "vhard";
					LISTMAPS_STOP = "vhard";
				}
				if (argument == "epic")
				{
					LISTMAPS_START = "epic";
					LISTMAPS_STOP = "epic";
				}
				if (argument == "all")
				{
					LISTMAPS_START = "low";
					LISTMAPS_STOP = "epic";
				}
			}

			if (LISTMAPS_START != "none")
			{
				if (!listingCustom)
				{
					if (argument != "all")
						ConsoleMessage(ENT_CURRENTPLAYER, "Listing maps recomended for " + LISTMAPS_START + " levels");
					else
						ConsoleMessage(ENT_CURRENTPLAYER, "Listing all maps by difficulty");
				}
				LISTMAPS_TARGET = EntityId(EntityOf(ENT_CURRENTPLAYER));
				OnDoListmaps();
			}
			else
			{
				LISTMAPS_TARGET = "LISTMAPS_TARGET";
				ConsoleMessage(ENT_CURRENTPLAYER, "listmaps, unrecognized parameter: " + argument);
				ConsoleMessage(ENT_CURRENTPLAYER, "listmaps [low|medium|hard|vhard|epic|all]");
			}
		}
		else if (command == "summon_help")
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "SUMMON CHAT COMMANDS");
			ConsoleMessage(ENT_CURRENTPLAYER, "follow - disengage and follow you");
			ConsoleMessage(ENT_CURRENTPLAYER, "defend - stay near, engage nearby enemies");
			ConsoleMessage(ENT_CURRENTPLAYER, "kill - attack your current target");
			ConsoleMessage(ENT_CURRENTPLAYER, "hunt - roam away and attack any enemies");
			ConsoleMessage(ENT_CURRENTPLAYER, "vanish - unsummon");
			ConsoleMessage(ENT_CURRENTPLAYER, "stay - guard position");
			ConsoleMessage(ENT_CURRENTPLAYER, "* Prefix any of the above commands with all [command] to affect all your summons");
			return;
		}
		else if (command == "mapinfo")
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "Map Title: " + Eval("game.map.title"));
			ConsoleMessage(ENT_CURRENTPLAYER, "Map Desc: " + Eval("game.map.desc"));
			ConsoleMessage(ENT_CURRENTPLAYER, "HPWarn: " + Eval("game.map.hpwarn"));
			ConsoleMessage(ENT_CURRENTPLAYER, "Weather: " + Eval("game.map.weather"));
			return;
		}
	}

	// do_listmaps
	void Help_OnDoListmaps()
	{
		LISTMAPS_COUNT = 0.0f;
		if (LISTMAPS_START == "low")
		{
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_LOW);
			CallEventDelayed(0.1f, "do_listmaps_low");
		}
		if (LISTMAPS_START == "medium")
		{
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_MED);
			CallEventDelayed(0.1f, "do_listmaps_medium");
		}
		if (LISTMAPS_START == "hard")
		{
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_HAR);
			CallEventDelayed(0.1f, "do_listmaps_hard");
		}
		if (LISTMAPS_START == "vhard")
		{
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_VHR);
			CallEventDelayed(0.1f, "do_listmaps_vhard");
		}
		if (LISTMAPS_START == "epic")
		{
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_EPC);
			CallEventDelayed(0.1f, "do_listmaps_epic");
		}
	}

	// do_listmaps_low
	void Help_OnDoListmapsLow()
	{
		if (!(LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_LOW")))
			return;

		ConsoleMessage(LISTMAPS_TARGET, GetArray("ARRAY_MAPLIST_LOW", Text(LISTMAPS_COUNT)));
		LISTMAPS_COUNT += 1.0f;

		if (LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_LOW"))
		{
			CallEventDelayed(0.1f, "do_listmaps_low");
		}
		else if (LISTMAPS_STOP != "low")
		{
			LISTMAPS_COUNT = 0.0f;
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_MED);
			OnDoListmapsMedium();
		}
		else
		{
			LISTMAPS_TARGET = "LISTMAPS_TARGET";
		}
	}

	// do_listmaps_medium
	void Help_OnDoListmapsMedium()
	{
		if (!(LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_MEDIUM")))
			return;

		ConsoleMessage(LISTMAPS_TARGET, GetArray("ARRAY_MAPLIST_MEDIUM", Text(LISTMAPS_COUNT)));
		LISTMAPS_COUNT += 1.0f;

		if (LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_MEDIUM"))
		{
			CallEventDelayed(0.1f, "do_listmaps_medium");
		}
		else if (LISTMAPS_STOP != "medium")
		{
			LISTMAPS_COUNT = 0.0f;
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_HAR);
			OnDoListmapsHard();
		}
		else
		{
			LISTMAPS_TARGET = "LISTMAPS_TARGET";
		}
	}

	// do_listmaps_hard
	void Help_OnDoListmapsHard()
	{
		if (!(LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_HARD")))
			return;

		ConsoleMessage(LISTMAPS_TARGET, GetArray("ARRAY_MAPLIST_HARD", Text(LISTMAPS_COUNT)));
		LISTMAPS_COUNT += 1.0f;

		if (LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_HARD"))
		{
			CallEventDelayed(0.1f, "do_listmaps_hard");
		}
		else if (LISTMAPS_STOP != "hard")
		{
			LISTMAPS_COUNT = 0.0f;
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_VHR);
			OnDoListmapsVhard();
		}
		else
		{
			LISTMAPS_TARGET = "LISTMAPS_TARGET";
		}
	}

	// do_listmaps_vhard
	void Help_OnDoListmapsVhard()
	{
		if (!(LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_VHARD")))
			return;

		ConsoleMessage(LISTMAPS_TARGET, GetArray("ARRAY_MAPLIST_VHARD", Text(LISTMAPS_COUNT)));
		LISTMAPS_COUNT += 1.0f;

		if (LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_VHARD"))
		{
			CallEventDelayed(0.1f, "do_listmaps_vhard");
		}
		else if (LISTMAPS_STOP != "vhard")
		{
			LISTMAPS_COUNT = 0.0f;
			ConsoleMessage(LISTMAPS_TARGET, LISTMAPS_MSG_EPC);
			OnDoListmapsEpic();
		}
		else
		{
			LISTMAPS_TARGET = "LISTMAPS_TARGET";
		}
	}

	// do_listmaps_epic
	void Help_OnDoListmapsEpic()
	{
		if (!(LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_EPIC")))
			return;

		ConsoleMessage(LISTMAPS_TARGET, GetArray("ARRAY_MAPLIST_EPIC", Text(LISTMAPS_COUNT)));
		LISTMAPS_COUNT += 1.0f;

		if (LISTMAPS_COUNT < GetArrayCount("ARRAY_MAPLIST_EPIC"))
			CallEventDelayed(0.1f, "do_listmaps_epic");
		else
			LISTMAPS_TARGET = "LISTMAPS_TARGET";
	}

	// list_custom_maps2
	void Help_OnListCustomMaps2()
	{
		float totalMaps = GetTokenCount(GetVar("MAPS_UNCONNECTED2")) - 1.0f;
		// if ( CUSTOM_COUNT == TOTAL_MAPS )
		// {
		// if MAPS_UNCONNECTEDS > 2
		// setvard CUSTOM_COUNT 0
		// callevent 0.1 list_custom_maps3
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		if (!(CUSTOM_COUNT <= totalMaps))
			return;
		string custMap = GetToken(GetVar("MAPS_UNCONNECTED2"), int(CUSTOM_COUNT));
		if (MapExists(custMap))
			ConsoleMessage(L_VOTE_CALLER, custMap);
		if (CUSTOM_COUNT == totalMaps)
		{
			ConsoleMessage(L_VOTE_CALLER, "===================================");
			ConsoleMessage(L_VOTE_CALLER, "Type listmaps for a listing of maps by difficulty");
			ConsoleMessage(L_VOTE_CALLER, "Or type maps * for a listing of all maps on your client");
		}
		CUSTOM_COUNT += 1.0f;
		CallEventDelayed(0.1f, "list_custom_maps2");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "") { Help_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); } // game_playercmd
	void OnDoListmaps() { Help_OnDoListmaps(); } // do_listmaps
	void OnDoListmapsLow() { Help_OnDoListmapsLow(); } // do_listmaps_low
	void OnDoListmapsMedium() { Help_OnDoListmapsMedium(); } // do_listmaps_medium
	void OnDoListmapsHard() { Help_OnDoListmapsHard(); } // do_listmaps_hard
	void OnDoListmapsVhard() { Help_OnDoListmapsVhard(); } // do_listmaps_vhard
	void OnDoListmapsEpic() { Help_OnDoListmapsEpic(); } // do_listmaps_epic
	void OnListCustomMaps2() { Help_OnListCustomMaps2(); } // list_custom_maps2

	// This file's events and timers by their .script names
	bool Help_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_listmaps") { OnDoListmaps(); return true; }
		if (name == "do_listmaps_epic") { OnDoListmapsEpic(); return true; }
		if (name == "do_listmaps_hard") { OnDoListmapsHard(); return true; }
		if (name == "do_listmaps_low") { OnDoListmapsLow(); return true; }
		if (name == "do_listmaps_medium") { OnDoListmapsMedium(); return true; }
		if (name == "do_listmaps_vhard") { OnDoListmapsVhard(); return true; }
		if (name == "game_playercmd") { OnGamePlayercmd(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "list_custom_maps2") { OnListCustomMaps2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/help"]
shared class HelpScript : ScriptEntity, Help
{
	// Variables every script that includes this file declares
	string BETA_TIMESTAMP = "BETA_TIMESTAMP";
	CBaseEntity@ CALLING_PLAYER = null;
	bool CAN_VOTE = false;
	string CREST_SELECTION = "CREST_SELECTION";
	float FREQ_WEATHER = 0.0f;
	bool HIGH_IDX = false;
	bool HIGH_SCORE = false;
	string LEADING_GUILDS = "LEADING_GUILDS";
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
		Help_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Help_DispatchEvent(name, params);
	}
}
