#pragma context server

// Converted from items/base_miscitem.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMiscitem
{
	// Constants
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_VIEW = "none";
	string MODEL_BODY_OFS = "16";
	string ANIM_PREFIX = "package";
	string PLAYERANIM_AIM = "holditem";

	// game_spawn
	void BaseMiscitem_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetAnimExtension(PLAYERANIM_AIM);
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetHudSprite("trade", "package");
		SetWeight(1);

		OnMiscitemSpawn();
	}

	// game_deploy
	void BaseMiscitem_OnGameDeploy()
	{
		OnMiscitemDeploy();
	}

	// game_pickup
	void BaseMiscitem_OnGamePickup()
	{
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel -= ItemHandIndex();
		SetModelBody(0, int(submodel));
	}

	// game_fall
	void BaseMiscitem_OnGameFall()
	{
		SetModel(MODEL_WORLD);

		if (MODEL_WORLD == "misc/p_misc.mdl")
		{
			float submodel = Float(MODEL_BODY_OFS);
			submodel += 1.0f;
			SetModelBody(0, int(submodel));
			string anim = ANIM_PREFIX + "_floor_idle";
			PlayAnim(anim);
		}
		else
		{
			SetModelBody(0, 0);
		}
	}

	// game_drop
	void BaseMiscitem_OnGameDrop()
	{
		OnGameFall();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy();
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop();
	}

	void OnGamePickup() { BaseMiscitem_OnGamePickup(); } // game_pickup
	void OnMiscitemDeploy() {} // miscitem_deploy
	void OnMiscitemSpawn() {} // miscitem_spawn

	// This file's events and timers by their .script names
	bool BaseMiscitem_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_miscitem"]
shared class BaseMiscitemScript : BaseItemExtrasScript, BaseMiscitem
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseMiscitem_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
