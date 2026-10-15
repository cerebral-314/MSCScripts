#pragma context server

// Converted from other/rock.script by msc_transpiler.
// Thothie - script had wrong setidleanim ("idle1") - in model is "seq-name"
// - Collision box too small, this thing would be used to block your path
// - Attempting to make vanish/break instead of fade away when broken

#include "runtime/ScriptEntity.as"

[script "other/rock"]
class OtherRock : ScriptEntity
{
	// spawn
	void OnSpawn()
	{
		SetHealth(150);
		SetWidth(128);
		SetHeight(64);
		SetRoam(false);
		SetRace("nothing"); // less likely to be an attack target
		SetName("large rock");
		SetBlood("none");
		SetIdleAnim("seq-name");
		SetModel("props/rock1.mdl");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		Effect("tempent", "gibs", "rockgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, RelativeVelocity(Vector3(0, 0, 10)), 20, 10, 1);
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000)); // no death sequence, teleport away, leave rock gibs behind
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return false;
	}
}
