#pragma context server

// Converted from items/dev_staff/remover.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Remover
{
	// Constants
	float REMOVE_DELAY = 0.15f;

	// Variables (an unset .script variable reads as its own name)
	float LAST_REMOVE = 0.0f;
	string BEAM_TARGET = "BEAM_TARGET";

	// try_remove
	void Remover_OnTryRemove()
	{
		if (!(LAST_REMOVE < GameTime()))
			return;
		OnFindBeamTarget();

		if (BEAM_TARGET == "none")
			return;
		if (IsPlayer(BEAM_TARGET))
			return;

		if (Text(OriginOf(BEAM_TARGET)) == "(0.00,0.00,0.00)")
		{
			PlayerMessageBlue(ENT_OWNER, "Removed map ent.");
			DeleteEntity(BEAM_TARGET, "remove");
		}
		else
		{
			PlayerMessageBlue(ENT_OWNER, "Removed " + FullNameOf(BEAM_TARGET));
			DeleteEntity(BEAM_TARGET);
		}

		LAST_REMOVE = GameTime() + REMOVE_DELAY;
		BEAM_TARGET = "none";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnTryRemove() { Remover_OnTryRemove(); } // try_remove
	void OnFindBeamTarget() {} // find_beam_target

	// This file's events and timers by their .script names
	bool Remover_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "try_remove") { OnTryRemove(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/remover"]
shared class RemoverScript : ScriptEntity, Remover
{
	// Variables every script that includes this file declares
	float AFFLICT_DMG = 0.0f;
	string AFFLICT_DURATION = "AFFLICT_DURATION";
	string AFFLICT_PARAMS = "AFFLICT_PARAMS";
	string AFFLICT_SCRIPT = "AFFLICT_SCRIPT";
	string AFFLICT_SKILL = "AFFLICT_SKILL";
	bool AM_NOCLIPPING = false;
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
	string DAMAGER_DMG = "DAMAGER_DMG";
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MENU_ID = "MENU_ID";
	bool NO_BANK = false;
	string NPC_CLIPBOARD = "NPC_CLIPBOARD";
	bool PHYSGUN_ON = false;
	float PHYS_KEEP_DIST = 0.0f;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Remover_DispatchEvent(name, params);
	}
}
