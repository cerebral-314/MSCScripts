#pragma context server

// Converted from chests/tundra_dzombs.script by msc_transpiler.
// tundra_guardian, tundra_polarhut, and tundra_dzombs must be found before unique will spawn
// (add one to global on spawn, check on each chest if == 3 - also check if unique already granted)

#include "runtime/ScriptEntity.as"
#include "converted/chests/tundra_base.as"

[script "chests/tundra_dzombs"]
class TundraDzombs : TundraBaseScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);

		AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);
		AddStoreItem(STORENAME, "axes_doubleaxe", 1, 0);
		AddStoreItem(STORENAME, "proj_bolt_fire", 50, 0, 0, 50);

		OnAddEpicItem();
		OnAddEpicItem();

		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return TundraBaseScript::DispatchEvent(name, params);
	}
}
