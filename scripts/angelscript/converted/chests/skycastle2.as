#pragma context server

// Converted from chests/skycastle2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/skycastle2"]
class Skycastle2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		float pArrows = ActivePlayerCount();
		float hArrows = ActivePlayerCount();
		pArrows *= 60.0f;
		hArrows *= 15.0f;

		// addstoreitem <storename> <item> <amt> <cost%> <buy_ratio> <bundle_size>
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_poison", pArrows, 0, 0, 60);
		AddStoreItem(STORENAME, "proj_arrow_gholy", hArrows, 0, 0, 15);
		AddStoreItem(STORENAME, "skin_bear", 50, 0);
		AddStoreItem(STORENAME, "item_crystal_return", "TC_NPLAYERS", 0);

		OnAddEpicItem();
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
