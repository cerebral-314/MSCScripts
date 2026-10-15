#pragma context server

// Converted from items/base_effect_armor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseEffectArmor
{

	// ext_activate_items
	void BaseEffectArmor_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!IsWorn(ENT_ME))
			return;
		OnBarmorEffectActivate();
	}

	// game_wear
	void BaseEffectArmor_OnGameWear(string race = "", string gender = "", string source = "")
	{
		CallEventDelayed(0.1f, "barmor_effect_activate");
	}

	// game_putinpack
	// this isn't working (SEP2009 - comment only)
	void BaseEffectArmor_OnGamePutinpack()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// game_remove
	void BaseEffectArmor_OnGameRemove()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// game_fall
	void BaseEffectArmor_OnGameFall()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// game_sheath
	void BaseEffectArmor_OnGameSheath()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// game_drop
	void BaseEffectArmor_OnGameDrop()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// game_deploy
	void BaseEffectArmor_OnGameDeploy()
	{
		CallEventDelayed(0.1f, "barmor_effect_remove");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnExtActivateItems(CBaseEntity@ playerId = null) { BaseEffectArmor_OnExtActivateItems(playerId); } // ext_activate_items
	void OnGameWear(string race = "", string gender = "", string source = "") { BaseEffectArmor_OnGameWear(race, gender, source); } // game_wear
	void OnGamePutinpack() { BaseEffectArmor_OnGamePutinpack(); } // game_putinpack
	void OnGameRemove() { BaseEffectArmor_OnGameRemove(); } // game_remove
	void OnGameFall() { BaseEffectArmor_OnGameFall(); } // game_fall
	void OnGameSheath() { BaseEffectArmor_OnGameSheath(); } // game_sheath
	void OnGameDrop() { BaseEffectArmor_OnGameDrop(); } // game_drop
	void OnGameDeploy() { BaseEffectArmor_OnGameDeploy(); } // game_deploy
	void OnBarmorEffectActivate() {} // barmor_effect_activate

	// This file's events and timers by their .script names
	bool BaseEffectArmor_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_remove") { OnGameRemove(); return true; }
		if (name == "game_sheath") { OnGameSheath(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_effect_armor"]
shared class BaseEffectArmorScript : ScriptEntity, BaseEffectArmor
{
	// Variables every script that includes this file declares
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string PLAYERANIM_AIM = "PLAYERANIM_AIM";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseEffectArmor_DispatchEvent(name, params);
	}
}
