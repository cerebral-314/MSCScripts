#pragma context server

// Converted from items/key_crystal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/key_crystal"]
class KeyCrystal : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyCrystal()
	{
		MODEL_WORLD = "misc/item_key_ice.mdl";
		MODEL_HANDS = "misc/item_key_ice.mdl";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Crystal Key");
		SetDescription("This delicate enchanted key reforged from crystal fragments");
		SetHudSprite("trade", "key");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/item_key_ice.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
