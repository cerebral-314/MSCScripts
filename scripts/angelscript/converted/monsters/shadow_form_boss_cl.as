#pragma context server

// Converted from monsters/shadow_form_boss_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/shadow_form_boss_cl"]
class ShadowFormBossCl : ScriptEntity
{
	// Constants
	int V_ADJ = 48;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;
	string OWNER_ORG = "OWNER_ORG";
	string FX_RADIUS = "FX_RADIUS";
	float START_SCALE = 0.0f;
	float ROT_DIR = 0.0f;
	float CUR_ROT = 0.0f;
	bool BOSS_DEAD = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ACTIVE = true;
		CallEventDelayed(30.0f, "end_fx");
		OnFxLoop();
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		if (BOSS_DEAD)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// end_fx_post_boss
	void OnEndFxPostBoss()
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		OWNER_ORG = LegacyFunction("getcl", FX_OWNER, "origin");
		// callevent 1.0 fx_loop
		FX_RADIUS = "90";
		START_SCALE = 1.0f;
		ROT_DIR = -0.1f;
		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnMakeSmokes();
		}
		FX_RADIUS = "180";
		START_SCALE = 0.8f;
		ROT_DIR = 0.1f;
		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnMakeSmokes();
		}
		FX_RADIUS = "270";
		START_SCALE = 0.6f;
		ROT_DIR = -0.1f;
		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnMakeSmokes();
		}
	}

	// make_smokes
	void OnMakeSmokes()
	{
		CUR_ROT = loopIteration * 20.0f;
		Vector3 sprPos = Vec(OWNER_ORG);
		sprPos += RelativePosition(Vector3(0, CUR_ROT, 0), Vector3(0, Float(FX_RADIUS), V_ADJ));
		ClientEffect("tempent", "sprite", "shadowfog.spr", sprPos, "setup_shadows1", "update_shadows1");
	}

	// boss_died
	void OnBossDied()
	{
		BOSS_DEAD = true;
		CallEventDelayed(10.0f, "end_fx_post_boss");
	}

	// update_shadows1
	void OnUpdateShadows1()
	{
		float rot = 0.0f;

		if (!FX_ACTIVE)
			return;

		if (BOSS_DEAD)
		{
			Vector3 sprVel = RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 0));
			rot = Float(Eval("game.tempent.fuser2")); // current rotation
			sprVel += RelativeVelocity(Vector3(0, rot, 0), Vector3(0, 100, 0));
			ClientEffect("tempent", "set_current_prop", "velocity", sprVel);
		}

		if (BOSS_DEAD)
			return;

		if (RandomInt(1, 10) == 1)
		{
			float curFrame = Float(Eval("game.tempent.fuser1"));
			curFrame += 1.0f;
			if (curFrame > 30.0f)
				curFrame = 20.0f;
			// dbg update_shadows1 CUR_FRAME
			ClientEffect("tempent", "set_current_prop", "frame", curFrame);
			ClientEffect("tempent", "set_current_prop", "fuser1", curFrame);
		}

		// cleffect tempent set_current_prop framerate 30
		rot = Float(Eval("game.tempent.fuser2")); // current rotation
		int dir = Int(Eval("game.tempent.fuser3")); // direction for this ring
		int rad = Int(Eval("game.tempent.fuser4")); // radius for this ring

		rot += dir;
		if (rot < 0.0f)
			rot = 359.99f;
		if (rot > 359.99f)
			rot = 0.0f;

		Vector3 sprPos = Vec(OWNER_ORG);
		sprPos += RelativePosition(Vector3(0, rot, 0), Vector3(0, rad, V_ADJ));
		ClientEffect("tempent", "set_current_prop", "origin", sprPos);
		ClientEffect("tempent", "set_current_prop", "fuser2", rot);
	}

	// setup_shadows1
	void OnSetupShadows1()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 30.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 20);
		ClientEffect("tempent", "set_current_prop", "frame", 20);
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", START_SCALE);
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "update", 1);

		ClientEffect("tempent", "set_current_prop", "fuser1", 20.0f);
		ClientEffect("tempent", "set_current_prop", "fuser2", CUR_ROT);
		ClientEffect("tempent", "set_current_prop", "fuser3", ROT_DIR);
		ClientEffect("tempent", "set_current_prop", "fuser4", FX_RADIUS);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "boss_died") { OnBossDied(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "end_fx_post_boss") { OnEndFxPostBoss(); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "make_smokes") { OnMakeSmokes(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_shadows1") { OnSetupShadows1(); return true; }
		if (name == "update_shadows1") { OnUpdateShadows1(); return true; }
		return false;
	}
}
