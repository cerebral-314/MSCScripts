#pragma context server

// Converted from helena/memorialguard.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/human_guard.as"

[script "helena/memorialguard"]
class Memorialguard : HumanGuardScript
{
	// Constants
	bool NO_CHAT = true;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuard_OnNpcSpawn(npc); // NPCs/human_guard

		SetName("Memorial Guard");
	}

	// helena_raid_end
	void OnHelenaRaidEnd()
	{
		SayText("All clear!");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "helena_raid_end") { OnHelenaRaidEnd(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return HumanGuardScript::DispatchEvent(name, params);
	}
}
