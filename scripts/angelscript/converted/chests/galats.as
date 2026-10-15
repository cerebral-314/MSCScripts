#pragma context server

// Converted from chests/galats.script by msc_transpiler.
// This is a special chest that gives players access to their storage.
// The items are kept on the character by the game (see the "storage" command), not by this script.
// The chest used to keep ammo and potions itself, in the quests b0-b9.
// Whatever a player still has in there is moved into their storage when they use the chest.
// All hail the almighty MSSCRIPT and SUSPEND_AI

#include "runtime/ScriptEntity.as"

[script "chests/galats"]
class Galats : ScriptEntity
{
	// Constants
	string ANIM_IDLE = "idle";
	string ANIM_CLOSE = "close";
	string ANIM_OPEN = "open";
	string BANK_PREFIX = "b";
	int BANK_MAX = 10;

	// Variables (an unset .script variable reads as its own name)
	float CHEST_USERS = 0.0f;
	CBasePlayer@ CONV_PLAYER = null;
	bool CONV_MOVED = false;
	bool CONV_KEPT = false;
	string CONV_SLOT = "CONV_SLOT";
	string CONV_CONTENTS = "CONV_CONTENTS";
	string CONV_KEEP = "CONV_KEEP";
	bool CONV_SLOT_MOVED = false;
	float CONV_IDX = 0.0f;
	string SCAN_AREA = "SCAN_AREA";

	// unnamed block (first think)
	void Galats_FirstThink()
	{
		CHEST_USERS = 0.0f; // Number of players that have their storage open through this chest
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
	}

	// game_playerused
	// <player>
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		// Move anything the player still has in the old chest into their storage
		OnBankConvert(player);

