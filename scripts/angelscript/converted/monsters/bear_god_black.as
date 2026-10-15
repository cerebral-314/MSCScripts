#pragma context server

// Converted from monsters/bear_god_black.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_god_random.as"

[script "monsters/bear_god_black"]
class BearGodBlack : BearGodRandomScript
{
	// Variables declared by included files, with the value they start with in this script
	BearGodBlack()
	{
		OVERRIDE_BEAR = true;
	}

	// unnamed block (first think)
	void BearGodBlack_FirstThink()
	{
		BEAR_TYPE = 3;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGodBlack_FirstThink();
		BearGodRandom_FirstThink();
		BearBaseGiant_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
