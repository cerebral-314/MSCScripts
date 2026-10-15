#pragma context server

// Converted from orc_for/boar2.script by msc_transpiler.
// same script, just adjusted for narrow passages

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar2.as"

[script "orc_for/boar2"]
class OrcForBoar2 : MonstersBoar2Script
{
	// Variables declared by included files, with the value they start with in this script
	OrcForBoar2()
	{
		BOAR_WIDTH2 = 32;
		DMG_GORE1 = 60;
	}

	// unnamed block (first think)
	void OrcForBoar2_FirstThink()
	{
		NPC_GIVE_EXP = 125.0f;

		FLEE_CHANCE = "10%";
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		MonstersBoar2_OnNpcPostSpawn(); // monsters/boar2
		// this is set in the base too (on spawn), so must reset here
		DROP_ITEM1 = "skin_boar_heavy"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "50%"; // base_monster - Chance of item drop #1

		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 100.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcForBoar2_FirstThink();
		MonstersBoar2_FirstThink();
		BoarBaseRemake_FirstThink();
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
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return MonstersBoar2Script::DispatchEvent(name, params);
	}
}
