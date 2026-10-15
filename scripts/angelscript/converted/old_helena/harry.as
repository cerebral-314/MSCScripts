#pragma context server

// Converted from old_helena/harry.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/old_helena/base_old_helena_npc.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_npc_vendor.as"

[script "old_helena/harry"]
class OldHelenaHarry : BaseNpcScript, BaseOldHelenaNpc, BaseNpcVendor, FirstVendor
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	string MY_RAID_POS = "MY_RAID_POS";

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "harrys_inn";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool SAY_SO = false;

	// unnamed block (first think)
	void OldHelenaHarry_FirstThink()
	{
		ANIM_DEATH = "diesimple";

		// base_vendor
		STORE_NAME = "harrys_inn";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SAY_SO = false;
	}

	// old_helena_warboss_died
	// Add winning items
	void OnOldHelenaWarbossDied()
	{
		BaseOldHelenaNpc_OnOldHelenaWarbossDied(); // old_helena/base_old_helena_npc
		AddStoreItem(STORE_NAME, "mana_regen", 2, 100, 0);
		AddStoreItem(STORE_NAME, "item_light_crystal", ActivePlayerCount(), 100, 0);
		AddStoreItem(STORE_NAME, "mana_leadfoot", 4, 100, 0);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(800);
		SetName("Harry");
		// ov		30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 1);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_quiet", "quiet");

		CatchSpeech("say_orcs", "orcs");
		CatchSpeech("say_dorfgan", "dorfgan");
		CatchSpeech("say_erkold", "erkold");
		CatchSpeech("say_serrold", "serrold");
		CatchSpeech("say_inn", "inn", "innkeeper");

		CatchSpeech("say_thanks", "ok", "okay", "sure");
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		// (never true here, the rest is skipped) if HELENA_SAVED
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlayAnim("once", "pondering3");
		SayText("Greetings to you adventurer!");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2test
	void OnSayHi2test()
	{
		if ((SAY_SO ? 1 : 0) != 0)
			return;

		SayText("I am Harry, your humble innkeeper.");

		OnSetsayso();
	}

	// satsayso
	void OnSatsayso()
	{
		SAY_SO = true;
	}

	// say_orcs
	void OnSayOrcs()
	{
		SayText("They disappear after 10 drinks!");
	}

	// say_dorfgan
	void OnSayDorfgan()
	{
		PlayAnim("once", "yes");
		SayText("Nice guy, he keeps order when my customers get a little fuzzy");
	}

	// say_erkold
	void OnSayErkold()
	{
		PlayAnim("once", "yes");
		SayText("Poor man.. Lost everything...");
	}

	// say_serrold
	void OnSaySerrold()
	{
		SayText("Serrold? He was our village leader...until the attacks.");
		CallEventDelayed(3.0f, "say_serrold2");
	}

	// say_serrold2
	void OnSaySerrold2()
	{
		SayText("He wasn't paying attention and an arrow ran him through...");
	}

	// say_inn
	void OnSayInn()
	{
		SayText("Yes, I own the inn over there. It's free to anyone passing through, but donations are welcome.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|	|Bundle amt|
		AddStoreItem(STORE_NAME, "health_apple", 15, 100);
		AddStoreItem(STORE_NAME, "health_mpotion", 20, 100, 0);
		AddStoreItem(STORE_NAME, "mana_mpotion", 20, 100, 0);
		AddStoreItem(STORE_NAME, "drink_mead", 20, 100);
		AddStoreItem(STORE_NAME, "drink_ale", 20, 100);
		AddStoreItem(STORE_NAME, "drink_wine", 20, 100);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); // old_helena/base_old_helena_npc
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseOldHelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
	}

	void OnSetsayso() {} // setsayso

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OldHelenaHarry_FirstThink();
		BaseOldHelenaNpc_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "satsayso") { OnSatsayso(); return true; }
		if (name == "say_dorfgan") { OnSayDorfgan(); return true; }
		if (name == "say_erkold") { OnSayErkold(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2test") { OnSayHi2test(); return true; }
		if (name == "say_inn") { OnSayInn(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_serrold") { OnSaySerrold(); return true; }
		if (name == "say_serrold2") { OnSaySerrold2(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return BaseOldHelenaNpc_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
