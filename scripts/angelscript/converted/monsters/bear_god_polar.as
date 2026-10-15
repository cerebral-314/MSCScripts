#pragma context server

// Converted from monsters/bear_god_polar.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_god_random.as"

[script "monsters/bear_god_polar"]
class BearGodPolar : BearGodRandomScript
{
	// Variables declared by included files, with the value they start with in this script
	BearGodPolar()
	{
		OVERRIDE_BEAR = true;
	}

	// unnamed block (first think)
	void BearGodPolar_FirstThink()
	{
		BEAR_TYPE = 1;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGodPolar_FirstThink();
		BearGodRandom_FirstThink();
		BearBaseGiant_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
