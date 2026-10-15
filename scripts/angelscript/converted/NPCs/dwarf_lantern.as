#pragma context server

// Converted from NPCs/dwarf_lantern.script by msc_transpiler.
// Dwarves with lanterns for Vomica by Thothie
// - This one is designed to work with a new submodel of the dwarven model

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"
#include "converted/monsters/base_civilian.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfLantern
{
	// Constants
	string CAN_HUNT = "0";
	string HUNT_AGRO = "0";
	string CAN_ATTACK = "0";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "100%";
	string CAN_HEAR = "1";
	string CAN_RETALIATE = "1";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	string CAN_FLINCH = "1";
	string FLINCH_ANIM = "flinch1";
	string FLINCH_CHANCE = "50%";
	string FLINCH_DELAY = "1";
	bool NO_JOB = true;
	bool NO_HAIL = true;
	bool NO_RUMOR = true;
	string MONSTER_MODEL = "npc/dwarf_lantern.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string CAN_FLEE = "1";
	string MOVE_RANGE = "MOVE_RANGE";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	bool I_R_GLOWING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// unnamed block (first think)
	void DwarfLantern_FirstThink()
	{
		MOVE_RANGE = "64";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		// const	ANIM_ATTACK	beatdoor
		ANIM_DEATH = "diesimple";
		ATTACK_RANGE = 90.0f;
		CAN_FLEE = "1";
	}

	// npc_spawn
	void DwarfLantern_OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		// ov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Dwarven Miner");
		if (!NO_WANDER)
			SetRoam(true);
		if (NO_WANDER)
			SetRoam(false);
		SetModel(MONSTER_MODEL);
		SetModelBody(0, RandomInt(0, 1)); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 4); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword 4-Lantern?
		SetMoveAnim("walk");

		CallEventDelayed(3.0f, "light_on");
	}

	// game_struck
	void DwarfLantern_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "4096", "20.0");
	}

	// unnamed block (timer)
	void DwarfLantern_Timer()
	{
		CallEventDelayed(30.0f, "DwarfLantern_Timer");

		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		PlaySound(0, 2, "npc/dwarfchitchat.wav"); // was using human wav
	}

	// attack_1
	void DwarfLantern_OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, "ATTACK1_DAMAGE", "ATTACK_PERCENTAGE");
	}

	// game_death
	void DwarfLantern_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
	}

	// light_on
	void DwarfLantern_OnLightOn()
	{
		if (I_R_GLOWING)
			return;
		I_R_GLOWING = true;
		ClientEvent("persist", "all", "NPCs/dwarf_lantern", IndexOf(ENT_ME));
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		DwarfLantern_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		DwarfLantern_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	void OnNpcSpawn(string npc = "") { DwarfLantern_OnNpcSpawn(npc); } // npc_spawn
	void OnAttack12() { DwarfLantern_OnAttack12(); } // attack_1
	void OnLightOn() { DwarfLantern_OnLightOn(); } // light_on

	// This file's events and timers by their .script names
	bool DwarfLantern_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "light_on") { OnLightOn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "DwarfLantern_Timer") { DwarfLantern_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/dwarf_lantern"]
shared class DwarfLanternScript : BaseNpcAttackScript, DwarfLantern, BaseCivilian
{
	// Variables every script that includes this file declares
	bool NO_WANDER = false;

	// Variables declared by included files, with the value they start with in this script
	DwarfLanternScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		CAN_HUNT = "0";
		HUNT_AGRO = "0";
		CAN_ATTACK = "0";
		CAN_FLEE = "1";
		CAN_HEAR = "1";
		CAN_RETALIATE = "1";
		CAN_FLINCH = "1";
		FLINCH_DELAY = "1";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/dwarf_lantern.mdl");
		CallEventDelayed(30.0f, "DwarfLantern_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfLantern_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DwarfLantern_DispatchEvent(name, params)
			|| BaseCivilian_DispatchEvent(name, params)
			|| BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
