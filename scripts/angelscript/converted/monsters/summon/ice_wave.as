#pragma context server

// Converted from monsters/summon/ice_wave.script by msc_transpiler.
// fx for icewave by Thothie from scratch

#include "runtime/ScriptEntity.as"

[script "monsters/summon/ice_wave"]
class IceWave : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	bool IR_ACTIVE = false;

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue2));
		CallEventOrDelay(creatorValue1, "wave_die");
		IR_ACTIVE = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Ice Wave");
		SetHealth(10000);
		SetInvincible(true);
		SetRace("beloved");
		SetSolid("none");
		SetBoundingBox("none");
		SetBlood("none");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 52);
		IR_ACTIVE = true;
		OnSnapTo();
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetIdleAnim("idle_standard"); // anims need to be set
		SetMoveAnim("idle_standard"); // anims need to be set
	}

	// snap_to
	void OnSnapTo()
	{
		if (!IR_ACTIVE)
			return;
		Vector3 sealPos = OriginOf(MY_OWNER);
		float groundZ = GroundHeight(sealPos);
		float sealZ = sealPos.z;
		float groundDist = groundZ - sealZ;
		sealPos += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, groundDist));
		SetOrigin(ENT_ME, sealPos);
		Vector3 ownerAngles = AnglesOf(MY_OWNER);
		SetAngle("face", ownerAngles);
		CallEventDelayed(0.1f, "snap_to");
	}

	// wave_die
	void OnWaveDie()
	{
		IR_ACTIVE = false;
		CallEventDelayed(0.1f, "final_bye_bye");
	}

	// final_bye_bye
	void OnFinalByeBye()
	{
		ClientEvent("remove", "all", "monsters/summon/ice_wave");
		DeleteEntity(ENT_ME);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetAlive(true);
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
		if (name == "final_bye_bye") { OnFinalByeBye(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "snap_to") { OnSnapTo(); return true; }
		if (name == "wave_die") { OnWaveDie(); return true; }
		return false;
	}
}
