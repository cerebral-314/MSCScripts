#pragma context server

// Converted from effects/sfx_bunny.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_bunny"]
class SfxBunny : ScriptEntity
{
	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetCallback("render", "enable");
		// local OWNER_IDX game.localplayer.eyepos
		Vector3 eyePos = Vec(Eval("game.localplayer.eyepos"));
		string eyeAngs = Eval("game.localplayer.viewangles");
		eyePos += RelativePosition(Vec(eyeAngs), Vector3(0, 20, 28));
		DebugPrint("*** client_activate " + Text(eyePos) + " " + eyeAngs);
		ClientEffect("tempent", "sprite", "bunny.spr", eyePos, "setup_bunny", "update_bunny");
		CallEventDelayed(20.0f, "remove_script");
		// playsound 0 10 ambience/the_horror1.wav
		PlaySound3D("ambience/the_horror1.wav", 10, eyePos);
	}

	// game_prerender
	void OnGamePrerender()
	{
	}

	// remove_script
	void OnRemoveScript()
	{
		RemoveScript();
	}

	// update_bunny
	void OnUpdateBunny()
	{
		// local OWNER_IDX game.localplayer.viewmodel.active.id
		Vector3 eyePos = Vec(Eval("game.localplayer.eyepos"));
		string eyeAngs = Eval("game.localplayer.viewangles");
		eyePos += RelativePosition(Vec(eyeAngs), Vector3(0, 20, 28));
		ClientEffect("tempent", "set_current_prop", "origin", eyePos);

		float curAlpha = Float(Eval("game.tempent.fuser1"));
		curAlpha += 1.0f;
		if (curAlpha > 255.0f)
			curAlpha = 200.0f;
		ClientEffect("tempent", "set_current_prop", "fuser1", curAlpha);
		ClientEffect("tempent", "set_current_prop", "renderamt", curAlpha);
	}

	// setup_bunny
	void OnSetupBunny()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 19.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 200);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_script") { OnRemoveScript(); return true; }
		if (name == "setup_bunny") { OnSetupBunny(); return true; }
		if (name == "update_bunny") { OnUpdateBunny(); return true; }
		return false;
	}
}
