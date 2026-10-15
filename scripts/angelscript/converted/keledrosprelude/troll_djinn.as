#pragma context server

// Converted from keledrosprelude/troll_djinn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/djinn_ice.as"

[script "keledrosprelude/troll_djinn"]
class TrollDjinn : DjinnIceScript
{
	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DjinnIce_OnNpcSpawn(npc); // monsters/djinn_ice
		SetName("Ice Djinn Ji-ax");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return DjinnIceScript::DispatchEvent(name, params);
	}
}
