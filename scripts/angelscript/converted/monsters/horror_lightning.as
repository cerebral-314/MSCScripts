#pragma context server

// Converted from monsters/horror_lightning.script by msc_transpiler.
// NOV2014_13 - adapted this to new flight model

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror_lightning2.as"

[script "monsters/horror_lightning"]
class HorrorLightning : HorrorLightning2Script
{
	// Constants
	string NPC_BASE_EXP = "200";

	// Variables declared by included files, with the value they start with in this script
	HorrorLightning()
	{
		DMG_PROJECTILE = 50;
		DMG_BLAST = 100;
	}

	// horror_spawn
	void OnHorrorSpawn()
	{
		SetName("Lightning Horror");

		SetHealth(500);
		SetWidth(32);
		SetHeight(32);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetRace("demon");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(11);
		SetModel("monsters/edwardgorey2.mdl");
		SetModelBody(0, 2);
		SetMoveSpeed(3); // slower than lightning2
		BASE_MOVESPEED = 3.0f;

		PlayAnim("once", ANIM_WALK);

		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 2);
		SetDamageTaken("acid", 2);

		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "horror_spawn") { OnHorrorSpawn(); return true; }
		return HorrorLightning2Script::DispatchEvent(name, params);
	}
}
