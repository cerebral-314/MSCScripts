#pragma context server

// Converted from chests/base_treasurechest.script by msc_transpiler.
// Treasure chest base for MSR by greatguys1. Based on MSC version by Thothie.
// - This system creates a seperate inventory for each player
// - This is explained to the player when the chest is looked upon (if there are multiple players)
// - Uses black chest model when there are potential artifacts
// - chest_additems - items are added to chest in this event
// special events
// callevent offer_felewyn_symbol //<%chance> - this chest may have a felewyn symbol if player meets criteria

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseTreasurechest
{
	// Constants
	string SOUND_OPEN = "Items/creak.wav";
	string SOUND_CHEST_LOCKED = "buttons/latchlocked1.wav";
	string BC_TRAP_LIST = "explode;gas";
	string ANIM_IDLE = "idle";
	string ANIM_CLOSE = "close";
	string ANIM_OPEN = "open";

	// Variables (an unset .script variable reads as its own name)
	bool NPC_NO_TRADE_REPORT = true;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float STORE_SUFFIX = 0.0f;
	float NEXT_EXPLAIN = 0.0f;
	bool BC_TRAPPED = false;
	string CHEST_USER = "CHEST_USER";
	string STORENAME = "STORENAME";
	float PLAYERS_WITHDRAWING = 0.0f;
	bool GAVE_ARTIFACTS = false;
	string TC_ARTIFACT_WINNERS = "TC_ARTIFACT_WINNERS";
	string TC_HIGHEST_DMGPOINTS = "TC_HIGHEST_DMGPOINTS";
	float TC_ALL_DMGPOINTS = 0.0f;
	float DROP_SCALING_IDX = 0.0f;
	string CHEST_DO_EVENTS = "CHEST_DO_EVENTS";
	bool BC_USE_TRACKER = false;
	float CHEST_AVG_LEVELS = 0.0f;
	bool BS_DID_NAME = false;
	bool CHEST_LOCKED = false;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	string BC_TRAP_TYPE = "BC_TRAP_TYPE";
	bool BC_GAVE_PICK = false;
	string BC_HAS_PICK_CHANCE = "BC_HAS_PICK_CHANCE";

	// unnamed block (first think)
	void BaseTreasurechest_FirstThink()
	{
		NPC_NO_TRADE_REPORT = true;
	}

	// game_spawn
	void BaseTreasurechest_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Treasure Chest");
		SetHealth(1);
		SetInvincible(true);

		SetModel("misc/treasure.mdl");

		SetHeight(30);
		SetWidth(30);

		SetIdleAnim(ANIM_IDLE);

		SetGravity(0.1f); // float down to ground

		PLAYING_DEAD = "1";

		SetNoPush(true);

		STORE_SUFFIX = Random(-10000, 10000);

		ArrayCreate("TC_STORE_ARRAY");
		ArrayCreate("TC_ARTIFACT");
		ArrayCreate("TC_ARTIFACT_CHANCE");
		ArrayCreate("TC_STORE_GOLDS");

		ArrayCreate("TC_ARTIFACT_GUARANTEED");

		ArrayCreate("DROP_CHANCE_SCALING"); // base drop chance will be multiplied by these numbers
		ArrayAdd("DROP_CHANCE_SCALING", 1.5f); // if 4 players, check idx 0
		ArrayAdd("DROP_CHANCE_SCALING", 1); // please always use 1 as base <3
		ArrayAdd("DROP_CHANCE_SCALING", 0.5f); // if 3-2 players, check idx 2 and 3
		ArrayAdd("DROP_CHANCE_SCALING", 0.25f); // if only 1 player, just use base
	}

	// game_targeted_by_player
	void BaseTreasurechest_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		if (!(PlayerCount() > 1))
			return;
		if (!(GameTime() > NEXT_EXPLAIN))
			return;
		NEXT_EXPLAIN = GameTime() + 60.0f;
		HelpTip(player, "generic", "INDIVIDUALIZED TREASURE CHEST", "This chest displays a unique inventory to each player.");
	}

	// game_playerused
	// Do all checks
	void BaseTreasurechest_OnGamePlayerused(CBasePlayer@ player = null)
	{
		if (!IsAlive(player))
			return;

		CallExternal(player, "ext_remove_afk");

		if (BC_TRAPPED)
		{
			OnDoTrap();
			InfoMessage(player, "THE CHEST IS TRAPPED!", "It's a trap!");
			BC_TRAPPED = false;
			return;
		}

		if (CHEST_LOCKED) // Some chests can be locked and unpickable. Some only unlocked via trigger.
		{
			PlaySound(0, 10, SOUND_CHEST_LOCKED);
			return;
		}

		OnTcArtifacts();
		OnTcOpen(FindPlayer(EntityId(player)));
	}

	// tc_open
	// <player Id opening>
	void BaseTreasurechest_OnTcOpen(CBasePlayer@ player = null)
	{
		CHEST_USER = EntityId(player);
		STORENAME = OnFuncMakeStoreString(CHEST_USER);

		int storeState = ArrayFind("TC_STORE_ARRAY", STORENAME);

		// store for this player hasn't been generated, make it
		if (storeState == -1)
			OnTcMakeAndPopulateStore();

		int goldStoreIdx = ArrayFind("TC_STORE_ARRAY", STORENAME);
		SetGold(Int(GetArray("TC_STORE_GOLDS", Text(goldStoreIdx))));

		LegacyCommand("offerstore", STORENAME, CHEST_USER, "inv", "trade");
	}

	// add_gold
	// <amt>
	void BaseTreasurechest_OnAddGold(float goldAmount = 0.0f)
	{
		int goldStoreIdx = ArrayFind("TC_STORE_ARRAY", STORENAME);
		float gold = Float(GetArray("TC_STORE_GOLDS", Text(goldStoreIdx)));
		gold += goldAmount;

		ArraySet("TC_STORE_GOLDS", goldStoreIdx, int(gold));
	}

	// game_gave_gold
	void BaseTreasurechest_OnGameGaveGold(CBasePlayer@ player = null, int price = 0)
	{
		string storeStr = OnFuncMakeStoreString(EntityId(player));
		int goldStoreIdx = ArrayFind("TC_STORE_ARRAY", storeStr);

		ArraySet("TC_STORE_GOLDS", goldStoreIdx, 0);
	}

	// tc_make_and_populate_store
	void BaseTreasurechest_OnTcMakeAndPopulateStore()
	{
		LegacyCommand("createstore", STORENAME);
		ArrayAdd("TC_STORE_ARRAY", STORENAME);
		ArrayAdd("TC_STORE_GOLDS", 0);

		// Checks qualifying damage points
		// Must have at least 1% of highest player to qualify for regular loot
		// Anything less and they get noob loot
		// callexternal GAME_MASTER gm_find_strongest_reset
		CallExternal(GetVar("GAME_MASTER"), "gm_top_players_reset", 1); // Redundant?
		string highestDmgpoints = ScriptVarOf(GetVar("GAME_MASTER"), "STRONGEST_STAT_LEVEL");

		CallExternal(CHEST_USER, "ext_get_dmgpoints");
		int myPts = Int(ScriptVarOf(CHEST_USER, "EXT_DMGPOINTS"));

		if (myPts > 0)
		{
			if (Divide(Float(highestDmgpoints), 10.0f) <= myPts) // at least 10% of highest dmgpoints
				OnChestAdditems();
			else
				OnChestNewb();
		}
	}

	// trade_success
	void BaseTreasurechest_OnTradeSuccess()
	{
		if (int(PLAYERS_WITHDRAWING) == 0)
		{
			PlaySound(2, 10, SOUND_OPEN);
			PlayAnim("hold", ANIM_OPEN);
		}

		PLAYERS_WITHDRAWING += 1.0f;
	}

	// trade_done
	void BaseTreasurechest_OnTradeDone()
	{
		PLAYERS_WITHDRAWING -= 1.0f;

		if (int(PLAYERS_WITHDRAWING) != 0)
			return;
		PlayAnim("once", ANIM_CLOSE);
		SetIdleAnim(ANIM_IDLE);
	}

	// chest_additems
	void BaseTreasurechest_OnChestAdditems()
	{
		// dbg ore_check
		if (!Truthy(GetVar("NO_ORE")) && Truthy(ItemExists(CHEST_USER, "item_gaxe_handle")) && !Truthy(ItemExists(CHEST_USER, "item_ore_lorel")) && RandomInt(1, 200) <= 1)
			AddStoreItem(STORENAME, "item_ore_lorel", 1, 0);
	}

	// chest_add_hpot_mpot
	void BaseTreasurechest_OnChestAddHpotMpot()
	{
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
	}

	// offer_felewyn_symbol
	// PARAM1 = % chance
	void BaseTreasurechest_OnOfferFelewynSymbol(int chance = 0)
	{
		if (!(RandomInt(1, 100) <= chance))
			return;

		string rndItem = "item_s" + RandomInt(1, 5);
		AddStoreItem(STORENAME, rndItem, 1, 0);
	}

	// tc_add_artifact
	// <scriptname> <%chance to drop 1-100>
	void BaseTreasurechest_OnTcAddArtifact(string scriptname = "", float dropChance = 0.0f)
	{
		SetModelBody(0, 1); // using black treasure model
		if (dropChance >= 100.0f)
		{
			ArrayAdd("TC_ARTIFACT_GUARANTEED", scriptname);
		}
		else
		{
			ArrayAdd("TC_ARTIFACT", scriptname);
			ArrayAdd("TC_ARTIFACT_CHANCE", dropChance);
		}
	}

	// tc_artifacts
	// rolls and gives artifacts to winners
	void BaseTreasurechest_OnTcArtifacts()
	{
		if (GAVE_ARTIFACTS)
			return;
		GAVE_ARTIFACTS = true;
		bool artExist = false;

		if (GetArrayCount("TC_ARTIFACT") > 0)
			artExist = true;
		if (GetArrayCount("TC_ARTIFACT_GUARANTEED") > 0)
			artExist = true;

		if ((artExist ? 1 : 0) == 1)
		{
			// getplayersarray TC_ARTIFACT_WINNERS
			// callexternal GAME_MASTER gm_find_strongest_reset
			CallExternal(GetVar("GAME_MASTER"), "gm_top_players_reset", 4);
		}

		TC_ARTIFACT_WINNERS = ScriptVarOf(GetVar("GAME_MASTER"), "SORTED_TOP_PLAYERS");

		TC_HIGHEST_DMGPOINTS = ScriptVarOf(GetVar("GAME_MASTER"), "STRONGEST_STAT_LEVEL");
		TC_ALL_DMGPOINTS = 0.0f;

		// calleventloop $get_array_amt(TC_ARTIFACT_WINNERS) tc_filter_winner_by_pts
		int count = GetTokenCount(TC_ARTIFACT_WINNERS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTcFilterWinnerByRoll();
		}
	}

	// give_each_guaranteed_loop
	// { tc_filter_winner_by_pts
	// if ( game.script.iteration == 0 ) setvard NUM_REMOVED 0
	// local L_IDX $math(subtract,game.script.iteration,NUM_REMOVED)
	// local L_PLAYER_ID $get_token(TC_ARTIFACT_WINNERS,L_IDX)
	// callexternal L_PLAYER_ID ext_get_dmgpoints
	// local L_MY_PTS $get(L_PLAYER_ID,scriptvar,'EXT_DMGPOINTS')
	// if ( $math(divide,TC_HIGHEST_DMGPOINTS,100) <= L_MY_PTS )
	// {
	// add TC_ALL_DMGPOINTS L_MY_PTS //yayy i can roll
	// }
	// else //boo not enough pts...
	// {
	// array.del TC_ARTIFACT_WINNERS L_IDX
	// add NUM_REMOVED 1
	// }
	// }
	void BaseTreasurechest_OnGiveEachGuaranteedLoop()
	{
		int idx = loopIteration;

		string guarItem = GetArray("TC_ARTIFACT_GUARANTEED", Text(idx));
		AddStoreItem(STORENAME, guarItem, 1, 0);
	}

	// tc_filter_winner_by_roll
	// instantly rolls all artifact chances to avoid roll chance manipulation
	void BaseTreasurechest_OnTcFilterWinnerByRoll()
	{
		// if ( game.script.iteration == 0 ) setvard NUM_REMOVED 0
		int idx = loopIteration; // $math(subtract,game.script.iteration,NUM_REMOVED)
		string playerId = GetToken(TC_ARTIFACT_WINNERS, idx);
		STORENAME = OnFuncMakeStoreString(playerId);

		TC_ALL_DMGPOINTS += Float(ScriptVarOf(playerId, "EXT_DMGPOINTS"));

		CallExternal(playerId, "ext_get_dmgpoints");

		int points = Int(ScriptVarOf(playerId, "EXT_DMGPOINTS"));

		if (!(points >= 1)) // Require more than 1k dmgpoints
			return;

		CHEST_USER = playerId;
		OnTcMakeAndPopulateStore();
		int count = GetArrayCount("TC_ARTIFACT_GUARANTEED");
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGiveEachGuaranteedLoop();
		}
		loopIteration = outerIteration;

		if (GetArrayCount("TC_ARTIFACT") < 1)
		{
			return; // No random chance artifacts, next player
		}
		DROP_SCALING_IDX = 0.0f;

		if (GetTokenCount(TC_ARTIFACT_WINNERS) < 4) // Less than 4 players, don't give bonus to highest damage scorer
			DROP_SCALING_IDX += 1.0f;

		DROP_SCALING_IDX += idx;

		if (DROP_SCALING_IDX > GetArrayCount("DROP_CHANCE_SCALING"))
		{
			return; // Max players already rolled for random artifact, next player
		}

		int rollMultiplier = Int(GetArray("DROP_CHANCE_SCALING", Text(DROP_SCALING_IDX)));

		// divide L_ROLL_MULTIPLIER TC_ALL_DMGPOINTS
		float randIdx = GetArrayCount("TC_ARTIFACT") - 1.0f;
		randIdx = RandomInt(0, int(randIdx));

		float chance = Float(GetArray("TC_ARTIFACT_CHANCE", Text(randIdx)));
		if (chance != 100.0f) // 100% chance does not get split among players. Everyone gets one.
			chance *= rollMultiplier;

		if (Random(0, 100) <= chance) // winnar! put this item in the chest.
		{
			AddStoreItem(STORENAME, GetArray("TC_ARTIFACT", Text(randIdx)), 1, 0);
			ArrayRemoveAt("TC_ARTIFACT", randIdx); // Remove the artifact
			ArrayRemoveAt("TC_ARTIFACT_CHANCE", randIdx); // Remove associated drop chance
		}
	}

	// add_noob_item
	void BaseTreasurechest_OnAddNoobItem()
	{
		string itemList = "ITEM_LIST";

		int rndList = RandomInt(1, Int(GetVar("G_NOOB_SETS")));
		if (rndList == 1)
			itemList = GetVar("G_NOOB_ITEMS1");
		if (rndList == 2)
			itemList = GetVar("G_NOOB_ITEMS2");
		if (rndList == 3)
			itemList = GetVar("G_NOOB_ITEMS3");
		if (rndList == 4)
			itemList = GetVar("G_NOOB_ITEMS4");
		if (rndList == 5)
			itemList = GetVar("G_NOOB_ITEMS5");
		if (rndList == 6)
			itemList = GetVar("G_NOOB_ITEMS6");
		if (rndList == 7)
			itemList = "G_NOOB_ITEMS7";
		if (rndList == 8)
			itemList = "G_NOOB_ITEMS8";
		if (rndList == 9)
			itemList = "G_NOOB_ITEMS9";
		float nItems = GetTokenCount(itemList) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(itemList, rItem);

		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_good_item
	void BaseTreasurechest_OnAddGoodItem()
	{
		string itemList = "ITEM_LIST";

		int rndList = RandomInt(1, Int(GetVar("G_GOOD_SETS")));
		if (rndList == 1)
			itemList = GetVar("G_GOOD_ITEMS1");
		if (rndList == 2)
			itemList = GetVar("G_GOOD_ITEMS2");
		if (rndList == 3)
			itemList = GetVar("G_GOOD_ITEMS3");
		if (rndList == 4)
			itemList = "G_GOOD_ITEMS4";
		if (rndList == 5)
			itemList = "G_GOOD_ITEMS5";
		if (rndList == 6)
			itemList = "G_GOOD_ITEMS6";
		if (rndList == 7)
			itemList = "G_GOOD_ITEMS7";
		if (rndList == 8)
			itemList = "G_GOOD_ITEMS8";
		if (rndList == 9)
			itemList = "G_GOOD_ITEMS9";
		float nItems = GetTokenCount(itemList) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(itemList, rItem);

		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_great_item
	void BaseTreasurechest_OnAddGreatItem()
	{
		string itemList = "ITEM_LIST";

		int rndList = RandomInt(1, Int(GetVar("G_GREAT_SETS")));
		if (rndList == 1)
			itemList = GetVar("G_GREAT_ITEMS1");
		else if (rndList == 2)
			itemList = GetVar("G_GREAT_ITEMS2");
		else if (rndList == 3)
			itemList = GetVar("G_GREAT_ITEMS3");
		float nItems = GetTokenCount(itemList) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(itemList, rItem);

		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_epic_item
	void BaseTreasurechest_OnAddEpicItem()
	{
		float nEpics = GetGlobalArrayCount("G_ARRAY_EPIC") - 1.0f;
		int rndPick = RandomInt(0, int(nEpics));
		string rndItem = GetGlobalArray("G_ARRAY_EPIC", Text(rndPick));

		AddStoreItem(STORENAME, rndItem, 1, 0);
	}

	// add_noob_arrows
	// <amt>
	void BaseTreasurechest_OnAddNoobArrows(string arrowCount = "")
	{
		string arrowList = GetVar("G_NOOB_ARROWS");
		string bundleSize = arrowCount;

		if (bundleSize.isEmpty())
			bundleSize = Text(15.0f * RandomInt(1, 3));

		float nArrowNames = GetTokenCount(arrowList) - 1.0f;
		string arrowName = GetToken(arrowList, RandomInt(0, int(nArrowNames)));
		AddStoreItem(STORENAME, arrowName, bundleSize, 0, 0, bundleSize);
	}

	// add_good_arrows
	// <amt>
	void BaseTreasurechest_OnAddGoodArrows(string arrowCount = "")
	{
		string arrowList = GetVar("G_GOOD_ARROWS");
		string bundleSize = arrowCount;

		if (bundleSize.isEmpty())
			bundleSize = Text(15.0f * RandomInt(1, 3));

		float nArrowNames = GetTokenCount(arrowList) - 1.0f;
		string arrowName = GetToken(arrowList, RandomInt(0, int(nArrowNames)));

		AddStoreItem(STORENAME, arrowName, bundleSize, 0, 0, bundleSize);
	}

	// add_great_arrows
	void BaseTreasurechest_OnAddGreatArrows(string arrowCount = "")
	{
		string arrowList = GetVar("G_GREAT_ARROWS");
		string bundleSize = arrowCount;

		if (bundleSize.isEmpty())
			bundleSize = Text(15.0f * RandomInt(1, 3));

		float nArrowNames = GetTokenCount(arrowList) - 1.0f;
		string arrowName = GetToken(arrowList, RandomInt(0, int(nArrowNames)));

		AddStoreItem(STORENAME, arrowName, bundleSize, 0, 0, bundleSize);
	}

	// add_epic_arrows
	void BaseTreasurechest_OnAddEpicArrows(string arrowCount = "")
	{
		string arrowList = GetVar("G_EPIC_ARROWS");
		string bundleSize = arrowCount;

		if (bundleSize.isEmpty())
			bundleSize = Text(15.0f * RandomInt(1, 3));

		float nArrowNames = GetTokenCount(arrowList) - 1.0f;
		string arrowName = GetToken(arrowList, RandomInt(0, int(nArrowNames)));

		AddStoreItem(STORENAME, arrowName, bundleSize, 0, 0, bundleSize);
	}

	// add_noob_pot
	void BaseTreasurechest_OnAddNoobPot()
	{
		float nItems = GetTokenCount(GetVar("G_NOOB_POTS")) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(GetVar("G_NOOB_POTS"), rItem);
		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_good_pot
	void BaseTreasurechest_OnAddGoodPot()
	{
		float nItems = GetTokenCount(GetVar("G_GOOD_POTS")) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(GetVar("G_GOOD_POTS"), rItem);
		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_great_pot
	void BaseTreasurechest_OnAddGreatPot()
	{
		float nItems = GetTokenCount(GetVar("G_GREAT_POTS")) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(GetVar("G_GREAT_POTS"), rItem);
		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// add_epic_pot
	void BaseTreasurechest_OnAddEpicPot()
	{
		float nItems = GetTokenCount(GetVar("G_EPIC_POTS")) - 1.0f;
		int rItem = RandomInt(0, int(nItems));
		string pItem = GetToken(GetVar("G_EPIC_POTS"), rItem);
		AddStoreItem(STORENAME, pItem, 1, 0);
	}

	// func_make_store_string
	// <playerid>
	string BaseTreasurechest_OnFuncMakeStoreString(string player = "")
	{
		string result = "";

		string return_ = SteamIdOf(player) + GetProp(player, "slot") + Text(STORE_SUFFIX);
		result = "";
		result = AppendResult(result, return_);
		return result;
	}

	// game_postspawn
	// TODO go through this and find out what it all means lmao
	void BaseTreasurechest_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		// allow additional items via addparameters
		// dbg dynchest-game_postspawn: PARAM4
		if (params != "none")
		{
			CHEST_DO_EVENTS = params;
			OnBcSetupAddparams();
		}

		if (Contains(params, "set_chest_sprite_in"))
			CallEventDelayed(0.1f, "chest_sprite_in");

		if (Truthy(GetVar("BC_SPRITE_IN")))
			CallEventDelayed(0.1f, "chest_sprite_in");

		if (Contains(params, "set_num_chests"))
			BC_USE_TRACKER = true;

		if (Contains(params, "set_chest_glow"))
			CallEventDelayed(0.1f, "chest_glow");

		if (Contains(params, "set_glowshell"))
			CallEventDelayed(0.1f, "chest_glowshell");

		if (Truthy(GetVar("BC_GLOWSHELL")))
			CallEventDelayed(0.1f, "chest_glowshell");
	}

	// bc_calc_avg_levels
	void BaseTreasurechest_OnBcCalcAvgLevels()
	{
		string name;

		int totalKills = Int(GetVar("G_SADJ_DEATHS"));
		string totalLevels = GetVar("G_SADJ_LEVELS");
		CHEST_AVG_LEVELS = Float(totalLevels);
		CHEST_AVG_LEVELS = Divide(CHEST_AVG_LEVELS, totalKills);

		if (BS_DID_NAME)
			return;
		BS_DID_NAME = true;

		name = "BS_DEF_NAME_PREFIX|BS_DEF_NAME";

		DebugPrint("bc_calc_avg_levels pre " + name);

		if (CHEST_AVG_LEVELS >= 6.0f)
			name += " VI (Multi)";
		else if (CHEST_AVG_LEVELS >= 5.0f)
			name += " V (Multi)";
		else if (CHEST_AVG_LEVELS >= 4.0f)
			name += " IV (Multi)";
		else if (CHEST_AVG_LEVELS >= 3.0f)
			name += " III (Multi)";
		else if (CHEST_AVG_LEVELS >= 2.0f)
			name += " II (Multi)";
		else if (CHEST_AVG_LEVELS < 2.0f)
			name += " I (Multi)";

		DebugPrint("bc_calc_avg_levels post " + name);

		SetName(name);
	}

	// chest_sprite_in
	void BaseTreasurechest_OnChestSpriteIn()
	{
		ClientEvent("new", "all", "effects/sfx_sprite_in", OriginOf(ENT_ME), "xflare1.spr", 20, 4.0f);
		PlaySound(0, 10, "amb/quest1.wav");
	}

	// ext_unlock
	void BaseTreasurechest_OnExtUnlock()
	{
		CHEST_LOCKED = false;
	}

	// chest_glow
	void BaseTreasurechest_OnChestGlow()
	{
		DebugPrint("chest_glow");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 255), 96, 120.0f);
	}

	// chest_glowshell
	void BaseTreasurechest_OnChestGlowshell()
	{
		Effect("glow", ENT_ME, GetVar("BC_GLOWSHELL_COLOR"), 16, -1, -1);
	}

	// game_gave_player
	void BaseTreasurechest_OnGameGavePlayer(CBasePlayer@ player = null, CBaseEntity@ item = null)
	{
		DebugPrint("game_gave_player " + EntityId(player) + " " + EntityId(item) + " " + NameOf(item) + " " + ItemNameOf(item));
	}

	// game_dynamically_created
	void BaseTreasurechest_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (creatorValue1 != "events")
			return;
		NPC_DO_EVENTS = creatorValue2;
		CallEventDelayed(0.01f, "npcatk_setup_addparams"); // delay, make sure I spawn first
	}

	// game_dynamically_created
	void BaseTreasurechest_OnGameDynamicallyCreated_2(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (creatorValue1 == "events")
		{
			DebugPrint("game_dynamically_created events " + creatorValue2);
			CHEST_DO_EVENTS = creatorValue2;
			OnBcSetupAddparams();
		}
	}

	// bc_setup_addparams
	void BaseTreasurechest_OnBcSetupAddparams()
	{
		DebugPrint("bc_setup_addparams " + GetTokenCount(CHEST_DO_EVENTS) + " " + CHEST_DO_EVENTS);
		int count = GetTokenCount(CHEST_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBcDoEvents();
		}
	}

	// bc_do_events
	void BaseTreasurechest_OnBcDoEvents()
	{
		int curIdx = loopIteration;
		string curParam = GetToken(CHEST_DO_EVENTS, curIdx);
		DebugPrint("bc_do_events " + curParam + " ( " + OnFuncParamIsnum(curParam) + " )");
		if (Truthy(OnFuncParamIsnum(curParam)))
			return;
		if (curIdx < GetTokenCount(CHEST_DO_EVENTS) - 1.0f)
		{
			string paramNext = GetToken(CHEST_DO_EVENTS, int(curIdx + 1.0f));
			CallEventOrDelay(curParam, paramNext);
		}
		else
		{
			CallEventOrDelay(curParam);
		}
	}

	// func_param_isnum
	string BaseTreasurechest_OnFuncParamIsnum(string value = "")
	{
		string result = "";
		// check if event, isn't actually an event, but parameter to be passed, such as a number or vector
		string firstChar = Left(value, 1);
		bool isNum = false;
		string numchars = "0123456789.)($";
		if (numchars.findFirst(firstChar) > -1)
		{
			DebugPrint("func_do_events_isnum " + value + " seems to be a parameter, skipping");
			isNum = true;
		}
		result = AppendResult(result, Text(isNum));
		return result;
	}

	// set_req_pick
	// [%chance]
	void BaseTreasurechest_OnSetReqPick(float chance = 0.0f)
	{
		DebugPrint("set_req_pick " + Text(chance));
		if (chance > 0.0f && RandomInt(1, 100) > chance)
			return;
	}

	// set_trap
	void BaseTreasurechest_OnSetTrap(string trapType = "")
	{
		DebugPrint("set_trap " + trapType);
		// setvard BC_TRAPPED 1
		BC_TRAP_TYPE = trapType;
		if (FindToken(BC_TRAP_LIST, BC_TRAP_TYPE) == -1)
		{
			float nTraps = GetTokenCount(BC_TRAP_LIST) - 1.0f;
			int rndTrap = RandomInt(0, int(nTraps));
			BC_TRAP_TYPE = GetToken(BC_TRAP_LIST, rndTrap);
		}
	}

	// set_locked
	void BaseTreasurechest_OnSetLocked()
	{
		CHEST_LOCKED = true;
	}

	// set_chance_haspick
	// [%chance]
	void BaseTreasurechest_OnSetChanceHaspick(float chance = 0.0f)
	{
		DebugPrint("set_chance_haspick " + Text(chance));
		BC_GAVE_PICK = false;
		BC_HAS_PICK_CHANCE = Text(chance);
		if (chance == 0.0f)
			BC_HAS_PICK_CHANCE = "100%";
	}

	// set_chance_trapped
	void BaseTreasurechest_OnSetChanceTrapped(string chance = "")
	{
		int trapChance = Int(chance);
		if (Float(chance) == 0.0f)
			trapChance = 100;

		if (!(RandomInt(1, 100) <= trapChance))
			return;
		OnSetTrap();
	}

	// do_trap
	void BaseTreasurechest_OnDoTrap()
	{
		DebugPrint("do_trap " + BC_TRAP_TYPE);
		if (BC_TRAP_TYPE == "explode")
			CreateNpc("traps/fire_burst", RelativePosition(Vector3(0, 0, 32)), 256);
		if (BC_TRAP_TYPE == "gas")
			CreateNpc("traps/poison_gas", RelativePosition(Vector3(0, 0, 32)), 128);
	}

	// ext_picked
	// <player>
	void BaseTreasurechest_OnExtPicked(CBaseEntity@ player = null)
	{
		PlaySound(1, 10, "doors/door_unlocked.wav");
		if (BC_TRAPPED)
		{
			if (CHEST_LOCKED)
				PlayerMessageGreen(player, "You disarm the trap and unlock the chest.");
			if (!CHEST_LOCKED)
				PlayerMessageGreen(player, "You disarm the trap.");
		}
		else
		{
			PlayerMessageGreen(player, "You successfully unlock the chest.");
		}

		CHEST_LOCKED = false;
		BC_TRAPPED = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseTreasurechest_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameTargetedByPlayer(CBasePlayer@ player = null) { BaseTreasurechest_OnGameTargetedByPlayer(player); } // game_targeted_by_player
	void OnGamePlayerused(CBasePlayer@ player = null) { BaseTreasurechest_OnGamePlayerused(player); } // game_playerused
	void OnTcOpen(CBasePlayer@ player = null) { BaseTreasurechest_OnTcOpen(player); } // tc_open
	void OnAddGold(float goldAmount = 0.0f) { BaseTreasurechest_OnAddGold(goldAmount); } // add_gold
	void OnGameGaveGold(CBasePlayer@ player = null, int price = 0) { BaseTreasurechest_OnGameGaveGold(player, price); } // game_gave_gold
	void OnTcMakeAndPopulateStore() { BaseTreasurechest_OnTcMakeAndPopulateStore(); } // tc_make_and_populate_store
	void OnTradeSuccess() { BaseTreasurechest_OnTradeSuccess(); } // trade_success
	void OnTradeDone() { BaseTreasurechest_OnTradeDone(); } // trade_done
	void OnChestAdditems() { BaseTreasurechest_OnChestAdditems(); } // chest_additems
	void OnChestAddHpotMpot() { BaseTreasurechest_OnChestAddHpotMpot(); } // chest_add_hpot_mpot
	void OnOfferFelewynSymbol(int chance = 0) { BaseTreasurechest_OnOfferFelewynSymbol(chance); } // offer_felewyn_symbol
	void OnTcAddArtifact(string scriptname = "", float dropChance = 0.0f) { BaseTreasurechest_OnTcAddArtifact(scriptname, dropChance); } // tc_add_artifact
	void OnTcArtifacts() { BaseTreasurechest_OnTcArtifacts(); } // tc_artifacts
	void OnGiveEachGuaranteedLoop() { BaseTreasurechest_OnGiveEachGuaranteedLoop(); } // give_each_guaranteed_loop
	void OnTcFilterWinnerByRoll() { BaseTreasurechest_OnTcFilterWinnerByRoll(); } // tc_filter_winner_by_roll
	void OnAddNoobItem() { BaseTreasurechest_OnAddNoobItem(); } // add_noob_item
	void OnAddGoodItem() { BaseTreasurechest_OnAddGoodItem(); } // add_good_item
	void OnAddGreatItem() { BaseTreasurechest_OnAddGreatItem(); } // add_great_item
	void OnAddEpicItem() { BaseTreasurechest_OnAddEpicItem(); } // add_epic_item
	void OnAddNoobArrows(string arrowCount = "") { BaseTreasurechest_OnAddNoobArrows(arrowCount); } // add_noob_arrows
	void OnAddGoodArrows(string arrowCount = "") { BaseTreasurechest_OnAddGoodArrows(arrowCount); } // add_good_arrows
	void OnAddGreatArrows(string arrowCount = "") { BaseTreasurechest_OnAddGreatArrows(arrowCount); } // add_great_arrows
	void OnAddEpicArrows(string arrowCount = "") { BaseTreasurechest_OnAddEpicArrows(arrowCount); } // add_epic_arrows
	void OnAddNoobPot() { BaseTreasurechest_OnAddNoobPot(); } // add_noob_pot
	void OnAddGoodPot() { BaseTreasurechest_OnAddGoodPot(); } // add_good_pot
	void OnAddGreatPot() { BaseTreasurechest_OnAddGreatPot(); } // add_great_pot
	void OnAddEpicPot() { BaseTreasurechest_OnAddEpicPot(); } // add_epic_pot
	string OnFuncMakeStoreString(string player = "") { return BaseTreasurechest_OnFuncMakeStoreString(player); } // func_make_store_string
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { BaseTreasurechest_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnBcCalcAvgLevels() { BaseTreasurechest_OnBcCalcAvgLevels(); } // bc_calc_avg_levels
	void OnChestSpriteIn() { BaseTreasurechest_OnChestSpriteIn(); } // chest_sprite_in
	void OnExtUnlock() { BaseTreasurechest_OnExtUnlock(); } // ext_unlock
	void OnChestGlow() { BaseTreasurechest_OnChestGlow(); } // chest_glow
	void OnChestGlowshell() { BaseTreasurechest_OnChestGlowshell(); } // chest_glowshell
	void OnGameGavePlayer(CBasePlayer@ player = null, CBaseEntity@ item = null) { BaseTreasurechest_OnGameGavePlayer(player, item); } // game_gave_player

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseTreasurechest_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
		BaseTreasurechest_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	void OnBcSetupAddparams() { BaseTreasurechest_OnBcSetupAddparams(); } // bc_setup_addparams
	void OnBcDoEvents() { BaseTreasurechest_OnBcDoEvents(); } // bc_do_events
	string OnFuncParamIsnum(string value = "") { return BaseTreasurechest_OnFuncParamIsnum(value); } // func_param_isnum
	void OnSetReqPick(float chance = 0.0f) { BaseTreasurechest_OnSetReqPick(chance); } // set_req_pick
	void OnSetTrap(string trapType = "") { BaseTreasurechest_OnSetTrap(trapType); } // set_trap
	void OnSetLocked() { BaseTreasurechest_OnSetLocked(); } // set_locked
	void OnSetChanceHaspick(float chance = 0.0f) { BaseTreasurechest_OnSetChanceHaspick(chance); } // set_chance_haspick
	void OnSetChanceTrapped(string chance = "") { BaseTreasurechest_OnSetChanceTrapped(chance); } // set_chance_trapped
	void OnDoTrap() { BaseTreasurechest_OnDoTrap(); } // do_trap
	void OnExtPicked(CBaseEntity@ player = null) { BaseTreasurechest_OnExtPicked(player); } // ext_picked
	void OnCurParam() {} // CUR_PARAM
	void OnChestNewb() {} // chest_newb

	// This file's events and timers by their .script names
	bool BaseTreasurechest_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_epic_arrows") { OnAddEpicArrows(Param(params, 0)); return true; }
		if (name == "add_epic_item") { OnAddEpicItem(); return true; }
		if (name == "add_epic_pot") { OnAddEpicPot(); return true; }
		if (name == "add_gold") { OnAddGold(Float(Param(params, 0))); return true; }
		if (name == "add_good_arrows") { OnAddGoodArrows(Param(params, 0)); return true; }
		if (name == "add_good_item") { OnAddGoodItem(); return true; }
		if (name == "add_good_pot") { OnAddGoodPot(); return true; }
		if (name == "add_great_arrows") { OnAddGreatArrows(Param(params, 0)); return true; }
		if (name == "add_great_item") { OnAddGreatItem(); return true; }
		if (name == "add_great_pot") { OnAddGreatPot(); return true; }
		if (name == "add_noob_arrows") { OnAddNoobArrows(Param(params, 0)); return true; }
		if (name == "add_noob_item") { OnAddNoobItem(); return true; }
		if (name == "add_noob_pot") { OnAddNoobPot(); return true; }
		if (name == "bc_calc_avg_levels") { OnBcCalcAvgLevels(); return true; }
		if (name == "bc_do_events") { OnBcDoEvents(); return true; }
		if (name == "bc_setup_addparams") { OnBcSetupAddparams(); return true; }
		if (name == "chest_add_hpot_mpot") { OnChestAddHpotMpot(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "chest_glow") { OnChestGlow(); return true; }
		if (name == "chest_glowshell") { OnChestGlowshell(); return true; }
		if (name == "chest_sprite_in") { OnChestSpriteIn(); return true; }
		if (name == "do_trap") { OnDoTrap(); return true; }
		if (name == "ext_picked") { OnExtPicked(EntityParam(params, 0)); return true; }
		if (name == "ext_unlock") { OnExtUnlock(); return true; }
		if (name == "func_make_store_string") { Return(OnFuncMakeStoreString(Param(params, 0))); return true; }
		if (name == "func_param_isnum") { Return(OnFuncParamIsnum(Param(params, 0))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_gave_gold") { OnGameGaveGold(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "game_gave_player") { OnGameGavePlayer(PlayerParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "give_each_guaranteed_loop") { OnGiveEachGuaranteedLoop(); return true; }
		if (name == "offer_felewyn_symbol") { OnOfferFelewynSymbol(Int(Param(params, 0))); return true; }
		if (name == "set_chance_haspick") { OnSetChanceHaspick(Float(Param(params, 0))); return true; }
		if (name == "set_chance_trapped") { OnSetChanceTrapped(Param(params, 0)); return true; }
		if (name == "set_locked") { OnSetLocked(); return true; }
		if (name == "set_req_pick") { OnSetReqPick(Float(Param(params, 0))); return true; }
		if (name == "set_trap") { OnSetTrap(Param(params, 0)); return true; }
		if (name == "tc_add_artifact") { OnTcAddArtifact(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "tc_artifacts") { OnTcArtifacts(); return true; }
		if (name == "tc_filter_winner_by_roll") { OnTcFilterWinnerByRoll(); return true; }
		if (name == "tc_make_and_populate_store") { OnTcMakeAndPopulateStore(); return true; }
		if (name == "tc_open") { OnTcOpen(PlayerParam(params, 0)); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/base_treasurechest"]
shared class BaseTreasurechestScript : ScriptEntity, BaseTreasurechest
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/treasure.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseTreasurechest_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseTreasurechest_DispatchEvent(name, params);
	}
}
