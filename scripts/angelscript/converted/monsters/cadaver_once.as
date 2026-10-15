#pragma context server

// Converted from monsters/cadaver_once.script by msc_transpiler.
// Cadaver

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/cadaver_once"]
class CadaverOnce : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 14.0f;
	float ATTACK_DAMAGE_HIGH = 17.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	CadaverOnce()
	{
		SKEL_HP = 150;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void CadaverOnce_FirstThink()
	{
		NPC_GIVE_EXP = 48.0f;

		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 3;
		DROP_GOLD_MAX = 11;
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Ghastly Knight");
		SetRoam(true);
		SetHearingSensitivity(3);
		SetModelBody(0, 5);
		SetModelBody(1, 4);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		CadaverOnce_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
