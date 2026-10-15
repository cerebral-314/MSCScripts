#pragma context server

// Converted from items/drink_wine.script by msc_transpiler.
// Thothie - Was using wrong model ofs (namely none)
// Drink Wine

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/drink_wine"]
class DrinkWine : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables (an unset .script variable reads as its own name)
	int DRINK_EFFECTAMT = 0;
	float ALE_DRUNK = 0.0f;
	bool ALE_DRUNk = false;

	// Variables declared by included files, with the value they start with in this script
	DrinkWine()
	{
		ANIM_IDLE = "0";
		ANIM_DRINK = "3";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 4;
		MODEL_BODY_OFS = "18";
		DRINK_TYPE = "getdrunk";
		DRINK_AMOUNT = 2;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void DrinkWine_FirstThink()
	{
		DRINK_TYPE = "getdrunk";
		DRINK_EFFECTAMT = RandomInt(2, 14);
		DRINK_AMOUNT = 2;
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
		ALE_DRUNk = false;
	}

	// drink_now
	void OnDrinkNow()
	{
		BaseDrink_OnDrinkNow(); // items/base_drink

		ClientEvent("new", ENT_OWNER, "effects/sfx_drunk", Random(1, 10));
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Ascerian Wine");
		SetDescription("A fine cup of some sweet Ascerian wine");
		SetWeight(2);
		SetValue(1);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "243");
		ALE_DRUNK = 0.0f;
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
		DrinkWine_FirstThink();
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
