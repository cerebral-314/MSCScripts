#pragma context server

// Converted from edana/boarboss.script by msc_transpiler.
// Boar boss, in the old man's garden in edana

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_hard.as"

[script "edana/boarboss"]
class Boarboss : MonstersBoarHardScript
{
	// Constants
	string ATTACK_HITPERCENT = "60%";

	// Variables declared by included files, with the value they start with in this script
	Boarboss()
	{
		GORE_FORWARD_DAMAGE = 3.0f;
		GORE_SIDE_DAMAGE = "1.5";
		BOAR_CHARGE_DMG = "9";
		NPC_BASE_EXP = "15";
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
		// this is set in the base too (on spawn), so must reset here
		DROP_ITEM1 = "skin_boar_heavy"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "100%"; // base_monster - Chance of item drop #1
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar
		MonstersBoarHard_OnNpcSpawn(npc); // monsters/boar_hard

		SetHealth(60);
		SetDamageTaken("all", 0.81f);
		SetName("Huge Aggressive Wild Boar");
		SetModel("monsters/boar1.mdl");
		SetHearingSensitivity(4);

		// Set this here, to override base scripts
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health (changes for boar)
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MonstersBoarHardScript::DispatchEvent(name, params);
	}
}
