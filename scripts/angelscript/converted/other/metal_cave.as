#pragma context server

// Converted from other/metal_cave.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "other/metal_cave"]
class MetalCave : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	float DEBUG_ANG = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("terrain/metal_caverns_01b.mdl");
		SetUniqueName("metal_cave");
		SetSolid("none");
		SetInvincible(true);
		SetNoPush(true);
		SetGravity(0);
		SetFly(true);
		SetName("");
		SetRoam(false);
		PLAYING_DEAD = "1";

		DEBUG_ANG = 0.0f;

		SetAngle("face", Vector3(0, 270, 0));

		CallEventDelayed(0.5f, "refresh_cl_fx");
	}

	// refresh_cl_fx
	void OnRefreshClFx()
	{
		// consider making light color change over time (new cl effect)
		// clientevent new all other/metal_cave_cl $get(ent_me,index) (255,0,255) 768 60.0
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "cl_metal_cave_light", IndexOf(ENT_ME));
	}

	// ext_refresh_cl_fx
	void OnExtRefreshClFx()
	{
		OnRefreshClFx();
	}

	// ext_turn
	void OnExtTurn(string yaw = "")
	{
		if (yaw.isEmpty())
		{
			DEBUG_ANG += 5.0f;
			yaw = Text(DEBUG_ANG);
		}

		SetAngle("face", Vector3(0, Float(yaw), 0));

		DebugPrint("ext_turn " + yaw);
	}

	// ext_clearout
	void OnExtClearout()
	{
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "cl_metal_cave_light_end", IndexOf(ENT_ME));
		SetVar("PLAYER_LIST", GetActivePlayers());
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTelePlayers();
		}
	}

	// tele_players
	void OnTelePlayers()
	{
		string curTarg = GetToken("PLAYER_LIST", loopIteration);
		if (Range2DTo(curTarg) < 896.0f)
			LegacyCommand("tospawn", curTarg, "from_tear");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("terrain/metal_caverns_01b.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_clearout") { OnExtClearout(); return true; }
		if (name == "ext_refresh_cl_fx") { OnExtRefreshClFx(); return true; }
		if (name == "ext_turn") { OnExtTurn(Param(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "refresh_cl_fx") { OnRefreshClFx(); return true; }
		if (name == "tele_players") { OnTelePlayers(); return true; }
		return false;
	}
}
