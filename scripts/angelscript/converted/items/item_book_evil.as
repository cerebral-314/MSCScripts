#pragma context server

// Converted from items/item_book_evil.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_book_evil"]
class ItemBookEvil : BaseMiscitemScript
{
	// Constants
	string MODEL_HOLD = "misc/p_misc.mdl";

	// Variables declared by included files, with the value they start with in this script
	ItemBookEvil()
	{
		MODEL_BODY_OFS = "7";
		ANIM_PREFIX = "evilbook";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Evil Book");
		SetDescription("An evil looking book");
		SetPlayerModel(MODEL_HANDS);
		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetWeight(5);
		SetValue(10);
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
