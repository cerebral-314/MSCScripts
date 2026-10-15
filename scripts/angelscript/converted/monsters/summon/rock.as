#pragma context server

// Converted from monsters/summon/rock.script by msc_transpiler.
// Rock for use with skeleton_stone2 by Thothie

#include "runtime/ScriptEntity.as"

[script "monsters/summon/rock"]
class MonstersSummonRock : ScriptEntity
{
	// Constants
	int ROCK_SPEED = 1000;

	// Variables (an unset .script variable reads as its own name)
	string ROCK_OWNER = "ROCK_OWNER";
	bool FIRE_ROCK = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetSolid("none");
		// race beloved
		SetModel("weapons/projectiles.mdl");
		if (!FIRE_ROCK)
		{
			SetModelBody(0, 5);
		}
		else
		{
			SetModelBody(0, 67);
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, -1, -1);
		}
		SetFly(true);
		SetGravity(0);
		SetMoveSpeed(0);
		SetRoam(false);
		SetInvincible(true);
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2=fire_rock 0|1
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SetRace(RaceOf(creatorValue1));
		if (!IsPlayer(creatorValue1))
			LegacyCommand("storeentity", ENT_EXPOWNER, creatorValue1);
		ROCK_OWNER = creatorValue1;

		if (Float(creatorValue2) == 1.0f)
		{
			SetModelBody(0, 67);
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, -1, -1);
			FIRE_ROCK = true;
		}
	}

	// toss_rock
	// called externally, PARAM1=target PARAM2=damage
	void OnTossRock(string target = "", string damage = "")
	{
		// invisible
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		if (!FIRE_ROCK)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_troll_rock", "view", target, ROCK_SPEED, damage, 0.75f, "none");
		}
		else
		{
			TossProjectile("proj_lava_rock", "view", target, ROCK_SPEED, damage, 0.75f, "none");
		}
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0);
		CallEventDelayed(1.5f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "toss_rock") { OnTossRock(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
