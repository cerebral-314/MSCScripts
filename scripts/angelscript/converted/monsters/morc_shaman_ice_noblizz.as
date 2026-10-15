#pragma context server

// Converted from monsters/morc_shaman_ice_noblizz.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/morc_shaman_ice.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MorcShamanIceNoblizz
{

	// make_blizzard
	void MorcShamanIceNoblizz_OnMakeBlizzard()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMakeBlizzard() { MorcShamanIceNoblizz_OnMakeBlizzard(); } // make_blizzard

	// This file's events and timers by their .script names
	bool MorcShamanIceNoblizz_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "make_blizzard") { OnMakeBlizzard(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/morc_shaman_ice_noblizz"]
shared class MorcShamanIceNoblizzScript : MorcShamanIceScript, MorcShamanIceNoblizz
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MorcShamanIceNoblizz_DispatchEvent(name, params)
			|| MorcShamanIceScript::DispatchEvent(name, params);
	}
}
