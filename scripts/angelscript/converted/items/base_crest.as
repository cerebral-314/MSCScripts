#pragma context server

// Converted from items/base_crest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseCrest
{
	// Constants
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_HOLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "none";
	string MODEL_WEAR = "armor/p_gowns.mdl";
	string MODEL_BODY_OFS = "16";
	string ANIM_PREFIX = "package";

	// Variables (an unset .script variable reads as its own name)
	float FINAL_OFS = 0.0f;
	int ARMOR_MODEL_BODY = -1;

	// game_spawn
	void BaseCrest_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		string ownerRace = "OWNER_RACE";
		string ownerGender = "OWNER_GENDER";

		SetWorldModel(MODEL_WORLD);
		SetHudSprite("trade", "crestedana");
		SetAnimExtension("holditem1");

		FINAL_OFS = MODEL_CREST_OFS - 1.0f; // Get the real submodel since setmodelbody starts at 0

		// setvard FINAL_OFS MODEL_OFS_FEMALE
		SetWeight(0);
		SetWearable(1, "neck");
		SetValue(1200);
		SetModelBody(0, Int(MODEL_BODY_OFS));

		OnCrestSpawn();
		OnRegisterArmor();
	}

	// game_show
	void BaseCrest_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(MODEL_WEAR);
		float reallyFinalOfs = FINAL_OFS;
		SetModelBody(0, int(reallyFinalOfs));
	}

	// register_armor
	void BaseCrest_OnRegisterArmor()
	{
		ARMOR_MODEL_BODY = -1;

		LegacyCommand("registerarmor");
	}

	// game_deploy
	void BaseCrest_OnGameDeploy()
	{
		SetModel(MODEL_HOLD);
		float submodel = Float(MODEL_BODY_OFS);
		submodel -= ItemHandIndex();
		SetModelBody(0, int(submodel));

		OnCrestDeploy();
	}

	// game_fall
	void BaseCrest_OnGameFall()
	{
		SetModel(MODEL_HOLD);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 1.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);

		OnCrestFall();
	}

	// game_removefromowner
	void BaseCrest_OnGameRemovefromowner()
	{
		SetModelBody(0, 0);

		OnCrestRemove();
	}

	// game_drop
	void BaseCrest_OnGameDrop()
	{
		OnGameFall();
	}

	// game_wear
	void BaseCrest_OnGameWear(string race = "", string gender = "", string source = "")
	{
		string ownerRace = "OWNER_RACE";
		string ownerGender = "OWNER_GENDER";

		SetModel(MODEL_WEAR);
		float finalCrestOfs = MODEL_CREST_OFS - 1.0f; // Get the real submodel since setmodelbody starts at 0
		SetModelBody(0, int(finalCrestOfs));

		// weararmor
		OwnerMessageClient("You place the crest over your head.");

		OnCrestRemove();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseCrest_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseCrest_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseCrest_OnGameDeploy();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseCrest_OnGameWear(race, gender, source);
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseCrest_OnGameDrop();
	}

	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { BaseCrest_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnRegisterArmor() { BaseCrest_OnRegisterArmor(); } // register_armor
	void OnGameRemovefromowner() { BaseCrest_OnGameRemovefromowner(); } // game_removefromowner
	void OnCrestDeploy() {} // crest_deploy
	void OnCrestFall() {} // crest_fall
	void OnCrestRemove() {} // crest_remove
	void OnCrestSpawn() {} // crest_spawn

	// This file's events and timers by their .script names
	bool BaseCrest_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "register_armor") { OnRegisterArmor(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_crest"]
shared class BaseCrestScript : BaseItemExtrasScript, BaseCrest
{
	// Variables every script that includes this file declares
	int MODEL_CREST_OFS = 0;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_gowns.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseCrest_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
