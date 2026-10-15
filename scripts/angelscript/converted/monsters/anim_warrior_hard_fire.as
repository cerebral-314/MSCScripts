#pragma context server

// Converted from monsters/anim_warrior_hard_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_warrior_hard_random.as"

[script "monsters/anim_warrior_hard_fire"]
class AnimWarriorHardFire : AnimWarriorHardRandomScript
{
	// unnamed block (first think)
	void AnimWarriorHardFire_FirstThink()
	{
		ARMOR_TYPE = "1";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimWarriorHardFire_FirstThink();
		AnimWarriorHardRandom_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
