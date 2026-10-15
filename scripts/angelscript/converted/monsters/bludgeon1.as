#pragma context server

// Converted from monsters/bludgeon1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bludgeon.as"

[script "monsters/bludgeon1"]
class Bludgeon1 : BludgeonScript
{
	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		Bludgeon_OnMyTargetDied(offender); // monsters/bludgeon
		IS_JUMPING = false;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Bludgeon_OnNpcSpawn(npc); // monsters/bludgeon
		SetDamageTaken("holy", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BludgeonScript::DispatchEvent(name, params);
	}
}
