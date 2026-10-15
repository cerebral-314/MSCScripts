#pragma context server

// Converted from helena/storage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/base_storage.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_civilian.as"
#include "converted/helena/helena_npc.as"

[script "helena/storage"]
class HelenaStorage : BaseNpcScript, BaseStorage, BaseChat, BaseCivilian, HelenaNpc
{
	// Constants
	Vector3 GALA_CHEST_POS = Vector3();
	string ANIM_CHAT = "pondering3";
	string ANIM_NO = "no";
	string ANIM_STORE = "return_needle";
	string SAYTEXT_REFUND = "Ummm Okay... Here's yer fee back. Come back anytime.";
	string SAYTEXT_SELECT_ITEM = "What would you like to store?";
	string SAYTEXT_NOITEM = "Er, sorry, I didn't get the the thing you were going to store.";
	string SAYTEXT_NOTICKET = "Sorry, I didn't get your ticket.";
	string SAYTEXT_NOSTORABLES = "Sorry, I'm afraid you have nothing I can store for you.";
	string SAYTEXT_GIVETICKET = "Here's your ticket! Remember, ya can redeem that at any Galat outlet.";
	string SAYTEXT_SELECT_TICKET = "Which ticket would do you like to redeem?";
	string SAYTEXT_HAND_WARN = "Please place your tickets in your hands so I can redeem them for you.";
	string SAYTEXT_REDEEMTICKET = "Th.. th... Thank you for using Galat Storage... Please come again! ...SOON!";
	string SAYTEXT_ITEMS_HANDS = "Please hold forth any items you wish to store in your hands.";
	string SAYTEXT_wondrous_NOFUNDS = "Eh, look, I can't take less than that for it. Sorry, but I need this job.";
	string SAYTEXT_wondrous_PURCHASED = "Here you go. Careful not to summon it into any walls. Remember: no refunds!";
	bool NO_HAIL = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	bool CHATTING = false;
	bool DID_HELLO = false;
	bool IS_FLEEING = false;
	float FEE_HP_RATIO = 0.0f;
	int STORE_CLOSED = 0;
	bool RAID_ON = false;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string ANIM_STEP1 = "ANIM_STEP1";
	string ANIM_STEP2 = "ANIM_STEP2";
	string ANIM_STEP3 = "ANIM_STEP3";
	string ANIM_STEP4 = "ANIM_STEP4";

