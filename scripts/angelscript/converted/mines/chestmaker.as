#pragma context server

// Converted from mines/chestmaker.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "mines/chestmaker"]
class MinesChestmaker : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("spawner");
		SetFly(true);
		SetInvincible(true);
		DebugPrint("chest_maker spawned");
		CallEventDelayed(0.1f, "make_chest");
	}

	// make_chest
	void OnMakeChest()
	{
		int roll = RandomInt(1, 6);
		if (roll == 1)
		{
			DebugPrint("spawning chest_great");
			CreateNpc("mines/chest_great", OriginOf(ENT_ME));
		}
		if (roll != 1)
		{
			DebugPrint("spawning chest_good");
			CreateNpc("mines/chest_good", OriginOf(ENT_ME));
		}

		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_chest") { OnMakeChest(); return true; }
		return false;
	}
}
