#pragma context server

// Converted from monsters/anim_warrior_hard_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_warrior_hard_random.as"

[script "monsters/anim_warrior_hard_lightning"]
class AnimWarriorHardLightning : AnimWarriorHardRandomScript
{
	// unnamed block (first think)
	void AnimWarriorHardLightning_FirstThink()
	{
		ARMOR_TYPE = "2";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimWarriorHardLightning_FirstThink();
		AnimWarriorHardRandom_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
