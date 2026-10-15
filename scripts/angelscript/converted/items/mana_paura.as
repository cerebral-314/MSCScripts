#pragma context server

// Converted from items/mana_paura.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/mana_paura"]
class ManaPaura : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables declared by included files, with the value they start with in this script
	ManaPaura()
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
	void ManaPaura_FirstThink()
	{
		DRINK_AMOUNT = 5;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Poison Aura Potion");
		SetDescription("This potion wreaths you in a poisonous mist");
		SetWeight(1);
		SetValue(1000);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// drink_effect
	void OnDrinkEffect()
	{
		Effect("screenfade", ENT_OWNER, 2.0f, 0.5f, Vector3(255, 0, 0), 255, "fadeout");
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 256, 1.0f, 1.0f);
		float auraDot = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.5f;
		CallExternal(ENT_OWNER, "ext_poison_aura_activate", auraDot, 64);
		CallExternal(ENT_OWNER, "ext_register_element", "paurp", "poison", 50);
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
		ManaPaura_FirstThink();
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
