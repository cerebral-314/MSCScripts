#pragma context server

// Converted from monsters/telf_warrior_esword.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

[script "monsters/telf_warrior_esword"]
class TelfWarriorEsword : ElfWarriorBaseScript
{
	// Constants
	string ATTACK_STANCE = "2hsword";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorEsword()
	{
		DMG_MELEE = 800;
	}

	// unnamed block (first think)
	void TelfWarriorEsword_FirstThink()
	{
		NPC_GIVE_EXP = 2000.0f;
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
		ANIM_ATTACK = "longsword_swipe_L";
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Torkalath Blademistress");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Shadowarcher - different base? (spiral arrows)
		SetHealth(4000);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");

		SetModelBody(1, 4); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow 6=Litchtounge
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorEsword_FirstThink();
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
