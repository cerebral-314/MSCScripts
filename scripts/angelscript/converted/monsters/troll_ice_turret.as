#pragma context server

// Converted from monsters/troll_ice_turret.script by msc_transpiler.
// same concept as monsters/spider_turret - thows stones, does not move

#include "runtime/ScriptEntity.as"
#include "converted/monsters/troll_ice_lobber.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TrollIceTurret
{
	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "idle0";
	string ANIM_RUN = "idle1";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";

	// unnamed block (first think)
	void TrollIceTurret_FirstThink()
	{
		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";
		NO_STUCK_CHECKS = "1"; // not stuck, I just don't move
	}

	// npc_spawn
	void TrollIceTurret_OnNpcSpawn(string npc = "")
	{
		SetRoam(false);
		SetMoveSpeed(0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
		TrollIceLobber_OnNpcSpawn(npc); // monsters/troll_ice_lobber
		TrollIceTurret_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool TrollIceTurret_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/troll_ice_turret"]
shared class TrollIceTurretScript : TrollIceLobberScript, TrollIceTurret
{
	// Variables declared by included files, with the value they start with in this script
	TrollIceTurretScript()
	{
		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollIceTurret_FirstThink();
		TrollIceLobber_FirstThink();
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
		return TrollIceTurret_DispatchEvent(name, params)
			|| TrollIceLobberScript::DispatchEvent(name, params);
	}
}
