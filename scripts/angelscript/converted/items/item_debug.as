#pragma context server

// Converted from items/item_debug.script by msc_transpiler.
// Item debuggary
// for some reason causing crashes for some players when in base_item_extras

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemDebug
{
	// Variables (an unset .script variable reads as its own name)
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";

	// item_debug2
	// <caller> [type:array|var] <params...>
	void ItemDebug_OnItemDebug2(string caller = "", string debugKind = "", string debugSource = "", string debugKey = "")
	{
		bool processed = false;

		if (!(GameTime() > 5.0f)) // make sure this doesn't go off during init
			return;

		if (!Truthy(ScriptVarOf(caller, "PLR_IN_WORLD"))) // make sure this doesn't go off during init (redundant)
			return;

		string outMsg = ItemNameOf(ENT_ME) + "[" + IndexOf(ENT_ME) + "]: ";

		if (debugKind == "array")
		{
			outMsg += "Array " + debugSource + "#" + debugKey + " is " + GetArray(debugSource, debugKey);
			processed = true;
		}
		if (debugKind == "var")
		{
			outMsg += "var " + debugSource + " prop " + GetProp(debugSource, debugKey);
			processed = true;
		}

		if (!processed)
		{
			// assume val
			if (debugKind.isEmpty())
			{
				outMsg += "exists";
			}
			else
			{
				outMsg += debugKind;
				if (!debugSource.isEmpty())
					outMsg += "->" + debugSource + "=" + GetProp(debugKind, debugSource);
				if (!debugKey.isEmpty())
				{
					outMsg += "," + GetProp(debugKind, debugSource);
					string prop = GetProp(debugKind, debugSource);
					outMsg += "->" + debugKey + "=" + GetProp(prop, debugKey) + " (scriptvar:" + ScriptVarOf(prop, debugKey) + ")";
				}
			}
		}

		// delay multiple cause to avoid flooding the callexternal message block
		if (GameTime() < Float(GetVar("G_NEXT_IDEBUG_CALL")))
		{
			BITEM_DEBUG_OUT = outMsg;
			BITEM_DEBUG_CALLER = caller;
			LegacyCommand("add", "G_NEXT_IDEBUG_CALL", 0.1f);
			CallEventDelayed(Float(GetVar("G_NEXT_IDEBUG_CALL")) - GameTime(), "item_debug_delay");
		}
		else
		{
			SetGlobal("G_NEXT_IDEBUG_CALL", GameTime());
			LegacyCommand("add", "G_NEXT_IDEBUG_CALL", 0.1f);
			CallExternal(caller, "ext_debug_que", outMsg);
		}
	}

	// item_debug_delay
	void ItemDebug_OnItemDebugDelay()
	{
		CallExternal(BITEM_DEBUG_CALLER, "ext_debug_que", BITEM_DEBUG_OUT);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnItemDebug2(string caller = "", string debugKind = "", string debugSource = "", string debugKey = "") { ItemDebug_OnItemDebug2(caller, debugKind, debugSource, debugKey); } // item_debug2
	void OnItemDebugDelay() { ItemDebug_OnItemDebugDelay(); } // item_debug_delay

	// This file's events and timers by their .script names
	bool ItemDebug_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "item_debug2") { OnItemDebug2(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "item_debug_delay") { OnItemDebugDelay(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/item_debug"]
shared class ItemDebugScript : ScriptEntity, ItemDebug
{
	// Variables every script that includes this file declares
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	bool IS_RESERVED = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ItemDebug_DispatchEvent(name, params);
	}
}
