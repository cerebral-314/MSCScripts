#pragma context server

// Converted from old_helena/dorfgan.script by msc_transpiler.
// Dorfgan the Smith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/old_helena/base_old_helena_npc.as"

[script "old_helena/dorfgan"]
class Dorfgan : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseOldHelenaNpc
{
	// Constants
	string ANIM_ATTACK = "beatdoor";
	string STORE_NAME = "dorfgans_blacksmith";

	// Variables (an unset .script variable reads as its own name)
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string ATTACK1_DAMAGE = "3";
	bool SAY_SO = false;
	bool EXPLAINING_QUEST = false;
	int QUEST_1 = 0;
	bool QUEST_2 = false;
	bool OFFER_ITEMS = true;
	int CANCHAT = 1;
	bool CAN_SCREAM = true;
	bool CAN_RUN = true;
	bool SEE_ENEMY = false;
	bool HELENA_SAVED = false;
	float CATAPULT_COMMENT = 0.0f;
	bool DID_CATA_COMMENT = false;
	string CUR_PLAYER = "CUR_PLAYER";
	CBasePlayer@ REPAIR_QUEST_WINNER = null;
	bool FIXING_DAGGER = false;
	float REPAIR_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	int CHAT_STEPS = 0;
	bool MENTIONED_DAGGER = false;

	// Variables declared by included files, with the value they start with in this script
	Dorfgan()
	{
		ATTACK_RANGE = 64.0f;
	}

	// unnamed block (first think)
	void Dorfgan_FirstThink()
	{
		ATTACK_RANGE = 64.0f;
	}

	// addrandomitems
	void Dorfgan_OnAddrandomitems()
	{
		if (RandomInt(1, 2) != 1)
			return;
		AddStoreItem(STORE_NAME, "swords_longsword", 1, 200);
	}

	// addrandomitems
	void Dorfgan_OnAddrandomitems_2()
	{
		if (RandomInt(1, 2) != 1)
			return;
		AddStoreItem(STORE_NAME, "swords_scimitar", 1, 100);
	}

	// addrandomitems
	void Dorfgan_OnAddrandomitems_3()
	{
		if (RandomInt(1, 2) != 1)
			return;
		AddStoreItem(STORE_NAME, "axes_battleaxe", 1, 200);
	}

	// unnamed block (timer)
	void Dorfgan_Timer()
	{
		CallEventDelayed(1.5f, "Dorfgan_Timer");

		string targetsNearText = LegacyFunction("get_tsphere", "enemy", 128, MyOrigin());
		int targetsNear = Int(targetsNearText);

		if (targetsNear >= 1)
		{
			PlayAnim("once", ANIM_ATTACK);
			DoDamage(GetToken(targetsNearText, 0), ATTACK_RANGE, 20.0f, "90%", "blunt");
		}
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;
		if (!HELENA_SAVED)
			return;
		if (Truthy(ItemExists(player, "smallarms_rd")))
		{
			menuItem.title = "Repair rusted dagger (10,000 gold)";
			menuItem.type = "payment";
			menuItem.data = "smallarms_rd;gold:10000";
			menuItem.callback = "start_repair_dagger";
			menuItem.cb_failed = "not_enough_repair_dagger";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(1200);
		SetGold(25);
		SetName("Dorfgan");
		// ov 120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/blacksmith.mdl");

		SOUND_PAIN = "player/chesthit1.wav";
		SOUND_PAIN2 = "player/armhit1.wav";
		ATTACK1_DAMAGE = "3";
		ATTACK_RANGE = 90.0f;

		SAY_SO = false;
		EXPLAINING_QUEST = false;
		QUEST_1 = 0;
		QUEST_2 = false;
		OFFER_ITEMS = true;
		CANCHAT = 1;
		CAN_SCREAM = true;
		CAN_RUN = true;
		SEE_ENEMY = false;

		OnCreatemystore();

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_quest", "attack");
		CatchSpeech("say_quest", "orc");
		CatchSpeech("say_dagger", "dagger");

		NPCATK_TARGET = "unset";

		SetMenuAutoOpen(true);

		CallEventDelayed(260.0f, "add_moar_stuff");
	}

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGamePlayerused(player); // monsters/base_npc_vendor
		if (!HELENA_SAVED)
			return;
		if (!Truthy(ItemExists(player, "smallarms_rd")))
			return;
		CHAT_STEP1 = "Hey, that's a mighty interesting looking hunk of rust you have there.";
		CHAT_STEP2 = "I might be able to clean it up into something even more interesting, for a price.";
		CHAT_STEPS = 2;
		OnChatLoop();
		MENTIONED_DAGGER = true;
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor

		if (!HELENA_SAVED)
			return;
		SayText("I've got a few unusual items just for those who rescued Helena.");
		OnBchatMouthMove();
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		SayText("We're low on supplies, so I don't have much to offer...");
		CANCHAT = 0;
		CallEventDelayed(0.0f, "10");
	}

