#pragma context server

// Converted from dq/murmur.script by msc_transpiler.
// Thothie - supplied for backwards compatability
// - not as insane as original murmur

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base_giant.as"

[script "dq/murmur"]
class Murmur : BearBaseGiantScript
{
	// Variables declared by included files, with the value they start with in this script
	Murmur()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_NORMAL_DAMAGE = "40";
		ATTACK_STOMPRANGE = 250;
		ATTACK_STOMPDMG = 80;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Murmur_FirstThink()
	{
		ANIM_IDLE = "idle"; // This is a workaround
		ANIM_WALK = "walk"; // because I use these as variables
		ANIM_RUN = "run"; // while bear_base uses them as
		ANIM_ATTACK = "attack"; // consts
		NPC_GIVE_EXP = 110.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base
		BearBaseGiant_OnNpcSpawn(npc); // monsters/bear_base_giant

		SetHealth(1000);
		// fov 165
		SetName("Murmur");

		SetModelBody(0, 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Murmur_FirstThink();
		BearBaseGiant_FirstThink();
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
		return BearBaseGiantScript::DispatchEvent(name, params);
	}
}
