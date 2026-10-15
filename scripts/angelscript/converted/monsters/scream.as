#pragma context server

// Converted from monsters/scream.script by msc_transpiler.
// Thothie - supplied for backwards compatability with MS1.35
// -TBH: I've no idea what this did in 1.35 - so, now it just spawns a rock
// -to prevent server crash on maps using it. (I think it's supposed to make spooky sounds, er somethin)
// -Currently I'm using it to verify my SC.DLL updated after map change (Hence the name)

#include "runtime/ScriptEntity.as"

[script "monsters/scream"]
class Scream : ScriptEntity
{
	// spawn
	void OnSpawn()
	{
		SetHealth(150);
		SetWidth(50);
		SetHeight(50);
		SetRoam(false);
		SetName("PlaceHolder [Test Minions]");
		SetIdleAnim("seq-name");
		SetModel("props/rock1.mdl");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/rock1.mdl");
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
