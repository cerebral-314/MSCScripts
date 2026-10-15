#pragma context server

// Converted from monsters/eagle.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/eagle_base.as"

[script "monsters/eagle"]
class Eagle : EagleBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Eagle()
	{
		NO_DIVE = true;
	}

	// unnamed block (first think)
	void Eagle_FirstThink()
	{
		NPC_GIVE_EXP = 100.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Eagle_FirstThink();
		EagleBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
