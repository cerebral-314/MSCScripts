#pragma context server

// Converted from player/client/halos.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Halos
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/client/halos"]
shared class HalosScript : ScriptEntity, Halos
{
}
