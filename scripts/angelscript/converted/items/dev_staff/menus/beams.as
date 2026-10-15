#pragma context server

// Converted from items/dev_staff/menus/beams.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Beams
{
	// Variables (an unset .script variable reads as its own name)
	string MENU_TYPE = "MENU_TYPE";
	string AFF_1 = "AFF_1";
	string AFF_2 = "AFF_2";
	string AFF_3 = "AFF_3";

	// menu_listbeams
	void Beams_OnMenuListbeams()
	{
		MenuItem menuItem;

		menuItem.title = "Set Beam Type";
		menuItem.type = "disabled";

		menuItem.title = "Physgun";
		menuItem.type = "callback";
		menuItem.callback = "set_beam_type";
		menuItem.data = "0";

		menuItem.title = "Remover";
		menuItem.type = "callback";
		menuItem.callback = "set_beam_type";
		menuItem.data = "1";

		menuItem.title = "Damager";
		menuItem.type = "callback";
		menuItem.callback = "set_beam_type";
		menuItem.data = "3";

		menuItem.title = "Afflicter";
		menuItem.type = "callback";
		menuItem.callback = "set_beam_type";
		menuItem.data = "2";
	}

	// set_beam_type
	void Beams_OnSetBeamType(string beamType = "", float beamMode = 0.0f)
	{
		CallExternal(MY_ITEM, "set_beam_type", Text(beamMode));

		if (beamMode == 2.0f)
		{
			MENU_TYPE = "2";
			CallEventDelayed(0.1f, "ext_menu_open");
		}
		else if (beamMode == 3.0f)
		{
			MENU_TYPE = "14";
			CallEventDelayed(0.1f, "ext_menu_open");
		}
	}

	// menu_listafflicttype
	void Beams_OnMenuListafflicttype()
	{
		MenuItem menuItem;

		menuItem.title = "Set Affliction Type";
		menuItem.type = "disabled";

		menuItem.title = "Fire";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "fire";

		menuItem.title = "Cold";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "cold";

		menuItem.title = "Lightning";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "lightning";

		menuItem.title = "Holy";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "holy";

		menuItem.title = "Poison";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "poison";

		menuItem.title = "Acid";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_type";
		menuItem.data = "acid";
	}

	// menu_listafflictduration
	void Beams_OnMenuListafflictduration()
	{
		MenuItem menuItem;

		menuItem.title = "Set Affliction Duration";
		menuItem.type = "disabled";

		menuItem.title = "5";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_duration";
		menuItem.data = "5";

		menuItem.title = "10";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_duration";
		menuItem.data = "10";

		menuItem.title = "15";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_duration";
		menuItem.data = "15";

		menuItem.title = "30";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_duration";
		menuItem.data = "30";
	}

	// menu_listafflictdmg
	void Beams_OnMenuListafflictdmg()
	{
		MenuItem menuItem;

		menuItem.title = "Set Affliction Damage";
		menuItem.type = "disabled";

		menuItem.title = "0.5";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "0.5";

		menuItem.title = "5";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "5";

		menuItem.title = "20";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "20";

		menuItem.title = "50";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "50";

		menuItem.title = "100";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "100";

		menuItem.title = "500";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "500";

		menuItem.title = "1000";
		menuItem.type = "callback";
		menuItem.callback = "set_afflict_dmg";
		menuItem.data = "1000";
	}

	// menu_damager_setdmg
	void Beams_OnMenuDamagerSetdmg()
	{
		MenuItem menuItem;

		menuItem.title = "Set Beam Damage";
		menuItem.type = "disabled";

		menuItem.title = "0.5";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "0.5";

		menuItem.title = "5";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "5";

		menuItem.title = "20";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "20";

		menuItem.title = "50";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "50";

		menuItem.title = "100";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "100";

		menuItem.title = "500";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "500";

		menuItem.title = "1000";
		menuItem.type = "callback";
		menuItem.callback = "set_damager";
		menuItem.data = "1000";
	}

	// set_afflict_type
	void Beams_OnSetAfflictType(string value = "", string afflictType = "")
	{
		AFF_1 = afflictType;
		MENU_TYPE = "3";
		CallEventDelayed(0.1f, "ext_menu_open");
	}

	// set_afflict_duration
	void Beams_OnSetAfflictDuration(string value = "", string duration = "")
	{
		AFF_2 = duration;
		MENU_TYPE = "4";
		CallEventDelayed(0.1f, "ext_menu_open");
	}

	// set_afflict_dmg
	void Beams_OnSetAfflictDmg(string value = "", string damage = "")
	{
		AFF_3 = damage;
		CallExternal(MY_ITEM, "set_affliction", AFF_1, AFF_2, AFF_3);
	}

	// set_damager
	void Beams_OnSetDamager(string damage = "", string extra = "")
	{
		CallExternal(MY_ITEM, "set_damager", extra);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuListbeams() { Beams_OnMenuListbeams(); } // menu_listbeams
	void OnSetBeamType(string beamType = "", float beamMode = 0.0f) { Beams_OnSetBeamType(beamType, beamMode); } // set_beam_type
	void OnMenuListafflicttype() { Beams_OnMenuListafflicttype(); } // menu_listafflicttype
	void OnMenuListafflictduration() { Beams_OnMenuListafflictduration(); } // menu_listafflictduration
	void OnMenuListafflictdmg() { Beams_OnMenuListafflictdmg(); } // menu_listafflictdmg
	void OnMenuDamagerSetdmg() { Beams_OnMenuDamagerSetdmg(); } // menu_damager_setdmg
	void OnSetAfflictType(string value = "", string afflictType = "") { Beams_OnSetAfflictType(value, afflictType); } // set_afflict_type
	void OnSetAfflictDuration(string value = "", string duration = "") { Beams_OnSetAfflictDuration(value, duration); } // set_afflict_duration
	void OnSetAfflictDmg(string value = "", string damage = "") { Beams_OnSetAfflictDmg(value, damage); } // set_afflict_dmg
	void OnSetDamager(string damage = "", string extra = "") { Beams_OnSetDamager(damage, extra); } // set_damager

	// This file's events and timers by their .script names
	bool Beams_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "menu_damager_setdmg") { OnMenuDamagerSetdmg(); return true; }
		if (name == "menu_listafflictdmg") { OnMenuListafflictdmg(); return true; }
		if (name == "menu_listafflictduration") { OnMenuListafflictduration(); return true; }
		if (name == "menu_listafflicttype") { OnMenuListafflicttype(); return true; }
		if (name == "menu_listbeams") { OnMenuListbeams(); return true; }
		if (name == "set_afflict_dmg") { OnSetAfflictDmg(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_afflict_duration") { OnSetAfflictDuration(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_afflict_type") { OnSetAfflictType(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_beam_type") { OnSetBeamType(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "set_damager") { OnSetDamager(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/beams"]
shared class BeamsScript : ScriptEntity, Beams
{
	// Variables every script that includes this file declares
	bool LISTENING_FOR_TRIGGER = false;
	string MY_ITEM = "MY_ITEM";
	string MY_OWNER = "MY_OWNER";
	string RECENT_TRIGGERS = "RECENT_TRIGGERS";
	float STARTED_LISTENING = 0.0f;
	int TELEPORT_MODE = 0;
	string TRIG_QUEST = "TRIG_QUEST";
	string WAYPOINT_QUEST = "WAYPOINT_QUEST";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Beams_DispatchEvent(name, params);
	}
}
