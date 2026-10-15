#pragma context server

// Converted from items/blunt_greatmaul.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_maul.as"

[script "items/blunt_greatmaul"]
class BluntGreatmaul : BluntMaulScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGreatmaul()
	{
		MELEE_DMG = 290;
		MELEE_DMG_RANGE = 150;
		MELEE_ENERGY = 11.0f;
		MELEE_ATK_DURATION = 1.5f;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMaul_OnWeaponSpawn(); // items/blunt_maul

		SetName("Great Maul");
		SetDescription("An even heavier maul");
		SetWeight(125);
		SetValue(530);
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
