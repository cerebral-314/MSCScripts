#pragma context server

// Converted from heras/TC_heras.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "heras/TC_heras"]
class TcHeras : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(10, 23));
		AddStoreItem(STORENAME, "health_mpotion", 3, 0);
		AddStoreItem(STORENAME, "proj_arrow_broadhead", 60, 0, 0, 30);

		string thisMap = ToLowerCase(MapName());
		if (thisMap == "edanasewers")
			AddStoreItem(STORENAME, "item_riddleanswers2", 1, 0);
		if (thisMap == "heras")
			AddStoreItem(STORENAME, "item_riddleanswers", 1, 0);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "proj_bolt_iron", 25, 0, 0, 25);

		OnAddrandomitems();
	}

	// addrandomitems
	void OnAddrandomitems()
	{
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "bows_longbow", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "armor_helm_knight", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "proj_arrow_jagged", 60, 0, 0, 30);
		if (RandomInt(1, 19) == 1)
			AddStoreItem(STORENAME, "bows_longbow", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "addrandomitems") { OnAddrandomitems(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
