#pragma context server

// Converted from items/item_coin.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_coin"]
class ItemCoin : BaseMiscitemScript
{
	// Constants
	string MODEL_HOLD = "misc/p_misc.mdl";

	// Variables declared by included files, with the value they start with in this script
	ItemCoin()
	{
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Ancient Dawnhope Coin");
		SetDescription("This coin is an enchanted trinket from ancient times");
		SetPlayerModel(MODEL_HANDS);
		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetWeight(1);
		SetValue(100);
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
