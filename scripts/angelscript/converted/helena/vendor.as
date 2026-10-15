#pragma context server

// Converted from helena/vendor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/help/first_vendor.as"
#include "converted/helena/helena_npc.as"
#include "converted/shops/base_magic.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HelenaVendor
{
	// Constants
	string SOUND_DEATH = "none";
	bool STORE_SELLMENU = true;
	bool STORE_RESTOCK = false;
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string ANIM_DEATH = "ANIM_DEATH";
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	string STORE_BUYMENU = "STORE_BUYMENU";
	string MAGIC_SHOP = "MAGIC_SHOP";
	int STORE_TYPE = 0;
	string TEMP = "TEMP";
	string STORE_NAME = "STORE_NAME";
	string OVERCHARGE = "OVERCHARGE";
	float SELL_RATIO = 0.0f;
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	bool VEND_NO_GOODBYE = false;

	// unnamed block (first think)
	// Random merchant
	void HelenaVendor_FirstThink()
	{
		// base_vendor
		ANIM_DEATH = "diesimple";

		STORE_TRADEEXT = "trade";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_BUYMENU = "1";

		MAGIC_SHOP = "0";
	}

	// npc_spawn
	void HelenaVendor_OnNpcSpawn(string npc = "")
	{
		SetHealth(35);
		SetName("Traveling Merchant");
		// ov		30
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

		TEMP = "helena" + RandomInt(0, 400);
		STORE_NAME = TEMP;

		STORE_TYPE = RandomInt(1, 6);
		OVERCHARGE = RandomInt(100, 150);
		SELL_RATIO = Random(0.5f, 0.9f);
	}

	// vendor_addstoreitems
	void HelenaVendor_OnVendorAddstoreitems()
	{
		OnStoreFood();
		OnStoreEquip();
		OnStoreArmor();
		OnStoreWeapon();
		OnStoreMagic();
		OnStoreNone();
	}

	// store_food
	void HelenaVendor_OnStoreFood()
	{
		if (STORE_TYPE != 1)
			return;
		// |Store name|	|Item name|              |Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "health_apple", RandomInt(5, 15), OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "health_lpotion", 0, OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "item_log", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "health_mpotion", 0, OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "health_spotion", 0, OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "pack_bigsack", 1, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "mana_mpotion", 0, OVERCHARGE, 0.1f);
	}

	// store_equip
	void HelenaVendor_OnStoreEquip()
	{
		if (STORE_TYPE != 2)
			return;
		// |Store name|	|Item name|              |Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(3, 8), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_log", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(1, 3), OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "pack_bigsack", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);
		// addstoreitem	STORE_NAME	pack_sack		$rand(1,3)		OVERCHARGE		SELL_RATIO
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);
		// addstoreitem	STORE_NAME	sheath_belt		$rand(1,3)		OVERCHARGE		SELL_RATIO
		// addstoreitem	STORE_NAME	sheath_back		$rand(0,3)		OVERCHARGE		SELL_RATIO
		// addstoreitem	STORE_NAME	sheath_belt_holster	$rand(1,3)		OVERCHARGE		SELL_RATIO
		AddStoreItem(STORE_NAME, "sheath_back_holster", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);

		// addstoreitem	STORE_NAME	sheath_dagger		$rand(0,3)		OVERCHARGE		SELL_RATIO
		// Items to buy
		// addstoreitem	STORE_NAME	pack_archersquiver	0			OVERCHARGE		SELL_RATIO
		AddStoreItem(STORE_NAME, "pack_quiver", 0, OVERCHARGE, SELL_RATIO);

		// addstoreitem	STORE_NAME	sheath_back_snakeskin	0			OVERCHARGE		SELL_RATIO
		// addstoreitem	STORE_NAME	sheath_belt_snakeskin	0			OVERCHARGE		SELL_RATIO
		// Random items
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(1, 5), OVERCHARGE, 0.1f);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "health_lpotion", RandomInt(1, 2), OVERCHARGE, 0.1f);
		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORE_NAME, "health_spotion", RandomInt(1, 2), OVERCHARGE, 0.1f);

		// if( $rand(1,6) == 1 ) addstoreitem	STORE_NAME	sheath_belt_snakeskin 	$rand(1,2)	OVERCHARGE	SELL_RATIO
		VEND_NEWBIE = "1";
		VEND_WEAPONS = false;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// store_armor
	void HelenaVendor_OnStoreArmor()
	{
		if (STORE_TYPE != 3)
			return;
		// |Store name|	|Item name|		|Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "shields_buckler", RandomInt(1, 5), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_knight", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_mongol", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_plate", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_knight", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_studded", RandomInt(1, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_mongol", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_plate", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "shields_ironshield", RandomInt(1, 3), OVERCHARGE, 0.25f);
		AddStoreItem(STORE_NAME, "shields_lironshield", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);

		// Items to buy
		AddStoreItem(STORE_NAME, "skin_bear", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "skin_boar", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "skin_boar_heavy", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "skin_ratpelt", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_dark", 0, 200, 1);
		AddStoreItem(STORE_NAME, "armor_golden", 0, 200, 1);
		AddStoreItem(STORE_NAME, "armor_helm_dark", 0, 200, 1);
		AddStoreItem(STORE_NAME, "armor_helm_golden", 0, 200, 1);
		AddStoreItem(STORE_NAME, "armor_leather", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_torn", 0, OVERCHARGE, SELL_RATIO);

		VEND_NEWBIE = "0";
		VEND_WEAPONS = false;
		VEND_CONTAINERS = false;
		VEND_ARMORER = true;
	}

	// store_weapon
	void HelenaVendor_OnStoreWeapon()
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
		AddStoreItem(STORE_NAME, "axes_axe", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_2haxe", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer2", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_mace", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_maul", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_gauntlets_leather", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "polearms_qs", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "polearms_sp", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);

		// Items to buy
		AddStoreItem(STORE_NAME, "blunt_greatmaul", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_katana", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_katana2", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_katana3", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_katana4", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_skullblade", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_skullblade2", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_skullblade3", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_skullblade4", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_fangstooth", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger2", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger3", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger4", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife2", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife3", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife4", 0, OVERCHARGE, SELL_RATIO);

		// addstoreitem  STORE_NAME     sheath_back		1		OVERCHARGE	SELL_RATIO
		AddStoreItem(STORE_NAME, "sheath_back_holster", 1, OVERCHARGE, SELL_RATIO);

		// addstoreitem  STORE_NAME     sheath_back_snakeskin	$rand(0,1)		OVERCHARGE	SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_belt		1		OVERCHARGE	SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_dagger 		1		OVERCHARGE	SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_belt_snakeskin	$rand(0,1)		OVERCHARGE	SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_dagger		1		OVERCHARGE	SELL_RATIO
		// addstoreitem  STORE_NAME     sheath_belt 		1		OVERCHARGE	SELL_RATIO
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
		// addstoreitem STORE_NAME sheath_belt_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_back_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_dagger_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_axe_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_blunt_snakeskin	1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_holster_snakeskin OVERCHARGE1 OVERCHARGE SELL_RATIO
		AddStoreItem(STORE_NAME, "sheath_back_holster", 5, 100, SELL_RATIO);

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// store_magic
	void HelenaVendor_OnStoreMagic()
	{
		if (STORE_TYPE != 5)
			return;
		MAGIC_SHOP = "1";
		// |Store name|	|Item name|		|Quantity|		|cost%|			|Sell Ratio|
		AddStoreItem(STORE_NAME, "scroll_fire_dart", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_lightning_weak", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_glow", RandomInt(1, 5), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_fire_dart", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_lightning_weak", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_glow", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_log", RandomInt(1, 4), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_ice_shield", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_summon_rat", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll2_summon_rat", RandomInt(0, 1), OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "mana_mpotion", RandomInt(3, 6), OVERCHARGE, 0.1f);
		AddStoreItem(STORE_NAME, "sheath_spellbook", RandomInt(3, 6), OVERCHARGE, SELL_RATIO);

		// Items to buy
		AddStoreItem(STORE_NAME, "scroll_blizzard", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_fire_wall", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_ice_wall", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_lightning_storm", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_summon_undead", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "scroll_volcano", 0, OVERCHARGE, SELL_RATIO);

		// Random items
		float extraOver = Float(OVERCHARGE);
		extraOver *= 1.5f;
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "scroll_summon_undead", RandomInt(1, 2), extraOver, 0.5f);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "scroll_rejuvenate", RandomInt(1, 2), extraOver, 0.5f);

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = false;
		VEND_ARMORER = false;
	}

	// store_none
	void HelenaVendor_OnStoreNone()
	{
		if (STORE_TYPE != 6)
			return;
		DeleteEntity(ENT_ME);
	}

	// trade_done
	void HelenaVendor_OnTradeDone()
	{
		if (RandomInt(1, 3) != 1)
			return;
		if (VEND_NO_GOODBYE)
			VEND_NO_GOODBYE = false;
		else
			SayText("Come again soon!");
	}

	// game_spawn
	void HelenaVendor_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CatchSpeech("npc_say_store", STORE_TRIGGERTEXT);
		LegacyCommand("npcstore.create", STORE_NAME);

		OnVendorAddstoreitems();
	}

	// game_menu_getoptions
	void HelenaVendor_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (RAID_ON)
			return;
		OnVendorAddstoremenu();
	}

	// vendor_addstoremenu
	void HelenaVendor_OnVendorAddstoremenu()
	{
		MenuItem menuItem;

		menuItem.id = "genericstore";
		menuItem.priority = "-100";
		SetLocal("reg.mitem.access", "all");

		if (STORE_CLOSED == 0)
		{
			menuItem.title = "Shop";
			menuItem.type = "callback";
			menuItem.callback = "vendor_offerstore";
		}
		else
		{
			menuItem.title = "Closed";
			menuItem.type = "disabled";
		}

		RegisterMenuItem(menuItem);
	}

	// game_playerused
	// Player pressed '+use' on me
	void HelenaVendor_OnGamePlayerused(CBasePlayer@ player = null)
	{
		if (RAID_ON)
			return;
		OnVendorUsed();
		OnVendorOfferstore(ToPlayer(EntityOf(ENT_LASTUSED)));
	}

	// npc_say_store
	// Player said my keyword
	void HelenaVendor_OnNpcSayStore()
	{
		if (RAID_ON)
			return;
		OnVendorOfferstore(FindPlayer(ENT_LASTSPOKE));
	}

	// vendor_offerstore
	// Offer store to a player
	// Gives parent script chance to override this and cancel the tranaction
	// 1: Offer Target
	void HelenaVendor_OnVendorOfferstore(CBasePlayer@ player = null)
	{
		if (RAID_ON)
			return;
		OnBasevendorOfferstore(EntityId(player));
	}

	// basevendor_offerstore
	// 1: Offer Target
	void HelenaVendor_OnBasevendorOfferstore(string target = "")
	{
		if (RAID_ON)
			return;
		string service = "0";
		if (Truthy(STORE_BUYMENU))
			service = "buy";
		if (STORE_SELLMENU)
			service += ";sell";

		LegacyCommand("npcstore.offer", STORE_NAME, target, service, "trade");
	}

	// unnamed block (timer)
	// Restock items after the level's been going a while
	// Restock means delete all store items and restock them
	void HelenaVendor_Timer()
	{
		CallEventDelayed(Random(0, 0), "HelenaVendor_Timer");

		if (RAID_ON)
			return;
		if (!STORE_RESTOCK)
			return;

		LegacyCommand("npcstore.remove", STORE_NAME, "allitems");
		OnVendorAddstoreitems();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		HelenaVendor_OnGameSpawn(playerRace, playerGender);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		HelenaNpc_OnBasevendorOfferstore(target); // helena/helena_npc
		HelenaVendor_OnBasevendorOfferstore(target);
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		BaseMagic_OnVendorAddstoreitems(); // shops/base_magic
		HelenaVendor_OnVendorAddstoreitems();
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		HelenaVendor_OnGameMenuGetoptions(player);
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
		HelenaVendor_OnVendorOfferstore(player);
	}

	void OnNpcSpawn(string npc = "") { HelenaVendor_OnNpcSpawn(npc); } // npc_spawn
	void OnStoreFood() { HelenaVendor_OnStoreFood(); } // store_food
	void OnStoreEquip() { HelenaVendor_OnStoreEquip(); } // store_equip
	void OnStoreArmor() { HelenaVendor_OnStoreArmor(); } // store_armor
	void OnStoreWeapon() { HelenaVendor_OnStoreWeapon(); } // store_weapon
	void OnStoreMagic() { HelenaVendor_OnStoreMagic(); } // store_magic
	void OnStoreNone() { HelenaVendor_OnStoreNone(); } // store_none
	void OnTradeDone() { HelenaVendor_OnTradeDone(); } // trade_done
	void OnVendorAddstoremenu() { HelenaVendor_OnVendorAddstoremenu(); } // vendor_addstoremenu
	void OnGamePlayerused(CBasePlayer@ player = null) { HelenaVendor_OnGamePlayerused(player); } // game_playerused
	void OnNpcSayStore() { HelenaVendor_OnNpcSayStore(); } // npc_say_store
	void OnVendorUsed(string player = "") {} // vendor_used

	// This file's events and timers by their .script names
	bool HelenaVendor_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_say_store") { OnNpcSayStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
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
		if (name == "HelenaVendor_Timer") { HelenaVendor_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "helena/vendor"]
shared class HelenaVendorScript : BaseNpcScript, HelenaVendor, FirstVendor, HelenaNpc, BaseMagic, BaseChat, BaseNpcVendorConfirm
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$randf(STORE_RESTOCK_TIME_LO,STORE_RESTOCK_TIME_HI)")), "HelenaVendor_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaVendor_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return HelenaVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseMagic_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
