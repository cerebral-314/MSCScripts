#pragma context server

// Converted from items/sheath_base.script by msc_transpiler.
// Wearable, openable pack
// 5:57 PM 2/16/2005
// Required:
// MODEL_VIEW, MODEL_HANDS, MODEL_WORLD, MODEL_WEAR
// CONTAINER_TYPE, CONTAINER_SPACE, CONTAINER_CANCLOSE, CONTAINER_LOCK_STRENGTH, CONTAINER_ITEM_ACCEPT

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SheathBase
{
	// Constants
	bool IS_CONTAINER = true;
	string MODEL_VIEW = "none";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_WEAR = "armor/packs/sheathes_wear.mdl";

	// pack_spawn
	void SheathBase_OnPackSpawn()
	{
		OnSheathSpawn();
	}

	// pack_deploy
	void SheathBase_OnPackDeploy()
	{
		OnSheathDeploy();
	}

	// game_fall
	void SheathBase_OnGameFall()
	{
		SetModel(MODEL_WORLD);
		SetModelBody(0, 17);
		PlayAnim("package_floor_idle");

		OnSheathFall();
	}

	// pack_pickup
	void SheathBase_OnPackPickup()
	{
		// setmodel	MODEL_HANDS
		// local		L_SUBMODEL 16
		// subtract	L_SUBMODEL game.item.hand_index
		// setmodelbody	0 L_SUBMODEL
		OnSheathPickup();
	}

	// pack_opencontainer
	void SheathBase_OnPackOpencontainer()
	{
		OnSheathOpencontainer();
	}

	// pack_wear
	void SheathBase_OnPackWear()
	{
		OnSheathWear();
	}

	// game_container_addeditem
	void SheathBase_OnGameContainerAddeditem(string item = "")
	{
		OnSetBody();
	}

	// game_container_removeditem
	void SheathBase_OnGameContainerRemoveditem(CBaseEntity@ item = null)
	{
		OnSetBody();
	}

	// set_body
	void SheathBase_OnSetBody()
	{
		float temp = Float(MODEL_BODY_OFS);
		if (Float(Eval("game.item.container.items")) > 0.0f)
		{
			temp -= 1.0f;
			SetModelBody(0, int(temp));
		}
		else
		{
			SetModelBody(0, Int(MODEL_BODY_OFS));
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_container_addeditem
	void OnGameContainerAddeditem(string item = "")
	{
		PackBase_OnGameContainerAddeditem(item); // items/pack_base
		SheathBase_OnGameContainerAddeditem(item);
	}

	void OnPackSpawn() { SheathBase_OnPackSpawn(); } // pack_spawn
	void OnPackDeploy() { SheathBase_OnPackDeploy(); } // pack_deploy
	void OnGameFall() { SheathBase_OnGameFall(); } // game_fall
	void OnPackPickup() { SheathBase_OnPackPickup(); } // pack_pickup
	void OnPackOpencontainer() { SheathBase_OnPackOpencontainer(); } // pack_opencontainer
	void OnPackWear() { SheathBase_OnPackWear(); } // pack_wear
	void OnGameContainerRemoveditem(CBaseEntity@ item = null) { SheathBase_OnGameContainerRemoveditem(item); } // game_container_removeditem
	void OnSetBody() { SheathBase_OnSetBody(); } // set_body
	void OnSheathDeploy() {} // sheath_deploy
	void OnSheathFall() {} // sheath_fall
	void OnSheathOpencontainer() {} // sheath_opencontainer
	void OnSheathPickup() {} // sheath_pickup
	void OnSheathSpawn() {} // sheath_spawn
	void OnSheathWear() {} // sheath_wear

	// This file's events and timers by their .script names
	bool SheathBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_container_addeditem") { OnGameContainerAddeditem(Param(params, 0)); return true; }
		if (name == "game_container_removeditem") { OnGameContainerRemoveditem(EntityParam(params, 0)); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "pack_opencontainer") { OnPackOpencontainer(); return true; }
		if (name == "pack_pickup") { OnPackPickup(); return true; }
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		if (name == "pack_wear") { OnPackWear(); return true; }
		if (name == "set_body") { OnSetBody(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/sheath_base"]
shared class SheathBaseScript : PackBaseScript, SheathBase
{
	// Variables every script that includes this file declares
	string CONTAINER_ITEM_ACCEPT = "CONTAINER_ITEM_ACCEPT";
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";

	// Variables declared by included files, with the value they start with in this script
	SheathBaseScript()
	{
		MODEL_VIEW = "none";
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_WEAR = "armor/packs/sheathes_wear.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/packs/sheathes_wear.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SheathBase_DispatchEvent(name, params)
			|| PackBaseScript::DispatchEvent(name, params);
	}
}
