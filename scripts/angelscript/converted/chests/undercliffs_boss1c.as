#pragma context server

// Converted from chests/undercliffs_boss1c.script by msc_transpiler.
// chests/undercliffs_chasm (minor) (pickchance:50%)
// chests/undercliffs_sekrat (unique) (pickchance:100%) [ie. "ravager chest"]
// chests/undercliffs_town (major) (pickchance:100%)
// chests/undercliffs_chasmkill (minor) (pickchance:50%)
// chests/undercliffs_temple (medium) (trapchance:100%,lockchance:100%)
// chests/undercliffs_boss1a (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss1b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss1c
// chests/undercliffs_boss2a (unique) (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss2b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss2c
// chests/undercliffs_boss3a (unique) (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss3b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss3c
// paramseg: set_req_pick;50;set_chance_trapped;50;set_chance_haspick;25;set_chest_glow

#include "runtime/ScriptEntity.as"
#include "converted/chests/undercliffs_boss1a.as"

[script "chests/undercliffs_boss1c"]
class UndercliffsBoss1c : UndercliffsBoss1aScript
{
}
