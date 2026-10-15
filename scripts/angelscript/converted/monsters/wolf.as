#pragma context server

// Converted from monsters/wolf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/wolf_base.as"

[script "monsters/wolf"]
class Wolf : WolfBaseScript
{
	// Constants
	string NPC_PET_SCRIPT = "monsters/companion/pet_wolf";

	// Variables (an unset .script variable reads as its own name)
	string NPC_PET_TYPE = "NPC_PET_TYPE";

	// unnamed block (first think)
	void Wolf_FirstThink()
	{
		NPC_GIVE_EXP = 30.0f;
		NPC_PET_TYPE = "wolf"; // tells charm that this can be tamed
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wolf_FirstThink();
		WolfBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
