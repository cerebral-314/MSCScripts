#pragma context server

// Converted from items/base_item_extras.script by msc_transpiler.
// ITEM_RESERVE_FOR_STRONGEST 1 - this item can only be picked up by the player with the most damage points when it first drops into the world
// PICKUP_ALLOW_LIST - array stores players allowed to pick up item (if this array exists, item pickup is restricted code side)
// QUEST_ITEM_CAT - quest data slot to store quest item in
// QUEST_ITEM_ID - quest data to store
// - if QUEST_ITEM_ID already exists in QUEST_ITEM_CAT it will not be added again
// - You can use this quest data to determine if the player has EVER had said item
// ======= Reserve items for strongest player

#include "runtime/ScriptEntity.as"
#include "converted/items/item_debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseItemExtras
{
	// Constants
	float BWEAPON_BASE_ANIM_SPEED = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool IS_RESERVED = false;

	// unnamed block (first think)
	void BaseItemExtras_FirstThink()
	{
		ArrayCreate("PICKUP_ALLOW_LIST");
	}

	// game_spawn
	void BaseItemExtras_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(0.1f, "vanish_item"); // Item owner is propogated 0.1 seconds after player is put in world
	}

	// vanish_item
	void BaseItemExtras_OnVanishItem()
	{
		CBaseEntity@ owner = OwnerOf(ENT_ME); // Can't use ent_owner, since item hasn't been placed in players hands yet
		if (Exists(owner))
			SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
	}

	// game_fall
	void BaseItemExtras_OnGameFall()
	{
		// (never true here, the rest is skipped) if ITEM_RESERVE_FOR_STRONGEST
	}

	// bitem_reserve_for_strongest
	void BaseItemExtras_OnBitemReserveForStrongest()
	{
		ITEM_RESERVED = true;
		CallEventDelayed(0.1f, "bitem_get_strongest");
	}

	// game_restricted
	// <player_who_tried_to_pick_me_up>
	void BaseItemExtras_OnGameRestricted(CBasePlayer@ player = null)
	{
		if (!ITEM_RESERVED)
			return;
		DebugPrint("game_restricted");
		string outMsg = "This trophy is reserved for ";
		string itemReserver = GetArray("PICKUP_ALLOW_LIST", "0");
		outMsg += NameOf(itemReserver);
		InfoMessage(player, "Item Damagepoint Restricted", outMsg);
	}

	// bitem_reserve
	// <playerId>
	void BaseItemExtras_OnBitemReserve(string playerId = "")
	{
		ITEM_RESERVED = true;
		ArrayAdd(playerId);
	}

	// bitem_get_strongest
	void BaseItemExtras_OnBitemGetStrongest()
	{
		if (IsAlive(ENT_OWNER))
		{
			ArrayErase("PICKUP_ALLOW_LIST"); // already owned, don't restrict anymore
		}
		else
		{
			CallExternal(GetVar("GAME_MASTER"), "gm_find_strongest_reset");
			string winningPlayer = ScriptVarOf(GetVar("GAME_MASTER"), "THE_CHOSEN_ONE");
			ArrayAdd("PICKUP_ALLOW_LIST", winningPlayer);
			DebugPrint("bitem_get_strongest " + NameOf(winningPlayer));
		}
	}

	// game_deploy
	// ====== Quest Flagged Items
	void BaseItemExtras_OnGameDeploy()
	{
		bool doNotAdd = false;
	}

	// ext_activate_items
	// ============= Wielded
	// include for weapons/items that have an effect only while weilded
	void BaseItemExtras_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		bool bewIsWeilded = false;
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			bewIsWeilded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			bewIsWeilded = true;
		if (!bewIsWeilded)
			return;
		OnBweaponEffectActivate();
	}

	// game_deploy
	void BaseItemExtras_OnGameDeploy_2()
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		OnBweaponEffectActivate();

		CallEventDelayed(0.01f, "bweapon_fixprops");
	}

	// bweapon_fixprops
	void BaseItemExtras_OnBweaponFixprops()
	{
		// restore normal viewmodel props in case was set funky by last weapon
		SetViewModelProp(ENT_ME, "rendermode", 0);
		SetViewModelProp(ENT_ME, "renderamt", 255);
	}

	// game_wear
	void BaseItemExtras_OnGameWear(string race = "", string gender = "", string source = "")
	{
		// if ( game.clientside ) dbg *** cl_game_wear
		OnBweaponEffectRemove();
	}

	// game_putinpack
	// this isn't working (SEP2009 - comment only)
	void BaseItemExtras_OnGamePutinpack()
	{
		CancelAttack();
		// (always true here) if game.serverside
		OnBweaponEffectRemove("game_putinpack");
	}

	// game_remove
	void BaseItemExtras_OnGameRemove()
	{
		// (always true here) if game.serverside
		OnBweaponEffectRemove("game_remove");
	}

	// game_sheath
	void BaseItemExtras_OnGameSheath()
	{
		OnBweaponEffectRemove("game_sheath");
	}

	// game_drop
	void BaseItemExtras_OnGameDrop()
	{
		CancelAttack();
		// (always true here) if game.serverside
		OnBweaponEffectRemove("game_drop");
	}

	// game_deleted
	void BaseItemExtras_OnGameDeleted()
	{
		bool remEffects = false;
		DebugPrint("game_deleted");
		// fuxing the wrong way with this causes problems due to the universal item list that deletes itself
		CancelAttack();
		if (IsInHand(ENT_ME))
			remEffects = true;
		if (IsWorn(ENT_ME))
			remEffects = true;
		if (!remEffects)
			return;
		OnBweaponEffectRemove("game_deleted");
	}

	// ext_render_items
	// ============= Setrender
	// <owner> <rendermode> <renderamt>
	void BaseItemExtras_OnExtRenderItems(CBaseEntity@ owner = null, int renderMode = 0, int renderAmount = 0)
	{
		if (owner !is EntityOf(ENT_OWNER))
			return;
		SetProp(ENT_ME, "rendermode", renderMode);
		SetProp(ENT_ME, "renderamt", renderAmount);
	}

	// ext_playowneranim
	void BaseItemExtras_OnExtPlayowneranim(string animation = "", string value = "", string value2 = "", string value3 = "")
	{
		// dbg playowneranim PARAM1 PARAM2 PARAM3 PARAM4
		// playowneranim	//<once|hold|critical|break> <AnimName> [LegAnimName] [TimeHoldLegAnim] - Play anim on the player model
		PlayOwnerAnim(animation, value, value2, value3);
	}

	// item_banked
	void BaseItemExtras_OnItemBanked()
	{
		// dbg item_banked
		OnGamePutinpack();
	}

	// ext_item_swift_blade
	// <base_speed|remove> <base_stike_delay>
	void BaseItemExtras_OnExtItemSwiftBlade(string baseSpeed = "", string baseStrikeDelay = "")
	{
		DebugPrint("ext_item_swift_blade " + baseSpeed + " " + baseStrikeDelay);
		ITEM_SWIFT_BLADE = true;
		if (baseSpeed != "remove")
		{
			ITEM_BASE_SPEED = baseSpeed;
			ITEM_BASE_STRIKE = baseStrikeDelay;
		}
		else
		{
			ITEM_SWIFT_BLADE = false;
			SetViewModelProp(ENT_ME, "animspeed", 1.0f);
			SetAttackProp(ENT_ME, 0, "delay.end", ITEM_BASE_SPEED);
			SetAttackProp(ENT_ME, 0, "delay.strike", ITEM_BASE_STRIKE);
		}
	}

	// ext_viewanim_test
	void BaseItemExtras_OnExtViewanimTest()
	{
		DebugPrint("ext_viewanim_test");
		SetViewModelProp(ENT_ME, "animspeed", 5.0f);
	}

	// game_deploy
	void BaseItemExtras_OnGameDeploy_3()
	{
		if (!Truthy(GetVar("IS_CONTAINER")))
			return;
		if (IS_RESERVED)
			return;
		IS_RESERVED = true;
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", @EntityOf(ENT_OWNER));
	}

	// game_fall
	void BaseItemExtras_OnGameFall_2()
	{
		if (!Truthy(GetVar("IS_CONTAINER")))
			return;
		if (IS_RESERVED)
			return;
		IS_RESERVED = true;
		ArrayCreate("PICKUP_ALLOW_LIST");
		ArrayAdd("PICKUP_ALLOW_LIST", @EntityOf(ENT_OWNER));
	}

	// game_restricted
	void BaseItemExtras_OnGameRestricted_2(CBasePlayer@ player = null)
	{
		if (!Truthy(GetVar("IS_CONTAINER")))
			return;
		if (!IS_RESERVED)
			return;
		string outMsg = "This container is reserved for ";
		string itemReserver = GetArray("PICKUP_ALLOW_LIST", "0");
		outMsg += NameOf(itemReserver);
		InfoMessage(player, "Item Restricted", outMsg);
	}

	// bweapon_effect_activate
	void BaseItemExtras_OnBweaponEffectActivate()
	{
	}

	// bweapon_effect_remove
	// When item is removed from players hands
	void BaseItemExtras_OnBweaponEffectRemove(string reason = "")
	{
		bool setId = false;
		int hand = -1;
		string handText = Text(hand);

		string id = ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"); // Get if item is left hand
		if (id == EntityId(self) && GetProp(id, "hand_index") == GetProp(ENT_ME, "hand_index"))
		{
			handText = GetProp(id, "hand_index");
			hand = Int(handText);
		}

		id = ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"); // Get if item is Right hand
		if (id == EntityId(self) && GetProp(id, "hand_index") == GetProp(ENT_ME, "hand_index"))
		{
			handText = GetProp(id, "hand_index");
			hand = Int(handText);
		}

		if (!(hand >= 0)) // If item is still wielded then it will have a hand value
			return;
		if (!(hand <= 3)) // This is a valid range of hand values
			return;

		CallExternal(ENT_OWNER, "ext_set_hand_id", handText, 0); // remove hand value
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseItemExtras_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnVanishItem() { BaseItemExtras_OnVanishItem(); } // vanish_item

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall();
		BaseItemExtras_OnGameFall_2();
	}

	void OnBitemReserveForStrongest() { BaseItemExtras_OnBitemReserveForStrongest(); } // bitem_reserve_for_strongest

	// game_restricted
	void OnGameRestricted(CBasePlayer@ player = null)
	{
		BaseItemExtras_OnGameRestricted(player);
		BaseItemExtras_OnGameRestricted_2(player);
	}

	void OnBitemReserve(string playerId = "") { BaseItemExtras_OnBitemReserve(playerId); } // bitem_reserve
	void OnBitemGetStrongest() { BaseItemExtras_OnBitemGetStrongest(); } // bitem_get_strongest

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy();
		BaseItemExtras_OnGameDeploy_2();
		BaseItemExtras_OnGameDeploy_3();
	}

	void OnExtActivateItems(CBaseEntity@ playerId = null) { BaseItemExtras_OnExtActivateItems(playerId); } // ext_activate_items
	void OnBweaponFixprops() { BaseItemExtras_OnBweaponFixprops(); } // bweapon_fixprops
	void OnGameWear(string race = "", string gender = "", string source = "") { BaseItemExtras_OnGameWear(race, gender, source); } // game_wear
	void OnGamePutinpack() { BaseItemExtras_OnGamePutinpack(); } // game_putinpack
	void OnGameRemove() { BaseItemExtras_OnGameRemove(); } // game_remove
	void OnGameSheath() { BaseItemExtras_OnGameSheath(); } // game_sheath
	void OnGameDrop() { BaseItemExtras_OnGameDrop(); } // game_drop
	void OnGameDeleted() { BaseItemExtras_OnGameDeleted(); } // game_deleted
	void OnExtRenderItems(CBaseEntity@ owner = null, int renderMode = 0, int renderAmount = 0) { BaseItemExtras_OnExtRenderItems(owner, renderMode, renderAmount); } // ext_render_items
	void OnExtPlayowneranim(string animation = "", string value = "", string value2 = "", string value3 = "") { BaseItemExtras_OnExtPlayowneranim(animation, value, value2, value3); } // ext_playowneranim
	void OnItemBanked() { BaseItemExtras_OnItemBanked(); } // item_banked
	void OnExtItemSwiftBlade(string baseSpeed = "", string baseStrikeDelay = "") { BaseItemExtras_OnExtItemSwiftBlade(baseSpeed, baseStrikeDelay); } // ext_item_swift_blade
	void OnExtViewanimTest() { BaseItemExtras_OnExtViewanimTest(); } // ext_viewanim_test
	void OnBweaponEffectActivate() { BaseItemExtras_OnBweaponEffectActivate(); } // bweapon_effect_activate
	void OnBweaponEffectRemove(string reason = "") { BaseItemExtras_OnBweaponEffectRemove(reason); } // bweapon_effect_remove

	// This file's events and timers by their .script names
	bool BaseItemExtras_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bitem_get_strongest") { OnBitemGetStrongest(); return true; }
		if (name == "bitem_reserve") { OnBitemReserve(Param(params, 0)); return true; }
		if (name == "bitem_reserve_for_strongest") { OnBitemReserveForStrongest(); return true; }
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "bweapon_fixprops") { OnBweaponFixprops(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "ext_item_swift_blade") { OnExtItemSwiftBlade(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_playowneranim") { OnExtPlayowneranim(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ext_render_items") { OnExtRenderItems(EntityParam(params, 0), Int(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "ext_viewanim_test") { OnExtViewanimTest(); return true; }
		if (name == "game_deleted") { OnGameDeleted(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_remove") { OnGameRemove(); return true; }
		if (name == "game_restricted") { OnGameRestricted(PlayerParam(params, 0)); return true; }
		if (name == "game_sheath") { OnGameSheath(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "item_banked") { OnItemBanked(); return true; }
		if (name == "vanish_item") { OnVanishItem(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_item_extras"]
shared class BaseItemExtrasScript : ItemDebugScript, BaseItemExtras
{
	// Variables declared by included files, with the value they start with in this script
	BaseItemExtrasScript()
	{
		BWEAPON_BASE_ANIM_SPEED = 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseItemExtras_DispatchEvent(name, params)
			|| ItemDebugScript::DispatchEvent(name, params);
	}
}
