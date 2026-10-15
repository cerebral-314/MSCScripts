#pragma context server

// Converted from monsters/orc_archer.script by msc_transpiler.
// Orc Archer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersOrcArcher
{
	// Constants
	int AIM_RATIO = 30;
	int ARROW_DAMAGE_LOW = 3;
	int ARROW_DAMAGE_HIGH = 5;
	int ATTACK_SPEED = 700;
	int ATTACK_CONE_OF_FIRE = 3;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2 = "DROP_ITEM2";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";

	// unnamed block (first think)
	void MonstersOrcArcher_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(2, 8);
		NPC_GIVE_EXP = 25.0f;

		ANIM_ATTACK = "shootorcbow"; // Attack animation
		MOVE_RANGE = "400";
		ATTACK_RANGE = 800.0f;

		DROP_ITEM1 = "bows_orcbow"; // Used by base_monster
		DROP_ITEM1_CHANCE = "20%"; // Used by base_monster
		DROP_ITEM2 = "proj_arrow_wooden30"; // Used by base_monster
		DROP_ITEM2_CHANCE = "80%"; // Used by base_monster

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_bluntwood";
	}

	// orc_spawn
	void MonstersOrcArcher_OnOrcSpawn()
	{
		SetHealth(40);
		// ov 180
		SetName("Orc Archer");
		SetHearingSensitivity(1.5f);
		SetStat("parry", 20);

		SetModelBody(0, 1); // Body
		SetModelBody(1, 1); // Head
		SetModelBody(2, 2); // Weapon
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		MonstersOrcArcher_OnOrcSpawn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// This file's events and timers by their .script names
	bool MonstersOrcArcher_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_archer"]
shared class MonstersOrcArcherScript : OrcBaseScript, MonstersOrcArcher, OrcBaseRanged
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersOrcArcher_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
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
		return MonstersOrcArcher_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
