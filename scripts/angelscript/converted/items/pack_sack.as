#pragma context server

// Converted from items/pack_sack.script by msc_transpiler.
// Newbie Sack
// 5:56 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_base.as"

[script "items/pack_sack"]
class PackSack : PackBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "4";
	string ANIM_PREFIX = "sack";

	// Variables declared by included files, with the value they start with in this script
	PackSack()
	{
		MODEL_VIEW = "none";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "armor/packs/p_packs.mdl";
		MODEL_WEAR = "armor/packs/p_packs.mdl";
		CONTAINER_TYPE = "generic";
		CONTAINER_SPACE = 10;
		CONTAINER_MAXITEMS = 8;
		CONTAINER_ITEM_REJECT = "arrow;axes;blunt;bolts;swords;bows;armor;pack;polearms";
	}

	// pack_spawn
	void OnPackSpawn()
	{
		SetName("Small Sack");
		SetDescription("A small sack, worn on the belt.");
		SetWeight(1);
		SetValue(2);
		SetWearable(1, "belt");
		SetHudSprite("hand", "sheath");
		SetHudSprite("trade", "backsheath");
	}

	// pack_wear
	void OnPackWear()
	{
		OwnerMessageClient("You attach your sack to your belt.");
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
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		if (name == "pack_wear") { OnPackWear(); return true; }
		return PackBaseScript::DispatchEvent(name, params);
	}
}
