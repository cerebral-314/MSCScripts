#pragma context server

// Converted from phobia/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "phobia/game_master"]
class PhobiaGameMaster : ScriptEntity
{
	// gm_phobia_tele_bandits
	void OnGmPhobiaTeleBandits()
	{
		CBaseEntity@ banditId = FindByName("bandit_ralion");
		if (IsAlive(banditId))
			SetOrigin(banditId, Vector3(328, 2432, -272));
		@banditId = FindByName("bandit_betor");
		if (IsAlive(banditId))
			SetOrigin(banditId, Vector3(448, 2560, -272));
		@banditId = FindByName("bandit_skelr");
		if (IsAlive(banditId))
			SetOrigin(banditId, Vector3(208, 2560, -272));
	}

	// gm_phobia_bandit_lights
	void OnGmPhobiaBanditLights()
	{
		CallExternal("all", "bandit_ally_lights");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_phobia_bandit_lights") { OnGmPhobiaBanditLights(); return true; }
		if (name == "gm_phobia_tele_bandits") { OnGmPhobiaTeleBandits(); return true; }
		return false;
	}
}
