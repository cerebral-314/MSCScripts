#pragma context server

// Converted from monsters/slime_black_small2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/slime_black_small.as"

[script "monsters/slime_black_small2"]
class SlimeBlackSmall2 : SlimeBlackSmallScript
{
	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SlimeBlackSmall_OnNpcSpawn(npc); // monsters/slime_black_small
		SetRace("demon");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SlimeBlackSmallScript::DispatchEvent(name, params);
	}
}
