#pragma context server

// Converted from helena/orcwarrior_hard.script by msc_transpiler.
// Thothie - Provided for backwards compatability with MS 1.35
// Otherwise all the maps go bad with each revision
// - Similar to Orc Flayer, little weaker, no weapon drop

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcwarriorHard
{
	// Constants
	string ATTACK_ACCURACY = "70%";
	float ATTACK_DMG_LOW = 16.0f;
	float ATTACK_DMG_HIGH = 32.0f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";

	// unnamed block (first think)
	void OrcwarriorHard_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(5, 25);
		NPC_GIVE_EXP = 80.0f;

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
	}

	// orc_spawn
	void OrcwarriorHard_OnOrcSpawn()
	{
		SetHealth(350);
		// ov 180
		SetWidth(32);
		SetHeight(60);
		SetName("Orc Champion");
		SetHearingSensitivity(3);
		SetStat("parry", 15);
		SetStat("swordsmanship", 10, 25, 20);
		SetDamageTaken("all", 0.8f);

		SetModelBody(0, 0); // Body
		SetModelBody(1, 2); // Head
		SetModelBody(2, 1); // Weapon
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		OrcwarriorHard_OnOrcSpawn();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell

	// This file's events and timers by their .script names
	bool OrcwarriorHard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "helena/orcwarrior_hard"]
shared class OrcwarriorHardScript : OrcBaseScript, OrcwarriorHard, OrcBaseMelee
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcwarriorHard_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
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
		return OrcwarriorHard_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
