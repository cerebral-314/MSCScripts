#pragma context server

// Converted from monsters/summon/npc_acid_cloud.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/npc_poison_cloud.as"

[script "monsters/summon/npc_acid_cloud"]
class NpcAcidCloud : NpcPoisonCloudScript
{
	// Variables declared by included files, with the value they start with in this script
	NpcAcidCloud()
	{
		AOE_SCAN_TYPE = "noscan";
	}

	// aoe_scan_loop
	void OnAoeScanLoop()
	{
		BaseAoe2_OnAoeScanLoop(); // monsters/summon/base_aoe2

		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, MY_BASE_DAMAGE, 0, MY_OWNER, MY_OWNER, "spellcasting.affliction", "acid");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_scan_loop") { OnAoeScanLoop(); return true; }
		return NpcPoisonCloudScript::DispatchEvent(name, params);
	}
}
