#pragma context server

// Converted from chests/bank1.script by msc_transpiler.
// This script is retired but kept for reasons. The new bank script is galats.script
// which uses the new storage system build into the game itself.
// All hail the almighty MSSCRIPT and SUSPEND_AI
// This is a special chest that allows players to store inventory as quest data
// (thus removing weight and hopefully reducing likelihood of overflow)
// Remade by greatguys1
// Stores ammo and potions.

#include "runtime/ScriptEntity.as"
#include "converted/chests/bank1/filter.as"
#include "converted/chests/bank1/deposit.as"
#include "converted/chests/bank1/withdraw.as"

[script "chests/bank1"]
class Bank1 : FilterScript, Deposit, Withdraw
{
	// Variables declared by included files, with the value they start with in this script
	Bank1()
	{
		ANIM_IDLE = "idle";
		ANIM_CLOSE = "close";
		ANIM_OPEN = "open";
		BANK_PREFIX = "b";
		BANK_MAX = 10;
		MAX_BANK_STRING = 255;
		MAX_IN_ONE_TRANSACTION = 100;
		MAX_AMMO_IN_ONE_SLOT = 9999;
		MAX_SWIGS_IN_ONE_SLOT = 20;
	}

	// unnamed block (first think)
	void Bank1_FirstThink()
	{
		NPC_ECHO_ITEMS = true; // flags for c++ code??
		NPC_NO_REPORT_ITEMS = true;

		PLAYER_WITHDRAWING = "0"; // Switches to either a player id or 0 depending on whether a player is withdrawing. 2 players cannot withdraw at the same time
	}

	// func_get_free_bank
	// <playerId> <itemId> - Returns a quest that has enough space to store the item, or 0 if there is no space.
	string Bank1_OnFuncGetFreeBank(CBasePlayer@ playerId = null, string itemId = "")
	{
		string result = "";

		int count = BANK_MAX;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFreeBankLooper(playerId, itemId);
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}

