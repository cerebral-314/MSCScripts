#pragma context server

// Converted from calruin/rat.script by msc_transpiler.
// Calruin rat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/giantrat.as"

[script "calruin/rat"]
class CalruinRat : MonstersGiantratScript
{
	// Variables (an unset .script variable reads as its own name)
	string MY_ENEMY = "enemy";

	// Variables declared by included files, with the value they start with in this script
	CalruinRat()
	{
		ATTACK_HITCHANCE = "55%";
	}

	// unnamed block (first think)
	void CalruinRat_FirstThink()
	{
		MOVE_RANGE = "50";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITCHANCE = "55%";
		MY_ENEMY = "enemy";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersGiantrat_OnNpcSpawn(npc); // monsters/giantrat

		SetHealth(45);
		SetFieldOfView(270);
		SetWidth(32);
		SetHeight(32);
		SetName("Corpse eater");
		SetRoam(true);
		SetHearingSensitivity(4);
		NPC_GIVE_EXP = 20.0f;
		SetRace("vermin");
		SetStepSize(16);

		SetModel("monsters/giant_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// bite1
	void OnBite1()
	{
		MonstersGiantrat_OnBite1(); // monsters/giantrat

		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(3.5f, 5), ATTACK_HITCHANCE);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersGiantrat_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		CalruinRat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MonstersGiantratScript::DispatchEvent(name, params);
	}
}
