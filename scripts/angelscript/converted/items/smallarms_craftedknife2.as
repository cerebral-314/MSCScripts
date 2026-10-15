#pragma context server

// Converted from items/smallarms_craftedknife2.script by msc_transpiler.
// Finely crafted knife

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_craftedknife.as"

[script "items/smallarms_craftedknife2"]
class SmallarmsCraftedknife2 : SmallarmsCraftedknifeScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsCraftedknife2()
	{
		BASE_LEVEL_REQ = "9";
		MELEE_DMG = 210;
		MELEE_RANGE = "35";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsCraftedknife_OnWeaponSpawn(); // items/smallarms_craftedknife

		SetName("Finely Crafted Knife");
		SetDescription("A deadly looking dagger of high craftsmanship");
		SetWeight(3);
		SetValue(20);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsCraftedknifeScript::DispatchEvent(name, params);
	}
}
