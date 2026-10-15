#pragma context server

// Converted from monsters/bandit_elite_dagger.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_elite.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditEliteDagger
{
	// Constants
	string WEAPON = "1";
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_elite_dagger"]
shared class BanditEliteDaggerScript : BanditEliteScript, BanditEliteDagger
{
	// Variables declared by included files, with the value they start with in this script
	BanditEliteDaggerScript()
	{
		WEAPON = "1";
	}
}
