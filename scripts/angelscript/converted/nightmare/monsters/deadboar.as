#pragma context server

// Converted from nightmare/monsters/deadboar.script by msc_transpiler.
// Skeleton Boar by Furion001

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base_remake.as"

[script "nightmare/monsters/deadboar"]
class Deadboar : BoarBaseRemakeScript
{
	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// Variables declared by included files, with the value they start with in this script
	Deadboar()
	{
		BOAR_MODEL = "nightmare/monsters/skeleboar.mdl";
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Deadboar_FirstThink()
	{
		NPC_GIVE_EXP = 35.0f;

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
		DROP_ITEM1_CHANCE = "0%"; // base_monster - Chance of item drop #1
	}

	// boar_spawn
	void OnBoarSpawn()
	{
		SetName("Skeleton Boar");
		SetHealth(100);
		SetHearingSensitivity(2);
		SetRoam(true);
		SetRace("undead");

		SetWidth(24);
		SetHeight(24);

		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("poison", 0.01f);
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.25f);
		SetDamageTaken("slash", 0.5f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("nightmare/monsters/skeleboar.mdl");
		Precache("monsters/boar/hoofbeats_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Deadboar_FirstThink();
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
