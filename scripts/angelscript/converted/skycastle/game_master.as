#pragma context server

// Converted from skycastle/game_master.script by msc_transpiler.
// Skycastle Game Master Events

#include "runtime/ScriptEntity.as"

[script "skycastle/game_master"]
class SkycastleGameMaster : ScriptEntity
{
	// gm_bear_god_death
	void OnGmBearGodDeath()
	{
		CallEventDelayed(1.0f, "gm_bear_god_death2");
	}

	// gm_bear_god_death2
	void OnGmBearGodDeath2()
	{
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 512, 0, 150);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_bear_god_death") { OnGmBearGodDeath(); return true; }
		if (name == "gm_bear_god_death2") { OnGmBearGodDeath2(); return true; }
		return false;
	}
}
