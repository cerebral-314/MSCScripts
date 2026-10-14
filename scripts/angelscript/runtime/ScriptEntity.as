#pragma context server

#include "runtime/Legacy.as"

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
// Fields of type bool, int, float, string and Vector3 are this script's variables:
// the engine and unconverted scripts read and write them by field name
// ($get(x,scriptvar,'NAME'), setvar from other scripts). Converted fields keep their
// .script names for that reason.
//
// The .script commands and $functions are global functions the engine registers from
// runtime/LegacyApi.txt (generated from the transpiler's mapping table): SetHealth(400),
// PlaySound(0, 10, "voice/hello.wav"), NameOf(player), ... They run on the script that calls
// them, and take numbers, vectors and entities as they are.
//
// The class is `shared`, so it is compiled once and every script module uses that copy.
shared class ScriptEntity
{
	ScriptHost@ host;

	// game.script.iteration inside a calleventloop
	int loopIteration = 0;

	// breakloop: the calleventloop running this stops after the current run
	bool breakLoop = false;

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

	// The entity this script runs on (ent_me)
	CBaseEntity@ get_self() property
	{
		return host.entity;
	}

	// Entity names the engine resolves relative to this entity
	string get_ENT_ME() const property { return "ent_me"; }
	string get_ENT_OWNER() const property { return "ent_owner"; }
	string get_ENT_TARGET() const property { return "ent_target"; }
	string get_ENT_LASTSEEN() const property { return "ent_lastseen"; }
	string get_ENT_LASTHEARD() const property { return "ent_lastheard"; }
	string get_ENT_LASTSPOKE() const property { return "ent_lastspoke"; }
	string get_ENT_LASTOFFERED() const property { return "ent_lastoffered"; }
	string get_ENT_LASTGAVE() const property { return "ent_lastgave"; }
	string get_ENT_LASTSTOLE() const property { return "ent_laststole"; }
	string get_ENT_LASTUSED() const property { return "ent_lastused"; }
	string get_ENT_LASTSTRUCK() const property { return "ent_laststruck"; }
	string get_ENT_LASTSTRUCKBYME() const property { return "ent_laststruckbyme"; }
	string get_ENT_LASTPROJECTILE() const property { return "ent_lastprojectile"; }
	string get_ENT_LASTCREATED() const property { return "ent_lastcreated"; }
	string get_ENT_CREATIONOWNER() const property { return "ent_creationowner"; }
	string get_ENT_EXPOWNER() const property { return "ent_expowner"; }
	string get_ENT_LOCALPLAYER() const property { return "ent_localplayer"; }
	string get_ENT_CURRENTPLAYER() const property { return "ent_currentplayer"; }

	// ---- Events -------------------------------------------------------------------------
	// (CallEvent, CallEventOrDelay, CallExternal and CallFunction are in LegacyApi.txt)

	// callevent <delay> <name> - parameters of delayed calls are not kept
	void CallEventDelayed(float delay, const string &in name)
	{
		host.CallEventDelayed(delay, name);
	}

	// return <value> from an event that has no typed result
	void Return(const string &in value)
	{
		host.Return(value);
	}

	// ---- Variables by .script name ---------------------------------------------------------
	// (SetVar, SetGlobal and SetLocal are in LegacyApi.txt)

	// A script variable that is not a field here: set by another included file, the engine,
	// or under a name built at run time. An unset variable reads as its own name.
	string GetVar(const string &in name)
	{
		return host.GetVar(name);
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

	// ---- Resources ------------------------------------------------------------------------------

	// Precache a model (models/...), sprite (sprites/...) or sound
	void Precache(const string &in file)
	{
		host.Precache(file);
	}
}
