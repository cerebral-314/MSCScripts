#pragma context server

// Converted from edana/edanateller.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/NPCs/base_storage.as"

[script "edana/edanateller"]
class EdanaEdanateller : BaseNpcScript, BaseChat, BaseStorage
{
	// Constants
	bool PLACEHOLDER = false;
	Vector3 GALA_CHEST_POS = Vector3();

	// Variables (an unset .script variable reads as its own name)
	bool NO_HAIL = false;
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool DID_HELLO = false;
	int CHAT_STEPS = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";

	// unnamed block (first think)
	void EdanaEdanateller_FirstThink()
	{
		NO_HAIL = true;
		NO_JOB = true;
		NO_RUMOR = true;
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
		SetName("Edric of Galat's Storage");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetWidth(16);
		SetHeight(72);
		SetModel("npc/balancepriest1.mdl");
		SetModelBody(1, 1);
		SetRoam(false);

		// dbg temp Edana Teller Spawned
		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("heard_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");
	}

	// heard_hi
	void OnHeardHi()
	{
		DID_HELLO = true;
		PlayAnim("critical", "talkright");
		SayText("Greetings, welcome to Galat's Weapon and Armor Storage...");
		CallEventDelayed(5.0f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		SayText("For a nominal fee, we can store your items here for you.");
		CallEventDelayed(5.0f, "heard_hi3");
	}

	// heard_hi3
	void OnHeardHi3()
	{
		SayText("We'll gives ya a ticket in exchange for any item we can store.");
		CallEventDelayed(5.0f, "heard_hi4");
	}

	// heard_hi4
	void OnHeardHi4()
	{
		SayText("Thanks to our contacts with the Felewyn wizards, you can redeem this ticket at any Galat outlet.");
		CallEventDelayed(5.0f, "heard_hi5");
	}

	// heard_hi5
	void OnHeardHi5()
	{
		SayText("Galat has outlets in Deralia, Gatecity, Kray Eldorad, and now, even in Helena!");
	}

	// heard_rumor
	void OnHeardRumor()
	{
		SayText("Look, I just work here, I don't live here. You got an item to store, or what?");
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
		CHAT_STEPS = 6;
		CHAT_STEP1 = "Ah yes, our new Galat Chest of Wondrous Storage!";
		CHAT_STEP2 = "This new chest here can store items for you, without the need to redeem tickets.";
		CHAT_STEP3 = "Simply place the items you wish to store in your hands, and use the chest.";
		CHAT_STEP4 = "To withdraw items, use it as you would any chest, simply reach in and take what you need.";
		CHAT_STEP5 = "The chest keeps each customer's inventory in a special dimensional pocket only the customer can access.";
		CHAT_STEP6 = "The chest can hold about a dozen or so items for each user. It's free to use for a limited time!";
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
		CHAT_STEP1 = "With a Wondrous Scroll of Galat's storage you can summon Galat's Chest of Wondrous Storage anywhere you may happen to be!";
		CHAT_STEP2 = "Any Galat customers present can then use the chest to access whatever items they have stored therein.";
		CHAT_STEP3 = "Each scroll is only good for one use. Be sure there's a patch of flat ground in front of you, big enough for the chest to manifest in.";
		CHAT_STEP4 = "Right now you can purchase these scrolls for the reasonable price of ";
		CHAT_STEP4 += Text(GALA_SCROLL_PRICE) + " gold!";
		OnChatLoop();
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
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanaEdanateller_FirstThink();
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
		return BaseChat_DispatchEvent(name, params)
			|| BaseStorage_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
