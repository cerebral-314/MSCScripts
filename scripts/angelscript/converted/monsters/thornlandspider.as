#pragma context server

// Converted from monsters/thornlandspider.script by msc_transpiler.
// Giant Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Thornlandspider
{
	// Constants
	bool DELETE_ON_DEATH = true;
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string ANIM_DODGE = "dodge";
	float ATTACK_DAMAGE_LOW = 9.0f;
	float ATTACK_DAMAGE_HIGH = 12.0f;
	string ATTACK_ACCURACY = "85%";
	int SPIDER_IDLE_VOL = 4;
	float SPIDER_IDLE_DELAY = 3.6f;
	int SPIDER_VOLUME = 10;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	bool NPC_IS_BOSS = false;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;

	// unnamed block (first think)
	void Thornlandspider_FirstThink()
	{
		if (ToLowerCase(MapName()) == "thornlands")
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 200.0f;
		}
		else
		{
			NPC_GIVE_EXP = 100.0f;
		}

		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "80";
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
		NPC_GIVE_EXP = 100.0f;
	}

	// npc_spawn
	void Thornlandspider_OnNpcSpawn(string npc = "")
	{
		SetHealth(500);
		SetWidth(100);
		SetHeight(64);
		SetName("Timidus Textor");
		SetHearingSensitivity(6);
		SetModel("monsters/giant_spider.mdl");
		// setvard NPC_GIVE_EXP 100 //doesn't seem to be coming accross in base_monster
		SetDamageTaken("all", 0.85f);
	}

	// bite1
	// Deal damage
	void Thornlandspider_OnBite1()
	{
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), SPIDER_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), "85%");
	}

	// game_damaged_other
	string Thornlandspider_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		// (never true here, the rest is skipped) if PUSH_VEL isnot 'PUSH_VEL'
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, Thornlandspider_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		Thornlandspider_OnNpcSpawn(npc);
	}

	void OnBite1() { Thornlandspider_OnBite1(); } // bite1

	// This file's events and timers by their .script names
	bool Thornlandspider_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/thornlandspider"]
shared class ThornlandspiderScript : SpiderBaseScript, Thornlandspider
{
	// Variables declared by included files, with the value they start with in this script
	ThornlandspiderScript()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE_LOW = 9.0f;
		ATTACK_DAMAGE_HIGH = 12.0f;
		ATTACK_ACCURACY = "85%";
		SPIDER_IDLE_VOL = 4;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_spider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Thornlandspider_FirstThink();
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
		return Thornlandspider_DispatchEvent(name, params)
			|| SpiderBaseScript::DispatchEvent(name, params);
	}
}
