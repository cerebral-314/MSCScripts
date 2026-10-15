#pragma context server

// Converted from chests/base_quiver_of.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseQuiverOf
{
	// Constants
	bool IS_QUIVER = true;

	// Variables (an unset .script variable reads as its own name)
	string NEW_NAME = "NEW_NAME";
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	bool BQ_CUSTOM = false;
	string BQ_QUIVER_TYPE = "BQ_QUIVER_TYPE";
	string BQ_BUNDLE_SIZE = "BQ_BUNDLE_SIZE";

	// game_spawn
	void BaseQuiverOf_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetInvincible(true);
		SetName("Quiver");
		SetWidth(20);
		SetHeight(30);
		SetModel("weapons/bows/quiver_floor.mdl");
		SetSolid("trigger");
		// callevent	treasure_spawn
		// callevent	createchest
		// setidleanim	ANIM_IDLE
		PlaySound(0, 10, "player/hitground2.wav");
	}

	// game_playerused
	// { createchest
	// local STORE_NUM $rand(1,1000)
	// local BASENAME QuiverNum
	// setvard STORENAME $stradd(STORE_NUM,BASENAME)
	// //dbg Storename STORENAME num STORE_NUM base BASENAME
	// createstore STORENAME
	// callevent chest_additems
	// }
	// { trade_success
	// //Need a squeak sound
	// volume		10
	// //playrandomsound	2	Items/backpack.wav
	// playanim		hold	ANIM_OPEN
	// }
	// { trade_done
	// //playanim	once	ANIM_CLOSE
	// callevent 1.0 fade_away
	// setidleanim	ANIM_IDLE
	// }
	// { game_playerused
	// offerstore	STORENAME	inv	trade
	// callevent	chest_used
	// }
	void BaseQuiverOf_OnGamePlayerused(CBasePlayer@ player = null)
	{
		bool isError = false;
		if (BQ_QUIVER_TYPE == "BQ_QUIVER_TYPE")
			isError = true;
		if (BQ_QUIVER_TYPE.isEmpty())
			isError = true;
		if (isError)
		{
			string outMsg = "Quiver type invalid or not set (" + BQ_QUIVER_TYPE + ")";
			InfoMessage(player, "QUIVER ERROR", outMsg);
		}
		Offer(player, BQ_QUIVER_TYPE, BQ_BUNDLE_SIZE);
		DeleteEntity(ENT_ME);
	}

	// fade_away
	void BaseQuiverOf_OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// game_dynamically_created
	void BaseQuiverOf_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (!creatorValue1.isEmpty())
			OnSetType(creatorValue1, creatorValue2);
		CallEventDelayed(30.0f, "fade_away");
	}

	// game_postspawn
	void BaseQuiverOf_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
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
	void BaseQuiverOf_OnRunAddparams()
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
	void BaseQuiverOf_OnNpcatkDoEvents()
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

	// set_type
	// <arrow_script> [number] - also works as addparam, but can't set amt (defaults to 30)
	void BaseQuiverOf_OnSetType(string arrowScript = "", string bundleSize = "")
	{
		BQ_CUSTOM = true;
		BQ_QUIVER_TYPE = arrowScript;
		if (!bundleSize.isEmpty())
			BQ_BUNDLE_SIZE = bundleSize;
		else
			BQ_BUNDLE_SIZE = "30";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseQuiverOf_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGamePlayerused(CBasePlayer@ player = null) { BaseQuiverOf_OnGamePlayerused(player); } // game_playerused
	void OnFadeAway() { BaseQuiverOf_OnFadeAway(); } // fade_away
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { BaseQuiverOf_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { BaseQuiverOf_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnRunAddparams() { BaseQuiverOf_OnRunAddparams(); } // run_addparams
	void OnNpcatkDoEvents() { BaseQuiverOf_OnNpcatkDoEvents(); } // npcatk_do_events
	void OnSetType(string arrowScript = "", string bundleSize = "") { BaseQuiverOf_OnSetType(arrowScript, bundleSize); } // set_type
	void OnEventName() {} // EVENT_NAME

	// This file's events and timers by their .script names
	bool BaseQuiverOf_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "run_addparams") { OnRunAddparams(); return true; }
		if (name == "set_type") { OnSetType(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/base_quiver_of"]
shared class BaseQuiverOfScript : ScriptEntity, BaseQuiverOf
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/quiver_floor.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseQuiverOf_DispatchEvent(name, params);
	}
}
