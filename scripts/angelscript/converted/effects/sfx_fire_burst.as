#pragma context server

// Converted from effects/sfx_fire_burst.script by msc_transpiler.
// Thothie SEP2009_15
// Ring of flame sprites that starts on the ground and rolls outward

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SfxFireBurst
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/sfx_fire_burst"]
shared class SfxFireBurstScript : ScriptEntity, SfxFireBurst
{
}
