#pragma context server

// Converted from dq/quests/dq_get_item_from_hands.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is get_item_from_hands. The npc will ask for an item from the player's inventory, which the player must either give it to him or search for the item.
// Vars:
// const QUEST_DATA1		- <"item scriptname;item name"> Which item will the NPC request? The item name is for informational dialogue and menus, it doesn't directly reflect the item being given.
// const QUEST_DATA2		- <quantity> How many of the item? Please have at least 1.
// const QUEST_DATA3		- <quality> Does the item have to have a "quality"? If set to 0, it will be ignored.
// Functions:
// give_item			- PARAM1 = PlayerID, PARAM2 = ItemID	Function called from a menu when player has appropriate item. Redundancy check for proper item is made in here.
// delete_item			- PARAM1 = ItemID	Calls the appropriate functions on the item before deleting it for a smooth transaction,
// func_check_item			- PARAM1 = PlayerID, PARAM2 = ItemID	Function called to check that the item is the appropriate one.
// func_check_ammo_strings		- PARAM1 = ScriptName	Checks if the scriptname contains any string associated with ammo.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqGetItemFromHands
{
	// Constants
	string DQ_ITEM_REQUIREMENT = "DQ_ITEM_REQUIREMENT";
	string DQ_QUALITY_REQUIREMENT = "DQ_QUALITY_REQUIREMENT";
	string DQ_AMMO_STRINGS = "proj_;item_lockpick";

	// Variables (an unset .script variable reads as its own name)
	string DQ_ITEM_NAME = "DQ_ITEM_NAME";
	string DQ_AMMO_REQUIREMENT = "DQ_AMMO_REQUIREMENT";
	string DQ_AMMO_CUR = "DQ_AMMO_CUR";
	string DQ_IS_AMMO = "DQ_IS_AMMO";
	bool FUNC_IS_AMMO = false;

	// unnamed block (first think)
	void DqGetItemFromHands_FirstThink()
	{
		DQ_ITEM_NAME = GetToken(QUEST_DATA1, 1); // setvard because higher scripts cant see lower script consts.
		DQ_AMMO_REQUIREMENT = QUEST_DATA2; // setvard because higher scripts cant see lower script consts.

		DQ_AMMO_CUR = "0";
		DQ_IS_AMMO = "0";
	}

	// game_menu_getoptions
	// PARAM1 = PlayerId
	void DqGetItemFromHands_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		DQ_IS_AMMO = OnFuncCheckAmmoStrings(DQ_ITEM_REQUIREMENT);

		if (QUEST_MODE == QUEST_ACTIVE)
		{
			bool item = false;

			string handLeft = ScriptVarOf(player, "PLR_LEFT_HAND");
			string handRight = ScriptVarOf(player, "PLR_RIGHT_HAND");

			string failureLeftText = OnFuncCheckFailure(player, handLeft);
			int failureLeft = Int(failureLeftText);
			string failureRightText = OnFuncCheckFailure(player, handRight);
			int failureRight = Int(failureRightText);

			string title = DQ_ITEM_NAME;

			if (Float(DQ_AMMO_REQUIREMENT) > 1.0f)
				title += " (" + int(Float(DQ_AMMO_CUR)) + "/" + DQ_AMMO_REQUIREMENT + ")";

			if (failureLeft == 0)
			{
				menuItem.title = title;
				menuItem.type = "callback";
				menuItem.data = handLeft;
				menuItem.callback = "give_item";
				RegisterMenuItem(menuItem);
			}
			else if (failureRight == 0)
			{
				menuItem.title = title;
				menuItem.type = "callback";
				menuItem.data = handRight;
				menuItem.callback = "give_item";
				RegisterMenuItem(menuItem);
			}
			else if (failureLeft > failureRight)
				OnReportFailed(failureLeftText);
			else
				OnReportFailed(failureRightText);

			if (failureLeft != 0 && failureRight != 0)
			{
				menuItem.title = title;
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// give_item
	// PARAM1 = PlayerID	PARAM2 = ItemID
	void DqGetItemFromHands_OnGiveItem(CBasePlayer@ giver = null, string itemString = "", string offerParams = "")
	{
		string failureText = OnFuncCheckFailure(giver, itemString);
		int failure = Int(failureText);
		if (failure == 0)
		{
			SayText(DQ_IS_AMMO);
			if (!Truthy(DQ_IS_AMMO)) // Normal item give routine
			{
				DQ_AMMO_CUR = Text(Float(DQ_AMMO_CUR) + 1.0f);
				OnDeleteItem(itemString);
			}
			else
			{
				// Ammo give routine
				int ammo = QuantityOf(itemString);
				SayText(Text(ammo));
				float diff = ammo - Float(DQ_AMMO_REQUIREMENT);

				if (diff <= 0.0f)
				{
					DQ_AMMO_CUR = Text(Float(DQ_AMMO_CUR) + ammo);
					OnDeleteItem(itemString);
				}
				else
				{
					DQ_AMMO_CUR = DQ_AMMO_REQUIREMENT;
					LegacyCommand("setquantity", itemString, diff);
				}
			}

			if (Float(DQ_AMMO_CUR) == Float(DQ_AMMO_REQUIREMENT))
			{
				OnQuestFinishedCheck();
				CallEventDelayed(0.1f, "open_menu");
			}
		}
		else
		{
			OnReportFailed(failureText);
		}
	}

	// open_menu
	void DqGetItemFromHands_OnOpenMenu()
	{
		OpenMenu(QUEST_TAKER);
	}

	// report_failed
	// PARAM1 = Level to report
	void DqGetItemFromHands_OnReportFailed(string reportLevel = "")
	{
		if (Float(reportLevel) == 1.0f)
			OnFailedExists();
		else if (Float(reportLevel) == 2.0f)
			OnFailedOwner();
		else if (Float(reportLevel) == 3.0f)
			OnFailedScriptname();
		else if (Float(reportLevel) == 4.0f)
			OnFailedQuality();
		else if (Float(reportLevel) == 5.0f)
			OnFailedQuantity();
	}

	// delete_item
	// PARAM1 = ItemID //Pulled from galat's
	void DqGetItemFromHands_OnDeleteItem(string itemToDelete = "")
	{
		CallExternal(itemToDelete, "item_banked"); // Gotta call these so it looks nice on the client
		CallClientItemEvent(itemToDelete, "game_putinpack");
		DeleteEntity(itemToDelete); // Delete the ent
	}

	// func_check_failure
	// PARAM1 = PlayerID	PARAM2 = ItemID	//Returns 0 if no failure found, returns failure level otherwise.
	string DqGetItemFromHands_OnFuncCheckFailure(CBasePlayer@ playerId = null, string itemId = "")
	{
		string result = "";

		int failed = 0;

		result = AppendResult(result, "**clear**");

		if (!Exists(itemId))
			failed = 1;
		else if (OwnerOf(itemId) !is playerId)
			failed = 2;
		else if (ScriptNameOf(itemId) != DQ_ITEM_REQUIREMENT)
			failed = 3;

		if (failed == 0 && Float(DQ_QUALITY_REQUIREMENT) != 0.0f && QualityOf(itemId) != Float(DQ_QUALITY_REQUIREMENT))
			failed = 4;

		if (failed == 0)
		{
			if (Truthy(DQ_IS_AMMO) && QuantityOf(itemId) == 0) // This will fail items that don't have a quantity, for example, arrows with no ammo in it, which can be accomplished by taking arrows out of another player's hands.
				failed = 5;
		}

		result = AppendResult(result, Text(failed));
		return result;
	}

	// func_check_ammo_strings
	// PARAM1 = ScriptName	//Checks if required item is ammo
	string DqGetItemFromHands_OnFuncCheckAmmoStrings(string scriptName = "")
	{
		string result = "";

		FUNC_IS_AMMO = false;

		int count = GetTokenCount(DQ_AMMO_STRINGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckAmmoStrings(scriptName);
		}

		result = AppendResult(result, "**clear**");
		result = AppendResult(result, Text(FUNC_IS_AMMO));
		return result;
	}

	// check_ammo_strings
	// PARAM1 = ScriptName
	void DqGetItemFromHands_OnCheckAmmoStrings(string scriptName = "")
	{
		string ammo = GetToken(DQ_AMMO_STRINGS, loopIteration);

		if (Contains(scriptName, ammo))
			FUNC_IS_AMMO = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		DqBaseQuests_OnGameMenuGetoptions(player); // dq/quests/bases/dq_base_quests
		DqGetItemFromHands_OnGameMenuGetoptions(player);
	}

	void OnGiveItem(CBasePlayer@ giver = null, string itemString = "", string offerParams = "") { DqGetItemFromHands_OnGiveItem(giver, itemString, offerParams); } // give_item
	void OnOpenMenu() { DqGetItemFromHands_OnOpenMenu(); } // open_menu
	void OnReportFailed(string reportLevel = "") { DqGetItemFromHands_OnReportFailed(reportLevel); } // report_failed
	void OnDeleteItem(string itemToDelete = "") { DqGetItemFromHands_OnDeleteItem(itemToDelete); } // delete_item
	string OnFuncCheckFailure(CBasePlayer@ playerId = null, string itemId = "") { return DqGetItemFromHands_OnFuncCheckFailure(playerId, itemId); } // func_check_failure
	string OnFuncCheckAmmoStrings(string scriptName = "") { return DqGetItemFromHands_OnFuncCheckAmmoStrings(scriptName); } // func_check_ammo_strings
	void OnCheckAmmoStrings(string scriptName = "") { DqGetItemFromHands_OnCheckAmmoStrings(scriptName); } // check_ammo_strings
	void OnFailedExists() {} // failed_exists
	void OnFailedOwner() {} // failed_owner
	void OnFailedQuality() {} // failed_quality
	void OnFailedQuantity() {} // failed_quantity
	void OnFailedScriptname() {} // failed_scriptname

	// This file's events and timers by their .script names
	bool DqGetItemFromHands_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_ammo_strings") { OnCheckAmmoStrings(Param(params, 0)); return true; }
		if (name == "delete_item") { OnDeleteItem(Param(params, 0)); return true; }
		if (name == "func_check_ammo_strings") { Return(OnFuncCheckAmmoStrings(Param(params, 0))); return true; }
		if (name == "func_check_failure") { Return(OnFuncCheckFailure(PlayerParam(params, 0), Param(params, 1))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_item") { OnGiveItem(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "open_menu") { OnOpenMenu(); return true; }
		if (name == "report_failed") { OnReportFailed(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_get_item_from_hands"]
shared class DqGetItemFromHandsScript : DqBaseQuestsScript, DqGetItemFromHands
{
	// Variables every script that includes this file declares
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_DATA2 = "QUEST_DATA2";
	string QUEST_DATA3 = "QUEST_DATA3";
	string QUEST_FINISHED_CHAT = "QUEST_FINISHED_CHAT";
	string QUEST_FINISHED_SOUND = "QUEST_FINISHED_SOUND";
	string QUEST_INTRO_CHAT = "QUEST_INTRO_CHAT";
	string QUEST_INTRO_SOUND = "QUEST_INTRO_SOUND";
	float QUEST_PROGRESS_MAX = 0.0f;
	float QUEST_PROGRESS_VAR = 0.0f;
	bool QUEST_REWARD_TAKEN = false;
	bool QUEST_SHOW_PROGRESS = false;
	bool USING_GENERIC_REWARD = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqGetItemFromHands_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqGetItemFromHands_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
