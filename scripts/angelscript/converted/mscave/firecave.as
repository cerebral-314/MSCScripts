#pragma context server

// Converted from mscave/firecave.script by msc_transpiler.
// hidden chest in the flaming skulls mouth - requires immune to fire to reach (more or less)

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/firecave"]
class Firecave : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(1000.0f);

		OnAddGreatItem();
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
