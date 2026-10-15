#pragma context server

// Converted from items/mana_st.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/mana_st"]
class ManaSt : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables declared by included files, with the value they start with in this script
	ManaSt()
	{
		DRINK_TYPE = "effect";
		MODEL_BODY_OFS = "24";
		ANIM_IDLE = "0";
		ANIM_DRINK = "1";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 2;
		ANIM_PREFIX = "mana";
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void ManaSt_FirstThink()
	{
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Stamina Potion");
		SetDescription("Provides rapid stamina regeneration");
		SetWeight(1);
		SetValue(500);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// drink_effect
	void OnDrinkEffect()
	{
		// callexternal ent_owner ext_nopush_on 1 0
		// scriptflags ent_owner add pot_stability nopush 1 -1 "The stability magic fades..."
		ApplyEffect(ENT_OWNER, "effects/effect_stamina_regen");
		OwnerMessage("You feel as though you have infinite energy.");
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
		ManaSt_FirstThink();
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
