#pragma context server

// Converted from bloodrose/chest_a_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ChestABase
{
	// Variables (an unset .script variable reads as its own name)
	string SCROLL_TOME = "SCROLL_TOME";

	// chest_additems
	void ChestABase_OnChestAdditems()
	{
		OnAddGold(RandomInt(50, 500));

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "item_log", 1, 0);
		AddStoreItem(STORENAME, "item_crystal_return", 1, 0);

		if (FOAMY_CHEST_TYPE == 1)
		{
			if (RandomInt(0, 1) != 0)
				AddStoreItem(STORENAME, "mana_gprotection", 1, 0);
			else
				AddStoreItem(STORENAME, "mana_protection", 1, 0);

			SCROLL_TOME = GetRandomToken("scroll_poison_cloud;scroll2_poison_cloud;scroll_acid_xolt;scroll2_acid_xolt;scroll_poison;scroll2_poison");
			AddStoreItem(STORENAME, SCROLL_TOME, 1, 0);
		}

		if (FOAMY_CHEST_TYPE == 2)
		{
			OnAddGreatItem();
			AddStoreItem(STORENAME, "smallarms_fangstooth", 1, 0);
		}

		if (FOAMY_CHEST_TYPE == 3)
		{
			AddStoreItem(STORENAME, "swords_nkatana", 1, 0);
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
		}

		if (FOAMY_CHEST_TYPE == 4)
		{
			AddStoreItem(STORENAME, "armor_helm_bronze", 1, 0);
			if (RandomInt(1, 8) == 1)
				AddStoreItem(STORENAME, "armor_salamander", 1, 0);
			if (RandomInt(1, 4) == 1)
				AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		ChestABase_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool ChestABase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "bloodrose/chest_a_base"]
shared class ChestABaseScript : BaseTreasurechestScript, ChestABase
{
	// Variables every script that includes this file declares
	int FOAMY_CHEST_TYPE = 0;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ChestABase_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
