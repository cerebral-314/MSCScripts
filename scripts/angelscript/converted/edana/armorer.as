#pragma context server

// Converted from edana/armorer.script by msc_transpiler.
// Armourer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "edana/armorer"]
class EdanaArmorer : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string STORE_NAME = "gatecity_armory";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	string OVER_CHARGE = "150%";
	bool NO_RUMOR = true;
	bool VEND_ARMORER = true;
	bool VEND_CONTAINERS = true;
	bool VEND_WEAPONS = true;
	bool VEND_SPEC_SHEATHS = true;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	int JOB = 0;
	int CANCHAT = 0;
	CBasePlayer@ ORE_TARGET = null;
	bool OFFER_SET = false;
	CBasePlayer@ GOLD_TARGET = null;
	bool GAVE_AXE2 = false;

	// unnamed block (first think)
	void EdanaArmorer_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;
		SELL_WEAPON_LEVEL = "3,6,9,12";
		VEND_NEWBIE = "1";
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;

		if (OFFER_SET && Truthy(ItemExists(player, "item_gaxe_handle")))
		{
			menuItem.title = "Pay 10,000 Gold";
			menuItem.type = "payment";
			menuItem.data = "gold:10000;item_gaxe_handle;item_ore_lorel";
			menuItem.callback = "say_gotgold";
			menuItem.cb_failed = "say_failed_pay";
			RegisterMenuItem(menuItem);
		}

		if (OFFER_SET)
			return;
		if (Truthy(ItemExists(player, "item_gaxe_handle")))
		{
			menuItem.title = "Ask about broken axe";
			menuItem.type = "callback";
			menuItem.callback = "say_axe";
			RegisterMenuItem(menuItem);

			if (Truthy(ItemExists(player, "item_ore_lorel")))
			{
				menuItem.title = "Show Loreldian Ore";
				menuItem.type = "callback";
				menuItem.callback = "say_ore";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("I hear the mayor is looking for some help.");
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetUniqueName("Roland");
		SetHealth(25);
		SetGold(25);
		SetName("Roland the Blacksmith");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 0); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 2); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetInvincible(true);

		JOB = 0;
		CANCHAT = 1;
		STORE_CLOSED = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
		CatchSpeech("say_axe", "axe", "golden", "broken", "mayor");
		CatchSpeech("say_failed_pay", "no", "give", "back");

		OnCreatemystore();
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "npc/goods.wav");
		Say("[.34]", "[.24]", "[.35]", "[.40]");
		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// npcreact_targetsighted
	// /////////////////////////////////////////////////////////
	// Greeting players
	// Respond to seeing player
	void OnNpcreactTargetsighted(CBaseEntity@ player = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(player) <= 90.0f)
			SayText("Would you like to [purchase] one of my fine weapons?");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(ENT_LASTSPOKE) <= 90.0f)
			SayText("Would you like [buy] some fine armor or weapons?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Sorry, but with the Undermountains closed, I have no work to be done.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "armor_leather_torn", RandomInt(1, 3), 125, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather", RandomInt(1, 3), 125, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_studded", RandomInt(1, 3), 125, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_plate", RandomInt(1, 2), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_plate", RandomInt(1, 2), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_bronze", RandomInt(1, 2), 90, SELL_RATIO);

		OnMongolGear();
		OnKnightGear();

		AddStoreItem(STORE_NAME, "armor_golden", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_golden", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_dark", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_dark", 0, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "sheath_belt_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_dagger_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_axe_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_blunt_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_holster_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_holster", 5, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "shields_buckler", RandomInt(1, 2), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "shields_ironshield", RandomInt(1, 2), 100, 0.25f);
		AddStoreItem(STORE_NAME, "shields_lironshield", RandomInt(1, 2), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "swords_rsword", RandomInt(1, 5), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_shortsword", RandomInt(1, 5), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_nkatana", RandomInt(1, 5), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_longsword", RandomInt(1, 5), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_doubleaxe", RandomInt(1, 5), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_gauntlets_leather", RandomInt(1, 2), 90, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_belt_holster", 1, "OVERCHARGE", SELL_RATIO);

		AddStoreItem(STORE_NAME, "smallarms_knife", 4, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dagger", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_rknife", 0, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "swords_rsword", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_shortsword", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_scimitar", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_longsword", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_bastardsword", 2, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "axes_rsmallaxe", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_smallaxe", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_axe", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_2haxe", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_battleaxe", 2, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "blunt_club", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer1", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer2", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_mace", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_warhammer", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer3", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_maul", 2, 100, SELL_RATIO);
	}

	// mongol_gear
	void OnMongolGear()
	{
		if (RandomInt(1, 10) == 1)
		{
			AddStoreItem(STORE_NAME, "armor_mongol", 1, 100, SELL_RATIO);
			AddStoreItem(STORE_NAME, "armor_helm_mongol", 1, 100, SELL_RATIO);
		}
	}

	// knight_gear
	void OnKnightGear()
	{
		if (RandomInt(1, 25) == 1)
		{
			AddStoreItem(STORE_NAME, "armor_knight", 1, 100, SELL_RATIO);
			AddStoreItem(STORE_NAME, "armor_helm_knight", 1, 100, SELL_RATIO);
		}
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// vendor_say_closed
	void OnVendorSayClosed()
	{
		SayText("Sorry, I'm closed. I will reopen at seven in the morning.");
	}

	// say_axe
	void OnSayAxe(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;

		if (speaker is null)
		{
			// callled from chat, not from menu, make sure he has axe
			CBaseEntity@ speakerId = EntityOf(ENT_LASTSPOKE);
			if (!Truthy(ItemExists(speakerId, "item_gaxe_handle")))
				exitSub = true;
		}
		if (exitSub)
			return;

		SayText("Wow, this here was a real piece of work, before it broke.");
		CallEventDelayed(4.0f, "say_axe2");
	}

	// say_axe2
	void OnSayAxe2()
	{
		SayText("Don't make them like this anymore, that's fer sure.");
		CallEventDelayed(4.0f, "say_axe3");
	}

	// say_axe3
	void OnSayAxe3()
	{
		SayText("I can still see the bits of the blade end, I can tell it was made of Loreldian ore.");
		CallEventDelayed(4.0f, "say_axe4");
	}

	// say_axe4
	void OnSayAxe4()
	{
		SayText("That's where the thing gets its magic, and why it only harms the unholy.");
		CallEventDelayed(4.0f, "say_axe5");
	}

	// say_axe5
	void OnSayAxe5()
	{
		SayText("Most such cursed things are imbued with the power of The Fallen, either directly, or indirectly.");
		CallEventDelayed(4.0f, "say_axe6");
	}

	// say_axe6
	void OnSayAxe6()
	{
		SayText("This stuff don't grow on trees, ya know. Even if it did, it's very difficult to work with.");
		CallEventDelayed(4.0f, "say_axe7");
	}

	// say_axe7
	void OnSayAxe7()
	{
		SayText("But if ya find some, bring it back to me, together with this handle, and maybe I can fix ya up.");
	}

	// say_ore
	void OnSayOre(CBasePlayer@ target = null)
	{
		@ORE_TARGET = target;
		SayText("Wow, you actually found some of the stuff! Hmm... Let's see here...");
		CallEventDelayed(4.0f, "say_ore2");
	}

	// say_ore2
	void OnSayOre2()
	{
		SayText("Okay, I think I can do this, but it'll cost ya.");
		CallEventDelayed(4.0f, "say_ore3");
	}

	// say_ore3
	void OnSayOre3()
	{
		SayText("I'll need 10,000 gold. Plus the hilt, of course.");
		CallEventDelayed(2.0f, "say_ore4");
		OFFER_SET = true;
	}

	// say_ore4
	void OnSayOre4()
	{
		SayText("Just tell me no, if yer not interested.");
	}

	// say_gotgold
	void OnSayGotgold(CBasePlayer@ target = null)
	{
		@GOLD_TARGET = target;
		SayText("Alright, just give me a few moments here.");
		PlayAnim("critical", "attack");
		CallEventDelayed(1.0f, "smith_sound");
		CallEventDelayed(2.0f, "say_gotgold2");
	}

	// say_gotgold2
	void OnSayGotgold2()
	{
		PlayAnim("critical", "attack");
		CallEventDelayed(1.0f, "smith_sound");
		CallEventDelayed(2.0f, "say_gotgold3");
	}

	// say_gotgold3
	void OnSayGotgold3()
	{
		PlayAnim("critical", "attack2");
		CallEventDelayed(1.0f, "smith_sound2");
		CallEventDelayed(1.0f, "say_gotgold4");
	}

	// say_gotgold4
	void OnSayGotgold4()
	{
		SayText("There ya go! Good as new... Sorta...");
		Offer(GOLD_TARGET, "axes_golden");
		GAVE_AXE2 = true;
		CallEventDelayed(3.0f, "say_gotgold5");
	}

	// say_gotgold5
	void OnSayGotgold5()
	{
		SayText("Now, if you want to make sure it won't break AGAIN, well...");
		CallEventDelayed(4.0f, "say_gotgold6");
	}

	// say_gotgold6
	void OnSayGotgold6()
	{
		SayText("To be honest, you'd need a better smith than I. But I happen to know one- Thordac!");
		CallEventDelayed(4.0f, "say_gotgold7");
	}

	// say_gotgold7
	void OnSayGotgold7()
	{
		SayText("Go over to Deralia, give him yer axe and my instructions here, telling him what ya need.");
		Offer(GOLD_TARGET, "item_roland_letter");
		CallEventDelayed(4.0f, "say_gotgold8");
	}

	// say_gotgold8
	void OnSayGotgold8()
	{
		SayText("I warn ye though, he'll charge you up the nose for what you'll need done!");
	}

	// say_failed_pay
	void OnSayFailedPay()
	{
		if (!OFFER_SET)
			return;
		if (GAVE_AXE2)
			return;
		OFFER_SET = false;
		SayText("Well, if ya ain't got the money now, I can wait.");
	}

	// smith_sound
	void OnSmithSound()
	{
		PlayRandomSound(0, 10, "debris/metal3.wav", "debris/metal2.wav", "debris/metal1.wav");
	}

	// smith_sound2
	void OnSmithSound2()
	{
		PlaySound(0, 10, "debris/bustmetal2.wav");
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
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	void OnCreatemystore() {} // createmystore

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanaArmorer_FirstThink();
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
		if (name == "knight_gear") { OnKnightGear(); return true; }
		if (name == "mongol_gear") { OnMongolGear(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_axe") { OnSayAxe(PlayerParam(params, 0)); return true; }
		if (name == "say_axe2") { OnSayAxe2(); return true; }
		if (name == "say_axe3") { OnSayAxe3(); return true; }
		if (name == "say_axe4") { OnSayAxe4(); return true; }
		if (name == "say_axe5") { OnSayAxe5(); return true; }
		if (name == "say_axe6") { OnSayAxe6(); return true; }
		if (name == "say_axe7") { OnSayAxe7(); return true; }
		if (name == "say_failed_pay") { OnSayFailedPay(); return true; }
		if (name == "say_gotgold") { OnSayGotgold(PlayerParam(params, 0)); return true; }
		if (name == "say_gotgold2") { OnSayGotgold2(); return true; }
		if (name == "say_gotgold3") { OnSayGotgold3(); return true; }
		if (name == "say_gotgold4") { OnSayGotgold4(); return true; }
		if (name == "say_gotgold5") { OnSayGotgold5(); return true; }
		if (name == "say_gotgold6") { OnSayGotgold6(); return true; }
		if (name == "say_gotgold7") { OnSayGotgold7(); return true; }
		if (name == "say_gotgold8") { OnSayGotgold8(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_ore") { OnSayOre(PlayerParam(params, 0)); return true; }
		if (name == "say_ore2") { OnSayOre2(); return true; }
		if (name == "say_ore3") { OnSayOre3(); return true; }
		if (name == "say_ore4") { OnSayOre4(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "smith_sound") { OnSmithSound(); return true; }
		if (name == "smith_sound2") { OnSmithSound2(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_say_closed") { OnVendorSayClosed(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
