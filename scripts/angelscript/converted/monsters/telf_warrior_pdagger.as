#pragma context server

// Converted from monsters/telf_warrior_pdagger.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

[script "monsters/telf_warrior_pdagger"]
class TelfWarriorPdagger : ElfWarriorBaseScript
{
	// Constants
	string ATTACK_STANCE = "assasin";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorPdagger()
	{
		DMG_TYPE = "pierce";
		CHANCE_DOT = "100%";
		DOT_SCRIPT = "effects/dot_poison";
		DOT_AMT = "40";
		DOT_DURATION = 10.0f;
		CAN_KICK = true;
		LEAP_AFTER_KICK = true;
		CAN_THROW = true;
		DMG_MELEE = 200;
	}

	// unnamed block (first think)
	void TelfWarriorPdagger_FirstThink()
	{
		NPC_GIVE_EXP = 3000.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcPostSpawn(); // monsters/elf_warrior_base
		ANIM_ATTACK = "swordjab1_R";
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Torkalath Assassin");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Archer - different base? (spiral arrows)
		SetHealth(4000);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");
		SetMoveSpeed(2);
		BASE_MOVESPEED = 2.0f;

		SetModelBody(1, 1); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorPdagger_FirstThink();
		ElfWarriorBase_FirstThink();
		ElfWarriorBase_FirstThink2();
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
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
