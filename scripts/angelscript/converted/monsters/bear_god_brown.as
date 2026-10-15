#pragma context server

// Converted from monsters/bear_god_brown.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_god_random.as"

[script "monsters/bear_god_brown"]
class BearGodBrown : BearGodRandomScript
{
	// Variables declared by included files, with the value they start with in this script
	BearGodBrown()
	{
		OVERRIDE_BEAR = true;
	}

	// unnamed block (first think)
	void BearGodBrown_FirstThink()
	{
		BEAR_TYPE = 2;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGodBrown_FirstThink();
		BearGodRandom_FirstThink();
		BearBaseGiant_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
