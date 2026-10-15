#pragma context server

// Converted from helena/orcguard.script by msc_transpiler.
// Thothie - Provided for backwards compatability with MS 1.35
// Otherwise all the maps go bad with each revision
// - Similar to Orc Flayer, no roam, more cash / hp

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "helena/orcguard"]
class Orcguard : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 18.0f;
	float ATTACK_DMG_HIGH = 45.0f;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// unnamed block (first think)
	void Orcguard_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(15, 35);
		NPC_GIVE_EXP = 100.0f;
		DROP_ITEM1 = "axes_battleaxe"; // Used by base_monster
		DROP_ITEM1_CHANCE = "40%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(600);
		// ov 180
		SetWidth(32);
		SetHeight(60);
		SetName("Orc Guard");
		SetHearingSensitivity(3);
		SetStat("parry", 15);
		SetStat("swordsmanship", 10, 25, 20);
		SetDamageTaken("all", 0.8f);
		SetRoam(false);

		SetModelBody(0, 2); // Body
		SetModelBody(1, 2); // Head
		SetModelBody(2, 1); // Weapon
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

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

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Orcguard_FirstThink();
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
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
