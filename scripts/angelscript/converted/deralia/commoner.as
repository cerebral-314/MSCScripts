#pragma context server

// Converted from deralia/commoner.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/default_human.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Commoner
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "deralia/commoner"]
shared class CommonerScript : NPCsDefaultHumanScript, Commoner
{
}
