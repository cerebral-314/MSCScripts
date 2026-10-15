#pragma context server

// Converted from animals/bats.script by msc_transpiler.
// *** Bats ***
// Spawn properties

#include "runtime/ScriptEntity.as"

[script "animals/bats"]
class Bats : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string SOUND_IDLE1 = "monsters/bats/bats.wav";

	// unnamed block (timer)
	// Idle sounds
	void Bats_Timer()
	{
		CallEventDelayed(8.0f, "Bats_Timer");

		PlaySound(0, 10, SOUND_IDLE1);
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(20);
		SetGold(0);
		SetWidth(0);
		SetHeight(0);
		SetRace("neutral");
		SetName("Bats");
		SetRoam(true);
		SetFly(true);
		SetModel("animals/bats.mdl");
		SetIdleAnim("flappin");
		SOUND_IDLE1 = "monsters/bats/bats.wav";
		SetInvincible(true);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("animals/bats.mdl");
		CallEventDelayed(8.0f, "Bats_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "Bats_Timer") { Bats_Timer(); return true; }
		return false;
	}
}
