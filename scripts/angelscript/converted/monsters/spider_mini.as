#pragma context server

// Converted from monsters/spider_mini.script by msc_transpiler.
// Mini-Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpiderMini
{
	// Constants
	bool DELETE_ON_DEATH = true;
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	float ATTACK_DAMAGE_LOW = 1.0f;
	float ATTACK_DAMAGE_HIGH = 2.0f;
	string ATTACK_ACCURACY = "40%";
	int SPIDER_IDLE_VOL = 1;
	float SPIDER_IDLE_DELAY = 3.6f;
	int SPIDER_VOLUME = 5;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string HUNT_AGRO = "HUNT_AGRO";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_FLEE = "CAN_FLEE";

	// unnamed block (first think)
	void SpiderMini_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "30";
		ATTACK_RANGE = 50.0f;
		ATTACK_HITRANGE = 80.0f;
		NPC_GIVE_EXP = 5.0f;

		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
	}

	// npc_spawn
	void SpiderMini_OnNpcSpawn(string npc = "")
	{
		SetHealth(15);
		// ov 359
		SetWidth(16);
		SetHeight(20);
		SetHearingSensitivity(3);
		SetName("Cave Spiderling");
		NPC_GIVE_EXP = 5.0f; // not getting set proper in base_monster, near as I can tell
		SetModel("monsters/minispider.mdl");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		SpiderMini_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool SpiderMini_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider_mini"]
shared class SpiderMiniScript : SpiderBaseScript, SpiderMini
{
	// Variables declared by included files, with the value they start with in this script
	SpiderMiniScript()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE_LOW = 1.0f;
		ATTACK_DAMAGE_HIGH = 2.0f;
		ATTACK_ACCURACY = "40%";
		SPIDER_IDLE_VOL = 1;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 5;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/minispider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderMini_FirstThink();
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
		return SpiderMini_DispatchEvent(name, params)
			|| SpiderBaseScript::DispatchEvent(name, params);
	}
}
