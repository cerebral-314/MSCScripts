#pragma context server

// Converted from NPCs/dwarf_warrior.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/dwarf_pickaxe.as"

[script "NPCs/dwarf_warrior"]
class DwarfWarrior : DwarfPickaxeScript
{
	// dwarf_spawn
	void OnDwarfSpawn()
	{
		SetName("Dwarven Warrior");
		SetModel("dwarf/male1.mdl");
		SetModelBody(1, 0);
		SetProp(ENT_ME, "skin", RandomInt(0, 6));
		SetProp(ENT_ME, "scale", 1.2f);
		SetWidth(38);
		SetHeight(50);
		SetRoam(true);
		SetHealth(700);
		SetRace("human");
		SetHearingSensitivity(8);
		CallEventDelayed(1.0f, "select_weapon");
	}

	// select_weapon
	void OnSelectWeapon()
	{
		if (WEAPON_CHOICE == "WEAPON_CHOICE")
			WEAPON_CHOICE = RandomInt(1, 4);

		SetModelBody(1, Int(WEAPON_CHOICE));

		// not really much difference, but meh
		// axe
		if (Float(WEAPON_CHOICE) == 1.0f)
		{
			ATTACK_DAMAGE = "40";
			ATTACK2_DAMAGE = "150";
			ATTACK2_CHANCE = 15;
		}

		// bigaxe
		if (Float(WEAPON_CHOICE) == 2.0f)
		{
			ATTACK_DAMAGE = "50";
			ATTACK2_DAMAGE = "150";
			ATTACK2_CHANCE = 25;
		}

		// bigsword
		if (Float(WEAPON_CHOICE) == 3.0f)
		{
			ATTACK_DAMAGE = "40";
			ATTACK2_DAMAGE = "150";
			ATTACK2_CHANCE = 15;
		}

		// daxe - noticed there is a duplicate in the model
		if (Float(WEAPON_CHOICE) == 4.0f)
		{
			ATTACK_DAMAGE = "50";
			ATTACK2_DAMAGE = "150";
			ATTACK2_CHANCE = 25;
		}
	}

	// set_weapon
	void OnSetWeapon(string weapon = "")
	{
		DebugPrint("set_weapon " + weapon);
		WEAPON_CHOICE = weapon;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dwarf_spawn") { OnDwarfSpawn(); return true; }
		if (name == "select_weapon") { OnSelectWeapon(); return true; }
		if (name == "set_weapon") { OnSetWeapon(Param(params, 0)); return true; }
		return DwarfPickaxeScript::DispatchEvent(name, params);
	}
}
