#pragma context server

// Converted from helena/vendor8.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

[script "helena/vendor8"]
class Vendor8 : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// Constants
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string STORE_NAME = "helena_general_store";
	int CANCHAT = 1;
	string OVERCHARGE = "OVERCHARGE";
	float SELL_RATIO = 0.0f;
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	float ARROW_AMT = 0.0f;

	// unnamed block (first think)
	void Vendor8_FirstThink()
	{
		// base_vendor
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_NAME = "helena_general_store";
		CANCHAT = 1;
		OVERCHARGE = "150%";
		SELL_RATIO = 0.8f;

		ANIM_DEATH = "diesimple";

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetName("Fletcher");
		// ov		360
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
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
		// |Store name|  |Item name|  		|Quantity|	|cost%|
		AddStoreItem(STORE_NAME, "proj_arrow_fire", 600, OVERCHARGE, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_wooden", 600, OVERCHARGE, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_broadhead", 300, OVERCHARGE, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_silvertipped", 300, OVERCHARGE, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_poison", 300, OVERCHARGE, 0, 120);

		AddStoreItem(STORE_NAME, "proj_bolt_wooden", 100, OVERCHARGE, 0, 25);
		// addstoreitem  STORE_NAME     proj_bolt_fire	600		OVERCHARGE	0 100
		AddStoreItem(STORE_NAME, "proj_bolt_iron", 100, OVERCHARGE, 0, 25);
		// addstoreitem  STORE_NAME     proj_bolt_steel	25		OVERCHARGE	0 100
		AddStoreItem(STORE_NAME, "pack_quiver", 3, OVERCHARGE, SELL_RATIO);
		// addstoreitem  STORE_NAME     pack_xbowquiver	   	3	OVERCHARGE	SELL_RATIO
		AddStoreItem(STORE_NAME, "bows_orcbow", 1, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_treebow", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_shortbow", 1, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_feather", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "pack_quiver", 1, OVERCHARGE, SELL_RATIO);

		if (RandomInt(1, 12) == 1)
		{
			ARROW_AMT = RandomInt(1, 5) * 30.0f;
			AddStoreItem(STORE_NAME, "proj_arrow_jagged", ARROW_AMT, OVERCHARGE, SELL_RATIO, 30);
		}
		if (RandomInt(1, 10) == 1) {}
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
		Vendor8_FirstThink();
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
