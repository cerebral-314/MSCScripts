#pragma context server

// Converted from old_helena/genstore.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/old_helena/base_old_helena_npc.as"

[script "old_helena/genstore"]
class OldHelenaGenstore : BaseNpcScript, BaseNpcVendor, FirstVendor, BaseOldHelenaNpc
{
	// Constants
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string STORE_NAME = "helena_general_store";
	int CANCHAT = 1;
	string OVERCHARGE = "150%";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	float MOAR_SUFF = 0.0f;
	bool HELENA_SAVED = false;

	// unnamed block (first think)
	void OldHelenaGenstore_FirstThink()
	{
		// base_vendor
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_NAME = "helena_general_store";
		CANCHAT = 1;
		OVERCHARGE = "150%";

		ANIM_DEATH = "dieforward";
		SELL_WEAPON_LEVEL = "6,12";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(800);
		SetName("Arthur");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");

		CallEventDelayed(120.0f, "add_moar_stuff");
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		if (!HELENA_SAVED)
			return;
		SayText("Just for you, I've these old galat storage notes you can use to trade gold with your friends.");
		OnBchatMouthMove();
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

	// old_helena_warboss_died
	// Add winning items
	void OnOldHelenaWarbossDied()
	{
		BaseOldHelenaNpc_OnOldHelenaWarbossDied(); // old_helena/base_old_helena_npc
		AddStoreItem(STORE_NAME, "item_gwond", 1, 0);
		HELENA_SAVED = true;

		CreateNpc("chests/galats", RelativePosition(Vector3(80, 30, 50)));
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// A VERY expensive store
		// |Store name|  |Item name|         |Quantity|		|cost%|
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(1, 3), 110);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", 1, 115);
		AddStoreItem(STORE_NAME, "smallarms_dagger", 1, 105);
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(10, 20), 115, 0.2f);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", 2, OVERCHARGE, "SELL_RATIO");
		AddStoreItem(STORE_NAME, "pack_bigsack", 2, OVERCHARGE, "SELL_RATIO");

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "sheath_back", 1, 95);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "sheath_belt_holster", 1, 95);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "blunt_maul", RandomInt(1, 3), 95);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "armor_leather_studded", 1, 95);
	}

	// add_moar_stuff
	void OnAddMoarStuff()
	{
		MOAR_SUFF += 1.0f;
		CallEventDelayed(120.0f, "add_moar_stuff");
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
		BaseOldHelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); // old_helena/base_old_helena_npc
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
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
		OldHelenaGenstore_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseOldHelenaNpc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_moar_stuff") { OnAddMoarStuff(); return true; }
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseOldHelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
