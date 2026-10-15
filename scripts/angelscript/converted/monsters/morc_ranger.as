#pragma context server

// Converted from monsters/morc_ranger.script by msc_transpiler.
// Marogar (Polar) Orc Archer, from Blackhand Archer, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_ranger"]
class MorcRanger : OrcBaseScript, OrcBaseRanged
{
	// Constants
	int AIM_RATIO = 50;
	int ARROW_DAMAGE_LOW = 40;
	int ARROW_DAMAGE_HIGH = 120;
	int ATTACK_SPEED = 900;
	int ATTACK_CONE_OF_FIRE = 2;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string ARROW_TYPE = "ARROW_TYPE";

	// unnamed block (first think)
	void MorcRanger_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(10, 18);
		NPC_GIVE_EXP = 100.0f;
		DROP_ITEM1 = "bows_longbow"; // Used by base_monster
		DROP_ITEM1_CHANCE = "10%"; // Used by base_monster

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_frost_arrows";

		// setvard CONTAINER_SCRIPT chests/arrows
		ANIM_ATTACK = "shootorcbow"; // Attack animation
		FLINCH_CHANCE = "45%";
		MOVE_RANGE = "5000";
		ATTACK_RANGE = 5500.0f;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged

		SetHealth(320);
		// ov 180
		SetName("Marogar Ice Archer");
		SetHearingSensitivity(10);
		SetStat("parry", 30);
		SetStat("archery", 20, 20, 20);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0.1f);

		ARROW_TYPE = "1";
		SetModel("monsters/morc.mdl");
		SetModelBody(0, 3); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
	}

	// shoot_arrow
	void OnShootArrow()
	{
		string launchArrow = "LAUNCH_ARROW";

		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		float lclAtkdmg = Random(ARROW_DAMAGE_LOW, ARROW_DAMAGE_HIGH);

		if (Float(ARROW_TYPE) == 1.0f)
			launchArrow = "proj_arrow_frost";
		if (Float(ARROW_TYPE) == 2.0f)
			launchArrow = "proj_arrow_jagged";

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_frost", RelativePosition(Vector3(0, 0, 18)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");

		ARROW_TYPE = Text(Float(ARROW_TYPE) + 1.0f);

		if (Float(ARROW_TYPE) > 2.0f)
			ARROW_TYPE = "1";

		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, SOUND_BOW);
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
		MorcRanger_FirstThink();
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
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
