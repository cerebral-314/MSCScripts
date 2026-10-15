#pragma context server

// Converted from items/proj_crescent_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_crescent_cl"]
class ProjCrescentCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float CUR_ANG = 0.0f;
	string CUR_VEL = "CUR_VEL";
	string CUR_ORG = "CUR_ORG";
	bool IS_ACTIVE = false;
	bool UPDATE_VEL = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		CUR_ANG = Float(hand);
		CUR_VEL = fxColor;
		CUR_ORG = lifetime;
		SetCallback("render", "enable");
		IS_ACTIVE = true;
		// dbg **** client_activate CUR_ORG
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", CUR_ORG, "setup_cre", "update_cre");
		CallEventDelayed(3.0f, "end_fx");
	}

	// sv_update_vel
	void OnSvUpdateVel(float angles = 0.0f, string velocity = "", string origin = "")
	{
		CUR_ANG = angles;
		CUR_VEL = velocity;
		CUR_ORG = origin;
		UPDATE_VEL = true;
	}

	// update_cre
	void OnUpdateCre()
	{
		if (IS_ACTIVE)
		{
			if (UPDATE_VEL)
			{
				ClientEffect("tempent", "set_current_prop", "angles", CUR_ANG);
				ClientEffect("tempent", "set_current_prop", "velocity", CUR_VEL);
				// cleffect tempent set_current_prop origin CUR_ORG
				UPDATE_VEL = false;
			}
		}
		else
		{
			// if ( CUR_ANG isnot OLD_ANG )
			// {
			// setvard ANG_DIFF_X $anglediff($vec.x(CUR_ANG),$vec.x(OLD_ANG))
			// setvard ANG_DIFF_Y $anglediff($vec.y(CUR_ANG),$vec.y(OLD_ANG))
			// setvard ANG_DIFF_Z $anglediff($vec.z(CUR_ANG),$vec.z(OLD_ANG))
			// if ( ANG_DIFF_X != 0 ) divide ANG_DIFF_X 360
			// if ( ANG_DIFF_Y != 0 ) divide ANG_DIFF_Y 360
			// if ( ANG_DIFF_Z != 0 ) divide ANG_DIFF_Z 360
			// setvard DO_TURN 1
			// }
			// setvard OLD_ANG CUR_ANG
			// if ( DO_TURN )
			// {
			// local CUR_CL_ANG game.tempent.angles
			// local CUR_CL_ANG_X $vec.x(CUR_CL_ANG)
			// local CUR_CL_ANG_Y $vec.y(CUR_CL_ANG)
			// local CUR_CL_ANG_Z $vec.z(CUR_CL_ANG)
			// local L_ANG_DIFF_X ANG_DIFF_X
			// local L_ANG_DIFF_Y ANG_DIFF_Y
			// local L_ANG_DIFF_Z ANG_DIFF_Z
			// multiply L_ANG_DIFF_X 0.5
			// multiply L_ANG_DIFF_Y 0.5
			// multiply L_ANG_DIFF_Z 0.5
			// add CUR_CL_ANG_X L_ANG_DIFF_X
			// add CUR_CL_ANG_Y L_ANG_DIFF_Y
			// add CUR_CL_ANG_Z L_ANG_DIFF_Z
			// local NEW_CL_ANG $vec(CUR_CL_ANG_X,CUR_CL_ANG_Y,CUR_CL_ANG_Z)
			// cleffect tempent set_current_prop angles NEW_CL_ANG
			// }
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 0, 0));
		}
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		IS_ACTIVE = false;
		CallEventDelayed(0.2f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_cre
	void OnSetupCre()
	{
		ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", FX_OWNER, "origin"));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", CUR_ANG);
		ClientEffect("tempent", "set_current_prop", "velocity", CUR_VEL); // $relvel(OWNER_ANG,$vec(0,1000,0))
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "body", 71);
		// cleffect tempent set_current_prop fadeout lifetime
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 16);
		ClientEffect("tempent", "set_current_prop", "sequence", 11); // maybe adjust based on throw anim
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cre") { OnSetupCre(); return true; }
		if (name == "sv_update_vel") { OnSvUpdateVel(Float(Param(params, 0)), Param(params, 1), Param(params, 2)); return true; }
		if (name == "update_cre") { OnUpdateCre(); return true; }
		return false;
	}
}
