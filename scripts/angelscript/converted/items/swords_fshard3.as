#pragma context server

// Converted from items/swords_fshard3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_fshard1.as"

[script "items/swords_fshard3"]
class SwordsFshard3 : SwordsFshard1Script
{
	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded
		SwordsFshard1_OnWeaponSpawn(); // items/swords_fshard1

		SetName("Felewyn Shard III");
		SetDescription("A shard of the legendary Felewyn Blade");
		SetWeight(100);
		SetValue(5000);
		SetHudSprite("trade", "235");

		SetHand("both");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsFshard1Script::DispatchEvent(name, params);
	}
}
