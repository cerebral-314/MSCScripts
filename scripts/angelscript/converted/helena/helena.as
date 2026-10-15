#pragma context server

// Converted from helena/helena.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "helena/helena"]
class Helena : ScriptEntity
{
	// Constants
	int FREQ_CHECK = 0;
	int HPREQ_MEDIUM_WAVE = 500;
	int HPREQ_STRONG_WAVE = 1250;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("script_helena");
		// Check for attack every CheckDelay seconds
		SetName("_");
		CallEventDelayed(0.0f, Text(FREQ_CHECK));
		SetInvincible(true);
		SetFly(true);
		PLAYING_DEAD = "1";
		SetAlive(true);
		SetRace("beloved");

		DebugPrint("helena NPC spawned");
	}

	// check_for_raid
	void OnCheckForRaid()
	{
		int rndChance = RandomInt(1, 5);
		DebugPrint("check_for_raid ( " + rndChance + " / 5 )");
		if (rndChance != 1)
			CallEventDelayed(0.0f, Text(FREQ_CHECK));

		if (rndChance != 1)
			return;

		OnStartRaid();
	}

	// start_raid
	void OnStartRaid()
	{
		string totalHpText = Eval("game.players.totalhp");
		int totalHp = Int(totalHpText);
		DebugPrint("start_raid " + totalHpText);
		if (totalHp < HPREQ_MEDIUM_WAVE)
			UseTrigger("spawn_orcs_weak", "del_stuff");

		if (totalHp >= HPREQ_MEDIUM_WAVE && totalHp < HPREQ_STRONG_WAVE)
			UseTrigger("spawn_orcs_medium", "cata_chance_50", "del_stuff");

		if (totalHp >= HPREQ_STRONG_WAVE)
			UseTrigger("spawn_orcs_strong", "cata_chance_75", "del_stuff");

		InfoMessage("all", "HELENA IS UNDER ATTACK!", "The Blackhand Orcs are raiding Helena!");
		CallExternal("all", "helena_raid_go");

		CallEventDelayed(1.0f, "music_orcs");
	}

	// bandit_raid
	void OnBanditRaid()
	{
		DebugPrint("bandit_raid");
		CallEventDelayed(1.0f, "bandit_raid2");
		UseTrigger("del_stuff"); // removes monsterclip from Dorfgan
	}

	// bandit_raid2
	void OnBanditRaid2()
	{
		InfoMessage("all", "HELENA IS UNDER ATTACK", "Bandits are raiding Helena!");
		CallExternal("all", "helena_raid_go");
		CallEventDelayed(1.0f, "music_bandits");
	}

	// music_orcs
	// Playmp3 seems to be generating some sort of client side error, stopping the script, hence these are seperate after a delay
	void OnMusicOrcs()
	{
		PlayMusic("all", "combat", "media/Half-Life11.mp3"); // mschalls.mp3
	}

	// music_bandits
	void OnMusicBandits()
	{
		PlayMusic("all", "combat", "barbarian_gladiator.mp3");
	}

	// music_raid_end
	void OnMusicRaidEnd()
	{
		PlayMusic("all", "combat", "mshelena.mp3");
	}

	// raid_done
	void OnRaidDone()
	{
		DebugPrint("raid_done");
		CallExternal("all", "helena_raid_end");
		CallEventDelayed(0.0f, Text(FREQ_CHECK));
		CallEventDelayed(2.0f, "music_raid_end");
		PlayMusic("all", "stop");
	}

	// manual_start
	void OnManualStart(string raid = "")
	{
		// if Attacking equals 0
		DebugPrint("manual_start");
		OnStartRaid();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bandit_raid") { OnBanditRaid(); return true; }
		if (name == "bandit_raid2") { OnBanditRaid2(); return true; }
		if (name == "check_for_raid") { OnCheckForRaid(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "manual_start") { OnManualStart(Param(params, 0)); return true; }
		if (name == "music_bandits") { OnMusicBandits(); return true; }
		if (name == "music_orcs") { OnMusicOrcs(); return true; }
		if (name == "music_raid_end") { OnMusicRaidEnd(); return true; }
		if (name == "raid_done") { OnRaidDone(); return true; }
		if (name == "start_raid") { OnStartRaid(); return true; }
		return false;
	}
}
