#pragma context server

// Converted from items/item_sorcv_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/item_sorcv_cl"]
class ItemSorcvCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_POS = Vector3();
	string FX_FRAME = "FX_FRAME";
	string FX_YAW = "FX_YAW";
	float FX_DURATION = 0.0f;

	// client_activate
	// <position> <frame> <yaw> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_POS = Vec(owner);
		FX_FRAME = hand;
		FX_YAW = fxColor;
		FX_DURATION = Float(lifetime);

		SetCallback("render", "enable");

		PlaySound3D("ambience/goal_1.wav", 10, FX_POS);
		ClientEffect("tempent", "sprite", "medals.spr", FX_POS, "setup_sprite", "update_sprite");
		ClientEffect("tempent", "sprite", "medals.spr", FX_POS, "setup_flip_sprite", "update_flip_sprite");

		float dur = FX_DURATION + 1.0f;
		CallEventDelayed(dur, "remove_me");
	}

	// update_sprite
	void OnUpdateSprite()
	{
		ClientEffect("tempent", "set_current_prop", "frame", FX_FRAME);
	}

	// update_flip_sprite
	void OnUpdateFlipSprite()
	{
		ClientEffect("tempent", "set_current_prop", "frame", FX_FRAME);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// setup_sprite
	void OnSetupSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
		ClientEffect("tempent", "set_current_prop", "framerate", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "frame", FX_FRAME);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, Float(FX_YAW), 0));
	}

	// setup_flip_sprite
	void OnSetupFlipSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
		ClientEffect("tempent", "set_current_prop", "framerate", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "frame", FX_FRAME);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		float negYaw = Float(FX_YAW);
		negYaw += 180.0f;
		if (negYaw > 359.99f)
			negYaw -= 359.99f;
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, negYaw, 0));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnLDur() {} // L_DUR

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_flip_sprite") { OnSetupFlipSprite(); return true; }
		if (name == "setup_sprite") { OnSetupSprite(); return true; }
		if (name == "update_flip_sprite") { OnUpdateFlipSprite(); return true; }
		if (name == "update_sprite") { OnUpdateSprite(); return true; }
		return false;
	}
}
