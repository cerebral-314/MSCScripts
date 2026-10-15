#pragma context server

// Converted from chests/m2_quest2_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/m2_quest2_final"]
class M2Quest2Final : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	bool TOLD_SYPH = false;

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseTreasurechest_OnGamePlayerused(player); // chests/base_treasurechest
		if (TOLD_SYPH)
			return;
		TOLD_SYPH = true;
		CallExternal(FindByName("sylphiel"), "ext_saw_chest");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);
		AddStoreItem(STORENAME, "mana_prot_spiders", 1, 0);
		OnAddNoobItem();
		OnAddNoobItem();
		OnAddGoodItem();
		OnAddGoodItem();
		OnAddGreatItem();
		if (ActivePlayerCount() > 1)
			OnAddGreatItem();
		OnAddGold(200.0f);
		AddStoreItem(STORENAME, "proj_arrow_blunt", 15, 0, 0, 15);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
