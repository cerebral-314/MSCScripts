#pragma context server

// Converted from monsters/bat_large_shreaker_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/bat_large_shreaker_cl"]
class BatLargeShreakerCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	float FX_MAX_SCALE = 0.0f;
	string FX_OWNER = "FX_OWNER";
	string FX_SKIN = "FX_SKIN";
	string FX_ANIM = "FX_ANIM";
	bool NO_BLUR = false;
	bool FX_ACTIVE = false;
	bool VEL_X = false;
	float VEL_R = 0.0f;
	string BLUR_ANG = "BLUR_ANG";
	Vector3 BLUR_VEL = Vector3();

	// client_activate
	// <origin> <scale> [owner_index] [skin] [anim_seq#] [attach]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		string sprPos = "SPR_POS";
		FX_ORIGIN = Vec(owner);
		FX_MAX_SCALE = Float(hand);
		FX_OWNER = fxColor;
		FX_SKIN = lifetime;
		FX_ANIM = sprite;
		if (FX_OWNER.isEmpty())
			NO_BLUR = true;
		FX_ACTIVE = true;
		CallEventDelayed(5.0f, "end_fx");

		PlaySound3D("magic/sff_explsonic.wav", 10, FX_ORIGIN);

		// vectoradd SPR_POS z -48 //dunno why this thing's center is wrong
		// local GROUND_LEVEL $get_ground_height(SPR_POS)
		// if ( $vec.z(SPR_POS) < GROUND_LEVEL ) vectorset SPR_POS z GROUND_LEVEL
		if (flag.isEmpty())
		{
			sprPos = Text(FX_ORIGIN);
		}
		else
		{
			if (Float(flag) == 0.0f)
				sprPos = LegacyFunction("getcl", FX_OWNER, "attachment0");
			if (Float(flag) == 1.0f)
				sprPos = LegacyFunction("getcl", FX_OWNER, "attachment1");
			if (Float(flag) == 2.0f)
				sprPos = LegacyFunction("getcl", FX_OWNER, "attachment2");
			if (Float(flag) == 3.0f)
				sprPos = LegacyFunction("getcl", FX_OWNER, "attachment3");

			DebugPrint("*** " + sprPos);
		}
		ClientEffect("tempent", "model", "monsters/zubat_sphere.mdl", LegacyFunction("getcl", FX_OWNER, "origin"), "setup_sphere", "update_sphere");

		if (NO_BLUR)
			return;
		VEL_X = false;
		for (int i = 0; i < 8; i++)
		{
			loopIteration = i;
			OnBlurLoop();
		}
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// blur_loop
	void OnBlurLoop()
	{
		VEL_R += 20.0f;
		BLUR_ANG = LegacyFunction("getcl", FX_OWNER, "angles");

		BLUR_VEL = RelativeVelocity(Vec(BLUR_ANG), Vector3(-VEL_R, 0, 0));
		ClientEffect("tempent", "model", LegacyFunction("getcl", FX_OWNER, "model"), LegacyFunction("getcl", FX_OWNER, "origin"), "setup_blur");
		BLUR_VEL = RelativeVelocity(Vec(BLUR_ANG), Vector3(VEL_R, 0, 0));
		ClientEffect("tempent", "model", LegacyFunction("getcl", FX_OWNER, "model"), LegacyFunction("getcl", FX_OWNER, "origin"), "setup_blur");
	}

	// setup_blur
	void OnSetupBlur()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "angles", BLUR_ANG);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 50);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "skin", FX_SKIN);
		ClientEffect("tempent", "set_current_prop", "velocity", BLUR_VEL);
		ClientEffect("tempent", "set_current_prop", "sequence", FX_ANIM);
	}

	// setup_sphere
	void OnSetupSphere()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 4.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", 2.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.25f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "sequence", 0); // 7
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 999);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(64, 64, 255));
		ClientEffect("tempent", "set_current_prop", "color", Vector3(64, 64, 255));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		// cleffect tempent set_current_prop body 65
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.25f);
	}

	// update_sphere
	void OnUpdateSphere()
	{
		if (FX_ACTIVE)
		{
			float curScale = Float(Eval("game.tempent.fuser1"));
			if (curScale < FX_MAX_SCALE)
			{
				curScale += 0.05f;
				ClientEffect("tempent", "set_current_prop", "scale", curScale);
				ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			}
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 2000)); // send off map for removal
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "blur_loop") { OnBlurLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_blur") { OnSetupBlur(); return true; }
		if (name == "setup_sphere") { OnSetupSphere(); return true; }
		if (name == "update_sphere") { OnUpdateSphere(); return true; }
		return false;
	}
}
