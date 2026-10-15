#pragma context server

// Converted from monsters/horror_fire2_ecaves.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror_lightning2.as"

[script "monsters/horror_fire2_ecaves"]
class HorrorFire2Ecaves : HorrorLightning2Script
{
	// Constants
	bool BURST_PUSH = true;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_SWBEAMS_REFRESH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	HorrorFire2Ecaves()
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

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		if (!(GameTime() > NEXT_SWBEAMS_REFRESH))
			return;
		NEXT_SWBEAMS_REFRESH = GameTime() + 10.2f;
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 1, 30, 10.0f, 200, Vector3(255, 0, 0));
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 1, 10, 10.0f, 200, Vector3(255, 128, 0));
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
		SetModel("monsters/horror1_ecave.mdl");
		SetModelBody(0, 0);
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/horror1_ecave.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "horror_spawn") { OnHorrorSpawn(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return HorrorLightning2Script::DispatchEvent(name, params);
	}
}
