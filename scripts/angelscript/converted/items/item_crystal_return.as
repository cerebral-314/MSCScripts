#pragma context server

// Converted from items/item_crystal_return.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crystal.as"

[script "items/item_crystal_return"]
class ItemCrystalReturn : BaseCrystalScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemCrystalReturn()
	{
		SKILL_TYPE = "skill.spellcasting";
	}

	// crystal_spawn
	void OnCrystalSpawn()
	{
		SetName("Crystal of Return");
		SetDescription("This crystal will return you to the last spawn point.");
		SetWeight(5); // some weight prevent over-stock
		SetValue(50);
		SetHand("both");
	}

	// activate_crystal
	void OnActivateCrystal()
	{
		Effect("screenfade", ENT_OWNER, 2, 0.5f, Vector3(0, 0, 0), 255, "fadein");
		string respawnPoint = ScriptVarOf(ENT_OWNER, "NEW_SPAWN_POS");

		if (respawnPoint != "NEW_SPAWN_POS") // If spawn was relocated, then use the relocated point
			SetOrigin(ENT_OWNER, Vec(respawnPoint));
		else
			LegacyCommand("respawn", ENT_OWNER);

		PlaySound(0, 10, "magic/spawn.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "activate_crystal") { OnActivateCrystal(); return true; }
		if (name == "crystal_spawn") { OnCrystalSpawn(); return true; }
		return BaseCrystalScript::DispatchEvent(name, params);
	}
}
