#pragma context server

// Converted from monsters/skels_sleep.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/skels_sleep"]
class SkelsSleep : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetRace("beloved");
		SetInvincible(true);
		SetUniqueName("skels_sleep");
		SetFly(true);
		SetHealth(10);
		PLAYING_DEAD = "1";
	}

	// suicide_me
	void OnSuicideMe()
	{
		// dbg skels_sleep got order to suicide
		SetRace("hated");
		SetInvincible(false);
		SetAlive(false);
		CallEventDelayed(0.2f, "suicide_me2");
	}

	// suicide_me2
	void OnSuicideMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "suicide_me") { OnSuicideMe(); return true; }
		if (name == "suicide_me2") { OnSuicideMe2(); return true; }
		return false;
	}
}
