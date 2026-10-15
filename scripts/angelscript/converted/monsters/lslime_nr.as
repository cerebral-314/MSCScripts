#pragma context server

// Converted from monsters/lslime_nr.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/lslime.as"

[script "monsters/lslime_nr"]
class LslimeNr : LslimeScript
{
	// Constants
	bool ME_NO_WANDER = true;

	// Variables declared by included files, with the value they start with in this script
	LslimeNr()
	{
		SOUND_DEATH = "none"; // from monsters/base_npc
	}

	// unnamed block (first think)
	void LslimeNr_FirstThink()
	{
		HEAR_RANGE_PLAYER = "200";
		HEAR_RANGE_MAX = "200";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LslimeNr_FirstThink();
		Lslime_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
