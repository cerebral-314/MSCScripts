#pragma context server

// Converted from monsters/bandit_hard_random.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_hard.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BanditHardRandom
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bandit_hard_random"]
shared class BanditHardRandomScript : BanditHardScript, BanditHardRandom
{
}