		result = "";
		result = AppendResult(result, Text(FREE_BANK));
		return result;
	}

	// func_check_bank_has
	// <playerId> [itemScriptname]
	string Bank1_OnFuncCheckBankHas(CBaseEntity@ playerId = null, string itemScript = "")
	{
		int count;
		string result = "";

		// Returns 1 if there is anything deposited in the players bank at all.
		// Returns 0 if there is nothing.
		// Returns a bank slot and index in a token if a scriptname is provided, and that item is found.
		// Returns 0 if a scriptname is provided and that item is not found in the players bank.

		if (itemScript.isEmpty())
		{
			count = BANK_MAX;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBankHasAnythingLoop(playerId);
				if (breakLoop)
				{
					breakLoop = false;
					break;
				}
			}
		}
		else
		{
			count = BANK_MAX;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBankHasItemLoop(playerId, itemScript);
				if (breakLoop)
				{
					breakLoop = false;
					break;
				}
			}
		}

		result = "";
		result = AppendResult(result, BANK_HAS);
		return result;
	}

	// func_stack_quantity
	// <bankContents> <func_make_string> -Attempts to stack the made string in the bank
	string Bank1_OnFuncStackQuantity(string bankData = "", string itemString = "")
	{
		string result = "";

		// contents string. Returns bank contents and sets a variable to flag the remainder
		string bankContents = bankData;

		STACK_REMAINDER = GetToken(itemString, 1);
		if (Float(STACK_REMAINDER) == 0.0f)
			STACK_REMAINDER = "1";

		string itemScriptname = GetToken(itemString, 0);

		int maxQuantity = 1;
		if (Truthy(LegacyFunction("get_item_table", itemScriptname, "is_projectile")))
			maxQuantity = MAX_AMMO_IN_ONE_SLOT;
		else if (Truthy(LegacyFunction("get_item_table", itemScriptname, "is_drinkable")))
			maxQuantity = MAX_SWIGS_IN_ONE_SLOT;

		if (maxQuantity > 1)
		{
			int existingIdx = FindToken(bankContents, itemScriptname);
			if (existingIdx != -1) // If the item exists in this bank slot
			{
				string existingQuantityText = OnFuncGetStoredQuantity(bankContents, Text(existingIdx));
				float existingQuantity = Float(existingQuantityText);

				if (existingQuantity < maxQuantity)
				{
					// Flag inserting the quantity variable in the contents if necessary
					bool insertQuantity = true;
					string existingScriptnameString = itemScriptname; // Make the string so we can test its length later
					if (existingQuantity != 1.0f)
					{
						insertQuantity = false;
						existingScriptnameString = TokenAdd(existingScriptnameString, GetToken(bankContents, int(existingIdx + 1.0f)));
					}

					// Add up stacks and set remainder
					existingQuantity += Float(STACK_REMAINDER);
					float remainder = 0.0f;
					if (existingQuantity > maxQuantity)
					{
						remainder = existingQuantity - maxQuantity;
						existingQuantity = maxQuantity;
					}

					// Build new string
					string newScriptnameString = itemScriptname + ";" + int(existingQuantity);
					// Test the fit
					float bankContentsLen = int(bankContents.length()) - int(existingScriptnameString.length());
					bankContentsLen += int(newScriptnameString.length());

					// If bank string will be valid
					if (bankContentsLen <= MAX_BANK_STRING)
					{
						// Set appropriate quantity inside of bank
						if (insertQuantity)
							bankContents = TokenSet(bankContents, existingIdx, newScriptnameString);
						else
							bankContents = TokenSet(bankContents, int(existingIdx + 1.0f), Text(int(existingQuantity)));

						// Properly flag remainder
						STACK_REMAINDER = Text(remainder);
					}
				}
			}
		}

		result = "";
		result = AppendResult(result, bankContents);
		return result;
	}

	// func_make_string
	// <itemId> //Puts item in a paired token with its quantity, and returns the string.
	string Bank1_OnFuncMakeString(string itemEntity = "")
	{
		string result = "";

		string itemScriptname = ItemNameOf(itemEntity);

		int quantity = 1;

		if (IsProjectile(itemEntity))
		{
			quantity = QuantityOf(itemEntity);
			if (quantity > MAX_IN_ONE_TRANSACTION)
				quantity = MAX_IN_ONE_TRANSACTION;
		}
		else if (Truthy(GetProp(itemEntity, "is_drinkable"))) // Item wont be both
			quantity = QualityOf(itemEntity);

		if (quantity > 1)
			itemScriptname = TokenAdd(itemScriptname, Text(quantity));

		result = "";
		result = AppendResult(result, itemScriptname);
		return result;
	}

	// func_get_stored_quantity
	// <bankContents> <idx> //Returns the number of items in that slot, and the one after if the item holds a quantity
	string Bank1_OnFuncGetStoredQuantity(string bankData = "", string idx = "")
	{
		string result = "";

		float quantity = Float(idx) + 1.0f;
		string quantityText = GetToken(bankData, int(quantity));
		quantity = Float(quantityText);

		// Algorithm to detect if the item in the bank has quantity
		if (quantityText == LegacyFunction("num", quantityText))
		{
			if (quantity == 0.0f)
			{
				quantity = 1.0f;
				quantityText = Text(quantity);
			}
		}
		else
		{
			quantity = 1.0f;
			quantityText = Text(quantity);
		}

		result = "";
		result = AppendResult(result, quantityText);
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Galat's Wondrous Chest of Storage");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(20);
		SetHeight(30);
		SetModel("misc/treasure.mdl");
		SetModelBody(0, 2); // new gold submodel

		SetIdleAnim(ANIM_IDLE);
		SetGravity(0.1f); // float down to ground

		SetNoPush(true);

		int count = BANK_MAX;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGenerateBankStrings();
		}

		SetMenuAutoOpen(true); // Opens menu when e is pushed
	}

	// generate_bank_strings
	// Creates the string used for storing and searching items in quests
	void OnGenerateBankStrings()
	{
		string str = BANK_PREFIX + Text(loopIteration);

		if (BANK_STRINGS == "BANK_STRINGS") // As much as I wanna initialize this variable at the top of the script, I can't because it will cause issues.
			BANK_STRINGS = str;
		else
			BANK_STRINGS = TokenAdd(BANK_STRINGS, str);
	}

	// game_menu_getoptions
	// PARAM1=player activating menu
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		int count;

		// Depositing functions
		// Get items in hand
		string items = TokenAdd(ScriptVarOf(player, "PLR_LEFT_HAND"), ScriptVarOf(player, "PLR_RIGHT_HAND")); // Gets item id in hand

		// Filter the items, returns only valid items.
		items = OnFuncFilterItems(player, items); // <player> <item_id_in_token>

		if (items == "0")
		{
			InfoMessage(player, "Galat's wondrous Chest of Storage", "Be sure to place any items you wish to store in your hands.");

			if (NUM_REMOVED > 0.0f) // using flag from { filter_by_space to determine if items were invalidated due to not enough bank space
			{
				menuItem.title = "Chest is Full";
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			count = GetTokenCount(items);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddDepositOptions(items);
			}
		}

		// Withdrawing functions
		// Check if there's anything in the bank at all
		if (Truthy(OnFuncCheckBankHas(player)))
		{
			if (Float(GetProp(player, "numitems")) >= Float(GetVar("G_MAX_ITEMS")))
			{
				InfoMessage(player, "Can't Withdaw Items", "Your inventory is full.");
				menuItem.title = "(Inventory Full)";
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
			else if (!Truthy(PLAYER_WITHDRAWING))
			{
				menuItem.title = "Withdraw Items";
				menuItem.type = "callback";
				menuItem.callback = "withdraw_items";
				RegisterMenuItem(menuItem);
			}
			else
			{
				string msg = NameOf(ENT_ME) + ": Cannot withdraw while the chest is in use.";
				PlayerMessageDark(player, msg);

				menuItem.title = "Withdraw Items";
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// add_deposit_options
	// <token_of_item_ids>
	void OnAddDepositOptions(string itemIdToken = "")
	{
		MenuItem menuItem;

		string item = GetToken(itemIdToken, loopIteration);
		string itemTitle = "Deposit " + NameOf(item);

		string scriptnameString = OnFuncMakeString(item);
		string depositAmtText = GetToken(scriptnameString, 1);
		int depositAmt = Int(depositAmtText);
		if (depositAmt > 0)
			itemTitle += " (" + depositAmtText + ")";

		menuItem.title = itemTitle;
		menuItem.type = "callback";
		menuItem.data = item;
		menuItem.callback = "deposit_item";
		RegisterMenuItem(menuItem);
	}

	// trade_success
	void OnTradeSuccess()
	{
		OnOpenChest();
	}

	// trade_done
	void OnTradeDone()
	{
		OnCloseChest();
		OnEraseStore();
		PLAYER_WITHDRAWING = "0";
	}

	// erase_store
	void OnEraseStore()
	{
		LegacyCommand("npcstore.remove", STORENAME);
	}

	// game_dynamically_created
	// <summoner>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		float yaw = AnglesOf(creatorValue1).y;
		SetSolid("none"); // don't let players use their scrolls to stick monsters

		if (!IsPlayer(creatorValue1))
		{
			OnSpawnIn(yaw);
		}
		else
		{
			CBaseEntity@ otherChest = FindByName("galat_bank1");
			if (Exists(otherChest))
			{
				SetOrigin(otherChest, OriginOf(ENT_ME));
				CallExternal(otherChest, "spawn_in", -yaw);
				DeleteEntity(ENT_ME);
			}
			else
			{
				SetUniqueName("galat_bank1");
				OnSpawnIn(-yaw);
			}
		}
	}

	// spawn_in
	void OnSpawnIn(float spawnYaw = 0.0f)
	{
		PlaySound(0, 7, "magic/spawn.wav");
		SetAngle("face", Vector3(0, spawnYaw, 0));
		CallExternal(GetVar("GAME_MASTER"), "gm_fade_in", self, 5);

		SCAN_AREA = FindInSphere("any", 64);
		if (SCAN_AREA == "none")
			return;
		int count = GetTokenCount(SCAN_AREA);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMoveMonsters();
		}
	}

	// move_monsters
	void OnMoveMonsters()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_AREA, loopIteration));
		if (IsPlayer(curTarg))
			return;
		if (Truthy(ScriptVarOf(curTarg, "GALAT_CHEST")))
			return;
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110)), "override");
	}

	// fade_in_done
	// from gm
	void OnFadeInDone()
	{
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// open_chest
	void OnOpenChest()
	{
		PlaySound(2, 10, "Items/creak.wav");
		PlayAnim("hold", ANIM_OPEN);
	}

	// close_chest
	void OnCloseChest()
	{
		PlayAnim("once", ANIM_CLOSE);
	}

	string OnFuncGetFreeBank(CBasePlayer@ playerId = null, string itemId = "") { return Bank1_OnFuncGetFreeBank(playerId, itemId); } // func_get_free_bank

	// free_bank_looper
	void OnFreeBankLooper(CBasePlayer@ targetPlayer = null, string bankItem = "")
	{
		if (loopIteration == 0)
			FREE_BANK = false;

		string itemScriptname = ItemNameOf(bankItem);
		string itemString = OnFuncMakeString(bankItem);

		string bank = GetToken(BANK_STRINGS, loopIteration);
		string bankContents = GetQuestData(targetPlayer, bank);

		// See if item is a quantity that can stack in an existing slot
		string newBankContents = OnFuncStackQuantity(bankContents, itemString);
		if (newBankContents != bankContents) // If new bank contents change, then a stack was allowed.
		{
			FREE_BANK = Truthy(bank);
			breakLoop = true;
		}
		else
		{
			// Add
			float resultValue = int(bankContents.length()) + int(itemString.length()) + 1.0f; // will automatically incur another char by adding it to a token (;)

			if (resultValue <= MAX_BANK_STRING)
			{
				FREE_BANK = Truthy(bank);
				breakLoop = true;
			}
		}
	}

	string OnFuncCheckBankHas(CBaseEntity@ playerId = null, string itemScript = "") { return Bank1_OnFuncCheckBankHas(playerId, itemScript); } // func_check_bank_has

	// bank_has_anything_loop
	// <playerId>
	void OnBankHasAnythingLoop(CBaseEntity@ playerId = null)
	{
		if (loopIteration == 0)
			BANK_HAS = "0";

		string bankSlot = GetToken(BANK_STRINGS, loopIteration);
		string bankContents = GetQuestData(playerId, bankSlot);

		if (int(bankContents.length()) > 1)
		{
			BANK_HAS = "1";
			breakLoop = true;
		}
	}

	// bank_has_item_loop
	// <playerId> <itemScriptName>
	void OnBankHasItemLoop(CBaseEntity@ playerId = null, string itemScriptName = "")
	{
		if (loopIteration == 0)
			BANK_HAS = "0";

		string bankSlot = GetToken(BANK_STRINGS, loopIteration);
		string bankContents = GetQuestData(playerId, bankSlot);

		int idx = FindToken(bankContents, itemScriptName);

		if (idx != -1)
		{
			BANK_HAS = bankSlot + ";" + idx;
			breakLoop = true;
		}
	}

	string OnFuncStackQuantity(string bankData = "", string itemString = "") { return Bank1_OnFuncStackQuantity(bankData, itemString); } // func_stack_quantity

	string OnFuncMakeString(string itemEntity = "") { return Bank1_OnFuncMakeString(itemEntity); } // func_make_string

	string OnFuncGetStoredQuantity(string bankData = "", string idx = "") { return Bank1_OnFuncGetStoredQuantity(bankData, idx); } // func_get_stored_quantity

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	string OnFuncFilterItems(CBasePlayer@ playerId = null, string itemIds = "") { return Filter_OnFuncFilterItems(playerId, itemIds); } // func_filter_items

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bank1_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_deposit_options") { OnAddDepositOptions(Param(params, 0)); return true; }
		if (name == "bank_has_anything_loop") { OnBankHasAnythingLoop(EntityParam(params, 0)); return true; }
		if (name == "bank_has_item_loop") { OnBankHasItemLoop(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "close_chest") { OnCloseChest(); return true; }
		if (name == "erase_store") { OnEraseStore(); return true; }
		if (name == "fade_in_done") { OnFadeInDone(); return true; }
		if (name == "free_bank_looper") { OnFreeBankLooper(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "func_check_bank_has") { Return(OnFuncCheckBankHas(EntityParam(params, 0), Param(params, 1))); return true; }
		if (name == "func_get_free_bank") { Return(OnFuncGetFreeBank(PlayerParam(params, 0), Param(params, 1))); return true; }
		if (name == "func_get_stored_quantity") { Return(OnFuncGetStoredQuantity(Param(params, 0), Param(params, 1))); return true; }
		if (name == "func_make_string") { Return(OnFuncMakeString(Param(params, 0))); return true; }
		if (name == "func_stack_quantity") { Return(OnFuncStackQuantity(Param(params, 0), Param(params, 1))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "generate_bank_strings") { OnGenerateBankStrings(); return true; }
		if (name == "move_monsters") { OnMoveMonsters(); return true; }
		if (name == "open_chest") { OnOpenChest(); return true; }
		if (name == "spawn_in") { OnSpawnIn(Float(Param(params, 0))); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		return Deposit_DispatchEvent(name, params)
			|| Withdraw_DispatchEvent(name, params)
			|| FilterScript::DispatchEvent(name, params);
	}
}
