#pragma context server

// Converted from monsters/shadow_form_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/shadow_form_cl"]
class ShadowFormCl : ScriptEntity
{
	// Constants
	string FX_WIDTH = "48";
	int FX_HEIGHT = 48;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	float NEG_FX_WIDTH = 0.0f;
	float NEG_FX_HEIGHT = 0.0f;
	float SHADOW_X_OFF = 0.0f;
	float SHADOW_Y_OFF = 0.0f;
	float SHADOW_Z_OFF = 0.0f;
	bool DEATH_MODE = false;

	// client_activate
	// <index> <delay>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_ACTIVE = true;

		NEG_FX_WIDTH = -Float(FX_WIDTH);
		NEG_FX_HEIGHT = -FX_HEIGHT;

		OnDoShadows();
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		if (DEATH_MODE)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// do_shadows
	void OnDoShadows()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.25f, "do_shadows");

		Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));

		SHADOW_X_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Y_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Z_OFF = Random(NEG_FX_HEIGHT, FX_HEIGHT);
		sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(SHADOW_X_OFF, SHADOW_Y_OFF, SHADOW_Z_OFF));

		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows", "update_shadows");

		sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));

		SHADOW_X_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Y_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Z_OFF = Random(NEG_FX_HEIGHT, FX_HEIGHT);
		sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(SHADOW_X_OFF, SHADOW_Y_OFF, SHADOW_Z_OFF));

		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows", "update_shadows");

		sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));

		SHADOW_X_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Y_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Z_OFF = Random(NEG_FX_HEIGHT, FX_HEIGHT);
		sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(SHADOW_X_OFF, SHADOW_Y_OFF, SHADOW_Z_OFF));

		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows", "update_shadows");

		sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));

		SHADOW_X_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Y_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Z_OFF = Random(NEG_FX_HEIGHT, FX_HEIGHT);
		sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(SHADOW_X_OFF, SHADOW_Y_OFF, SHADOW_Z_OFF));

		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows", "update_shadows");

		sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));

		SHADOW_X_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Y_OFF = Random(NEG_FX_WIDTH, Float(FX_WIDTH));
		SHADOW_Z_OFF = Random(NEG_FX_HEIGHT, FX_HEIGHT);
		sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(SHADOW_X_OFF, SHADOW_Y_OFF, SHADOW_Z_OFF));
		sprPos.z += 32.0f;

		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows", "update_shadows");
	}

	// update_shadows
	void OnUpdateShadows()
	{
		if (!DEATH_MODE)
		{
			Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin")); // suspect we'll have to keep updating this :/
			sprPos.z += 32.0f;
			int myXOff = Int(Eval("game.tempent.fuser1"));
			int myYOff = Int(Eval("game.tempent.fuser2"));
			int myZOff = Int(Eval("game.tempent.fuser3"));
			sprPos += RelativePosition(Vector3(0, 0, 0), Vector3(myXOff, myYOff, myZOff));
			ClientEffect("tempent", "set_current_prop", "origin", sprPos);
		}
		else
		{
			float curScale = Float(Eval("game.tempent.fuser4"));
			curScale -= 0.2f;
			if (curScale < 0.0f)
			{
				curScale = 0.01f;
				ClientEffect("tempent", "set_current_prop", "framerate", 30);
			}
			ClientEffect("tempent", "set_current_prop", "scale", curScale);

			string curYaw = Eval("game.tempent.fuser1");

			if (Float(curYaw) != 999.0f)
			{
				curYaw = Text(Random(0, 359));
				ClientEffect("tempent", "set_current_prop", "angles.yaw", curYaw);
				ClientEffect("tempent", "set_current_prop", "velocity.y", Random(-100, 100));
				ClientEffect("tempent", "set_current_prop", "fuser1", 999);
				ClientEffect("tempent", "set_current_prop", "framerate", 5);
				ClientEffect("tempent", "set_current_prop", "gravity", -0.5f);
			}
		}
	}

	// shadow_death
	void OnShadowDeath()
	{
		DEATH_MODE = true;
		FX_ACTIVE = false;
		CallEventDelayed(4.0f, "remove_fx");
	}

	// setup_shadows
	void OnSetupShadows()
	{
		float rndScale = Random(0.4f, 0.6f);
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.4f, 0.6f));
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		ClientEffect("tempent", "set_current_prop", "fuser1", SHADOW_X_OFF);
		ClientEffect("tempent", "set_current_prop", "fuser2", SHADOW_Y_OFF);
		ClientEffect("tempent", "set_current_prop", "fuser3", SHADOW_Z_OFF);
		ClientEffect("tempent", "set_current_prop", "fuser4", rndScale);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_shadows") { OnDoShadows(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_shadows") { OnSetupShadows(); return true; }
		if (name == "shadow_death") { OnShadowDeath(); return true; }
		if (name == "update_shadows") { OnUpdateShadows(); return true; }
		return false;
	}
}
