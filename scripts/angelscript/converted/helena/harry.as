#pragma context server

// Converted from helena/harry.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

[script "helena/harry"]
class HelenaHarry : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	string MY_RAID_POS = "MY_RAID_POS";

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "harrys_inn";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool SAY_SO = false;
	string OVERCHARGE = "OVERCHARGE";
	float SELL_RATIO = 0.0f;

	// unnamed block (first think)
	void HelenaHarry_FirstThink()
	{
		ANIM_DEATH = "diesimple";

		// base_vendor
		STORE_NAME = "harrys_inn";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SAY_SO = false;

		OVERCHARGE = RandomInt(100, 150);
		SELL_RATIO = Random(0.5f, 0.9f);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
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
		AddStoreItem(STORE_NAME, "health_apple", 15, OVERCHARGE);
		AddStoreItem(STORE_NAME, "health_mpotion", 4, OVERCHARGE, 0.2f);
		AddStoreItem(STORE_NAME, "proj_arrow_wooden", 300, OVERCHARGE, 0, 60);
		AddStoreItem(STORE_NAME, "drink_mead", 20, OVERCHARGE);
		AddStoreItem(STORE_NAME, "drink_ale", 20, OVERCHARGE);
		AddStoreItem(STORE_NAME, "drink_wine", 20, OVERCHARGE);
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

	void OnSetsayso() {} // setsayso

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaHarry_FirstThink();
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
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
