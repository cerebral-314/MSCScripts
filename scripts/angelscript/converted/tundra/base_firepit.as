#pragma context server

// Converted from tundra/base_firepit.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseFirepit
{
	// Constants
	string TORCH_LIGHT_SCRIPT = "items/item_torch_light";

	// unnamed block (first think)
	void BaseFirepit_FirstThink()
	{
		PrecacheFile(TORCH_LIGHT_SCRIPT);
	}

	// npc_spawn
	void BaseFirepit_OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		SetWidth(40);
		SetHeight(64);
		SetName("fire pit");
		SetRoam(false);
		SetInvincible(true);

		SetModel("misc/item_log.mdl");
	}

	// give_torch
	void BaseFirepit_OnGiveTorch()
	{
		ReceiveOffer("accept");
		ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_ME), 1);
		OnGaveTorch();
	}

	// game_menu_getoptions
	void BaseFirepit_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_torch")))
		{
			menuItem.title = "Light with torch";
			menuItem.type = "payment";
			menuItem.data = "item_torch";
			menuItem.callback = "give_torch";
			RegisterMenuItem(menuItem);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcSpawn(string npc = "") { BaseFirepit_OnNpcSpawn(npc); } // npc_spawn
	void OnGiveTorch() { BaseFirepit_OnGiveTorch(); } // give_torch
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseFirepit_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnGaveTorch() {} // gave_torch

	// This file's events and timers by their .script names
	bool BaseFirepit_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_torch") { OnGiveTorch(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "tundra/base_firepit"]
shared class BaseFirepitScript : BaseNpcScript, BaseFirepit
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/item_log.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseFirepit_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseFirepit_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
