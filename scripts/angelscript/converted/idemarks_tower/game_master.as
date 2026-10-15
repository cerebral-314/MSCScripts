#pragma context server

// Converted from idemarks_tower/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "idemarks_tower/game_master"]
class IdemarksTowerGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool TIME_OF_DAY = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CBaseEntity@ sky = FindByName("skybox");
		SetProp(sky, "setbody", 0, 1);

		TIME_OF_DAY = false; // 0 = day, 1 = sunset. Night is an event and is not tracked here.
	}

	// game_triggered
	// <map trigger fired>
	void OnGameTriggered(string triggerName = "")
	{
		CBaseEntity@ sky = null;

		if (triggerName == "jl_met")
			CallExternal(FindByName("ishmeea"), "ext_met_leofing");
		if (triggerName == "cv_met")
			CallExternal(FindByName("leofing"), "ext_met_ishmeea");
		if (triggerName == "jl_celldoor1break")
			CallExternal(FindByName("leofing"), "ext_cell_key");

		if (triggerName == "counter_ish")
		{
			CallExternal(FindByName("ishmeea"), "ext_collected");
			CallExternal(FindByName("alfgar"), "ext_zombify");
		}

		if (triggerName == "tele_ishmeea")
			CallExternal(FindByName("ishmeea"), "ext_tele_triggered");
		if (triggerName == "chapel_start")
		{
			CallExternal(FindByName("ishmeea"), "ext_chapel_start");
			CallExternal(FindByName("idemark"), "ext_chapel_start");
		}
		if (triggerName == "final_boss_die")
			CallExternal(FindByName("ishmeea"), "ext_boss_died");

		if (triggerName == "relay_envlightday")
		{
			@sky = FindByName("skybox");
			SetProp(sky, "setbody", 0, 1);

			TIME_OF_DAY = false;
		}

		if (triggerName == "relay_envlightsunset")
		{
			@sky = FindByName("skybox");
			SetProp(sky, "setbody", 0, 0);

			TIME_OF_DAY = true;
		}

		if (triggerName == "relay_envlightnight")
		{
			@sky = FindByName("skybox");
			SetProp(sky, "setbody", 0, 2);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_triggered") { OnGameTriggered(Param(params, 0)); return true; }
		return false;
	}
}
