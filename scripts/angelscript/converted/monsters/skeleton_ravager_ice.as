#pragma context server

// Converted from monsters/skeleton_ravager_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_ravager.as"

[script "monsters/skeleton_ravager_ice"]
class SkeletonRavagerIce : SkeletonRavagerScript
{
	// Variables (an unset .script variable reads as its own name)
	int PASS_FREEZE_DMG = 0;
	float PASS_FREEZE_DUR = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SkeletonRavagerIce()
	{
		NPC_BASE_EXP = "600";
		USES_PROJECTILE = true;
		PROJECTILE_SCRIPT = "proj_freezing_sphere";
		PROJECTILE_SPEED = "150";
		SOUND_PROJECTILE = "none";
		DMG_CLAW_EFFECT = "effects/dot_cold";
		DMG_CLAW_EFFECT_DOT = 75;
		MONSTER_MODEL = "monsters/skeleton_ravenous_ele.mdl";
		SOUND_ALERT1 = "monsters/undeadz/c_skeltwar_bat1.wav";
		SOUND_ALERT2 = "monsters/undeadz/c_skeltwar_bat1.wav";
	}

	// unnamed block (first think)
	void SkeletonRavagerIce_FirstThink()
	{
		PASS_FREEZE_DMG = 50;
		PASS_FREEZE_DUR = 5.0f;
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SkeletonRavager_OnSkeleSpawn(); // monsters/skeleton_ravager
		SetName("Iceboned Ravager");
		SetModelBody(0, 1);
		SetModel(MONSTER_MODEL);
		SetHealth(4000);
		SetWidth(32);
		SetHeight(72);
		SetRace("undead");
		SetBlood("none");
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("blunt", 1.5f);
		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("holy", 2);
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("claw.spr");
		Precache("monsters/skeleton_ravenous_ele.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonRavagerIce_FirstThink();
		SkeletonRavager_FirstThink();
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
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		return SkeletonRavagerScript::DispatchEvent(name, params);
	}
}
