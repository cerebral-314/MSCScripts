#pragma context server

// Converted from a3/a3TC6.script by msc_transpiler.
// Thornlands spider chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/a3TC6"]
class A3TC6 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(10, 50));

		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "blunt_hammer2", 1, 0);
		AddStoreItem(STORENAME, "bows_longbow", 1, 0);
		AddStoreItem(STORENAME, "swords_bastardsword", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "sheath_belt_snakeskin", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_skullblade", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_skullblade2", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "proj_arrow_silvertipped", 30, 0, 0, 15);

		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
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
