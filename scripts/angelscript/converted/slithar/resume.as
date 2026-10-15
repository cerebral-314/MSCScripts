#pragma context server

// Converted from slithar/resume.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "slithar/resume"]
class Resume : BaseTemporaryScript
{
	// Variables declared by included files, with the value they start with in this script
	Resume()
	{
		DEATH_DELAY = 10.0f;
	}

	// unnamed block (first think)
	void Resume_FirstThink()
	{
		PLAYING_DEAD = "1";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary
		CallEventDelayed(0.1f, "send_resume");
	}

	// send_resume
	void OnSendResume()
	{
		// dbg sending resume command to Slithar
		CBaseEntity@ slitharId = FindByName("snake_lord");
		CallExternal(slitharId, "slithar_resume");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Resume_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "send_resume") { OnSendResume(); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
