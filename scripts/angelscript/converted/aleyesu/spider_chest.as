#pragma context server

// Converted from aleyesu/spider_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "aleyesu/spider_chest"]
class AleyesuSpiderChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(20.0f);

		// |Store name|  	|Item name| 	|Quant|	|cost|	|0?|	|Stack?|
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "health_spotion", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);

		AddStoreItem(STORENAME, "blunt_warhammer", 1, 0);
		AddStoreItem(STORENAME, "drink_ale", 4, 0);

		AddStoreItem(STORENAME, "smallarms_huggerdagger3", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "shields_lironshield", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "armor_knight", 1, 0);

		AddStoreItem(STORENAME, "proj_bolt_steel", 50, 0, 0, 50);
		AddStoreItem(STORENAME, "mana_prot_spiders", 1, 0);
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
