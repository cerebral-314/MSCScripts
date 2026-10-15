#pragma context server

// Converted from monsters/morc_warrior.script by msc_transpiler.
// Marogar (Polar) Orc warrior, from Orc Warrior, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_warrior"]
class MorcWarrior : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "60%";
	float ATTACK_DMG_LOW = 10.0f;
	float ATTACK_DMG_HIGH = 35.0f;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";

	// unnamed block (first think)
	void MorcWarrior_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(5, 10);
		NPC_GIVE_EXP = 60.0f;
		DROP_ITEM1 = "axes_battleaxe"; // Used by base_monster
		DROP_ITEM1_CHANCE = "1%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(240);
		// ov 180
		SetName("Marogar Orc Warrior");
		SetHearingSensitivity(1.5f);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.9f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0.1f);
		SetModel("monsters/morc.mdl");

		SetModelBody(0, 0); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 1); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/morc.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcWarrior_FirstThink();
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
