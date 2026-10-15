#pragma context server

// Converted from monsters/slime_black_large.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/slime_black_base.as"

[script "monsters/slime_black_large"]
class SlimeBlackLarge : SlimeBlackBaseScript
{
	// unnamed block (first think)
	void SlimeBlackLarge_FirstThink()
	{
		SetName("Large Black Pudding");
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
		SlimeBlackLarge_FirstThink();
	}
}
