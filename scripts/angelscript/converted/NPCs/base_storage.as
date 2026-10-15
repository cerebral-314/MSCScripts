#pragma context server

// Converted from NPCs/base_storage.script by msc_transpiler.
// weapon armor storage, alternative bank system by Thothie (from scratch)
// base to be used by NPC tellers

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseStorage
{
	// Constants
	Vector3 GALA_CHEST_POS = Vector3();
	string SAYTEXT_wondrous_NOFUNDS = "We're sorry, but you seem to lack the funds to purchase Galat's Wondrous Scroll.";
	string SAYTEXT_wondrous_PURCHASED = "Here you go. It's only good for one use, so be sure you have room to use it.";
	string STORAGE_DISPLAYNAME = "Galat's Storage";
	string STORAGE_NAME = "main_bank";
	float STORAGE_FEERATIO = 0.01f;
	int STORAGE_ACCOUNT_COST = 5;
	string SAYTEXT_BANKOPEN = "There, that should be your stuff.";
	int N_ADDITIONAL = 3;
	string ADDITIONAL_ITEMS_01 = "blunt_gauntlets_serpant;blunt_gauntlets_leather;blunt_gauntlets_demon;bows_orion1;swords_novablade12;armor_pheonix55;axes_poison1;axes_vaxe;axes_thunder11;axes_gthunder11;blunt_lrod11;bows_thornbow;bows_crossbow_heavy33;armor_helm_undead;";
	string ADDITIONAL_ITEMS_02 = "blunt_northmaul972;smallarms_frozentongueonflagpole;swords_frostblade55;armor_belmont;armor_belmont;blunt_mithral;armor_salamander;armor_fireliz;swords_wolvesbane;swords_blood_drinker;armor_leather_gaz1;axes_td;axes_tf;axes_ti;axes_tp;";
	string ADDITIONAL_ITEMS_03 = "axes_dragon;smallarms_nh;bows_firebird;bows_frost;armor_faura;armor_paura;armor_venom;smallarms_k_fire;axes_tl;";
	string SAYTEXT_REFUND = "No pressure, here's your fee back. Come back anytime.";
	string SAYTEXT_SELECT_ITEM = "Please select the specific item you would like to store.";
	string SAYTEXT_SELECT_CAT = "SAYTEXT_SELECT_CAT";
	string SAYTEXT_NOITEM = "Sorry, I did not recieve the item.";
	string SAYTEXT_NOTICKET = "Sorry, I did not recieve the ticket.";
	string SAYTEXT_NOSTORABLES = "I'm sorry, you've no items we can store for you.";
	string SAYTEXT_GIVETICKET = "Here's your ticket! Remember, you can redeem that at any Galat outlet.";
	string SAYTEXT_SELECT_TICKET = "Please select which ticket you wish to redeem.";
	string SAYTEXT_HAND_WARN = "Please place tickets in your hands before you attempt to redeem them.";
	string SAYTEXT_REDEEMTICKET = "There ya go! Thank you for using Galat Storage, please come again!";
	string SAYTEXT_ITEMS_HANDS = "Remember, I can only store items held forth in your hands.";
	string SAYTEXT_BANK_NOTE = "Ah, a you wish to cash a Galat bank note. Yes, we can do that here.";
	string ANIM_CHAT = "talkright";
	string ANIM_NO = "deskidle";
	string ANIM_STORE = "portal";

	// Variables (an unset .script variable reads as its own name)
	int GALA_SCROLL_PRICE = 5000;
	float FEE_HP_RATIO = 0.0f;
	string AXE_STRING = "AXE_STRING";
	string BLUNT_STRING = "BLUNT_STRING";
	string BOW_STRING = "BOW_STRING";
	string GAUNTLET_STRING = "GAUNTLET_STRING";
	string ARMOR_STRING1 = "ARMOR_STRING1";
	string ARMOR_STRING2 = "ARMOR_STRING2";
	string SMALLARM_STRING1 = "SMALLARM_STRING1";
	string SMALLARM_STRING2 = "SMALLARM_STRING2";
	string SWORD_STRING1 = "SWORD_STRING1";
	string SWORD_STRING2 = "SWORD_STRING2";
	CBaseEntity@ CUSTOMER_ID = null;
	bool REGISTER_ITEMS = false;
	bool REGISTER_TICKETS = false;
	float USE_FEE = 0.0f;
	int FOUND_IN_HANDS = 0;
	float TOTAL_COUNT = 0.0f;
	float TICKET_COUNT = 0.0f;
	bool GAVE_HAND_WARNING = false;
	bool GAVE_SELECT_TICKET_TEXT = false;
	float CHECK_LOOP = 0.0f;
	bool STORAGE_ACTIVE = false;
	bool TICKETS_ACTIVE = false;
	string STORAGE_TYPE = "STORAGE_TYPE";
	int ARMOR_TYPES = 0;
	int AXE_TYPES = 0;
	int BLUNT_TYPES = 0;
	int BOW_TYPES = 0;
	int GAUNTLET_TYPES = 0;
	int SMALLARM_TYPES = 0;
	int SWORD_TYPES = 0;
	string BANK_USER = "BANK_USER";
	float BC_TOTAL_MOUTH_TIME = 0.0f;

	// unnamed block (first think)
	void BaseStorage_FirstThink()
	{
		GALA_SCROLL_PRICE = 5000;

		// Ticket storage system ==============
		FEE_HP_RATIO = 0.1f;

		// I'm not sure why I made these vards, but I'm not changing it now
		// these should probably be const, but I'm using sevard due to potential menu item registry issues
		// add to these strings as new items are added
		AXE_STRING = "axes_2haxe;axes_axe;axes_battleaxe;axes_doubleaxe;axes_greataxe;axes_rsmallaxe;axes_runeaxe;axes_scythe;axes_smallaxe;axes_golden;axes_golden_ref;";
		BLUNT_STRING = "blunt_calrianmace;blunt_club;blunt_darkmaul;blunt_granitemace;blunt_granitemaul;blunt_greatmaul;blunt_hammer_dorfgan;blunt_hammer1;blunt_hammer2;blunt_hammer3;blunt_mace;blunt_maul;blunt_ravenmace;blunt_rudolfsmace;blunt_rustyhammer2;blunt_warhammer;";
		BOW_STRING = "bows_crossbow_light;bows_longbow;bows_orcbow;bows_shortbow;bows_swiftbow;bows_treebow;bows_orion1;";
		GAUNTLET_STRING = "blunt_gauntlets;blunt_gauntlets_fire;gauntlets_normal;blunt_snake_staff;";

		// SWORD_STRING1, SMALLARM_STRING1, and ARMOR_STRING1 met the maximum char length, so we had to split it in two
		// - if another one hits the max limit, you'll have to do the same and alter the code
		ARMOR_STRING1 = "armor_dark;armor_golden;armor_helm_dark;armor_helm_gaz1;armor_helm_gaz2;armor_helm_golden;armor_helm_knight;armor_helm_mongol;armor_helm_plate;armor_knight;armor_leather;armor_leather_studded;armor_leather_torn;armor_mongol;armor_plate;";
		ARMOR_STRING2 = "armor_helm_gray;armor_helm_bronze;"; // removing shields temporarily
		SMALLARM_STRING1 = "smallarms_bone_blade;smallarms_craftedknife;smallarms_craftedknife2;smallarms_craftedknife3;smallarms_craftedknife4;smallarms_dagger;smallarms_dirk;smallarms_fangstooth;smallarms_flamelick;smallarms_huggerdagger;smallarms_huggerdagger2;";
		SMALLARM_STRING2 = "smallarms_huggerdagger3;smallarms_huggerdagger4;smallarms_knife;smallarms_rknife;smallarms_royaldagger;";
		SWORD_STRING1 = "swords_bastardsword;swords_giceblade;swords_iceblade;swords_katana;swords_katana2;swords_katana3;swords_katana4;swords_liceblade;swords_longsword;swords_lostblade;swords_m2sword;swords_msword;swords_nkatana;swords_poison1;swords_rsword;swords_scimitar;";
		SWORD_STRING2 = "swords_shortsword;swords_skullblade;swords_skullblade2;swords_skullblade3;swords_skullblade4;swords_spiderblade;swords_testskin;swords_testsub;swords_volcano;swords_rune_green;";
	}

	// game_spawn
	void BaseStorage_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(1.0f, "create_bank"); // Lets the npc fall before attempting to spawn the chest. -greatguys1@SEP2021
	}

	// create_bank
	void BaseStorage_OnCreateBank()
	{
		CreateNpc("chests/galats", GALA_CHEST_POS, self);

		OnStorageReset();
		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void BaseStorage_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		LegacyCommand("menuitem.remove", "abort_option");

		@CUSTOMER_ID = player;

		if (TICKETS_ACTIVE)
		{
			REGISTER_ITEMS = false;
			REGISTER_TICKETS = true;
		}

		if (!STORAGE_ACTIVE)
		{
			OnCountItems();
			if (Truthy(ItemExists(player, "item_galat_note_100")))
			{
				menuItem.title = "Redeem Bank Note [100]";
				menuItem.type = "payment";
				menuItem.data = "item_galat_note_100";
				menuItem.callback = "note_hundred";
				RegisterMenuItem(menuItem);
			}

			if (Truthy(ItemExists(player, "item_galat_note_10")))
			{
				menuItem.title = "Redeem Bank Note [10]";
				menuItem.type = "payment";
				menuItem.data = "item_galat_note_10";
				menuItem.callback = "note_ten";
				RegisterMenuItem(menuItem);
			}

			menuItem.title = "About storage chest";
			menuItem.type = "callback";
			menuItem.callback = "say_storage_chest";
			RegisterMenuItem(menuItem);

			menuItem.title = "Buy Wondrous Scroll (";
			LegacyCommand("stradd", "reg.mitem.title", GALA_SCROLL_PRICE);
			LegacyCommand("stradd", "reg.mitem.title", "gp)");
			menuItem.type = "payment";
			menuItem.data = "gold:";
			LegacyCommand("stradd", "reg.mitem.data", GALA_SCROLL_PRICE);
			menuItem.callback = "buy_scroll";
			menuItem.cb_failed = "say_wondrous_cant_afford";
			RegisterMenuItem(menuItem);

			menuItem.title = "About Wondrous Scroll";
			menuItem.type = "callback";
			menuItem.callback = "say_wondrous";
			RegisterMenuItem(menuItem);
		}

		if (FOUND_IN_HANDS == 0 && TOTAL_COUNT > 0.0f)
		{
			SayText(SAYTEXT_ITEMS_HANDS);
			OnBtellerHandWarn();
		}

		if (TICKETS_ACTIVE && !GAVE_SELECT_TICKET_TEXT)
			CallEventDelayed(0.5f, "storage_reset");

		if (TICKETS_ACTIVE)
			return;

		// //dbg temp Menu Activated storageact STORAGE_ACTIVE storetype STORAGE_TYPE
		if (!STORAGE_ACTIVE)
		{
			USE_FEE = MaxHealthOf(player) * FEE_HP_RATIO;
			USE_FEE = int(USE_FEE);
			if (USE_FEE < 25.0f)
				USE_FEE = 25.0f;
			menuItem.id = "a_storage";
			menuItem.title = "Store an Item: " + Text(USE_FEE) + "gp";
			menuItem.type = "payment";
			menuItem.data = "gold:" + Text(USE_FEE);
			menuItem.callback = "activate_storage";
			if (TOTAL_COUNT == 0.0f)
			{
				PlayAnim("critical", ANIM_NO);
				SayText(SAYTEXT_NOSTORABLES);
				OnBtellerStoreError();
				menuItem.type = "disabled";
				LegacyCommand("menuitem.remove", "a_storage");
			}
			if (FOUND_IN_HANDS == 0)
				menuItem.type = "disabled";
			if (FOUND_IN_HANDS != 0)
				RegisterMenuItem(menuItem);

			if (TICKET_COUNT > 0.0f)
			{
				menuItem.id = "a_ticket";
				menuItem.title = "Redeem a ticket";
				menuItem.type = "callback";
				menuItem.callback = "activate_tickets";
				SetLocal("reg.mitem.disable", 0);
				RegisterMenuItem(menuItem);
			}
		}

		// ye beta bank of fail
		// if ( G_DEVELOPER_MODE )
		// {
		// local reg.mitem.title	"Use Beta Bank"
		// local reg.mitem.type	callback
		// local reg.mitem.callback  open_betabank
		// menuitem.register
		// }
		if (!STORAGE_ACTIVE)
			return;

		menuItem.cb_failed = "storage_reset";

		FOUND_IN_HANDS = 0;
		TOTAL_COUNT = 0.0f;
		REGISTER_ITEMS = true;
		REGISTER_TICKETS = false;
		OnEnumAll();

		if (FOUND_IN_HANDS == 0)
		{
			OnBtellerHandWarn();
			SayText(SAYTEXT_ITEMS_HANDS);
		}

		OnDisplayAbort();
	}

	// count_items
	void BaseStorage_OnCountItems()
	{
		// count up storable items by category, as well as tickets
		FOUND_IN_HANDS = 0;
		TOTAL_COUNT = 0.0f;
		TICKET_COUNT = 0.0f;
		REGISTER_ITEMS = false;

		OnEnumAll();
	}

	// check_inventory
	// PARAM1 = category //PARAM2 = passstring
	void BaseStorage_OnCheckInventory(string category = "", string passString = "")
	{
		int notInHands = 0;
		MenuItem menuItem;
		string searchTicket = "SEARCH_TICKET";

		string searchItem = GetToken(passString, int(CHECK_LOOP));

		if (Truthy(ItemExists(CUSTOMER_ID, searchItem)) && !REGISTER_TICKETS)
		{
			bool foundItem = true;

			if (Truthy(ItemExists(CUSTOMER_ID, searchItem)))
			{
				notInHands = Int(LegacyFunction("item_exists", @CUSTOMER_ID, searchItem, "nohands"));

				if (notInHands == 0)
					FOUND_IN_HANDS = 1;

				TOTAL_COUNT += 1.0f;

				// //dbg temp found PARAM1 ( SEARCH_ITEM ) on $get(CUSTOMER_ID,name) loop ( CHECK_LOOP ) in hands ( FOUND_IN_HANDS )
				if (REGISTER_ITEMS)
				{
					// items must be in hands
					if (notInHands == 0)
					{
						string itemName = LegacyFunction("item_exists", @CUSTOMER_ID, searchItem, "name");
						menuItem.title = "Store " + itemName;
						menuItem.type = "callback";
						menuItem.data = searchItem;
						menuItem.callback = "return_ticket";
						menuItem.cb_failed = "storage_reset";
						RegisterMenuItem(menuItem);
					}
				}
			}
		}

		if (REGISTER_TICKETS)
		{
			searchTicket = "item_tk_" + searchItem;
			if (Truthy(ItemExists(CUSTOMER_ID, searchTicket)))
			{
				// //dbg temp SEARCH_TICKET exists 1 ( notinhands $item_exists(CUSTOMER_ID,SEARCH_TICKET,nohands) noinv $item_exists(CUSTOMER_ID,SEARCH_TICKET,notinpack) noworn $item_exists(CUSTOMER_ID,SEARCH_TICKET,noworn) )
				notInHands = Int(LegacyFunction("item_exists", @CUSTOMER_ID, searchTicket, "nohands"));
				if (notInHands != 0 && !GAVE_HAND_WARNING)
				{
					SayText(SAYTEXT_HAND_WARN);
					OnBtellerTicketWarn();
					GAVE_HAND_WARNING = true;
				}
				if (notInHands == 0)
				{
					if (!GAVE_SELECT_TICKET_TEXT)
					{
						SayText(SAYTEXT_SELECT_TICKET);
						GAVE_SELECT_TICKET_TEXT = true;
						OnBtellerSelectTicket();
					}

					string ticketName = LegacyFunction("item_exists", @CUSTOMER_ID, searchTicket, "name");
					menuItem.title = ticketName;
					menuItem.type = "callback";
					menuItem.data = searchItem;
					menuItem.callback = "redeem_ticket";
					menuItem.cb_failed = "storage_reset";
					RegisterMenuItem(menuItem);
				}
			}
		}

		if (!REGISTER_ITEMS)
		{
			searchTicket = "item_tk_" + searchItem;
			if (Truthy(ItemExists(CUSTOMER_ID, searchTicket)))
			{
				TICKET_COUNT += 1.0f;
				notInHands = Int(LegacyFunction("item_exists", @CUSTOMER_ID, searchItem, "nohands"));
				if (notInHands != 0 && !GAVE_HAND_WARNING)
				{
					SayText(SAYTEXT_HAND_WARN);
					OnBtellerTicketWarn();
					GAVE_HAND_WARNING = true;
				}
			}
		}

		// //dbg temp Found ticket SEARCH_TICKET on $get(CUSTOMER_ID,name)
		CHECK_LOOP += 1.0f;
	}

	// activate_storage
	void BaseStorage_OnActivateStorage(CBasePlayer@ player = null)
	{
		SayText(SAYTEXT_SELECT_CAT);
		STORAGE_ACTIVE = true;
		CallEventDelayed(0.5f, "open_menu");
	}

	// activate_tickets
	void BaseStorage_OnActivateTickets(CBasePlayer@ player = null)
	{
		TICKETS_ACTIVE = true;
		CallEventDelayed(0.5f, "open_menu");
	}

	// say_select_item
	void BaseStorage_OnSaySelectItem()
	{
		SayText(SAYTEXT_SELECT_ITEM);
	}

	// return_ticket
	// PARAM1=user, PARAM2=item to store
	void BaseStorage_OnReturnTicket(CBasePlayer@ user = null, string storeItem = "")
	{
		// //dbg temp ReturnTicket got $get(PARAM1,name) PARAM2 PARAM3 PARAM4

		string ticketName = "item_tk_" + storeItem;

		if (Truthy(ItemExists(user, storeItem)))
		{
			string methodHack = LegacyFunction("item_exists", @user, storeItem, "remove");
			Offer(user, ticketName);
			OnBtellerGiveTicket();
			SayText(SAYTEXT_GIVETICKET);
		}
		else
		{
			SayText(SAYTEXT_NOITEM);
			PlayAnim("critical", ANIM_NO);
			OnBtellerErrorNoItem();
		}

		OnStorageReset();
	}

	// open_menu
	void BaseStorage_OnOpenMenu()
	{
		// //dbg temp opening menu
		OpenMenu(CUSTOMER_ID);
	}

	// storage_reset
	void BaseStorage_OnStorageReset()
	{
		// //dbg temp storage_reset
		STORAGE_TYPE = "unset";
		STORAGE_ACTIVE = false;
		TICKETS_ACTIVE = false;
		REGISTER_TICKETS = false;
		REGISTER_ITEMS = false;
		FOUND_IN_HANDS = 0;
		TOTAL_COUNT = 0.0f;
		GAVE_SELECT_TICKET_TEXT = false;
		GAVE_HAND_WARNING = false;
	}

	// cancel_trade
	void BaseStorage_OnCancelTrade(CBasePlayer@ player = null)
	{
		SayText(SAYTEXT_REFUND);
		Offer(player, "gold", USE_FEE);
		OnStorageReset();
	}

	// display_abort
	void BaseStorage_OnDisplayAbort()
	{
		MenuItem menuItem;

		menuItem.id = "abort_option";
		menuItem.title = "Abort Transaction";
		menuItem.type = "callback";
		menuItem.callback = "cancel_trade";
		RegisterMenuItem(menuItem);
	}

	// redeem_ticket
	// PARAM1=customer_id PARAM2=item to return
	void BaseStorage_OnRedeemTicket(CBasePlayer@ customerId = null, string returnItem = "")
	{
		// //dbg temp RedeemTicket got $get(PARAM1,name) PARAM2 PARAM3 PARAM4

		string ticketName = "item_tk_" + returnItem;

		if (Truthy(ItemExists(customerId, ticketName)))
		{
			PlayAnim("critical", ANIM_STORE);

			// //dbg temp attempting to remove TICKET_NAME in exchange for ITEM_IN
			string methodHack = LegacyFunction("item_exists", @customerId, ticketName, "remove");
			Offer(customerId, returnItem);

			SayText(SAYTEXT_REDEEMTICKET);
			OnBtellerTicketRedeemed();
		}
		else
		{
			SayText(SAYTEXT_NOTICKET);
			PlayAnim("critical", ANIM_NO);
			OnBtellerErrorNoItem();
		}

		OnStorageReset();
	}

	// enum_all
	void BaseStorage_OnEnumAll()
	{
		CHECK_LOOP = 0.0f;
		ARMOR_TYPES = GetTokenCount(ARMOR_STRING1);
		int count = ARMOR_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("armor", ARMOR_STRING1);
		}
		CHECK_LOOP = 0.0f;
		ARMOR_TYPES = GetTokenCount(ARMOR_STRING2);
		count = ARMOR_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("armor", ARMOR_STRING2);
		}

		// enum_axe
		CHECK_LOOP = 0.0f;
		AXE_TYPES = GetTokenCount(AXE_STRING);
		count = AXE_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("axe", AXE_STRING);
		}

		// future use
		// setvard CHECK_LOOP 0
		// setvard AXE_TYPES $get_token_amt(AXE_STRING2)
		// calleventloop AXE_TYPES check_inventory axe AXE_STRING2
		// emum_blunt
		CHECK_LOOP = 0.0f;
		BLUNT_TYPES = GetTokenCount(BLUNT_STRING);
		count = BLUNT_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("blunt", BLUNT_STRING);
		}

		// future use
		// setvard CHECK_LOOP 0
		// setvard BLUNT_TYPES $get_token_amt(BLUNT_STRING2)
		// calleventloop BLUNT_TYPES check_inventory blunt BLUNT_STRING2
		// enum_bow
		CHECK_LOOP = 0.0f;
		BOW_TYPES = GetTokenCount(BOW_STRING);
		count = BOW_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("bow", BOW_STRING);
		}

		// future use
		// setvard CHECK_LOOP 0
		// setvard BOW_TYPES $get_token_amt(BOW_STRING2)
		// calleventloop BOW_TYPES check_inventory bow BOW_STRING2
		// enum_gauntlet
		CHECK_LOOP = 0.0f;
		GAUNTLET_TYPES = GetTokenCount(GAUNTLET_STRING);
		count = GAUNTLET_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("gauntlet", GAUNTLET_STRING);
		}

		// enum_smallarm
		CHECK_LOOP = 0.0f;
		SMALLARM_TYPES = GetTokenCount(SMALLARM_STRING1);
		count = SMALLARM_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("smallarm", SMALLARM_STRING1);
		}

		CHECK_LOOP = 0.0f;
		SMALLARM_TYPES = GetTokenCount(SMALLARM_STRING2);
		count = SMALLARM_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("smallarm", SMALLARM_STRING2);
		}

		// enum_sword
		CHECK_LOOP = 0.0f;
		SWORD_TYPES = GetTokenCount(SWORD_STRING1);
		count = SWORD_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("sword", SWORD_STRING1);
		}

		CHECK_LOOP = 0.0f;
		SWORD_TYPES = GetTokenCount(SWORD_STRING2);
		count = SWORD_TYPES;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventory("sword", SWORD_STRING2);
		}

		// enum_additional
		// The item division is a result of the original method (ie. categorize all weapons on player to avoid overflowing the 5 menu item limit)
		// We've done away with that by only allowing banking of items in the player's hands
		// Thus, all future item strings will be in ADDITIONAL_ITEMS_xx
		if (!(N_ADDITIONAL >= 1))
			return;
		CHECK_LOOP = 0.0f;
		string nextCheckList = ADDITIONAL_ITEMS_01;
		int checkListNitems = GetTokenCount(nextCheckList);
		for (int i = 0; i < checkListNitems; i++)
		{
			loopIteration = i;
			OnCheckInventory("other", nextCheckList);
		}

		if (!(N_ADDITIONAL >= 2))
			return;
		CHECK_LOOP = 0.0f;
		nextCheckList = ADDITIONAL_ITEMS_02;
		checkListNitems = GetTokenCount(nextCheckList);
		for (int i = 0; i < checkListNitems; i++)
		{
			loopIteration = i;
			OnCheckInventory("other", nextCheckList);
		}

		if (!(N_ADDITIONAL >= 3))
			return;
		CHECK_LOOP = 0.0f;
		nextCheckList = ADDITIONAL_ITEMS_03;
		checkListNitems = GetTokenCount(nextCheckList);
		for (int i = 0; i < checkListNitems; i++)
		{
			loopIteration = i;
			OnCheckInventory("other", nextCheckList);
		}

		if (!(N_ADDITIONAL >= 4))
			return;
		CHECK_LOOP = 0.0f;
		nextCheckList = "ADDITIONAL_ITEMS_04";
		checkListNitems = GetTokenCount(nextCheckList);
		for (int i = 0; i < checkListNitems; i++)
		{
			loopIteration = i;
			OnCheckInventory("other", nextCheckList);
		}

		if (!(N_ADDITIONAL >= 5))
			return;
		CHECK_LOOP = 0.0f;
		nextCheckList = "ADDITIONAL_ITEMS_05";
		checkListNitems = GetTokenCount(nextCheckList);
		for (int i = 0; i < checkListNitems; i++)
		{
			loopIteration = i;
			OnCheckInventory("other", nextCheckList);
		}
	}

	// note_hundred
	void BaseStorage_OnNoteHundred(CBasePlayer@ player = null)
	{
		SayText(SAYTEXT_BANK_NOTE);
		PlayAnim("once", ANIM_CHAT);
		Offer(player, "gold", 100);
	}

	// note_ten
	void BaseStorage_OnNoteTen(CBasePlayer@ player = null)
	{
		SayText(SAYTEXT_BANK_NOTE);
		PlayAnim("once", ANIM_CHAT);
		Offer(player, "gold", 10);
	}

	// open_betabank
	// scripts to add (placed here by ticket maker)
	void BaseStorage_OnOpenBetabank(string bankUser = "")
	{
		LegacyCommand("storage", "checkaccount", STORAGE_NAME, ENT_LASTUSED, "betabank");
		BANK_USER = bankUser;
	}

	// betabank_success
	void BaseStorage_OnBetabankSuccess()
	{
		SayText(SAYTEXT_BANKOPEN);
		LegacyCommand("storage", "trade", STORAGE_NAME, BANK_USER, STORAGE_FEERATIO, STORAGE_DISPLAYNAME);
	}

	// betabank_failed
	void BaseStorage_OnBetabankFailed()
	{
		OnConvoAnim();
		SayText("We have this eh, mystic portal to the vaults. It seems to be working okay, but it's still a little experimental.");
		CallEventDelayed(2.0f, "bank_intro1");
	}

	// bank_intro1
	void BaseStorage_OnBankIntro1()
	{
		SayText("You can use it for a minimal fee. Just beware that it is at the moment 'at your own risk' - at least until the wizards get the kinks worked out.");
		LegacyCommand("storage", "openaccount", STORAGE_NAME, BANK_USER);
		CallEventDelayed(2.0f, "bank_intro2");
	}

	// bank_intro2
	void BaseStorage_OnBankIntro2()
	{
		OnConvoAnim();
		SayText("You can store more items in the betabank, and you don't have to deal with tickets. Also, usually cheaper - the cost is based on the value of the item.");
		InfoMessage(BANK_USER, "BETA BANK ACCOUNT OPEN", "Choose Open Betabank again to start using the betabank.");
	}

	// buy_scroll
	void BaseStorage_OnBuyScroll(CBasePlayer@ player = null)
	{
		SayText(SAYTEXT_wondrous_PURCHASED);
		OnLchatMouthMove();
		Offer(player, "item_gwond");
		PlayAnim("once", "return_needle");
	}

	// say_wondrous_cant_afford
	void BaseStorage_OnSayWondrousCantAfford()
	{
		SayText(SAYTEXT_wondrous_NOFUNDS);
		OnLchatMouthMove();
		PlayAnim("once", "no");
	}

	// lchat_mouth_move
	void BaseStorage_OnLchatMouthMove()
	{
		BC_TOTAL_MOUTH_TIME = 0.0f;

		string rndSay1 = "[";
		float mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay1 += Text(mTime) + "]";

		string rndSay2 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay2 += Text(mTime) + "]";

		string rndSay3 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay3 += Text(mTime) + "]";

		string rndSay4 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay4 += Text(mTime) + "]";

		Say(rndSay1, rndSay2, rndSay3, rndSay4);
		BC_TOTAL_MOUTH_TIME += 1.0f;
		CallEventDelayed(BC_TOTAL_MOUTH_TIME, "bchat_close_mouth");
	}

	// lchat_close_mouth
	void BaseStorage_OnLchatCloseMouth()
	{
		// (always true here) if !NO_CLOSE_MOUTH
		SetProp(ENT_ME, "controller1", 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseStorage_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnCreateBank() { BaseStorage_OnCreateBank(); } // create_bank
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseStorage_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnCountItems() { BaseStorage_OnCountItems(); } // count_items
	void OnCheckInventory(string category = "", string passString = "") { BaseStorage_OnCheckInventory(category, passString); } // check_inventory
	void OnActivateStorage(CBasePlayer@ player = null) { BaseStorage_OnActivateStorage(player); } // activate_storage
	void OnActivateTickets(CBasePlayer@ player = null) { BaseStorage_OnActivateTickets(player); } // activate_tickets
	void OnSaySelectItem() { BaseStorage_OnSaySelectItem(); } // say_select_item
	void OnReturnTicket(CBasePlayer@ user = null, string storeItem = "") { BaseStorage_OnReturnTicket(user, storeItem); } // return_ticket
	void OnOpenMenu() { BaseStorage_OnOpenMenu(); } // open_menu
	void OnStorageReset() { BaseStorage_OnStorageReset(); } // storage_reset
	void OnCancelTrade(CBasePlayer@ player = null) { BaseStorage_OnCancelTrade(player); } // cancel_trade
	void OnDisplayAbort() { BaseStorage_OnDisplayAbort(); } // display_abort
	void OnRedeemTicket(CBasePlayer@ customerId = null, string returnItem = "") { BaseStorage_OnRedeemTicket(customerId, returnItem); } // redeem_ticket
	void OnEnumAll() { BaseStorage_OnEnumAll(); } // enum_all
	void OnNoteHundred(CBasePlayer@ player = null) { BaseStorage_OnNoteHundred(player); } // note_hundred
	void OnNoteTen(CBasePlayer@ player = null) { BaseStorage_OnNoteTen(player); } // note_ten
	void OnOpenBetabank(string bankUser = "") { BaseStorage_OnOpenBetabank(bankUser); } // open_betabank
	void OnBetabankSuccess() { BaseStorage_OnBetabankSuccess(); } // betabank_success
	void OnBetabankFailed() { BaseStorage_OnBetabankFailed(); } // betabank_failed
	void OnBankIntro1() { BaseStorage_OnBankIntro1(); } // bank_intro1
	void OnBankIntro2() { BaseStorage_OnBankIntro2(); } // bank_intro2
	void OnBuyScroll(CBasePlayer@ player = null) { BaseStorage_OnBuyScroll(player); } // buy_scroll
	void OnSayWondrousCantAfford() { BaseStorage_OnSayWondrousCantAfford(); } // say_wondrous_cant_afford
	void OnLchatMouthMove() { BaseStorage_OnLchatMouthMove(); } // lchat_mouth_move
	void OnLchatCloseMouth() { BaseStorage_OnLchatCloseMouth(); } // lchat_close_mouth
	void OnBcTotalMouthTime() {} // BC_TOTAL_MOUTH_TIME
	void OnBtellerErrorNoItem() {} // bteller_error_no_item
	void OnBtellerGiveTicket() {} // bteller_give_ticket
	void OnBtellerHandWarn() {} // bteller_hand_warn
	void OnBtellerSelectTicket() {} // bteller_select_ticket
	void OnBtellerStoreError() {} // bteller_store_error
	void OnBtellerTicketRedeemed() {} // bteller_ticket_redeemed
	void OnBtellerTicketWarn() {} // bteller_ticket_warn
	void OnConvoAnim() {} // convo_anim

	// This file's events and timers by their .script names
	bool BaseStorage_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_storage") { OnActivateStorage(PlayerParam(params, 0)); return true; }
		if (name == "activate_tickets") { OnActivateTickets(PlayerParam(params, 0)); return true; }
		if (name == "bank_intro1") { OnBankIntro1(); return true; }
		if (name == "bank_intro2") { OnBankIntro2(); return true; }
		if (name == "betabank_failed") { OnBetabankFailed(); return true; }
		if (name == "betabank_success") { OnBetabankSuccess(); return true; }
		if (name == "buy_scroll") { OnBuyScroll(PlayerParam(params, 0)); return true; }
		if (name == "cancel_trade") { OnCancelTrade(PlayerParam(params, 0)); return true; }
		if (name == "check_inventory") { OnCheckInventory(Param(params, 0), Param(params, 1)); return true; }
		if (name == "count_items") { OnCountItems(); return true; }
		if (name == "create_bank") { OnCreateBank(); return true; }
		if (name == "display_abort") { OnDisplayAbort(); return true; }
		if (name == "enum_all") { OnEnumAll(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "lchat_close_mouth") { OnLchatCloseMouth(); return true; }
		if (name == "lchat_mouth_move") { OnLchatMouthMove(); return true; }
		if (name == "note_hundred") { OnNoteHundred(PlayerParam(params, 0)); return true; }
		if (name == "note_ten") { OnNoteTen(PlayerParam(params, 0)); return true; }
		if (name == "open_betabank") { OnOpenBetabank(Param(params, 0)); return true; }
		if (name == "open_menu") { OnOpenMenu(); return true; }
		if (name == "redeem_ticket") { OnRedeemTicket(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "return_ticket") { OnReturnTicket(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "say_select_item") { OnSaySelectItem(); return true; }
		if (name == "say_wondrous_cant_afford") { OnSayWondrousCantAfford(); return true; }
		if (name == "storage_reset") { OnStorageReset(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/base_storage"]
shared class BaseStorageScript : ScriptEntity, BaseStorage
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseStorage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseStorage_DispatchEvent(name, params);
	}
}
