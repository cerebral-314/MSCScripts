#pragma context server

// Converted from dq/quests/dq_fetch_drop.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This quest is fetch_drop. You must pick up qitems dropped from specific npcs on their death.
// Vars:
// const QUEST_DATA1		- <"# of items required;monster name|all"> How many items need to be picked up, and which monster drops them?
// const QUEST_DATA2		- <"qitem code;qitem name"> Which qitem do you use? What do you wanna name the qitem?
// const DQ_FIND_NUM		- How many qitems need to be found?
// const DQ_KILL_WHO		- The partial name of who you need to kill in order for the qitem to drop off of them.
// const QITEM_CODE		- The qitem code.
// const QITEM_NAME		- The qitem name.
// setvard QITEMS_FOUND		- How many qitems are found currently? It only counts when they're actually turned into the npc.
// setvard QITEMS_DROPPED		- How many qitems have been dropped?
// Functions:
// The pre-cache thing		- Pre-caches the file. I'm not sure if I can safely spell pre-cache properly. :I
// quest_activate			- Adds itself to the callback list of the game_masters monster death tracker.
// game_menu_getoptions		- Checks to see if the player has any qitems.
// quest_check_qitems		- Ditto, but it loops :o
// ext_quest_monster_killed	- The callback from the game_master once an enemy has been killed.
// quest_create_qitem		- Creates the qitem
// ext_receive_quest_item		- Callback from the player external if the correct qitem is found.
// game_death			- Cleanup. It removes itself from the monster death callback counter from the game_master

#include "runtime/ScriptEntity.as"
#include "converted/dq/quests/bases/dq_base_quests.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqFetchDrop
{
	// Constants
	string DQ_KILL_WHO = "DQ_KILL_WHO";
	string QITEM_CODE = "QITEM_CODE";
	string QITEM_NAME = "QITEM_NAME";

	// Variables (an unset .script variable reads as its own name)
	float DQ_FIND_NUM = 0.0f;
	float QITEMS_FOUND = 0.0f;
	float QITEMS_DROPPED = 0.0f;

	// unnamed block (first think)
	void DqFetchDrop_FirstThink()
	{
		DQ_FIND_NUM = Float(GetToken(QUEST_DATA1, 0)); // setvard because higher scripts cant see lower script cosnts.

		QITEMS_FOUND = 0.0f;
		QITEMS_DROPPED = 0.0f;
	}

	// game_precache
	void DqFetchDrop_OnGamePrecache()
	{
		PrecacheFile("other/qitem");
	}

	// quest_activate
	// The player id of the menu owner must be passed though to this
	void DqFetchDrop_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_dq_add_counter", self);
	}

	// game_menu_getoptions
	void DqFetchDrop_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (QUEST_MODE == "active")
		{
			CallExternal(GetVar("GAME_MASTER"), "ext_check_quest_item", QITEM_CODE, self); // Checks if the qitems are found
		}
	}

	// ext_quest_monster_killed
	void DqFetchDrop_OnExtQuestMonsterKilled()
	{
		if (QUEST_MODE == "active")
		{
			string monsterKilledName = ToLowerCase(ScriptVarOf(GetVar("GAME_MASTER"), "DQ_MONSTER_KILLED_NAME"));

			if (Contains(monsterKilledName, DQ_KILL_WHO))
				OnQuestCreateQitem();
			else if (DQ_KILL_WHO == "all")
				OnQuestCreateQitem();
		}
	}

	// quest_create_qitem
	void DqFetchDrop_OnQuestCreateQitem()
	{
		if (QITEMS_DROPPED >= DQ_FIND_NUM)
		{
			CallExternal(GetVar("GAME_MASTER"), "gm_dq_perish_counter", self); // Dont drop extra qitems if enough has dropped for the quest to be finished already
		}
		else
		{
			string qitemOrigin = ScriptVarOf(GetVar("GAME_MASTER"), "DQ_MONSTER_KILLED_ORIGIN");
			CreateNpc("other/qitem", Vec(qitemOrigin), QITEM_CODE, QITEM_NAME);
			QITEMS_DROPPED = QITEMS_DROPPED + 1.0f;
		}
	}

	// ext_receive_quest_item
	void DqFetchDrop_OnExtReceiveQuestItem(string itemCode = "")
	{
		if (QUEST_MODE == "active")
		{
			QITEMS_FOUND = QITEMS_FOUND + 1.0f;

			if (QITEMS_FOUND >= DQ_FIND_NUM)
			{
				OnQuestFinished();
				CallExternal(GetVar("GAME_MASTER"), "gm_dq_perish_counter", self);
			}
		}
	}

	// game_death
	void DqFetchDrop_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_dq_perish_counter", self); // If the counter was already perished, the game_master won't perish a counter it shouldn't
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// quest_activate
	void OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		DqBaseQuests_OnQuestActivate(menuOwner); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnQuestActivate(menuOwner);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqBaseQuests_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		DqBaseQuests_OnGameMenuGetoptions(player); // dq/quests/bases/dq_base_quests
		DqFetchDrop_OnGameMenuGetoptions(player);
	}

	void OnGamePrecache() { DqFetchDrop_OnGamePrecache(); } // game_precache
	void OnExtQuestMonsterKilled() { DqFetchDrop_OnExtQuestMonsterKilled(); } // ext_quest_monster_killed
	void OnQuestCreateQitem() { DqFetchDrop_OnQuestCreateQitem(); } // quest_create_qitem
	void OnExtReceiveQuestItem(string itemCode = "") { DqFetchDrop_OnExtReceiveQuestItem(itemCode); } // ext_receive_quest_item

	// This file's events and timers by their .script names
	bool DqFetchDrop_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_quest_monster_killed") { OnExtQuestMonsterKilled(); return true; }
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_create_qitem") { OnQuestCreateQitem(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/dq_fetch_drop"]
shared class DqFetchDropScript : DqBaseQuestsScript, DqFetchDrop
{
	// Variables every script that includes this file declares
	string QUEST_ACTIVATE_CHAT = "QUEST_ACTIVATE_CHAT";
	string QUEST_ACTIVATE_SOUND = "QUEST_ACTIVATE_SOUND";
	string QUEST_COMPLETE_CHAT = "QUEST_COMPLETE_CHAT";
	string QUEST_COMPLETE_SOUND = "QUEST_COMPLETE_SOUND";
	string QUEST_DATA2 = "QUEST_DATA2";
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
		DqFetchDrop_FirstThink();
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqFetchDrop_DispatchEvent(name, params)
			|| DqBaseQuestsScript::DispatchEvent(name, params);
	}
}
