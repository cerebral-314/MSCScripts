#pragma context server

// Converted from items/dev_staff/damager.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Damager
{
	// Variables (an unset .script variable reads as its own name)
	string DAMAGER_DMG = "DAMAGER_DMG";

	// unnamed block (first think)
	void Damager_FirstThink()
	{
		DAMAGER_DMG = "3";
	}

	// try_damage
	void Damager_OnTryDamage()
	{
		OnFindBeamTarget();
		DoDamageEx(BEAM_TARGET, "direct", DAMAGER_DMG, 100, ENT_OWNER, ENT_ME, "none", "apostle_effect");
	}

	// set_damager
	void Damager_OnSetDamager(string damage = "", string extra = "")
	{
		DAMAGER_DMG = damage;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnTryDamage() { Damager_OnTryDamage(); } // try_damage
	void OnSetDamager(string damage = "", string extra = "") { Damager_OnSetDamager(damage, extra); } // set_damager
	void OnFindBeamTarget() {} // find_beam_target

	// This file's events and timers by their .script names
	bool Damager_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "set_damager") { OnSetDamager(Param(params, 0), Param(params, 1)); return true; }
		if (name == "try_damage") { OnTryDamage(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/damager"]
shared class DamagerScript : ScriptEntity, Damager
{
	// Variables every script that includes this file declares
	float AFFLICT_DMG = 0.0f;
	string AFFLICT_DURATION = "AFFLICT_DURATION";
	string AFFLICT_PARAMS = "AFFLICT_PARAMS";
	string AFFLICT_SCRIPT = "AFFLICT_SCRIPT";
	string AFFLICT_SKILL = "AFFLICT_SKILL";
	bool AM_NOCLIPPING = false;
	string BEAM_TARGET = "BEAM_TARGET";
	string BEAM_TYPE = "BEAM_TYPE";
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	string CLIPBOARD_ADDPARAMS = "CLIPBOARD_ADDPARAMS";
	float CLIPBOARD_ADD_DIST = 0.0f;
	string CLIPBOARD_DMGMULTI = "CLIPBOARD_DMGMULTI";
	string CLIPBOARD_HPMULTI = "CLIPBOARD_HPMULTI";
	int CLIPBOARD_KEEP_DIST = 0;
	string CLIPBOARD_NAME = "CLIPBOARD_NAME";
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	float LAST_REMOVE = 0.0f;
	string MENU_ID = "MENU_ID";
	bool NO_BANK = false;
	string NPC_CLIPBOARD = "NPC_CLIPBOARD";
	bool PHYSGUN_ON = false;
	float PHYS_KEEP_DIST = 0.0f;
	float REMOVE_DELAY = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Damager_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Damager_DispatchEvent(name, params);
	}
}