		// Opens the player's storage. The player has to stay near the chest to keep using it.
		// Calls bank_success right away, and bank_done when the player is finished.
		LegacyCommand("storage", "trade", @player, "Galat's Wondrous Chest of Storage", "bank");
	}

	// bank_success
	// <player>
	void OnBankSuccess()
	{
		CHEST_USERS += 1.0f;
		if (CHEST_USERS != 1.0f)
			return;
		OnOpenChest();
	}

	// bank_done
	// <player>
	void OnBankDone()
	{
		CHEST_USERS -= 1.0f;
		if (!(CHEST_USERS <= 0.0f))
			return;
		CHEST_USERS = 0.0f;
		OnCloseChest();
	}

	// bank_convert
	// <player> - Moves what the player has in the old chest (quests b0-b9) into their storage
	void OnBankConvert(CBasePlayer@ player = null)
	{
		@CONV_PLAYER = player;
		CONV_MOVED = false; // Set if anything was moved into storage
		CONV_KEPT = false; // Set if anything had to stay in the old chest

		int count = BANK_MAX;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBankConvertSlot();
		}

		if (CONV_KEPT)
			HelpTip(CONV_PLAYER, "generic", "Galat's Wondrous Chest of Storage", "Some of your old items could not be moved into your storage yet|Make room and use the chest again.");
		else if (CONV_MOVED)
			HelpTip(CONV_PLAYER, "generic", "Galat's Wondrous Chest of Storage", "The items you kept in this chest have been moved into your storage.");
	}

	// bank_convert_slot
	void OnBankConvertSlot()
	{
		CONV_SLOT = BANK_PREFIX + Text(loopIteration);
		CONV_CONTENTS = GetQuestData(CONV_PLAYER, CONV_SLOT);

		// A slot with nothing in it is 0
		if (!(int(CONV_CONTENTS.length()) > 1))
			return;

		CONV_KEEP = "0"; // What stays in this slot
		CONV_SLOT_MOVED = false; // Set if anything left this slot
		CONV_IDX = 0.0f;
		int count = GetTokenCount(CONV_CONTENTS);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBankConvertItem();
		}
		loopIteration = outerIteration;

		// Only write the slot if something left it
		if (!CONV_SLOT_MOVED)
			return;
		Quest("set", CONV_PLAYER, CONV_SLOT, CONV_KEEP);
	}

	// bank_convert_item
	void OnBankConvertItem()
	{
		int added = 0;
		string addedText;

		// Each item is its name, followed by a number if there is more than 1 of it.
		// An item can take up two tokens, so there may be less items than loops
		if (!(CONV_IDX < GetTokenCount(CONV_CONTENTS)))
			return;

		string name = GetToken(CONV_CONTENTS, int(CONV_IDX));
		CONV_IDX += 1.0f;

		// A name is never just a number, so a token that is one is this item's number.
		// $get_token gives 0 past the end of the slot
		string quantityText = GetToken(CONV_CONTENTS, int(CONV_IDX));
		int quantity = Int(quantityText);
		if (quantityText == LegacyFunction("num", quantityText))
		{
			if (quantity > 0)
			{
				CONV_IDX += 1.0f;
			}
			else
			{
				quantity = 1;
				quantityText = Text(quantity);
			}
		}
		else
		{
			quantity = 1;
			quantityText = Text(quantity);
		}

		float left = quantity; // How much of it couldn't go into storage

		if (Truthy(LegacyFunction("get_item_table", name, "is_drinkable")))
		{
			// For a potion the number is how many drinks are left.
			// They become full potions, and one partly used potion for the remainder
			string fullText = LegacyFunction("get_item_table", name, "quality"); // Drinks in a full potion
			int full = Int(fullText);
			if (full < 1)
			{
				full = 1;
				fullText = Text(full);
			}
			int potions = int(Divide(quantity, full));
			float partial = quantity - potions * full;

			if (potions > 0)
			{
				LegacyCommand("storage", "add", @CONV_PLAYER, name, potions, fullText);
				addedText = Eval("game.ret.storage.added");
				added = Int(addedText);
				left -= added * full;
			}
			if (partial > 0.0f)
			{
				LegacyCommand("storage", "add", @CONV_PLAYER, name, 1, partial);
				addedText = Eval("game.ret.storage.added");
				added = Int(addedText);
				left -= added * partial;
			}
		}
		else
		{
			// For anything else the number is how many there are
			LegacyCommand("storage", "add", @CONV_PLAYER, name, quantityText);
			addedText = Eval("game.ret.storage.added");
			added = Int(addedText);
			left -= added;
		}

		if (left < quantity)
		{
			CONV_MOVED = true;
			CONV_SLOT_MOVED = true;
		}

		if (left > 0.0f)
			OnBankConvertKeep(name, int(left));
	}

	// bank_convert_keep
	// <itemname> <number> - This couldn't go into storage, so it stays in the old chest
	void OnBankConvertKeep(string itemName = "", int quantity = 0)
	{
		CONV_KEPT = true;

		if (CONV_KEEP == "0")
			CONV_KEEP = itemName;
		else
			CONV_KEEP = TokenAdd(CONV_KEEP, itemName);

		if (quantity > 1)
			CONV_KEEP = TokenAdd(CONV_KEEP, Text(quantity));
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

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Galats_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bank_convert") { OnBankConvert(PlayerParam(params, 0)); return true; }
		if (name == "bank_convert_item") { OnBankConvertItem(); return true; }
		if (name == "bank_convert_keep") { OnBankConvertKeep(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "bank_convert_slot") { OnBankConvertSlot(); return true; }
		if (name == "bank_done") { OnBankDone(); return true; }
		if (name == "bank_success") { OnBankSuccess(); return true; }
		if (name == "close_chest") { OnCloseChest(); return true; }
		if (name == "fade_in_done") { OnFadeInDone(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "move_monsters") { OnMoveMonsters(); return true; }
		if (name == "open_chest") { OnOpenChest(); return true; }
		if (name == "spawn_in") { OnSpawnIn(Float(Param(params, 0))); return true; }
		return false;
	}
}
