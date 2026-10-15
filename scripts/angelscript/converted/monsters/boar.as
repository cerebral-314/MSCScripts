#pragma context server

// Converted from monsters/boar.script by msc_transpiler.
// Standard Boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Boar
{
	// Constants
	int FLEE_HEALTH = 10;
	string FLEE_CHANCE = "25%";
	float GORE_FORWARD_DAMAGE = 1.0f;
	string GORE_SIDE_DAMAGE = "0.7";
	bool BOAR_CAN_CHARGE = false;

	// Variables (an unset .script variable reads as its own name)
	string CAN_FLEE = "CAN_FLEE";
	float NPC_GIVE_EXP = 0.0f;
	string PUSH_VEL = "PUSH_VEL";

	// unnamed block (first think)
	void Boar_FirstThink()
	{
		CAN_FLEE = "1"; // base_npc_attack - Whether I run away at low health (changes for boar)

		NPC_GIVE_EXP = 6.0f;
	}

	// npc_spawn
	void Boar_OnNpcSpawn(string npc = "")
	{
		SetHealth(20);
		SetName("Wild Boar");
		SetHearingSensitivity(0);
	}

	// gore_forward
	// Deal damage
	void Boar_OnGoreForward()
	{
		PUSH_VEL = Text(Vector3(0, 0, 0));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, GORE_FORWARD_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_left
	// Deal side damage
	void Boar_OnGoreLeft()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(100, 50, 10)));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
	}

	// gore_right
	void Boar_OnGoreRight()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, 50, 10)));
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, GORE_SIDE_DAMAGE, ATTACK_HITCHANCE);
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
		Boar_OnNpcSpawn(npc);
	}

	// gore_forward
	void OnGoreForward()
	{
		BoarBase_OnGoreForward(); // monsters/boar_base
		Boar_OnGoreForward();
	}

	void OnGoreLeft() { Boar_OnGoreLeft(); } // gore_left
	void OnGoreRight() { Boar_OnGoreRight(); } // gore_right

	// This file's events and timers by their .script names
	bool Boar_DispatchEvent(const string &in name, const array<string> &in params)
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
[script "monsters/boar"]
shared class BoarScript : BoarBaseScript, Boar
{
	// Variables declared by included files, with the value they start with in this script
	BoarScript()
	{
		FLEE_HEALTH = 10;
		FLEE_CHANCE = "25%";
		GORE_FORWARD_DAMAGE = 1.0f;
		GORE_SIDE_DAMAGE = "0.7";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return Boar_DispatchEvent(name, params)
			|| BoarBaseScript::DispatchEvent(name, params);
	}
}
