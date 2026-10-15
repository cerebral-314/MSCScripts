#pragma context server

// Converted from items/proj_arrow_npc.script by msc_transpiler.
// NPC's arrows

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ProjArrowNpc
{
	// Constants
	int ARROW_BODY_OFS = 0;
	string PROJ_DAMAGE = "PROJ_DAMAGE";
	int ARROW_EXPIRE_DELAY = 5;
	int ARROW_STICK_DURATION = 10;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "10%";

	// arrow_spawn
	void ProjArrowNpc_OnArrowSpawn()
	{
		SetName("Blunt Wooden Arrow");
		SetDescription("It's more like a sharpened stick than an arrow");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.6f);
		SetGroupable(25);
		LegacyCommand("useable", 0); // Can't be picked up
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnArrowSpawn() { ProjArrowNpc_OnArrowSpawn(); } // arrow_spawn

	// This file's events and timers by their .script names
	bool ProjArrowNpc_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/proj_arrow_npc"]
shared class ProjArrowNpcScript : ProjArrowBaseScript, ProjArrowNpc
{
	// Variables declared by included files, with the value they start with in this script
	ProjArrowNpcScript()
	{
		ARROW_EXPIRE_DELAY = 5;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ProjArrowNpc_DispatchEvent(name, params)
			|| ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
