#pragma context server

// Converted from items/pack_heavybackpack.script by msc_transpiler.
// Heavy Backpack
// 8:13 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_base.as"

[script "items/pack_heavybackpack"]
class PackHeavybackpack : PackBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "2";
	string ANIM_PREFIX = "backpack";

	// Variables declared by included files, with the value they start with in this script
	PackHeavybackpack()
	{
		MODEL_VIEW = "none";
		MODEL_HANDS = "armor/packs/p_packs.mdl";
		MODEL_WORLD = "armor/packs/p_packs.mdl";
		MODEL_WEAR = "armor/packs/p_packs.mdl";
		CONTAINER_TYPE = "generic";
		CONTAINER_SPACE = 200;
		CONTAINER_MAXITEMS = 32;
		CONTAINER_ITEM_REJECT = "scroll2;shields;pack";
	}

	// pack_spawn
	void OnPackSpawn()
	{
		SetName("Heavy Backpack");
		SetDescription("A heavy backpack, suited for wear and tear");
		SetWeight(3);
		SetValue(50);
		SetWearable(1, "back");
		SetHudSprite("trade", "hvybackpack");
	}

	// pack_deploy
	void OnPackDeploy()
	{
		float mbTemp = ItemHandIndex() - 2.0f + Float(MODEL_BODY_OFS);
		SetModelBody(0, int(mbTemp));
		SetViewModel("none");
	}

	// pack_wear
	void OnPackWear()
	{
		OwnerMessage("You sling a heavy backpack over your shoulder.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("armor/packs/p_packs.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		if (name == "pack_wear") { OnPackWear(); return true; }
		return PackBaseScript::DispatchEvent(name, params);
	}
}
