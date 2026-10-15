#pragma context server

// Converted from monsters/troll_stone.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/troll2.as"

[script "monsters/troll_stone"]
class TrollStone : Troll2Script
{
	// Variables declared by included files, with the value they start with in this script
	TrollStone()
	{
		IS_GUARDIAN = true;
	}

	// unnamed block (first think)
	void TrollStone_FirstThink()
	{
		IS_GUARDIAN = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollStone_FirstThink();
		Cavetroll2_FirstThink();
		MonstersTroll_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
