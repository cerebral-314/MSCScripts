#pragma context server

// Converted from monsters/debug.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Debug
{
	// Variables (an unset .script variable reads as its own name)
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";

	// bd_debug
	// in game format:
	// tdebug (for all mobs) or tdebugt (for current target)
	// tdebug <var> - returns variable
	// tdebug <var> <prop> - returns $get property variable ala $get(<var>,<prop>) [eg. ent_me maxhp]
	// tdebug <var> <prop> <prop> - returns $get property variable ala $get(<var>,<proc>,<prop>) [eg. ent_me scriptvar NPCATK_TARGET]
	// tdebug array <array_name> <idx> - returns array element
	// tdebug garray <array_name> <idx> - returns global array element
	// tdebug darray <array_name> - dumps entire array contents to console
	// tdebug dgarray <array_name> - dumps entire global array contents to console
	// <caller> [type:array|var] <params...>
	void Debug_OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "")
	{
		bool processed = false;

		string extraEvent = "none";

		string outMsg = NameOf(ENT_ME) + "[" + IndexOf(ENT_ME) + "]: ";

		if (varType == "array")
		{
			outMsg += "Array " + varName + "#" + key + " is " + GetArray(varName, key);
			processed = true;
		}
		if (varType == "garray")
		{
			outMsg += "g_Array " + varName + "#" + key + " is " + GetGlobalArray(varName, key);
			processed = true;
		}
		if (varType == "darray")
		{
			outMsg += "Dumping Array: " + varName;
			DUMP_ARRAY_NAME = varName;
			DUMP_ARRAY_GLOBAL = false;
			DUMP_ARRAY_CALLER = caller;
			extraEvent = "dbg_dump_array";
			processed = true;
		}
		if (varType == "dgarray")
		{
			outMsg += "Dumping Global Array: " + varName;
			DUMP_ARRAY_NAME = varName;
			DUMP_ARRAY_GLOBAL = true;
			DUMP_ARRAY_CALLER = caller;
			extraEvent = "dbg_dump_array";
			processed = true;
		}
		if (varType == "var")
		{
			outMsg += "var " + varName + " prop " + GetProp(varName, key);
			processed = true;
		}

		if (!processed)
		{
			// assume val
			if (varType.isEmpty())
			{
				outMsg += "exists";
			}
			else
			{
				outMsg += varType;
				if (!varName.isEmpty() && key.isEmpty())
					outMsg += "->" + varName + "=" + GetProp(varType, varName);
				if (!key.isEmpty())
					outMsg += "->" + varName + "[" + key + "]=" + GetProp(varType, varName, key);
			}

			// stradd L_OUT_MSG ","
			// stradd L_OUT_MSG $get(PARAM2,PARAM3)
			// local L_PROP $get(PARAM2,PARAM3)
			// stradd L_OUT_MSG "->"
			// stradd L_OUT_MSG PARAM4
			// stradd L_OUT_MSG "="
			// stradd L_OUT_MSG $get(L_PROP,PARAM4)
			// stradd L_OUT_MSG " (scriptvar:"
			// stradd L_OUT_MSG $get(L_PROP,scriptvar,PARAM4)
			// stradd L_OUT_MSG ")"
			processed = true;
		}

		// consolemsg L_DEBUG_CALLER direct: L_OUT_MSG //temporary
		CallExternal(caller, "ext_debug_que", outMsg);
		if (extraEvent == "none")
			return;
		CallEventOrDelay(extraEvent);
	}

	// dbg_dump_array
	void Debug_OnDbgDumpArray()
	{
		int nElements;
		if (DUMP_ARRAY_GLOBAL)
			nElements = GetGlobalArrayCount(DUMP_ARRAY_NAME);
		else
			nElements = GetArrayCount(DUMP_ARRAY_NAME);

		DebugPrint("dbg_dump_array " + nElements + " of " + DUMP_ARRAY_NAME + " to " + NameOf(DUMP_ARRAY_CALLER));

		for (int i = 0; i < nElements; i++)
		{
			loopIteration = i;
			OnDbgDumpArrayElements();
		}
	}

	// dbg_dump_array_elements
	void Debug_OnDbgDumpArrayElements()
	{
		string element;
		int curIdx = loopIteration;
		if (DUMP_ARRAY_GLOBAL)
			element = GetGlobalArray(DUMP_ARRAY_NAME, Text(curIdx));
		else
			element = GetArray(DUMP_ARRAY_NAME, Text(curIdx));
		string outMsg = "#" + curIdx + " " + element;
		CallExternal(DUMP_ARRAY_CALLER, "ext_debug_que", outMsg);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "") { Debug_OnBdDebug(caller, varType, varName, key); } // bd_debug
	void OnDbgDumpArray() { Debug_OnDbgDumpArray(); } // dbg_dump_array
	void OnDbgDumpArrayElements() { Debug_OnDbgDumpArrayElements(); } // dbg_dump_array_elements
	void OnLExtraEvent() {} // L_EXTRA_EVENT

	// This file's events and timers by their .script names
	bool Debug_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bd_debug") { OnBdDebug(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "dbg_dump_array") { OnDbgDumpArray(); return true; }
		if (name == "dbg_dump_array_elements") { OnDbgDumpArrayElements(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/debug"]
shared class DebugScript : ScriptEntity, Debug
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Debug_DispatchEvent(name, params);
	}
}
