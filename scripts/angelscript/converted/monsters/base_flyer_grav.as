#pragma context server

// Converted from monsters/base_flyer_grav.script by msc_transpiler.
// Gravity based flyer
// assumes model is centered a bit off ground and has monster AI (either new or old) and normal LX movement anims
// death animations should end with the model resting on the ground
// (minor aesthetic bug): if the creature dies at a great height, it may not reach the ground before the death sequence finishes, causing a 'suspended in air' death, or a 'snap-to' teleport effect
// (technically, this flight model will work with any ground-movement based creature, but it will look awfully funny on something that walks.)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseFlyerGrav
{
	// Constants
	int BFLY_VSPEED_UP = 25;
	int BFLY_VSPEED_DOWN = -25;
	int BFLY_VRANGE = 50;
	float BFLY_MIN_REMOVE_DELAY = 15.0f;
	int BFLY_AGRESSIVE_MAX_THRUST = 100;
	int BFLY_AGRESSIVE_MIN_RANGE = 128;

	// Variables (an unset .script variable reads as its own name)
	bool BFLY_AGRESSIVE = false;

	// unnamed block (first think)
	void BaseFlyerGrav_FirstThink()
	{
		BFLY_AGRESSIVE = false; // optional, move towards target faster when seen, speed increase based on distance (overshoots sometimes, but works alright)
	}

	// game_spawn
	void BaseFlyerGrav_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetGravity(0);
	}

	// npc_targetsighted
	void BaseFlyerGrav_OnNpcTargetsighted(string target = "")
	{
		if (!BFLY_AGRESSIVE)
			return;
		if (!(RangeTo(GetVar("NPCATK_TARGET")) > BFLY_AGRESSIVE_MIN_RANGE))
			return;
		float thrustRatio = RangeTo(GetVar("NPCATK_TARGET"));
		if (thrustRatio > 640.0f)
			thrustRatio = 640.0f;
		thrustRatio = Divide(thrustRatio, 640.0f);
		thrustRatio = Ratio(thrustRatio, 0, BFLY_AGRESSIVE_MAX_THRUST);
		// dbg L_THRUST_RATIO
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, thrustRatio, 0)));
	}

	// npcatk_hunt
	void BaseFlyerGrav_OnNpcatkHunt()
	{
		float zDiff = 0.0f;
		if (!IsAlive(ENT_ME))
			return;
		if (Truthy(GetVar("SUSPEND_AI")))
			return;
		if (Truthy(GetVar("I_R_FROZEN")))
			return;
		if (Truthy(GetVar("BFLY_SUSPEND_FLY")))
			return;

		float moveDestZ = Vec(Eval("game.monster.movedest.origin")).z;
		float myZ = OriginOf(ENT_ME).z;

		if (moveDestZ > myZ)
		{
			// dbg moving up
			zDiff = moveDestZ - myZ;
			if (zDiff > BFLY_VRANGE)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, BFLY_VSPEED_UP)));
		}
		if (moveDestZ < myZ)
		{
			// dbg moving down
			zDiff = myZ - moveDestZ;
			if (zDiff > BFLY_VRANGE)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, BFLY_VSPEED_DOWN)));
		}
	}

	// game_death
	void BaseFlyerGrav_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Truthy(GetVar("BFLY_NO_FAKE_DEATH")))
			return;

		// this is causing invincinble mobs, new method, we create model.
		PlayAnim("critical", GetVar("ANIM_DEATH"));

		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "spawn_corpse", IndexOf(ENT_ME), AnimIndexOf(ENT_ME), GetProp(ENT_ME, "renderprops"));

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnNpcTargetsighted(string target = "") { BaseFlyerGrav_OnNpcTargetsighted(target); } // npc_targetsighted
	void OnNpcatkHunt() { BaseFlyerGrav_OnNpcatkHunt(); } // npcatk_hunt
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death

	// This file's events and timers by their .script names
	bool BaseFlyerGrav_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_flyer_grav"]
shared class BaseFlyerGravScript : ScriptEntity, BaseFlyerGrav
{
	// Variables every script that includes this file declares
	string PLAYING_DEAD = "PLAYING_DEAD";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseFlyerGrav_DispatchEvent(name, params);
	}
}
