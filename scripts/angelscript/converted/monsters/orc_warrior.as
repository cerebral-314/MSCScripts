#pragma context server

// Converted from monsters/orc_warrior.script by msc_transpiler.
// Orc warrior

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base.as"
#include "converted/monsters/orc_base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersOrcWarrior
{
	// Constants
	string ATTACK_ACCURACY = "60%";
	float ATTACK_DMG_LOW = 5.0f;
	float ATTACK_DMG_HIGH = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 1;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void MonstersOrcWarrior_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(3, 8);
		NPC_GIVE_EXP = 30.0f;

		DROP_ITEM1 = "axes_battleaxe"; // Used by base_monster
		DROP_ITEM1_CHANCE = "10%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
	}

	// orc_spawn
	void MonstersOrcWarrior_OnOrcSpawn()
	{
		SetHealth(60);
		// ov 180
		SetName("Orc Warrior");
		SetHearingSensitivity(1.5f);
		SetStat("parry", 50);
		SetDamageTaken("all", 0.9f);

		SetModelBody(0, 2); // Body
		SetModelBody(1, 0); // Head
		SetModelBody(2, 1); // Weapon
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		MonstersOrcWarrior_OnOrcSpawn();
	}

	void OnSwingAxe() { OrcBaseMelee_OnSwingAxe(); } // swing_axe

	// This file's events and timers by their .script names
	bool MonstersOrcWarrior_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_warrior"]
shared class MonstersOrcWarriorScript : OrcBaseScript, MonstersOrcWarrior, OrcBaseMelee
{
	// Variables declared by included files, with the value they start with in this script
	MonstersOrcWarriorScript()
	{
		DROP_GOLD = 1;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersOrcWarrior_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		OrcBaseMelee_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersOrcWarrior_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
