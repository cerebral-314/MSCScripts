#pragma context server

// Converted from monsters/morc_archer.script by msc_transpiler.
// Marogar (Polar) Orc Archer, from Blackhand Archer, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_archer"]
class MorcArcher : OrcBaseScript, OrcBaseRanged
{
	// Constants
	int AIM_RATIO = 50;
	int ARROW_DAMAGE_LOW = 20;
	int ARROW_DAMAGE_HIGH = 35;
	int ATTACK_SPEED = 900;
	int ATTACK_CONE_OF_FIRE = 2;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM2 = "DROP_ITEM2";
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";

	// unnamed block (first think)
	void MorcArcher_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(10, 18);
		NPC_GIVE_EXP = 45.0f;
		DROP_ITEM1 = "bows_longbow"; // Used by base_monster
		DROP_ITEM1_CHANCE = "10%"; // Used by base_monster
		DROP_ITEM2 = "proj_arrow_jagged60"; // Used by base_monster
		DROP_ITEM2_CHANCE = "10%"; // Used by base_monster

		ANIM_ATTACK = "shootorcbow"; // Attack animation
		FLINCH_CHANCE = "45%";
		MOVE_RANGE = "5000";
		ATTACK_RANGE = 5500.0f;

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "5%";
		CONTAINER_SCRIPT = "chests/quiver_of_frost_arrows";
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged

		SetHealth(160);
		// ov 180
		SetName("Marogar Archer");
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0.1f);
		SetModel("monsters/morc.mdl");
		SetModelBody(0, 1); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 2); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/morc.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcArcher_FirstThink();
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
