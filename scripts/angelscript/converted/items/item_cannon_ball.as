#pragma context server

// Converted from items/item_cannon_ball.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_cannon_ball"]
class ItemCannonBall : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemCannonBall()
	{
		MODEL_BODY_OFS = "66";
		ANIM_PREFIX = "boar";
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Cannon Ball");
		SetDescription("This is a large iron ball for a dwarven flint cannon");
		SetValue(0);
		SetWeight(110);

		SetWorldModel(MODEL_WORLD);
		SetPlayerModel(MODEL_HANDS);
		SetViewModel(MODEL_VIEW);
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
