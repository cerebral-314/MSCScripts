#pragma context server

// Converted from items/drink_ale.script by msc_transpiler.
// Was using wrong world model
// Drink Ale

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/drink_ale"]
class DrinkAle : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables (an unset .script variable reads as its own name)
	int DRINK_EFFECTAMT = 0;
	float ALE_DRUNK = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DrinkAle()
	{
		ANIM_IDLE = "0";
		ANIM_DRINK = "3";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 4;
		MODEL_BODY_OFS = "18";
		DRINK_TYPE = "getdrunk";
		DRINK_AMOUNT = 12;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void DrinkAle_FirstThink()
	{
		DRINK_TYPE = "getdrunk";
		DRINK_EFFECTAMT = RandomInt(15, 20);
		DRINK_AMOUNT = 12;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseDrink_OnGameFall(); // items/base_drink

		float submodel = Float(MODEL_BODY_OFS);
		submodel += 2.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// drink_now
	void OnDrinkNow()
	{
		BaseDrink_OnDrinkNow(); // items/base_drink

		ALE_DRUNK += 1.0f;

		if (!(ALE_DRUNK >= 1.0f))
			return;

		ClientEvent("new", ENT_OWNER, "effects/sfx_drunk", Random(4, 11));
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Ale");
		SetDescription("A mug of some bitter ale");
		SetWeight(2);
		SetValue(1);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "243");
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
		DrinkAle_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "drink_now") { OnDrinkNow(); return true; }
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		return BaseDrinkScript::DispatchEvent(name, params);
	}
}
