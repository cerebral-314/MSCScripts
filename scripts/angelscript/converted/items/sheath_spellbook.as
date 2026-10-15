#pragma context server

// Converted from items/sheath_spellbook.script by msc_transpiler.
// Spellbook by Thothie (from sheath_back), for new spell system

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_spellbook"]
class SheathSpellbook : SheathBaseScript
{
	// Constants
	string ANIM_PREFIX = "evilbook";

	// Variables declared by included files, with the value they start with in this script
	SheathSpellbook()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 200;
		CONTAINER_MAXITEMS = 40;
		CONTAINER_ITEM_ACCEPT = "scroll2";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "6";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		PackBase_OnGameDeploy(); // items/pack_base

		SetViewModel("MODEL_VIEW_BOOK");
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += ItemHandIndex();
		SetModelBody(0, int(submodel));
	}

	// sheath_spawn
	void OnSheathSpawn()
	{
		SetName("Spellbook");
		SetDescription("A book of shadows, designed to hold spell scrolls.");
		SetWeight(1);
		SetValue(40);
		SetWearable(1, "belt");
		SetHudSprite("trade", "ebook");
	}

	// game_fall
	void OnGameFall()
	{
		SetModel("misc/p_misc.mdl");

		float submodel = Float(MODEL_BODY_OFS);
		submodel += 2.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// sheath_wear
	// may need to override set_body
	void OnSheathWear()
	{
		SetModel("none");
		OwnerMessage("You affix a spellbook to your belt.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "sheath_spawn") { OnSheathSpawn(); return true; }
		if (name == "sheath_wear") { OnSheathWear(); return true; }
		return SheathBaseScript::DispatchEvent(name, params);
	}
}
