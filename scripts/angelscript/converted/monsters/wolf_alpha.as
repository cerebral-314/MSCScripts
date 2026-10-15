#pragma context server

// Converted from monsters/wolf_alpha.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/wolf_base.as"

[script "monsters/wolf_alpha"]
class WolfAlpha : WolfBaseScript
{
	// Constants
	bool AM_ALPHA = true;

	// unnamed block (first think)
	void WolfAlpha_FirstThink()
	{
		NPC_GIVE_EXP = 35.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WolfAlpha_FirstThink();
		WolfBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
