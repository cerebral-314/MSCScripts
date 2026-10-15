#pragma context server

// Converted from items/pack_bigsack.script by msc_transpiler.
// Large Sack
// 8:13 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_base.as"

[script "items/pack_bigsack"]
class PackBigsack : PackBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "6";
	string ANIM_PREFIX = "bigsack";

	// Variables declared by included files, with the value they start with in this script
	PackBigsack()
	{
		MODEL_VIEW = "none";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "armor/packs/p_packs.mdl";
		MODEL_WEAR = "armor/packs/p_packs.mdl";
		CONTAINER_TYPE = "generic";
		CONTAINER_SPACE = 200;
		CONTAINER_MAXITEMS = 32;
		CONTAINER_ITEM_REJECT = "polearms;arrow;scroll2;axes;swords;blunt;bows;shields;smallarms;bolt;pack";
	}

	// pack_spawn
	void OnPackSpawn()
	{
		SetName("Big Sack");
		SetDescription("A big sack, worn over the shoulder");
		SetWeight(1);
		SetValue(4);
		SetWearable(1, "shoulder");
		SetHudSprite("trade", "backsheath");
	}

	// pack_deploy
	void OnPackDeploy()
	{
		SetViewModel("none");
	}

	// pack_wear
	void OnPackWear()
	{
		OwnerMessage("You sling a big sack over your shoulder.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("armor/packs/p_packs.mdl");
		Precache("misc/p_misc.mdl");
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
