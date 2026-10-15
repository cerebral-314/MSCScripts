#pragma context server

// Converted from sorc_villa/storage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/NPCs/base_storage.as"

[script "sorc_villa/storage"]
class SorcVillaStorage : BaseChatArrayScript, BaseStorage
{
	// Constants
	Vector3 GALA_CHEST_POS = Vector3();
	string ANIM_CHAT = "look_idle";
	string ANIM_NO = "look_idle";
	string ANIM_STORE = "ref_shoot_trip";
	string SAYTEXT_REFUND = "Very well, I shall refund your fee then.";
	string SAYTEXT_SELECT_ITEM = "Which item would you like us to store?";
	string SAYTEXT_NOITEM = "I apologize, but I did not receive the item you wished to store.";
	string SAYTEXT_NOTICKET = "It seems that I did not receive your ticket.";
	string SAYTEXT_NOSTORABLES = "I fear that you have no items which we can store for you.";
	string SAYTEXT_GIVETICKET = "Very good then, here is your ticket. Remember, as always, you may redeem such tickets at any Galat outlet.";
	string SAYTEXT_SELECT_TICKET = "Very well then, which ticket would do you like to redeem?";
	string SAYTEXT_HAND_WARN = "Please, for the love of Felewyn, remember to place the tickets you wish to redeem in your in your hands.";
	string SAYTEXT_REDEEMTICKET = "We of Galat appreciate your business.";
	string SAYTEXT_ITEMS_HANDS = "Please hold forth any items you wish to store in your hands.";
	string SAYTEXT_wondrous_NOFUNDS = "I'm afraid you lack sufficient funds for this service.";
	string SAYTEXT_wondrous_PURCHASED = "One scroll it is. Please be careful as to its usage, as we cannot provide refunds should you be foolish enough to summon the chest into a wall.";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	int DID_INTRO = 0;
	CBaseEntity@ PLAYER_SPOTTED = null;
	bool DID_HELLO = false;
	bool DID_SNIDE = false;

	// Variables declared by included files, with the value they start with in this script
	SorcVillaStorage()
	{
		CHAT_NEVER_INTERRUPT = true;
		CHAT_CONV_ANIMS = "look_idle;deep_idle;ref_aim_egon;ref_aim_squeek";
	}

