#pragma context server

// Converted from NPCs/dwarf_lantern_still.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/dwarf_lantern.as"

[script "NPCs/dwarf_lantern_still"]
class DwarfLanternStill : DwarfLanternScript
{
	// Variables declared by included files, with the value they start with in this script
	DwarfLanternStill()
	{
		NO_WANDER = true;
	}

	// dwarf_spawn
	void OnDwarfSpawn()
	{
		SetRoam(false);
		OnSetNpcTurret();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dwarf_spawn") { OnDwarfSpawn(); return true; }
		return DwarfLanternScript::DispatchEvent(name, params);
	}
}
