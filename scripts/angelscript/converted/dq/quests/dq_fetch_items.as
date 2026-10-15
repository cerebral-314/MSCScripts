#pragma context server

// Converted from dq/quests/dq_fetch_items.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is fetch_items. When the quest is activated, you either must look for a bunch of items, or one item in a randomly spawned location. Bringing back the items will complete the quest.
// Vars:
// const QUEST_DATA1		- <"info_target prefix"|"(x,y,z);(x,y,z)"> Where do the qitems spawn?
// const QUEST_DATA2		- <"qitem code;qitem name"> Which qitem do you use? What do you wanna name the qitem?
// const QUEST_DATA3		- <0|1> Spawn one item at available random locations, rather than one item at each location.
// const INFO_TARGET_PREFIX	- Inherited from QUEST_DATA1.
// const QITEM_CODE		- The qitem code.
// const QITEM_NAME		- The qitem name.
// setvard QITEM_ORIGIN_AMT	- How many different spawn positions are there?
// setvard QITEMS_FOUND		- How many qitems are found?
// array QITEM_SPAWN_ORIGINS	- The array containing all of the different vectors for spawn points available for qitems.
// Functions:
// The pre-cache thing		- Pre-caches the qitems. I'm not sure if I can safely spell pre-cache :I
// quest_activate			- Calls the event quest_begin_handle_origins
// game_menu_getoptions		- Checks to see if the player has any qitems.
// ext_receive_quest_item		- Called from the game_master when a matching qitem is found.
// quest_begin_handle_origins	- Sees if it's dealing with info_targets or vectors as spawn points for the qitems.
// quest_handle_info_targets	- quest_begin_handle_origins determined that there's info_targets being used as the vectors for qitems to spawn at.
// quest_handle_vectors		- quest_begin_handle_origins determined that straight vectors were being used as the spawn points for qitems.
// quest_populate_origins_loop	- Spawns all the qitems around the map.

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqFetchItems
{
	// Constants
	string INFO_TARGET_PREFIX = "INFO_TARGET_PREFIX";
	string QITEM_CODE = "QITEM_CODE";
	string QITEM_NAME = "QITEM_NAME";
	float ITEM_DROP_MODE = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	float QITEM_ORIGIN_AMT = 0.0f;
	float QITEMS_FOUND = 0.0f;

	// unnamed block (first think)
	void DqFetchItems_FirstThink()
	{
		QITEM_ORIGIN_AMT = 0.0f;
		QITEMS_FOUND = 0.0f;
	}

	// game_precache
	void DqFetchItems_OnGamePrecache()
	{
		PrecacheFile("other/qitem");
	}

	// quest_activate
	// The player id of the menu owner must be passed though to this
	void DqFetchItems_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		OnQuestBeginHandleOrigins();
	}

	// game_menu_getoptions
	// PARAM1 = PlayerID	This will run a check on the array ARRAY_QUEST_ITEMS to check if we have the required amount to complete the quest
	void DqFetchItems_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (QUEST_MODE == "active")
		{
			CallExternal(GetVar("GAME_MASTER"), "ext_check_quest_item", QITEM_CODE, self); // Checks if the qitems are found
		}
	}

	// ext_receive_quest_item
	void DqFetchItems_OnExtReceiveQuestItem(string itemCode = "")
	{
		if (QUEST_TYPE == "fetch_items" && QUEST_MODE == "active")
		{
			QITEMS_FOUND = QITEMS_FOUND + 1.0f;

			if (QITEMS_FOUND == QITEM_ORIGIN_AMT)
				OnQuestFinished();
		}
	}

	// quest_begin_handle_origins
	// Most of the function is influenced from Thothie's fire wyrm pit getter. Thenks bruh
	void DqFetchItems_OnQuestBeginHandleOrigins()
	{
		int count;

		ArrayCreate("QITEM_SPAWN_ORIGINS");

		string infoTargetName = INFO_TARGET_PREFIX + "1"; // This is just a tester to see if it should look for info targets or just take vectors

		CBaseEntity@ infoTargetId = FindByName(infoTargetName);

		if (Exists(infoTargetId))
		{
			OnQuestHandleInfoTargets(); // This cant be on a loop because we don't know exactly how much info_targets they are until we find one that doesn't exist
		}
		else if (StartsWith(QUEST_DATA1, "(")) // If it starts with that it has to be vectors
		{
			QITEM_ORIGIN_AMT = GetTokenCount(QUEST_DATA1);
			count = int(QITEM_ORIGIN_AMT); // I can call this on a loop because I can see how many tokens are in quest_data1
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnQuestHandleVectors();
			}
		}
		else
		{
			DebugPrint("No proper origins were found, fetch_items cannot spawn qitems!");
		}
	}

	// quest_handle_info_targets
	// For organization
	void DqFetchItems_OnQuestHandleInfoTargets()
	{
		string infoTargetName = INFO_TARGET_PREFIX;
		float qitemOriginAmt = QITEM_ORIGIN_AMT;
		qitemOriginAmt = int(qitemOriginAmt + 1.0f); // $math tends to add .00 at the end. It'll try to look for .00 in the info target if I don't do $int
		infoTargetName += Text(qitemOriginAmt);

		CBaseEntity@ infoTargetId = FindByName(infoTargetName);

		if (Exists(infoTargetId))
		{
			ArrayAdd("QITEM_SPAWN_ORIGINS", OriginOf(infoTargetId));
			QITEM_ORIGIN_AMT = QITEM_ORIGIN_AMT + 1.0f;

			CallEventDelayed(0.1f, "quest_handle_info_targets");
		}
		else
		{
			OnQuestPopulateOrigins();
		}
	}

	// quest_handle_vectors
	// For organization
	void DqFetchItems_OnQuestHandleVectors()
	{
		ArrayAdd("QITEM_SPAWN_ORIGINS", GetToken(QUEST_DATA1, loopIteration));

		if (loopIteration + 1.0f == QITEM_ORIGIN_AMT)
			OnQuestPopulateOrigins();
	}

	// quest_populate_origins
	// Checks the "mode" to see if one should be placed at a random location, or all at all locations
	void DqFetchItems_OnQuestPopulateOrigins()
	{
		int count;

		if (ITEM_DROP_MODE == 1.0f) // This means drop 1 item at a random location
		{
			int origin = RandomInt(0, int(QITEM_ORIGIN_AMT - 1.0f)); // The subtract because 0 is an index and QITEM_ORIGIN_AMT doesn't account for this
			CreateNpc("other/qitem", Vec(Text(origin)), QITEM_CODE, QITEM_NAME);
			QITEM_ORIGIN_AMT = 1.0f; // So the checking the required items works out alright
		}
		else if (ITEM_DROP_MODE == 0.0f)
		{
			count = int(QITEM_ORIGIN_AMT);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnQuestPopulateOriginsLoop();
			}
		}
	}

	// quest_populate_origins_loop
	void DqFetchItems_OnQuestPopulateOriginsLoop()
	{
		string origin = GetArray("QITEM_SPAWN_ORIGINS", Text(loopIteration));
		CreateNpc("other/qitem", Vec(origin), QITEM_CODE, QITEM_NAME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqFetchItems_OnQuestActivate(menuOwner);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		DqBaseQuests_OnGameMenuGetoptions(player); // dq/quests/bases/dq_base_quests
		DqFetchItems_OnGameMenuGetoptions(player);
	}

	void OnGamePrecache() { DqFetchItems_OnGamePrecache(); } // game_precache
	void OnExtReceiveQuestItem(string itemCode = "") { DqFetchItems_OnExtReceiveQuestItem(itemCode); } // ext_receive_quest_item
	void OnQuestBeginHandleOrigins() { DqFetchItems_OnQuestBeginHandleOrigins(); } // quest_begin_handle_origins
	void OnQuestHandleInfoTargets() { DqFetchItems_OnQuestHandleInfoTargets(); } // quest_handle_info_targets
	void OnQuestHandleVectors() { DqFetchItems_OnQuestHandleVectors(); } // quest_handle_vectors
	void OnQuestPopulateOrigins() { DqFetchItems_OnQuestPopulateOrigins(); } // quest_populate_origins
	void OnQuestPopulateOriginsLoop() { DqFetchItems_OnQuestPopulateOriginsLoop(); } // quest_populate_origins_loop

	// This file's events and timers by their .script names
	bool DqFetchItems_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_begin_handle_origins") { OnQuestBeginHandleOrigins(); return true; }
		if (name == "quest_handle_info_targets") { OnQuestHandleInfoTargets(); return true; }
		if (name == "quest_handle_vectors") { OnQuestHandleVectors(); return true; }
		if (name == "quest_populate_origins") { OnQuestPopulateOrigins(); return true; }
		if (name == "quest_populate_origins_loop") { OnQuestPopulateOriginsLoop(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_fetch_items"]
shared class DqFetchItemsScript : DqBaseQuestsScript, DqFetchItems
{
	// Variables every script that includes this file declares
	string QUEST_DATA2 = "QUEST_DATA2";
	string QUEST_DATA3 = "QUEST_DATA3";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqFetchItems_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqFetchItems_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
