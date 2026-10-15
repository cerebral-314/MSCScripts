#pragma context server

// Converted from monsters/bear_cub_polar.script by msc_transpiler.
// Thothie - once again, to keep game compatible (no need to dump all custom maps with every update)
// Same as blackbearcub, cept white
// Standard Black Bear Cub

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base.as"
#include "converted/monsters/base_ice_race.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearCubPolar
{
	// Constants
	string ATTACK_DAMAGE = "$rand(5,8)";
	string ATTACK_HITCHANCE = "60%";
	string NPC_BASE_EXP = "20";

	// Variables (an unset .script variable reads as its own name)
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";

	// unnamed block (first think)
	void BearCubPolar_FirstThink()
	{
		MOVE_RANGE = "60";
		ATTACK_RANGE = 70.0f;
		ATTACK_HITRANGE = 120.0f;

		DROP_ITEM1 = "skin_bear"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "50%"; // base_monster - Chance of item drop #1
	}

	// npc_spawn
	void BearCubPolar_OnNpcSpawn(string npc = "")
	{
		SetHealth(80);
		// ov 120
		SetWidth(40);
		SetHeight(80);
		SetName("Polar Bear Cub");
		SetHearingSensitivity(2);
		SetDamageTaken("cold", 0);

		SetModel("monsters/bearcub.mdl");
		SetModelBody(0, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
		BearCubPolar_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool BearCubPolar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_cub_polar"]
shared class BearCubPolarScript : BearBaseScript, BearCubPolar, BaseIceRace
{
	// Variables declared by included files, with the value they start with in this script
	BearCubPolarScript()
	{
		ATTACK_DAMAGE = "$rand(5,8)";
		ATTACK_HITCHANCE = "60%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bearcub.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearCubPolar_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BearCubPolar_DispatchEvent(name, params)
			|| BaseIceRace_DispatchEvent(name, params)
			|| BearBaseScript::DispatchEvent(name, params);
	}
}
