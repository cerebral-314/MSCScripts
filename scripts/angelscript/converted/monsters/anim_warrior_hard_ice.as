#pragma context server

// Converted from monsters/anim_warrior_hard_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_warrior_hard_random.as"

[script "monsters/anim_warrior_hard_ice"]
class AnimWarriorHardIce : AnimWarriorHardRandomScript
{
	// unnamed block (first think)
	void AnimWarriorHardIce_FirstThink()
	{
		ARMOR_TYPE = "3";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimWarriorHardIce_FirstThink();
		AnimWarriorHardRandom_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
