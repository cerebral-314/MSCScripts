#pragma context server

// Converted from effects/sfx_icecage_old.script by msc_transpiler.
// Ice Cage by Thothie from sfx_stunring
// PARAM1 - Stunned npc ID
// PARAM2 - Duration

#include "runtime/ScriptEntity.as"

[script "effects/sfx_icecage_old"]
class SfxIcecageOld : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float rheight = 0.0f;

	// unnamed block (timer)
	void SfxIcecageOld_Timer()
	{
		CallEventDelayed(0.1f, "SfxIcecageOld_Timer");

		OnSnapToOwner();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SetVar("script.owner", creatorValue1);
		SetVar("script.tilt", 1);

		DebugPrint("ice cage spawn");
		CallExternal(creatorValue1, "freeze_solid_start", creatorValue2);

		SetModel("weapons/magic/icecage.mdl");
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetProp(ENT_ME, "solid", 0);
		SetAngle("angles.z", -20);
		SetFly(true);
		SetInvincible(true);
		PlayAnim("idle");
		SetAnimFrameRate(0);

		OnSnapToOwner();
		OnSetTilt();
		CallEventOrDelay(creatorValue2, "die");
	}

	// snap_to_owner
	void OnSnapToOwner()
	{
		Vector3 pos = OriginOf("script.owner");
		rheight = 0.0f;

		if ((IsPlayer("script.owner") ? 1 : 0) == 1)
		{
			rheight = 0.0f;
			pos += Vector3(0, 0, rheight);
		}

		SetOrigin(ENT_ME, pos);

		if (IsAlive("script.owner"))
			return;
	}

	// die
	void OnDie()
	{
		SetProp(ENT_ME, "avelocity", Vector3(0, 0, 0));
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSetTilt() {} // set_tilt

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/icecage.mdl");
		CallEventDelayed(0.1f, "SfxIcecageOld_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "die") { OnDie(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "snap_to_owner") { OnSnapToOwner(); return true; }
		if (name == "SfxIcecageOld_Timer") { SfxIcecageOld_Timer(); return true; }
		return false;
	}
}
