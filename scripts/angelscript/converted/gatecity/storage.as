#pragma context server

// Converted from gatecity/storage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/NPCs/base_storage.as"

[script "gatecity/storage"]
class GatecityStorage : BaseNpcScript, BaseStorage
{
	// Constants
	Vector3 GALA_CHEST_POS = Vector3();
	string ANIM_CHAT = "nod";
	string ANIM_NO = "attack";
	string ANIM_STORE = "nod";
	string SAYTEXT_REFUND = "No pressure! Here's yer fee back. Come back anytime.";
	string SAYTEXT_SELECT_ITEM = "Pick what yer gonna store.";
	string SAYTEXT_NOITEM = "Er, sorry, I didn't get the thing.";
	string SAYTEXT_NOTICKET = "Sorry, I didn't get yer ticket.";
	string SAYTEXT_NOSTORABLES = "Sorry, ya've got nuttin I can store for you.";
	string SAYTEXT_GIVETICKET = "Here's yer ticket! Remember, ya can redeem that at any Galat outlet.";
	string SAYTEXT_SELECT_TICKET = "What ticket would ya like to redeem?";
	string SAYTEXT_HAND_WARN = "Put yer tickets in your hands where I can see them please.";
	string SAYTEXT_REDEEMTICKET = "There ya go! Thank you for using Galat Storage, please come again!";
	string SAYTEXT_ITEMS_HANDS = "Gotta put yer stuff in yer hands before I can store it.";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	bool DID_HELLO = false;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";

	// unnamed block (first think)
	void GatecityStorage_FirstThink()
	{
		ANIM_IDLE = "idle";
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseStorage_OnGameMenuGetoptions(player); // NPCs/base_storage
		MenuItem menuItem;

		if (!DID_HELLO)
		{
			DID_HELLO = true;
			SayText("Welcome to Galat's Weapon and Armor Storage!");
		}

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "heard_hi";
		RegisterMenuItem(menuItem);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Vogdor of Galat's Storage");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetWidth(28);
		SetHeight(96);
		SetModel("dwarf/male1.mdl");
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		SetRoam(false);
		PlayAnim("once", "idle");
		SetModelBody(0, 1); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 3); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword

		SetModelBody(1, 0);
		SetModelBody(2, 0);

		// dbg temp Gatecity Teller Spawned
		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("heard_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");
	}

	// heard_hi
	void OnHeardHi()
	{
		DID_HELLO = true;
		PlayAnim("critical", ANIM_CHAT);
		PlaySound(0, 10, "npc/dwarfatservice.wav");
		SayText("'ello thar, welcome to Galat's Weapon and Armor Storage...");
		CallEventDelayed(5.0f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		SayText("For a nominal fee, we can store yer things here for ya's.");
		CallEventDelayed(5.0f, "heard_hi3");
	}

	// heard_hi3
	void OnHeardHi3()
	{
		SayText("We'll gives you a ticket for anything we can store.");
		CallEventDelayed(5.0f, "heard_hi4");
	}

	// heard_hi4
	void OnHeardHi4()
	{
		SayText("Thanks to our contacts with the Felewyn wizards, ya can redeem this ticket at any Galat outlet!");
		CallEventDelayed(5.0f, "heard_hi5");
	}

	// heard_hi5
	void OnHeardHi5()
	{
		SayText("Galat has outlets all over - even in the forsaken town of Helena!");
	}

	// heard_rumor
	void OnHeardRumor()
	{
		SayText("Hmm... Not much goin on here to be honest. We dwarves don't like change.");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// say_storage_chest
	void OnSayStorageChest()
	{
		OnConvoAnim();
		CHAT_STEPS = 6;
		CHAT_STEP1 = "Ah, that bleedin thing be the new fangled Wondrous Chest of Storage.";
		CHAT_STEP2 = "This bugger here can store items for you, no need for tickets. Makes me wonder what I'm doin' here.";
		CHAT_STEP3 = "Just thrust your fists at it, whiling holdin' whatever it be you wantin' to get off yer hands.";
		CHAT_STEP4 = "Then, when ye want yer stuff back, just open her up - or anyone like her, anywhere.";
		CHAT_STEP5 = "The chest has some magic thingie on it that makes sure you, and only you, gets yer stuff.";
		CHAT_STEP6 = "It's free to use. Seems the lads at Galat HQ are in a giving mood this turn. *cough*";
		OnChatLoop();
	}

	// say_wondrous
	void OnSayWondrous()
	{
		OnConvoAnim();
		CHAT_STEPS = 4;
		CHAT_STEP1 = "Ah, here be the interestin' part of the whole deal. With one of these, you can summon that there chest in front of me.";
		CHAT_STEP2 = "Meaning you, and yer friends, can have access to the Galat Wondrous Chest of Storage, wherever ye may happen to be.";
		CHAT_STEP3 = "Only works once though - and ye need a fair bit of room to place the chest, so be careful.";
		CHAT_STEP4 = "So, this where where they get ya. After suckering in with free use of the chest here, they charge you ";
		CHAT_STEP4 += Text(GALA_SCROLL_PRICE) + " gold a piece the scrolls!";
		OnChatLoop();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseStorage_OnGameSpawn(playerRace, playerGender); // NPCs/base_storage
	}

	void OnChatLoop() {} // chat_loop

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GatecityStorage_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseStorage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_hi2") { OnHeardHi2(); return true; }
		if (name == "heard_hi3") { OnHeardHi3(); return true; }
		if (name == "heard_hi4") { OnHeardHi4(); return true; }
		if (name == "heard_hi5") { OnHeardHi5(); return true; }
		if (name == "heard_rumor") { OnHeardRumor(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_storage_chest") { OnSayStorageChest(); return true; }
		if (name == "say_wondrous") { OnSayWondrous(); return true; }
		return BaseStorage_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
