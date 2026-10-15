#pragma context server

// Converted from deralia/storage.script by msc_transpiler.
// Now refers to the chest as "Galat's Wondrous Chest of Storage" instead of "Galat's Chest of Wondrous Storage"
// No longer refers to Helena's Galat's chest as new.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/NPCs/base_storage.as"
#include "converted/monsters/base_civilian.as"

[script "deralia/storage"]
class DeraliaStorage : BaseNpcScript, BaseChat, BaseStorage, BaseCivilian
{
	// Constants
	Vector3 GALA_CHEST_POS = Vector3();
	string ANIM_CHAT = "pondering3";
	string ANIM_NO = "no";
	string ANIM_STORE = "return_needle";
	string SAYTEXT_REFUND = "Here's your fee back. Such as it is.";
	string SAYTEXT_SELECT_ITEM = "What do you wish to store?";
	string SAYTEXT_NOITEM = "I did not recieve your item.";
	string SAYTEXT_NOTICKET = "I did not recieve your ticket.";
	string SAYTEXT_NOSTORABLES = "Sorry, I'm afraid you have nothing we can store for you.";
	string SAYTEXT_GIVETICKET = "Here is your ticket! You can redeem that at any Galat outlet.";
	string SAYTEXT_SELECT_TICKET = "Which ticket would do you like to redeem?";
	string SAYTEXT_HAND_WARN = "Please place your tickets in your hands.";
	string SAYTEXT_REDEEMTICKET = "Thank you for using Galat Storage.";
	string SAYTEXT_ITEMS_HANDS = "Please hold forth any items you wish to store in your hands.";
	bool NO_HAIL = true;
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	Vector3 MY_HOME = Vector3();
	bool CHATTING = false;
	bool DID_HELLO = false;
	bool IS_FLEEING = false;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";

	// Variables declared by included files, with the value they start with in this script
	DeraliaStorage()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk_scared";
	}

	// unnamed block (first think)
	void DeraliaStorage_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk_scared";
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		SetRoam(true);
		SetMoveAnim(ANIM_RUN);
		SetMoveDest(ENT_LASTSTRUCK, 9999, "flee");
		SetMenuAutoOpen(false);
		if (IS_FLEEING)
			return;
		IS_FLEEING = true;
		CallEventDelayed(20.0f, "stop_fleeing");
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
			PlayAnim("critical", "lean");
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
		SetName("Guilda of Galat's Storage");
		SetHealth(40);
		SetInvincible(false);
		SetGold(10);
		SetRace("human");
		SetWidth(28);
		SetHeight(96);
		SetModel("npc/human2.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim("run");
		SetRoam(false);
		PlayAnim("once", "idle1");
		SetModelBody(0, 0);
		SetModelBody(1, 1);

		// dbg temp Deralia Teller Spawned
		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("heard_rumor", "job", "rumor", "rumour", "quest", "Kayle", "woman", "women", "gal", "girls", "chicks");
		CatchSpeech("heard_store", "shop", "store", "bank");

		CallEventDelayed(1.6f, "post_spawn");
	}

	// post_spawn
	void OnPostSpawn()
	{
		MY_HOME = MyOrigin();
	}

	// heard_hi
	void OnHeardHi()
	{
		if (CHATTING)
			return;
		CHATTING = true;

		DID_HELLO = true;
		PlayAnim("critical", "180_right");
		SayText("Welcome to Galat's Weapon and Armor Storage.");
		CallEventDelayed(5.0f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		SayText("For a nominal fee, we can store your weapons and armor.");
		CallEventDelayed(5.0f, "heard_hi3");
	}

	// heard_hi3
	void OnHeardHi3()
	{
		SayText("We'll give you a ticket for any item that we can store.");
		CallEventDelayed(5.0f, "heard_hi4");
	}

	// heard_hi4
	void OnHeardHi4()
	{
		SayText("Thanks to our contacts with the Felewyn wizards, you may redeem this ticket at any Galat outlet!");
		CallEventDelayed(5.0f, "heard_hi5");
	}

	// heard_hi5
	void OnHeardHi5()
	{
		CHATTING = false;
		PlayAnim("critical", "pondering2");
		SayText("Galat has outlets in Deralia, Gatecity, Kray Eldorad, and surprisingly, Helena."); // Helena's chest is no longer "new" so now just surprising 'cuz the attacks
	}

	// heard_rumor
	void OnHeardRumor()
	{
		PlayAnim("critical", "fear1");
		SayText("By Urdual! You mean there's more than one woman in this town!?");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// stop_fleeing
	void OnStopFleeing()
	{
		SetMoveDest(MY_HOME, 10);
		SetMoveAnim(ANIM_WALK);

		SetMenuAutoOpen(true);
		SetRoam(false);
		IS_FLEEING = false;
	}

	// say_storage_chest
	void OnSayStorageChest()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "say_storage_chest");
		if (BUSY_CHATTING)
			return;
		OnConvoAnim();
		CHAT_STEPS = 6;
		CHAT_STEP1 = "Yes, this before me is the latest in magical banking: Galat's Wondrous Chest of Storage!";
		CHAT_STEP2 = "This new chest here can store items for you, no need for tickets.";
		CHAT_STEP3 = "Simply place the items you wish to store in your hands, and use the chest. It does the rest!";
		CHAT_STEP4 = "To withdraw items, use it as you would any chest, simply reach in and take what you need.";
		CHAT_STEP5 = "The chest keeps each customer's inventory in a special dimensional pocket only the customer can access.";
		CHAT_STEP6 = "The chest can hold about a couple dozen or so items for each user. You can use this one here at any time.";
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
		CHAT_STEP1 = "With a Wondrous Scroll of Galat's storage you can summon Galat's Wondrous Chest of Storage anywhere you may happen to be.";
		CHAT_STEP2 = "Any Galat customers present can then use the chest to access whatever items they have stored therein.";
		CHAT_STEP3 = "Each scroll is good for single summoning. Be sure you have a fair amount of room around yourself for the chest to manifest in.";
		CHAT_STEP4 = "I, and any Galat Banking representative can sell you one of these scrolls for the meager asking price of ";
		CHAT_STEP4 += Text(GALA_SCROLL_PRICE) + " gold.";
		OnChatLoop();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
	}

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
		Precache("npc/human2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaStorage_FirstThink();
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
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_hi2") { OnHeardHi2(); return true; }
		if (name == "heard_hi3") { OnHeardHi3(); return true; }
		if (name == "heard_hi4") { OnHeardHi4(); return true; }
		if (name == "heard_hi5") { OnHeardHi5(); return true; }
		if (name == "heard_rumor") { OnHeardRumor(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "post_spawn") { OnPostSpawn(); return true; }
		if (name == "say_storage_chest") { OnSayStorageChest(); return true; }
		if (name == "say_wondrous") { OnSayWondrous(); return true; }
		if (name == "stop_fleeing") { OnStopFleeing(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseStorage_DispatchEvent(name, params)
			|| BaseCivilian_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
