#pragma context server

// Converted from monsters/slime_black_large2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/slime_black_base.as"

[script "monsters/slime_black_large2"]
class SlimeBlackLarge2 : SlimeBlackBaseScript
{
	// Constants
	string NPC_BASE_EXP = "80";

	// Variables declared by included files, with the value they start with in this script
	SlimeBlackLarge2()
	{
		CHILD_SCRIPT = "monsters/slime_black_small2";
	}

	// unnamed block (first think)
	void SlimeBlackLarge2_FirstThink()
	{
		SetName("Large Black Pudding");
		SetHealth(200);
		SetRace("demon");
		NPC_GIVE_EXP = 80.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBlackBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SlimeBlackLarge2_FirstThink();
	}
}
