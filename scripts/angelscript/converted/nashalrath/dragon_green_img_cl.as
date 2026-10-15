#pragma context server

// Converted from nashalrath/dragon_green_img_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "nashalrath/dragon_green_img_cl"]
class DragonGreenImgCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string BREATH_TYPE = "BREATH_TYPE";
	float BREATH_YAW = 0.0f;
	Vector3 BREATH_COLOR = Vector3();
	bool FX_ACTIVE = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		BREATH_TYPE = hand;
		BREATH_YAW = Float(LegacyFunction("getcl", FX_OWNER, "angles"));
		BREATH_YAW = Vec(Text(BREATH_YAW)).y; // not sure if we can use angles.yaw client side

		// 1=fire 2=lightning 3=cold
		if (Float(BREATH_TYPE) == 1.0f)
			BREATH_COLOR = Vector3(255, 128, 0);
		if (Float(BREATH_TYPE) == 2.0f)
			BREATH_COLOR = Vector3(255, 255, 0);
		if (Float(BREATH_TYPE) == 3.0f)
			BREATH_COLOR = Vector3(64, 64, 255);

		FX_ACTIVE = true;
		OnBreathLoop();
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(Random(0.1f, 0.2f), "breath_loop");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "setup_breath_sprite", "update_breath_sprite");
	}

	// ext_breath_stop
	void OnExtBreathStop()
	{
		FX_ACTIVE = false;
		CallEventDelayed(8.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// update_breath_sprite
	void OnUpdateBreathSprite()
	{
		if (!FX_ACTIVE)
			return;

		if (Vec(Eval("game.tempent.origin")).z > -2100.0f)
		{
			ClientEffect("tempent", "set_current_prop", "gravity", 2); // not bouncing off ceiling for some reason
			ClientEffect("tempent", "set_current_prop", "fuser2", 1);
			// local CUR_VEL game.tempent.velocity
			// vectorset CUR_VEL z -800
			// cleffect tempent set_current_prop velocity CUR_VEL
			DebugPrint("update_breath_sprite adjust_down");
		}
		else if (Float(Eval("game.tempent.fuser2")) == 1.0f)
			ClientEffect("tempent", "set_current_prop", "gravity", -2);

		float curScale = Float(Eval("game.tempent.fuser1"));
		if (!(curScale < 20.0f))
			return;
		curScale += 0.1f;
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
	}

	// setup_breath_sprite
	void OnSetupBreathSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 6.0f);
		float breathYaw = BREATH_YAW + Random(-30, 30);
		float rndF = Random(100, 300);

		ClientEffect("tempent", "set_current_prop", "velocity", RelativePosition(Vector3(0, breathYaw, 0), Vector3(0, rndF, 0)));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 2);
		ClientEffect("tempent", "set_current_prop", "scale", 1);
		ClientEffect("tempent", "set_current_prop", "gravity", Random(-3, -2));
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", 1);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", BREATH_COLOR);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "ext_breath_stop") { OnExtBreathStop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_breath_sprite") { OnSetupBreathSprite(); return true; }
		if (name == "update_breath_sprite") { OnUpdateBreathSprite(); return true; }
		return false;
	}
}
