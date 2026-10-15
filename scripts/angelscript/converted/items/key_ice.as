#pragma context server

// Converted from items/key_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/key_ice"]
class KeyIce : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyIce()
	{
		MODEL_WORLD = "misc/item_key_ice.mdl";
		MODEL_HANDS = "misc/item_key_ice.mdl";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Key of Ice");
		SetDescription("This key seems to be made of magical ice");
		SetHudSprite("trade", "163");
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
