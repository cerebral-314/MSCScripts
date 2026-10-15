#pragma context server

// Converted from other/grave_watcher.script by msc_transpiler.
// This script detects players with the felewyn statue for Dridge's upcoming map

#include "runtime/ScriptEntity.as"
#include "converted/other/base_item_detect.as"
#include "converted/monsters/debug.as"

[script "other/grave_watcher"]
class GraveWatcher : BaseItemDetectScript, Debug
{
	// Variables declared by included files, with the value they start with in this script
	GraveWatcher()
	{
		SEARCH_ITEM = "item_fstatue";
	}

	// item_detected
	void OnItemDetected(string player = "")
	{
		if (ITEM_FOUND)
			return;
		SetName("Feldar's Grave");
		ITEM_FOUND = true;
		OpenMenu(player);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (!ITEM_FOUND)
			return;

		if (!Truthy(ItemExists(player, SEARCH_ITEM)))
			return;

		menuItem.title = "Place the Statuette";
		menuItem.type = "payment";
		menuItem.cb_failed = "payment_failed";
		menuItem.data = SEARCH_ITEM;
		menuItem.callback = "statue_return";
		RegisterMenuItem(menuItem);

		menuItem.title = "Leave";
		menuItem.type = "callback";
		menuItem.callback = "player_opted_out";
		RegisterMenuItem(menuItem);
	}

	// statue_return
	void OnStatueReturn()
	{
		UseTrigger("got_statue");
		CBaseEntity@ keeperId = FindByName("lkeeper");
		CallExternal(keeperId, "quest_done_grave");
		CallEventDelayed(0.1f, "remove_me");
	}

	// player_opted_out
	void OnPlayerOptedOut()
	{
		UseTrigger("player_refused");
		CallEventDelayed(3.0f, "reset_scan");
	}

	// payment_failed
	void OnPaymentFailed()
	{
		CallEventDelayed(3.0f, "reset_scan");
	}

	// reset_scan
	void OnResetScan()
	{
		ITEM_FOUND = false;
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "item_detected") { OnItemDetected(Param(params, 0)); return true; }
		if (name == "payment_failed") { OnPaymentFailed(); return true; }
		if (name == "player_opted_out") { OnPlayerOptedOut(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reset_scan") { OnResetScan(); return true; }
		if (name == "statue_return") { OnStatueReturn(); return true; }
		return Debug_DispatchEvent(name, params)
			|| BaseItemDetectScript::DispatchEvent(name, params);
	}
}
