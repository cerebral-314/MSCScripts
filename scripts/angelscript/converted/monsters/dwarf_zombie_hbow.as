#pragma context server

// Converted from monsters/dwarf_zombie_hbow.script by msc_transpiler.
// still need the new hxbow model in hand

#include "runtime/ScriptEntity.as"
#include "converted/monsters/dwarf_zombie_sbow.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfZombieHbow
{
	// Constants
	int XBOW_TYPE = 0;
	int DMG_XBOW = 60;
	float PBOLT_DURATION = 15.0f;
	string SOUND_XBOW_STRETCH = "weapons/bow/stretch.wav";
	string LANTERN_COLOR = "LANTERN_COLOR";

	// Variables (an unset .script variable reads as its own name)
	string AMMO_TYPE = "AMMO_TYPE";
	bool IS_BLOODLESS = false;
	bool IMMUNE_VAMPIRE = false;
	bool IS_UNHOLY = false;

	// frame_reload_hxbow
	void DwarfZombieHbow_OnFrameReloadHxbow()
	{
		PlaySound(0, 10, SOUND_XBOW_STRETCH);
	}

	// frame_attack_hxbow
	void DwarfZombieHbow_OnFrameAttackHxbow()
	{
		OnBowFire();
	}

	// select_ammo
	// maybe we can get away with random on these
	void DwarfZombieHbow_OnSelectAmmo()
	{
		if (AMMO_TYPE != "unset") // somehow we are getting here, even when set_ammo is run :\
			return;

		int rndType = RandomInt(1, 3);
		if (rndType == 1)
			AMMO_TYPE = "poison";
		if (rndType == 2)
			AMMO_TYPE = "explode";
		if (rndType == 3)
			AMMO_TYPE = "pierce";

		OnAdjustXp();
	}

	// darcher_spawn
	void DwarfZombieHbow_OnDarcherSpawn()
	{
		SetName("Dwarven Zombie Bowman");
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 2);
		SetModelBody(1, 7);
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(300);
		SetRace("undead");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("slash", 1.25f);
		SetHearingSensitivity(8);

		IS_BLOODLESS = true;
		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnFrameReloadHxbow() { DwarfZombieHbow_OnFrameReloadHxbow(); } // frame_reload_hxbow
	void OnFrameAttackHxbow() { DwarfZombieHbow_OnFrameAttackHxbow(); } // frame_attack_hxbow
	void OnSelectAmmo() { DwarfZombieHbow_OnSelectAmmo(); } // select_ammo
	void OnDarcherSpawn() { DwarfZombieHbow_OnDarcherSpawn(); } // darcher_spawn

	// This file's events and timers by their .script names
	bool DwarfZombieHbow_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "darcher_spawn") { OnDarcherSpawn(); return true; }
		if (name == "frame_attack_hxbow") { OnFrameAttackHxbow(); return true; }
		if (name == "frame_reload_hxbow") { OnFrameReloadHxbow(); return true; }
		if (name == "select_ammo") { OnSelectAmmo(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/dwarf_zombie_hbow"]
shared class DwarfZombieHbowScript : DwarfZombieSbowScript, DwarfZombieHbow
{
	// Variables declared by included files, with the value they start with in this script
	DwarfZombieHbowScript()
	{
		XBOW_TYPE = 0;
		DMG_XBOW = 60;
		PBOLT_DURATION = 15.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DwarfZombieHbow_DispatchEvent(name, params)
			|| DwarfZombieSbowScript::DispatchEvent(name, params);
	}
}
