#pragma context server

// Converted from monsters/snowboar1.script by msc_transpiler.
// Standard Boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar.as"
#include "converted/monsters/base_ice_race.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Snowboar1
{
	// Constants
	int FLEE_HEALTH = 10;
	string FLEE_CHANCE = "25%";
	string NPC_BASE_EXP = "12";
	float GORE_FORWARD_DAMAGE = 1.0f;
	string GORE_SIDE_DAMAGE = "0.7";
	bool BOAR_CAN_CHARGE = false;

	// Variables (an unset .script variable reads as its own name)
	string CAN_FLEE = "CAN_FLEE";
	string PUSH_VEL = "PUSH_VEL";

	// unnamed block (first think)
	void Snowboar1_FirstThink()
	{
		CAN_FLEE = "1"; // base_npc_attack - Whether I run away at low health (changes for boar)
	}

	// npc_spawn
	void Snowboar1_OnNpcSpawn(string npc = "")
	{
		SetHealth(30);
		SetName("Snow Boar");
		SetHearingSensitivity(0);
		SetModel("monsters/boar1.mdl");
		SetProp(ENT_ME, "skin", 3);
	}

	// gore_forward
	// Deal damage
	void Snowboar1_OnGoreForward()
	{
		PUSH_VEL = Text(Vector3(0, 0, 0));
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_FORWARD_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_left
	// Deal side damage
	void Snowboar1_OnGoreLeft()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(100, 50, 10)));
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_right
	void Snowboar1_OnGoreRight()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, 50, 10)));
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
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
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
		Snowboar1_OnNpcSpawn(npc);
	}

	// gore_forward
	void OnGoreForward()
	{
		BoarBase_OnGoreForward(); // monsters/boar_base
		Boar_OnGoreForward(); // monsters/boar
		Snowboar1_OnGoreForward();
	}

	// gore_left
	void OnGoreLeft()
	{
		Boar_OnGoreLeft(); // monsters/boar
		Snowboar1_OnGoreLeft();
	}

	// gore_right
	void OnGoreRight()
	{
		Boar_OnGoreRight(); // monsters/boar
		Snowboar1_OnGoreRight();
	}

	// This file's events and timers by their .script names
	bool Snowboar1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "gore_forward") { OnGoreForward(); return true; }
		if (name == "gore_left") { OnGoreLeft(); return true; }
		if (name == "gore_right") { OnGoreRight(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/snowboar1"]
shared class Snowboar1Script : BoarScript, Snowboar1, BaseIceRace
{
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
		Snowboar1_FirstThink();
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
		return Snowboar1_DispatchEvent(name, params)
			|| BaseIceRace_DispatchEvent(name, params)
			|| BoarScript::DispatchEvent(name, params);
	}
}
