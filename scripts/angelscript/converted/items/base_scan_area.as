#pragma context server

// Converted from items/base_scan_area.script by msc_transpiler.
// Thothie - lots of the spell scripts damage an area ever few seconds
// many are buggy in how they go about it
// hopeing to move them all over to a central system
// Required vars:
// setvard BSCAN_RADIUS 256 //radius to scan
// setvard BSCAN_OWNER	//defaults to PARAM1 of game_dynamically_Created but can be overriden
// const BSCAN_EVENT some_event //event to fire when target found <param1> will be target
// const BSCAN_ALLIES 1 //optional: set to 1 to affect allies to

#include "runtime/ScriptEntity.as"

[script "items/base_scan_area"]
class BaseScanArea : ScriptEntity
{
	// Constants
	Vector3 BSCAN_CENTER = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string BSCAN_OWNER = "BSCAN_OWNER";

	// game_dynamically_Created
	void OnGameDynamicallyCreated2(string owner = "")
	{
		BSCAN_OWNER = owner;
		CallEventDelayed(0.25f, "bscan_start_scan");
	}

	// bscan_start_scan
	void OnBscanStartScan()
	{
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bscan_start_scan") { OnBscanStartScan(); return true; }
		if (name == "game_dynamically_Created") { OnGameDynamicallyCreated2(Param(params, 0)); return true; }
		return false;
	}
}
