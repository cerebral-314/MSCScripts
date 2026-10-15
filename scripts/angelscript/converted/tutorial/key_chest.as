#pragma context server

// Converted from tutorial/key_chest.script by msc_transpiler.
// Keychest for tutorial map by Thothie
// - Cuz rats don't generally have keychains ;)

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "tutorial/key_chest"]
class TutorialKeyChest : BaseTreasurechestScript
{
	// Constants
	bool NO_ORE = true;

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		AddStoreItem(STORENAME, "tutorial_key", 1, 0);
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
