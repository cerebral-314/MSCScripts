#pragma context server

// Converted from world.script by msc_transpiler.
// Manages the game world
// Useful for controlling ongoing global events
// Loaded by the dll on Client and Server
// BEWARE
// - Any parsing errors in this file or its includes will STOP MSC FROM LOADING
// - and will not return ANY ERROR in the dll logs

#include "runtime/ScriptEntity.as"
#include "converted/beta_date.as"
#include "converted/world/sv_world.as"
#include "converted/world/server/commands.as"
#include "converted/world/server/time.as"
#include "converted/world/server/time_vote.as"
#include "converted/world/server/player_vote.as"
#include "converted/world/server/help.as"
#include "converted/world/server/maps.as"
// #include $currentmapscript - not found (optional)

[script "world"]
class World : CommandsScript, BetaDate, SvWorld, Time, TimeVote, PlayerVote, Help, Maps
{
	// Variables declared by included files, with the value they start with in this script
	World()
	{
		BETA_TIMESTAMP = "CANARY: Mon 10/12/2026 16:26:05.47"; // from beta_date
		TIME_UPDATE_INTERVAL = 30; // from world/server/time
	}

	// unnamed block (first think)
	void World_FirstThink()
	{
		// this name_uniq does not register proper
		// this entity cannot be called to post spawn
		// but rather runs once at map start
		// - see game_master for a universal script that be used post-game spawn
		SetUniqueName("msworld");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SvWorld_OnGameSpawn(playerRace, playerGender); // world/sv_world
		Time_OnGameSpawn(playerRace, playerGender); // world/server/time
	}

	// game_playerjoin
	void OnGamePlayerjoin(CBasePlayer@ player = null)
	{
		SvWorld_OnGamePlayerjoin(player); // world/sv_world
		Time_OnGamePlayerjoin(player); // world/server/time
	}

	// game_playercmd
	void OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		Devcmds_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); // developer/devcmds
		Commands_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); // world/server/commands
		PlayerVote_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); // world/server/player_vote
		Help_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); // world/server/help
	}

	void OnSetTime(float hour = 0.0f, float minute = 0.0f) { Commands_OnSetTime(hour, minute); } // set_time
	void OnCheckCanVote(CBaseEntity@ player = null) { Commands_OnCheckCanVote(player); } // check_can_vote

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rain.spr");
		Precache("rain_splash.spr");
		Precache("rain_mist.spr");
		Precache("rain_ripple.spr");
		Precache("snow1.spr");
		Precache("char_breath.spr");
		CallEventDelayed(1.0f, "Time_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		World_FirstThink();
		SvWorld_FirstThink();
		Commands_FirstThink();
		Time_FirstThink();
		Time_FirstThink2();
		PlayerVote_FirstThink();
		Help_FirstThink();
		Maps_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SvWorld_DispatchEvent(name, params)
			|| Time_DispatchEvent(name, params)
			|| TimeVote_DispatchEvent(name, params)
			|| PlayerVote_DispatchEvent(name, params)
			|| Help_DispatchEvent(name, params)
			|| CommandsScript::DispatchEvent(name, params);
	}
}
