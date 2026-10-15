#pragma context server

// Converted from items/blunt_base_twohanded.script by msc_transpiler.
// Blunt weapon (two-handed)

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntBaseTwohanded
{
	// Constants
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string PLAYERANIM_AIM = "bluntdouble";
	string PLAYERANIM_SWING = "swing_bluntdouble";
	string SOUND_HITWALL1 = "weapons/xbow_hitbod1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hitbod2.wav";

	// weapon_spawn
	void BluntBaseTwohanded_OnWeaponSpawn()
	{
		SetHand("both");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool BluntBaseTwohanded_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_base_twohanded"]
shared class BluntBaseTwohandedScript : BluntBaseOnehandedScript, BluntBaseTwohanded
{
	// Variables declared by included files, with the value they start with in this script
	BluntBaseTwohandedScript()
	{
		PLAYERANIM_AIM = "bluntdouble";
		PLAYERANIM_SWING = "swing_bluntdouble";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntBaseTwohanded_DispatchEvent(name, params)
			|| BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
