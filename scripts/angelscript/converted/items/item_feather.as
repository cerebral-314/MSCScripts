#pragma context server

// Converted from items/item_feather.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/item_precache.as"
#include "converted/items/base_miscitem.as"

[script "items/item_feather"]
class ItemFeather : BaseMiscitemScript, ItemPrecache
{
	// Constants
	string MODEL_OFS = "OFS_GENERIC";

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Hawk Feather");
		SetDescription("A valueable type of feather used for fletchings");
		SetWeight(0.1f);
		SetValue(10);
		SetGravity(0.5f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles2.mdl");
		Precache("poison_cloud.spr");
		Precache("laserbeam.spr");
		Precache("weapons/magic/seals.mdl");
		Precache("3dmflaora.spr");
		Precache("lgtning.spr");
		Precache("fire1_fixed.spr");
		Precache("null.mdl");
		Precache("xsmoke3.spr");
		Precache("weapons/p_weapons1.mdl");
		Precache("weapons/p_weapons2.mdl");
		Precache("weapons/p_weapons3.mdl");
		Precache("weapons/p_weapons4.mdl");
		Precache("glassgibs.mdl");
		Precache("weapons/projectiles.mdl");
		Precache("bigsmoke.spr");
		Precache("fire1_fixed2.spr");
		Precache("misc/p_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ItemPrecache_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return ItemPrecache_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
