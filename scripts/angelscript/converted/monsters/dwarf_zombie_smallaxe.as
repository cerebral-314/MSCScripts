#pragma context server

// Converted from monsters/dwarf_zombie_smallaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/dwarf_zombie_random.as"

[script "monsters/dwarf_zombie_smallaxe"]
class DwarfZombieSmallaxe : DwarfZombieRandomScript
{
	// pick_weapon_type
	void OnPickWeaponType()
	{
		// pick random type (progressively meaner)
		// 0 - Unarmed
		// 1 - Small Axe
		// 2 - Great Axe
		// 3 - Broadsword
		WEAPON_TYPE = "1";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "pick_weapon_type") { OnPickWeaponType(); return true; }
		return DwarfZombieRandomScript::DispatchEvent(name, params);
	}
}
