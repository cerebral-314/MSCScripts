#pragma context server

// Converted from items/item_sewernote.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_sewernote"]
class ItemSewernote : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemSewernote()
	{
		MODEL_WORLD = "garbagegibs.mdl";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Note");
		SetDescription("A molded note with strange writings on it");
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
