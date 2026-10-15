#pragma context server

// Converted from furion/dragoons/psn_random_nm.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/furion/dragoons/dragoon.as"

[script "furion/dragoons/psn_random_nm"]
class PsnRandomNm : DragoonScript
{
	// Variables declared by included files, with the value they start with in this script
	PsnRandomNm()
	{
		ELEMENT = "1";
	}

	// unnamed block (first think)
	void PsnRandomNm_FirstThink()
	{
		WEAPON = RandomInt(0, 5);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PsnRandomNm_FirstThink();
		Dragoon_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
