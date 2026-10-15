#pragma context server

// Converted from NPCs/base_banker.script by msc_transpiler.
// Generic banker

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseBanker
{
	// Constants
	string STORAGE_DISPLAYNAME = "Edana Bank";
	string STORAGE_NAME = "edanastorage";
	float STORAGE_FEERATIO = 0.10f;
	int STORAGE_ACCOUNT_COST = 20;

	// Variables (an unset .script variable reads as its own name)
	bool CHECK_REASON = false;

	// unnamed block (first think)
	void BaseBanker_FirstThink()
	{
		DeleteEntity(ENT_ME);
	}

	// game_playerused
	void BaseBanker_OnGamePlayerused(CBasePlayer@ player = null)
	{
		CHECK_REASON = false;

		LegacyCommand("storage", "checkaccount", STORAGE_NAME, ENT_LASTUSED, "used_checkaccount");
	}

	// used_checkaccount_success
	void BaseBanker_OnUsedCheckaccountSuccess()
	{
		OnBankTrade(FindPlayer(ENT_LASTUSED));
	}

	// used_checkaccount_failed
	void BaseBanker_OnUsedCheckaccountFailed()
	{
		SayText("Sorry, you don't have an account with us");
		OpenMenu(ENT_LASTUSED);
		CallEventDelayed(1.0f, "speech_makeaccount");
	}

	// speech_makeaccount
	void BaseBanker_OnSpeechMakeaccount()
	{
		SayText("You can create an account with this bank for " + STORAGE_ACCOUNT_COST + " gold");
	}

	// game_recvoffer_gold
	void BaseBanker_OnGameRecvofferGold()
	{
		LegacyCommand("storage", "checkaccount", STORAGE_NAME, ENT_LASTUSED, "offer_checkacct");
	}

	// offer_checkacct_success
	void BaseBanker_OnOfferCheckacctSuccess()
	{
		ReceiveOffer("reject");
		SayText("You already have an account with us.");
	}

	// offer_checkacct_failed
	void BaseBanker_OnOfferCheckacctFailed()
	{
		if (Float(Eval("game.offer.gold")) >= STORAGE_ACCOUNT_COST)
		{
			ReceiveOffer("accept");

			OnBankOpenaccount(FindPlayer(ENT_LASTGAVE));
		}
		else
		{
			ReceiveOffer("reject");

			OnBankOpenaccountFailed();
		}
	}

	// game_menu_getoptions
	void BaseBanker_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		LegacyCommand("storage", "checkaccount", STORAGE_NAME, @player, "menuitem_checkacct");
	}

	// menuitem_checkacct_failed
	void BaseBanker_OnMenuitemCheckacctFailed()
	{
		MenuItem menuItem;

		menuItem.id = "payment";
		menuItem.title = "Open Account";
		menuItem.type = "payment";
		menuItem.data = "gold:" + STORAGE_ACCOUNT_COST;
		menuItem.callback = "bank_openaccount";
		menuItem.cb_failed = "menu_recv_payment_failed";

		RegisterMenuItem(menuItem);
	}

	// menuitem_checkacct_succes
	void BaseBanker_OnMenuitemCheckacctSucces()
	{
		MenuItem menuItem;

		menuItem.id = "bank";
		menuItem.title = "Bank";
		menuItem.type = "callback";
		menuItem.data = "gold:" + STORAGE_ACCOUNT_COST;
		menuItem.callback = "bank_trade";
		menuItem.cb_failed = "";

		RegisterMenuItem(menuItem);
	}

	// bank_trade
	void BaseBanker_OnBankTrade(CBasePlayer@ player = null)
	{
		LegacyCommand("storage", "trade", STORAGE_NAME, @player, STORAGE_FEERATIO, STORAGE_DISPLAYNAME);
	}

	// bank_openaccount
	void BaseBanker_OnBankOpenaccount(CBasePlayer@ player = null)
	{
		LegacyCommand("storage", "openaccount", STORAGE_NAME, @player);

		SayText("Thank you! Your new account with " + STORAGE_DISPLAYNAME + " is open!");
		PlayAnim("once", "yes");
	}

	// bank_openaccount_failed
	void BaseBanker_OnBankOpenaccountFailed()
	{
		SayText("I'm sorry, we have a business to run. An Account costs " + STORAGE_ACCOUNT_COST + " gold.");
		PlayAnim("once", "no");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePlayerused(CBasePlayer@ player = null) { BaseBanker_OnGamePlayerused(player); } // game_playerused
	void OnUsedCheckaccountSuccess() { BaseBanker_OnUsedCheckaccountSuccess(); } // used_checkaccount_success
	void OnUsedCheckaccountFailed() { BaseBanker_OnUsedCheckaccountFailed(); } // used_checkaccount_failed
	void OnSpeechMakeaccount() { BaseBanker_OnSpeechMakeaccount(); } // speech_makeaccount
	void OnGameRecvofferGold() { BaseBanker_OnGameRecvofferGold(); } // game_recvoffer_gold
	void OnOfferCheckacctSuccess() { BaseBanker_OnOfferCheckacctSuccess(); } // offer_checkacct_success
	void OnOfferCheckacctFailed() { BaseBanker_OnOfferCheckacctFailed(); } // offer_checkacct_failed
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseBanker_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnMenuitemCheckacctFailed() { BaseBanker_OnMenuitemCheckacctFailed(); } // menuitem_checkacct_failed
	void OnMenuitemCheckacctSucces() { BaseBanker_OnMenuitemCheckacctSucces(); } // menuitem_checkacct_succes
	void OnBankTrade(CBasePlayer@ player = null) { BaseBanker_OnBankTrade(player); } // bank_trade
	void OnBankOpenaccount(CBasePlayer@ player = null) { BaseBanker_OnBankOpenaccount(player); } // bank_openaccount
	void OnBankOpenaccountFailed() { BaseBanker_OnBankOpenaccountFailed(); } // bank_openaccount_failed

	// This file's events and timers by their .script names
	bool BaseBanker_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bank_openaccount") { OnBankOpenaccount(PlayerParam(params, 0)); return true; }
		if (name == "bank_openaccount_failed") { OnBankOpenaccountFailed(); return true; }
		if (name == "bank_trade") { OnBankTrade(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "menuitem_checkacct_failed") { OnMenuitemCheckacctFailed(); return true; }
		if (name == "menuitem_checkacct_succes") { OnMenuitemCheckacctSucces(); return true; }
		if (name == "offer_checkacct_failed") { OnOfferCheckacctFailed(); return true; }
		if (name == "offer_checkacct_success") { OnOfferCheckacctSuccess(); return true; }
		if (name == "speech_makeaccount") { OnSpeechMakeaccount(); return true; }
		if (name == "used_checkaccount_failed") { OnUsedCheckaccountFailed(); return true; }
		if (name == "used_checkaccount_success") { OnUsedCheckaccountSuccess(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/base_banker"]
shared class BaseBankerScript : ScriptEntity, BaseBanker
{
	// Variables every script that includes this file declares
	bool NO_CHAT = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseBanker_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseBanker_DispatchEvent(name, params);
	}
}
