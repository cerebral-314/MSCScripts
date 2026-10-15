#pragma context server

// Converted from monsters/troll2.script by msc_transpiler.
// Temp Fix, cause I'm lazy

#include "runtime/ScriptEntity.as"
#include "converted/calruin/cavetroll2.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Troll2
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/troll2"]
shared class Troll2Script : Cavetroll2Script, Troll2
{
}
