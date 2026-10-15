#pragma context server

// Converted from other/catapault.script by msc_transpiler.
// Invisible NPC to be triggered either via another NPC or msnpc_script

#include "runtime/ScriptEntity.as"

[script "other/catapault"]
class Catapault : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("catapault");
		// setmodel null.mdl
		SetFly(true);
		SetGravity(0);
		SetInvincible(true);
		SetNoPush(true);
		SetRace("orc");
		SetWidth(1);
		SetHeight(1);
		PLAYING_DEAD = "1";
		SetIdleAnim("none");
		SetMoveAnim("none");
	}

	// OneBall
	void OnOneBall()
	{
		OnCatapaults(1);
	}

	// FiveBalls
	void OnFiveBalls()
	{
		OnCatapaults(5);
	}

	// Catapaults
	void OnCatapaults(int catapultCount = 0)
	{
		// debugprint Preparing the catapaults!
		// debugprint PARAM1 balls incoming!
		for (int i = 0; i < catapultCount; i++)
		{
			loopIteration = i;
			OnFireCatapault();
		}
		CallExternal("all", "CatapaultsIncoming");
	}

	// FireCatapault
	void OnFireCatapault()
	{
		CallEventDelayed(0.0f, Text(Random(0, 1.5f)));
	}

	// CatapaultShoot
	void OnCatapaultShoot()
	{
		// local xoff $rand(-50,50)
		// local yoff $rand(-50,50)
		// local zoff $rand(-50,50)
		// debugprint Firing! - x y z
		// local L_MAP_NAME $lcase(game.map.name)
		if (Contains(ToLowerCase(MapName()), "helena"))
		{
			CallExternal("all", "catapults_fire");
			SetAngle("view", Vector3(20, 90, 0));
		}
		else
		{
			SetAngle("view", Vector3(20, Float(Eval("game.monster.angles.yaw")), 0));
		}

		// if ( L_MAP_NAME equals helena2 ) setangle view (20,90,0)
		TossProjectile("proj_catapaultball", RelativePosition(Vector3(0, 0, 0)), "none", 1000, 1000, 30, "none");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "CatapaultShoot") { OnCatapaultShoot(); return true; }
		if (name == "Catapaults") { OnCatapaults(Int(Param(params, 0))); return true; }
		if (name == "FireCatapault") { OnFireCatapault(); return true; }
		if (name == "FiveBalls") { OnFiveBalls(); return true; }
		if (name == "OneBall") { OnOneBall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
