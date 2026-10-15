#pragma context server

// Converted from items/dev_staff/afflicter.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Afflicter
{
	// Variables (an unset .script variable reads as its own name)
	string AFFLICT_SCRIPT = "effects/dot_fire";
	string AFFLICT_DURATION = "3";
	float AFFLICT_DMG = 3.33f;
	string AFFLICT_SKILL = "swordsmanship";
	string AFFLICT_PARAMS = "none";

	// unnamed block (first think)
	void Afflicter_FirstThink()
	{
		AFFLICT_SCRIPT = "effects/dot_fire";
		AFFLICT_DURATION = "3";
		AFFLICT_DMG = 3.33f;
		AFFLICT_SKILL = "swordsmanship";
		AFFLICT_PARAMS = "none";
	}

	// try_applyeffect
	void Afflicter_OnTryApplyeffect()
	{
		OnFindBeamTarget();

		if (Text(OriginOf(BEAM_TARGET)) == "(0.00,0.00,0.00)")
			return;

		ApplyEffect(BEAM_TARGET, AFFLICT_SCRIPT, AFFLICT_DURATION, @EntityOf(ENT_OWNER), AFFLICT_DMG, AFFLICT_SKILL);
	}

	// set_affliction
	// <dmg_type or debuff> <duration> <dmg> <other params in a token>
	void Afflicter_OnSetAffliction(string dmgType = "", string duration = "", string dmg = "")
	{
		if (dmgType == "fire")
		{
			AFFLICT_SCRIPT = "effects/dot_fire";
			AFFLICT_SKILL = "spellcasting.fire";
		}
		else if (dmgType == "cold")
		{
			AFFLICT_SCRIPT = "effects/dot_cold";
			AFFLICT_SKILL = "spellcasting.ice";
		}
		else if (dmgType == "lightning")
		{
			AFFLICT_SCRIPT = "effects/dot_lightning";
			AFFLICT_SKILL = "spellcasting.lightning";
		}
		else if (dmgType == "holy")
		{
			AFFLICT_SCRIPT = "effects/dot_holy";
			AFFLICT_SKILL = "spellcasting.divination";
		}
		else if (dmgType == "poison")
		{
			AFFLICT_SCRIPT = "effects/dot_poison";
			AFFLICT_SKILL = "spellcasting.affliction";
		}
		else if (dmgType == "acid")
		{
			AFFLICT_SCRIPT = "effects/dot_acid";
			AFFLICT_SKILL = "spellcasting.affliction";
		}

		AFFLICT_DURATION = duration;
		AFFLICT_DMG = Float(dmg);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnTryApplyeffect() { Afflicter_OnTryApplyeffect(); } // try_applyeffect
	void OnSetAffliction(string dmgType = "", string duration = "", string dmg = "") { Afflicter_OnSetAffliction(dmgType, duration, dmg); } // set_affliction
	void OnFindBeamTarget() {} // find_beam_target

	// This file's events and timers by their .script names
	bool Afflicter_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "set_affliction") { OnSetAffliction(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "try_applyeffect") { OnTryApplyeffect(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/afflicter"]
shared class AfflicterScript : ScriptEntity, Afflicter
{
	// Variables every script that includes this file declares
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
	bool PHYSGUN_ON = false;
	float PHYS_KEEP_DIST = 0.0f;
	float REMOVE_DELAY = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Afflicter_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Afflicter_DispatchEvent(name, params);
	}
}
