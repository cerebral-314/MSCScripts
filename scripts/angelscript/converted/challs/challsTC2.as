#pragma context server

// Converted from challs/challsTC2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "challs/challsTC2"]
class ChallsTC2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(6, 12));
		// |Store name|  |Item name|  	|Quantity| |cost|
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "blunt_greatmaul", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
		AddStoreItem(STORENAME, "proj_bolt_iron", 25, 0, 0, 25);

		if (RandomInt(1, 8) == 1)
		{
			int scrollTome = RandomInt(1, 2);
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
