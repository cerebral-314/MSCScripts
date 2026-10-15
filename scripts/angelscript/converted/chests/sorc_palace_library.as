#pragma context server

// Converted from chests/sorc_palace_library.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/sorc_palace_library"]
class SorcPalaceLibrary : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(1000.0f);

		AddStoreItem(STORENAME, "scroll_lightning_weak", 1, 0);
		AddStoreItem(STORENAME, "scroll2_lightning_weak", 1, 0);

		if (RandomInt(1, 4) == 1)
		{
			AddStoreItem(STORENAME, "scroll_lightning_storm", 1, 0);
			AddStoreItem(STORENAME, "scroll2_lightning_storm", 1, 0);
		}

		if (RandomInt(1, 8) == 1)
		{
			AddStoreItem(STORENAME, "scroll_lightning_chain", 1, 0);
			AddStoreItem(STORENAME, "scroll2_lightning_chain", 1, 0);
		}

		if (RandomInt(1, 16) == 1)
		{
			AddStoreItem(STORENAME, "scroll_volcano", 1, 0);
			AddStoreItem(STORENAME, "scroll2_volcano", 1, 0);
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
