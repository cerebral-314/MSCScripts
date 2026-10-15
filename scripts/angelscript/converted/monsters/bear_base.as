#pragma context server

// Converted from monsters/bear_base.script by msc_transpiler.
// Base Bear

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearBase
{
	// Constants
	string SOUND_ATTACK1 = "monsters/bear/cubattack.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACK3 = "none";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "monsters/bear/cubpain.wav";
	string SOUND_STRUCK5 = "none";
	string SOUND_DEATH = "monsters/bear/cubdeath.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "20%";
	string BEAR_VOLUME = "game.sound.maxvol";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_HEAR = "CAN_HEAR";
	string NPC_HEAR_TARGET = "NPC_HEAR_TARGET";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";

	// unnamed block (first think)
	void BearBase_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";

		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		CAN_RETALIATE = "1"; // base_npc_attack - Whether I retaliate
		CAN_HEAR = "1"; // base_npc_attack - Whether I hear things
		NPC_HEAR_TARGET = "enemy"; // base_npc_attack - What I hear

		DROP_ITEM1 = "skin_bear"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "50%"; // base_monster - Chance of item drop #1
	}

	// npc_spawn
	void BearBase_OnNpcSpawn(string npc = "")
	{
		SetRoam(true);
		SetRace("wildanimal");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// game_postspawn
	void BearBase_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		if (StartsWith(ToLowerCase(MapName()), "skycastle"))
			DROP_ITEM1_CHANCE = "0%";
	}

	// bite1
	// Deal damage
	void BearBase_OnBite1()
	{
		// Attack grunts
		PlayRandomSound(Int(Eval("game.sound.weapon")), BEAR_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void BearBase_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), BEAR_VOLUME, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		BearBase_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc);
	}

	void OnBite1() { BearBase_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { BearBase_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool BearBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_base"]
shared class BearBaseScript : BaseMonsterScript, BearBase
{
	// Variables every script that includes this file declares
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";

	// Variables declared by included files, with the value they start with in this script
	BearBaseScript()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/bear/cubdeath.wav";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BearBase_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
