#pragma context server

// Converted from monsters/summon/sfx_icewave.script by msc_transpiler.
// Thothie - adjust ring to be more likely to appear above heads of NPCs (rather than waste level)
// Stun ring
// PARAM1 - Stunned npc ID
// PARAM2 - Duration

#include "runtime/ScriptEntity.as"

[script "monsters/summon/sfx_icewave"]
class SfxIcewave : ScriptEntity
{
	// Constants
	int TILT_SPEED = 70;

	// Variables (an unset .script variable reads as its own name)
	float rheight = 0.0f;

	// unnamed block (timer)
	void SfxIcewave_Timer()
	{
		CallEventDelayed(0.01f, "SfxIcewave_Timer");

		OnSnapToOwner();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SetVar("script.owner", creatorValue1);
		SetVar("script.tilt", 1);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 53);
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetProp(ENT_ME, "solid", 0);
		SetAngle("angles.z", -20);
		SetFly(true);
		SetInvincible(true);
		PlayAnim("idle");
		SetAnimFrameRate(2);

		OnSnapToOwner();
		OnSetTilt();
		CallEventOrDelay(creatorValue2, "die");
	}

	// set_tilt
	void OnSetTilt()
	{
		CallEventDelayed(0.5f, "set_tilt");

		SetProp(ENT_ME, "avelocity", Vector3(0, 0, TILT_SPEED));
		SetVar("script.tilt", 1);
	}

	// snap_to_owner
	void OnSnapToOwner()
	{
		Vector3 pos = OriginOf("script.owner");
		rheight = 37.0f;

		if ((IsPlayer("script.owner") ? 1 : 0) == 0)
		{
			// //dbg OwnerHeight $get(script.owner,height) - odd, but this comes to 0
			rheight = HeightOf("script.owner") + 15.0f;
		}

		pos += Vector3(0, 0, rheight);

		SetOrigin(ENT_ME, pos);

		if (IsAlive("script.owner"))
			return;
	}

	// die
	void OnDie()
	{
		SetProp(ENT_ME, "avelocity", Vector3(0, 0, 0));
		DeleteEntity(ENT_ME, "fade 1");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(0.01f, "SfxIcewave_Timer");
		CallEventDelayed(0.5f, "set_tilt");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "die") { OnDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "set_tilt") { OnSetTilt(); return true; }
		if (name == "snap_to_owner") { OnSnapToOwner(); return true; }
		if (name == "SfxIcewave_Timer") { SfxIcewave_Timer(); return true; }
		return false;
	}
}
