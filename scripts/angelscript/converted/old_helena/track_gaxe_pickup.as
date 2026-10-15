#pragma context server

// Converted from old_helena/track_gaxe_pickup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "old_helena/track_gaxe_pickup"]
class TrackGaxePickup : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	TrackGaxePickup()
	{
		EFFECT_ID = "track_gaxe";
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		SetGlobal("G_OLDHELENA_AXE_PICKED", 1);
	}

	// game_fall
	void OnGameFall()
	{
		SetGlobal("G_OLDHELENA_AXE_PICKED", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
