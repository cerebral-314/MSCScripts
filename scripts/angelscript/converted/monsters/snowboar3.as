#pragma context server

// Converted from monsters/snowboar3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base_remake.as"
#include "converted/monsters/base_ice_race.as"

[script "monsters/snowboar3"]
class Snowboar3 : BoarBaseRemakeScript, BaseIceRace
{
	// Variables declared by included files, with the value they start with in this script
	Snowboar3()
	{
		BOAR_SIZE = 3;
		BOAR_SKIN = 3;
		BOAR_MODEL = "monsters/boar3.mdl";
		DMG_GORE_FORWARD = 60.0f;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Snowboar3_FirstThink()
	{
		NPC_GIVE_EXP = 400.0f;

		FLEE_CHANCE = "10%";
	}

	// boar_spawn
	void OnBoarSpawn()
	{
		SetName("Gigantic Snow Boar");
		SetHealth(1200);
		SetHearingSensitivity(2);
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBaseRemake_OnNpcSpawn(npc); // monsters/boar_base_remake
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar3.mdl");
		Precache("monsters/boar/hoofbeats_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Snowboar3_FirstThink();
		BoarBaseRemake_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boar_spawn") { OnBoarSpawn(); return true; }
		return BaseIceRace_DispatchEvent(name, params)
			|| BoarBaseRemakeScript::DispatchEvent(name, params);
	}
}
