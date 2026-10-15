#pragma context server

// Converted from m2_quest/boar2_weak.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base_remake.as"

[script "m2_quest/boar2_weak"]
class Boar2Weak : BoarBaseRemakeScript
{
	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// Variables declared by included files, with the value they start with in this script
	Boar2Weak()
	{
		BOAR_SIZE = 2;
		BOAR_MODEL = "monsters/boar2.mdl";
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Boar2Weak_FirstThink()
	{
		NPC_GIVE_EXP = 75.0f;

		FLEE_CHANCE = "10%";
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		// this is set in the base too (on spawn), so must reset here
		DROP_ITEM1 = "skin_boar_heavy"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "50%"; // base_monster - Chance of item drop #1
	}

	// boar_spawn
	void OnBoarSpawn()
	{
		SetName("Great Boar");
		SetHealth(250);
		SetHearingSensitivity(2);
		SetRoam(true);
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
		Boar2Weak_FirstThink();
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
		if (name == "boar_spawn") { OnBoarSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return BoarBaseRemakeScript::DispatchEvent(name, params);
	}
}