	// unnamed block (first think)
	void SorcVillaStorage_FirstThink()
	{
		ANIM_IDLE = "idle";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseStorage_OnGameSpawn(playerRace, playerGender); // NPCs/base_storage

		SetName("Magi Varondo");
		SetHealth(30);
		SetInvincible(true);
		SetNoPush(true);
		SetGold(0);
		SetRace("beloved");
		SetWidth(28);
		SetHeight(96);
		SetModel("npc/elf_m_wizard.mdl");
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		SetRoam(false);
		PlayAnim("once", "idle");

		SetModelBody(1, 2); // 0=Unarmed 1=Dark_Staff 2=Dragon_Staff 3=H4xbow
		SetProp(ENT_ME, "skin", 7); // 0=Young_Black_Robe 1=Elder_Black_Robe 2=Young_Green_Robe 3=Elder_Green_Robe 4=Young_Puce_Robe 5=Elder_Puce_Robe 6=Good_Pale 7=Good_Pink

		// dbg temp Gatecity Teller Spawned
		SetSayTextRange(512);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("say_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");

		CallEventDelayed(1.0f, "scan_for_players");

		OnChatAddText("introf_text", "Ah, salutations to the young adventurers. I had overheard there were some honored guests in the villa, but I knew not whether to believe my elven ears.", "7.6", "sound:voices/sorc_villa/varondo/villa_friendly_greeting_part_1.wav");
		OnChatAddText("introf_text", "Greetings. I am Vorondo, stationed here by Galat to provide services to those unfortunate enough to pass though these orc infested lands.", "8.1", "sound:voices/sorc_villa/varondo/villa_friendly_greeting_part_2.wav");

		OnChatAddText("introh_text", "Salutations, young adventurers. I would not venture further, for the villa just beyond this bend belongs to Runegahr and the Shadahar Orcs.", "7.1", "sound:voices/sorc_villa/varondo/villa_enemy_greeting_part_1.wav");
		OnChatAddText("introh_text", "They tolerate my presence here, but would no doubt attempt to slay me were I to move closer, and they'll treat you no better, no doubt.", "7.3", "sound:voices/sorc_villa/varondo/villa_enemy_greeting_part_2.wav");
		OnChatAddText("introh_text", "Should you choose to enter the villa, and are attacked - and mark my words, you will be - I fear I will not be able to assist you.", "7.1", "sound:voices/sorc_villa/varondo/villa_enemy_greeting_part_3.wav");
		OnChatAddText("introh_text", "Galat wishes to maintain peaceful relations with this particular orc tribe, and thus I am forbade to interfere save in self-defense...", "7.4", "sound:voices/sorc_villa/varondo/villa_enemy_greeting_part_4.wav");
		OnChatAddText("introh_text", "...and even then, I am under strict orders to favor discretion over valor.", "4.5", "sound:voices/sorc_villa/varondo/villa_enemy_greeting_part_5.wav");

		OnChatAddText("hail_text", "I am Vorondo, stationed in this gods forsaken land to provide Galat services to those few who can make use of them.", "6.1", "sound:voices/sorc_villa/varondo/hailed.wav");
		OnChatAddText("hail_text", "The orcs, savages though they maybe, tollerate my presense, so long as I setup shop no closer to their stronghold than this.", "7.1", "sound:voices/sorc_villa/varondo/hailed_2.wav");
		OnChatAddText("hail_text", "I would have prefered, of course, to be stationed in Eswen Sylen, or someplace closer to my homeland - anywhere but here, really...", "8.0", "sound:voices/sorc_villa/varondo/hailed_3.wav");
		OnChatAddText("hail_text", "But alas, as one of the few who can both defend themselves, and dependably provide Galat services, I drew the short straw, and wound up out... Here.", "9.5", "sound:voices/sorc_villa/varondo/hailed_4.wav");
		OnChatAddText("hail_text", "It could be worse, I suppose. One does grow accustom to the smell of orc, over time. Now what services may I offer one of my rare customers?", "5.5", "sound:voices/sorc_villa/varondo/hailed_5.wav");

		OnChatAddText("rumor_text", "Fear not for me. I am quite capable of defending myself. Not that I would attempt to move closer to the villa, for fear of the bloodbath that would ensue.", "8.5", "sound:voices/sorc_villa/varondo/rumours_or_survival_1.wav");
		OnChatAddText("rumor_text", "I suppose, the high bankers of Galat had hoped to extend a hand of friendship to these orcs, for while they are still savages, they are more civil than most...", "7.7", "sound:voices/sorc_villa/varondo/rumours_or_survival_2.wav");
		OnChatAddText("rumor_text", "I fear the effort has been ill-fated, however, for thus far, only two orcs have dared to use my services, and the rest have only agreed to stop trying to devour me.", "8.4", "sound:voices/sorc_villa/varondo/rumours_or_survival_3.wav");
		OnChatAddText("rumor_text", "The human merchant from Sunden-dal uses my services, at least, so it isn't a total waste of my time - though I could surely think of more pleasant ways to spend it.", "9.2", "sound:voices/sorc_villa/varondo/rumours_or_survival_4.wav");
		OnChatAddText("rumor_text", "It would be only slightly safer to setup in Sunden-dal, to the south, for it has problems of its own, though, unquestionably, the odor would be more pleasant.", "8.3", "sound:voices/sorc_villa/varondo/rumours_or_survival_5.wav");
		OnChatAddText("rumor_text", "But alas, the Galat management has deemed the place too small to bother with, I suppose.", "5.2", "sound:voices/sorc_villa/varondo/rumours_or_survival_6.wav");
		OnChatAddText("rumor_text", "...And thus, by cruel twist of fate, here I am.", "4.2", "sound:voices/sorc_villa/varondo/rumours_or_survival_7.wav");

		OnChatAddText("storage_chest", "This, as I am sure you already know, is the enchanted Galat Storage Chest.", "5.7", "sound:voices/sorc_villa/varondo/asked_about_chest_1.wav");
		OnChatAddText("storage_chest", "You may place items held in your hands into the chest with relative ease.", "4.6", "sound:voices/sorc_villa/varondo/asked_about_chest_2.wav");
		OnChatAddText("storage_chest", "To withdraw items, simply open the chest and remove the items you desire.", "4.3", "sound:voices/sorc_villa/varondo/asked_about_chest_3.wav");
		OnChatAddText("storage_chest", "The chest employs a dimensional pocket system, and thus will display an inventory unique to each customer's account.", "5.9", "sound:voices/sorc_villa/varondo/asked_about_chest_4.wav");
		OnChatAddText("storage_chest", "The chest can hold a limited number of items for each customer, and it cannot store every type of item, so please be aware of its limitations.", "6.9", "sound:voices/sorc_villa/varondo/asked_about_chest_5.wav");

		OnChatAddText("scroll_text", "The Wondrous Scroll allows you to summon a Galat Storage Chest anywhere you may happen to be at the time.", "5.2", "sound:voices/sorc_villa/varondo/asked_about_scroll_1.wav");
		OnChatAddText("scroll_text", "Needless to say, this is quite useful for adventurers such as yourself, who often find themselves in, shall we say, out of the way places.", "9.1", "sound:voices/sorc_villa/varondo/asked_about_scroll_2.wav");
		OnChatAddText("scroll_text", "Though it requires no magical skill, per say, one must be careful, when employing the scroll, not to summon the chest inside a wall or other obstacle.", "7.6", "sound:voices/sorc_villa/varondo/asked_about_scroll_3.wav");
		string scrollLine = "The scroll is not for the faint of fortune, however. It currently sells for ";
		scrollLine += Text(GALA_SCROLL_PRICE) + " gold.";
		OnChatAddText("scroll_text", scrollLine, "5.2", "sound:voices/sorc_villa/varondo/asked_about_scroll_4.wav");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		BaseStorage_OnGameMenuGetoptions(player); // NPCs/base_storage
		MenuItem menuItem;

		SetMoveDest(@player, 9999);

		if (!DID_HELLO && !DID_SNIDE)
		{
			DID_SNIDE = true;
			CallEventDelayed(60.0f, "reset_side");
			if (!CHAT_BUSY)
				OnChatNow("Welcome to Galat's Weapon and Armor Storage. We're everywhere, apparently.", "3.8", "sound:voices/sorc_villa/varondo/idle_gripe.wav");
		}

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "heard_hi";
		RegisterMenuItem(menuItem);

		menuItem.title = "A lone elf?";
		menuItem.type = "callback";
		menuItem.callback = "say_rumor";
		RegisterMenuItem(menuItem);
	}

