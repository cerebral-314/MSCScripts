#pragma context server

// Converted from furion/dragoons/random_random_nm.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/furion/dragoons/dragoon.as"

[script "furion/dragoons/random_random_nm"]
class RandomRandomNm : DragoonScript
{
	// unnamed block (first think)
	void RandomRandomNm_FirstThink()
	{
		WEAPON = RandomInt(0, 5);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		RandomRandomNm_FirstThink();
		Dragoon_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
