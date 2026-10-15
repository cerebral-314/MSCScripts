#pragma context server

// Converted from items/blunt_staff_i_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/blunt_staff_i_cl"]
class BluntStaffICl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ACTIVE = true;
		OnFxLoop();
		CallEventDelayed(20.0f, "end_fx");

		Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		sprPos.z = GroundHeight(sprPos);
		ClientEffect("decal", 16, LegacyFunction("getcl", FX_OWNER, "origin"), sprPos);
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		if (!FX_ACTIVE)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(5.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.01f, "fx_loop");
		Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		sprPos.z = GroundHeight(sprPos);
		sprPos.x += Random(-10, 10);
		sprPos.y += Random(-10, 10);
		// setvard FIX_FRAME $rand(0,9)
		// cleffect tempent sprite bloodspray.spr SPR_POS setup_ice_sprite update_ice_sprite
		ClientEffect("decal", 17, LegacyFunction("getcl", FX_OWNER, "origin"), sprPos);
	}

	// update_ice_sprite
	void OnUpdateIceSprite()
	{
		string fixFrame = Eval("game.tempent.fuser1");
		ClientEffect("tempent", "set_current_prop", "frame", fixFrame);
	}

	// setup_ice_sprite
	void OnSetupIceSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(200, 200, 255));
		ClientEffect("tempent", "set_current_prop", "framerate", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "frame", "FIX_FRAME");
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "fuser1", "FIX_FRAME");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_ice_sprite") { OnSetupIceSprite(); return true; }
		if (name == "update_ice_sprite") { OnUpdateIceSprite(); return true; }
		return false;
	}
}
