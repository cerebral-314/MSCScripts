#pragma context server

// Converted from monsters/slime_black_large_nr.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/slime_black_base.as"

[script "monsters/slime_black_large_nr"]
class SlimeBlackLargeNr : SlimeBlackBaseScript
{
	// Constants
	bool ME_NO_WANDER = true;

	// unnamed block (first think)
	void SlimeBlackLargeNr_FirstThink()
	{
		HEAR_RANGE_MAX = "400";
		HEAR_RANGE_PLAYER = "300";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBlackLargeNr_FirstThink();
		SlimeBlackBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
