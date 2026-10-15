#pragma context server

// Converted from items/pack_bank.script by msc_transpiler.
// Attempts to make a pack, that removes all weight from things put into it, but can only be opened/closed...
// - near a bank teller.

#include "runtime/ScriptEntity.as"

[script "items/pack_bank"]
class PackBank : ScriptEntity
{
	// Constants
	string MODEL_VIEW = "none";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "armor/packs/p_packs.mdl";
	string MODEL_WEAR = "armor/packs/p_packs.mdl";
	string BANK_NAME = "Edana";
	string CONTAINER_TYPE = "generic";
	int CONTAINER_SPACE = 200;
	int CONTAINER_MAXITEMS = 32;
	string CONTAINER_ITEM_REJECT = "sheath;pack;bolt;arrow;health;mana_mpotion";
	string MODEL_BODY_OFS = "6";
	string ANIM_PREFIX = "none";

	// Variables (an unset .script variable reads as its own name)
	string TRUE_ACCEPT = "";

	// pack_spawn
	void OnPackSpawn()
	{
		SetName(BANK_NAME + " Bank Signet");
		SetDescription("This ticket gives access to your Edana bank account.");
		SetWeight(0);
		SetValue(5000);
		SetWearable(1, "leftfinger");
		SetHudSprite("trade", "ring");
	}

	// pack_deploy
	void OnPackDeploy()
	{
		SetViewModel("none");
	}

	// pack_wear
	void OnPackWear()
	{
		OwnerMessage("You put on your " + BANK_NAME + " bank signet ring.");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		int containerLockStrength = 0;
		bool containerCanclose = false;

		SetWorldModel(MODEL_WORLD);
		SetHand("any");

		OnPackSpawn();

		TRUE_ACCEPT = "";

		if (MapName() == "edana")
		{
			containerLockStrength = 0;
			containerCanclose = false;
		}

		if (MapName() != "edana")
		{
			containerLockStrength = 10000;
			containerCanclose = true;
		}

		SetLocal("reg.container.type", CONTAINER_TYPE);
		SetLocal("reg.container.space", CONTAINER_SPACE);
		SetLocal("reg.container.canclose", containerCanclose);
		SetLocal("reg.container.lock_str", containerLockStrength);
		SetLocal("reg.container.accept_mask", TRUE_ACCEPT);
		SetLocal("reg.container.reject_mask", CONTAINER_ITEM_REJECT);
		SetLocal("reg.container.maxitem", CONTAINER_MAXITEMS); // maxitem singular, not plural
		LegacyCommand("registercontainer");
	}

	// game_deploy
	void OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);

		OnPackDeploy();
	}

	// game_fall
	void OnGameFall()
	{
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 1.0f;
		string anim = ANIM_PREFIX + "_floor_idle";

		SetModelBody(0, int(submodel));
		PlayAnim(anim);

		OnPackFall();
	}

	// game_pickup
	void OnGamePickup()
	{
		float submodel;

		SetModel(MODEL_HANDS);
		if (MODEL_HANDS == "misc/p_misc.mdl")
			submodel = 16.0f;
		else
			submodel = Float(MODEL_BODY_OFS);
		submodel -= ItemHandIndex();
		SetModelBody(0, int(submodel));

		PlayViewAnim(0);
		OnPackPickup();
	}

	// game_playeractivate
	void OnGamePlayeractivate()
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
	void OnGameOpencontainer()
	{
		OnPackOpencontainer();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		SetModel(MODEL_WEAR);
		SetModelBody(0, Int(MODEL_BODY_OFS));

		OnPackWear();
	}

	// game_container_addeditem
	void OnGameContainerAddeditem(string item = "")
	{
		OwnerMessage("Added " + item + " to " + BANK_NAME + " bank");
		int inItemWeight = Int(GetProp(item, "weight"));
		SetWeight(-inItemWeight);
	}

	// game_container_removeditem
	void OnGameContainerRemoveditem(CBaseEntity@ item = null)
	{
		OwnerMessage("Removed " + EntityId(item) + " from " + BANK_NAME + " bank");
		int outItemWeight = Int(GetProp(item, "weight"));
		SetWeight(outItemWeight);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnPackFall() {} // pack_fall
	void OnPackOpencontainer() {} // pack_opencontainer
	void OnPackPickup() {} // pack_pickup
	void OnPackPlayeractivate() {} // pack_playeractivate

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
		if (name == "game_container_addeditem") { OnGameContainerAddeditem(Param(params, 0)); return true; }
		if (name == "game_container_removeditem") { OnGameContainerRemoveditem(EntityParam(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_opencontainer") { OnGameOpencontainer(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_playeractivate") { OnGamePlayeractivate(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		if (name == "pack_wear") { OnPackWear(); return true; }
		return false;
	}
}
