#pragma context server

// Converted from items/item_precache.script by msc_transpiler.
// This is for generating fake precaches and seeing how close to the item limit we are
// Note: precache's happen anywhere in this file, so fake ones actually have to be disabled, even though fake_caches event is not called
// NOTE: This will need to be moved into an existing 1.0 script for compatability

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemPrecache
{

	// unnamed block (first think)
	void ItemPrecache_FirstThink()
	{
		// everything used by items not found in 1.0 should be precached here
		// test
		// recache test/ALIEN5.mdl
		// recache test/DarkElfM.mdl
		// recache test/ElfArcherF.mdl
		// merge misc/stunned.mdl (projectiles) - also re-write fx script not spawn NPC
		// real caches
		// recache viewmodels/v_book.mdl
		// recache status.spr
		// recache weapons/blunt/calrainmace_rview.mdl
		// recache holder.mdl
		// recache viewmodels/v_1haxes.mdl
		// recache viewmodels/v_1hblunts.mdl
		// recache viewmodels/v_1hswords.mdl
		// recache viewmodels/v_1hswordssb.mdl
		// recache viewmodels/v_2haxes.mdl
		// recache viewmodels/v_2haxesgreat.mdl
		// recache viewmodels/v_2hblunts.mdl
		// recache viewmodels/v_2hswords.mdl
		// recache viewmodels/v_bows.mdl
		// recache viewmodels/v_martialarts.mdl
		// recache viewmodels/v_martialarts_claws.mdl
		// recache viewmodels/v_misc.mdl
		// recache viewmodels/v_shields.mdl
		// recache viewmodels/v_smallarms.mdl
		// recache weapons/magic/icecage.mdl
		// only if using new models
		// recache metalgibs.mdl
		// sounds (do not count against media limit)  - Im actually not sure about this claim...-greatguys1
		PrecacheFile("chests/base_treasurechest");
		PrecacheFile("monsters/skeleton");

		PrecacheFile("monsters/summon/bear1");
		PrecacheFile("monsters/summon/lesser_wraith");
		PrecacheFile("monsters/wraith_cl");

		PrecacheFile("monsters/companion/pet_wolf");
		PrecacheFile("monsters/companion/pet_wolf_ice");
		PrecacheFile("monsters/companion/pet_wolf_shadow");
	}

	// fake_caches
	void ItemPrecache_OnFakeCaches()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnFakeCaches() { ItemPrecache_OnFakeCaches(); } // fake_caches

	// This file's events and timers by their .script names
	bool ItemPrecache_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "fake_caches") { OnFakeCaches(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/item_precache"]
shared class ItemPrecacheScript : ScriptEntity, ItemPrecache
{
	// Variables every script that includes this file declares
	string ANIM_PREFIX = "ANIM_PREFIX";
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	string MODEL_WORLD = "MODEL_WORLD";
	string PLAYERANIM_AIM = "PLAYERANIM_AIM";

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
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ItemPrecache_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ItemPrecache_DispatchEvent(name, params);
	}
}