	// activate_storage
	void OnActivateStorage(CBasePlayer@ player = null)
	{
		BaseStorage_OnActivateStorage(player); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/store_item.wav");
	}

	// say_select_item
	void OnSaySelectItem()
	{
		BaseStorage_OnSaySelectItem(); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/store_item.wav");
	}

	// cancel_trade
	void OnCancelTrade(CBasePlayer@ player = null)
	{
		BaseStorage_OnCancelTrade(player); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/cancelled_transaction.wav");
	}

	// open_betabank
	void OnOpenBetabank(string bankUser = "")
	{
		BaseStorage_OnOpenBetabank(bankUser); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/cancelled_transaction.wav");
	}

	// buy_scroll
	void OnBuyScroll(CBasePlayer@ player = null)
	{
		BaseStorage_OnBuyScroll(player); // NPCs/base_storage
		OnChatMoveMouth("4.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/scroll_bought.wav");
	}

	// say_wondrous_cant_afford
	void OnSayWondrousCantAfford()
	{
		BaseStorage_OnSayWondrousCantAfford(); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/failure_no_money.wav");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		if (Truthy(LegacyFunction("cansee", "player", 256)))
		{
			DID_INTRO = 1;
			@PLAYER_SPOTTED = EntityOf(ENT_LASTSEEN);
			OnDoIntro();
		}
		else
		{
			CallEventDelayed(1.0f, "scan_for_players");
		}
	}

