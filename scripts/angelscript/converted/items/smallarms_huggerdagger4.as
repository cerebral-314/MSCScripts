#pragma context server

// Converted from items/smallarms_huggerdagger4.script by msc_transpiler.
// Perfect Hugger Dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_huggerdagger.as"

[script "items/smallarms_huggerdagger4"]
class SmallarmsHuggerdagger4 : SmallarmsHuggerdaggerScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsHuggerdagger4()
	{
		BASE_LEVEL_REQ = "15";
		MELEE_DMG = 240;
		MELEE_ACCURACY = "85%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsHuggerdagger_OnWeaponSpawn(); // items/smallarms_huggerdagger

		SetName("Perfect Hugger Dagger");
		SetDescription("A dagger only useful if you're close enough to give the enemy a big warm hug");
		SetWeight(1);
		SetValue(500);
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
