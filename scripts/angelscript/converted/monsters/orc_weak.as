#pragma context server

// Converted from monsters/orc_weak.script by msc_transpiler.
// Easy, weak warrior

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/orc_weak"]
class OrcWeak : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "30%";
	float ATTACK_DMG_LOW = 0.5f;
	float ATTACK_DMG_HIGH = 1.5f;

	// unnamed block (first think)
	void OrcWeak_FirstThink()
	{
		DROP_GOLD = RandomInt(0, 1); // Chance of dropping gold
		DROP_GOLD_AMT = RandomInt(1, 4);
		NPC_GIVE_EXP = 10.0f;

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation

		MOVE_RANGE = "64";
		ATTACK_RANGE = 72.0f;
		ATTACK_HITRANGE = 128.0f;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(20);
		// ov 180
		SetName("Orc");
		SetHearingSensitivity(1);
		SetStat("parry", 15);

		SetModelBody(0, 0); // Body
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
		OrcWeak_FirstThink();
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
