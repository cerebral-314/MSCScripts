#pragma context server

// Converted from other/idle_lure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "other/idle_lure"]
class IdleLure : DebugScript
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string LURE_RACE = "LURE_RACE";
	string PAR_STR = "PAR_STR";
	string RUN_WALK = "RUN_WALK";

	// unnamed block (timer)
	void IdleLure_Timer()
	{
		CallEventDelayed(10.0f, "IdleLure_Timer");

		if (LURE_RACE == "none")
			LURE_RACE = "all";
		CallExternal("all", "ext_super_lure", self, LURE_RACE, RUN_WALK);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		SetFly(true);
		SetNoPush(true);
		PLAYING_DEAD = "1";
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = params string
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		PAR_STR = params;
		LURE_RACE = "all";
		RUN_WALK = "walk";
		int nPars = GetTokenCount(params);
		if (!(nPars > 0))
			return;
		for (int i = 0; i < nPars; i++)
		{
			loopIteration = i;
			OnParseParams();
		}
	}

	// parse_params
	void OnParseParams()
	{
		string curParam = GetToken(PAR_STR, loopIteration);
		if (curParam == "run")
			RUN_WALK = "run";
		if (curParam != "run")
			LURE_RACE = curParam;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(10.0f, "IdleLure_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "parse_params") { OnParseParams(); return true; }
		if (name == "IdleLure_Timer") { IdleLure_Timer(); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
