#pragma context server

// Converted from items/axes_golden.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_golden_ref.as"

[script "items/axes_golden"]
class AxesGolden : AxesGoldenRefScript
{
	// Variables declared by included files, with the value they start with in this script
	AxesGolden()
	{
		THIS_NO_BREAK = false;
		FINAL_VALUE = 4000;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesGoldenRef_OnWeaponSpawn(); // items/axes_golden_ref

		SetName("Golden Axe");
		SetHudSprite("trade", "111");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesGoldenRefScript::DispatchEvent(name, params);
	}
}
