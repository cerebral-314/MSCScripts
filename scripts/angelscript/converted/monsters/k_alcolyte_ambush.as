#pragma context server

// Converted from monsters/k_alcolyte_ambush.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_alcolyte.as"

[script "monsters/k_alcolyte_ambush"]
class KAlcolyteAmbush : KAlcolyteScript
{
	// Constants
	bool NPC_PROX_ACTIVATE = true;
	string NPC_PROXACT_RANGE = "512";
	string NPC_PROXACT_EVENT = "ambush";
	bool NPC_PROXACT_IFSEEN = true;
	bool NPC_PROXACT_FOV = true;
	int NPC_PROXACT_CONE = 90;
	bool I_POUNCE = true;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KAlcolyte_OnNpcSpawn(npc); // monsters/k_alcolyte
		// callevent npcatk_suspend_ai
		SetRoam(false);
	}

	// run_mode
	void OnRunMode()
	{
		KAlcolyte_OnRunMode(); // monsters/k_alcolyte
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "run_mode") { OnRunMode(); return true; }
		return KAlcolyteScript::DispatchEvent(name, params);
	}
}
