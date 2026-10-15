#pragma context server

// Converted from monsters/skeleton_archer_ice1.script by msc_transpiler.
// Weakest of the ice archers

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_archer_base.as"

[script "monsters/skeleton_archer_ice1"]
class SkeletonArcherIce1 : SkeletonArcherBaseScript
{
	// Constants
	string SKELE_ARROW_EFFECT = "effects/dot_cold";
	int SKELE_ARROW_AOE = 0;
	int SKELE_DOT_DMG = 25;
	float SKELE_DOT_DUR = 8.0f;
	bool SKELE_ARROW_GLOW = true;
	Vector3 SKELE_ARROW_GLOW_COLOR = Vector3();
	int C_SKELE_ARROW_KNOCKBACK = 400;
	bool SKELE_DROPS_CONTAINER = true;
	string SKELE_CONTAINER_SCRIPT = "chests/quiver_of_frost";
	string SKELE_DROPS_CONTAINER_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	SkeletonArcherIce1()
	{
		DMG_ARROW = 200;
		DMG_SWIPE = "30";
		SKELE_GOLD = 50;
		SKELE_START_LIVES = 1;
	}

	// unnamed block (first think)
	void SkeletonArcherIce1_FirstThink()
	{
		// base stats
		NPC_GIVE_EXP = 500.0f;
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SetName("Frozen Archer");
		SetHealth(1000);

		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1.25f);

		SetModel("monsters/skeleton_boss1.mdl");
		SetWidth(32);
		SetHeight(80);

		SetModelBody(0, 5); // 0=Classic 1=Dark 2=Poison 3=Fire 4=Gore 5=Ice 6=Gold 7=Stone 8=Royal_ice 9=Bright_Fire 10=Greek_Armor
		SetModelBody(1, 10); // 0=Unarmed 1=Mace 2=Sword 3=Hammers 4=Sword+Shield 5=Ice_Clubs 6=Fire_Clubs 7=Big_Sword 8=Wand 9=Wand_Glow 10=Bow
		SetModelBody(2, 0); // 0=Hide_Arrow 1=Show_arrow
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonArcherIce1_FirstThink();
		SkeletonArcherBase_FirstThink();
		SkeletonArcherBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SkeletonArcherBase_FirstThink3();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		return SkeletonArcherBaseScript::DispatchEvent(name, params);
	}
}
