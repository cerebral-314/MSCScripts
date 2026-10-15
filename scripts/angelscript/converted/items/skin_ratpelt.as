#pragma context server

// Converted from items/skin_ratpelt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/skin_ratpelt"]
class SkinRatpelt : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	SkinRatpelt()
	{
		MODEL_BODY_OFS = "34";
		ANIM_PREFIX = "rat";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Rat Pelt");
		SetDescription("A Rat Pelt");
		SetValue(3);
		SetWeight(1);
		SetHudSprite("trade", "ratpelt");
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
