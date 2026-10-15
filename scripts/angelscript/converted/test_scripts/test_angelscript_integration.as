#pragma context server

// Converted from test_scripts/test_angelscript_integration.script by msc_transpiler.
// Test script to verify AngelScript integration
// This will attempt to call AngelScript functions from the legacy script system

#include "runtime/ScriptEntity.as"

[script "test_scripts/test_angelscript_integration"]
class TestAngelscriptIntegration : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	int AS_TEST_STAGE = 0;

	// game_spawn
	void TestAngelscriptIntegration_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		AS_TEST_STAGE = 0;

		CallEventDelayed(1.0f, "test_angelscript_init");
	}

	// game_spawn
	void TestAngelscriptIntegration_OnGameSpawn_2(string playerRace = "", string playerGender = "")
	{
		SetName("AS Integration Tester");
		SetHealth(1);
		SetRace("beloved");
		SetWidth(1);
		SetHeight(1);
		SetGravity(0);
		SetInvincible(true);
		LegacyCommand("invisible", 1);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		TestAngelscriptIntegration_OnGameSpawn(playerRace, playerGender);
		TestAngelscriptIntegration_OnGameSpawn_2(playerRace, playerGender);
	}

	// test_angelscript_init
	void OnTestAngelscriptInit()
	{
		AS_TEST_STAGE = 1;
		ServerCommand("echo === Testing AngelScript Module System ===");

		// Check if AngelScript is initialized
		if (Truthy(Eval("game.script.angelscript_initialized")))
		{
			ServerCommand("echo [PASS] AngelScript engine is initialized");
			OnTestModules();
		}
		else
		{
			ServerCommand("echo [FAIL] AngelScript engine NOT initialized!");
			ServerCommand("echo Please ensure ASBindings::RegisterAll() was called during server startup");
		}
	}

	// test_modules
	void OnTestModules()
	{
		AS_TEST_STAGE = 2;
		ServerCommand("echo === Testing AngelScript Modules ===");

		// Test if modules can be loaded
		OnAsLoadModule("GameMaster.as");
		CallEventDelayed(0.5f, "as_load_module");
		CallEventDelayed(1.0f, "as_load_module");
		CallEventDelayed(1.5f, "as_load_module");

		CallEventDelayed(3.0f, "test_functions");
	}

	// as_load_module
	void OnAsLoadModule(string moduleFile = "")
	{
		ServerCommand("echo Testing module: L_MODULE_NAME");

		// This would need to call into the AngelScript system
		// For now, we'll check if the module exists in the file system
		if (Eval("game.script.module_exists") == ")")
			ServerCommand("echo [PASS] Module found: L_MODULE_NAME");
		else
			ServerCommand("echo [FAIL] Module NOT found: L_MODULE_NAME");
	}

	// test_functions
	void OnTestFunctions()
	{
		AS_TEST_STAGE = 3;
		ServerCommand("echo === Testing AngelScript Functions ===");

		// Test calling AngelScript functions
		// These would need C++ bindings to actually work
		ServerCommand("echo Testing MS::InitializeGameMaster()...");
		OnAsCallFunction("MS::InitializeGameMaster");

		ServerCommand("echo Testing MS::GetMagicHandScripts()...");
		CallEventDelayed(0.5f, "as_call_function");

		CallEventDelayed(2.0f, "test_complete");
	}

	// as_call_function
	void OnAsCallFunction(string methodName = "", string methodArg = "")
	{
		ServerCommand("echo Calling AngelScript function: L_FUNC_NAME");

		// This would need actual C++ integration
		// For testing, we'll simulate the call
		if (Contains(methodName, "\"Initialize\""))
			ServerCommand("echo [SIMULATED] Function would initialize system");
		else if (Contains(methodName, "\"GetMagic\""))
			ServerCommand("echo [SIMULATED] Function would return magic hand scripts");
	}

	// test_complete
	void OnTestComplete()
	{
		ServerCommand("echo === AngelScript Integration Test Complete ===");
		ServerCommand("echo Test stages completed: AS_TEST_STAGE / 3");

		// Clean up
		CallEventDelayed(2.0f, "removeme");
	}

	// removeme
	void OnRemoveme()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "as_call_function") { OnAsCallFunction(Param(params, 0), Param(params, 1)); return true; }
		if (name == "as_load_module") { OnAsLoadModule(Param(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "removeme") { OnRemoveme(); return true; }
		if (name == "test_angelscript_init") { OnTestAngelscriptInit(); return true; }
		if (name == "test_complete") { OnTestComplete(); return true; }
		if (name == "test_functions") { OnTestFunctions(); return true; }
		if (name == "test_modules") { OnTestModules(); return true; }
		return false;
	}
}
