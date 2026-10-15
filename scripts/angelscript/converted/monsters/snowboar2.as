#pragma context server

// Converted from monsters/snowboar2.script by msc_transpiler.
// A tough boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar.as"
#include "converted/monsters/base_ice_race.as"

[script "monsters/snowboar2"]
class Snowboar2 : BoarScript, BaseIceRace
{
	// Constants
	string NPC_BASE_EXP = "150";
	string BOAR_CHARGE_DMG = "$rand(60,150)";

	// Variables declared by included files, with the value they start with in this script
	Snowboar2()
	{
		ANIM_FORWARD = "gore_forward2";
		GORE_FORWARD_DAMAGE = 16.0f;
		GORE_SIDE_DAMAGE = "$rand(10,15)";
		BOAR_CAN_CHARGE = true;
		FLEE_CHANCE = "10%";
	}

	// unnamed block (first think)
	void Snowboar2_FirstThink()
	{
		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_HEAR = "1"; // base_npc_attack - Whether I can hear enemies (changes for boar)
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		MOVE_RANGE = "64";
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race

		SetHealth(800);
		SetHeight(72);
		SetWidth(72);
		SetName("Ferocious Snow Boar");
		SetHearingSensitivity(2);
		SetModel("monsters/boar2.mdl");
		SetProp(ENT_ME, "skin", 3);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar.mdl");
		Precache("monsters/boar2.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "BoarBase_Timer");
		CallEventDelayed(Float(Eval("$rand(8,12)")), "BoarBase_Timer2");
		CallEventDelayed(0.1f, "BoarBase_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Snowboar2_FirstThink();
		Boar_FirstThink();
		BoarBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseIceRace_DispatchEvent(name, params)
			|| BoarScript::DispatchEvent(name, params);
	}
}
