#pragma context server

// Converted from monsters/anim_archer_hard_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_archer_hard_random.as"

[script "monsters/anim_archer_hard_fire"]
class AnimArcherHardFire : AnimArcherHardRandomScript
{
	// unnamed block (first think)
	void AnimArcherHardFire_FirstThink()
	{
		// 1=fire
		// 2=lightning
		// 3=ice
		// 4=poison
		ARMOR_TYPE = "1";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimArcherHardFire_FirstThink();
		AnimArcherHardRandom_FirstThink();
		AnimArcher_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
