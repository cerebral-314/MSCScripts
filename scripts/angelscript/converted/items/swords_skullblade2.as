#pragma context server

// Converted from items/swords_skullblade2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_skullblade.as"

[script "items/swords_skullblade2"]
class SwordsSkullblade2 : SwordsSkullbladeScript
{
	// Variables declared by included files, with the value they start with in this script
	SwordsSkullblade2()
	{
		MELEE_DMG = 100;
		MELEE_ACCURACY = "50%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsSkullblade_OnWeaponSpawn(); // items/swords_skullblade

		SetName("Dull Skullblade");
		SetDescription("This heavy broad sword has seen one too many battles.");
		SetWeight(80);
		SetValue(100);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsSkullbladeScript::DispatchEvent(name, params);
	}
}
