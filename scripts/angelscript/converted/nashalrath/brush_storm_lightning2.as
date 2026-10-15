#pragma context server

// Converted from nashalrath/brush_storm_lightning2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_storm_brush.as"

[script "nashalrath/brush_storm_lightning2"]
class BrushStormLightning2 : BaseStormBrushScript
{
	// unnamed block (first think)
	// lightning made up of two brushes, texture render layer of clouds, and additive flickering clouds
	// this is the flickering layer
	void BrushStormLightning2_FirstThink()
	{
		SetUniqueName("brush_storm_lightning2");
	}

	// do_flicker
	void OnDoFlicker()
	{
		OnStormShow();
		CallEventDelayed(Random(0.1f, 0.5f), "callevent");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BrushStormLightning2_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_flicker") { OnDoFlicker(); return true; }
		return BaseStormBrushScript::DispatchEvent(name, params);
	}
}
