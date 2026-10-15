#pragma context server

// Converted from items/proj_mana2_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_mana2_cl"]
class ProjMana2Cl : ScriptEntity
{
	// Constants
	string FX_MODEL = "weapons/projectiles.mdl";

	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	string FX_ANG = "FX_ANG";
	string FX_VEL = "FX_VEL";
	float BALL_SIZE = 0.0f;
	bool FX_ACTIVE = false;
	string FX_CUR_ORG = "FX_CUR_ORG";

	// client_activate
	// origin angle velocity ballSize
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_ANG = hand;
		FX_VEL = fxColor;
		BALL_SIZE = Float(lifetime);

		FX_ACTIVE = true;

		ClientEffect("tempent", "model", FX_MODEL, FX_ORIGIN, "setup_arrow", "update_arrow", "cl_projectile_collide");

		CallEventDelayed(10.0f, "end_fx"); // case we fail to collide/land for some reason
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		RemoveScript();
	}

	// remove_fx
	void OnRemoveFx()
	{
		FX_ACTIVE = false;
		RemoveScript();
	}

	// reduce_size
	void OnReduceSize()
	{
		BALL_SIZE -= 1.0f;
		if (BALL_SIZE == 0.0f)
			FX_ACTIVE = false;
	}

	// update_arrow
	void OnUpdateArrow()
	{
		ClientEffect("tempent", "set_current_prop", "scale", BALL_SIZE * 0.75f);

		if (FX_ACTIVE)
			FX_CUR_ORG = Eval("game.tempent.origin");
		else
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
	}

	// setup_arrow
	void OnSetupArrow()
	{
		ClientEffect("tempent", "set_current_prop", "origin", FX_ORIGIN);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "scale", BALL_SIZE * 0.75f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", FX_ANG);
		ClientEffect("tempent", "set_current_prop", "velocity", FX_VEL);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "body", 13);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 16);
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "cb_collide", "cl_projectile_collide");
	}

	// cl_projectile_collide
	void OnClProjectileCollide()
	{
		OnEndFx();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_projectile_collide") { OnClProjectileCollide(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "reduce_size") { OnReduceSize(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_arrow") { OnSetupArrow(); return true; }
		if (name == "update_arrow") { OnUpdateArrow(); return true; }
		return false;
	}
}
