#pragma context server

// Converted from chests/barnum_jump.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/barnum_jump"]
class BarnumJump : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		SetGold(int(50.0f * ActivePlayerCount()));
		OnChestAddHpotMpot();

		OnAddGoodItem();
		OnAddGoodItem();

		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);
		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);

		if (RandomInt(1, 6) == 1)
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
