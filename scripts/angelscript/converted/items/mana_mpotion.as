#pragma context server

// Converted from items/mana_mpotion.script by msc_transpiler.
// Thothie - Increased Mana potion Effect - only rich high level people gonna be using these
// - I dun feel like making 3 types
// Mana potion

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/mana_mpotion"]
class ManaMpotion : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables (an unset .script variable reads as its own name)
	float RESTORE_PERCENT = 0.9f;
	int DRINK_EFFECTAMT = 300;

	// Variables declared by included files, with the value they start with in this script
	ManaMpotion()
	{
		ANIM_IDLE = "0";
		ANIM_DRINK = "1";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		MODEL_BODY_OFS = "24";
		ANIM_PREFIX = "mana";
		DRINK_TYPE = "givemana";
		DRINK_AMOUNT = 4;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void ManaMpotion_FirstThink()
	{
		DRINK_TYPE = "givemana";
		RESTORE_PERCENT = 0.9f;
		DRINK_EFFECTAMT = 300;
		DRINK_AMOUNT = 4;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Mana Potion");
		SetDescription("Restores Magical Energies");
		SetWeight(1);
		SetValue(500);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "bpot");
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
		ManaMpotion_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		return BaseDrinkScript::DispatchEvent(name, params);
	}
}
