#pragma context server

// Converted from items/swords_skullblade3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_skullblade.as"

[script "items/swords_skullblade3"]
class SwordsSkullblade3 : SwordsSkullbladeScript
{
	// Variables declared by included files, with the value they start with in this script
	SwordsSkullblade3()
	{
		MELEE_DMG = 225;
		MELEE_ACCURACY = "55%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsSkullblade_OnWeaponSpawn(); // items/swords_skullblade

		SetName("Sharp Skullblade");
		SetDescription("This sword relies more on its weight than its sharp edge.");
		SetValue(330);
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
