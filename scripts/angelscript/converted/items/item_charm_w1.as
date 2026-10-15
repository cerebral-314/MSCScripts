#pragma context server

// Converted from items/item_charm_w1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crystal.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemCharmW1
{
	// Constants
	int SKILL_LEVEL_REQ = 0;
	string SKILL_TYPE = "skill.spellcasting";
	string PET_TYPE = "wolf";
	string PET_SEARCH = "wolf";
	int PET_MAXHP = 100;
	string PET_FAIL_MESSAGE = "No wolves in range.";
	string PET_YAY_MESSAGE = "You now have a new pet wolf!";

	// Variables (an unset .script variable reads as its own name)
	bool CRYSTAL_ABORT_USE = false;

	// crystal_spawn
	void ItemCharmW1_OnCrystalSpawn()
	{
		SetName("Wolf Charm");
		SetDescription("This crystal can be used to tame one wolf");
		SetWeight(5);
		SetValue(500);
		SetHand("both");
	}

	// check_use
	void ItemCharmW1_OnCheckUse()
	{
		bool exitSub = false;

		string ownerPets = GetQuestData(ENT_OWNER, "pets");

		if (Contains(ownerPets, PET_TYPE))
		{
			CRYSTAL_ABORT_USE = true;
			PlayerMessageDark(ENT_OWNER, "You can only have one of this type of pet.");
			exitSub = true;
		}
		if (exitSub)
			return;

		CallExternal(ENT_OWNER, "ext_scan_pet", PET_SEARCH);
		string foundPet = ScriptVarOf(ENT_OWNER, "PLR_FOUND_PET");
		if (IsAlive(foundPet))
		{
			if (HealthOf(foundPet) > PET_MAXHP)
			{
				CRYSTAL_ABORT_USE = true;
				PlayerMessageDark(ENT_OWNER, NameOf(foundPet) + " is too strong to be charmed! It must be weakened first!");
				exitSub = true;
			}
			if (!exitSub)
				CallExternal(foundPet, "ext_makepet", @EntityOf(ENT_OWNER));
		}
		else
		{
			CRYSTAL_ABORT_USE = true;
			PlayerMessageDark(ENT_OWNER, PET_FAIL_MESSAGE);
		}
	}

	// activate_crystal
	// from base_crystal
	void ItemCharmW1_OnActivateCrystal()
	{
		CallExternal(EntityOf(ENT_OWNER), "set_spawn_point", "NEW_SPAWN_POS");
		Effect("screenfade", ENT_OWNER, 0.5f, 1, Vector3(255, 255, 255), 255, "fadein");
		InfoMessage(ENT_OWNER, "PET", PET_YAY_MESSAGE);
		PlaySound(0, 10, "magic/spawn.wav");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnCrystalSpawn() { ItemCharmW1_OnCrystalSpawn(); } // crystal_spawn
	void OnCheckUse() { ItemCharmW1_OnCheckUse(); } // check_use
	void OnActivateCrystal() { ItemCharmW1_OnActivateCrystal(); } // activate_crystal

	// This file's events and timers by their .script names
	bool ItemCharmW1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_crystal") { OnActivateCrystal(); return true; }
		if (name == "check_use") { OnCheckUse(); return true; }
		if (name == "crystal_spawn") { OnCrystalSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/item_charm_w1"]
shared class ItemCharmW1Script : BaseCrystalScript, ItemCharmW1
{
	// Variables declared by included files, with the value they start with in this script
	ItemCharmW1Script()
	{
		SKILL_TYPE = "skill.spellcasting";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ItemCharmW1_DispatchEvent(name, params)
			|| BaseCrystalScript::DispatchEvent(name, params);
	}
}
