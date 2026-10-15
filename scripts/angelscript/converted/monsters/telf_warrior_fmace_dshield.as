#pragma context server

// Converted from monsters/telf_warrior_fmace_dshield.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TelfWarriorFmaceDshield
{
	// Constants
	string CHANCE_STUN = "20%";
	string ATTACK_TYPE = "blunt";
	string ATTACK_STANCE = "1h";
	string CHANCE_DOT = "100%";
	bool CAN_BLOCK = true;
	bool WEAPON_AURA = true;
	string WAURA_TYPE = "fire";
	string WAURA_EFFECT_SCRIPT = "effects/dot_fire";
	int WAURA_RANGE = 128;
	string WEAPON_AURA_CL_SCRIPT = "monsters/telf_warrior_fmace_cl";
	int DMG_WAURA = 400;
	int DOT_WAURA = 150;
	string WAURA_DMG_TYPE = "fire_effect";
	float FREQ_WAURA = 0.0f;
	float WAURA_DURATION = 5.0f;
	string SOUND_WAURA_START = "monsters/goblin/sps_fogfire.wav";
	string SOUND_WAURA_LOOP = "magic/volcano_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void TelfWarriorFmaceDshield_FirstThink()
	{
		NPC_GIVE_EXP = 2500.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;
	}

	// elf_spawn
	void TelfWarriorFmaceDshield_OnElfSpawn()
	{
		SetName("Torkalath Warrior");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Archer - different base? (spiral arrows)
		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		ANIM_ATTACK = "swordswing1_R";
		SetRace("torkie");

		SetModelBody(1, 2); // 0=Unarmed 1=PDagger 2=FMace 3=LAxe 4=ESword 5=DBow 6=IDagger 7=Axe 8=OBow 9=Dagger 10=Mace
		SetModelBody(2, 1); // 0=None 1=Dark_Shield 2=Wood_Shield 3=White_Shield
	}

	// npc_post_spawn
	void TelfWarriorFmaceDshield_OnNpcPostSpawn()
	{
		ANIM_ATTACK = "swordswing1_R";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

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
		TelfWarriorFmaceDshield_OnNpcPostSpawn();
	}

	void OnElfSpawn() { TelfWarriorFmaceDshield_OnElfSpawn(); } // elf_spawn

	// This file's events and timers by their .script names
	bool TelfWarriorFmaceDshield_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/telf_warrior_fmace_dshield"]
shared class TelfWarriorFmaceDshieldScript : ElfWarriorBaseScript, TelfWarriorFmaceDshield
{
	// Variables every script that includes this file declares
	int DID_INTRO = 0;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string OVR_DROP_GOLD_AMT = "OVR_DROP_GOLD_AMT";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorFmaceDshieldScript()
	{
		CHANCE_STUN = "20%";
		CHANCE_DOT = "100%";
		CAN_BLOCK = true;
		WEAPON_AURA = true;
		WAURA_TYPE = "fire";
		WAURA_EFFECT_SCRIPT = "effects/dot_fire";
		WEAPON_AURA_CL_SCRIPT = "monsters/telf_warrior_fmace_cl";
		DMG_WAURA = 400;
		DOT_WAURA = 150;
		WAURA_DMG_TYPE = "fire_effect";
		SOUND_WAURA_START = "monsters/goblin/sps_fogfire.wav";
		SOUND_WAURA_LOOP = "magic/volcano_loop.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("npc/elf_f_warrior.mdl");
		Precache("magic/volcano_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorFmaceDshield_FirstThink();
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
		return TelfWarriorFmaceDshield_DispatchEvent(name, params)
			|| ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
