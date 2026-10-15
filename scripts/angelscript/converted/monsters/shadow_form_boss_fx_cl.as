#pragma context server

// Converted from monsters/shadow_form_boss_fx_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/shadow_form_boss_fx_cl"]
class ShadowFormBossFxCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ACTIVE = true;
		OnDoTrackerLoop();
		OnDoSmokesLoop();
		CallEventDelayed(30.0f, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// do_smokes_loop
	void OnDoSmokesLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.5f, "do_smokes_loop");
		string sprPos = LegacyFunction("getcl", FX_OWNER, "attachment0");
		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows2", "update_shadows2");
		sprPos = LegacyFunction("getcl", FX_OWNER, "attachment1");
		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows2", "update_shadows2");
		sprPos = LegacyFunction("getcl", FX_OWNER, "attachment2");
		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows2", "update_shadows2");
		sprPos = LegacyFunction("getcl", FX_OWNER, "attachment3");
		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows2", "update_shadows2");
	}

	// update_shadows2
	void OnUpdateShadows2()
	{
		float curFrame = Float(Eval("game.tempent.fuser1"));
		curFrame += 1.0f;
		if (curFrame > 30.0f)
			curFrame = 20.0f;
		// dbg update_shadows1 CUR_FRAME
		ClientEffect("tempent", "set_current_prop", "frame", curFrame);
		ClientEffect("tempent", "set_current_prop", "fuser1", curFrame);

		float curScale = Float(Eval("game.tempent.fuser2"));
		curScale -= 0.01f;
		if (curScale <= 0.01f)
		{
			curScale = 0.0f;
			ClientEffect("tempent", "set_current_prop", "renderamt", 0);
		}
		ClientEffect("tempent", "set_current_prop", "fuser2", curScale);
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
	}

	// setup_shadows2
	void OnSetupShadows2()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 20);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frame", 39);
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.4f, 0.6f));
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "update", 1);

		ClientEffect("tempent", "set_current_prop", "fuser1", 20);
		ClientEffect("tempent", "set_current_prop", "fuser2", 2.0f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDoTrackerLoop() {} // do_tracker_loop

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_smokes_loop") { OnDoSmokesLoop(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_shadows2") { OnSetupShadows2(); return true; }
		if (name == "update_shadows2") { OnUpdateShadows2(); return true; }
		return false;
	}
}
