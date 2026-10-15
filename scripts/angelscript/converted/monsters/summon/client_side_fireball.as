#pragma context server

// Converted from monsters/summon/client_side_fireball.script by msc_transpiler.
// strange experiments may lead to spectacular spells without server crashes

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ClientSideFireball
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/client_side_fireball"]
shared class ClientSideFireballScript : ScriptEntity, ClientSideFireball
{
}
