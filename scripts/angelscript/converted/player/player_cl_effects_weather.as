#pragma context server

// Converted from player/player_cl_effects_weather.script by msc_transpiler.
// Weather/TOD combo script by Thothie 10:50 AM 7/20/2010
// do not initiate weather at hours 6, 17, or 20 due to TOD change

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClEffectsWeather
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_effects_weather"]
shared class PlayerClEffectsWeatherScript : ScriptEntity, PlayerClEffectsWeather
{
}
