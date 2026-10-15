#pragma context server

// Converted from calruin/cavetroll2.script by msc_transpiler.
// Cave Troll in the Calrian Ruins

#include "runtime/ScriptEntity.as"
#include "converted/monsters/troll.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Cavetroll2
{
	// Constants
	string NPC_BASE_EXP = "200";

	// Variables (an unset .script variable reads as its own name)
	int ATTACK1_RANGE = 210;
	int ATTACK2_RANGE = 160;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float ATTACK_RANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float NPC_GIVE_EXP = 0.0f;
	string PUSH_VEL = "PUSH_VEL";

	// unnamed block (first think)
	void Cavetroll2_FirstThink()
	{
		DROP_GOLD_MIN = 50;
		DROP_GOLD_MAX = 85;
		ATTACK_RANGE = 130.0f;
		ATTACK1_RANGE = 210;
		ATTACK2_RANGE = 160;
		MOVE_RANGE = "130";
		NPC_GIVE_EXP = 200.0f;
	}

	// troll_spawn
	void Cavetroll2_OnTrollSpawn()
	{
		SetHealth(800);
		SetName("Hideous Cave Troll");
		SetRoam(false);
		SetHearingSensitivity(8);
	}

	// attack_1
	void Cavetroll2_OnAttack12()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(25, 40)), "90%", "blunt");

		OnAttackSound();
	}

	// attack_2
	void Cavetroll2_OnAttack22()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));

		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(30, 40)), "100%", "blunt");

		OnAttackSound();
	}

	// npc_struck
	// Hit by someone
	void Cavetroll2_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		MonstersTroll_OnNpcStruck(damage); // monsters/troll
		Cavetroll2_OnNpcStruck(damage);
	}

	void OnTrollSpawn() { Cavetroll2_OnTrollSpawn(); } // troll_spawn
	void OnAttack12() { Cavetroll2_OnAttack12(); } // attack_1
	void OnAttack22() { Cavetroll2_OnAttack22(); } // attack_2
	void OnAttackSound(float pitch = 0.0f) {} // attack_sound

	// This file's events and timers by their .script names
	bool Cavetroll2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "troll_spawn") { OnTrollSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/cavetroll2"]
shared class Cavetroll2Script : MonstersTrollScript, Cavetroll2
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Cavetroll2_FirstThink();
		MonstersTroll_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Cavetroll2_DispatchEvent(name, params)
			|| MonstersTrollScript::DispatchEvent(name, params);
	}
}
