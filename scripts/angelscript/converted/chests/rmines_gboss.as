#pragma context server

// Converted from chests/rmines_gboss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/rmines_gboss"]
class RminesGboss : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= ActivePlayerCount();
		goldToAdd *= 10.0f;
		OnAddGold(int(goldToAdd));

		AddStoreItem(STORENAME, "proj_bolt_poison", 25, 0, 0, 25);

		OnAddGreatItem();
		OnAddEpicItem();
		OnAddGreatArrows();

		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "mana_bravery", 1, 0);
		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "mana_paura", 1, 0);
		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);
		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "mana_font", 1, 0);

		AddStoreItem(STORENAME, "proj_bolt_poison", 25, 0, 0, 25);
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
