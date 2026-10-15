#pragma context server

// Converted from items/pack_base.script by msc_transpiler.
// Thothie - Method for 'accept all' screwing with some packs, changed
// - Problem with most multi-reject or mutlti-accept packs is the formatting
// - file pipes are not seperators, and token strings with seperators must be in quotes
// - ie. "arrows;bows;bolts"
// - NOT arrows;bows;bolts NOR arrows|bows|bolts
// - Armor not rendering properly maybe similar issue
// Wearable, openable pack
// Required:
// MODEL_VIEW, MODEL_HANDS, MODEL_WORLD, MODEL_WEAR
// CONTAINER_TYPE, CONTAINER_SPACE, CONTAINER_CANCLOSE, CONTAINER_LOCK_STRENGTH, CONTAINER_ITEM_ACCEPT

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PackBase
{
	// Constants
	bool IS_CONTAINER = true;
	bool BLAH = false;

	// Variables (an unset .script variable reads as its own name)
	string TRUE_ACCEPT = "";

	// game_spawn
	void PackBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWorldModel(MODEL_WORLD);
		SetHand("any");

		OnPackSpawn();

		TRUE_ACCEPT = "";

		if (GetVar("CONTAINER_ITEM_ACCEPT") != "CONTAINER_ITEM_ACCEPT")
			TRUE_ACCEPT = GetVar("CONTAINER_ITEM_ACCEPT");

		SetLocal("reg.container.type", CONTAINER_TYPE);
		SetLocal("reg.container.space", CONTAINER_SPACE);
		SetLocal("reg.container.canclose", CONTAINER_CANCLOSE);
		SetLocal("reg.container.lock_str", CONTAINER_LOCK_STRENGTH);
		SetLocal("reg.container.accept_mask", TRUE_ACCEPT);
		SetLocal("reg.container.reject_mask", CONTAINER_ITEM_REJECT);
		SetLocal("reg.container.maxitem", CONTAINER_MAXITEMS); // maxitem singular, not plural
		LegacyCommand("registercontainer");
	}

	// game_deploy
	void PackBase_OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);

		OnPackDeploy();
	}

	// game_fall
	void PackBase_OnGameFall()
	{
		float submodel = Float(GetVar("MODEL_BODY_OFS"));
		submodel += 1.0f;
		string anim = GetVar("ANIM_PREFIX") + "_floor_idle";

		SetModelBody(0, int(submodel));
		PlayAnim(anim);

		OnPackFall();
	}

	// game_pickup
	void PackBase_OnGamePickup()
	{
		float submodel;

		SetModel(MODEL_HANDS);
		if (MODEL_HANDS == "misc/p_misc.mdl")
			submodel = 16.0f;
		else
			submodel = Float(GetVar("MODEL_BODY_OFS"));
		submodel -= ItemHandIndex();
		SetModelBody(0, int(submodel));

		PlayViewAnim(Int(GetVar("ANIM_IDLE")));
		OnPackPickup();
	}

	// game_playeractivate
	void PackBase_OnGamePlayeractivate()
	{
		if (!Truthy(Eval("game.item.container.open")))
		{
			PlayViewAnim(0);
			OnGameOpencontainer();
		}
		else
		{
			PlayViewAnim(0);
		}

		OnPackPlayeractivate();
	}

	// game_opencontainer
	void PackBase_OnGameOpencontainer()
	{
		OnPackOpencontainer();
	}

	// game_wear
	void PackBase_OnGameWear(string race = "", string gender = "", string source = "")
	{
		SetModel(MODEL_WEAR);
		SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));

		OnPackWear();
	}

	// game_show
	void PackBase_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(MODEL_WEAR);
		SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));
	}

	// game_container_addeditem
	void PackBase_OnGameContainerAddeditem(string item = "")
	{
		// beware this goes off on spawn
		// beware event disabled FEB2008a
		// messageall green game_container_addeditem $get(ent_me,name) PARAM1 PARAM2
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		if (!IsOnGround(ENT_OWNER))
			return;
		MessageAll("green", NameOf(ENT_ME) + " additem " + NameOf(item));
	}

	// game_container_gaveitem
	void PackBase_OnGameContainerGaveitem(string item = "")
	{
		// beware this goes off on spawn1
		// beware event disabled FEB2008a
		// messageall green game_container_gaveitem PARAM2 PARAM2
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		if (!IsOnGround(ENT_OWNER))
			return;
		MessageAll("green", NameOf(ENT_ME) + " gaveitem " + NameOf(item));
	}

	// game_attempt_unlock
	void PackBase_OnGameAttemptUnlock(CBaseEntity@ owner = null)
	{
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		MessageAll("green", NameOf(ENT_ME) + " openby " + NameOf(owner));
	}

	// ext_lock
	void PackBase_OnExtLock()
	{
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		MessageAll("green", NameOf(ENT_ME) + " locked.");
	}

	// ext_unlock
	void PackBase_OnExtUnlock()
	{
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		MessageAll("green", NameOf(ENT_ME) + " unlocked.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		PackBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		PackBase_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		PackBase_OnGameDeploy();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		PackBase_OnGameWear(race, gender, source);
	}

	void OnGamePickup() { PackBase_OnGamePickup(); } // game_pickup
	void OnGamePlayeractivate() { PackBase_OnGamePlayeractivate(); } // game_playeractivate
	void OnGameOpencontainer() { PackBase_OnGameOpencontainer(); } // game_opencontainer
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { PackBase_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnGameContainerAddeditem(string item = "") { PackBase_OnGameContainerAddeditem(item); } // game_container_addeditem
	void OnGameContainerGaveitem(string item = "") { PackBase_OnGameContainerGaveitem(item); } // game_container_gaveitem
	void OnGameAttemptUnlock(CBaseEntity@ owner = null) { PackBase_OnGameAttemptUnlock(owner); } // game_attempt_unlock
	void OnExtLock() { PackBase_OnExtLock(); } // ext_lock
	void OnExtUnlock() { PackBase_OnExtUnlock(); } // ext_unlock
	void OnPackDeploy() {} // pack_deploy
	void OnPackFall() {} // pack_fall
	void OnPackOpencontainer() {} // pack_opencontainer
	void OnPackPickup() {} // pack_pickup
	void OnPackPlayeractivate() {} // pack_playeractivate
	void OnPackSpawn() {} // pack_spawn
	void OnPackWear() {} // pack_wear

	// This file's events and timers by their .script names
	bool PackBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_lock") { OnExtLock(); return true; }
		if (name == "ext_unlock") { OnExtUnlock(); return true; }
		if (name == "game_attempt_unlock") { OnGameAttemptUnlock(EntityParam(params, 0)); return true; }
		if (name == "game_container_addeditem") { OnGameContainerAddeditem(Param(params, 0)); return true; }
		if (name == "game_container_gaveitem") { OnGameContainerGaveitem(Param(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_opencontainer") { OnGameOpencontainer(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_playeractivate") { OnGamePlayeractivate(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/pack_base"]
shared class PackBaseScript : BaseItemExtrasScript, PackBase
{
	// Variables every script that includes this file declares
	bool CONTAINER_CANCLOSE = false;
	string CONTAINER_ITEM_REJECT = "CONTAINER_ITEM_REJECT";
	bool CONTAINER_LOCK_STRENGTH = false;
	int CONTAINER_MAXITEMS = 0;
	int CONTAINER_SPACE = 0;
	string CONTAINER_TYPE = "CONTAINER_TYPE";
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	string MODEL_WEAR = "MODEL_WEAR";
	string MODEL_WORLD = "MODEL_WORLD";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PackBase_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
