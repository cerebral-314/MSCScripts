#pragma context server

// Converted from deralia/commoner_sitting.script by msc_transpiler.
// *** Default human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "deralia/commoner_sitting"]
class CommonerSitting : BaseNpcScript
{
	// Constants
	bool NO_CHAT = true;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		// fov		180
		SetWidth(5);
		SetHeight(55);
		SetRace("human");
		SetName("Commoner");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetIdleAnim("coffee");
		SetMoveAnim("walk");
		SetInvincible(true);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
