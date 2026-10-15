#pragma context server

// Converted from help/first_vendor.script by msc_transpiler.
// Thothie - help update for new spell system
// Player first sees a vendor

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FirstVendor
{

	// game_targeted_by_player
	// 1: Player
	void FirstVendor_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		string text = "You are looking at " + Eval("game.monster.name");
		text += ".|He sells items.  You can press the use key|or speak to him to gain access to his wares.";
		HelpTip(player, "help_vendor", "Vendor", text);
	}

	// help_vendor_magic
	// 1: Player
	void FirstVendor_OnHelpVendorMagic(CBasePlayer@ player = null)
	{
		string text = "You are looking at " + Eval("game.monster.name");
		text += ".|He sells Tomes and Scrolls.|In order to use magic you must read the Scroll or Tome.|Tomes can be permanently memorized and re-selected|press 2 to select a memorized spell.|Scrolls must be activated for each use, |but need no be memorized.|Currently, you may only memorize eight spells.";
		HelpTip(player, "help_scrolls", "Scroll merchant", text);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameTargetedByPlayer(CBasePlayer@ player = null) { FirstVendor_OnGameTargetedByPlayer(player); } // game_targeted_by_player
	void OnHelpVendorMagic(CBasePlayer@ player = null) { FirstVendor_OnHelpVendorMagic(player); } // help_vendor_magic

	// This file's events and timers by their .script names
	bool FirstVendor_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "help_vendor_magic") { OnHelpVendorMagic(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "help/first_vendor"]
shared class FirstVendorScript : ScriptEntity, FirstVendor
{
	// Variables every script that includes this file declares
	string STORE_BUYMENU = "STORE_BUYMENU";
	string STORE_NAME = "STORE_NAME";
	bool STORE_RESTOCK = false;
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	bool VEND_NO_GOODBYE = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return FirstVendor_DispatchEvent(name, params);
	}
}
