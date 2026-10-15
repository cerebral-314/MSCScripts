#pragma context server

// Converted from items/dev_staff/copypaste.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Copypaste
{
	// Constants
	int CLIPBOARD_KEEP_DIST = 500;

	// Variables (an unset .script variable reads as its own name)
	string NPC_CLIPBOARD = "none";
	string CLIPBOARD_NAME = "none";
	string CLIPBOARD_DMGMULTI = "1";
	string CLIPBOARD_HPMULTI = "1";
	string CLIPBOARD_ADDPARAMS = "none";
	float CLIPBOARD_ADD_DIST = 0.0f;

	// unnamed block (first think)
	void Copypaste_FirstThink()
	{
		NPC_CLIPBOARD = "none";
		CLIPBOARD_NAME = "none";
		CLIPBOARD_DMGMULTI = "1";
		CLIPBOARD_HPMULTI = "1";
		CLIPBOARD_ADDPARAMS = "none";
		CLIPBOARD_ADD_DIST = 0.0f;
	}

	// copy_target
	void Copypaste_OnCopyTarget()
	{
		bool notarg = false;

		OnFindBeamTarget();

		if (BEAM_TARGET == "none")
			notarg = true;
		if (IsPlayer(BEAM_TARGET))
			notarg = true;

		if (notarg)
		{
			if (NPC_CLIPBOARD != "none")
				PlayerMessageBlue(ENT_OWNER, "Clipboard cleared.");
			NPC_CLIPBOARD = "none";
			return;
		}

		NPC_CLIPBOARD = ScriptNameOf(BEAM_TARGET);
		CLIPBOARD_NAME = ScriptVarOf(BEAM_TARGET, "NEW_NAME");
		CLIPBOARD_DMGMULTI = ScriptVarOf(BEAM_TARGET, "NPC_DMG_MULTI");
		CLIPBOARD_HPMULTI = ScriptVarOf(BEAM_TARGET, "NPC_HP_MULTI");
		CLIPBOARD_ADDPARAMS = ScriptVarOf(BEAM_TARGET, "NPC_DO_EVENTS");

		CLIPBOARD_ADD_DIST = Divide(WidthOf(BEAM_TARGET), 2.0f);

		PlayerMessageBlue(ENT_OWNER, "Copied " + NameOf(BEAM_TARGET) + " " + ScriptNameOf(BEAM_TARGET));
	}

	// paste_target
	void Copypaste_OnPasteTarget()
	{
		if (NPC_CLIPBOARD == "none")
			return;
		float keepDist = CLIPBOARD_KEEP_DIST + CLIPBOARD_ADD_DIST;

		Vector3 pos = RelativePosition(ViewAnglesOf(ENT_OWNER), Vector3(0, keepDist, 0));
		pos += EyePositionOf(ENT_OWNER);

		string spawnPoint = LegacyFunction("get_traceline", EyePositionOf(ENT_OWNER), pos, "worldonly");
		CreateNpc(NPC_CLIPBOARD, Vec(spawnPoint));

		CallExternal(EntityOf(ENT_LASTCREATED), "game_postspawn", CLIPBOARD_NAME, CLIPBOARD_DMGMULTI, CLIPBOARD_HPMULTI, CLIPBOARD_ADDPARAMS);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnCopyTarget() { Copypaste_OnCopyTarget(); } // copy_target
	void OnPasteTarget() { Copypaste_OnPasteTarget(); } // paste_target
	void OnFindBeamTarget() {} // find_beam_target

	// This file's events and timers by their .script names
	bool Copypaste_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "copy_target") { OnCopyTarget(); return true; }
		if (name == "paste_target") { OnPasteTarget(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/copypaste"]
shared class CopypasteScript : ScriptEntity, Copypaste
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
	string DAMAGER_DMG = "DAMAGER_DMG";
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	float LAST_REMOVE = 0.0f;
	string MENU_ID = "MENU_ID";
	bool NO_BANK = false;
	bool PHYSGUN_ON = false;
	float PHYS_KEEP_DIST = 0.0f;
	float REMOVE_DELAY = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Copypaste_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Copypaste_DispatchEvent(name, params);
	}
}
