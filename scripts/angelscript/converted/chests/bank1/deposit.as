#pragma context server

// Converted from chests/bank1/deposit.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Deposit
{

	// deposit_item
	// <owner> <item_id>
	void Deposit_OnDepositItem(CBasePlayer@ owner = null, string itemId = "")
	{
		float finalAmt = 0.0f;
		string str = "L_STR";

		// Should re-check if the item can be accepted
		string item = itemId;

		item = OnFuncFilterItems(owner, item); // Check if item is rejected

		if (item != "0")
		{
			string freeBank = OnFuncGetFreeBank(owner, item); // Check for next free space in the bank
			if (freeBank != "0")
			{
				// callexternal L_ITEM item_banked //tell item we've been banked
				string bankContents = GetQuestData(owner, freeBank);
				if (int(bankContents.length()) == 0)
					bankContents = "0";

				string itemScriptnameString = OnFuncMakeString(item);

				// Set new bank contents if stackable
				string newBankContents = OnFuncStackQuantity(bankContents, itemScriptnameString);
				if (newBankContents != bankContents)
				{
					bankContents = newBankContents;
				}
				else
				{
					// Stack size and deletion is handled below
					// Otherwise append it.
					// Write bank contents
					if (bankContents == "0") // If the quest var is uninitialized
						bankContents = itemScriptnameString;
					else
						bankContents = TokenAdd(bankContents, itemScriptnameString);
				}

				// Set stack size in hand or delete item
				string numStoringText = GetToken(itemScriptnameString, 1); // Number of items attempted to store
				float numStoring = Float(numStoringText);
				if (numStoring == 0.0f)
					numStoring = 1.0f;

				if (Float(STACK_REMAINDER) != numStoring) // If item was stacked, do math to get the number of items stored in that slot in this transaction
					numStoring = numStoring - Float(STACK_REMAINDER);

				if (IsProjectile(item))
				{
					finalAmt = QuantityOf(item) - numStoring;

					str = "You add " + int(numStoring) + " of your " + NameOf(item) + "s to the Galat Chest.";
					PlayerMessageDark(owner, str);

					if (finalAmt > 0.0f)
						LegacyCommand("setquantity", item, finalAmt);
					else
						DeleteEntity(item);
				}
				else if (Truthy(GetProp(item, "is_drinkable")))
				{
					finalAmt = QualityOf(item) - numStoring;

					string swigs = "swig";
					if (numStoring > 1.0f)
						swigs += "s";

					str = "You add " + int(numStoring) + " " + swigs + " of your " + NameOf(item) + " to the Galat Chest.";
					PlayerMessageDark(owner, str);

					if (finalAmt > 0.0f)
						LegacyCommand("setquality", item, finalAmt);
					else
						DeleteEntity(item);
				}
				else
				{
					DeleteEntity(item);
				}

				Quest("set", owner, freeBank, bankContents);

				string msg = "You add your " + NameOf(item) + " to the Galat Chest.";
				InfoMessage(owner, NameOf(ENT_ME), msg);

				CallEventDelayed(0.1f, "open_chest");
				CallEventDelayed(0.55f, "close_chest");
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnDepositItem(CBasePlayer@ owner = null, string itemId = "") { Deposit_OnDepositItem(owner, itemId); } // deposit_item
	string OnFuncFilterItems(CBasePlayer@ playerId = null, string itemIds = "") { return ""; } // func_filter_items
	string OnFuncGetFreeBank(CBasePlayer@ playerId = null, string itemId = "") { return ""; } // func_get_free_bank
	string OnFuncMakeString(string itemEntity = "") { return ""; } // func_make_string
	string OnFuncStackQuantity(string bankData = "", string itemString = "") { return ""; } // func_stack_quantity

	// This file's events and timers by their .script names
	bool Deposit_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "deposit_item") { OnDepositItem(PlayerParam(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/bank1/deposit"]
shared class DepositScript : ScriptEntity, Deposit
{
	// Variables every script that includes this file declares
	string ANIM_CLOSE = "ANIM_CLOSE";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_OPEN = "ANIM_OPEN";
	string BANK_HAS = "BANK_HAS";
	int BANK_MAX = 0;
	string BANK_PREFIX = "BANK_PREFIX";
	string BANK_STRINGS = "BANK_STRINGS";
	string FILTER_REJECTS = "FILTER_REJECTS";
	string FILTER_RESULT = "FILTER_RESULT";
	bool FREE_BANK = false;
	int MAX_AMMO_IN_ONE_SLOT = 0;
	int MAX_BANK_STRING = 0;
	int MAX_IN_ONE_TRANSACTION = 0;
	int MAX_SWIGS_IN_ONE_SLOT = 0;
	bool NPC_ECHO_ITEMS = false;
	bool NPC_NO_REPORT_ITEMS = false;
	float NUM_REMOVED = 0.0f;
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
		return Deposit_DispatchEvent(name, params);
	}
}
