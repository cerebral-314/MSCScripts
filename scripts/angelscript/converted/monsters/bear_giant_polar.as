#pragma context server

// Converted from monsters/bear_giant_polar.script by msc_transpiler.
// Thothie - Model didn't seem to set skin, so attempted adjustment through setmodel
// Giant Polar Bear

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base_giant.as"
#include "converted/monsters/base_ice_race.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearGiantPolar
{
	// Constants
	string ATTACK_NORMAL_DAMAGE = "$rand(40,80)";
	string ATTACK_STANDING_DAMAGE = "$rand(40,58)";
	int ATTACK_STOMPRANGE = 200;
	int ATTACK_STOMPDMG = 50;
	string ATTACK_HITCHANCE = "70%";
	string NPC_BASE_EXP = "200";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void BearGiantPolar_FirstThink()
	{
		ANIM_IDLE = "idle"; // This is a workaround
		ANIM_WALK = "walk"; // because I use these as variables
		ANIM_RUN = "run"; // while bear_base uses them as
		ANIM_ATTACK = "attack"; // consts
	}

	// npc_spawn
	void BearGiantPolar_OnNpcSpawn(string npc = "")
	{
		SetHealth(1600);
		// ov 165
		SetName("Giant Polar bear");
		SetDamageTaken("cold", 0);

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
		BearBaseGiant_OnNpcSpawn(npc); // monsters/bear_base_giant
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
		BearGiantPolar_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool BearGiantPolar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_giant_polar"]
shared class BearGiantPolarScript : BearBaseGiantScript, BearGiantPolar, BaseIceRace
{
	// Variables declared by included files, with the value they start with in this script
	BearGiantPolarScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_NORMAL_DAMAGE = "$rand(40,80)";
		ATTACK_STANDING_DAMAGE = "$rand(40,58)";
		ATTACK_STOMPRANGE = 200;
		ATTACK_STOMPDMG = 50;
		ATTACK_HITCHANCE = "70%";
		NPC_BASE_EXP = "200";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGiantPolar_FirstThink();
		BearBaseGiant_FirstThink();
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
		return BearGiantPolar_DispatchEvent(name, params)
			|| BaseIceRace_DispatchEvent(name, params)
			|| BearBaseGiantScript::DispatchEvent(name, params);
	}
}
