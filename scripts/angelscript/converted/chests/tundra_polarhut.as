#pragma context server

// Converted from chests/tundra_polarhut.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/tundra_base.as"

[script "chests/tundra_polarhut"]
class TundraPolarhut : TundraBaseScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);

		AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);
		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);

		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "scroll2_ice_blast", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "scroll_ice_blast", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "scroll2_healing_circle_920", 1, 0);

		OnAddEpicItem();
		OnAddEpicItem();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return TundraBaseScript::DispatchEvent(name, params);
	}
}
