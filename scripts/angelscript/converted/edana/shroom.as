#pragma context server

// Converted from edana/shroom.script by msc_transpiler.
// Thothie - supplied for backwards compatability with MS1.35
// - This was sometimes used as a monster lure in old maps - orcs, trolls, and undead will attack
// - Interesting trick, if you put it inside a func_illusionary and delete it via delay
// - Maybe more useful with no model, however

#include "runtime/ScriptEntity.as"

[script "edana/shroom"]
class Shroom : ScriptEntity
{
	// spawn
	void OnSpawn()
	{
		SetHealth(9999);
		SetRace("human");
		SetWidth(50);
		SetHeight(50);
		SetRoam(false);
		SetName("Shroom");
		SetIdleAnim("idle");
		SetModel("misc/env_shroom4.mdl");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/env_shroom4.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn") { OnSpawn(); return true; }
		return false;
	}
}
