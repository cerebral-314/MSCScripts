#pragma context server

// Converted from monsters/bandit_boss_nova.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_boss.as"

[script "monsters/bandit_boss_nova"]
class BanditBossNova : BanditBossScript
{
	// Constants
	bool BOSS_TYPE_OVERRIDE = true;

	// Variables declared by included files, with the value they start with in this script
	BanditBossNova()
	{
		BOSS_TYPE = 6;
	}
}
