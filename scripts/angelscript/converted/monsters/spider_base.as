#pragma context server

// Converted from monsters/spider_base.script by msc_transpiler.
// Standard Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpiderBase
{
	// Constants
	string PARRY_TYPE = "dodged!";

	// Variables (an unset .script variable reads as its own name)
	string CAN_HEAR = "CAN_HEAR";
	float ATTACK_HITRANGE = 0.0f;

	// unnamed block (first think)
	void SpiderBase_FirstThink()
	{
		CAN_HEAR = "1"; // Not a const, because it changes
		if (Text(ATTACK_HITRANGE) == "ATTACK_HITRANGE")
			ATTACK_HITRANGE = 128.0f;
	}

	// npc_spawn
	void SpiderBase_OnNpcSpawn(string npc = "")
	{
		SetRace("spider");
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetBoundingBox("npcsize"); // hoping will help with "reach" issues
	}

	// unnamed block (timer)
	// Idling
	void SpiderBase_Timer()
	{
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");

		if (!Truthy(Eval("game.monster.alive")))
			return;
		if (Truthy(GetVar("SPIDER_LATCHED")))
			return;

		PlaySound(Int(Eval("game.sound.body")), SPIDER_IDLE_VOL, SOUND_IDLE1);
	}

	// frame_bite1
	// Deal damage
	void SpiderBase_OnFrameBite1()
	{
		float attackDamage = Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH);
		DoDamageEx(ENT_LASTSEEN, ATTACK_HITRANGE, attackDamage, ATTACK_ACCURACY, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
	}

	// bite1
	// backwards compatibility.  the spiders mdls need to be calling frame_bite1
	void SpiderBase_OnBite1()
	{
		OnFrameBite1();
	}

	// npc_struck
	// Hit by someone
	void SpiderBase_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), SPIDER_VOLUME, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SND_STRUCK4, SND_STRUCK5);
	}

	// game_parry
	// Dodge an attack
	void SpiderBase_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		if (GetVar("ANIM_DODGE") == "ANIM_DODGE")
			return;

		PlayAnim("critical", GetVar("ANIM_DODGE"));
	}

	// npc_death
	// Stop idle sound on death
	void SpiderBase_OnNpcDeath()
	{
		PlaySound(Int(Eval("game.sound.body")), 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		SpiderBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	void OnFrameBite1() { SpiderBase_OnFrameBite1(); } // frame_bite1
	void OnBite1() { SpiderBase_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { SpiderBase_OnNpcStruck(damage); } // npc_struck
	void OnNpcDeath() { SpiderBase_OnNpcDeath(); } // npc_death

	// This file's events and timers by their .script names
	bool SpiderBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "frame_bite1") { OnFrameBite1(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "SpiderBase_Timer") { SpiderBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider_base"]
shared class SpiderBaseScript : BaseMonsterScript, SpiderBase
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_ACCURACY = "ATTACK_ACCURACY";
	float ATTACK_DAMAGE_HIGH = 0.0f;
	float ATTACK_DAMAGE_LOW = 0.0f;
	string SND_STRUCK1 = "SND_STRUCK1";
	string SND_STRUCK2 = "SND_STRUCK2";
	string SND_STRUCK3 = "SND_STRUCK3";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_IDLE1 = "SOUND_IDLE1";
	string SOUND_PAIN = "SOUND_PAIN";
	float SPIDER_IDLE_DELAY = 0.0f;
	int SPIDER_IDLE_VOL = 0;
	int SPIDER_VOLUME = 0;

	// Variables declared by included files, with the value they start with in this script
	SpiderBaseScript()
	{
		PARRY_TYPE = "dodged!";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderBase_FirstThink();
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
		return SpiderBase_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
