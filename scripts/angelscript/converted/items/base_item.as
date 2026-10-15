#pragma context server

// Converted from items/base_item.script by msc_transpiler.
// 6:01 AM 2/2/2005
// Items
// REQ:
// ANIM_LIFT1
// MODEL_VIEW
// MODEL_HANDS
// MODEL_WORLD

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseItem
{
	// Constants
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "0";
	string ANIM_IDLE2 = "0";
	string ANIM_IDLE3 = "0";
	int ANIM_IDLE4 = 0;
	int ANIM_IDLE5 = 0;
	int ANIM_IDLE_DELAY_LOW = 2;
	int ANIM_IDLE_DELAY_HIGH = 5;
	string PLAYERANIM_AIM = "blunt";

	// Variables (an unset .script variable reads as its own name)
	float BI_IDLE_PENDING = 0.0f;

	// unnamed block (first think)
	void BaseItem_FirstThink()
	{
		SetVar("baseitem.canidle", 1); // Changes
		BI_IDLE_PENDING = 0.0f;
	}

	// game_spawn
	void BaseItem_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (Truthy(GetVar("IS_MAGIC_HAND")))
			return;

		SetAnimExtension(PLAYERANIM_AIM);

		SetWorldModel(GetVar("MODEL_WORLD"));
		OnItemSpawn();
	}

	// game_pickup
	void BaseItem_OnGamePickup()
	{
		if (Truthy(GetVar("IS_MAGIC_HAND")))
			return;

		PlayViewAnim(ANIM_LIFT1);

		SetModel(GetVar("MODEL_HANDS"));
		SetModelBody(0, ItemHandIndex());

		OnItemPickup();
	}

	// game_deploy
	void BaseItem_OnGameDeploy()
	{
		if (Truthy(GetVar("IS_WEAPON")))
			return;
		if (Truthy(GetVar("IS_MAGIC_HAND")))
			return;

		// temporary debug
		// dbg game_deploy $get(ent_me,itemname)
		SetViewModel(GetVar("MODEL_VIEW"));

		OnItemDeploy();

		// popup setviewmodelprop MODEL_VIEW_IDX
		if (!(Float(GetVar("ITEM_MODEL_VIEW_IDX")) > 0.0f))
			return;
		CallEventDelayed(0.1f, "bi_setup_model");
	}

	// game_switchhands
	void BaseItem_OnGameSwitchhands()
	{
		if (Truthy(GetVar("IS_MAGIC_HAND")))
			return;

		PlayViewAnim(Int(ANIM_IDLE1));

		OnItemSwitchhands();
	}

	// game_drop
	void BaseItem_OnGameDrop()
	{
		OnItemDrop();
	}

	// game_attack_cancel
	void BaseItem_OnGameAttackCancel()
	{
		OnGameViewanimdone();
	}

	// game_viewanimdone
	void BaseItem_OnGameViewanimdone(string value = "")
	{
		if (!(Float(GetVar("ANIM_IDLE_TOTAL")) > 0.0f))
			return;

		CallEventDelayed(RandomInt(ANIM_IDLE_DELAY_LOW, ANIM_IDLE_DELAY_HIGH), "item_idle");
	}

	// item_idle
	void BaseItem_OnItemIdle()
	{
		// (never true here, the rest is skipped) if game.clientside
	}

	// bi_idle_fallback
	void BaseItem_OnBiIdleFallback()
	{
		BI_IDLE_PENDING -= 1.0f;
		if (!(BI_IDLE_PENDING <= 0.0f))
			return;
		BI_IDLE_PENDING = 0.0f;
		OnItemIdle();
	}

	// bi_setup_model
	// { [server] set_new_owner
	// if ( ITEM_CURRENT_OWNER isnot $get(ent_owner,id) ) callevent log_item_exchange ITEM_CURRENT_OWNER $get(ent_owner,id)
	// if ( $get(ITEM_CURRENT_OWNER,isplayer) )
	// {
	// if ( ITEM_CURRENT_OWNER isnot $get(ent_owner,id) )
	// {
	// //trasnfered ownership from one player to another
	// if ( G_DEVELOPER_MODE ) gplayermessage ent_owner Old Owner $get(ITEM_CURRENT_OWNER,name) new owner $get(ent_owner,name)
	// consolemsg ent_owner Ownership confirmed for: $get(ent_me,name)
	// gplayermessage ent_owner New ownership confirmed for: $get(ent_me,name)
	// }
	// }
	// setvard ITEM_CURRENT_OWNER $get(ent_owner,id)
	// if ( G_DEVELOPER_MODE ) messageall green $get(ent_me,name) set owner: $get(ITEM_CURRENT_OWNER,name)
	// }
	void BaseItem_OnBiSetupModel()
	{
		if (!IsInHand(ENT_ME))
			return;
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), GetVar("ITEM_MODEL_VIEW_IDX"));
		CallEventDelayed(1.0f, "bi_setup_model2");
	}

	// bi_setup_model2
	void BaseItem_OnBiSetupModel2()
	{
		if (!IsInHand(ENT_ME))
			return;
		DebugPrint("bi_setup_model2");
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), GetVar("ITEM_MODEL_VIEW_IDX"));
	}

	// bitem_set_can_idle
	void BaseItem_OnBitemSetCanIdle()
	{
		SetVar("baseitem.canidle", 1);
		OnItemIdle();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy();
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseItem_OnGameDrop();
	}

	void OnGamePickup() { BaseItem_OnGamePickup(); } // game_pickup
	void OnGameSwitchhands() { BaseItem_OnGameSwitchhands(); } // game_switchhands
	void OnGameAttackCancel() { BaseItem_OnGameAttackCancel(); } // game_attack_cancel
	void OnGameViewanimdone(string value = "") { BaseItem_OnGameViewanimdone(value); } // game_viewanimdone
	void OnItemIdle() { BaseItem_OnItemIdle(); } // item_idle
	void OnBiIdleFallback() { BaseItem_OnBiIdleFallback(); } // bi_idle_fallback
	void OnBiSetupModel() { BaseItem_OnBiSetupModel(); } // bi_setup_model
	void OnBiSetupModel2() { BaseItem_OnBiSetupModel2(); } // bi_setup_model2
	void OnBitemSetCanIdle() { BaseItem_OnBitemSetCanIdle(); } // bitem_set_can_idle
	void OnItemDeploy() {} // item_deploy
	void OnItemDrop() {} // item_drop
	void OnItemPickup() {} // item_pickup
	void OnItemSpawn() {} // item_spawn
	void OnItemSwitchhands() {} // item_switchhands

	// This file's events and timers by their .script names
	bool BaseItem_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bi_idle_fallback") { OnBiIdleFallback(); return true; }
		if (name == "bi_setup_model") { OnBiSetupModel(); return true; }
		if (name == "bi_setup_model2") { OnBiSetupModel2(); return true; }
		if (name == "bitem_set_can_idle") { OnBitemSetCanIdle(); return true; }
		if (name == "game_attack_cancel") { OnGameAttackCancel(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "game_viewanimdone") { OnGameViewanimdone(Param(params, 0)); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_item"]
shared class BaseItemScript : BaseItemExtrasScript, BaseItem
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseItem_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
