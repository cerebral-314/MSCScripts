#pragma context server

// Converted from items/blunt_granitemace.script by msc_transpiler.
// Thothie - Nerfed this a bit, available in Keledros2

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_mace.as"

[script "items/blunt_granitemace"]
class BluntGranitemace : BluntMaceScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGranitemace()
	{
		BASE_LEVEL_REQ = "12";
		MELEE_DMG = 230;
		MELEE_DMG_RANGE = 140;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntMace_OnWeaponSpawn(); // items/blunt_mace

		SetName("Granite Mace");
		SetDescription("A heavy granite mace");
		SetWeight(60);
		SetValue(800);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntMaceScript::DispatchEvent(name, params);
	}
}
