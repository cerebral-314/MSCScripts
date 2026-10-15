#pragma context server

// Converted from items/item_bulge.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_bulge"]
class ItemBulge : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemBulge()
	{
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Bulge's Ring");
		SetDescription("It looks like... A wedding ring?");

		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetValue(0);
		SetHudSprite("trade", "ring");
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
