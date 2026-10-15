#pragma context server

// Converted from items/base_effect_weilded.script by msc_transpiler.
// include for weapons/items that have an effect only while weilded
// THIS IS OBSOLETE
// - Now included in items/base_item_extras
// - beware that if a any of the below game_ events are [overide] this will NOT work - check all includes
// - base includes with [override] game_x events need to be altered

#include "runtime/ScriptEntity.as"

[script "items/base_effect_weilded"]
class BaseEffectWeilded : ScriptEntity
{
	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		bool bewIsWeilded = false;
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			bewIsWeilded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			bewIsWeilded = true;
		if (!bewIsWeilded)
			return;
		OnBweaponEffectActivate();
	}

	// game_deploy
	void OnGameDeploy()
	{
		// dbg base_effect_wielded $get(ent_owner,scriptvar,'PLR_IN_WORLD')
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		OnBweaponEffectActivate();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		OnBweaponEffectRemove();
	}

	// game_putinpack
	// this isn't working (SEP2009 - comment only)
	void OnGamePutinpack()
	{
		OnBweaponEffectRemove();
	}

	// game_remove
	void OnGameRemove()
	{
		OnBweaponEffectRemove();
	}

	// game_fall
	void OnGameFall()
	{
		OnBweaponEffectRemove();
	}

	// game_sheath
	void OnGameSheath()
	{
		OnBweaponEffectRemove();
	}

	// game_drop
	void OnGameDrop()
	{
		OnBweaponEffectRemove();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBweaponEffectActivate() {} // bweapon_effect_activate
	void OnBweaponEffectRemove(string reason = "") {} // bweapon_effect_remove

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
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
