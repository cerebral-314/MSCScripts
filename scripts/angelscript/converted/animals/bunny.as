#pragma context server

// Converted from animals/bunny.script by msc_transpiler.
// *** Bunny ***
// Spawn properties

#include "runtime/ScriptEntity.as"

[script "animals/bunny"]
class Bunny : ScriptEntity
{
	// unnamed block (timer)
	void Bunny_Timer()
	{
		CallEventDelayed(4.0f, "Bunny_Timer");
		PlayAnim("once", "hop");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(20);
		SetGold(0);
		SetWidth(0);
		SetHeight(0);
		SetRace("neutral");
		SetName("Bunny");
		SetRoam(true); // Roam freely
		SetModel("animals/bunny.mdl");
		SetIdleAnim("idle");
		SetInvincible(true);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("animals/bunny.mdl");
		CallEventDelayed(4.0f, "Bunny_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "Bunny_Timer") { Bunny_Timer(); return true; }
		return false;
	}
}
