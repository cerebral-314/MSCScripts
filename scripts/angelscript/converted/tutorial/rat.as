#pragma context server

// Converted from tutorial/rat.script by msc_transpiler.
// Giving a rat a key, lulz. CMD

#include "runtime/ScriptEntity.as"
#include "converted/monsters/giantrat.as"

[script "tutorial/rat"]
class TutorialRat : MonstersGiantratScript
{
	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		// Thothie: angry rat - no confusing skin drop
		HUNT_AGRO = "1";
		ORIG_HUNT_AGRO = "1";
		DROP_ITEM1_CHANCE = "0%"; // Used by base_monster
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersGiantrat_OnNpcSpawn(npc); // monsters/giantrat

		SetHealth(4);
		// ov 150
		SetWidth(32);
		SetHeight(32);
		SetName("Angry Giant Rat");
		SetRoam(true);
		SetHearingSensitivity(10);
		NPC_GIVE_EXP = 3.0f;
		SetRace("demon");

		SetModel("monsters/giant_rat.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MonstersGiantratScript::DispatchEvent(name, params);
	}
}
