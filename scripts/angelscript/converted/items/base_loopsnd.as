#pragma context server

// Converted from items/base_loopsnd.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseLoopsnd
{
	// Constants
	string LOOPSND_NAME = "none";
	int LOOPSND_LENGTH = 5;
	float LOOPSND_VOLUME = 0.0f;
	string LOOPSND_CHANNEL = "const.sound.item";

	// Variables (an unset .script variable reads as its own name)
	bool LOOPSND_ON = false;

	// game_spawn
	// Init with sound off
	void BaseLoopsnd_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		LOOPSND_ON = false;
	}

	// loopsnd_start
	// Start playing/looping sound
	void BaseLoopsnd_OnLoopsndStart()
	{
		LOOPSND_ON = true;
		OnLoopsnd();
	}

	// loopsnd_end
	// Stop
	void BaseLoopsnd_OnLoopsndEnd()
	{
		LOOPSND_ON = false;
		ServerPlaySound(Int(LOOPSND_CHANNEL), 0);
	}

	// loopsnd
	void BaseLoopsnd_OnLoopsnd()
	{
		if (!LOOPSND_ON)
			return;

		ServerPlaySound(Int(LOOPSND_CHANNEL), LOOPSND_VOLUME, LOOPSND_NAME);
		CallEventDelayed(LOOPSND_LENGTH, "loopsnd");
	}

	// game_putinpack
	void BaseLoopsnd_OnGamePutinpack()
	{
		OnLoopsndEnd();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseLoopsnd_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnLoopsndStart() { BaseLoopsnd_OnLoopsndStart(); } // loopsnd_start
	void OnLoopsndEnd() { BaseLoopsnd_OnLoopsndEnd(); } // loopsnd_end
	void OnLoopsnd() { BaseLoopsnd_OnLoopsnd(); } // loopsnd
	void OnGamePutinpack() { BaseLoopsnd_OnGamePutinpack(); } // game_putinpack
	void OnLoopsndLength() {} // LOOPSND_LENGTH

	// This file's events and timers by their .script names
	bool BaseLoopsnd_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "loopsnd") { OnLoopsnd(); return true; }
		if (name == "loopsnd_end") { OnLoopsndEnd(); return true; }
		if (name == "loopsnd_start") { OnLoopsndStart(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_loopsnd"]
shared class BaseLoopsndScript : ScriptEntity, BaseLoopsnd
{
	// Variables every script that includes this file declares
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_WORLD = "MODEL_WORLD";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseLoopsnd_DispatchEvent(name, params);
	}
}
