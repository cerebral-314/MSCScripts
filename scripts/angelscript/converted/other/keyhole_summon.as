#pragma context server

// Converted from other/keyhole_summon.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_summon"]
class KeyholeSummon : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeSummon()
	{
		KEY_NAME = "item_summon_crystal";
		KEYHOLE_NAME = "Crystal Holder";
		KEYHOLE_TITLE = "Place the Summoning Crystal";
	}

	// unnamed block (first think)
	void KeyholeSummon_FirstThink()
	{
		RETURN_KEY = false;
	}

	// spawn
	void OnSpawn()
	{
		SetName(KEYHOLE_NAME);
		SetWidth(2);
		SetHeight(16);
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetFly(true); // suspend in air where placed

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		SetMenuAutoOpen(true);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/keyhole.mdl");
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeSummon_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseKeyholeScript::DispatchEvent(name, params);
	}
}
