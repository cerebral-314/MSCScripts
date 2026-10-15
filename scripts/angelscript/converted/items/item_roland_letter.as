#pragma context server

// Converted from items/item_roland_letter.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_roland_letter"]
class ItemRolandLetter : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemRolandLetter()
	{
		MODEL_BODY_OFS = "45";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Letter from Roland");
		SetDescription("Seems to describe a complex reinforcement procedure for your Golden Axe.");
		SetValue(50);
		SetHudSprite("trade", "letter");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
