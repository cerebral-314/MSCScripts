#pragma context server

// Converted from monsters/gbear_brown_lpoly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/gbear_polar.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GbearBrownLpoly
{
	// Constants
	string NPC_BASE_EXP = "350";
	string MONSTER_MODEL = "monsters/gbear_lpoly.mdl";
	bool NO_BREATH_ATTACK = true;
	bool NO_FROSTY_BREATH = true;

	// npc_spawn
	void GbearBrownLpoly_OnNpcSpawn(string npc = "")
	{
		SetName("Greater Brownbear");
		SetDamageTaken("cold", 0.75f);
		SetDamageTaken("fire", 0.75f);
		SetHealth(2000);
		SetProp(ENT_ME, "skin", 2);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		GbearPolar_OnNpcSpawn(npc); // monsters/gbear_polar
		GbearBrownLpoly_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool GbearBrownLpoly_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/gbear_brown_lpoly"]
shared class GbearBrownLpolyScript : GbearPolarScript, GbearBrownLpoly
{
	// Variables declared by included files, with the value they start with in this script
	GbearBrownLpolyScript()
	{
		NPC_BASE_EXP = "350";
		MONSTER_MODEL = "monsters/gbear_lpoly.mdl";
		NO_BREATH_ATTACK = true;
		NO_FROSTY_BREATH = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gbear_lpoly.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GbearBrownLpoly_DispatchEvent(name, params)
			|| GbearPolarScript::DispatchEvent(name, params);
	}
}
