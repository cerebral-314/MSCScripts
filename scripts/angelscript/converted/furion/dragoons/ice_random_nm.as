#pragma context server

// Converted from furion/dragoons/ice_random_nm.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/furion/dragoons/dragoon.as"

[script "furion/dragoons/ice_random_nm"]
class IceRandomNm : DragoonScript
{
	// Variables declared by included files, with the value they start with in this script
	IceRandomNm()
	{
		ELEMENT = "0";
	}

	// unnamed block (first think)
	void IceRandomNm_FirstThink()
	{
		WEAPON = RandomInt(0, 5);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IceRandomNm_FirstThink();
		Dragoon_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
