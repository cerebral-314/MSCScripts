#pragma context server

// Converted from monsters/guard2.script by msc_transpiler.
// Thothie - Completely the wrong script in here...
// - Needed for MS 1.35 compatability too..
// - To make more useful, converting to staitonary orc guard
// - Note: place with back to wall, or may not attack when idle
// Orc Guard2 (from Orc warrior)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/guard2"]
class Guard2 : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "60%";
	float ATTACK_DMG_LOW = 5.0f;
	float ATTACK_DMG_HIGH = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// unnamed block (first think)
	void Guard2_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(3, 8);
		NPC_GIVE_EXP = 30.0f;
		DROP_ITEM1 = "axes_battleaxe"; // Used by base_monster
		DROP_ITEM1_CHANCE = "10%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(100);
		// ov 180
		SetName("Orc Warrior");
		SetHearingSensitivity(1.5f);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.9f);
		SetRoam(false);

		SetModelBody(0, 2); // Body
		SetModelBody(1, 0); // Head
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
		Guard2_FirstThink();
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
