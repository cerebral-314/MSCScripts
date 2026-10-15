#pragma context server

// Converted from items/base_elemental_resist.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseElementalResist
{
	// Variables (an unset .script variable reads as its own name)
	bool ELM_EFFECT_ACTIVE = false;

	// unnamed block (first think)
	void BaseElementalResist_FirstThink()
	{
		// required:
		// ELM_NAME - item's code name (five letters, must be unique)
		// ELM_TYPE - element type
		// ELM_AMT - resistance % (use negative numbers to add vulnerability)
		// ELM_WEAPON - set to 1 if reistance item is a weapon and does not need to be worn
		// if resist% is variable, set in elm_get_resist
		// if using multiple resistances, [override] elm_activate_effect and elm_remove_effect
		// you will also need multiple code names for each type of resistance
		// this can also be used for other effects that are only in play when an item is worn
		// to use this, [override] elm_activate_effect and elm_remove_effect, then replace with desired effect
		// list of used element names:
		// farmr - primary faura armor effect
		// carmr - secondary faura armor effect
		// aarmr - primary paura armor effect
		// aarmb - secondary paura armor effect
		// cbow - frost bow effect (wrong length, but seems okay)
		// ringl - lightning ring
		// possw - green rune sword
		// firel - fire lizard armor
		// fireh - fire helm
		// coldh - cold helm
		// phonx - phoenix armor
		// pois1 - salamander armor
		// varmr - venom plate
		// colip - immune cold potion
		// firip - immune fire potion
		// ligip - immune lightning potion
		// coldp - resist cold potion
		// firep - resist fire potion
		ELM_EFFECT_ACTIVE = false;
	}

	// game_putinpack
	void BaseElementalResist_OnGamePutinpack()
	{
		OnElmRemoveEffect();
	}

	// game_drop
	void BaseElementalResist_OnGameDrop()
	{
		OnElmRemoveEffect();
	}

	// game_remove
	// { game_removefromowner
	// callevent elm_remove_effect
	// }
	// { game_removed
	// callevent elm_remove_effect
	// }
	void BaseElementalResist_OnGameRemove()
	{
		OnElmRemoveEffect();
	}

	// game_fall
	void BaseElementalResist_OnGameFall()
	{
		OnElmRemoveEffect();
	}

	// game_sheath
	void BaseElementalResist_OnGameSheath()
	{
		OnElmRemoveEffect();
	}

	// game_deploy
	void BaseElementalResist_OnGameDeploy()
	{
		if (Truthy(GetVar("ELM_WEAPON")))
			return;
		OnElmRemoveEffect();
	}

	// game_deleted
	void BaseElementalResist_OnGameDeleted()
	{
		bool remEffects = false;
		if (IsInHand(ENT_ME))
			remEffects = true;
		if (IsWorn(ENT_ME))
			remEffects = true;
		if (!remEffects)
			return;
		OnElmRemoveEffect();
	}

	// game_wear
	void BaseElementalResist_OnGameWear(string race = "", string gender = "", string source = "")
	{
		OnElmActivateEffect();
	}

	// elm_activate_effect
	void BaseElementalResist_OnElmActivateEffect()
	{
		if (ELM_EFFECT_ACTIVE)
			return;
		ELM_EFFECT_ACTIVE = true;
		OnElmGetResist();
		if (!Truthy(GetVar("ELM_WEAPON")))
			CallExternal(ENT_OWNER, "ext_register_element", GetVar("ELM_NAME"), GetVar("ELM_TYPE"), GetVar("ELM_AMT"));
		else
			CallExternal(ENT_OWNER, "ext_register_weapon", self, GetVar("ELM_NAME"), GetVar("ELM_TYPE"), GetVar("ELM_AMT"));
	}

	// elm_remove_effect
	void BaseElementalResist_OnElmRemoveEffect()
	{
		if (!ELM_EFFECT_ACTIVE)
			return;
		ELM_EFFECT_ACTIVE = false;
		if (!Truthy(GetVar("ELM_WEAPON")))
			CallExternal(ENT_OWNER, "ext_register_element", GetVar("ELM_NAME"), "remove");
		else
			CallExternal(ENT_OWNER, "ext_register_weapon", self, GetVar("ELM_NAME"), "remove");
	}

	// elm_get_resist
	void BaseElementalResist_OnElmGetResist()
	{
	}

	// ext_activate_items
	// <spawning playerId>
	void BaseElementalResist_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		bool exitSub = false;

		if (playerId !is EntityOf(ENT_OWNER))
			return;

		if (!Truthy(GetVar("ELM_WEAPON")))
		{
			// wearables don't give bonus if not worn
			if (!IsWorn(ENT_ME))
				exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(GetVar("ELM_WEAPON")))
		{
			// weapons don't give bonus if not in hand
			if (ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND") != ENT_ME && ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND") != ENT_ME)
				exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(0.1f, "elm_activate_effect");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePutinpack() { BaseElementalResist_OnGamePutinpack(); } // game_putinpack
	void OnGameDrop() { BaseElementalResist_OnGameDrop(); } // game_drop
	void OnGameRemove() { BaseElementalResist_OnGameRemove(); } // game_remove
	void OnGameFall() { BaseElementalResist_OnGameFall(); } // game_fall
	void OnGameSheath() { BaseElementalResist_OnGameSheath(); } // game_sheath
	void OnGameDeploy() { BaseElementalResist_OnGameDeploy(); } // game_deploy
	void OnGameDeleted() { BaseElementalResist_OnGameDeleted(); } // game_deleted
	void OnGameWear(string race = "", string gender = "", string source = "") { BaseElementalResist_OnGameWear(race, gender, source); } // game_wear
	void OnElmActivateEffect() { BaseElementalResist_OnElmActivateEffect(); } // elm_activate_effect
	void OnElmRemoveEffect() { BaseElementalResist_OnElmRemoveEffect(); } // elm_remove_effect
	void OnElmGetResist() { BaseElementalResist_OnElmGetResist(); } // elm_get_resist
	void OnExtActivateItems(CBaseEntity@ playerId = null) { BaseElementalResist_OnExtActivateItems(playerId); } // ext_activate_items

	// This file's events and timers by their .script names
	bool BaseElementalResist_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "elm_activate_effect") { OnElmActivateEffect(); return true; }
		if (name == "elm_get_resist") { OnElmGetResist(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_deleted") { OnGameDeleted(); return true; }
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
[script "items/base_elemental_resist"]
shared class BaseElementalResistScript : ScriptEntity, BaseElementalResist
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

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseElementalResist_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseElementalResist_DispatchEvent(name, params);
	}
}