	// Variables declared by included files, with the value they start with in this script
	HelenaStorage()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk_scared";
	}

	// unnamed block (first think)
	void HelenaStorage_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk_scared";
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseStorage_OnGameMenuGetoptions(player); // NPCs/base_storage
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!DID_HELLO)
		{
			DID_HELLO = true;
			PlayAnim("critical", "eye_wipe");
			SayText("Umm... Oh yeah... Welcome to Galat's Weapon and Armor Storage!");
			PlaySound(0, 10, "voices/helena/smivel/startled_hello.wav");
		}

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "heard_hi";
		RegisterMenuItem(menuItem);
	}

	// activate_storage
	void OnActivateStorage(CBasePlayer@ player = null)
	{
		BaseStorage_OnActivateStorage(player); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/store_item.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_wants_to_store.wav");
	}

	// say_select_item
	void OnSaySelectItem()
	{
		BaseStorage_OnSaySelectItem(); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/store_item.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_wants_to_store.wav");
	}

	// cancel_trade
	void OnCancelTrade(CBasePlayer@ player = null)
	{
		BaseStorage_OnCancelTrade(player); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/cancelled_transaction.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_declines_to_store.wav");
	}

	// open_betabank
	void OnOpenBetabank(string bankUser = "")
	{
		BaseStorage_OnOpenBetabank(bankUser); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/cancelled_transaction.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_declines_to_store.wav");
	}

	// buy_scroll
	void OnBuyScroll(CBasePlayer@ player = null)
	{
		BaseStorage_OnBuyScroll(player); // NPCs/base_storage
		OnChatMoveMouth("4.0");
		// playsound 0 10 "voices/sorc_villa/varondo/scroll_bought.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_buys_scroll.wav");
	}

	// say_wondrous_cant_afford
	void OnSayWondrousCantAfford()
	{
		BaseStorage_OnSayWondrousCantAfford(); // NPCs/base_storage
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/failure_no_money.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_lacks_funds.wav");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		SetRoam(true);
		SetMoveAnim(ANIM_RUN);
		SetMoveDest(ENT_LASTSTRUCK, 9999, "flee");
		SetMenuAutoOpen(false);
		if (IS_FLEEING)
			return;
		IS_FLEEING = true;
		CallEventDelayed(20.0f, "stop_fleeing");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		PlayAnim("critical", "panic");
		OnBchatAutoMouthMove("3.0");
		SayText("I'm hoping to get promoted to the Deralia branch - IT ISN'T SAFE HERE!");
		PlaySound(0, 10, "voices/helena/smivel/im_hoping_to_get_promoted.wav");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Smivel of Galat's Storage");
		SetHealth(30);
		SetInvincible(false);
		SetGold(0);
		SetRace("human");
		SetWidth(28);
		SetHeight(96);
		SetModel("npc/human1.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		SetRoam(false);
		PlayAnim("once", "idle1");
		SetModelBody(0, 3);
		SetModelBody(1, 4);

		// dbg temp Gatecity Teller Spawned
		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("say_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");
	}

	// heard_hi
	void OnHeardHi()
	{
		if (CHATTING)
			return;
		CHATTING = true;

		DID_HELLO = true;
		PlayAnim("critical", "checktie");
		SayText("Eh? Oh, hello good sir... Um... Welcome to Galat's Weapon and Armor Storage.");
		PlaySound(0, 10, "voices/helena/smivel/welcome_to_galats.wav");
		CallEventDelayed(5.8f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		SayText("For a nominal fee, we can store weapons and armor.");
		PlaySound(0, 10, "voices/helena/smivel/for_a_nominal_fee.wav");
		CallEventDelayed(4.2f, "heard_hi3");
	}

	// heard_hi3
	void OnHeardHi3()
	{
		SayText("We'll give you a ticket for any item that we can store.");
		PlaySound(0, 10, "voices/helena/smivel/well_give_you_a_ticket.wav");
		CallEventDelayed(3.1f, "heard_hi4");
	}

	// heard_hi4
	void OnHeardHi4()
	{
		SayText("Thanks to our contacts with the Felewyn wizards, you may redeem this ticket at any Galat outlet!");
		PlaySound(0, 10, "voices/helena/smivel/thanks_to_our_contacts.wav");
		CallEventDelayed(5.9f, "heard_hi5");
	}

	// heard_hi5
	void OnHeardHi5()
	{
		CHATTING = false;
		PlayAnim("critical", "lean");
		SayText("There are many other Galat outlets... All of which are in safer places than mine!");
		PlaySound(0, 10, "voices/helena/smivel/there_are_many_other_outlets.wav");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// stop_fleeing
	void OnStopFleeing()
	{
		SetMoveDest("MY_HOME", 10);
		SetMoveAnim(ANIM_WALK);

		SetMenuAutoOpen(true);
		SetRoam(false);
		IS_FLEEING = false;
	}

	// orc_raid
	void OnOrcRaid()
	{
		IS_FLEEING = true;
		OnGameStruck();
	}

	// tele_home
	void OnTeleHome()
	{
		FEE_HP_RATIO = 0.01f;
	}

	// helena_made_it_home
	void OnHelenaMadeItHome()
	{
		// special case, vendor without store
		// vendors snap to
		SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
		float oldYaw = NPC_HOME_ANG.y;
		SetAngle("face", Vector3(0, oldYaw, 0));
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		SetRoam(false);
		SetMenuAutoOpen(true);
		STORE_CLOSED = 0;
		RAID_ON = false;
	}

	// say_storage_chest
	void OnSayStorageChest()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "say_storage_chest");
		if (BUSY_CHATTING)
			return;
		OnConvoAnim();
		CHAT_STEPS = 5;

		CHAT_STEP1 = "Oh yeah, that thing. Umm.. That's the new magical storage chest Galat put out recently.";
		CHAT_SOUND1 = "voices/helena/smivel/oh_yeah_that_thing.wav";
		CHAT_DELAY_STEP1 = "6.5";

		CHAT_STEP2 = "Eh, well.. You can put things in it, and it will store them for you.";
		CHAT_SOUND2 = "voices/helena/smivel/well_you_can_put_things_in_it.wav";
		CHAT_DELAY_STEP2 = "3.9";

		// setvard CHAT_STEP3 "Just place the items you want to store in your hands, and use the chest."
		// canna find sound file
		CHAT_STEP3 = "You can take things out too, of course. Just treat it like any other chest for that.";
		CHAT_SOUND3 = "voices/helena/smivel/you_can_take_things_out_too.wav";
		CHAT_DELAY_STEP3 = "4.7";

		CHAT_STEP4 = "Each customer's items are kept in a Dim... Dim-en-sion-al pocket. So they, eh, don't get mixed up.";
		CHAT_SOUND4 = "voices/helena/smivel/each_customers_items_are_stored.wav";
		CHAT_DELAY_STEP4 = "9.0";

		CHAT_STEP5 = "It holds maybe a few dozen items or so. Feel free to use it. Damn thing gives me the creeps.";
		CHAT_SOUND5 = "voices/helena/smivel/holds_a_dozen_items.wav";
		CHAT_DELAY_STEP5 = "6.3";

		OnChatLoop();
	}

	// say_wondrous
	void OnSayWondrous()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "say_wondrous");
		if (BUSY_CHATTING)
			return;
		CHAT_STEPS = 4;
		ANIM_STEP1 = "checktie";
		CHAT_STEP1 = "Oh yes, *cough* with Galat's new Wondrous Scroll, you can summon forth a Galat's Wondrous Chest, anywhere.";
		CHAT_SOUND1 = "voices/helena/smivel/with_galats_new_wonderous_scroll.wav";
		CHAT_DELAY_STEP1 = "8.5";

		ANIM_STEP2 = "lean";
		CHAT_STEP2 = "Which, I'd guess, would be very useful given the sort of places adventurer's like yourself get off to.";
		CHAT_SOUND2 = "voices/helena/smivel/with_i_guess_would_be_very_useful.wav";
		CHAT_DELAY_STEP2 = "6.3";

		ANIM_STEP3 = "eye_wipe";
		CHAT_STEP3 = "We're supposed to sell these things for... Wow... That can't be right... Ummm... ";
		CHAT_STEP3 += Text(GALA_SCROLL_PRICE) + " gold.";
		CHAT_SOUND3 = "voices/helena/smivel/were_supposed_to_sell_these_things_for.wav";
		CHAT_DELAY_STEP3 = "7.7";

		ANIM_STEP4 = "no";
		CHAT_STEP4 = "I guess the higher ups at Galat figure adventurer's like yourself are just made of gold.";
		CHAT_SOUND4 = "voices/helena/smivel/i_figure_the_higher_ups_at_galats.wav";
		CHAT_DELAY_STEP4 = "5.2";

		DebugPrint("say_wondrous " + ANIM_STEP1);
		OnChatLoop();
	}

	// bteller_error_no_item
	void OnBtellerErrorNoItem()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/failed_itemget.wav"
		PlaySound(0, 10, "voices/helena/smivel/bank_didnt_get_the_item.wav");
	}

	// bteller_error_no_ticket
	void OnBtellerErrorNoTicket()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/failed_ticketget.wav"
		PlaySound(0, 10, "voices/helena/smivel/bank_failed_to_find_ticket.wav");
	}

	// bteller_store_error
	void OnBtellerStoreError()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/no_storables.wav"
		PlaySound(0, 10, "voices/helena/smivel/no_items_to_store.wav");
	}

	// bteller_give_ticket
	void OnBtellerGiveTicket()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/storage_success.wav"
		PlaySound(0, 10, "voices/helena/smivel/heres_your_ticket.wav");
	}

	// bteller_select_ticket
	void OnBtellerSelectTicket()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/request_redeem_ticket.wav"
		PlaySound(0, 10, "voices/helena/smivel/player_asks_to_redeem.wav");
	}

	// bteller_ticket_warn
	void OnBtellerTicketWarn()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/no_ticket_in_hands.wav"
		PlaySound(0, 10, "voices/helena/smivel/please_place_ticket_in_hands.wav");
	}

	// bteller_ticket_redeemed
	void OnBtellerTicketRedeemed()
	{
		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/success_other.wav"
		PlaySound(0, 10, "voices/helena/smivel/thank_you_for_using_galat_storage.wav");
	}

	// bteller_hand_warn
	void OnBtellerHandWarn()
	{
		if (!DID_HELLO)
			return;
		if (!(GameTime() > 0.0f))
			return;

		OnChatMoveMouth("3.0");
		// playsound 0 10 "voices/sorc_villa/varondo/please_hold_forth_items.wav"
		PlaySound(0, 10, "voices/helena/smivel/please_hold_forth_items.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseStorage_OnGameSpawn(playerRace, playerGender); // NPCs/base_storage
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	void OnConvoAnim() { BaseChat_OnConvoAnim(); } // convo_anim
	void OnCallForHelp(CBaseEntity@ attacker = null) { HelenaNpc_OnCallForHelp(attacker); } // call_for_help
	void OnChatMoveMouth(string duration = "") {} // chat_move_mouth

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaStorage_FirstThink();
		BaseStorage_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
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
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_hi2") { OnHeardHi2(); return true; }
		if (name == "heard_hi3") { OnHeardHi3(); return true; }
		if (name == "heard_hi4") { OnHeardHi4(); return true; }
		if (name == "heard_hi5") { OnHeardHi5(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "helena_made_it_home") { OnHelenaMadeItHome(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "open_betabank") { OnOpenBetabank(Param(params, 0)); return true; }
		if (name == "orc_raid") { OnOrcRaid(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_select_item") { OnSaySelectItem(); return true; }
		if (name == "say_storage_chest") { OnSayStorageChest(); return true; }
		if (name == "say_wondrous") { OnSayWondrous(); return true; }
		if (name == "say_wondrous_cant_afford") { OnSayWondrousCantAfford(); return true; }
		if (name == "stop_fleeing") { OnStopFleeing(); return true; }
		if (name == "tele_home") { OnTeleHome(); return true; }
		return BaseStorage_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseCivilian_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
