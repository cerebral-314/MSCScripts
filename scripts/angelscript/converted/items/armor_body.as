#pragma context server

// Converted from items/armor_body.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/armor_body"]
class ArmorBody : ScriptEntity
{
	// unnamed block (first think)
	void ArmorBody_FirstThink()
	{
		// armor fix, fail
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ArmorBody_FirstThink();
	}
}
