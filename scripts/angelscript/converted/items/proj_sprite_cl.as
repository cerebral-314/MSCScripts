#pragma context server

// Converted from items/proj_sprite_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_sprite_cl"]
class ProjSpriteCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	Vector3 FX_ORIGIN = Vector3();
	string FX_ANG = "FX_ANG";
	string FX_VEL = "FX_VEL";
	string FX_SPRITE = "FX_SPRITE";
	bool FX_ACTIVE = false;

	// client_activate
	// <proj_index> <sprite_name>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ORIGIN = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		FX_ANG = LegacyFunction("getcl", FX_OWNER, "angles");
		FX_VEL = LegacyFunction("getcl", FX_OWNER, "velocity");
		FX_SPRITE = hand;
		FX_ACTIVE = true;
		ClientEffect("tempent", "sprite", FX_SPRITE, FX_ORIGIN, "setup_proj_sprite", "update_proj_sprite");
	}

	// update_proj_sprite
	void OnUpdateProjSprite()
	{
		if (FX_ACTIVE)
		{
			ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", FX_OWNER, "origin"));
			ClientEffect("tempent", "set_current_prop", "velocity", LegacyFunction("getcl", FX_OWNER, "velocity"));
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(5000, 5000, 5000));
		}
	}

	// proj_landed
	void OnProjLanded()
	{
		FX_ACTIVE = false;
		CallEventDelayed(0.2f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_proj_sprite
	void OnSetupProjSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 60.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", FX_ANG);
		ClientEffect("tempent", "set_current_prop", "velocity", FX_VEL);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "proj_landed") { OnProjLanded(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_proj_sprite") { OnSetupProjSprite(); return true; }
		if (name == "update_proj_sprite") { OnUpdateProjSprite(); return true; }
		return false;
	}
}
