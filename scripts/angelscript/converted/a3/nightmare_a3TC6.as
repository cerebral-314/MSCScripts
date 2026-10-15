#pragma context server

// Converted from a3/nightmare_a3TC6.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_a3TC6"]
class NightmareA3TC6 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(20, 100));

		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);
		AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "item_crystal_return", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
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
