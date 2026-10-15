#pragma context server

// Converted from sfor/sforTC2.script by msc_transpiler.
// Thothie - can't figure why these chests were removed
// - adding a map condition, as this map used to contain nothing but a smidgen of gold
// - and many (only ms_swamp but ok) maps use it as a minor reward

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "sfor/sforTC2"]
class SforTC2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		string mapName = ToLowerCase(MapName());

		OnAddGold(RandomInt(5, 25));

		// |Store name|	|Item name|		|Quantity|	|cost|
		if (mapName == "sfor")
			AddStoreItem(STORENAME, "item_manuscript", 1, 0);

		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "shields_buckler", 1, 0);
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
