#pragma context server

// Converted from chests/bag_o_gold_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BagOGoldBase
{
	// Constants
	string ANIM_OPEN = "idle";
	string ANIM_CLOSE = "idle";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string GOLD_AMT = "GOLD_AMT";
	bool WAS_USED = false;
	string NEW_NAME = "NEW_NAME";
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";

	// unnamed block (first think)
	void BagOGoldBase_FirstThink()
	{
		ANIM_IDLE = "idle";
	}

	// game_dynamically_created
	void BagOGoldBase_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		CallEventDelayed(90.0f, "fade_away"); // tends to spawn off map
		if (creatorValue1.isEmpty())
			return;
		GOLD_AMT = creatorValue1;
	}

	// game_spawn
	void BagOGoldBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Bag of Gold");
		SetModel("misc/treasure.mdl"); // %& MERGE WITH NEW MODEL
		SetModelBody(0, 3);
		SetSolid("none");

		SetHealth(1);
		SetInvincible(true);
		SetWidth(20);
		SetHeight(30);
		SetIdleAnim(ANIM_IDLE);
		PlaySound(0, 10, "misc/gold.wav");

		Effect("glow", ENT_ME, Vector3(230, 210, 80), 64, 3, 3);
	}

	// game_playerused
	void BagOGoldBase_OnGamePlayerused(CBasePlayer@ player = null)
	{
		if (WAS_USED)
			return;
		WAS_USED = true;
		CallExternal(player, "ext_addgold", GOLD_AMT);
		PlaySound(0, 10, "misc/gold.wav", 0.8f, Random(80, 120));
		OnRemoveMe();
	}

	// remove_me
	void BagOGoldBase_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_postspawn
	void BagOGoldBase_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		bool exitSub = false;
		NEW_NAME = title;
		if (NEW_NAME != "default")
			SetName(NEW_NAME);
		if (params.isEmpty())
			exitSub = true;
		if (exitSub)
			return;
		NPC_DO_EVENTS = params;
		CallEventDelayed(0.01f, "run_addparams");
	}

	// run_addparams
	void BagOGoldBase_OnRunAddparams()
	{
		int count = GetTokenCount(NPC_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkDoEvents();
		}
	}

	// npcatk_do_events
	// run param events
	void BagOGoldBase_OnNpcatkDoEvents()
	{
		string nextEvent = "NEXT_EVENT";
		float nEvent = loopIteration;
		string eventName = GetToken(NPC_DO_EVENTS, int(nEvent));
		nEvent += 1.0f;
		if (nEvent <= GetTokenCount(NPC_DO_EVENTS))
			nextEvent = GetToken(NPC_DO_EVENTS, int(nEvent));
		DebugPrint("doing token event " + eventName);
		CallEventOrDelay(eventName, nextEvent);
	}

	// fade_away
	// { [server] createchest
	// gold GOLD_AMT
	// local STORE_NUM $rand(1,1000)
	// local BASENAME QuiverNum
	// setvard STORENAME $stradd(STORE_NUM,BASENAME)
	// //dbg Storename STORENAME num STORE_NUM base BASENAME
	// createstore STORENAME
	// //callevent chest_additems
	// }
	// { [server] trade_success
	// setvard DID_TRADE 1
	// playrandomsound 0 10 misc/gold.wav
	// setvar CANCHAT 0
	// playanim  open
	// setidleanim ANIM_IDLE
	// }
	// { [server] trade_done
	// //playanim	once	ANIM_CLOSE
	// if !BAG_NO_DELETE
	// callevent 1.0 fade_away
	// setidleanim	ANIM_IDLE
	// }
	// { [server] game_playerused
	// if ( DID_TRADE ) local EXIT_SUB 1
	// if ( BAG_MULTI_OPEN ) local EXIT_SUB 0
	// if !EXIT_SUB
	// offerstore	STORENAME PARAM1 inv	trade
	// }
	void BagOGoldBase_OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { BagOGoldBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BagOGoldBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGamePlayerused(CBasePlayer@ player = null) { BagOGoldBase_OnGamePlayerused(player); } // game_playerused
	void OnRemoveMe(string caller = "") { BagOGoldBase_OnRemoveMe(caller); } // remove_me
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { BagOGoldBase_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnRunAddparams() { BagOGoldBase_OnRunAddparams(); } // run_addparams
	void OnNpcatkDoEvents() { BagOGoldBase_OnNpcatkDoEvents(); } // npcatk_do_events
	void OnFadeAway() { BagOGoldBase_OnFadeAway(); } // fade_away
	void OnEventName() {} // EVENT_NAME

	// This file's events and timers by their .script names
	bool BagOGoldBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "run_addparams") { OnRunAddparams(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/bag_o_gold_base"]
shared class BagOGoldBaseScript : ScriptEntity, BagOGoldBase
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/treasure.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BagOGoldBase_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BagOGoldBase_DispatchEvent(name, params);
	}
}
