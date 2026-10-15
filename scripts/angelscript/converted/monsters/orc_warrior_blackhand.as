#pragma context server

// Converted from monsters/orc_warrior_blackhand.script by msc_transpiler.
// Black hand clan - Tough Orc warriors

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/orc_warrior_blackhand"]
class OrcWarriorBlackhand : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "70%";
	float ATTACK_DMG_LOW = 10.0f;
	float ATTACK_DMG_HIGH = 20.0f;
	int ORC_SHIELD = 0;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// unnamed block (first think)
	void OrcWarriorBlackhand_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(8, 16);
		NPC_GIVE_EXP = 60.0f;
		DROP_ITEM1 = "axes_battleaxe"; // Used by base_monster
		DROP_ITEM1_CHANCE = "30%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(120);
		// ov 180
		SetName("Blackhand Warrior");
		if (MapName() == "ms_wicardoven")
		{
			SetName("Voldar Recruit");
			SetProp(ENT_ME, "skin", 3);
		}
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);

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
		OrcWarriorBlackhand_FirstThink();
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
