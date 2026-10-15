#pragma context server

// Converted from monsters/djinn_ogre_fire_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/djinn_ogre_fire_cl"]
class DjinnOgreFireCl : ScriptEntity
{
	// Constants
	float GLOW_RAD = 128.0f;
	Vector3 GLOW_COLOR = Vector3();
	string FLAME_SPRITE = "explode1.spr";
	int N_FRAMES = 9;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	string MY_LIGHT_ID = "MY_LIGHT_ID";
	string RIGHT_HAND_POS = "RIGHT_HAND_POS";
	string LEFT_HAND_POS = "LEFT_HAND_POS";
	bool FX_STORM_ON = false;
	string CLOUD_ANG = "CLOUD_ANG";

	// unnamed block (timer)
	void DjinnOgreFireCl_Timer()
	{
		CallEventDelayed(0.01f, "DjinnOgreFireCl_Timer");
		RIGHT_HAND_POS = LegacyFunction("getcl", FX_OWNER, "attachment0");
		LEFT_HAND_POS = LegacyFunction("getcl", FX_OWNER, "attachment1");
	}

	// client_activate
	// <owner> <duration> <fire_storm_on>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);

		SetCallback("render", "enable");

		FX_ACTIVE = true;

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), GLOW_RAD, GLOW_COLOR, 5.0f);
		MY_LIGHT_ID = Eval("game.script.last_light_id");

		RIGHT_HAND_POS = LegacyFunction("getcl", FX_OWNER, "attachment0");
		LEFT_HAND_POS = LegacyFunction("getcl", FX_OWNER, "attachment1");

		ClientEffect("tempent", "sprite", "Fire1_fixed.spr", RIGHT_HAND_POS, "setup_hand_sprite", "update_rhand_sprite");
		ClientEffect("tempent", "sprite", "Fire1_fixed.spr", LEFT_HAND_POS, "setup_hand_sprite", "update_lhand_sprite");

		if (Float(fxColor) == 1.0f)
			OnFireStormOn();

		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!FX_ACTIVE)
			return;
		string pos = LegacyFunction("getcl", FX_OWNER, "origin");
		ClientEffect("light", MY_LIGHT_ID, pos, GLOW_RAD, GLOW_COLOR, 1.0f);
	}

	// update_rhand_sprite
	void OnUpdateRhandSprite()
	{
		if (FX_ACTIVE)
			ClientEffect("tempent", "set_current_prop", "origin", RIGHT_HAND_POS);
		else
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
	}

	// update_lhand_sprite
	void OnUpdateLhandSprite()
	{
		if (FX_ACTIVE)
			ClientEffect("tempent", "set_current_prop", "origin", LEFT_HAND_POS);
		else
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
	}

	// fire_storm_on
	void OnFireStormOn()
	{
		FX_STORM_ON = true;
		OnFireStormLoop();
	}

	// fire_storm_off
	void OnFireStormOff()
	{
		FX_STORM_ON = false;
	}

	// fire_storm_loop
	void OnFireStormLoop()
	{
		if (!FX_STORM_ON)
			return;
		OnMakeCloud(RIGHT_HAND_POS, LegacyFunction("getcl", FX_OWNER, "angles"));
		OnMakeCloud(LEFT_HAND_POS, LegacyFunction("getcl", FX_OWNER, "angles"));
		CallEventDelayed(0.1f, "fire_storm_loop");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		FX_STORM_ON = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// make_cloud
	// <origin> <angles>
	void OnMakeCloud(string origin = "", string angles = "")
	{
		// dbg make_cloud PARAM1 PARAM2
		CLOUD_ANG = angles;
		ClientEffect("tempent", "sprite", FLAME_SPRITE, origin, "setup_cloud", "update_cloud");
	}

	// update_cloud
	void OnUpdateCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (curScale < 2.0f)
		{
			curScale += 0.1f;
			ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", "N_FRAME");
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
		ClientEffect("tempent", "set_current_prop", "angles", CLOUD_ANG);

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vec(CLOUD_ANG), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// setup_hand_sprite
	void OnSetupHandSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 255));
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 23);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.01f, "DjinnOgreFireCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fire_storm_loop") { OnFireStormLoop(); return true; }
		if (name == "fire_storm_off") { OnFireStormOff(); return true; }
		if (name == "fire_storm_on") { OnFireStormOn(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "make_cloud") { OnMakeCloud(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_hand_sprite") { OnSetupHandSprite(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "update_lhand_sprite") { OnUpdateLhandSprite(); return true; }
		if (name == "update_rhand_sprite") { OnUpdateRhandSprite(); return true; }
		if (name == "DjinnOgreFireCl_Timer") { DjinnOgreFireCl_Timer(); return true; }
		return false;
	}
}
