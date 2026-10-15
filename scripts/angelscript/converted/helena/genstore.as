#pragma context server

// Converted from helena/genstore.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

[script "helena/genstore"]
class HelenaGenstore : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// Constants
	bool NO_CHAT = true;
	bool VEND_WEAPONS = true;
	bool VEND_CONTAINERS = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string STORE_NAME = "helena_arthur_store";
	int CANCHAT = 1;
	string OVERCHARGE = "OVERCHARGE";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";

	// unnamed block (first think)
	void HelenaGenstore_FirstThink()
	{
		// base_vendor
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_NAME = "helena_arthur_store";
		CANCHAT = 1;
		OVERCHARGE = "150%";

		ANIM_DEATH = "dieforward";
		SELL_WEAPON_LEVEL = "6,12";

		VEND_NEWBIE = "1";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetName("Arthur");
		// ov		360
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		Say("goods[.56]", "[.4]", "[.58]", "[.66]");
		CANCHAT = 0;
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// A VERY expensive store
		// |Store name|  |Item name|         |Quantity|		|cost%|
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(1, 3), OVERCHARGE);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", 1, OVERCHARGE);
		AddStoreItem(STORE_NAME, "smallarms_dagger", 1, OVERCHARGE);
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(10, 20), 115, 0.2f);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "pack_bigsack", 2, OVERCHARGE, SELL_RATIO);

		// if ( $rand(1,5) == 1 )
		// {
		// addstoreitem  STORE_NAME     sheath_back		1		OVERCHARGE
		// }
		// if ( $rand(1,3) == 1 )
		// {
		// addstoreitem  STORE_NAME     sheath_belt_holster	1		OVERCHARGE
		// }
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "blunt_maul", RandomInt(1, 3), OVERCHARGE);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "armor_leather_studded", 1, OVERCHARGE);
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
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

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

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		HelenaNpc_OnBasevendorOfferstore(target); // helena/helena_npc
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/goods.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaGenstore_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
