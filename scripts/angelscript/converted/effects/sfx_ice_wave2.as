#pragma context server

// Converted from effects/sfx_ice_wave2.script by msc_transpiler.
// radial burst outwards

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SfxIceWave2
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/sfx_ice_wave2"]
shared class SfxIceWave2Script : ScriptEntity, SfxIceWave2
{
}
