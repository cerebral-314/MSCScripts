#pragma context server

// Converted from items/item_runicsymbol2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_runicsymbol2"]
class ItemRunicsymbol2 : BaseMiscitemScript
{
	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Glowing Urdual Title Ring");
		SetDescription("This faintly glowing ring has runes that read ZAHLON ERSTE");
		SetWeight(7);
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
