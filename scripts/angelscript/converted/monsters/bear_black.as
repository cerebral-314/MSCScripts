#pragma context server

// Converted from monsters/bear_black.script by msc_transpiler.
// Black bear

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearBlack
{
	// Constants
	string ATTACK_DAMAGE = "$rand(5,7)";
	string ATTACK_HITCHANCE = "60%";
	string NPC_BASE_EXP = "40";
	string RETALIATE_CHANGETARGET_CHANCE = "50%";

	// Variables (an unset .script variable reads as its own name)
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";

	// unnamed block (first think)
	void BearBlack_FirstThink()
	{
		MOVE_RANGE = "70";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 200.0f;

		DROP_ITEM1 = "skin_bear"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "75%"; // base_monster - Chance of item drop #1
	}

	// npc_spawn
	void BearBlack_OnNpcSpawn(string npc = "")
	{
		SetHealth(140);
		// ov 150
		SetWidth(64);
		SetHeight(95);
		SetName("Black bear");
		SetHearingSensitivity(3);

		SetModel("monsters/bear.mdl");
		SetModelBody(0, 2);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base
		BearBlack_OnNpcSpawn(npc);
	}

	// This file's events and timers by their .script names
	bool BearBlack_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_black"]
shared class BearBlackScript : BearBaseScript, BearBlack
{
	// Variables declared by included files, with the value they start with in this script
	BearBlackScript()
	{
		ATTACK_DAMAGE = "$rand(5,7)";
		ATTACK_HITCHANCE = "60%";
		RETALIATE_CHANGETARGET_CHANCE = "50%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bear.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearBlack_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BearBlack_DispatchEvent(name, params)
			|| BearBaseScript::DispatchEvent(name, params);
	}
}
