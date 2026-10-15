#pragma context server

// Converted from monsters/bandit_boss_mace.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_boss.as"

[script "monsters/bandit_boss_mace"]
class BanditBossMace : BanditBossScript
{
	// Constants
	bool BOSS_TYPE_OVERRIDE = true;

	// Variables declared by included files, with the value they start with in this script
	BanditBossMace()
	{
		BOSS_TYPE = 2;
	}
}
