#pragma context server

// Converted from monsters/anim_archer_hard_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_archer_hard_random.as"

[script "monsters/anim_archer_hard_ice"]
class AnimArcherHardIce : AnimArcherHardRandomScript
{
	// unnamed block (first think)
	void AnimArcherHardIce_FirstThink()
	{
		// 1=fire
		// 2=lightning
		// 3=ice
		// 4=poison
		ARMOR_TYPE = "3";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimArcherHardIce_FirstThink();
		AnimArcherHardRandom_FirstThink();
		AnimArcher_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
