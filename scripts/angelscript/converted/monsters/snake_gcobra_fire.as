#pragma context server

// Converted from monsters/snake_gcobra_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/snake_gcobra.as"

[script "monsters/snake_gcobra_fire"]
class SnakeGcobraFire : SnakeGcobraScript
{
	// Variables declared by included files, with the value they start with in this script
	SnakeGcobraFire()
	{
		NPC_BASE_EXP = "200";
		MONSTER_MODEL = "monsters/gcobra_fire.mdl";
		DMG_EFFECT_SCRIPT = "effects/dot_fire";
		BREATH_EFFECT_SCRIPT = "effects/dot_fire";
		POISON_DAMAGE = "30.0";
		POISON_DURATION = "10.0";
		PUSH_BREATH = true;
		CL_SCRIPT = "monsters/snake_gcobra_fire_cl";
		FIRE_BREATH = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SnakeGcobra_OnNpcSpawn(npc); // monsters/snake_gcobra
		SetName("Fire Cobra");
		SetDamageTaken("fire", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("explode1.spr");
		Precache("monsters/gcobra_fire.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SnakeGcobraScript::DispatchEvent(name, params);
	}
}
