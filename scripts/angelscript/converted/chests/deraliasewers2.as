#pragma context server

// Converted from chests/deraliasewers2.script by msc_transpiler.
// Sewer Boss Chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/deraliasewers2"]
class Deraliasewers2 : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	bool GAVE_KEY = false;

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (!GAVE_KEY)
		{
			GAVE_KEY = true;
			AddStoreItem(STORENAME, "item_key_sewer", 1, 0);
		}
		else if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "item_key_sewer", 1, 0);

		OnAddGold(RandomInt(200, 1200));

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "armor_salamander", 1, 0);

		if (RandomInt(1, 20) == 1)
		{
			OnAddGoodItem();
			OnAddGreatItem();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 20) == 1)
		{
			OnAddGreatItem();
			OnAddGreatItem();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				OnAddEpicItem();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 20) == 1)
		{
			OnAddGreatItem();
			OnAddEpicItem();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				OnAddEpicItem();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 20) == 1)
		{
			OnAddEpicItem();
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 20) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
			if (RandomInt(1, 10) <= ActivePlayerCount())
				AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
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
