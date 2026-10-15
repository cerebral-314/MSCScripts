#pragma context server

// Converted from calruin/spidqueen.script by msc_transpiler.
// Thothie - precache error fixed - plus she drops gold, like she used to
// Giant Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Spidqueen
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 1.0f;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_ACCURACY = "0";
	string ATTACK_HITCHANCE = "100%";
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_FLEE = "CAN_FLEE";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// unnamed block (first think)
	void Spidqueen_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "calruin"))
		{
			NPC_GIVE_EXP = 500.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 200.0f;
		}

		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ATTACK_RANGE = 250.0f;
		ATTACK_HITRANGE = 350.0f;
		MOVE_RANGE = "50";
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 25;
		DROP_GOLD_MAX = 50;
	}

	// npc_spawn
	void Spidqueen_OnNpcSpawn(string npc = "")
	{
		SetHealth(900);
		SetWidth(120);
		SetHeight(80);
		SetName("Veneficus Arachnidia");
		SetRoam(true);
		SetHearingSensitivity(6);
		SetRace("spider");
		if (ToLowerCase(MapName()) != "helena")
		{
			SetModel("monsters/fer_spider_giant.mdl");
			SetModelBody(0, 2);
		}
		else
		{
			SetModel("monsters/giant_spider.mdl");
		}
		SetIdleAnim("idle");
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("all", 0.7f);
	}

	// bite1
	void Spidqueen_OnBite1()
	{
		// Deal damage
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(9.5f, 11), ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void Spidqueen_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
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
		Spidqueen_OnNpcSpawn(npc);
	}

	void OnBite1() { Spidqueen_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { Spidqueen_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool Spidqueen_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/spidqueen"]
shared class SpidqueenScript : BaseMonsterNewScript, Spidqueen
{
	// Variables declared by included files, with the value they start with in this script
	SpidqueenScript()
	{
		NPC_BOSS_RESTORATION = 1.0f;
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_giant.mdl");
		Precache("monsters/giant_spider.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Spidqueen_FirstThink();
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
		return Spidqueen_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
