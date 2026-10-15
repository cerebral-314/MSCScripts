#pragma context server

// Converted from items/mana_font.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

[script "items/mana_font"]
class ManaFont : BaseDrinkScript
{
	// Constants
	string SOUND_DRINK = "items/drink.wav";

	// Variables declared by included files, with the value they start with in this script
	ManaFont()
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
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// unnamed block (first think)
	void ManaFont_FirstThink()
	{
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Mana Font Potion");
		SetDescription("This potion grants rapid mana regeneration, for a time");
		SetWeight(1);
		SetValue(1000);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// drink_effect
	void OnDrinkEffect()
	{
		Effect("screenfade", ENT_OWNER, 2.0f, 0.5f, Vector3(0, 0, 255), 255, "fadeout");
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 256, 1.0f, 1.0f);
		// callexternal ent_owner ext_mana_font_start 25
		CallExternal(ENT_OWNER, "ext_set_status_flag", "mana_pot", "mana_regen", 1, -1, "The mana font potion effect expires.");
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
		ManaFont_FirstThink();
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
