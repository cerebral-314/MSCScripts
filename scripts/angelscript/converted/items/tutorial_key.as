#pragma context server

// Converted from items/tutorial_key.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/tutorial_key"]
class TutorialKey : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	TutorialKey()
	{
		MODEL_BODY_OFS = "13";
		ANIM_PREFIX = "rustedkey";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Old key");
		SetDescription("Maybe this key will open the door in the previous room");
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
