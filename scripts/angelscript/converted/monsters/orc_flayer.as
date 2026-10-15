#pragma context server

// Converted from monsters/orc_flayer.script by msc_transpiler.
// Orcish Flayer
// Thothie
// -Traded axe for sword MS 1.35 style

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersOrcFlayer
{
	// Constants
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 18.0f;
	float ATTACK_DMG_HIGH = 25.0f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";

	// unnamed block (first think)
	void MonstersOrcFlayer_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(15, 25);
		NPC_GIVE_EXP = 100.0f;
		DROP_ITEM1 = "swords_shortsword"; // Used by base_monster
		DROP_ITEM1_CHANCE = "20%"; // Used by base_monster

		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
	}

	// orc_spawn
	void MonstersOrcFlayer_OnOrcSpawn()
	{
		SetHealth(400);
		SetName("Orcish Flayer");
		SetHearingSensitivity(5);
		SetStat("parry", 15);
		SetStat("swordsmanship", 10, 25, 20);
		SetDamageTaken("all", 0.8f);

		SetModelBody(0, 2); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 4); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		MonstersOrcFlayer_OnOrcSpawn();
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
	bool MonstersOrcFlayer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_flayer"]
shared class MonstersOrcFlayerScript : OrcBaseScript, MonstersOrcFlayer, OrcBaseMelee
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersOrcFlayer_FirstThink();
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
		return MonstersOrcFlayer_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
