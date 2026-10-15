#pragma context server

// Converted from edanas/sewerrat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/giantrat.as"

[script "edanas/sewerrat"]
class Sewerrat : MonstersGiantratScript
{
	// Variables declared by included files, with the value they start with in this script
	Sewerrat()
	{
		ATTACK_DAMAGE = "0.9";
		ATTACK_HITCHANCE = "55%";
	}

	// unnamed block (first think)
	void Sewerrat_FirstThink()
	{
		ATTACK_RANGE = 70.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(15);
		// ov 180
		SetWidth(40);
		SetHeight(64);
		SetName("Sewer Rat");
		SetRoam(true);
		SetHearingSensitivity(1);
		SetSkillLevel(6);
		SetRace("demon"); // for ease of placement

		SetModel("monsters/giant_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Sewerrat_FirstThink();
		MonstersGiantrat_FirstThink();
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
		return MonstersGiantratScript::DispatchEvent(name, params);
	}
}
