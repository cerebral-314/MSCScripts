#pragma context server

// Converted from monsters/horror_fire2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror_lightning2.as"

[script "monsters/horror_fire2"]
class HorrorFire2 : HorrorLightning2Script
{
	// Variables declared by included files, with the value they start with in this script
	HorrorFire2()
	{
		PROJ_SCRIPT = "proj_fire_ball";
		PROJ_SPEED = 1000.0f;
		FX_BURST_SCRIPT = "effects/sfx_fire_burst";
		EFFECT_DOT = "effects/dot_fire";
		BURST_ELEMENT = "fire_effect";
		SOUND_SPRAY = "magic/volcano_start.wav";
		SOUND_SHOCK1 = "magic/fireball_strike.wav";
		SOUND_SHOCK2 = "magic/fireball_strike.wav";
		SOUND_SHOCK3 = "magic/fireball_strike.wav";
	}

	// horror_spawn
	void OnHorrorSpawn()
	{
		SetName("Burning Horror");

		SetHealth(1000);
		SetWidth(32);
		SetHeight(32);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetRace("demon");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(11);
		SetModel("monsters/edwardgorey2.mdl");
		SetModelBody(0, 1);
		SetMoveSpeed(2); // slower than lightning2
		BASE_MOVESPEED = 2.0f;

		PlayAnim("once", ANIM_WALK);

		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 2);
		SetDamageTaken("cold", 2);

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
