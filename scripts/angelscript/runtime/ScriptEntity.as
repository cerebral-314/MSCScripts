#pragma context server

#include "runtime/Legacy.as"
#include "runtime/Commands.as"
#include "runtime/Functions.as"

// Base class for MS-Script files converted to AngelScript.
//
// When a script such as "monsters/orc_flayer" spawns and the pak contains
// angelscript/converted/monsters/orc_flayer.as, the engine creates the class
// tagged [script "monsters/orc_flayer"] instead of parsing the .script file,
// then calls, in order:
//
//   Attach(host)     gives the object its ScriptHost (the entity's script host)
//   OnLoad()         load-time work the .script parser did (precaching, starting timers)
//   DispatchEvent()  every event, by its .script name ("game_spawn", "npc_targetsighted", ...)
//   OnFirstThink()   the .script's unnamed { } blocks, which run on the first think after spawn
//
// GetLegacyVar/SetLegacyVar let the engine and unconverted scripts read and
// write this script's variables by their .script names ($get(x,scriptvar,'NAME')).
//
// The .script commands and $functions are methods from LegacyCommands and
// LegacyFunctions (generated from the transpiler's mapping table).
class ScriptEntity : LegacyCommands, LegacyFunctions
{
	ScriptHost@ host;

	// game.script.iteration inside a calleventloop
	int loopIteration = 0;

	void Attach(ScriptHost@ scriptHost)
	{
		@host = scriptHost;
	}

	void OnLoad() {}
	void OnFirstThink() {}

	bool DispatchEvent(const string &in name, const array<string> &in params)
	{
		return false;
	}

	bool GetLegacyVar(const string &in name, string &out value)
	{
		return false;
	}

	bool SetLegacyVar(const string &in name, const string &in value)
	{
		return false;
	}

	// The entity this script runs on (ent_me)
	CBaseEntity@ get_self() property
	{
		return host.entity;
	}

	// ---- Events -------------------------------------------------------------------------

	// callevent <name> [params] - runs every handler of that event in this script
	void CallEvent(const string &in name, const array<string>@ params = null)
	{
		host.CallEvent(name, params);
	}

	// callevent <delay> <name> - parameters of delayed calls are not kept
	void CallEventDelayed(float delay, const string &in name)
	{
		host.CallEventDelayed(delay, name);
	}

	// callevent <value> ... where the first value decides at run time:
	// a number delays the call, anything else is the event name
	void CallEventOrDelay(const string &in first, const array<string>@ rest = null)
	{
		array<string> args = { first };
		AppendArgs(args, rest);
		host.Command("callevent", args);
	}

	// callexternal <target> <name> [params] - an event on another entity's scripts
	// (target may also be "all", "players" or "gamemaster")
	void CallExternal(const string &in target, const string &in name, const array<string>@ params = null)
	{
		array<string> args = { target, name };
		AppendArgs(args, params);
		host.Command("callexternal", args);
	}

	// $func(<name>, params...) for events whose result is decided at run time
	string CallFunction(const string &in name, const array<string>@ params = null)
	{
		return host.CallFunction(name, params);
	}

	// return <value> from an event that has no typed result
	void Return(const string &in value)
	{
		host.Return(value);
	}

	// ---- Variables by .script name ---------------------------------------------------------

	// A script variable that is not a field here: set by another included file, the engine,
	// or under a name built at run time. An unset variable reads as its own name.
	string GetVar(const string &in name)
	{
		return host.GetVar(name);
	}

	void SetVar(const string &in name, const string &in value)
	{
		host.SetVar(name, value);
	}

	// setvarg - a variable shared by every script on the server
	void SetGlobal(const string &in name, const string &in value)
	{
		host.Command("setvarg", { name, value });
	}

	// local reg.* values read by commands such as menuitem.register
	void SetLocal(const string &in name, const string &in value)
	{
		host.SetLocal(name, value);
	}

	string GetLocal(const string &in name)
	{
		return host.GetLocal(name);
	}

	// A .script token evaluated as the interpreter would (game.*, const.*, $f(...))
	string Eval(const string &in expression)
	{
		return host.Eval(expression);
	}

	// ---- Entities -----------------------------------------------------------------------------

	// $get(<entity>,<property>[,<option>...])
	string GetProp(const string &in entity, const string &in prop)
	{
		return host.Function("get", { entity, prop });
	}

	string GetProp(const string &in entity, const string &in prop, const string &in option)
	{
		return host.Function("get", { entity, prop, option });
	}

	string GetProp(const string &in entity, const string &in prop, const string &in option, const string &in option2)
	{
		return host.Function("get", { entity, prop, option, option2 });
	}

	// ---- Menus ----------------------------------------------------------------------------------

	// menuitem.register: adds an item to the menu being built in game_menu_getoptions
	void RegisterMenuItem(const MenuItem &in item)
	{
		SetMenuValue("reg.mitem.id", item.id);
		SetMenuValue("reg.mitem.title", item.title);
		SetMenuValue("reg.mitem.type", item.type);
		SetMenuValue("reg.mitem.data", item.data);
		SetMenuValue("reg.mitem.callback", item.callback);
		SetMenuValue("reg.mitem.cb_failed", item.cb_failed);
		SetMenuValue("reg.mitem.priority", item.priority);
		host.Command("menuitem.register");
	}

	private void SetMenuValue(const string &in name, const string &in value)
	{
		if (!value.isEmpty())
			host.SetLocal(name, value);
	}

	// ---- Anything without a typed wrapper yet -----------------------------------------------

	// A .script command with already-evaluated arguments
	void LegacyCommand(const string &in name, const array<string>@ args = null)
	{
		host.Command(name, args);
	}

	// A $function with already-evaluated arguments
	string LegacyFunction(const string &in name, const array<string>@ args = null)
	{
		return host.Function(name, args);
	}

	// Precache a model (models/...), sprite (sprites/...) or sound
	void Precache(const string &in file)
	{
		host.Precache(file);
	}

	private void AppendArgs(array<string>& args, const array<string>@ extra)
	{
		if (extra is null)
			return;
		for (uint i = 0; i < extra.length(); i++)
			args.insertLast(extra[i]);
	}
}
