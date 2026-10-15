#pragma context server

// Converted from other/sfx_orbiting_light.script by msc_transpiler.
// orbiting light effect, creates a sprite and light that orbits origin
// with commentary

#include "runtime/ScriptEntity.as"

[script "other/sfx_orbiting_light"]
class SfxOrbitingLight : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// unnamed block (timer)
	void SfxOrbitingLight_Timer()
	{
		CallEventDelayed(60.0f, "SfxOrbitingLight_Timer");
		// ^ repeat this event every 60 seconds
		// refresh the sound and CL effect:
		OnRefreshSound();
		ClientEvent("new", "all", "other/sfx_orbiting_light_cl", OriginOf(ENT_ME), 60.0f, 96, 256, Vector3(128, 128, 0), 0.8f);
	}

	// game_spawn
	// Special DLL event goes off whenever script spawns:
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// defining height and width so that it has an actual origin, sometimes NPC's with no models have issues finding their origins
		SetWidth(1);
		SetHeight(1);
		SetRace("beloved"); // so no NPC's attack or damage it
		SetHealth(1); // so it can be removed
		SetInvincible(true); // so it can't be damaged by players or other effects
		PLAYING_DEAD = "1"; // this prevents NPC's from even acknowleging its existence
		SetNoPush(true); // cant be pushed
		SetSolid("none"); // isn't clipped
		SetGravity(0); // floats
		SetProp(ENT_ME, "movetype", 0); // prevents ths slow fall effect you sometimes get with floating npcs
		// initialize cl effect on spawn (expires in 60 seconds):
		ClientEvent("new", "all", "other/sfx_orbiting_light_cl", OriginOf(ENT_ME), 60.0f, 96, 256, Vector3(128, 128, 0), 0.8f);
		// initlialize server side sound:
		// (this particular wave file has a special loop flag that causes it to auto-loop)
		// (it's part of the base half-life materials [half-life/valve/sound])
		ServerPlaySound(1, 10, "ambience/alien_creeper.wav");
	}

	// refresh_sound
	void OnRefreshSound()
	{
		// turn looping sounds off by playing again at zero volume, before re-starting it
		ServerPlaySound(1, 0, "ambience/alien_creeper.wav");
		CallEventDelayed(0.1f, "refresh_sound2");
	}

	// refresh_sound2
	void OnRefreshSound2()
	{
		// and back on again
		ServerPlaySound(1, 10, "ambience/alien_creeper.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambience/alien_creeper.wav");
		CallEventDelayed(60.0f, "SfxOrbitingLight_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "refresh_sound") { OnRefreshSound(); return true; }
		if (name == "refresh_sound2") { OnRefreshSound2(); return true; }
		if (name == "SfxOrbitingLight_Timer") { SfxOrbitingLight_Timer(); return true; }
		return false;
	}
}
