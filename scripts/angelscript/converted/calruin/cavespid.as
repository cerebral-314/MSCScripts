#pragma context server

// Converted from calruin/cavespid.script by msc_transpiler.
// Cavern Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Cavespid
{
	// Constants
	int FIN_EXP = 20;
	string SPIDER_MODEL = "monsters/fer_spider.mdl";

	// npc_spawn
	void Cavespid_OnNpcSpawn(string npc = "")
	{
		SetHealth(85);
		SetName("Cave Spider");
		if (Contains(ToLowerCase(MapName()), "calruin"))
			SetName("Maisculus Araneu");
		if (Contains(ToLowerCase(MapName()), "deralia"))
			SetName("Maisculus Araneu");

		SetModelBody(0, 0);
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
		Spider_OnNpcSpawn(npc); // monsters/spider
		Cavespid_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool Cavespid_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/cavespid"]
shared class CavespidScript : SpiderScript, Cavespid
{
	// Variables declared by included files, with the value they start with in this script
	CavespidScript()
	{
		FIN_EXP = 20;
		SPIDER_MODEL = "monsters/fer_spider.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(4.0f, "Spider_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Cavespid_DispatchEvent(name, params)
			|| SpiderScript::DispatchEvent(name, params);
	}
}
