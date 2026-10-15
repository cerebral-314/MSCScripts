#pragma context server

// Converted from gertenheld_cave/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "gertenheld_cave/game_master"]
class GertenheldCaveGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool BGOBLIN_CHIEF_SLAIN = false;
	bool VGOBLIN_CHIEF_SLAIN = false;

	// bgoblin_chief_died
	void OnBgoblinChiefDied(Vector3 position = Vector3())
	{
		OnGoldSpew("500", "2", "96", "4", "8", position);
		BGOBLIN_CHIEF_SLAIN = true;
	}

	// vgoblin_chief_died
	void OnVgoblinChiefDied(Vector3 chiefOrigin = Vector3())
	{
		OnGoldSpew("500", "2", "96", "4", "8", chiefOrigin);
		VGOBLIN_CHIEF_SLAIN = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGoldSpew(string goldPerBag = "", string bagsPerPlayer = "", string distance = "", string minimumBags = "", string maximumBags = "", Vector3 position = Vector3()) {} // gold_spew

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bgoblin_chief_died") { OnBgoblinChiefDied(Vec(Param(params, 0))); return true; }
		if (name == "vgoblin_chief_died") { OnVgoblinChiefDied(Vec(Param(params, 0))); return true; }
		return false;
	}
}
