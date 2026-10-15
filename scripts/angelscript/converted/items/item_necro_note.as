#pragma context server

// Converted from items/item_necro_note.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_necro_note"]
class ItemNecroNote : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemNecroNote()
	{
		MODEL_WORLD = "garbagegibs.mdl";
		MODEL_HANDS = "garbagegibs.mdl";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		SetViewModel(MODEL_VIEW);
		PlayAnim(22);
		CallEventDelayed(0.1f, "setup_viewmodel");
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Letter from Venevus");
		SetDescription("Take this key and meet me in my lair, if you dare.");
		SetViewModel(MODEL_VIEW);
		SetHudSprite("trade", "letter");
		SetHand("both");
	}

	// setup_viewmodel
	void OnSetupViewmodel()
	{
		SetViewModelProp(ENT_ME, "submodel", 0, 9);
		PlayItemViewAnim(ENT_ME, 22);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("garbagegibs.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		if (name == "setup_viewmodel") { OnSetupViewmodel(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
