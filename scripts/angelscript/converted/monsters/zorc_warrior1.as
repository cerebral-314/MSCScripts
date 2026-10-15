#pragma context server

// Converted from monsters/zorc_warrior1.script by msc_transpiler.
// Thothie - Zombie Orcs (not the ones used in mscave)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/zorc_warrior1"]
class ZorcWarrior1 : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 50.0f;
	float ATTACK_DMG_HIGH = 100.0f;

	// unnamed block (first think)
	void ZorcWarrior1_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 50.0f;
		NPC_GIVE_EXP = 200.0f;

		ANIM_ATTACK = "swordswing1_L";

		BO_ZOMBIE_MODE = true;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(2000);
		SetName("Undead Orc");
		SetHearingSensitivity(5);
		SetDamageTaken("all", 0.8f);

		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("fire", 1.25f);

		SetAnimFrameRate(0.5f);
		BASE_FRAMERATE = "0.5";

		SetRace("undead");

		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 1); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 4); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
		SetProp(ENT_ME, "skin", 1);
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
		ZorcWarrior1_FirstThink();
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
