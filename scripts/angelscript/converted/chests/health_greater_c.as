#pragma context server

// Converted from chests/health_greater_c.script by msc_transpiler.
// Useful, predictable chests by Thothie
// Because every dungeon should have a resupply
// These come in A, B, and C so you can have multiple resupplies that don't stack in your dungeon

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/health_greater_c"]
class HealthGreaterC : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// |Store name|  		|Item name| 	|Quant|	|cost|	|0?|	|Stack?|
		AddStoreItem(STORENAME, "health_spotion", 4, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 4, 0);

		string mapName = ToLowerCase(MapName());
		if (mapName != "b_castle")
			return;

		OnAddGold(200.0f);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		OnAddGoodItem();
		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);

		if (RandomInt(1, 3) == 1)
		{
			OnAddGoodItem();
			AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);
		}

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);

		if (RandomInt(1, 3) == 1)
		{
			AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
			OnAddGreatItem();
		}
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
