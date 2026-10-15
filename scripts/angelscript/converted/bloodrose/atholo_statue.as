#pragma context server

// Converted from bloodrose/atholo_statue.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "bloodrose/atholo_statue"]
class AtholoStatue : ScriptEntity
{
	// Constants
	string MONSTER_MODEL = "props/atholo_statue.mdl";
	string SOUND_SPAWN = "magic/spawn_loud.wav";
	string SOUND_ROCKS = "debris/bustconcrete2.wav";

	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ PASS_TARGET = null;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("");
		SetUniqueName("atholo_statue");
		SetInvincible(true);
		// race beloved
		SetWidth(40);
		SetHeight(100);
		SetSolid("npcsize");
		SetModel(MONSTER_MODEL);
	}

	// spawn_atholo
	void OnSpawnAtholo(CBaseEntity@ target = null)
	{
		@PASS_TARGET = target;

		Effect("glow", ENT_ME, Vector3(255, 0, 255), 512, 2, 2);
		PlaySound(0, 10, SOUND_SPAWN);
		CallEventDelayed(1.9f, "gibify");
		CallEventDelayed(2.0f, "summon_atholo");
	}

	// gibify
	void OnGibify()
	{
		PlaySound(0, 10, SOUND_ROCKS);
		Effect("tempent", "gibs", "rockgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 5, 15, 20, 5);
	}

	// summon_atholo
	void OnSummonAtholo()
	{
		Vector3 myAngles = AnglesOf(ENT_ME);
		float myYaw = myAngles.y;

		CreateNpc("bloodrose/atholo", RelativePosition(Vector3(0, 0, 0)), myYaw, @PASS_TARGET);
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/atholo_statue.mdl");
		Precache("rockgibs.mdl");
		Precache("monsters/skeleton_boss2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gibify") { OnGibify(); return true; }
		if (name == "spawn_atholo") { OnSpawnAtholo(EntityParam(params, 0)); return true; }
		if (name == "summon_atholo") { OnSummonAtholo(); return true; }
		return false;
	}
}
