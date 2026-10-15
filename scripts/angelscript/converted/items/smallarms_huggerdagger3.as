#pragma context server

// Converted from items/smallarms_huggerdagger3.script by msc_transpiler.
// Dull Hugger Dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_huggerdagger.as"

[script "items/smallarms_huggerdagger3"]
class SmallarmsHuggerdagger3 : SmallarmsHuggerdaggerScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsHuggerdagger3()
	{
		MELEE_DMG = 220;
		MELEE_RANGE = "35";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsHuggerdagger_OnWeaponSpawn(); // items/smallarms_huggerdagger

		SetName("Sharp Hugger Dagger");
		SetDescription("A dagger only useful if you're close enough to give the enemy a big warm hug");
		SetWeight(1);
		SetValue(60);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsHuggerdaggerScript::DispatchEvent(name, params);
	}
}
