#pragma context server

// Converted from items/base_medal.script by msc_transpiler.
// Medals are reserved for their owners, set by creator/GM on spawn
// They display a special effect when activated

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMedal
{
	// Constants
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_HANDS = "misc/p_misc.mdl";
	float FREQ_EFFECT = 21.0f;

	// Variables (an unset .script variable reads as its own name)
	bool BM_OWNER_SET = false;
	float MEDAL_DEPLOY_TIME = 0.0f;
	float MEDAL_NEXT_EFFECT = 0.0f;

	// game_spawn
	void BaseMedal_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHudSprite("trade", "80");
		OnMedalSpawn();
	}

	// game_fall
	void BaseMedal_OnGameFall()
	{
		if (BM_OWNER_SET)
			return;
		BM_OWNER_SET = true;
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", @EntityOf(ENT_OWNER));
	}

	// game_restricted
	void BaseMedal_OnGameRestricted(CBasePlayer@ player = null)
	{
		string outMsg = "This trophy is reserved for ";
		string itemOwner = GetArray("PICKUP_ALLOW_LIST", "0");
		outMsg += NameOf(itemOwner);
		InfoMessage(player, "Item Damagepoint Restricted", outMsg);
	}

	// ext_set_owner
	// <player>
	void BaseMedal_OnExtSetOwner(string player = "")
	{
		// local WINNING_PLAYER $get(GAME_MASTER,scriptvar,'GM_MEDAL_OWNER')
		DebugPrint("Owner set " + NameOf(player));
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", player);
		BM_OWNER_SET = true;
	}

	// game_deploy
	void BaseMedal_OnGameDeploy()
	{
		MEDAL_DEPLOY_TIME = GameTime() + 1.0f;
	}

	// game_attack1
	void BaseMedal_OnGameAttack1()
	{
		if (!(GameTime() > MEDAL_DEPLOY_TIME))
			return;

		if (GameTime() > MEDAL_NEXT_EFFECT)
		{
			MEDAL_NEXT_EFFECT = GameTime() + FREQ_EFFECT;
			OnMedalActivate();
		}
		else
		{
			PlayerMessageDark(ENT_OWNER, "You must wait a bit before showing off this medal again.");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		BaseMedal_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseMedal_OnGameFall();
	}

	// game_restricted
	void OnGameRestricted(CBasePlayer@ player = null)
	{
		BaseItemExtras_OnGameRestricted(player); // items/base_item_extras
		BaseItemExtras_OnGameRestricted_2(player); // items/base_item_extras
		BaseMedal_OnGameRestricted(player);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseMedal_OnGameDeploy();
	}

	void OnExtSetOwner(string player = "") { BaseMedal_OnExtSetOwner(player); } // ext_set_owner
	void OnGameAttack1() { BaseMedal_OnGameAttack1(); } // game_attack1
	void OnMedalActivate() {} // medal_activate
	void OnMedalSpawn() {} // medal_spawn

	// This file's events and timers by their .script names
	bool BaseMedal_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_set_owner") { OnExtSetOwner(Param(params, 0)); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_restricted") { OnGameRestricted(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_medal"]
shared class BaseMedalScript : BaseMiscitemScript, BaseMedal
{
	// Variables every script that includes this file declares
	string MEDAL_FX_SCRIPT = "MEDAL_FX_SCRIPT";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseMedal_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
