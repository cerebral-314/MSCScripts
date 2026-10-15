#pragma context server

// Converted from items/axes_base_onehanded.script by msc_transpiler.
// One handed axe
// Uses ANIM_ATTACK1-3

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesBaseOnehanded
{
	// Constants
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	int ATTACK_ANIMS = 3;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string MODEL_HANDS = "MODEL_HANDS";
	string PLAYERANIM_AIM = "axe_onehand";
	string PLAYERANIM_SWING = "axe_onehand_swing";
	string SOUND_HITWALL1 = "weapons/axemetal1.wav";
	string SOUND_HITWALL2 = "weapons/axemetal2.wav";

	// melee_start
	void AxesBaseOnehanded_OnMeleeStart()
	{
		int swing = RandomInt(1, ATTACK_ANIMS);
		int swingAnim = Int(ANIM_ATTACK1);
		if (swing == 2)
			swingAnim = Int(ANIM_ATTACK2);
		else if (swing == 3)
			swingAnim = Int(ANIM_ATTACK3);
		else if (swing == 4)
			swingAnim = 0;
		else if (swing == 5)
			swingAnim = 0;

		PlayViewAnim(swingAnim);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesBaseOnehanded_OnMeleeStart();
	}

	// This file's events and timers by their .script names
	bool AxesBaseOnehanded_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "melee_start") { OnMeleeStart(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_base_onehanded"]
shared class AxesBaseOnehandedScript : BaseMeleeScript, AxesBaseOnehanded
{
	// Variables every script that includes this file declares
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	float MELEE_ATK_DURATION = 0.0f;
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "MELEE_DMG_TYPE";
	float MELEE_ENERGY = 0.0f;
	string MELEE_PARRY_CHANCE = "MELEE_PARRY_CHANCE";
	string MELEE_RANGE = "MELEE_RANGE";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_STAT = "MELEE_STAT";
	int MODEL_VIEW_IDX = 0;
	string SOUND_SWIPE = "SOUND_SWIPE";

	// Variables declared by included files, with the value they start with in this script
	AxesBaseOnehandedScript()
	{
		ANIM_IDLE1 = "1";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		PLAYERANIM_AIM = "axe_onehand";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesBaseOnehanded_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
