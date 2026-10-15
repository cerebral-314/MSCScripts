#pragma context server

// Converted from monsters/boar_hard.script by msc_transpiler.
// A tough boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersBoarHard
{
	// Constants
	float GORE_FORWARD_DAMAGE = 2.0f;
	string GORE_SIDE_DAMAGE = "1.2";
	bool BOAR_CAN_CHARGE = true;
	string BOAR_CHARGE_DMG = "4";
	string FLEE_CHANCE = "10%";
	bool IS_HARD = true;
	string NPC_BASE_EXP = "9";

	// Variables (an unset .script variable reads as its own name)
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_HEAR = "CAN_HEAR";

	// unnamed block (first think)
	void MonstersBoarHard_FirstThink()
	{
		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_HEAR = "1"; // base_npc_attack - Whether I can hear enemies (changes for boar)
	}

	// npc_spawn
	void MonstersBoarHard_OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		SetName("Ferocious Wild Boar");
		SetHearingSensitivity(2);
		SetModel("monsters/boar1.mdl");

		if (ToLowerCase(MapName()) == "nightmare_thornlands")
			SetMonsterClip(false);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar
		MonstersBoarHard_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool MonstersBoarHard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/boar_hard"]
shared class MonstersBoarHardScript : BoarScript, MonstersBoarHard
{
	// Variables declared by included files, with the value they start with in this script
	MonstersBoarHardScript()
	{
		GORE_FORWARD_DAMAGE = 2.0f;
		GORE_SIDE_DAMAGE = "1.2";
		BOAR_CAN_CHARGE = true;
		FLEE_CHANCE = "10%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar.mdl");
		Precache("monsters/boar1.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "BoarBase_Timer");
		CallEventDelayed(Float(Eval("$rand(8,12)")), "BoarBase_Timer2");
		CallEventDelayed(0.1f, "BoarBase_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersBoarHard_FirstThink();
		Boar_FirstThink();
		BoarBase_FirstThink();
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
		return MonstersBoarHard_DispatchEvent(name, params)
			|| BoarScript::DispatchEvent(name, params);
	}
}
