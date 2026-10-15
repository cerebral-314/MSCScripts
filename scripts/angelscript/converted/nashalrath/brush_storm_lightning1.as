#pragma context server

// Converted from nashalrath/brush_storm_lightning1.script by msc_transpiler.
// lightning made up of two brushes, texture render layer of clouds, and additive flickering clouds
// this is the texture layer

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_storm_brush.as"

[script "nashalrath/brush_storm_lightning1"]
class BrushStormLightning1 : BaseStormBrushScript
{
	// Variables declared by included files, with the value they start with in this script
	BrushStormLightning1()
	{
		BASE_RENDERAMT = 180;
	}

	// unnamed block (first think)
	void BrushStormLightning1_FirstThink()
	{
		SetUniqueName("brush_storm_lightning1");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BrushStormLightning1_FirstThink();
	}
}
