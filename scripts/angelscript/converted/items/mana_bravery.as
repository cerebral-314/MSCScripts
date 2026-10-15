#pragma context server

// Converted from items/mana_bravery.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/mana_bravery"]
class ManaBravery : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables declared by included files, with the value they start with in this script
	ManaBravery()
	{
		DRINK_TYPE = "effect";
		ANIM_IDLE = "0";
		ANIM_DRINK = "1";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 2;
		MODEL_BODY_OFS = "39";
		ANIM_PREFIX = "mana";
		DRINK_AMOUNT = 5;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void ManaBravery_FirstThink()
	{
		DRINK_AMOUNT = 5;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Bravery Potion");
		SetDescription("This prevents XP/Gold loss on your next death");
		SetWeight(1);
		SetValue(1000);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// drink_effect
	void OnDrinkEffect()
	{
		CallExternal(ENT_OWNER, "ext_bravery");
		InfoMessage("all", NameOf(ENT_OWNER), "Has downed a Potion of Bravery");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ManaBravery_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "drink_effect") { OnDrinkEffect(); return true; }
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		return BaseDrinkScript::DispatchEvent(name, params);
	}
}
