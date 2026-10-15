#pragma context server

// Converted from monsters/slime_black_huge.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/slime_black_base.as"

[script "monsters/slime_black_huge"]
class SlimeBlackHuge : SlimeBlackBaseScript
{
	// Constants
	bool NO_COMBAT_REPOS = true;
	string NPC_BASE_EXP = "150";

	// Variables declared by included files, with the value they start with in this script
	SlimeBlackHuge()
	{
		ATTACK_HITCHANCE = "80%";
		ANIM_RUN = "walk";
		CHILD_SCRIPT = "monsters/slime_black_large2";
		CHILD_DIST = 30;
	}

	// unnamed block (first think)
	void SlimeBlackHuge_FirstThink()
	{
		MOVE_RANGE = "50";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		ANIM_RUN = "walk"; // big slime is slower
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SlimeBlackBase_OnNpcSpawn(npc); // monsters/slime_black_base

		SetName("Huge Black Pudding");
		SetHealth(400);
		SetModel("monsters/slime_huge.mdl");
		SetRace("demon");
		SetRoam(true);
		NPC_GIVE_EXP = 150.0f;
	}

	// bite1
	void OnBite1()
	{
		// damage everyone in area
		OnNpcatkDodamage(Text(RelativePosition(Vector3(0, 0, 0))), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "0.0", "reflective", "acid");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime_large.mdl");
		Precache("monsters/slime.mdl");
		Precache("monsters/slime_huge.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBlackHuge_FirstThink();
		SlimeBlackBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SlimeBlackBaseScript::DispatchEvent(name, params);
	}
}
