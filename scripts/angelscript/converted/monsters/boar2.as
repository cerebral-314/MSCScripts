#pragma context server

// Converted from monsters/boar2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base_remake.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersBoar2
{
	// Constants
	int BOAR_SIZE = 2;
	int BOAR_SKIN = 0;
	string BOAR_MODEL = "monsters/boar2.mdl";
	float DMG_GORE_FORWARD = 0.0f;
	float DMG_GORE_LEFT = 0.0f;
	float DMG_GORE_RIGHT = 0.0f;
	int DMG_CHARGE = 0;
	string ATTACK_HITCHANCE = "70%";

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	string FLEE_CHANCE = "FLEE_CHANCE";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";

	// unnamed block (first think)
	void MonstersBoar2_FirstThink()
	{
		NPC_GIVE_EXP = 125.0f;

		FLEE_CHANCE = "10%";
	}

	// boar_spawn
	void MonstersBoar2_OnBoarSpawn()
	{
		SetName("Great Boar");
		SetHealth(400);
		SetHearingSensitivity(2);
		SetRoam(true);
	}

	// npc_post_spawn
	void MonstersBoar2_OnNpcPostSpawn()
	{
		// this is set in the base too (on spawn), so must reset here
		DROP_ITEM1 = "skin_boar_heavy"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "50%"; // base_monster - Chance of item drop #1
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		MonstersBoar2_OnNpcPostSpawn();
	}

	void OnBoarSpawn() { MonstersBoar2_OnBoarSpawn(); } // boar_spawn

	// This file's events and timers by their .script names
	bool MonstersBoar2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "boar_spawn") { OnBoarSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/boar2"]
shared class MonstersBoar2Script : BoarBaseRemakeScript, MonstersBoar2
{
	// Variables every script that includes this file declares
	int DMG_GORE1 = 0;
	float DMG_GORE2 = 0.0f;
	float DMG_GORE3 = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MonstersBoar2Script()
	{
		BOAR_SIZE = 2;
		BOAR_MODEL = "monsters/boar2.mdl";
		ATTACK_HITCHANCE = "70%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar2.mdl");
		Precache("monsters/boar/hoofbeats_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersBoar2_FirstThink();
		BoarBaseRemake_FirstThink();
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
		return MonstersBoar2_DispatchEvent(name, params)
			|| BoarBaseRemakeScript::DispatchEvent(name, params);
	}
}
