#pragma context server

// Converted from monsters/telf_warrior_idagger.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TelfWarriorIdagger
{
	// Constants
	string DMG_TYPE = "pierce";
	string ATTACK_STANCE = "assasin";
	string CHANCE_DOT = "100%";
	string DOT_SCRIPT = "effects/dot_cold";
	string DOT_AMT = "50";
	float DOT_DURATION = 5.0f;
	int DMG_MELEE = 200;
	bool CAN_FREEZE_AURA = true;

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void TelfWarriorIdagger_FirstThink()
	{
		NPC_GIVE_EXP = 3000.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;
	}

	// game_precache
	void TelfWarriorIdagger_OnGamePrecache()
	{
		PrecacheFile("effects/sfx_ice_burst");
	}

	// elf_spawn
	void TelfWarriorIdagger_OnElfSpawn()
	{
		SetName("Torkalath Frostmistress");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Shadowarcher - different base? (spiral arrows)
		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");

		SetModelBody(1, 6); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow 6=Litchtounge
	}

	// npc_post_spawn
	void TelfWarriorIdagger_OnNpcPostSpawn()
	{
		ANIM_ATTACK = "swordjab1_R";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { TelfWarriorIdagger_OnGamePrecache(); } // game_precache

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
		TelfWarriorIdagger_OnNpcPostSpawn();
	}

	void OnElfSpawn() { TelfWarriorIdagger_OnElfSpawn(); } // elf_spawn

	// This file's events and timers by their .script names
	bool TelfWarriorIdagger_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/telf_warrior_idagger"]
shared class TelfWarriorIdaggerScript : ElfWarriorBaseScript, TelfWarriorIdagger
{
	// Variables every script that includes this file declares
	int DID_INTRO = 0;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string OVR_DROP_GOLD_AMT = "OVR_DROP_GOLD_AMT";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorIdaggerScript()
	{
		DMG_TYPE = "pierce";
		CHANCE_DOT = "100%";
		DOT_SCRIPT = "effects/dot_cold";
		DMG_MELEE = 200;
		CAN_FREEZE_AURA = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorIdagger_FirstThink();
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
		return TelfWarriorIdagger_DispatchEvent(name, params)
			|| ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
