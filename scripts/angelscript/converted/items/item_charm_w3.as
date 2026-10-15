#pragma context server

// Converted from items/item_charm_w3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/item_charm_w1.as"

[script "items/item_charm_w3"]
class ItemCharmW3 : ItemCharmW1Script
{
	// Variables declared by included files, with the value they start with in this script
	ItemCharmW3()
	{
		SKILL_LEVEL_REQ = 12;
		PET_SEARCH = "wolf_shadow";
		PET_MAXHP = 500;
		PET_FAIL_MESSAGE = "No weakened shadow wolves in range.";
		PET_YAY_MESSAGE = "You now have a new pet shadow wolf!";
	}

	// crystal_spawn
	void OnCrystalSpawn()
	{
		SetName("Shadow Wolf Charm");
		SetDescription("This crystal can be used to tame one shadow wolf");
		SetWeight(5);
		SetValue(750);
		SetHand("both");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "crystal_spawn") { OnCrystalSpawn(); return true; }
		return ItemCharmW1Script::DispatchEvent(name, params);
	}
}
