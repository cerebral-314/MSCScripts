#pragma context server

// Converted from other/qitem.script by msc_transpiler.
// Special dynamic quest items, pick up when touched
// - Quest items without cluttering player inventory.
// - These track, but don't save (save function via quest data pending)
// current qitem codes:
// ap - "Golden Apple"
// bs - "Bag of Salt"
// bp - "Bag of Pepper"
// bm - "Barrel of Mead"
// la - "Sylphiel's Ladel"
// tnt - "a stick of|Dwarven Explosives"
// gen1 - "Package of Something" //(these use the generic item package model)
// gen2 - "Package of Something" //(name intended to be changed via second createdyn param or title property)
// gen3 - "Package of Something"
// gen3 - "Package of Something"

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Qitem
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 GLOW_COLOR = Vector3();
	string PLAYING_DEAD = "PLAYING_DEAD";
	float NEXT_TOUCH = 0.0f;
	string QUEST_PLAYER = "QUEST_PLAYER";
	bool IS_ACTIVE = false;
	string ITEM_TYPE = "ITEM_TYPE";
	string TNT_MODEL = "TNT_MODEL";
	float SLOW_COUNT = 0.0f;
	bool AM_SUMMONED = false;

	// unnamed block (first think)
	void Qitem_FirstThink()
	{
		GLOW_COLOR = Vector3(255, 200, 0);
		SetCallback("touch", "enable");
	}

	// game_spawn
	void Qitem_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("misc/sylphiels_stuff.mdl");
		SetWidth(16);
		SetHeight(16);
		SetSolid("trigger");
		SetInvincible(true);
		SetNoPush(true);
		PLAYING_DEAD = "1"; // not a valid target
		CallEventDelayed(1.0f, "glow_loop");
	}

	// glow_loop
	void Qitem_OnGlowLoop()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(10.0f, "glow_loop");
		Effect("glow", ENT_ME, GLOW_COLOR, 16.0f, 9.0f, -1);
	}

	// game_touch
	string Qitem_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!IS_ACTIVE)
			return result;
		if (!(GameTime() > NEXT_TOUCH))
			return result;
		NEXT_TOUCH = GameTime() + 1.0f;

		if (!IsPlayer(other))
			return result;
		QUEST_PLAYER = EntityId(other);
		OnFoundItem();
		return result;
	}

	// found_item
	void Qitem_OnFoundItem()
	{
		if (!IS_ACTIVE)
			return;
		IS_ACTIVE = false;
		PlaySound(0, 10, "items/ammopickup1.wav");
		string outMsg = "You find " + FullNameOf(ENT_ME);
		PlayerMessageGreen(QUEST_PLAYER, "You acquire  " + FullNameOf(ENT_ME));
		InfoMessage("all", "QUEST ITEM FOUND", outMsg);
		HelpTip(QUEST_PLAYER, "questitem", "QUEST ITEM", "This is a special quest item that will not appear in your inventory.");
		CallExternal(GetVar("GAME_MASTER"), "ext_got_quest_item", ITEM_TYPE);
		CallEventDelayed(0.5f, "remove_me");
	}

	// remove_me
	void Qitem_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void Qitem_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		string param = ToLowerCase(GetToken(params, 0));
		if (param != "none")
			OnSetItemType(param);
	}

	// set_item_type
	void Qitem_OnSetItemType(string itemType = "")
	{
		bool didInit = false;

		IS_ACTIVE = true;
		ITEM_TYPE = itemType;
		if (ITEM_TYPE == "ap")
		{
			SetName("Golden Apple");
			SetModelBody(0, 0);
			didInit = true;
		}

		if (ITEM_TYPE == "bs")
		{
			SetName("Bag of Salt");
			SetModelBody(0, 1);
			didInit = true;
		}

		if (ITEM_TYPE == "bp")
		{
			SetName("Bag of Pepper");
			SetModelBody(0, 2);
			didInit = true;
		}

		if (ITEM_TYPE == "km")
		{
			SetName("Barrel of Mead");
			SetModelBody(0, 3);
			didInit = true;
		}

		if (ITEM_TYPE == "la")
		{
			SetName("Sylphiel's Ladel");
			SetModelBody(0, 4);
			didInit = true;
		}

		if (ITEM_TYPE == "tnt")
		{
			SetName("a stick of|Dwarven Explosives");
			GLOW_COLOR = Vector3(0, 255, 0);
			SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));
			TNT_MODEL = "monsters/dwarf_bomber_tnt.mdl"; // be sure you precach this, if creating tnt
			SLOW_COUNT = 0.0f;
			CallEventDelayed(0.1f, "slow_down_loop");
			SetModel(TNT_MODEL);
			didInit = true;
			SetMonsterClip(false);
		}

		if (didInit)
			return;

		string outMsg = "m2_quest/sylphiels_stuff cannot find type: " + ITEM_TYPE;
		InfoMessage("all", "MAPPING ERROR", outMsg);
	}

	// slow_down_loop
	void Qitem_OnSlowDownLoop()
	{
		Vector3 curVel = Scale(VelocityOf(ENT_ME), Vector3(0.5f, 0.5f, 0.5f));
		SLOW_COUNT += 1.0f;
		if (SLOW_COUNT >= 20.0f)
			curVel = Vector3(0, 0, 0);
		SetVelocity(ENT_ME, curVel);
		if (Text(curVel) == Text(Vector3(0, 0, 0)))
			return;
		CallEventDelayed(0.5f, "slow_down_loop");
	}

	// game_dynamically_created
	// <type> [name]
	void Qitem_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		AM_SUMMONED = true;
		OnSetItemType(ToLowerCase(creatorValue1));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { Qitem_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGlowLoop() { Qitem_OnGlowLoop(); } // glow_loop
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return Qitem_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnFoundItem() { Qitem_OnFoundItem(); } // found_item
	void OnRemoveMe(string caller = "") { Qitem_OnRemoveMe(caller); } // remove_me
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { Qitem_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnSetItemType(string itemType = "") { Qitem_OnSetItemType(itemType); } // set_item_type
	void OnSlowDownLoop() { Qitem_OnSlowDownLoop(); } // slow_down_loop
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { Qitem_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created

	// This file's events and timers by their .script names
	bool Qitem_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "found_item") { OnFoundItem(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "glow_loop") { OnGlowLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "set_item_type") { OnSetItemType(Param(params, 0)); return true; }
		if (name == "slow_down_loop") { OnSlowDownLoop(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/qitem"]
shared class QitemScript : DebugScript, Qitem
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/sylphiels_stuff.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Qitem_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Qitem_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
