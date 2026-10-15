#pragma context server

// Converted from monsters/orc_berserker_blackhand.script by msc_transpiler.
// Black hand clan - Tough Orc berserker
// Berserkers are like warriors, but have special attacks

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcBerserkerBlackhand
{
	// Constants
	string ATTACK_ACCURACY = "70%";
	float ATTACK_DMG_LOW = 10.0f;
	float ATTACK_DMG_HIGH = 20.0f;
	int ORC_SHIELD = 0;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string ATTACK_PUSH = "ATTACK_PUSH";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void OrcBerserkerBlackhand_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(8, 16);
		NPC_GIVE_EXP = 60.0f;
		DROP_ITEM1 = "swords_shortsword"; // Used by base_monster
		DROP_ITEM1_CHANCE = "25%"; // Used by base_monster

		ANIM_ATTACK1 = "battleaxe_swing1_L"; // Attack animation 1
		ANIM_ATTACK2 = "swordswing1_L"; // Attack animation 2
		FLINCH_CHANCE = "45%";
	}

	// swing_sword
	// Needs to be above the includes - Thothie asks "why?"
	void OrcBerserkerBlackhand_OnSwingSword()
	{
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(-100, 130, 120)));
	}

	// orc_spawn
	void OrcBerserkerBlackhand_OnOrcSpawn()
	{
		SetHealth(120);
		// ov 180
		SetName("Blackhand Warrior");
		if (MapName() == "ms_wicardoven")
		{
			SetName("Voldar Recruit");
			SetProp(ENT_ME, "skin", 3);
		}
		SetHearingSensitivity(2);
		SetStat("parry", 50);
		SetDamageTaken("all", 0.7f);

		SetModelBody(0, 2); // Body
		SetModelBody(1, 2); // Head
		SetModelBody(2, 4); // Weapon
		if (ORC_SHIELD == 1 && !BO_ZOMBIE_MODE)
		{
			SetStat("parry", 90);
			SetModelBody(2, 6);
		}
	}

	// npc_selectattack
	void OrcBerserkerBlackhand_OnNpcSelectattack()
	{
		ANIM_ATTACK = ANIM_ATTACK1;
		ATTACK_PUSH = "none";
		if (RandomInt(0, 99) < 30)
			ANIM_ATTACK = ANIM_ATTACK2;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// swing_sword
	void OnSwingSword()
	{
		OrcBerserkerBlackhand_OnSwingSword();
		OrcBaseMelee_OnSwingSword(); // monsters/orc_base_melee
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		OrcBerserkerBlackhand_OnOrcSpawn();
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

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		OrcBerserkerBlackhand_OnNpcSelectattack();
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell

	// This file's events and timers by their .script names
	bool OrcBerserkerBlackhand_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_berserker_blackhand"]
shared class OrcBerserkerBlackhandScript : OrcBaseScript, OrcBerserkerBlackhand, OrcBaseMelee
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcBerserkerBlackhand_FirstThink();
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
		return OrcBerserkerBlackhand_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
