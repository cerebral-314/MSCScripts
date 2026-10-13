#pragma context server

// Base class for MS-Script files converted to AngelScript.
//
// When a script such as "monsters/orc_flayer" spawns and the pak contains
// angelscript/converted/monsters/orc_flayer.as, the engine creates the class
// tagged [script "monsters/orc_flayer"] instead of parsing the .script file,
// then calls, in order:
//
//   Attach(host)     gives the object its ScriptHost (the entity's script host)
//   OnLoad()         load-time consts and setvars (the .script parser runs these before spawn)
//   DispatchEvent()  every event, by its .script name ("game_spawn", "npc_targetsighted", ...)
//   OnFirstThink()   the .script's unnamed { } blocks, which run on the first think after spawn
//
// GetLegacyVar/SetLegacyVar let the engine and unconverted scripts read and
// write this script's variables by their .script names ($get(x,scriptvar,'NAME')).
//
// Converted classes override the generated members; the methods below are the
// shared plumbing they call.
class ScriptEntity
{
	ScriptHost@ host;

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

	// Runs another event of this script by its .script name (callevent <name> ...)
	void CallEvent(const string &in name, const array<string>@ params = null)
	{
		host.CallEvent(name, params);
	}

	// Runs an event of this script after a delay (callevent <delay> <name>)
	void CallEventDelayed(float delay, const string &in name)
	{
		host.CallEventDelayed(delay, name);
	}

	// Runs an event on another entity's scripts (callexternal <target> <name> ...)
	void CallExternal(CBaseEntity@ target, const string &in name, const array<string>@ params = null)
	{
		array<string> args = { EntityId(target), name };
		AppendArgs(args, params);
		host.Command("callexternal", args);
	}

	// Same as above for the special targets "all", "players" and "gamemaster"
	void CallExternal(const string &in target, const string &in name, const array<string>@ params = null)
	{
		array<string> args = { target, name };
		AppendArgs(args, params);
		host.Command("callexternal", args);
	}

	// Adds a value to the entity's return buffer (return <value>); read by $func callers
	void Return(const string &in value)
	{
		host.Return(value);
	}

	// Runs a legacy command with already-evaluated arguments, for commands that
	// have no typed wrapper yet
	void LegacyCommand(const string &in name, const array<string>@ args = null)
	{
		host.Command(name, args);
	}

	// Evaluates a legacy $function with already-evaluated arguments
	string LegacyFunction(const string &in name, const array<string>@ args = null)
	{
		return host.Function(name, args);
	}

	private void AppendArgs(array<string>& args, const array<string>@ extra)
	{
		if (extra is null)
			return;
		for (uint i = 0; i < extra.length(); i++)
			args.insertLast(extra[i]);
	}
}
