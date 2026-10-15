#pragma context server

// Converted from monsters/hawk.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/hawk"]
class Hawk : ScriptEntity
{
	// unnamed block (first think)
	void Hawk_FirstThink()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Hawk_FirstThink();
	}
}
