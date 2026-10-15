#pragma context server

// Converted from NPCs/default_dwarf.script by msc_transpiler.
// *** Default dwarf script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_civilian.as"
#include "converted/NPCs/dwarf_lantern_base.as"

[script "NPCs/default_dwarf"]
class DefaultDwarf : BaseNpcScript, BaseCivilian, DwarfLanternBase
{
	// Constants
	string ATTACK1_DAMAGE = "1";
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

	// Variables (an unset .script variable reads as its own name)
	string MOVE_RANGE = "MOVE_RANGE";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	DefaultDwarf()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		CAN_FLEE = "1";
	}

	// unnamed block (first think)
	void DefaultDwarf_FirstThink()
	{
		MOVE_RANGE = "32";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "diesimple";
		ATTACK_RANGE = 48.0f;
		ATTACK_HITRANGE = 80.0f;
		CAN_FLEE = "1";
	}

	// unnamed block (timer)
	void DefaultDwarf_Timer()
	{
		CallEventDelayed(30.0f, "DefaultDwarf_Timer");

		if (LANTERN_ON) // refresh lantern cl
			OnNpcatkHunt();

		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		PlaySound(0, 2, "npc/dwarfchitchat.wav"); // was using human wav
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		SetMoveDest(ENT_LASTSTRUCK, 9999);
		PlayAnim("critical", ANIM_ATTACK);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		// ov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
		SetModel("dwarf/male1.mdl");
		SetModelBody(1, 0);
		SetMoveAnim("walk");

		SetProp(ENT_ME, "skin", RandomInt(1, 6));

		CallEventDelayed(1.0f, "do_lantern");
	}

	// do_lantern
	void OnDoLantern()
	{
		if (LANTERN_SET)
			return;
		if (RandomInt(1, 2) == 1)
			OnSetLantern();
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSTRUCK, ATTACK_HITRANGE, ATTACK1_DAMAGE, "ATTACK_PERCENTAGE", "blunt");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
		CallEventDelayed(30.0f, "DefaultDwarf_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DefaultDwarf_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "do_lantern") { OnDoLantern(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "DefaultDwarf_Timer") { DefaultDwarf_Timer(); return true; }
		return BaseCivilian_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
