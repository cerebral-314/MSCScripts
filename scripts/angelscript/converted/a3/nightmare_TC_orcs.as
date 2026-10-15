#pragma context server

// Converted from a3/nightmare_TC_orcs.script by msc_transpiler.
// Treasure chest after you kill all the orcs in a3 [random quest]
// - nightmare variant

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_TC_orcs"]
class NightmareTcOrcs : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		AddStoreItem(STORENAME, "health_mpotion", RandomInt(1, 2), 0);
		AddStoreItem(STORENAME, "bows_orcbow", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_jagged", 60, 0, 0, 15);
		AddStoreItem(STORENAME, "proj_arrow_fire", 60, 0, 0, 15);
		AddStoreItem(STORENAME, "armor_leather_studded", 1, 0);

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "bows_swiftbow", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_protection", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "blunt_gauntlets_fire", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
