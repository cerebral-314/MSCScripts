#pragma context server

// Converted from nightmare/edanateller.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/NPCs/base_storage.as"

[script "nightmare/edanateller"]
class NightmareEdanateller : BaseNpcScript, BaseChat, BaseStorage
{
	// Constants
	bool PLACEHOLDER = false;
	Vector3 GALA_CHEST_POS = Vector3();
	string CONV_ANIMS = "idle1;flinch;laflinch;raflinch;llflinch;rlflinch";
	string SAYTEXT_wondrous_NOFUNDS = "Need, more, flesh. I mean gold... Need more golds...";
	string SAYTEXT_wondrous_PURCHASED = "One scroll... Use... Wisely.";
	string SAYTEXT_BANKOPEN = "Behold... Your shinies.";
	string SAYTEXT_REFUND = "Fee... Returned.";
	string SAYTEXT_SELECT_ITEM = "Choose... Item.";
	string SAYTEXT_SELECT_CAT = "SAYTEXT_SELECT_CAT";
	string SAYTEXT_NOITEM = "Item, not, received.";
	string SAYTEXT_NOTICKET = "Ticket, needs ticket.";
	string SAYTEXT_NOSTORABLES = "Cannot, store.";
	string SAYTEXT_GIVETICKET = "Ticket, I gives ticket to fleshling.";
	string SAYTEXT_SELECT_TICKET = "Please choose ticket, fleshling.";
	string SAYTEXT_HAND_WARN = "Tickets, in delicious meat hands, please.";
	string SAYTEXT_REDEEMTICKET = "Fleshling... Transaction, complete.";
	string SAYTEXT_ITEMS_HANDS = "Items to store, in delicious meat hands, please.";
	string SAYTEXT_BANK_NOTE = "Give note, in exchange, golds.";
	string ANIM_CHAT = "idle1";
	string ANIM_NO = "llflinch";
	string ANIM_STORE = "raflinch";

	// Variables (an unset .script variable reads as its own name)
	bool NO_HAIL = false;
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool DID_HELLO = false;
	float NEXT_TALK = 0.0f;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_SOUND4 = "CHAT_SOUND4";

	// unnamed block (first think)
	void NightmareEdanateller_FirstThink()
	{
		NO_HAIL = true;
		NO_JOB = true;
		NO_RUMOR = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseStorage_OnGameMenuGetoptions(player); // NPCs/base_storage
		MenuItem menuItem;

		if (!DID_HELLO)
		{
			DID_HELLO = true;
			SayText("Welcome, fleshlings, to Galat's Weapon and Armor Storage, Edeadna branch...");
			PlaySound(0, 10, "voices/nightmare_edana/teller_hail1.wav");
			NEXT_TALK = GameTime() + 6.0f;
		}

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "heard_hi";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		PlayAnim("critical", "rlflinch");
		PlaySound(0, 10, "voices/nightmare_edana/teller_rumors.wav");
		SayText("The rumor mill here... Is kinda dead.");
	}

	// activate_storage
	void OnActivateStorage(CBasePlayer@ player = null)
	{
		BaseStorage_OnActivateStorage(player); // NPCs/base_storage
		PlaySound(0, 10, "voices/nightmare_edana/teller_choose_item.wav");
	}

	// say_select_item
	void OnSaySelectItem()
	{
		BaseStorage_OnSaySelectItem(); // NPCs/base_storage
		PlaySound(0, 10, "voices/nightmare_edana/teller_choose_item.wav");
	}

	// cancel_trade
	void OnCancelTrade(CBasePlayer@ player = null)
	{
		BaseStorage_OnCancelTrade(player); // NPCs/base_storage
		if (RandomInt(1, 2) == 1)
			PlaySound(0, 10, "voices/nightmare_edana/teller_return_fee1.wav");
		else
			PlaySound(0, 10, "voices/nightmare_edana/teller_return_fee2.wav");
	}

	// open_betabank
	void OnOpenBetabank(string bankUser = "")
	{
		BaseStorage_OnOpenBetabank(bankUser); // NPCs/base_storage
		PlaySound(0, 10, "voices/nightmare_edana/teller_return_fee1.wav");
	}

	// buy_scroll
	void OnBuyScroll(CBasePlayer@ player = null)
	{
		BaseStorage_OnBuyScroll(player); // NPCs/base_storage
		PlaySound(0, 10, "voices/nightmare_edana/teller_wscroll_purchased.wav");
	}

	// say_wondrous_cant_afford
	void OnSayWondrousCantAfford()
	{
		BaseStorage_OnSayWondrousCantAfford(); // NPCs/base_storage
		PlaySound(0, 10, "voices/nightmare_edana/teller_wscroll_nofunds.wav");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Deadric of Galat's Storage");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetWidth(16);
		SetHeight(72);
		SetModel("monsters/skeleton.mdl");
		SetModelBody(0, 8);
		SetRoam(false);

		PLAYING_DEAD = "1";

		// dbg temp Edana Teller Spawned
		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("say_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");
	}

