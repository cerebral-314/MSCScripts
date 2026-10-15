#pragma context server

// Converted from chests/chapel_bat.script by msc_transpiler.
// chapel bat chest - kinda like spidqer queen chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/chapel_bat"]
class ChapelBat : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(10, 40));

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "swords_bastardsword", 1, 0);

		if (RandomInt(1, 2) == 1)
			OnAddNoobItem();
		if (RandomInt(1, 2) == 1)
			OnAddNoobItem();

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_longsword", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_skullblade", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_skullblade2", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "proj_arrow_silvertipped", 300, 0, 0, 60);
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
