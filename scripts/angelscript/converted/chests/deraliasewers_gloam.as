#pragma context server

// Converted from chests/deraliasewers_gloam.script by msc_transpiler.
// Semi-hidden chest near some gloams
// - should likely not be too populated, as you don't have to actually slay the gloams

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/deraliasewers_gloam"]
class DeraliasewersGloam : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(501, 1999));

		if (RandomInt(1, 5) == 1)
		{
			OnAddEpicItem();
			OnAddGreatItem();
		}

		if (RandomInt(1, 5) == 1)
		{
			OnAddEpicItem();
			OnAddGreatItem();
		}

		if (RandomInt(1, 5) == 1)
			OnAddPotion();
	}

	// add_potion
	void OnAddPotion()
	{
		int rndPot = RandomInt(1, 4);

		if (rndPot == 1)
			AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
		if (rndPot == 2)
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		if (rndPot == 3)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);
		if (rndPot == 4)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_potion") { OnAddPotion(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
