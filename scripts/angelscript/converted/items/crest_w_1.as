#pragma context server

// Converted from items/crest_w_1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_w_1"]
class CrestW1 : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestW1()
	{
		MODEL_CREST_OFS = 31;
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseCrest_OnGameFall(); // items/base_crest
		if (IS_RESERVED)
			return;
		IS_RESERVED = true;
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", @EntityOf(ENT_OWNER));
	}

	// game_restricted
	void OnGameRestricted(CBasePlayer@ player = null)
	{
		BaseItemExtras_OnGameRestricted(player); // items/base_item_extras
		BaseItemExtras_OnGameRestricted_2(player); // items/base_item_extras
		string outMsg = "This crest is reserved for ";
		string itemReserver = GetArray("PICKUP_ALLOW_LIST", "0");
		outMsg += NameOf(itemReserver);
		InfoMessage(player, "Item Restricted", outMsg);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseCrest_OnGameDeploy(); // items/base_crest
		if (IS_RESERVED)
			return;
		IS_RESERVED = true;
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", @EntityOf(ENT_OWNER));
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Avocado's Wallpaper Crest 2012");
		SetDescription("Reward for MSC Wallpaper Contest 2012");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "crest_spawn") { OnCrestSpawn(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_restricted") { OnGameRestricted(PlayerParam(params, 0)); return true; }
		return BaseCrestScript::DispatchEvent(name, params);
	}
}
