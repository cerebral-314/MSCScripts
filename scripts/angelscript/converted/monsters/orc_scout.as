#pragma context server

// Converted from monsters/orc_scout.script by msc_transpiler.
// Orc Scout Archer - weak

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

[script "monsters/orc_scout"]
class OrcScout : OrcBaseScript, OrcBaseRanged
{
	// Constants
	int AIM_RATIO = 30;
	int ARROW_DAMAGE_LOW = 1;
	int ARROW_DAMAGE_HIGH = 2;
	int ATTACK_SPEED = 800;
	int ATTACK_CONE_OF_FIRE = 2;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM2 = "DROP_ITEM2";
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";

	// unnamed block (first think)
	void OrcScout_FirstThink()
	{
		DROP_GOLD = RandomInt(0, 1); // Chance of dropping gold
		DROP_GOLD_AMT = RandomInt(1, 4);
		NPC_GIVE_EXP = 10.0f;
		DROP_ITEM1 = "bows_orcbow"; // Used by base_monster
		DROP_ITEM1_CHANCE = "20%"; // Used by base_monster
		DROP_ITEM2 = "proj_arrow_wooden30"; // Used by base_monster
		DROP_ITEM2_CHANCE = "80%"; // Used by base_monster

		ANIM_ATTACK = "shootorcbow"; // Attack animation
		FLINCH_CHANCE = "70%";
		MOVE_RANGE = "300";
		ATTACK_RANGE = 800.0f;

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_bluntwood";
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged

		SetHealth(15);
		// ov 180
		SetWidth(40);
		SetHeight(90);
		SetName("Blackhand scout");
		if (MapName() == "ms_wicardoven")
		{
			SetName("Voldar Peon");
			SetProp(ENT_ME, "skin", 3);
		}
		SetHearingSensitivity(1);
		SetStat("parry", 20);

		SetModelBody(0, 0); // Body
		SetModelBody(1, 1); // Head
		SetModelBody(2, 2); // Weapon
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcScout_FirstThink();
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
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
