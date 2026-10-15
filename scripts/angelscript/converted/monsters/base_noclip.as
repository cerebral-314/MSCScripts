#pragma context server

// Converted from monsters/base_noclip.script by msc_transpiler.
// For "ghostly" monsters

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_propelled.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNoclip
{
	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 1.0f;

	// unnamed block (first think)
	void BaseNoclip_FirstThink()
	{
		NPC_HACKED_MOVE_SPEED = 1.0f;
	}

	// game_spawn
	void BaseNoclip_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnBasenoclipFlight();
	}

	// basenoclip_flight
	void BaseNoclip_OnBasenoclipFlight()
	{
		CallEventDelayed(0.1f, "basenoclip_flight");

		Vector3 myOrg = MyOrigin() + RelativeVelocity(Vector3(0, FWD_SPEED, 0));
		SetOrigin(ENT_ME, myOrg);

		if (!Truthy(GetVar("IS_FLEEING")))
			SetMoveDest(NPC_NOCLIP_DEST, GetVar("ATTACK_MOVERANGE"));
		else
			SetMoveDest(NPC_NOCLIP_DEST, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseNoclip_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnBasenoclipFlight() { BaseNoclip_OnBasenoclipFlight(); } // basenoclip_flight

	// This file's events and timers by their .script names
	bool BaseNoclip_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basenoclip_flight") { OnBasenoclipFlight(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_noclip"]
shared class BaseNoclipScript : BasePropelledScript, BaseNoclip
{
	// Variables every script that includes this file declares
	float FWD_SPEED = 0.0f;
	Vector3 NPC_NOCLIP_DEST = Vector3();

	// Variables declared by included files, with the value they start with in this script
	BaseNoclipScript()
	{
		NPC_HACKED_MOVE_SPEED = 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNoclip_DispatchEvent(name, params)
			|| BasePropelledScript::DispatchEvent(name, params);
	}
}
