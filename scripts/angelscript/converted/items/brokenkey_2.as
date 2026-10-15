#pragma context server

// Converted from items/brokenkey_2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/brokenkey_2"]
class Brokenkey2 : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	Brokenkey2()
	{
		MODEL_BODY_OFS = "13";
		ANIM_PREFIX = "rustedkey";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Broken piece of a key (2/3)");
		SetDescription("This seems to be the midsection of a key (piece 2 of 3)");
		SetHudSprite("trade", "key");
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
