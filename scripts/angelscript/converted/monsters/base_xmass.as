#pragma context server

// Converted from monsters/base_xmass.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseXmass
{
	// Constants
	string ANIM_XMASS_WAVE = "wave";

	// game_spawn
	void BaseXmass_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
		{
			// add christmas hat
			CatchSpeech("say_xmass", "christmas", "xmas", "holidays", "hogswatch", "x-mas");
			if (RaceOf(ENT_ME) == "human")
				LegacyCommand("setmodelbody", ENT_ME, 2, 1);
		}
	}

	// say_xmass
	void BaseXmass_OnSayXmass()
	{
		if (!Truthy(GetVar("G_CHRISTMAS_MODE")))
			return;
		PlayAnim("critical", ANIM_XMASS_WAVE);
		SayText("A happy Hogswatch to you too!");

		if (RandomInt(0, 1) != 0)
			PlayMusic("all", "system", "xmass_annoy.mp3");
		else
			PlayMusic("all", "system", "xmass.mp3");

		if (Truthy(GetVar("XMASS_OLD_GUY")))
		{
			PlaySound(0, 10, "npc/happy_hogswatch.wav");
			Say("[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.10]", "[.10]", "[.10]", "[.10]");
		}
		else
		{
			PlaySound(0, 10, "npc/xmass_male.wav");
			Say("[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.10]", "[.10]", "[.10]", "[.10]");
		}

		if (!Truthy(GetVar("IS_SNOWING")))
			CallExternal("players", "ext_weather_change", "snow");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseXmass_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSayXmass() { BaseXmass_OnSayXmass(); } // say_xmass

	// This file's events and timers by their .script names
	bool BaseXmass_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_xmass") { OnSayXmass(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_xmass"]
shared class BaseXmassScript : ScriptEntity, BaseXmass
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseXmass_DispatchEvent(name, params);
	}
}
