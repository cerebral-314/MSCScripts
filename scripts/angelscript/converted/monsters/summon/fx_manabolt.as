#pragma context server

// Converted from monsters/summon/fx_manabolt.script by msc_transpiler.
// Special visual effect for manaball charging on Orion Bow

#include "runtime/ScriptEntity.as"

[script "monsters/summon/fx_manabolt"]
class FxManabolt : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string F_BALL_SIZE = "F_BALL_SIZE";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("weapons/projectiles.mdl");
		SetSolid("none");
		SetBoundingBox("none");
		SetModelBody(0, 14);
		SetRace("beloved");
		SetInvincible(true);
		SetFly(true);
		SetGravity(0);
		SetMonsterClip(false);

		SetProp(ENT_ME, "renderamt", 10);
		SetProp(ENT_ME, "rendermode", 5);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		CallEventDelayed(0.1f, "stick_to_owner");
	}

	// stick_to_owner
	void OnStickToOwner()
	{
		CallEventDelayed(0.1f, "stick_to_owner");

		SetProp(ENT_ME, "renderamt", 10);
		SetProp(ENT_ME, "rendermode", 5);

		Vector3 setLoc = OriginOf(MY_OWNER);
		float ownerYaw = AnglesOf(MY_OWNER).y;
		float ownerPitch = AnglesOf(MY_OWNER).x;
		float nOwnerPitch = -ownerPitch;

		setLoc += RelativePosition(Vector3(nOwnerPitch, ownerYaw, 0), Vector3(0, 20, 28));

		SetOrigin(ENT_ME, setLoc);

		F_BALL_SIZE = ScriptVarOf(MY_OWNER, "BALL_SIZE");
		if (Float(F_BALL_SIZE) == 0.0f)
			DeleteEntity(ENT_ME);
		if (!(Float(F_BALL_SIZE) > 0.0f))
			return;
		float subModel = int(Float(F_BALL_SIZE)) + 12.0f;
		subModel = int(subModel);
		SetModelBody(0, int(subModel));
		SetBoundingBox("animsize");
	}

	// set_size
	void OnSetSize(string size = "")
	{
		// dbg fX_manabolt got PARAM1
		float subModel = int(Float(size)) + 13.0f;
		SetModelBody(0, int(subModel));
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
		if (name == "set_size") { OnSetSize(Param(params, 0)); return true; }
		if (name == "stick_to_owner") { OnStickToOwner(); return true; }
		return false;
	}
}
