#pragma context server

// Converted from items/blunt_hammer_dorfgan.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_hammer1.as"

[script "items/blunt_hammer_dorfgan"]
class BluntHammerDorfgan : BluntHammer1Script
{
	// Variables declared by included files, with the value they start with in this script
	BluntHammerDorfgan()
	{
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 110;
		MELEE_DMG_RANGE = 90;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntHammer1_OnWeaponSpawn(); // items/blunt_hammer1

		SetName("Dorfgan's Hammer");
		SetDescription("Dorfgan's lost hammer");
		SetWeight(25);
		SetValue(35);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntHammer1Script::DispatchEvent(name, params);
	}
}
