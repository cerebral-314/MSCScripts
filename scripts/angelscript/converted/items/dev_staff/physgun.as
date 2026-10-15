#pragma context server

// Converted from items/dev_staff/physgun.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Physgun
{
	// Variables (an unset .script variable reads as its own name)
	bool PHYSGUN_ON = false;
	float PHYS_KEEP_DIST = 0.0f;
	string BEAM_TARGET = "BEAM_TARGET";

	// unnamed block (first think)
	void Physgun_FirstThink()
	{
		PHYSGUN_ON = false;
		PHYS_KEEP_DIST = 0.0f;
	}

	// try_physgun
	void Physgun_OnTryPhysgun()
	{
		if (!PHYSGUN_ON)
		{
			OnFindBeamTarget();
			if (BEAM_TARGET != "none" && Text(OriginOf(BEAM_TARGET)) != "(0.00,0.00,0.00)")
			{
				PHYSGUN_ON = true;
				PHYS_KEEP_DIST = Distance(OriginOf(ENT_OWNER), OriginOf(BEAM_TARGET));

				PlayerMessageBlue(ENT_OWNER, "Linked physgun to " + NameOf(BEAM_TARGET));
				OnUpdatePhysgunTarget();
			}
		}
		else
		{
			OnUpdatePhysgunTarget();
		}
	}

	// update_physgun_target
	void Physgun_OnUpdatePhysgunTarget()
	{
		if (!IsAlive(BEAM_TARGET))
		{
			BEAM_TARGET = "none";
			PHYSGUN_ON = false;
			return;
		}

		Vector3 targPos = RelativePosition(ViewAnglesOf(ENT_OWNER), Vector3(0, PHYS_KEEP_DIST, 0));
		targPos += EyePositionOf(ENT_OWNER);

		SetOrigin(BEAM_TARGET, targPos);
		SetVelocity(BEAM_TARGET, Vector3(0, 0, 0));

		Effect("glow", BEAM_TARGET, Vector3(50, 50, 255), 72, 0.2f, 0.2f);
	}

	// target_freeze
	void Physgun_OnTargetFreeze()
	{
	}

	// game_-attack1
	void Physgun_OnGameReleaseAttack1()
	{
		if (!PHYSGUN_ON)
			return;
		PHYSGUN_ON = false;
		BEAM_TARGET = "none";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnTryPhysgun() { Physgun_OnTryPhysgun(); } // try_physgun
	void OnUpdatePhysgunTarget() { Physgun_OnUpdatePhysgunTarget(); } // update_physgun_target
	void OnTargetFreeze() { Physgun_OnTargetFreeze(); } // target_freeze
	void OnGameReleaseAttack1() { Physgun_OnGameReleaseAttack1(); } // game_-attack1
	void OnFindBeamTarget() {} // find_beam_target

	// This file's events and timers by their .script names
	bool Physgun_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_-attack1") { OnGameReleaseAttack1(); return true; }
		if (name == "target_freeze") { OnTargetFreeze(); return true; }
		if (name == "try_physgun") { OnTryPhysgun(); return true; }
		if (name == "update_physgun_target") { OnUpdatePhysgunTarget(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/physgun"]
shared class PhysgunScript : ScriptEntity, Physgun
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
	float LAST_REMOVE = 0.0f;
	string MENU_ID = "MENU_ID";
	bool NO_BANK = false;
	string NPC_CLIPBOARD = "NPC_CLIPBOARD";
	float REMOVE_DELAY = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Physgun_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Physgun_DispatchEvent(name, params);
	}
}
