#pragma context server

// Converted from monsters/firegiantghoul3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul_greater.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Firegiantghoul3
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/firegiantghoul3"]
shared class Firegiantghoul3Script : FiregiantghoulGreaterScript, Firegiantghoul3
{
}
