#pragma context server

// Converted from items/key_gold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/key_gold"]
class KeyGold : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyGold()
	{
		MODEL_BODY_OFS = "13";
		ANIM_PREFIX = "rustedkey";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Gold Key");
		SetDescription("This key is made of gold");
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
