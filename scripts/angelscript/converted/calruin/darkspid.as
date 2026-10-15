#pragma context server

// Converted from calruin/darkspid.script by msc_transpiler.
// Spitting Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_spitting.as"

[script "calruin/darkspid"]
class Darkspid : SpiderSpittingScript
{
	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		SpiderSpitting_OnNpcSpawn(npc); // monsters/spider_spitting

		SetHealth(150);
		// ov 359
		SetWidth(64);
		SetHeight(64);

		SetName("Veneficus Umbra");
		SetHearingSensitivity(7);
		SetModel("monsters/fer_spider_large.mdl");
		SetModelBody(0, 2);

		SetDamageTaken("all", 0.8f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gspider.mdl");
		Precache("monsters/fer_spider_large.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SpiderSpittingScript::DispatchEvent(name, params);
	}
}
