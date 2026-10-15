#pragma context server

// Converted from monsters/summon/seal_maker.script by msc_transpiler.
// Thothie = can't for the life of me figure how to make the seal stay on the ground as a client side effect

#include "runtime/ScriptEntity.as"

[script "monsters/summon/seal_maker"]
class SealMaker : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string SEAL_MODEL = "SEAL_MODEL";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool SEAL_RUNNING = false;

	// game_dynamically_created
	// PARAM1 = Model PARAM2 = Duration PARAM3=Sealoffset
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SEAL_MODEL = creatorValue1;

		SetModel(creatorValue1);
		SetModelBody(0, Int(damage));
		CallEventOrDelay(creatorValue2, "make_go_bye_bye");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Magic Seal");
		SetHealth(10000);
		SetInvincible(true);
		SetDamageTaken("all", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("cold", 0);
		// race beloved
		SetMoveSpeed(0);
		PLAYING_DEAD = "1";
		// height 2
		// width 2
		SetFly(true);
		LegacyCommand("float", 1);
		SetGravity(0);
		SetBlood("none");
		if (SEAL_MODEL == "SEAL_MODEL")
			SEAL_MODEL = "none";
		SetModel(SEAL_MODEL);
		SetSolid("none");
		SetBoundingBox("none");
		LegacyCommand("drop_to_floor");

		SEAL_RUNNING = true;
		CallEventDelayed(0.5f, "stay_floor");
	}

	// stay_floor
	void OnStayFloor()
	{
		if (!SEAL_RUNNING)
			return;

		LegacyCommand("drop_to_floor");
		CallEventDelayed(1.0f, "stay_floor");
	}

	// make_go_bye_bye
	void OnMakeGoByeBye()
	{
		SEAL_RUNNING = false;
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000)); // make sure seal vanishes
		CallEventDelayed(0.5f, "final_remove");
	}

	// final_remove
	void OnFinalRemove()
	{
		ClientEvent("remove", "all", "monsters/summon/seal_maker");
		DeleteEntity(ENT_ME);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetAlive(true);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "final_remove") { OnFinalRemove(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_go_bye_bye") { OnMakeGoByeBye(); return true; }
		if (name == "stay_floor") { OnStayFloor(); return true; }
		return false;
	}
}
