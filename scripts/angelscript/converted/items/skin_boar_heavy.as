#pragma context server

// Converted from items/skin_boar_heavy.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/skin_boar_heavy"]
class SkinBoarHeavy : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	SkinBoarHeavy()
	{
		MODEL_BODY_OFS = "31";
		ANIM_PREFIX = "boar";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Heavy Boar Skin");
		SetDescription("A heavy boar skin");
		SetWeight(4);
		SetValue(30);
		SetWorldModel(MODEL_WORLD);
		SetPlayerModel(MODEL_HANDS);
		SetViewModel(MODEL_VIEW);
		SetHudSprite("trade", "boarskin");
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
