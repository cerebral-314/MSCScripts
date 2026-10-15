#pragma context server

// Converted from monsters/k_alcolyte_blue.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_alcolyte.as"

[script "monsters/k_alcolyte_blue"]
class KAlcolyteBlue : KAlcolyteScript
{
	// Constants
	int OVERRIDE_TYPE = 1;

	// unnamed block (first think)
	void KAlcolyteBlue_FirstThink()
	{
		ALCO_TYPE = "4";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KAlcolyteBlue_FirstThink();
		KAlcolyte_FirstThink();
		KAlcolyte_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
