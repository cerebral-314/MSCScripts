#pragma context server

// Converted from chests/highlands1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/highlands1"]
class Highlands1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(50.0f);

		// |Store name|  	|Item name| 	|Quant|	|cost|	|0?|	|Stack?|
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);

		AddStoreItem(STORENAME, "blunt_warhammer", 1, 0);
		AddStoreItem(STORENAME, "drink_ale", 4, 0);

		AddStoreItem("smallarms_huggerdagger3", "1", 0);

		int nPlayers = ActivePlayerCount();

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "shields_lironshield", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "armor_knight", 1, 0);

		AddStoreItem(STORENAME, "proj_bolt_iron", 50, 0, 0, 25);

		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "swords_katana4", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "swords_katana1", 1, 0);
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
