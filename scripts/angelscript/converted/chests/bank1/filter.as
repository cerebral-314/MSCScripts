#pragma context server

// Converted from chests/bank1/filter.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Filter
{
	// Constants
	string FILTER_REJECTS = "fist_bare;pack_;sheath_;magic_hand_;item_tk_";

	// Variables (an unset .script variable reads as its own name)
	float NUM_REMOVED = 0.0f;
	string FILTER_RESULT = "FILTER_RESULT";

	// func_filter_items
	// <playerId> <itemIds_in_token>
	string Filter_OnFuncFilterItems(CBasePlayer@ playerId = null, string itemIds = "")
	{
		string result = "";

		string items = itemIds;

		// Check item reject
		int count = GetTokenCount(items); // No need to pass verbose or player since its only checking hard-stop no storage items
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFilterByReject(items);
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
		items = FILTER_RESULT;
		NUM_REMOVED = 0.0f; // Reset flag

		if (int(items.length()) == 0) // If an item was removed from the filter
			PlayerMessageDark(playerId, "Galat's Storage cannot deposit tickets or containers.");

		// Check free bank space
		count = GetTokenCount(items);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFilterBySpace(playerId, items);
		}
		items = FILTER_RESULT;

		result = "";
		result = AppendResult(result, items);
		return result;
	}

	// filter_by_reject
	void Filter_OnFilterByReject(string outcome = "")
	{
		int itemIdx = loopIteration;

		if (itemIdx == 0)
		{
			FILTER_RESULT = outcome;
			NUM_REMOVED = 0.0f;
		}

		int count = GetTokenCount(FILTER_REJECTS); // will use FILTER_RESULT
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRejectLooper(itemIdx);
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
		loopIteration = outerIteration;
	}

	// reject_looper
	// <item_idx_from_FILTER_RESULT> Run by filter_by_reject
	void Filter_OnRejectLooper(float itemIndex = 0.0f)
	{
		bool remove = false;

		float idx = itemIndex - NUM_REMOVED;

		string itemScriptname = GetToken(FILTER_RESULT, int(idx));

		// Hard checks to see if item properties make it invalid
		if (!Exists(itemScriptname))
			remove = true;
		if (Truthy(ScriptVarOf(itemScriptname, "NO_BANK")))
			remove = true;

		itemScriptname = ItemNameOf(itemScriptname);

		string filter = GetToken(FILTER_REJECTS, loopIteration);

		if (Contains(itemScriptname, filter))
			remove = true;

		if (remove)
		{
			FILTER_RESULT = TokenRemove(FILTER_RESULT, int(idx));
			NUM_REMOVED += 1.0f;
			breakLoop = true;
		}
	}

	// filter_by_space
	void Filter_OnFilterBySpace(CBasePlayer@ targetPlayer = null, string value = "")
	{
		float itemIdx = loopIteration;

		if (itemIdx == 0.0f)
		{
			FILTER_RESULT = value;
			NUM_REMOVED = 0.0f;
		}

		itemIdx -= NUM_REMOVED;

		bool remove = false;

		string item = GetToken(FILTER_RESULT, int(itemIdx));

		string bank = OnFuncGetFreeBank(targetPlayer, item);

		if (bank == "0")
		{
			string str = "Your bank is too full to fit " + NameOf(item) + ".";
			PlayerMessageDark(targetPlayer, str);

			FILTER_RESULT = TokenRemove(FILTER_RESULT, int(itemIdx));
			NUM_REMOVED += 1.0f;
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnFuncFilterItems(CBasePlayer@ playerId = null, string itemIds = "") { return Filter_OnFuncFilterItems(playerId, itemIds); } // func_filter_items
	void OnFilterByReject(string outcome = "") { Filter_OnFilterByReject(outcome); } // filter_by_reject
	void OnRejectLooper(float itemIndex = 0.0f) { Filter_OnRejectLooper(itemIndex); } // reject_looper
	void OnFilterBySpace(CBasePlayer@ targetPlayer = null, string value = "") { Filter_OnFilterBySpace(targetPlayer, value); } // filter_by_space
	string OnFuncGetFreeBank(CBasePlayer@ playerId = null, string itemId = "") { return ""; } // func_get_free_bank

	// This file's events and timers by their .script names
	bool Filter_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "filter_by_reject") { OnFilterByReject(Param(params, 0)); return true; }
		if (name == "filter_by_space") { OnFilterBySpace(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "func_filter_items") { Return(OnFuncFilterItems(PlayerParam(params, 0), Param(params, 1))); return true; }
		if (name == "reject_looper") { OnRejectLooper(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/bank1/filter"]
shared class FilterScript : ScriptEntity, Filter
{
	// Variables every script that includes this file declares
	string ANIM_CLOSE = "ANIM_CLOSE";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_OPEN = "ANIM_OPEN";
	string BANK_HAS = "BANK_HAS";
	int BANK_MAX = 0;
	string BANK_PREFIX = "BANK_PREFIX";
	string BANK_STRINGS = "BANK_STRINGS";
	bool FREE_BANK = false;
	int MAX_AMMO_IN_ONE_SLOT = 0;
	int MAX_BANK_STRING = 0;
	int MAX_IN_ONE_TRANSACTION = 0;
	int MAX_SWIGS_IN_ONE_SLOT = 0;
	bool NPC_ECHO_ITEMS = false;
	bool NPC_NO_REPORT_ITEMS = false;
	string PLAYER_WITHDRAWING = "PLAYER_WITHDRAWING";
	string SCAN_AREA = "SCAN_AREA";
	string STACK_REMAINDER = "STACK_REMAINDER";
	string STORENAME = "STORENAME";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Filter_DispatchEvent(name, params);
	}
}