	// heard_hi
	void OnHeardHi()
	{
		DID_HELLO = true;
		NEXT_TALK = GameTime() + 6.0f;
		PlayAnim("critical", "idle1");
		SayText("Welcome, fleshlings, to Galat's Weapon and Armor Storage, Edeadna branch...");
		PlaySound(0, 10, "voices/nightmare_edana/teller_hail1.wav");
		CallEventDelayed(6.5f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_hail2.wav");
		SayText("Galat Storage, we're eveeerryyywheeeereee...");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// say_storage_chest
	void OnSayStorageChest()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "say_storage_chest");
		if (BUSY_CHATTING)
			return;
		OnConvoAnim();
		CHAT_STEPS = 4;
		CHAT_STEP1 = "Galat chest...";
		CHAT_DELAY_STEP1 = "1.5";
		CHAT_SOUND1 = "voices/nightmare_edana/teller_gchest1.wav";
		CHAT_STEP2 = "Put items to store in your, delicious, meat hands...";
		CHAT_DELAY_STEP2 = "4.25";
		CHAT_SOUND2 = "voices/nightmare_edana/teller_gchest2.wav";
		CHAT_STEP3 = "Then use chest...";
		CHAT_DELAY_STEP3 = "2.0";
		CHAT_SOUND3 = "voices/nightmare_edana/teller_gchest3.wav";
		CHAT_STEP4 = "Stores stuff...";
		CHAT_DELAY_STEP4 = "2.0";
		CHAT_SOUND4 = "voices/nightmare_edana/teller_gchest4.wav";
		OnChatLoop();
	}

	// say_wondrous
	void OnSayWondrous()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "say_wondrous");
		if (BUSY_CHATTING)
			return;
		OnConvoAnim();
		CHAT_STEPS = 4;
		CHAT_STEP1 = "Wondrous Scroll of Galat's Storage...";
		CHAT_DELAY_STEP1 = "3.0";
		CHAT_SOUND1 = "voices/nightmare_edana/teller_wscroll1.wav";
		CHAT_STEP2 = "Summons chests with demonic magicks.";
		CHAT_DELAY_STEP2 = "3.5";
		CHAT_SOUND2 = "voices/nightmare_edana/teller_wscroll2.wav";
		CHAT_STEP3 = "Use anywhere.";
		CHAT_DELAY_STEP3 = "1.5";
		CHAT_SOUND3 = "voices/nightmare_edana/teller_wscroll3.wav";
		CHAT_STEP4 = "Exchange is " + GALA_SCROLL_PRICE + " golds. ...or one soul.";
		CHAT_DELAY_STEP4 = "4.0";
		if (RandomInt(1, 2) == 1)
			CHAT_SOUND4 = "voices/nightmare_edana/teller_wscroll4a.wav";
		else
			CHAT_SOUND4 = "voices/nightmare_edana/teller_wscroll4b.wav";
		OnChatLoop();
	}

	// bteller_error_no_item
	void OnBtellerErrorNoItem()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_store_error.wav");
	}

	// bteller_error_no_ticket
	void OnBtellerErrorNoTicket()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_ticket_error.wav");
	}

	// bteller_store_error
	void OnBtellerStoreError()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_store_error.wav");
	}

	// bteller_give_ticket
	void OnBtellerGiveTicket()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_ticket_purchased.wav");
	}

	// bteller_select_ticket
	void OnBtellerSelectTicket()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_choose_item.wav");
	}

	// bteller_ticket_warn
	void OnBtellerTicketWarn()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_ticket_detect.wav");
	}

	// bteller_ticket_redeemed
	void OnBtellerTicketRedeemed()
	{
		PlaySound(0, 10, "voices/nightmare_edana/teller_store_success.wav");
	}

	// bteller_hand_warn
	void OnBtellerHandWarn()
	{
		if (!DID_HELLO)
			return;
		if (!(GameTime() > NEXT_TALK))
			return;

		if (RandomInt(1, 2) == 1)
			PlaySound(0, 10, "voices/nightmare_edana/teller_items_in_hands1.wav");
		else
			PlaySound(0, 10, "voices/nightmare_edana/teller_items_in_hands2.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseStorage_OnGameSpawn(playerRace, playerGender); // NPCs/base_storage
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NightmareEdanateller_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
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
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_hi2") { OnHeardHi2(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "open_betabank") { OnOpenBetabank(Param(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_select_item") { OnSaySelectItem(); return true; }
		if (name == "say_storage_chest") { OnSayStorageChest(); return true; }
		if (name == "say_wondrous") { OnSayWondrous(); return true; }
		if (name == "say_wondrous_cant_afford") { OnSayWondrousCantAfford(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseStorage_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
