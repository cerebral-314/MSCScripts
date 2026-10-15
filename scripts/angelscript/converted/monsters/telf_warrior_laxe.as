#pragma context server

// Converted from monsters/telf_warrior_laxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TelfWarriorLaxe
{
	// Constants
	string DMG_TYPE = "slash";
	string ATTACK_STANCE = "2haxe";
	string CHANCE_DOT = "100%";
	string DOT_SCRIPT = "effects/dot_lightning";
	string DOT_AMT = "50";
	float DOT_DURATION = 5.0f;
	bool WEAPON_AURA = true;
	string SOUND_SHOCKAMB1 = "debris/zap1.wav";
	string SOUND_SHOCKAMB2 = "debris/zap3.wav";
	string SOUND_SHOCKAMB3 = "debris/zap8.wav";

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";

	// unnamed block (first think)
	void TelfWarriorLaxe_FirstThink()
	{
		NPC_GIVE_EXP = 2500.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;
	}

	// elf_spawn
	void TelfWarriorLaxe_OnElfSpawn()
	{
		SetName("Torkalath Slasher");
		// Torkalath Warrior - Club (stun)
		// Torkalath Assasin - Dagger (poison - maybe throw?)
		// Torkalath Slasher - Axe (more hp)
		// Torkalath Blademistress - Dbl Sword (more dmg)
		// Torkalath Shadowarcher - different base? (spiral arrows)
		SetHealth(7000);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");

		SetModelBody(1, 3); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow 6=Litchtounge
	}

	// npc_post_spawn
	void TelfWarriorLaxe_OnNpcPostSpawn()
	{
		ANIM_ATTACK = "battleaxe_swing1_L";
	}

	// unnamed block (timer)
	void TelfWarriorLaxe_Timer()
	{
		CallEventDelayed(Random(5, 10), "TelfWarriorLaxe_Timer");
		if (!IsAlive(ENT_ME))
			return;
		PlayRandomSound(0, 10, SOUND_SHOCKAMB1, SOUND_SHOCKAMB2, SOUND_SHOCKAMB3);

		// clientevent new all monsters/telf_warrior_laxe_cl $get(ent_me,index)
		// beam ents <spritename> <width> <target1> <attach#> <target2> <attach#> <(r,g,b)> <brightness> <noise> <duration> - stores in ent_lastcreated
		Effect("beam", "ents", "lgtning.spr", 20, ENT_ME, 1, ENT_ME, 2, Vector3(255, 255, 0), 200, 100, 1.0f);
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
		TelfWarriorLaxe_OnNpcPostSpawn();
	}

	void OnElfSpawn() { TelfWarriorLaxe_OnElfSpawn(); } // elf_spawn

	// This file's events and timers by their .script names
	bool TelfWarriorLaxe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "TelfWarriorLaxe_Timer") { TelfWarriorLaxe_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/telf_warrior_laxe"]
shared class TelfWarriorLaxeScript : ElfWarriorBaseScript, TelfWarriorLaxe
{
	// Variables every script that includes this file declares
	int DID_INTRO = 0;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string OVR_DROP_GOLD_AMT = "OVR_DROP_GOLD_AMT";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorLaxeScript()
	{
		CHANCE_DOT = "100%";
		DOT_SCRIPT = "effects/dot_lightning";
		WEAPON_AURA = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_f_warrior.mdl");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(Float(Eval("$randf(5.0,10.0)")), "TelfWarriorLaxe_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorLaxe_FirstThink();
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
		return TelfWarriorLaxe_DispatchEvent(name, params)
			|| ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
