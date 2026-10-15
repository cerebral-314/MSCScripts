#pragma context server

// Converted from effects/sfx_lightning_shield.script by msc_transpiler.
// Lightning shield client effect
// <model_idx> <radius> <duration> <v_adjust> [constant:0|1]
// - Can either be a temporary effect that is only visible when enemies get near
// - Or a sustained effect
// - In the case of constant effect, it needs to be toggled when zapping by updating lshield_on
// - If constant, it recomended that the client fx be removed and renewed every 10-20 seconds, in case client indexes change
// - If constant, set the duration to just over the refresh/renew rate
// ( ALL OF THE ABOVE IS HANDLED IN monsters/base_lightning_shield )

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SfxLightningShield
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/sfx_lightning_shield"]
shared class SfxLightningShieldScript : ScriptEntity, SfxLightningShield
{
}
