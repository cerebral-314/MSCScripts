#pragma context server

// Converted from bloodrose/key_chest.script by msc_transpiler.
// Cupboard in barracks

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "bloodrose/key_chest"]
class BloodroseKeyChest : BaseTreasurechestScript
{
	// Variables declared by included files, with the value they start with in this script
	BloodroseKeyChest()
	{
		ANIM_OPEN = "seq-name";
		ANIM_CLOSE = "seq-name";
		ANIM_IDLE = "seq-name";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		SetName("Old Dresser");
		SetModel("props/Xen_furniture2.mdl");
		SetIdleAnim(ANIM_IDLE);
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseTreasurechest_OnTradeSuccess(); // chests/base_treasurechest
		PlayRandomSound(2, 10, "items/creak.wav");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(13, 26));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		AddStoreItem(STORENAME, "key_red", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/treasure.mdl");
		Precache("props/Xen_furniture2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
