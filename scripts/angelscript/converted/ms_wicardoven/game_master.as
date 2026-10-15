#pragma context server

// Converted from ms_wicardoven/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_wicardoven/game_master"]
class MsWicardovenGameMaster : ScriptEntity
{
	// game_triggered
	// <trigger name>
	void OnGameTriggered(string triggerName = "")
	{
		if (triggerName == "music_voldar_dead") // fired from map
			CallEventDelayed(2.5f, "sailor_moon");
	}

	// sailor_moon
	void OnSailorMoon()
	{
		PlayMusic("all", "combat", "sailormoon_victory.mp3");
		CallEventDelayed(7.5f, "end_music");
	}

	// end_music
	void OnEndMusic()
	{
		PlayMusic("all", "stop");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_music") { OnEndMusic(); return true; }
		if (name == "game_triggered") { OnGameTriggered(Param(params, 0)); return true; }
		if (name == "sailor_moon") { OnSailorMoon(); return true; }
		return false;
	}
}
