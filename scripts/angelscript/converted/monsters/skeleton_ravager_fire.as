#pragma context server

// Converted from monsters/skeleton_ravager_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_ravager.as"

[script "monsters/skeleton_ravager_fire"]
class SkeletonRavagerFire : SkeletonRavagerScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonRavagerFire()
	{
		NPC_BASE_EXP = "600";
		USES_PROJECTILE = true;
		DMG_PROJECTILE = 400;
		PROJECTILE_SPEED = "400";
		SOUND_PROJECTILE = "magic/fireball_strike.wav";
		DMG_CLAW_EFFECT = "effects/dot_fire";
		DMG_CLAW_EFFECT_DOT = 100;
		MONSTER_MODEL = "monsters/skeleton_ravenous_ele.mdl";
		SOUND_ALERT1 = "monsters/undeadz/c_skeltwar_bat1.wav";
		SOUND_ALERT2 = "monsters/undeadz/c_skeltwar_bat1.wav";
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SkeletonRavager_OnSkeleSpawn(); // monsters/skeleton_ravager
		SetName("Redboned Ravager");
		SetModelBody(0, 0);
		SetModel(MONSTER_MODEL);
		SetHealth(4000);
		SetWidth(32);
		SetHeight(72);
		SetRace("undead");
		SetBlood("none");
		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("blunt", 1.5f);
		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 1);
		SetDamageTaken("holy", 2);
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// npc_adjust_projectile
	void OnNpcAdjustProjectile()
	{
		CallExternal(ENT_LASTPROJECTILE, "lighten", DMG_CLAW_EFFECT_DOT, 0.0f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("claw.spr");
		Precache("monsters/skeleton_ravenous_ele.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_adjust_projectile") { OnNpcAdjustProjectile(); return true; }
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		return SkeletonRavagerScript::DispatchEvent(name, params);
	}
}