	// do_intro
	void OnDoIntro()
	{
		if (Truthy(GetVar("G_SORCV_FRIENDLY")))
			OnDoIntroFriendly();
		else
			OnDoIntroHostile();
	}

	// do_intro_friendly
	void OnDoIntroFriendly()
	{
		SetMoveDest(@PLAYER_SPOTTED, 9999);
		OnChatStartSequence("introf_text");
	}

	// do_intro_hostile
	void OnDoIntroHostile()
	{
		SetMoveDest(@PLAYER_SPOTTED, 9999);
		OnChatStartSequence("introh_text");
	}

	// heard_hi
	void OnHeardHi()
	{
		DID_HELLO = true;
		OnChatStartSequence("hail_text");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		DID_HELLO = true;
		OnChatStartSequence("rumor_text");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// reset_side
	void OnResetSide()
	{
		DID_SNIDE = false;
	}

	// say_storage_chest
	void OnSayStorageChest()
	{
		OnChatStartSequence("storage_chest");
	}

	// say_wondrous
	void OnSayWondrous()
	{
		OnChatStartSequence("scroll_text");
	}

	// bteller_error_no_item
	void OnBtellerErrorNoItem()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/failed_itemget.wav");
	}

	// bteller_error_no_ticket
	void OnBtellerErrorNoTicket()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/failed_ticketget.wav");
	}

	// bteller_store_error
	void OnBtellerStoreError()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/no_storables.wav");
	}

	// bteller_give_ticket
	void OnBtellerGiveTicket()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/storage_success.wav");
	}

	// bteller_select_ticket
	void OnBtellerSelectTicket()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/request_redeem_ticket.wav");
	}

	// bteller_ticket_warn
	void OnBtellerTicketWarn()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/no_ticket_in_hands.wav");
	}

	// bteller_ticket_redeemed
	void OnBtellerTicketRedeemed()
	{
		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/success_other.wav");
	}

	// bteller_hand_warn
	void OnBtellerHandWarn()
	{
		if (!DID_HELLO)
			return;
		if (!(GameTime() > 0.0f))
			return;

		OnChatMoveMouth("3.0");
		PlaySound(0, 10, "voices/sorc_villa/varondo/please_hold_forth_items.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_m_wizard.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcVillaStorage_FirstThink();
		BaseChatArray_FirstThink();
		BaseStorage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "activate_storage") { OnActivateStorage(PlayerParam(params, 0)); return true; }
		if (name == "bteller_error_no_item") { OnBtellerErrorNoItem(); return true; }
		if (name == "bteller_error_no_ticket") { OnBtellerErrorNoTicket(); return true; }
		if (name == "bteller_give_ticket") { OnBtellerGiveTicket(); return true; }
		if (name == "bteller_hand_warn") { OnBtellerHandWarn(); return true; }
		if (name == "bteller_select_ticket") { OnBtellerSelectTicket(); return true; }
		if (name == "bteller_store_error") { OnBtellerStoreError(); return true; }
		if (name == "bteller_ticket_redeemed") { OnBtellerTicketRedeemed(); return true; }
		if (name == "bteller_ticket_warn") { OnBtellerTicketWarn(); return true; }
		if (name == "buy_scroll") { OnBuyScroll(PlayerParam(params, 0)); return true; }
		if (name == "cancel_trade") { OnCancelTrade(PlayerParam(params, 0)); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro_friendly") { OnDoIntroFriendly(); return true; }
		if (name == "do_intro_hostile") { OnDoIntroHostile(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "open_betabank") { OnOpenBetabank(Param(params, 0)); return true; }
		if (name == "reset_side") { OnResetSide(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_select_item") { OnSaySelectItem(); return true; }
		if (name == "say_storage_chest") { OnSayStorageChest(); return true; }
		if (name == "say_wondrous") { OnSayWondrous(); return true; }
		if (name == "say_wondrous_cant_afford") { OnSayWondrousCantAfford(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		return BaseStorage_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
