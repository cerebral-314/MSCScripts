#pragma context server

// Converted from items/base_sheath.script by msc_transpiler.
// Wearable, openable pack
// 5:57 PM 2/16/2005
// Required:
// MODEL_VIEW, MODEL_HANDS, MODEL_WORLD, MODEL_WEAR
// CONTAINER_TYPE, CONTAINER_SPACE, CONTAINER_CANCLOSE, CONTAINER_LOCK_STRENGTH, CONTAINER_ITEM_ACCEPT

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

[script "items/base_sheath"]
class BaseSheath : BaseItemExtrasScript
{
	// Constants
	bool IS_CONTAINER = true;
	string MODEL_VIEW = "none";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_WEAR = "armor/packs/sheathes_wear.mdl";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras

		SetWorldModel(MODEL_WORLD);
		SetHand("any");

		OnSheathSpawn();

		LegacyCommand("registercontainer");
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras

		SetModel(MODEL_WORLD);
		SetModelBody(0, 17);
		PlayAnim("package_floor_idle");

		OnSheathFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras

		SetViewModel(MODEL_VIEW);

		OnSheathDeploy();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras

		SetModel(MODEL_WEAR);
		SetModelBody(0, 0);

		OnSheathWear();
	}

	// game_pickup
	void OnGamePickup()
	{
		SetModel(MODEL_HANDS);
		float submodel = 16.0f - ItemHandIndex();
		SetModelBody(0, int(submodel));

		OnSheathPickup();
	}

	// game_opencontainer
	void OnGameOpencontainer()
	{
		OnSheathOpencontainer();
	}

	// game_show
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(MODEL_WEAR);
		SetModelBody(0, 0);
	}

	// game_container_addeditem
	void OnGameContainerAddeditem(string item = "")
	{
		OnSetBody();
	}

	// game_container_removeditem
	void OnGameContainerRemoveditem(CBaseEntity@ item = null)
	{
		OnSetBody();
	}

	// set_body
	void OnSetBody()
	{
		float temp = 0.0f;
		if (Float(Eval("game.item.container.items")) > 0.0f)
		{
			temp -= 1.0f;
			SetModelBody(0, int(temp));
		}
		else
		{
			SetModelBody(0, 0);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSheathDeploy() {} // sheath_deploy
	void OnSheathFall() {} // sheath_fall
	void OnSheathOpencontainer() {} // sheath_opencontainer
	void OnSheathPickup() {} // sheath_pickup
	void OnSheathSpawn() {} // sheath_spawn
	void OnSheathWear() {} // sheath_wear

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
		if (name == "game_container_addeditem") { OnGameContainerAddeditem(Param(params, 0)); return true; }
		if (name == "game_container_removeditem") { OnGameContainerRemoveditem(EntityParam(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_opencontainer") { OnGameOpencontainer(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "set_body") { OnSetBody(); return true; }
		return BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
