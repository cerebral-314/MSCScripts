#pragma context server

// Converted from items/pack_quiver.script by msc_transpiler.
// Quiver for arrows
// 5:56 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PackQuiver
{
	// Constants
	string MODEL_VIEW = "none";
	string MODEL_HANDS = "weapons/bows/quiver_hands.mdl";
	string MODEL_WORLD = "weapons/bows/quiver_floor.mdl";
	string MODEL_WEAR = "weapons/bows/quiver_spine3.mdl";
	string CONTAINER_TYPE = "quiver";
	int CONTAINER_SPACE = 200;
	int CONTAINER_MAXITEMS = 8;
	bool CONTAINER_CANCLOSE = false;
	bool CONTAINER_LOCK_STRENGTH = false;
	string CONTAINER_ITEM_ACCEPT = "arrow";
	string CONTAINER_ITEM_REJECT = "item_tk_";

	// pack_spawn
	void PackQuiver_OnPackSpawn()
	{
		SetName("Quiver for Arrows");
		SetDescription("A large quiver for arrows");
		SetWeight(1);
		SetValue(4);
		SetWearable(1, "back");
		SetHudSprite("hand", "quiver");
		SetHudSprite("trade", "quiver");
		SetHand("left");
	}

	// pack_deploy
	void PackQuiver_OnPackDeploy()
	{
		SetViewModel("none");
	}

	// pack_wear
	void PackQuiver_OnPackWear()
	{
		OwnerMessage("You sling your quiver over your shoulder.");
	}

	// game_fall
	void PackQuiver_OnGameFall()
	{
		PlayAnim("idle");

		OnPackFall();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnPackSpawn() { PackQuiver_OnPackSpawn(); } // pack_spawn
	void OnPackDeploy() { PackQuiver_OnPackDeploy(); } // pack_deploy
	void OnPackWear() { PackQuiver_OnPackWear(); } // pack_wear
	void OnGameFall() { PackQuiver_OnGameFall(); } // game_fall

	// This file's events and timers by their .script names
	bool PackQuiver_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		if (name == "pack_wear") { OnPackWear(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/pack_quiver"]
shared class PackQuiverScript : PackBaseScript, PackQuiver
{
	// Variables every script that includes this file declares
	string ANIM_IDLE = "ANIM_IDLE";

	// Variables declared by included files, with the value they start with in this script
	PackQuiverScript()
	{
		MODEL_VIEW = "none";
		MODEL_HANDS = "weapons/bows/quiver_hands.mdl";
		MODEL_WORLD = "weapons/bows/quiver_floor.mdl";
		MODEL_WEAR = "weapons/bows/quiver_spine3.mdl";
		CONTAINER_TYPE = "quiver";
		CONTAINER_SPACE = 200;
		CONTAINER_MAXITEMS = 8;
		CONTAINER_ITEM_REJECT = "item_tk_";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/quiver_floor.mdl");
		Precache("weapons/bows/quiver_hands.mdl");
		Precache("weapons/bows/quiver_spine3.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PackQuiver_DispatchEvent(name, params)
			|| PackBaseScript::DispatchEvent(name, params);
	}
}
