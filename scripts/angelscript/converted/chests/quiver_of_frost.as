#pragma context server

// Converted from chests/quiver_of_frost.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_quiver_of.as"

[script "chests/quiver_of_frost"]
class QuiverOfFrost : BaseQuiverOfScript
{
	// Variables declared by included files, with the value they start with in this script
	QuiverOfFrost()
	{
		BQ_QUIVER_TYPE = "proj_arrow_frost";
		BQ_BUNDLE_SIZE = "60";
	}

	// unnamed block (first think)
	void QuiverOfFrost_FirstThink()
	{
		BQ_QUIVER_TYPE = "proj_arrow_frost";
		BQ_BUNDLE_SIZE = "60";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuiverOfFrost_FirstThink();
	}
}
