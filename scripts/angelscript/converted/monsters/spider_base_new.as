#pragma context server

// Converted from monsters/spider_base_new.script by msc_transpiler.
// Standard Spider
// Thothie - experimental to see if new AI can fix spider range issues

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpiderBaseNew
{
	// Variables (an unset .script variable reads as its own name)
	string CAN_HEAR = "CAN_HEAR";
	float ATTACK_HITRANGE = 0.0f;

	// unnamed block (first think)
	void SpiderBaseNew_FirstThink()
	{
		CAN_HEAR = "1"; // Not a const, because it changes
		ATTACK_HITRANGE = 128.0f;
	}

	// npc_spawn
	void SpiderBaseNew_OnNpcSpawn(string npc = "")
	{
		SetRace("spider");
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetBoundingBox("npcsize"); // hoping will help with "reach" issues
	}

	// unnamed block (timer)
	// Idling
	void SpiderBaseNew_Timer()
	{
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBaseNew_Timer");

		if (!Truthy(Eval("game.monster.alive")))
			return;

		PlaySound(Int(Eval("game.sound.body")), SPIDER_IDLE_VOL, SOUND_IDLE1);
	}

	// frame_bite1
	// Deal damage
	void SpiderBaseNew_OnFrameBite1()
	{
		float attackDamage = Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(attackDamage), ATTACK_ACCURACY);
	}

	// bite1
	// backwards compatibility.  the spiders mdls need to be calling frame_bite1
	void SpiderBaseNew_OnBite1()
	{
		OnFrameBite1();
	}

	// npc_struck
	// Hit by someone
	void SpiderBaseNew_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), SPIDER_VOLUME, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SND_STRUCK4, SND_STRUCK5);
	}

	// game_parry
	// Dodge an attack
	void SpiderBaseNew_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		if (ANIM_DODGE == "ANIM_DODGE")
			return;

		PlayAnim("critical", ANIM_DODGE);
	}

	// npc_death
	// Stop idle sound on death
	void SpiderBaseNew_OnNpcDeath()
	{
		PlaySound(Int(Eval("game.sound.body")), 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBaseNew_OnNpcSpawn(npc);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		SpiderBaseNew_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	void OnFrameBite1() { SpiderBaseNew_OnFrameBite1(); } // frame_bite1
	void OnBite1() { SpiderBaseNew_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { SpiderBaseNew_OnNpcStruck(damage); } // npc_struck
	void OnNpcDeath() { SpiderBaseNew_OnNpcDeath(); } // npc_death

	// This file's events and timers by their .script names
	bool SpiderBaseNew_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "frame_bite1") { OnFrameBite1(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "SpiderBaseNew_Timer") { SpiderBaseNew_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider_base_new"]
shared class SpiderBaseNewScript : BaseMonsterNewScript, SpiderBaseNew
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DODGE = "ANIM_DODGE";
	string ATTACK_ACCURACY = "ATTACK_ACCURACY";
	float ATTACK_DAMAGE_HIGH = 0.0f;
	float ATTACK_DAMAGE_LOW = 0.0f;
	string PUSH_VEL = "PUSH_VEL";
	string SND_STRUCK1 = "SND_STRUCK1";
	string SND_STRUCK2 = "SND_STRUCK2";
	string SND_STRUCK3 = "SND_STRUCK3";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_ATTACK1 = "SOUND_ATTACK1";
	string SOUND_ATTACK2 = "SOUND_ATTACK2";
	string SOUND_IDLE1 = "SOUND_IDLE1";
	string SOUND_PAIN = "SOUND_PAIN";
	float SPIDER_IDLE_DELAY = 0.0f;
	int SPIDER_IDLE_VOL = 0;
	int SPIDER_VOLUME = 0;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBaseNew_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderBaseNew_FirstThink();
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
		return SpiderBaseNew_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
