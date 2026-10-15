#pragma context server

// Converted from NPCs/stalker.script by msc_transpiler.
// Stalker script

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/stalker"]
class Stalker : BaseNpcScript
{
	// unnamed block (timer)
	// Follow someone
	void Stalker_Timer()
	{
		CallEventDelayed(0.5f, "Stalker_Timer");
		SetMoveDest(ENT_LASTSEEN, 128);
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(45);
		// ov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetSkillLevel(-5);
		SetName("Strange Person");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 5);
		SetMoveAnim("walk_scared");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(0.5f, "Stalker_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "Stalker_Timer") { Stalker_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
