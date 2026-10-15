#pragma context server

// Converted from monsters/bandit_boss_sword.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_boss.as"

[script "monsters/bandit_boss_sword"]
class BanditBossSword : BanditBossScript
{
	// Constants
	bool BOSS_TYPE_OVERRIDE = true;

	// Variables declared by included files, with the value they start with in this script
	BanditBossSword()
	{
		BOSS_TYPE = 4;
	}
}
