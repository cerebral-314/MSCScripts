#pragma context server

// Converted from items/item_light_crystal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crystal.as"

[script "items/item_light_crystal"]
class ItemLightCrystal : BaseCrystalScript
{
	// Constants
	bool SILENT_DELAY = true;

	// Variables declared by included files, with the value they start with in this script
	ItemLightCrystal()
	{
		SKILL_TYPE = "skill.spellcasting";
	}

	// crystal_spawn
	void OnCrystalSpawn()
	{
		SetName("Light Crystal");
		SetDescription("These crystals of light become less corporeal with age");
		SetWeight(1); // some weight prevent over-stock
		SetValue(10);
		SetHand("both");
		ACTIVE_DELAY = Random(0, 0.5f);
	}

	// activate_crystal
	void OnActivateCrystal()
	{
		// blind owner, all nearby players, make all nearby monsters flee
		// effect screenfade ent_owner 2 3 (255,255,255) 255 fadein
		CallExternal("all", "ext_flash_bang", OriginOf(ENT_OWNER), 128, @EntityOf(ENT_OWNER));
		OwnerMessage(ENT_OWNER + " You break the light crystal!");
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
