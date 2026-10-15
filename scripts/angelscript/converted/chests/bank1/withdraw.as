#pragma context server

// Converted from chests/bank1/withdraw.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Withdraw
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYER_WITHDRAWING = "PLAYER_WITHDRAWING";
	string STORENAME = "STORENAME";

	// withdraw_items
	// <playerID> -Generates the galat storemenu and offers it to the player
	void Withdraw_OnWithdrawItems(CBasePlayer@ playerId = null)
	{
		int count;

		if (!Truthy(PLAYER_WITHDRAWING))
		{
			PLAYER_WITHDRAWING = EntityId(playerId);

			STORENAME = "galat_" + BANK_PREFIX + "_" + SteamIdOf(playerId);
			LegacyCommand("createstore", STORENAME);

			count = BANK_MAX;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBuildStores(playerId);
			}
			LegacyCommand("offerstore", STORENAME, @playerId, "inv", "trade");
		}
		else
		{
			string msg = NameOf(ENT_ME) + ": Cannot withdraw while the chest is in use.";
			PlayerMessageDark(playerId, msg);
		}
	}

	// build_stores
	// <playerId>
	void Withdraw_OnBuildStores(CBaseEntity@ playerId = null)
	{
		int count;
		int outerIteration;

		string bank = GetToken(BANK_STRINGS, loopIteration);

		string bankContents = GetQuestData(playerId, bank);
		if (int(bankContents.length()) > 1)
		{
			count = GetTokenCount(bankContents);
			outerIteration = loopIteration;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddToChest(bankContents);
			}
			loopIteration = outerIteration;
		}
	}

	// add_to_chest
	// <bankStr>
	void Withdraw_OnAddToChest(string bankData = "")
	{
		int maxStack;
		string maxStackText;
		int count;
		int outerIteration;

		string itemScriptname = GetToken(bankData, loopIteration);
		float quantity = Float(OnFuncGetStoredQuantity(bankData, Text(loopIteration)));

		if (quantity > 1.0f)
		{
			if (Truthy(LegacyFunction("get_item_table", itemScriptname, "is_projectile")))
			{
				maxStack = MAX_IN_ONE_TRANSACTION;
				maxStackText = Text(maxStack);
			}
			else
			{
				maxStackText = LegacyFunction("get_item_table", itemScriptname, "quality");
				maxStack = Int(maxStackText);
			}

			float stacks = Divide(quantity, maxStack);
			if (stacks > int(stacks)) // If There exists a non-full stack
			{
				quantity = Modulo(quantity, maxStack); // Gets remainder
				AddStoreItem(STORENAME, itemScriptname, quantity, 0, 0, quantity); // Stack remainder in first.
			}

			count = int(stacks);
			outerIteration = loopIteration;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddStackToChest(itemScriptname, maxStackText);
			}
			loopIteration = outerIteration;
		}
		else
		{
			AddStoreItem(STORENAME, itemScriptname, quantity, 0, 0, quantity);
		}
	}

	// add_stack_to_chest
	// <scriptname> <quantity>
	void Withdraw_OnAddStackToChest(string itemScript = "", string quantity = "")
	{
		AddStoreItem(STORENAME, itemScript, quantity, 0, 0, quantity);
	}

	// ext_player_got_item
	// <item_id> <owner> -called when player clicks an item in their bank menu
	void Withdraw_OnExtPlayerGotItem(CBaseEntity@ itemEntity = null, CBaseEntity@ owner = null)
	{
		string itemScriptname = ItemNameOf(itemEntity);

		string itemFound = OnFuncCheckBankHas(owner, itemScriptname);

		if (itemFound != "0")
		{
			string bank = GetToken(itemFound, 0);
			string bankStr = GetQuestData(owner, bank);
			string itemIdx = GetToken(itemFound, 1);

			float quantityStored = Float(OnFuncGetStoredQuantity(bankStr, itemIdx));
			int quantityWithdrawing = int(quantityStored);
			string quantityWithdrawingText = Text(quantityWithdrawing);

			if (quantityStored > 1.0f)
			{
				int maxTransaction = MAX_IN_ONE_TRANSACTION; // Assume projectile storage, then check for potion storage.
				if (Truthy(GetProp(itemEntity, "is_drinkable"))) // Potion withdraw amt can only be as high as the max swig.
					maxTransaction = QualityOf(itemEntity);

				if (quantityWithdrawing > maxTransaction)
				{
					quantityWithdrawing = maxTransaction;
					quantityWithdrawingText = Text(quantityWithdrawing);
				}

				quantityStored -= quantityWithdrawing;

				if (quantityStored > 1.0f) // Edit quantity stored
				{
					bankStr = TokenSet(bankStr, int(Float(itemIdx) + 1.0f), Text(int(quantityStored)));
				}
				else if (quantityStored == 1.0f) // Delete quantity indicator
				{
					bankStr = TokenRemove(bankStr, int(Float(itemIdx) + 1.0f));
				}
				else
				{
					bankStr = TokenRemove(bankStr, Int(itemIdx));
					bankStr = TokenRemove(bankStr, Int(itemIdx));
				}
			}
			else
			{
				bankStr = TokenRemove(bankStr, Int(itemIdx));
			}

			// Fixes withdrawing potions with 1 swig left giving max quantity.
			if (IsProjectile(itemEntity))
			{
				LegacyCommand("setquantity", @itemEntity, quantityWithdrawingText);
			}
			else if (Truthy(GetProp(itemEntity, "is_drinkable")))
			{
				LegacyCommand("setquality", @itemEntity, quantityWithdrawingText);
				LegacyCommand("setquantity", @itemEntity, 1); // Fixes item pickup constantly showing multiple potions in one stack.
			}

			Quest("set", owner, bank, bankStr);
		}
		else
		{
			DebugPrint("Couldn't find item!");
			CallExternal(itemEntity, "item_banked"); // tell item we've been removed
			DeleteEntity(itemEntity);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnWithdrawItems(CBasePlayer@ playerId = null) { Withdraw_OnWithdrawItems(playerId); } // withdraw_items
	void OnBuildStores(CBaseEntity@ playerId = null) { Withdraw_OnBuildStores(playerId); } // build_stores
	void OnAddToChest(string bankData = "") { Withdraw_OnAddToChest(bankData); } // add_to_chest
	void OnAddStackToChest(string itemScript = "", string quantity = "") { Withdraw_OnAddStackToChest(itemScript, quantity); } // add_stack_to_chest
	void OnExtPlayerGotItem(CBaseEntity@ itemEntity = null, CBaseEntity@ owner = null) { Withdraw_OnExtPlayerGotItem(itemEntity, owner); } // ext_player_got_item
	string OnFuncCheckBankHas(CBaseEntity@ playerId = null, string itemScript = "") { return ""; } // func_check_bank_has
	string OnFuncGetStoredQuantity(string bankData = "", string idx = "") { return ""; } // func_get_stored_quantity

	// This file's events and timers by their .script names
	bool Withdraw_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_stack_to_chest") { OnAddStackToChest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "add_to_chest") { OnAddToChest(Param(params, 0)); return true; }
		if (name == "build_stores") { OnBuildStores(EntityParam(params, 0)); return true; }
		if (name == "ext_player_got_item") { OnExtPlayerGotItem(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "withdraw_items") { OnWithdrawItems(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/bank1/withdraw"]
shared class WithdrawScript : ScriptEntity, Withdraw
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
	string SCAN_AREA = "SCAN_AREA";
	string STACK_REMAINDER = "STACK_REMAINDER";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Withdraw_DispatchEvent(name, params);
	}
}
