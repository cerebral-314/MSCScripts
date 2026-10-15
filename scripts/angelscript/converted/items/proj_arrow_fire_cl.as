#pragma context server

// Converted from items/proj_arrow_fire_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_arrow_fire_cl"]
class ProjArrowFireCl : ScriptEntity
{
	// Constants
	string SPR_FIRE = "fire1_fixed.spr";
	string SPR_SMOKE1 = "xsmoke3.spr";
	int N_FRAMES = 20;
	float LIGHT_RADIUS = 256.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	Vector3 FX_ORIGIN = Vector3();
	bool FX_ACTIVE = false;
	string SKEL_LIGHT_ID = "SKEL_LIGHT_ID";
	bool FX_SMOKES_ON = false;
	bool OWNER_TRANSFERED = false;
	bool FX_ORIGIN_FIXED = false;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;

		DebugPrint("client_activate");

		FX_ORIGIN = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));

		FX_ACTIVE = true;
		SetCallback("render", "enable");
		ClientEffect("light", "new", FX_ORIGIN, LIGHT_RADIUS, LIGHT_COLOR, 5.0f);
		SKEL_LIGHT_ID = Eval("game.script.last_light_id");

		ClientEffect("tempent", "sprite", SPR_FIRE, FX_ORIGIN, "setup_fire_sprite");

		FX_SMOKES_ON = true;
		OnDoSmokes();
		CallEventDelayed(10.0f, "end_smoke");
		CallEventDelayed(60.0f, "end_fx");
	}

	// transfer_owner
	void OnTransferOwner(string owner = "")
	{
		OWNER_TRANSFERED = true;
		FX_OWNER = owner;
		FX_ORIGIN = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));
		OnOwnerUpdate();
	}

	// owner_update
	void OnOwnerUpdate()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(1.0f, "owner_update");
		FX_ORIGIN = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));
	}

	// game_prerender
	void OnGamePrerender()
	{
		string pos;
		if (!FX_ACTIVE)
			return;
		if (!FX_ORIGIN_FIXED)
			pos = LegacyFunction("getcl", FX_OWNER, "attachment0");
		else
			pos = Text(FX_ORIGIN);

		if (pos == Text(Vector3(0, 0, 0)))
			OnEndFx();
		ClientEffect("light", SKEL_LIGHT_ID, pos, LIGHT_RADIUS, LIGHT_COLOR, 1.0f);
	}

	// end_smoke
	void OnEndSmoke()
	{
		FX_SMOKES_ON = false;
		if (OWNER_TRANSFERED)
			return;
		FX_ORIGIN = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));
		FX_ORIGIN_FIXED = true;
	}

	// do_smokes
	void OnDoSmokes()
	{
		string pos;
		if (!FX_SMOKES_ON)
			return;
		CallEventDelayed(Random(0.25f, 0.5f), "do_smokes");
		if (!FX_ORIGIN_FIXED)
			pos = LegacyFunction("getcl", FX_OWNER, "attachment0");
		else
			pos = Text(FX_ORIGIN);
		ClientEffect("tempent", "sprite", SPR_SMOKE1, pos, "setup_smoke");
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

	// setup_smoke
	void OnSetupSmoke()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", Random(100, 200));
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", Random(-0.2f, -0.01f));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(Random(-5, 5), Random(-5, 5), 0));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(32, 32, 32));
		// cleffect tempent set_current_prop rendermode 		alpha
		ClientEffect("tempent", "set_current_prop", "frames", N_FRAMES);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
	}

	// setup_fire_sprite
	void OnSetupFireSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "die_with_ent", FX_OWNER);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 128);
		ClientEffect("tempent", "set_current_prop", "scale", 0.3f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 128, 128));
		ClientEffect("tempent", "set_current_prop", "frames", 23);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "follow", FX_OWNER, 0);
	}

	// loop_sound
	void OnLoopSound()
	{
		if (!FX_ACTIVE)
			return;
		PlaySound3D("items/torch1.wav", 5, FX_ORIGIN);
		CallEventDelayed(6.0f, "loop_sound");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_smokes") { OnDoSmokes(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "end_smoke") { OnEndSmoke(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "loop_sound") { OnLoopSound(); return true; }
		if (name == "owner_update") { OnOwnerUpdate(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fire_sprite") { OnSetupFireSprite(); return true; }
		if (name == "setup_smoke") { OnSetupSmoke(); return true; }
		if (name == "transfer_owner") { OnTransferOwner(Param(params, 0)); return true; }
		return false;
	}
}
