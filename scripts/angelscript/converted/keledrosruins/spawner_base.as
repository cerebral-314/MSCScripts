#pragma context server

// Converted from keledrosruins/spawner_base.script by msc_transpiler.
// Thothie - I percieve anything else in the Keledros script that would cause brain death
// - It seems very likely that the createNPC meathod does not clean out memory the same way a standard msmonster_spawn does
// - As such, I'm removing 3 spawners, and replacing with "greater animated warriors" and seeing if it helps various issues
// - Also adding new scrolls to Keledros when I get them (and him) working right
// - Also note on this: original was EXIST < 5 - meaning he could spawn more than 6 armors, so the last one survived long enough for him to summon again. (sure I've seen this happen since January)
// - Keledros now decides for himself if he can spawn more guards or not - this is kept for compatibility

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpawnerBase
{
	// Variables (an unset .script variable reads as its own name)
	float EXIST = 0.0f;

	// unnamed block (first think)
	void SpawnerBase_FirstThink()
	{
		EXIST = 0.0f;
	}

	// make_undead
	void SpawnerBase_OnMakeUndead()
	{
		Vector3 origin = Vec("origin");

		if (!(EXIST < 3.0f))
			return;
		string sky = Text(origin);
		sky = Text(Vec(sky) + Vector3(0, 0, 4096));
		origin = Vec(GetProp(ENT_ME, Text(origin)));

		// clientevent new all_in_sight effects/sfx_lightning origin l.sky 1 1
		EXIST += 1.0f;

		// debugprint added: EXIST
		OnSpawnUndead();
	}

	// undead_died
	void SpawnerBase_OnUndeadDied()
	{
		EXIST -= 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMakeUndead() { SpawnerBase_OnMakeUndead(); } // make_undead
	void OnUndeadDied() { SpawnerBase_OnUndeadDied(); } // undead_died
	void OnSpawnUndead() {} // spawn_undead

	// This file's events and timers by their .script names
	bool SpawnerBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "make_undead") { OnMakeUndead(); return true; }
		if (name == "undead_died") { OnUndeadDied(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "keledrosruins/spawner_base"]
shared class SpawnerBaseScript : ScriptEntity, SpawnerBase
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpawnerBase_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SpawnerBase_DispatchEvent(name, params);
	}
}
