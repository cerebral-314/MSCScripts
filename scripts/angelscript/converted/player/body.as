#pragma context server

// Converted from player/body.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "player/body"]
class Body : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("armor/p_armorvest.mdl");
		SetName("Player Body");
		SetWidth(32);
		SetHeight(72);
		SetModelBody(0, 1); // legs
		SetModelBody(1, 1); // head
		SetModelBody(2, 0); // torso (hide)
		SetModelBody(3, 1); // arms
		SetModelBody(4, 9); // armor
		SetRace("beloved");
		PLAYING_DEAD = "1";
		// setsolid none
		SetInvincible(true);
		SetProp(ENT_ME, "skin", 0);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		SetName(NameOf(MY_OWNER) + " body");
		CallEventDelayed(0.1f, "do_latch");
	}

	// do_latch
	void OnDoLatch()
	{
		Effect("beam", "update", ENT_ME, "start_target", MY_OWNER, 0);
		Effect("beam", "update", ENT_ME, "end_target", MY_OWNER, 0);
		SetProp(MY_OWNER, "rendermode", 5);
		SetProp(MY_OWNER, "renderamt", 0);
	}

	// ext_bodyparts
	// <legs> <head> <torso> <arms> <armor>
	void OnExtBodyparts(int legs = 0, int head = 0, int torso = 0, int arms = 0, int armor = 0)
	{
		SetModelBody(0, legs);
		SetModelBody(1, head);
		SetModelBody(2, torso);
		SetModelBody(3, arms);
		SetModelBody(4, armor);
	}

	// ext_skin
	// <legs>
	void OnExtSkin(string legs = "")
	{
		SetProp(ENT_ME, "skin", legs);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("armor/p_armorvest.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_latch") { OnDoLatch(); return true; }
		if (name == "ext_bodyparts") { OnExtBodyparts(Int(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2)), Int(Param(params, 3)), Int(Param(params, 4))); return true; }
		if (name == "ext_skin") { OnExtSkin(Param(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
