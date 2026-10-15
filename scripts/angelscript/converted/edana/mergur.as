#pragma context server

// Converted from edana/mergur.script by msc_transpiler.
// Please note that this is a very old script, so some of the conventions are a bit off

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/help/first_marketsquare.as"
#include "converted/monsters/base_react.as"

[script "edana/mergur"]
class Mergur : BaseChatScript, FirstMarketsquare, BaseReact
{
	// Constants
	int NPC_REACT_SEETARGET_RANGE = 128;

	// Variables (an unset .script variable reads as its own name)
	int ENTRY_GOLD = 0;
	bool CHAT_GREET = false;
	int STORE_CLOSED = 0;

	// game_spawn
	void Mergur_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(20);
		SetGold(26);
		SetName("Merchant Square Keeper");
		// ov	60
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 1);
		ENTRY_GOLD = RandomInt(2, 4);
		SetMenuAutoOpen(true);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumor", "rumour", "news", "happening");

		OnOpenStore();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		Mergur_OnGameSpawn(playerRace, playerGender);
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (STORE_CLOSED == 0)
		{
			menuItem.id = "payment";
			menuItem.title = "Pay " + ENTRY_GOLD + " gold";
			menuItem.type = "payment";
			menuItem.data = "gold:" + ENTRY_GOLD;
			menuItem.callback = "menu_recv_payment";
			menuItem.cb_failed = "menu_recv_payment_failed";

			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Merc. Square Closed";
			menuItem.type = "disabled";

			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		PlayAnim("once", "pondering");
		SayText("Tristan is after the mayor, but he can't leave his post. He's at the backalley of the merchant square.");
	}

	// npcreact_targetsighted
	void OnNpcreactTargetsighted(CBaseEntity@ player = null)
	{
		if (!CHAT_GREET)
			return;
		if (STORE_CLOSED != 0)
			return;

		OnSayHi();
	}

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		OnSayHi();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!CHAT_GREET)
			return;
		if (STORE_CLOSED == 0)
		{
			PlayAnim("once", "studycart");
			SayText("Greetings and welcome to the merchant square!");
			Say("[.5]", "[.1]", "[.1]", "[.05]", "[.05]", "[.1]", "[.3]");
			CallEventDelayed(2.0f, "say_hi_2");
		}
		else
		{
			SayText("Sorry, the square is closed from midnight 'til nine");
			Say("[.3]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]", "[.05]", "[.05]", "[.04]", "[.5]");
		}

		CHAT_GREET = false;
		CallEventDelayed(6.0f, "reset_greet");
	}

	// say_hi_2
	void OnSayHi22()
	{
		SayText("The entry fee is " + ENTRY_GOLD + " gold, you can stay as long as you want.");
	}

	// reset_greet
	void OnResetGreet()
	{
		CHAT_GREET = true;
	}

	// game_recvoffer_gold
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	void OnGameRecvofferGold()
	{
		if (STORE_CLOSED == 0)
		{
			if (Float(Eval("game.offer.gold")) >= ENTRY_GOLD)
			{
				if (Float(Eval("game.offer.gold")) > ENTRY_GOLD)
					SayText("More then I needed!");
				else
					SayText("Thank you very much!");
				Say("[.05]", "[.05]", "[.05]", "[.03]", "[.1]", "[.05]", "[.2]");
				ReceiveOffer("accept");
				PlayAnim("once", "yes");
				OnRecvPayment();
			}
			else
			{
				ReceiveOffer("reject");
				OnRecvPaymentFailed();
			}
		}
		else
		{
			SayText("Sorry, the square is closed from midnight 'til nine");
			Say("[.05]", "[.05]", "[.05]", "[.01]", "[.1]", "[.05]", "[.2]", "[.1]", "[.1]");
			ReceiveOffer("reject");
			PlayAnim("once", "no");
		}
	}

	// menu_recv_payment
	void OnMenuRecvPayment(CBasePlayer@ player = null)
	{
		SayText("Thank you very much!");
		Say("[.05]", "[.05]", "[.05]", "[.03]", "[.1]", "[.05]", "[.2]");
		ReceiveOffer("accept");
		PlayAnim("once", "yes");

		OnRecvPayment();
	}

	// menu_recv_payment_failed
	void OnMenuRecvPaymentFailed(CBasePlayer@ player = null)
	{
		SayText("Thank you very much!");
		Say("[.05]", "[.05]", "[.05]", "[.03]", "[.1]", "[.05]", "[.2]");
		ReceiveOffer("accept");
		PlayAnim("once", "yes");

		OnRecvPayment();
	}

	// recv_payment
	void OnRecvPayment()
	{
		UseTrigger("door1");
	}

	// recv_payment_failed
	void OnRecvPaymentFailed()
	{
		SayText("I'm sorry, but since we just got this merchant square set up,");
		Say("[.05]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]", "[.08]", "[.08]", "[.05]", "[.1]", "[.1]", "[.2]");
		CallEventDelayed(1.0f, "speech_materials");
		PlayAnim("once", "no");
	}

	// speech_materials
	void OnSpeechMaterials()
	{
		SayText("we have to charge a little extra to pay for materials. I'm sure you understand...");
	}

	// say_job
	// /////////////////////////////////////////////////////////////////////////////////7
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Well, I just recently hired a new guard so I'm afraid we're fully staffed now.");
		Say("[.4]", "[.2]", "[.2]", "[.1]", "[.1]", "[.1]", "[.2]", "[.05]", "[.05]", "[.2]", "[.1]", "[.3]", "[.2]", "[.3]", "[.1]");
	}

	// open_store
	void OnOpenStore()
	{
		CHAT_GREET = true;
		STORE_CLOSED = 0;
	}

	// close_store
	void OnCloseStore()
	{
		CHAT_GREET = false;
		STORE_CLOSED = 1;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(1.0f, "BaseReact_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		BaseReact_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "close_store") { OnCloseStore(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "menu_recv_payment") { OnMenuRecvPayment(PlayerParam(params, 0)); return true; }
		if (name == "menu_recv_payment_failed") { OnMenuRecvPaymentFailed(PlayerParam(params, 0)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "open_store") { OnOpenStore(); return true; }
		if (name == "recv_payment") { OnRecvPayment(); return true; }
		if (name == "recv_payment_failed") { OnRecvPaymentFailed(); return true; }
		if (name == "reset_greet") { OnResetGreet(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi_2") { OnSayHi22(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "speech_materials") { OnSpeechMaterials(); return true; }
		return FirstMarketsquare_DispatchEvent(name, params)
			|| BaseReact_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
