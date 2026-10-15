#pragma context server

// Converted from a3/bookbat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/keledrosprelude/bat.as"

[script "a3/bookbat"]
class Bookbat : KeledrospreludeBatScript
{
	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BatBase_OnNpcSpawn(npc); // monsters/bat_base

		SetName("Lesser Firebat");
		SetHealth(25);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return KeledrospreludeBatScript::DispatchEvent(name, params);
	}
}
