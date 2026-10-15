#pragma context server

// Converted from gatecity/vendor.script by msc_transpiler.
// Random merchant

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "gatecity/vendor"]
class GatecityVendor : BaseChatScript, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string SOUND_DEATH = "none";
	bool STORE_SELLMENU = true;
	bool STORE_RESTOCK = false;
	bool NO_RUMOR = true;
	bool NO_CHAT = true;
	bool VEND_SPEC_SHEATHS = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	string STORE_BUYMENU = "STORE_BUYMENU";
	string MAGIC_SHOP = "MAGIC_SHOP";
	int STORE_TYPE = 0;
	string OVERCHARGE = "OVERCHARGE";
	float SELL_RATIO = 0.0f;
	string TEMP = "TEMP";
	string STORE_NAME = "STORE_NAME";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	bool VEND_NO_GOODBYE = false;

	// unnamed block (first think)
	void GatecityVendor_FirstThink()
	{
		// base_vendor
		STORE_TRADEEXT = "trade";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_BUYMENU = "1";

		MAGIC_SHOP = "0";
	}

	// game_spawn
	void GatecityVendor_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(35);
		SetName("Traveling Merchant");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_store", "buy", "trade", "sell", "purchase", "sale");
		CatchSpeech("say_job", "job", "work", "money", "gold");

		TEMP = "gatecity" + RandomInt(0, 400);
		STORE_NAME = TEMP;

		STORE_TYPE = RandomInt(1, 6);
		OVERCHARGE = RandomInt(90, 160);
		SELL_RATIO = Random(0.5f, 0.9f);
	}

	// game_spawn
	void GatecityVendor_OnGameSpawn_2(string playerRace = "", string playerGender = "")
	{
		CatchSpeech("npc_say_store", STORE_TRIGGERTEXT);
		LegacyCommand("npcstore.create", STORE_NAME);

		OnVendorAddstoreitems();
	}

	// unnamed block (timer)
	// Restock items after the level's been going a while
	// Restock means delete all store items and restock them
	void GatecityVendor_Timer()
	{
		CallEventDelayed(Random(STORE_RESTOCK_TIME_LO, STORE_RESTOCK_TIME_HI), "GatecityVendor_Timer");

		if (!STORE_RESTOCK)
			return;

		LegacyCommand("npcstore.remove", STORE_NAME, "allitems");
		OnVendorAddstoreitems();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		GatecityVendor_OnGameSpawn(playerRace, playerGender);
		GatecityVendor_OnGameSpawn_2(playerRace, playerGender);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm

		OnVendorAddstoremenu();
	}

	// vendor_addstoremenu
	void OnVendorAddstoremenu()
	{
		BaseNpcVendor_OnVendorAddstoremenu(); // monsters/base_npc_vendor
		MenuItem menuItem;

		menuItem.id = "genericstore";
		menuItem.priority = "-100";
		SetLocal("reg.mitem.access", "all");

		menuItem.title = "Shop";
		menuItem.type = "callback";
		menuItem.callback = "vendor_offerstore";

		RegisterMenuItem(menuItem);
	}

	// game_playerused
	// Player pressed '+use' on me
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGamePlayerused(player); // monsters/base_npc_vendor

		OnVendorUsed();
		OnVendorOfferstore(ToPlayer(EntityOf(ENT_LASTUSED)));
	}

	// npc_say_store
	// Player said my keyword
	void OnNpcSayStore()
	{
		BaseNpcVendor_OnNpcSayStore(); // monsters/base_npc_vendor

		OnVendorOfferstore(FindPlayer(ENT_LASTSPOKE));
	}

	// vendor_offerstore
	// Offer store to a player
	// Gives parent script chance to override this and cancel the tranaction
	// 1: Offer Target
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm

		OnBasevendorOfferstore(EntityId(player));
	}

	// basevendor_offerstore
	// 1: Offer Target
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor

		string service = "0";
		if (Truthy(STORE_BUYMENU))
			service = "buy";
		if (STORE_SELLMENU)
			service += ";sell";

		LegacyCommand("npcstore.offer", STORE_NAME, target, service, "trade");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		OnStoreFood();
		OnStoreEquip();
		OnStoreArmor();
		OnStoreWeapon();
		OnStoreMagic();
		OnStoreNone();
	}

	// store_food
	void OnStoreFood()
	{
		if (STORE_TYPE != 1)
			return;
		// |Store name|	|Item name|              |Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "health_apple", RandomInt(3, 6), OVERCHARGE, SELL_RATIO);
	}

	// store_equip
	void OnStoreEquip()
	{
		if (STORE_TYPE != 2)
			return;
		// |Store name|	|Item name|              |Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(3, 8), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_log", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(0, 3), OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "pack_bigsack", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		// addstoreitem  STORE_NAME	pack_sack		$rand(0,3)		OVERCHARGE		SELL_RATIO
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_belt", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		// Random items
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(1, 5), OVERCHARGE, 0.1f);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "health_lpotion", RandomInt(1, 2), OVERCHARGE, 0.1f);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "health_spotion", RandomInt(1, 2), OVERCHARGE, 0.1f);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "sheath_belt_snakeskin", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);

		VEND_NEWBIE = "1";
		VEND_WEAPONS = false;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// store_armor
	void OnStoreArmor()
	{
		if (STORE_TYPE != 3)
			return;
		// |Store name|	|Item name|		|Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "armor_helm_knight", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_mongol", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_plate", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_knight", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_studded", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_mongol", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_plate", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "shields_buckler", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);

		VEND_NEWBIE = "0";
		VEND_WEAPONS = false;
		VEND_CONTAINERS = false;
		VEND_ARMORER = true;
	}

	// store_weapon
	void OnStoreWeapon()
	{
		if (STORE_TYPE != 4)
			return;
		SELL_WEAPON_LEVEL = "3,6,9,12";
		// |Store name|	|Item name|		|Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "smallarms_knife", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dagger", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_shortsword", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_scimitar", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_smallaxe", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_doubleaxe", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_axe", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_2haxe", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer2", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_mace", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_maul", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_holster", 1, OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "polearms_qs", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "polearms_sp", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);

		// Random items
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "blunt_hammer3", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "axes_battleaxe", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "axes_scythe", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "swords_longsword", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);

		if (RandomInt(1, 5) != 1)
			return;
		AddStoreItem(STORE_NAME, "sheath_belt_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_dagger_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_axe_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_blunt_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_holster_snakeskin", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_holster", 5, 100, SELL_RATIO);

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// store_magic
	void OnStoreMagic()
	{
		if (STORE_TYPE != 5)
			return;
		MAGIC_SHOP = "1";
		// |Store name|	|Item name|		|Quantity|		|cost%|		|Sell Ratio|
		AddStoreItem(STORE_NAME, "scroll_fire_dart", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_glow", RandomInt(1, 5), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_ice_shield", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_frost_xolt", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_ice_shield", RandomInt(1, 3), 500, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_summon_rat", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_spellbook", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "scroll2_summon_rat", RandomInt(1, 3), OVERCHARGE, 0.25f);
		AddStoreItem(STORE_NAME, "mana_mpotion", RandomInt(3, 6), OVERCHARGE, 0.2f);
		// Random items
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "scroll_summon_undead", RandomInt(1, 2), 200, 0.5f);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "scroll_rejuvenate", RandomInt(1, 2), 200, 0.5f);

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = false;
		VEND_ARMORER = false;
	}

	// store_none
	void OnStoreNone()
	{
		if (STORE_TYPE != 6)
			return;
		DeleteEntity(ENT_ME);
	}

	// trade_done
	void OnTradeDone()
	{
		if (RandomInt(1, 3) != 1)
			return;
		if (VEND_NO_GOODBYE)
			VEND_NO_GOODBYE = false;
		else
			SayText("Come again soon!");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnChatLoop() { BaseChat_OnChatLoop(); } // chat_loop
	void OnBchatMouthMove() { BaseChat_OnBchatMouthMove(); } // bchat_mouth_move

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$randf(STORE_RESTOCK_TIME_LO,STORE_RESTOCK_TIME_HI)")), "GatecityVendor_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GatecityVendor_FirstThink();
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
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_say_store") { OnNpcSayStore(); return true; }
		if (name == "store_armor") { OnStoreArmor(); return true; }
		if (name == "store_equip") { OnStoreEquip(); return true; }
		if (name == "store_food") { OnStoreFood(); return true; }
		if (name == "store_magic") { OnStoreMagic(); return true; }
		if (name == "store_none") { OnStoreNone(); return true; }
		if (name == "store_weapon") { OnStoreWeapon(); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_addstoremenu") { OnVendorAddstoremenu(); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		if (name == "GatecityVendor_Timer") { GatecityVendor_Timer(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
