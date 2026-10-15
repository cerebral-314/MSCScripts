#pragma context server

// Converted from oceancrossing/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "oceancrossing/game_master"]
class OceancrossingGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float RUN_NUM = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CBaseEntity@ sky = FindByName("skybox");
		SetProp(sky, "setbody", 0, 1);

		CallEventDelayed(0.01f, "game_think");
	}

	// game_triggered
	// <map trigger fired>
	void OnGameTriggered(string triggerName = "")
	{
		CBaseEntity@ ocean = FindByName("ocean");
		CBaseEntity@ sky = FindByName("skybox");

		if (triggerName == "deralia_start")
		{
			SetProp(ocean, "skin", 2);
			SetProp(sky, "setbody", 0, 2);

			UseTrigger("relay_envlightnight");
		}
		else if (triggerName == "ara_start")
		{
			SetProp(sky, "setbody", 0, 0);
			UseTrigger("relay_envlightsunset");
		}
		else if (triggerName == "isles_start")
		{
			SetProp(ocean, "skin", 3);
		}
		else if (triggerName == "tundra_start")
		{
			SetGlobal("G_WEATHER_LOCK", "snow");
			CallExternal("players", "ext_weather_change", "snow");
			SetProp(ocean, "skin", 1);
			SetProp(ocean, "sequence", 1);
		}

		if (triggerName == "cannon_fired")
		{
			SetProp(ocean, "sequence", 1); // calm ocean
			CallExternal("players", "ext_weather_change", "clear");
		}
	}

	// player_joined
	void OnPlayerJoined(CBaseEntity@ player = null)
	{
	}

	// game_think
	void OnGameThink()
	{
		CBaseEntity@ sky = FindByName("skybox");

		float num = Divide(Modulo(RUN_NUM, 50.0f), 50.0f) * 6.28f;

		float ang = Float(LegacyFunction("math", "sin", num));

		// multiply L_ANG 2
		// infomsg all RUN_NUM L_ANG
		SetProp(sky, "angles", Vector3(ang, 0, 0));

		RUN_NUM += 1.0f;

		CallEventDelayed(0.01f, "game_think");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_think") { OnGameThink(); return true; }
		if (name == "game_triggered") { OnGameTriggered(Param(params, 0)); return true; }
		if (name == "player_joined") { OnPlayerJoined(EntityParam(params, 0)); return true; }
		return false;
	}
}
