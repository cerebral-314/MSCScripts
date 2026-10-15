#pragma context server

// Converted from monsters/skeleton_archer_stone1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_archer_base.as"

[script "monsters/skeleton_archer_stone1"]
class SkeletonArcherStone1 : SkeletonArcherBaseScript
{
	// Constants
	bool SKELE_DROPS_CONTAINER = true;
	string SKELE_CONTAINER_SCRIPT = "chests/quiver_of_jagged";
	string SKELE_DROPS_CONTAINER_CHANCE = "50%";
	int C_SKELE_ARROW_KNOCKBACK = 400;
	bool STONE_SKELETON = true;

	// Variables declared by included files, with the value they start with in this script
	SkeletonArcherStone1()
	{
		DMG_ARROW = 500;
		DMG_SWIPE = "80";
		SKELE_GOLD = 50;
		SKELE_START_LIVES = 1;
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void SkeletonArcherStone1_FirstThink()
	{
		// base stats
		NPC_GIVE_EXP = 500.0f;
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SetName("Stone Archer");
		SetHealth(2000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("fire", 1);
		SetDamageTaken("stun", 0.25f);

		SetModel("monsters/skeleton_boss1.mdl");
		SetWidth(32);
		SetHeight(80);

		SetModelBody(0, 7); // 0=Classic 1=Dark 2=Poison 3=Fire 4=Gore 5=Ice 6=Gold 7=Stone 8=Royal_ice 9=Bright_Fire 10=Greek_Armor
		SetModelBody(1, 10); // 0=Unarmed 1=Mace 2=Sword 3=Hammers 4=Sword+Shield 5=Ice_Clubs 6=Fire_Clubs 7=Big_Sword 8=Wand 9=Wand_Glow 10=Bow
		SetModelBody(2, 0); // 0=Hide_Arrow 1=Show_arrow
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonArcherStone1_FirstThink();
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
