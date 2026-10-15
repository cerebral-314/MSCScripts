#pragma context server

// Converted from chests/nashalrath_mid.script by msc_transpiler.
// %%missing lava
// Chest for firegiant ripoffroom

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/nashalrath_mid"]
class NashalrathMid : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(5000.0f);

		OnAddEpicItem();

		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);

		OnAddGreatItem();
		OnAddGreatItem();
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
