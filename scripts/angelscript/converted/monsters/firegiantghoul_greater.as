#pragma context server

// Converted from monsters/firegiantghoul_greater.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FiregiantghoulGreater
{
	// Constants
	int MY_MAX_HP = 4000;
	string MY_NAME = "Greater Undead Firegiant";
	int FIREBALL_DAMAGE = 100;
	string ATTACK_DAMAGE = "60";
	float THROW_CHANCE = 30.0f;
	int FIN_EXP = 400;

	// npc_spawn
	void FiregiantghoulGreater_OnNpcSpawn(string npc = "")
	{
		SetDamageTaken("cold", 1.25f);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Firegiantghoul_OnNpcSpawn(npc); // monsters/firegiantghoul
		FiregiantghoulGreater_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool FiregiantghoulGreater_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/firegiantghoul_greater"]
shared class FiregiantghoulGreaterScript : FiregiantghoulScript, FiregiantghoulGreater
{
	// Variables declared by included files, with the value they start with in this script
	FiregiantghoulGreaterScript()
	{
		MY_MAX_HP = 4000;
		MY_NAME = "Greater Undead Firegiant";
		FIREBALL_DAMAGE = 100;
		ATTACK_DAMAGE = "60";
		THROW_CHANCE = 30.0f;
		FIN_EXP = 400;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return FiregiantghoulGreater_DispatchEvent(name, params)
			|| FiregiantghoulScript::DispatchEvent(name, params);
	}
}
