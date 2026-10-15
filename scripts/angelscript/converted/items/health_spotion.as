#pragma context server

// Converted from items/health_spotion.script by msc_transpiler.
// Reviver potion

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/health_spotion"]
class HealthSpotion : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables (an unset .script variable reads as its own name)
	float RESTORE_PERCENT = 0.50f;
	int DRINK_EFFECTAMT = 0;

	// Variables declared by included files, with the value they start with in this script
	HealthSpotion()
	{
		ANIM_IDLE = "0";
		ANIM_DRINK = "1";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 1;
		MODEL_BODY_OFS = "18";
		DRINK_TYPE = "givehealth";
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 5.0f;
	}

	// unnamed block (first think)
	void HealthSpotion_FirstThink()
	{
		DRINK_TYPE = "givehealth";
		RESTORE_PERCENT = 0.50f;
		DRINK_EFFECTAMT = RandomInt(50, 70);
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 5.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Strong Health Potion");
		SetDescription("A restorative potion offering miraculous regeneration of health");
		SetWeight(1);
		SetValue(300);
		SetHudSprite("trade", "mhealth");
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
		HealthSpotion_FirstThink();
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
