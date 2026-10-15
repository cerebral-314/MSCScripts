#pragma context server

// Converted from deralia/blacksmith.script by msc_transpiler.
// Blacksmith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "deralia/blacksmith"]
class DeraliaBlacksmith : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "deralia_merchant_2";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	int CANCHAT = 1;
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60";
	string CURRENT_THIEF = "\x81PNULL\x81P";
	string CHECK_PLAYER = "ent_lastspoke";
	bool CHATTING_PLAYER = false;
	bool OFFER_SET = false;
	CBasePlayer@ GAXE_TARGET = null;

	// Variables declared by included files, with the value they start with in this script
	DeraliaBlacksmith()
	{
		ATTACK_RANGE = 90.0f;
	}

	// unnamed block (first think)
	void DeraliaBlacksmith_FirstThink()
	{
		STORE_NAME = "deralia_merchant_2";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
		SELL_WEAPON_LEVEL = "3,6,9,12";

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = true;
	}

	// unnamed block (timer)
	void DeraliaBlacksmith_Timer()
	{
		CallEventDelayed(25.0f, "DeraliaBlacksmith_Timer");

		if (CHATTING_PLAYER)
			return;

		PlayAnim("once", "wave");
		SayText("The finest weapons in all the land!");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;

		DebugPrint("game_menu_getoptions " + NameOf(player) + " ax " + ItemExists(player, "axes_golden") + " let " + ItemExists(player, "item_roland_letter"));

		if (Truthy(ItemExists(player, "axes_golden")) && !OFFER_SET && Truthy(ItemExists(player, "item_roland_letter")))
		{
			menuItem.title = "Show Rolands Letter";
			menuItem.type = "callback";
			menuItem.data = "say_letter";
			menuItem.callback = "say_letter";
			RegisterMenuItem(menuItem);
		}

		if (OFFER_SET && Truthy(ItemExists(player, "axes_golden")))
		{
			menuItem.title = "Pay 100,000 Gold";
			menuItem.type = "payment";
			menuItem.data = "gold:100000;axes_golden;item_roland_letter";
			menuItem.callback = "make_gaxe";
			menuItem.cb_failed = "say_letter6";
			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetGold(50);
		SetName("Thordac the Blacksmith");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/blacksmith.mdl");
		SetInvincible(true);
		CANCHAT = 1;
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60";
		CURRENT_THIEF = "\x81PNULL\x81P"; // A player can't pick this name

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");

		CatchSpeech("say_rumour", "rumour", "rumours", "news", "happenings");

		OnResetchat();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Welcome to Deralia's smithy. I have many items, some that might interest you.");
		CallEventDelayed(0.0f, "3");
	}

	// say_store
	void OnSayStore()
	{
		CHECK_PLAYER = ENT_LASTSPOKE;
		OnOfferNotthief();
		OnOfferIsthief();
	}

	// trade_done
	void OnTradeDone()
	{
		SayText("Please, do come again some time. Might have something more interesting for you then.");
	}

	// vendor_addstoreitems
	// ----------------------
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|              |Quantity|  |cost%|
		AddStoreItem(STORE_NAME, "armor_helm_knight", 3, 110);
		AddStoreItem(STORE_NAME, "armor_knight", 2, 110);

		AddStoreItem(STORE_NAME, "smallarms_rknife", 0, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "smallarms_knife", 3, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "smallarms_dagger", 2, 100, "SELL_RATIO");

		AddStoreItem(STORE_NAME, "swords_rsword", 0, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "swords_shortsword", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "swords_scimitar", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "swords_nkatana", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "swords_longsword", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "swords_bastardsword", 2, 100, "SELL_RATIO");

		AddStoreItem(STORE_NAME, "axes_rsmallaxe", 0, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "axes_smallaxe", 3, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "axes_axe", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "axes_2haxe", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "axes_battleaxe", 2, 100, "SELL_RATIO");

		AddStoreItem(STORE_NAME, "blunt_club", 1, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_hammer2", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_mace", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_warhammer", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_hammer3", 2, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_maul", 2, 100, "SELL_RATIO");

		AddStoreItem(STORE_NAME, "polearms_qs", RandomInt(0, 1), 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "polearms_sp", RandomInt(0, 1), 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "polearms_tri", RandomInt(0, 1), 100, "SELL_RATIO");

		// addstoreitem  STORE_NAME     sheath_belt_snakeskin 1 100 SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_back_snakeskin 1 100 SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_dagger_snakeskin 1 100 SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_axe_snakeskin 1 100 SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_blunt_snakeskin	1 100 SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_holster_snakeskin 1 100 SELL_RATIO
		AddStoreItem(STORE_NAME, "sheath_back_holster", 5, 100, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "blunt_gauntlets_leather", 1, 100, "SELL_RATIO");

		AddStoreItem(STORE_NAME, "smallarms_craftedknife", RandomInt(1, 2), 175);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "blunt_greatmaul", 1, 120);

		// if ( $rand(1,3) == 1 )
		// {
		// addstoreitem  STORE_NAME     axes_battleaxe	 	1   	    120
		// }
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "axes_scythe", 4, 120);

		// if ( $rand(1,3) == 1 )
		// {
		// addstoreitem  STORE_NAME     swords_longsword		1	    120
		// }
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "blunt_granitemace", 1, 500, 0);
		AddStoreItem(STORE_NAME, "crest_deralia", 1, 100, 0);
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering2");
		SayText("Ummm ... someone mentioned seeing the beacon blink. But that could never happen.");
	}

	// say_letter
	void OnSayLetter(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;

		if (speaker is null)
		{
			// callled from chat, not from menu, make sure he has axe
			CBaseEntity@ speakerId = EntityOf(ENT_LASTSPOKE);
			if (!Truthy(ItemExists(speakerId, "item_roland_letter")))
				exitSub = true;
		}
		if (exitSub)
			return;

		CHATTING_PLAYER = true;

		SayText("Hmm... Wow, he wants me to attach a theulian spine to this thing!?");
		SetIdleAnim("keypad");
		PlayAnim("once", "keypad");
		CallEventDelayed(4.0f, "say_letter2");
	}

	// say_letter2
	void OnSayLetter2()
	{
		SayText("Hmmm... I have one, but these things are so damned rare. It'll cost you about...");
		SetIdleAnim("pondering");
		PlayAnim("once", "pondering");
		CallEventDelayed(4.0f, "say_letter3");
	}

	// say_letter3
	void OnSayLetter3()
	{
		SayText("100,000 gold.");
		OFFER_SET = true;
		CallEventDelayed(4.0f, "say_letter4");
	}

	// say_letter4
	void OnSayLetter4()
	{
		SetIdleAnim("pondering");
		PlayAnim("once", "pondering");
		SayText("He sent you to me, because he knows I'm the only one around who makes these...");
		CallEventDelayed(4.0f, "say_letter5");
	}

	// say_letter5
	void OnSayLetter5()
	{
		SayText("They take me about five years a piece to make, so I don't install them cheap!");
		CallEventDelayed(4.0f, "say_letter6");
	}

	// say_letter6
	void OnSayLetter6()
	{
		SayText("100,000 gold. Take it or leave it.");
		CHATTING_PLAYER = false;
		CallEventDelayed(2.0f, "resume_idle");
	}

	// make_gaxe
	void OnMakeGaxe(CBasePlayer@ target = null)
	{
		CHATTING_PLAYER = true;
		@GAXE_TARGET = target;
		SayText("Wow, rich boy. *cough* Okay... Here we go.");
		SetModelBody(0, 1);
		SetModelBody(1, 1);
		SetIdleAnim("smith_hammer_time");
		PlayAnim("once", "smith_hammer_time");
		CallEventDelayed(1.0f, "smith_noise");
		CallEventDelayed(2.0f, "smith_noise");
		CallEventDelayed(3.0f, "smith_noise");
		CallEventDelayed(4.0f, "smith_noise");
		CallEventDelayed(5.0f, "smith_noise");
		CallEventDelayed(6.0f, "smith_noise");
		CallEventDelayed(7.0f, "make_gaxe2");
	}

	// make_gaxe2
	void OnMakeGaxe2()
	{
		SetIdleAnim("smith_hammer_idle");
		PlayAnim("once", "smith_hammer_idle");
		SayText("Alright...");
		CallEventDelayed(2.0f, "make_gaxe3");
	}

	// make_gaxe3
	void OnMakeGaxe3()
	{
		Offer(GAXE_TARGET, "axes_golden_ref");
		SetModelBody(0, 0);
		SetModelBody(1, 0);
		SetIdleAnim("dryhands");
		PlayAnim("once", "dryhands");
		SayText("There. That thing will never break again, guaranteed.");
		CHATTING_PLAYER = false;
		CallEventDelayed(3.0f, "resume_idle");
	}

	// resume_idle
	void OnResumeIdle()
	{
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");
	}

	// smith_noise
	void OnSmithNoise()
	{
		PlayRandomSound(0, 10, "debris/metal3.wav", "debris/metal2.wav", "debris/metal1.wav");
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

	void OnOfferIsthief() {} // offer_isthief
	void OnOfferNotthief() {} // offer_notthief
	void OnResetchat() {} // resetchat

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/blacksmith.mdl");
		CallEventDelayed(25.0f, "DeraliaBlacksmith_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaBlacksmith_FirstThink();
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
		if (name == "make_gaxe") { OnMakeGaxe(PlayerParam(params, 0)); return true; }
		if (name == "make_gaxe2") { OnMakeGaxe2(); return true; }
		if (name == "make_gaxe3") { OnMakeGaxe3(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "resume_idle") { OnResumeIdle(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_letter") { OnSayLetter(PlayerParam(params, 0)); return true; }
		if (name == "say_letter2") { OnSayLetter2(); return true; }
		if (name == "say_letter3") { OnSayLetter3(); return true; }
		if (name == "say_letter4") { OnSayLetter4(); return true; }
		if (name == "say_letter5") { OnSayLetter5(); return true; }
		if (name == "say_letter6") { OnSayLetter6(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_store") { OnSayStore(); return true; }
		if (name == "smith_noise") { OnSmithNoise(); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "DeraliaBlacksmith_Timer") { DeraliaBlacksmith_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
