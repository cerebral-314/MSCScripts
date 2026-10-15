#pragma context server

// Converted from global/sv_globals.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SvGlobals
{

	// unnamed block (first think)
	void SvGlobals_FirstThink()
	{
		SetGlobal("NO_ADVANCED_SEARCHES", 0);
		SetGlobal("G_VALID_SPAWN", 0);

		// reset globals
		// spam control
		SetGlobal("MAX_SUMMONS", 10);
		SetGlobal("CURRENT_SUMMONS", 0);
		SetGlobal("global.map.weather", "clear;clear;clear"); // FEB2009_17 - default to clear weather
		SetGlobal("G_OVERRIDE_WEATHER_CODE", 0); // NOV2009_07 - Weather issues
		SetGlobal("G_NO_STEP_ADJ", 0); // no step size adjustment for monsters on this map when set 1
		SetGlobal("G_HELP_ON", 0); // help mode on
		SetGlobal("G_CRITICAL_NPCS", ""); // n of critical NPCs on siege map
		SetGlobal("G_SIEGE_MAP", "G_SIEGE_MAP"); // map in siege mode
		SetGlobal("G_FORCE_SPAWN_WEATHER", "G_FORCE_SPAWN_WEATHER"); // ms_underworldv2 is the only one to use this.
		SetGlobal("G_EXP_MULTI", 1.0f); // global experience multiplier - set to 1.0 to enable XP multi for dmgmulti/hpmulti monsters
		SetGlobal("G_NO_DROP", 0); // no drop treasure
		SetGlobal("G_UNDAMAEL_VULNERABLE", 0); // undamael vulnerability flag when quest done proper
		SetGlobal("G_SHAD_PRESENT", 0); // shaddahr present to convert orcs to zombies?
		SetGlobal("G_SORC_NEXT_TELE", 0); // AUG2009 - time to next allowed sorc teleport
		SetGlobal("G_MUMMY_NEXT_REBIRTH", 0); // SEP2009 - next time a mummy pinned by a dead comerade can rebirth
		SetGlobal("G_SKELE_NEXT_REBIRTH", 0); // SEP2009_14 - next time a skeleton (archer) pinned by a dead comerade can rebirth
		SetGlobal("G_GUARDIAN_CHARGER", "G_GUARDIAN_CHARGER"); // NOV2009_07 - mark position for guardian charger (see monsters/guardian_iron [_charger])
		SetGlobal("G_SORC_TELE_POINTS", 0); // DEC2009_10 - sorc teleporter system - number of teleporters
		SetGlobal("G_SORC_CHIEF_PRESENT", 0); // JAN2010_01 - sorc chief present flag for sorc_palace
		SetGlobal("G_TELF_ESCORTS", 0); // JAN2010_01 - torkie escort counter for the_wall
		SetGlobal("G_ONE_SHOT", 0); // JAN2010_10 - shad palace talk counter
		SetGlobal("G_WEATHER_LOCK", 0); // JAN2010 - allow weather to be locked (monster blackness, for instance)
		SetGlobal("G_NPC_COMBAT_MAP", 0); // FEB2010_06 - used to flag a map with heavy NPC vs NPC fighting - causes all NPCs to cycle full when in combat with one another, as if their opponents were players
		SetGlobal("G_TELF_LEADER_COUNTER", 0); // FEB2010_10 - for the_wall
		SetGlobal("G_CURRENT_WEATHER", 0); // NOV2010_28 holds current weather type
		SetGlobal("G_TRACK_DEATHS", 0); // DEC2010_03 track monster deaths for challenges
		SetGlobal("G_TRACK_DEATHS_TRIGGER", 0); // level at which to trigger next stage of challenge
		SetGlobal("G_TRACK_DEATHS_EVENT", 0); // GM event to call when achievement level reached
		SetGlobal("G_SERVER_LOCKED", 0); // votelock flag
		SetGlobal("G_SADJ_DEATHS", 0); // self-adjusting death tracker (#killed)
		SetGlobal("G_SADJ_LEVELS", 0); // self-adjusting death tracker (total levels)
		SetGlobal("G_GAVE_TOME1", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME2", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME3", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME4", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME5", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME6", 0); // treasure tracker
		SetGlobal("G_GAVE_TOME7", 0); // treasure tracker
		SetGlobal("G_GAVE_ARTI1", 0); // treasure tracker
		SetGlobal("G_LAST_GABE_TARGET", 0); // for the gabe gag
		SetGlobal("G_APRIL_FOOLS_MODE", 0); // ditto
		SetGlobal("G_DEVELOPER_MODE", 0); // reset dev mode, just in case
		SetGlobal("G_TRACK_HP", 0); // set to 1 track average player HP on the server with each kill
		SetGlobal("G_TRACK_KILLS", 0);
		SetGlobal("G_LAST_VICTORY", 0); // for victory sounds, so not all monsters make the same chear at once
		SetGlobal("G_NPC_SUMMON_COUNT", 0); // tracks summons for some npcs
		SetGlobal("G_FLAMES_EAGLES", 0); // tracks eagles on phlames map (stops vines from spawning while they are about)
		SetGlobal("G_ALERT_CYCLE", 0); // stops some monsters from using the same alert anim/sound at same time
		SetGlobal("G_SPECIAL_COMMANDS", 0); // special commands for special maps
		SetGlobal("G_CHEST_TRACKER", 0); // for number of self-adjust chests found on a map

		// donator list
		if (GetGlobalArrayCount("G_ARRAY_DONATORS") == -1)
		{
			GlobalArrayCreate("G_ARRAY_DONATORS");
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:452876"); // Thothie
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:1339151"); // Hush 2.0
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:15435276"); // Echo 717
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:5168669"); // Shaftinthecity
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:4985228"); // Dridje
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:838591"); // lafingman0
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:17717134"); // Lucifer Majiskus
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:1184501"); // Older than Dirt
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:23328455"); // Meru
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:20479631"); // Phosphorcracker
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:8122893"); // DarkFox
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:10951502"); // Jonzay
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:33635060"); // Malachite
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:11447863"); // zeus9860
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:12864684"); // Tetsmega1
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:5900395"); // Kanta
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:13564511"); // ShadowGrrl
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:20630963"); // Rex
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:7019991"); // Bernt
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:69835"); // Kuroneko
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:3937474"); // Irish Fog
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:0:20470108"); // Aze-M
			GlobalArrayAdd("G_ARRAY_DONATORS", "STEAM_0:1:2142322"); // FaLco
		}

		// Guild leader list
		if (GetGlobalArrayCount("ARRAY_CRESTS") == -1) // array is not initialized
		{
			GlobalArrayCreate("ARRAY_CRESTS");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_crow");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_cwog");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_darktide");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_forestcroth");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_hov");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_pirates");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_torkalath");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_valor");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_wildfire");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_bou");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_gag");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_fmu");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_yoku");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_rip");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_gow");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_crew");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_wario");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_tfl");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_justice");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_revenge");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_socialist");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_pos");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_barnum");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_fellowship");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_hod");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_tdk");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_torkie");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_cloak_blue");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_neko");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_wotn");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_w_2");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_sor");
			GlobalArrayAdd("ARRAY_CRESTS", "crest_noclicky");

			GlobalArrayCreate("ARRAY_CREST_OWNERS");
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_crow
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_cwog
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_darktide
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_forestcr
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_hov
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:11447863"); // crest_pirates
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_torkalat
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_valor
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_wildfire
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:759168"); // crest_bou
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_gag
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_fmu
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_yoku
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:7087443"); // crest_rip
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_gow
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_crew
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_wario
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_tfl
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_justice
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_revenge
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:1679220"); // crest_socialis
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_pos
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_barnum
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_fellowsh
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:0:5003092"); // crest_hod
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:3695755;STEAM_0:0:3686251"); // crest_tdk
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_torkie
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "none"); // crest_cloak_blue
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:0:69835"); // crest_neko
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:8122893"); // crest_wotn
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:1:7087443"); // crest_w_2
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:0:5900395"); // crest_sor
			GlobalArrayAdd("ARRAY_CREST_OWNERS", "STEAM_0:0:10987306"); // crest_noclicky
		}

		if (GetGlobalArrayCount("G_ARRAY_DEVELOPERS") == -1) // Developer list (for rgb halos)
		{
			GlobalArrayCreate("G_ARRAY_DEVELOPERS");
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:3967789"); // Dehoth
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:19627420"); // Furion
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:0:5003092"); // Wish
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:8122893"); // Dark
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:4985228"); // Dridje
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:1955506"); // Jody
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:0:58762201"); // Kimmy
			GlobalArrayAdd("G_ARRAY_DEVELOPERS", "STEAM_0:1:2822032"); // Dravus
		}

		SetGlobal("G_TROLLCANO_OWNERS", "STEAM_0:0:19648837;STEAM_0:1:8122893"); // Keldorn, Dark Fox
		SetGlobal("G_DEVSTAFF_OWNERS", "STEAM_0:1:4985228;STEAM_0:1:8122893;STEAM_0:0:5003092;STEAM_0:0:20630963;");
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "global/sv_globals"]
shared class SvGlobalsScript : ScriptEntity, SvGlobals
{
	// Variables every script that includes this file declares
	string CUR_ITEM = "CUR_ITEM";
	string LOAD_ITEMS = "LOAD_ITEMS";
	int SK_LVL1_MIN = 0;
	int SK_LVL2_MIN = 0;
	int TITLE_MINSKILL = 0;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SvGlobals_FirstThink();
	}
}
