#pragma context server

// Converted from monsters/grizzly.script by msc_transpiler.
// Temp Fix, cause I'm lazy (ie. include brown_bear)
// Thothie - think ya mean 'no fix' - since there is no brown_bear script! >< (Fixed that...)
// - using blackbear, turning brown, adding HP/dam
// - Grizzly is meaner than brownbear
// Brown bear

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base.as"

[script "monsters/grizzly"]
class Grizzly : BearBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Grizzly()
	{
		ATTACK_DAMAGE = "$rand(15,20)";
		ATTACK_HITCHANCE = "60%";
		RETALIATE_CHANGETARGET_CHANCE = "50%";
	}

	// unnamed block (first think)
	void Grizzly_FirstThink()
	{
		MOVE_RANGE = "70";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 130.0f;
		NPC_GIVE_EXP = 55.0f;

		DROP_ITEM1 = "skin_bear"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "75%"; // base_monster - Chance of item drop #1
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base

		SetHealth(200);
		// ov 150
		SetWidth(64);
		SetHeight(95);
		SetName("Grizzly");
		SetHearingSensitivity(5);

		SetModel("monsters/bear.mdl");
		SetModelBody(0, 1);
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
		Grizzly_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BearBaseScript::DispatchEvent(name, params);
	}
}
