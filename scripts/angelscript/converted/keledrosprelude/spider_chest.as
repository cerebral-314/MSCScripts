#pragma context server

// Converted from keledrosprelude/spider_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "keledrosprelude/spider_chest"]
class KeledrospreludeSpiderChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(20, 30));
		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "health_mpotion", 3, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 2, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "item_thiefmap", 1, 0);
		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "blunt_granitemace", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "armor_helm_mongol", 1, 0);
		if (RandomInt(1, 50) == 1)
			AddStoreItem(STORENAME, "shields_lironshield", 1, 0);
		if (RandomInt(1, 100) == 1)
			AddStoreItem(STORENAME, "scroll2_fire_wall", 1, 0);
		if (RandomInt(1, 50) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
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
