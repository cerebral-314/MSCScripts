#pragma context server

// Converted from items/base_ticket.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseTicket
{
	// Constants
	string MODEL_WORLD = "garbagegibs.mdl";
	string MODEL_HANDS = "misc/p_misc.mdl";

	// game_spawn
	void BaseTicket_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnTicketSpawn();
		SetDescription("The ticket reads: redeem at any Galat Storage Outlet for the associated item");
		SetHudSprite("trade", "letter"); // make new icon if we get a new inventory system
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		BaseTicket_OnGameSpawn(playerRace, playerGender);
	}

	void OnTicketSpawn() {} // ticket_spawn

	// This file's events and timers by their .script names
	bool BaseTicket_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_ticket"]
shared class BaseTicketScript : BaseMiscitemScript, BaseTicket
{
	// Variables declared by included files, with the value they start with in this script
	BaseTicketScript()
	{
		MODEL_WORLD = "garbagegibs.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("garbagegibs.mdl");
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseTicket_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
