#pragma context server

// Converted from items/bows_shortbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_shortbow"]
class BowsShortbow : BowsBaseScript
{
	// Constants
	int MODEL_VIEW_IDX = 2;
	int RANGED_FORCE = 1000;
	float RANGED_ENERGY = 3.0f;
	string RANGED_ACCURACY = "4;2";
	float RANGED_POSTFIRE_DELAY = 0.1f;

	// Variables declared by included files, with the value they start with in this script
	BowsShortbow()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_WEAR = "weapons/p_weapons2.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "orcbow";
		ANIM_PREFIX = "orcbow";
		MODEL_BODY_OFS = "40";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseRanged_OnGameDeploy(); // items/base_ranged
		SetViewModelProp(ENT_ME, "submodel", 0, 2);
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Short Bow");
		SetDescription("A short and steady bow");
		SetWeight(40);
		SetValue(15);
		SetHudSprite("trade", "69");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_bows.mdl");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		return BowsBaseScript::DispatchEvent(name, params);
	}
}
