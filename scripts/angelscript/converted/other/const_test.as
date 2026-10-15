#pragma context server

// Converted from other/const_test.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/const_test_inc.as"

[script "other/const_test"]
class ConstTest : ConstTestIncScript
{
	// Variables declared by included files, with the value they start with in this script
	ConstTest()
	{
		TOP_CONST = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(0.1f, "say_const");
		CallEventDelayed(1.0f, "ext_change_const");
	}

	// say_const
	void OnSayConst()
	{
		// This works!
		SayText("The constants are (top) " + Text(TOP_CONST) + " and (bottom) " + BOTTOM_CONST);
	}

	// ext_change_const
	void OnExtChangeConst()
	{
		SayText("The changed to (top) " + Text(TOP_CONST) + " and (bottom) " + BOTTOM_CONST);
		SayText("Scriptvar (top) " + ScriptVarOf(ENT_ME, "TOP_CONST") + " and (bottom) " + ScriptVarOf(ENT_ME, "BOTTOM_CONST"));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_change_const") { OnExtChangeConst(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_const") { OnSayConst(); return true; }
		return ConstTestIncScript::DispatchEvent(name, params);
	}
}
