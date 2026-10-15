#pragma context server

// Converted from other/boom_block.script by msc_transpiler.
// Block that moves upwards then falls back down when event is called to it.
// The amount it moves is based on its distance from the caller.
// A bunch of them can be thus used to simulate something large falling to the ground and causing a wave-like blast.
// It's a neat effect, but too resource heavy to be practical.
// This block is non-solid and should be tied to an msarea_scripted with an origin brush.
// Video Demonstration: http://www.youtube.com/watch?v=epLkxuC1vCE

#include "runtime/ScriptEntity.as"

[script "other/boom_block"]
class BoomBlock : ScriptEntity
{
	// Constants
	int EFFECT_DIST = 1024;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string NPC_HOME_LOC = "NPC_HOME_LOC";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		SetRace("beloved");
		PLAYING_DEAD = "1";
		SetSolid("none");
		SetNoPush(true);
		CallEventDelayed(0.1f, "get_home_loc");
	}

	// get_home_loc
	void OnGetHomeLoc()
	{
		NPC_HOME_LOC = Text(OriginOf(ENT_ME));
	}

	// do_boom
	// <ent>
	void OnDoBoom(string sourceEntity = "")
	{
		DebugPrint("do_boom " + Text(RangeTo(sourceEntity)));
		if (!(RangeTo(sourceEntity) < EFFECT_DIST))
			return;

		float distRatio = Divide(RangeTo(sourceEntity), EFFECT_DIST);
		float boomDelay = Ratio(distRatio, 0.1f, 1);
		DebugPrint("do_boom " + Text(boomDelay));
		CallEventDelayed(boomDelay, "do_bob");
	}

	// do_bob
	void OnDoBob()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 200)));
	}

	// reset_block
	void OnResetBlock()
	{
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
	}

	// bury_block
	void OnBuryBlock()
	{
		SetSolid("none");
		Vector3 down16 = Vec(NPC_HOME_LOC);
		down16.z += -30.0f;
		SetOrigin(ENT_ME, down16);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBoomDelay() {} // BOOM_DELAY

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bury_block") { OnBuryBlock(); return true; }
		if (name == "do_bob") { OnDoBob(); return true; }
		if (name == "do_boom") { OnDoBoom(Param(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_home_loc") { OnGetHomeLoc(); return true; }
		if (name == "reset_block") { OnResetBlock(); return true; }
		return false;
	}
}
