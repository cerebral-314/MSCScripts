#pragma context server

// Converted from other/ice_wall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "other/ice_wall"]
class OtherIceWall : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float ROT_COUNT = 0.0f;
	bool IS_ACTIVE = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// ame_unique scripted_ice_wall
		SetInvincible(true);
	}

	// activate_wall
	// <target>
	void OnActivateWall(string target = "")
	{
		DebugPrint("activate_wall " + Text(OriginOf(target)));
		SetOrigin(ENT_ME, OriginOf(target));
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		if (IS_ACTIVE)
			return;
		ROT_COUNT = 0.0f;
		IS_ACTIVE = true;
		OnSpinLoop();
	}

	// spin_loop
	void OnSpinLoop()
	{
		if (!IS_ACTIVE)
			return;
		ROT_COUNT += 1.0f;
		if (ROT_COUNT > 359.0f)
			ROT_COUNT = 0.0f;
		SetAngle("face", Vector3(0, ROT_COUNT, 0));
		CallEventDelayed(0.1f, "spin_loop");
	}

	// deactivate_wall
	void OnDeactivateWall()
	{
		IS_ACTIVE = false;
		CallEventDelayed(2.0f, "hide_wall");
	}

	// hide_wall
	void OnHideWall()
	{
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "activate_wall") { OnActivateWall(Param(params, 0)); return true; }
		if (name == "deactivate_wall") { OnDeactivateWall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "hide_wall") { OnHideWall(); return true; }
		if (name == "spin_loop") { OnSpinLoop(); return true; }
		return false;
	}
}
