#pragma context server

// Converted from items/blunt_granitemaul.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_maul.as"

[script "items/blunt_granitemaul"]
class BluntGranitemaul : BluntMaulScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGranitemaul()
	{
		MELEE_DMG = 320;
		MELEE_DMG_RANGE = 160;
		MELEE_ENERGY = 20.0f;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMaul_OnWeaponSpawn(); // items/blunt_maul

		SetName("Granite Maul");
		SetDescription("A heavy granite maul");
		SetWeight(150);
		SetValue(1100);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntMaulScript::DispatchEvent(name, params);
	}
}