	// old_helena_warboss_died
	// Add winning items
	void OnOldHelenaWarbossDied()
	{
		BaseOldHelenaNpc_OnOldHelenaWarbossDied(); // old_helena/base_old_helena_npc

		HELENA_SAVED = true;
		// if ( $rand(1,2) == 1 ) addstoreitem STORE_NAME item_ore_lorel 1 200 0
		AddStoreItem(STORE_NAME, "blunt_northmaul972", 1, 200, 0);
		AddStoreItem(STORE_NAME, "bows_crossbow_heavy33", 1, 100, 0);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Adventurer! We're under [attack]!");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2test
	void OnSayHi2test()
	{
		if ((SAY_SO ? 1 : 0) != 0)
			return;

		SayText("I'm Dorfgan, the blacksmith.");

		OnSetsayso();
	}

	// setsayso
	void OnSetsayso()
	{
		SAY_SO = true;
	}

	// say_quest
	void OnSayQuest()
	{
		if ((EXPLAINING_QUEST ? 1 : 0) != 0)
			return;

		SayText("Our village is being ransacked by those blasted Orcs!");
		EXPLAINING_QUEST = true;
		CallEventDelayed(0.0f, "2");
	}

	// struck
	// Thothie - in this quest Dorfgan needs a hammer you would find in Thornlands to arm mercenaries
	// - it uses old convention and thus will not function, in addition to the fact that the hammer no longer appears there
	// - might consider some variant of this quest
	// {
	// eventname say_quest_2
	// saytext Mercenaries should be coming shortly to help... that is, if I can forge weapons for them.
	// calleventtimed 3 say_quest_3
	// }
	// {
	// eventname say_quest_3
	// saytext But I've lost my hammer and can't forge anything right now.
	// calleventtimed 2 say_quest_4
	// }
	// {
	// eventname say_quest_4
	// saytext I've lost it somewhere in the caves in the southern plains... without it, I'm afraid this village won't last long...
	// setvar EXPLAINING_QUEST 0
	// }
	// //Delivering Note from Erkold, if hammer has been returned
	// {
	// eventname recvoffer_item_erkoldsnote
	// if QUEST_1 equals 0
	// DLLFunc recvoffer refuse
	// saytext I need my hammer to finish it. Perhaps if you found it for me...
	// }
	// {
	// eventname recvoffer_item_erkoldsnote
	// if QUEST_1 equals 1
	// if QUEST_2 equals 0
	// DLLFunc recvoffer accept
	// saytext I see... well, it's all done and repaired. You'll need two hands for this one, it's heavy!
	// setvar QUEST_2 1
	// calleventtimed 4 givearmor
	// }
	// {
	// eventname givearmor
	// offer ent_lastgave armor_mongol
	// offer ent_lastgave armor_helm_mongol
	// }
	// {
	// eventname recvoffer_blunt_rustyhammer2
	// if QUEST_1 equals 0
	// DLLFunc recvoffer accept
	// saytext That's my hammer! Thank you very much for bringing it back!
	// setvar QUEST_1 1
	// calleventtimed 4 recvhammer_2
	// }
	// {
	// eventname recvhammer_2
	// playanim critical pull_needle
	// saytext It will be some time before the mercenaries will arrive. Please take this gold as a reward!
	// calleventtimed 30 callmercs
	// calleventtimed 2 recvhammer_3
	// }
	// {
	// eventname recvhammer_3
	// offer ent_lastgave gold 100
	// }
	// {
	// eventname callmercs
	// usetrigger spawnmercs
	// }
	// Thothie
	// - Dorfgan can't currently attack due to the dated conventions used here (plus his model as no anim attack event)
	// - I'd like Dorfgan to be able to fight back if you brought him a weapon (Dorfgan quest variant)
	// - If he does so it'd be best if he remained within a certain distance of his spawn
	// - (There maybe a function for this in base_npc_attack - if not, we should make on in base_monster_shared)
	// - outpost/super - has a patrol area function that is similar
	// //////////////////////////////////////////////////////////
	void OnStruck()
	{
		// Hit by someone
		SetVolume(10);
		PlayRandomSound(2, 10, SOUND_PAIN, SOUND_PAIN2, "none", "none");
		PlayAnim("once", "raflinch");

		OnFlee();
	}

	// resetoffer
	void OnResetoffer()
	{
		OFFER_ITEMS = true;
	}

	// playerused
	// /////////////////////////////////////////////////////////
	void OnPlayerused()
	{
		if (HELENA_SAVED)
			SayText("I've also an item or two for exclusive sale to our brave saviors here.");

		if ((OFFER_ITEMS ? 1 : 0) != 1)
			return;

		LegacyCommand("offerstore", STORE_NAME, "buysell", "trade");
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// vendor_addstoreitems
	// /////////////////////////////////////////////////////////
	// The blacksmith doesn't have much to offer since the village is being attacked and low on supplies
	void OnVendorAddstoreitems()
	{
		LegacyCommand("createstore", STORE_NAME);

		// |Store name|  |Item name|  |Quantity| |cost|
		AddStoreItem(STORE_NAME, "swords_shortsword", 1, 100);
		AddStoreItem(STORE_NAME, "swords_bastardsword", 1, 100);
		AddStoreItem(STORE_NAME, "axes_doubleaxe", 2, 100);
		AddStoreItem(STORE_NAME, "shields_ironshield", 2, 100);
		AddStoreItem(STORE_NAME, "shields_lironshield", 2, 100);
		AddStoreItem(STORE_NAME, "proj_bolt_wooden", 100, 100, 0, 25);
		AddStoreItem(STORE_NAME, "proj_bolt_fire", 100, 100, 0, 25);
		AddStoreItem(STORE_NAME, "proj_bolt_iron", 100, 100, 0, 25);
		AddStoreItem(STORE_NAME, "proj_bolt_steel", 75, 800, 0, 25);
		AddStoreItem(STORE_NAME, "proj_bolt_silver", 25, 800, 0, 25);

		OnAddrandomitems();
	}

	// addrandomitems
	void OnAddrandomitems()
	{
		Dorfgan_OnAddrandomitems();
		Dorfgan_OnAddrandomitems_2();
		Dorfgan_OnAddrandomitems_3();
	}

	// catapults_fire
	void OnCatapultsFire()
	{
		if (DID_CATA_COMMENT)
			return;
		CATAPULT_COMMENT += 1.0f;
		if (!(CATAPULT_COMMENT > 3.0f))
			return;

		SayText("Catapults!? May the gods save us! They've brought catapults!");
		DID_CATA_COMMENT = true;
	}

	// say_dagger
	void OnSayDagger(string player = "")
	{
		if (!Truthy(ItemExists(player, "smallarms_rd")))
			return;

		if (!HELENA_SAVED)
			SayText("Is now really the time to talk about this? We're under attack!");

		if (!HELENA_SAVED)
			return;
		if (FIXING_DAGGER)
			return;
		CUR_PLAYER = player;

		SayText("I always hate to see adventurers who can't properly take care of their equipment.");
		CallEventDelayed(1.0f, "say_dagger2");
	}

	// say_dagger2
	void OnSayDagger2()
	{
		SayText("I can fix that up for you, for a nominal fee, of course.");

		OpenMenu(CUR_PLAYER);
	}

	// not_enough_repair_dagger
	void OnNotEnoughRepairDagger()
	{
		SayText("You travellers have to learn somehow.");
	}

	// start_repair_dagger
	void OnStartRepairDagger(CBasePlayer@ player = null)
	{
		@REPAIR_QUEST_WINNER = player;

		FIXING_DAGGER = true;
		REPAIR_STEP = 0.0f;
		OnRepairDagger();
	}

	// repair_dagger
	void OnRepairDagger()
	{
		REPAIR_STEP += 1.0f;

		if (REPAIR_STEP == 1.0f)
		{
			PlayAnim("once", "portal");
			SayText("This'll be no trouble at all.");
		}
		if (REPAIR_STEP == 2.0f)
		{
			PlayAnim("once", "panic");
			SayText("*Crunch* Ow!");
		}
		if (REPAIR_STEP == 3.0f)
		{
			PlayAnim("once", "push_button");
			SayText("Sorry, I broke your dagger. Strange thing is, I think it cut me AFTER it shattered...");
			Offer(REPAIR_QUEST_WINNER, "smallarms_eth");
			FIXING_DAGGER = false;
		}

		if (!(REPAIR_STEP < 3.0f))
			return;
		CallEventDelayed(2.0f, "repair_dagger");
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
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseOldHelenaNpc_OnGameSpawn(playerRace, playerGender); // old_helena/base_old_helena_npc
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseOldHelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // old_helena/base_old_helena_npc
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	void OnCreatemystore() {} // createmystore
	void OnFlee() {} // flee

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/blacksmith.mdl");
		CallEventDelayed(1.5f, "Dorfgan_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Dorfgan_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseNpcVendorConfirm_FirstThink();
		BaseOldHelenaNpc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "addrandomitems") { OnAddrandomitems(); return true; }
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "catapults_fire") { OnCatapultsFire(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "not_enough_repair_dagger") { OnNotEnoughRepairDagger(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "old_helena_warboss_died") { OnOldHelenaWarbossDied(); return true; }
		if (name == "playerused") { OnPlayerused(); return true; }
		if (name == "repair_dagger") { OnRepairDagger(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "resetoffer") { OnResetoffer(); return true; }
		if (name == "say_dagger") { OnSayDagger(Param(params, 0)); return true; }
		if (name == "say_dagger2") { OnSayDagger2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2test") { OnSayHi2test(); return true; }
		if (name == "say_quest") { OnSayQuest(); return true; }
		if (name == "setsayso") { OnSetsayso(); return true; }
		if (name == "start_repair_dagger") { OnStartRepairDagger(PlayerParam(params, 0)); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Dorfgan_Timer") { Dorfgan_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseOldHelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
