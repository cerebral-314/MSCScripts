#pragma context server

// Converted from items/mana_flesheater2.script by msc_transpiler.
// Greater Potion of Venom Claws (Slithar's Necrojuice) by CMD June 2010
// Well, cleveryly diguised as a potion, anyway. Runs similar to items/base_crystal

#include "runtime/ScriptEntity.as"
#include "converted/items/mana_flesheater1.as"

[script "items/mana_flesheater2"]
class ManaFlesheater2 : ManaFlesheater1Script
{
	// Variables declared by included files, with the value they start with in this script
	ManaFlesheater2()
	{
		SKILL_REQ = 20;
		AFFLIC_REQ = 20;
		ITEM_TO_GIVE = "blunt_gauntlets_fe2";
	}

	// unnamed block (first think)
	void ManaFlesheater2_FirstThink()
	{
		ABORT_USE = false;

		DRINK_AMOUNT = 1;
	}

	// item_spawn
	void OnItemSpawn()
	{
		ManaFlesheater1_OnItemSpawn(); // items/mana_flesheater1

		SetName("Greater Venom Claw Potion");
		SetDescription("This potion infuses you with power of a Flesheater.");
		SetWeight(1);
		SetValue(3000);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ManaFlesheater2_FirstThink();
		ManaFlesheater1_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "item_spawn") { OnItemSpawn(); return true; }
		return ManaFlesheater1Script::DispatchEvent(name, params);
	}
}
