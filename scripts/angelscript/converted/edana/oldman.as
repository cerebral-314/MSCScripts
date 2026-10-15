#pragma context server

// Converted from edana/oldman.script by msc_transpiler.
// Old man

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "edana/oldman"]
class Oldman : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	string SOUND_IDLE1 = "voices/human/male_oldidle.wav";
	string SOUND_IDLE2 = "voices/human/male_oldidle2.wav";
	string SOUND_IDLE3 = "voices/human/male_oldidle3.wav";
	string SOUND_POTION = "voices/human/male_oldpotion.wav";
	bool NO_RUMOR = true;
	string STORE_NAME = "edana_merchant_2";
	bool VENDOR_NOT_ON_USE = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	int CANCHAT = 0;
	string STORENAME = "STORENAME";
	bool letter = false;
	int QUEST_BOAR = 0;
	bool CAN_ASKPOTION = false;

	// unnamed block (first think)
	void Oldman_FirstThink()
	{
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	}

	// unnamed block (timer)
	// Idling
	void Oldman_Timer()
	{
		CallEventDelayed(RandomInt(30, 45), "Oldman_Timer");

		if (!CAN_ASKPOTION)
			return;
		PlayRandomSound(Int(Eval("game.sound.voice")), 6, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
		Say("[.3]", "[.3]", "[.3]", "[.3]");
	}

	// unnamed block (timer)
	void Oldman_Timer2()
	{
		CallEventDelayed(RandomInt(60, 120), "Oldman_Timer2");

		if (!CAN_ASKPOTION)
			return;

		int potionChat = RandomInt(1, 3);
		if (potionChat == 1)
		{
			SayText("How about a [potion]?");
			PlaySound(Int(Eval("game.sound.voice")), 6, SOUND_POTION);
		}
		else if (potionChat == 2)
			SayText("Did you need some [potions], lad?.");
		else if (potionChat == 3)
			SayText("I've got something that'll heal you up.");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;

		if (!letter && Truthy(ItemExists(player, "item_ikeletter")))
		{
			menuItem.title = "Give Letter";
			menuItem.type = "payment";
			menuItem.data = "item_ikeletter";
			menuItem.callback = "quest_letter_done";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "skin_boar_heavy")))
		{
			menuItem.title = "Give Pelt";
			menuItem.type = "callback";
			menuItem.callback = "quest_heavypelt_done";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetGold(25);
		SetName("Old man"); // A name doesn't get set until Ike mentions it
		SetUniqueName("abulurd");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);

		CANCHAT = 1;
		STORENAME = "edanaoldmans_shop";
		letter = false;
		QUEST_BOAR = 0;
		CAN_ASKPOTION = true;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("npc_say_store", "buy", "store", "heal", "potion", "buy", "trade");
		CatchSpeech("say_ledger", "ledger");
		CatchSpeech("say_job", "boar", "garden", "kill");
		CatchSpeech("say_shutup", "shut up", "quiet", "stop");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlayAnim("once", "talkleft");
		SayText("New folk around here, eh? And the adventerous kind, I see.");
		Say("[.3]", "[.1]", "[.2]", "[.3]", "[.4]", "[.2]", "[.2]", "[.3]", "[.1]");
		CallEventDelayed(3.0f, "say_hi2");
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText("Well, then, you are free to use my garden for practicing your skills.");
		Say("[.2]", "[.2]", "[.3]", "[.1]", "[.2]", "[.2]", "[.2]", "[.3]", "[.1]", "[.3]", "[.1]", "[.4]");
		CallEventDelayed(3.0f, "say_hi3");
	}

	// say_hi3
	void OnSayHi3()
	{
		SayText("If you're lucky, the real big one'll be there. Real tough one, aye...");
		Say("[.10]", "[.10]", "[.10]", "[.20]", "[.7]", "[.7]", "[.10]", "[.20]", "[.1]", "[.1]", "[.1]", "[.3]");
	}

	// vendor_addstoreitems
	// /////////////////////////////////////////////////////////
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|              |Quantity|  |cost%|
		AddStoreItem(STORE_NAME, "health_mpotion", 4, 80);
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// reset
	void OnReset()
	{
		letter = false;
	}

	// game_recvoffer_item
	void OnGameRecvofferItem(string itemScript = "")
	{
		if (itemScript != "item_ikeletter")
			return;
		if ((letter ? 1 : 0) != 0)
			return;
		ReceiveOffer("accept");
		OnQuestLetterDone(ToPlayer(EntityOf(ENT_LASTGAVE)));
	}

	// global_quest_letter
	void OnGlobalQuestLetter()
	{
		// Player doen't know the old man's name until Ike mentions it
		SetName("Abulurd");
	}

	// quest_letter_done
	void OnQuestLetterDone(CBasePlayer@ target = null)
	{
		PlayAnim("once", "pondering3");
		SayText("So Ike's looking for some good firewood eh? My son does some good work, give him this sample.");
		letter = true;
		SetVar("quest.letter.target", @target);
		CallEventDelayed(300.0f, "reset");
		CallEventDelayed(3.0f, "quest_letter_done_2");
	}

	// quest_letter_done_2
	void OnQuestLetterDone2()
	{
		Offer("quest.letter.target", "item_ikelog");
	}

	// global_quest_ledger
	void OnGlobalQuestLedger()
	{
		SetVar("quest.ledger", 1);
	}

	// say_ledger
	void OnSayLedger()
	{
		// (never true here, the rest is skipped) if quest.ledger == 1
	}

	// quest_ledger_done
	void OnQuestLedgerDone(CBasePlayer@ winner = null)
	{
		PlayAnim("critical", "pull_needle");
		SayText("Ah! Here it is! Now hurry and take it to Ike.");
		CallEventDelayed(2.0f, "quest_ledger_done_2");
	}

	// quest_ledger_done_2
	void OnQuestLedgerDone2()
	{
		Offer("quest.ledger.target", "item_ledger");
	}

	// trig_boarsdead
	// ------- boars
	void OnTrigBoarsdead()
	{
		QUEST_BOAR = 2;
	}

	// global_quest_boars_done
	void OnGlobalQuestBoarsDone()
	{
		QUEST_BOAR = 3;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (QUEST_BOAR == 0)
		{
			QUEST_BOAR = 1;

			SayText("They're trapped in the backyard!");
			PlayAnim("once", "converse2");
			Say("[.30]", "[.30]", "[.30]", "[.40]", "[.20]");
			CallEventDelayed(2.3f, "say_boar2");
		}
		else if (QUEST_BOAR == 1)
		{
			SayText("Head out back and train up. I don' mind.");
			// playanim once yes
			Say("[.20]", "[.10]", "[.10]", "[.10]", "[.10]", "[.10]", "[.15]", "[.10]");
		}
		else if (QUEST_BOAR == 2)
		{
			SayText("Did'ya get all the little rascals? A fine job lad.");
			PlayAnim("once", "yes");
			Say("[.20]", "[.10]", "[.10]", "[.30]", "[.10]", "[.10]", "[.15]", "[.10]");
			CallEventDelayed(3.0f, "say_boar_done2");
		}
	}

	// say_boar2
	void OnSayBoar2()
	{
		SayText("I just send people there so they can train their skills.");
		Say("[.30]", "[.20]", "[.30]", "[.40]", "[.20]", "[.20]", "[.30]", "[.10]");
		CallEventDelayed(4.0f, "say_boar3");
	}

	// say_boar3
	void OnSayBoar3()
	{
		SayText("Nobody can afford a mentor these days...");
		Say("[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.20]", "[.20]");

		CallEventDelayed(3.0f, "say_boar4");
	}

	// say_boar4
	void OnSayBoar4()
	{
		SayText("Oh, and Ike the Armourer might have a job for ye when you're done.");
		Say("[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.20]", "[.20]", "[.10]", "[.10]", "[.10]", "[.10]", "[.10]");
		CallEventDelayed(5.0f, "say_boar5");
	}

	// say_boar5
	void OnSayBoar5()
	{
		SayText("...Care for a [potion], by the way?");
		Say("[.10]", "[.10]", "[.10]", "[.10]", "[.10]");
	}

	// say_boar_done2
	void OnSayBoarDone2()
	{
		SayText("Head to town and Ike can use the skins");
		Say("[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.10]", "[.10]", "[.10]", "[.10]");
	}

	// say_shutup
	void OnSayShutup()
	{
		if (!CAN_ASKPOTION)
			return;
		CAN_ASKPOTION = false;

		SayText("I'm sorry, was I bothering you?");
		PlayAnim("once", "panic");
		Say("[.3]", "[.1]", "[.4]", "[.1]", "[.1]", "[.7]", "[.7]", "[.7]", "[.4]");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$rand(30,45)")), "Oldman_Timer");
		CallEventDelayed(Float(Eval("$rand(60,120)")), "Oldman_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Oldman_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_item") { OnGameRecvofferItem(Param(params, 0)); return true; }
		if (name == "global_quest_boars_done") { OnGlobalQuestBoarsDone(); return true; }
		if (name == "global_quest_ledger") { OnGlobalQuestLedger(); return true; }
		if (name == "global_quest_letter") { OnGlobalQuestLetter(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "quest_ledger_done") { OnQuestLedgerDone(PlayerParam(params, 0)); return true; }
		if (name == "quest_ledger_done_2") { OnQuestLedgerDone2(); return true; }
		if (name == "quest_letter_done") { OnQuestLetterDone(PlayerParam(params, 0)); return true; }
		if (name == "quest_letter_done_2") { OnQuestLetterDone2(); return true; }
		if (name == "reset") { OnReset(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_boar2") { OnSayBoar2(); return true; }
		if (name == "say_boar3") { OnSayBoar3(); return true; }
		if (name == "say_boar4") { OnSayBoar4(); return true; }
		if (name == "say_boar5") { OnSayBoar5(); return true; }
		if (name == "say_boar_done2") { OnSayBoarDone2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_ledger") { OnSayLedger(); return true; }
		if (name == "say_shutup") { OnSayShutup(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "trig_boarsdead") { OnTrigBoarsdead(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Oldman_Timer") { Oldman_Timer(); return true; }
		if (name == "Oldman_Timer2") { Oldman_Timer2(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
