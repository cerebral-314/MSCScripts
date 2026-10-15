#pragma context server

// Converted from gatecity/generalstore.script by msc_transpiler.
// general store

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "gatecity/generalstore"]
class Generalstore : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string STORE_NAME = "gatecity_generalstore";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool NO_RUMOR = true;
	bool NO_CHAT = true;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	int JOB = 0;
	int CANCHAT = 0;

	// unnamed block (first think)
	void Generalstore_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SELL_WEAPON_LEVEL = "3,6";

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// game_spawn
	// Spawn properties
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm

		SetUniqueName("Egmont");
		SetHealth(25);
		SetGold(25);
		SetName("Egmont the Merchant");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 1); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 0); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetInvincible(true);

		SetModelBody(2, 0);

		JOB = 0;
		CANCHAT = 1;
		STORE_CLOSED = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");

		OnCreatemystore();
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("I heard a fellow merchant from this city has gone missing.");
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
			SayText("Fine goods for sale!");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(ENT_LASTSPOKE) <= 90.0f)
			SayText("Can I get something for you?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Sorry, I have no need to hire anyone.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "smallarms_rknife", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_knife", RandomInt(1, 3), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "axes_rsmallaxe", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_smallaxe", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_axe", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_doubleaxe", 1, 150, SELL_RATIO);

		AddStoreItem(STORE_NAME, "blunt_club", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer1", RandomInt(1, 5), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "item_torch", RandomInt(5, 10), 100, SELL_RATIO);

		// addstoreitem  STORE_NAME     pack_sack		$rand(1,5)	100	SELL_RATIO
		AddStoreItem(STORE_NAME, "pack_bigsack", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(1, 3), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "sheath_belt", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_belt_holster", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_holster", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_dagger", RandomInt(1, 3), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "sheath_back_snakeskin", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_belt_snakeskin", 0, 100, SELL_RATIO);
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

	// say_containers
	void OnSayContainers()
	{
		SayText("Weapon straps hold any type of weapon. Quivers hold amunition. Big sacks hold nearly everything else.");
		SayText("Backpacks can hold nearly anything, useful for more a more generalized inventory.");
		SayText("Spellbooks hold magic scrolls. The small sack can hold most items, but has very little room, so it can't hold much.");
		SayText("I also offer more specialized sheaths, that can only hold specific weapon types.");
		OnVendMouthMove();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	void OnCreatemystore() {} // createmystore
	void OnVendMouthMove() {} // vend_mouth_move

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Generalstore_FirstThink();
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
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_containers") { OnSayContainers(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
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
