#pragma context server

// Converted from monsters/wraith.script by msc_transpiler.
// backwards way to do this, but I just happened to make them in this order

#include "runtime/ScriptEntity.as"
#include "converted/monsters/wraith_summoned.as"

[script "monsters/wraith"]
class Wraith : WraithSummonedScript
{
	// Variables declared by included files, with the value they start with in this script
	Wraith()
	{
		NOT_SUMMONED = true;
	}

	// unnamed block (first think)
	void Wraith_FirstThink()
	{
		I_AM_TURNABLE = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wraith_FirstThink();
		WraithSummoned_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseNoclip_FirstThink();
	}
}
