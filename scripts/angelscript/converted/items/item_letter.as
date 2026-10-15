#pragma context server

// Converted from items/item_letter.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_letter"]
class ItemLetter : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemLetter()
	{
		MODEL_WORLD = "garbagegibs.mdl";
		MODEL_BODY_OFS = "4";
		ANIM_PREFIX = "oldbook";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Sealed Letter");
		SetDescription("A letter from Hoguld to Willem in Deralia");
		SetHudSprite("trade", "letter");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("garbagegibs.mdl");
		Precache("misc/p_misc.mdl");
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
