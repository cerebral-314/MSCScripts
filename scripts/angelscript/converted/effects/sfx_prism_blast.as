#pragma context server

// Converted from effects/sfx_prism_blast.script by msc_transpiler.
// originally, this was a rainbow blast of sorts
// came up too gay, so this effect no longer lives up to its name

#include "runtime/ScriptEntity.as"

[script "effects/sfx_prism_blast"]
class SfxPrismBlast : ScriptEntity
{
	// Constants
	string EFFECT_ELEMENTS = "acid;fire;cold;poison;dark;lightning;holy";
	string EFFECT_COLORS = "EFFECT_COLORS";

	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	string FX_AOE = "FX_AOE";
	bool FX_ACTIVE = false;
	string FX_COLOR = "FX_COLOR";
	bool DO_LIGHT = false;
	float FX_LIGHT_RAD = 0.0f;
	string FX_LIGHT_ID = "FX_LIGHT_ID";
	bool BALL_ROT = false;
	bool BALL_COL_IDX = false;
	int BALL_SPD = 0;
	float CIRCLE_RAD = 0.0f;
	float CIRCLE_DIST_INC = 0.0f;
	float CIRCLE_COUNT = 0.0f;
	string CIRCLE_COUNT_MAX = "CIRCLE_COUNT_MAX";
	float CUR_SIZE = 0.0f;
	float CIRCLE_ROT = 0.0f;

	// unnamed block (timer)
	void SfxPrismBlast_Timer()
	{
		CallEventDelayed(0.01f, "SfxPrismBlast_Timer");
		if (!FX_ACTIVE)
			return;
		if (!(CUR_SIZE <= 1.0f))
			return;
		CUR_SIZE += 0.02f;
		if (CUR_SIZE > 1.0f)
			CUR_SIZE = 1.0f;
	}

	// client_activate
	// <origin> <radius> <type>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_AOE = hand;
		FX_ACTIVE = true;

		int idx = FindToken(EFFECT_ELEMENTS, fxColor);
		FX_COLOR = GetToken(EFFECT_COLORS, idx);

		DO_LIGHT = true;
		if (DO_LIGHT)
		{
			FX_LIGHT_RAD = Float(FX_AOE) * 1.5f;
			SetCallback("render", "enable");
			ClientEffect("light", "new", FX_ORIGIN, FX_LIGHT_RAD, FX_COLOR, 0.5f);
			FX_LIGHT_ID = Eval("game.script.last_light_id");
		}

		PlaySound3D("magic/dburst_large_sdr_darkness.wav", 10, FX_ORIGIN);

		CIRCLE_RAD = 0.0f;
		int nCircles = GetTokenCount(EFFECT_COLORS);
		CIRCLE_DIST_INC = Float(FX_AOE);
		CIRCLE_DIST_INC = Divide(CIRCLE_DIST_INC, nCircles);
		// calleventloop $get_token_amt(EFFECT_COLORS) beam_circle
		CIRCLE_COUNT = 0.0f;
		CIRCLE_COUNT_MAX = nCircles;
		OnDoCircles();

		CallEventDelayed(1.0f, "end_fx");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!FX_ACTIVE)
			return;
		if (!DO_LIGHT)
			return;
		// rainbow light even more MLP
		// local L_R $rand(0,128)
		// local L_G $rand(0,128)
		// local L_B $rand(0,128)
		ClientEffect("light", FX_LIGHT_ID, FX_ORIGIN, Ratio(CUR_SIZE, 0, FX_LIGHT_RAD), FX_COLOR, 0.5f);
	}

	// do_circles
	void OnDoCircles()
	{
		if (!(CIRCLE_COUNT < Float(CIRCLE_COUNT_MAX)))
			return;
		CallEventDelayed(0.1f, "do_circles");
		OnBeamCircle();
		CIRCLE_COUNT += 1.0f;
	}

	// beam_circle
	void OnBeamCircle()
	{
		CIRCLE_RAD += CIRCLE_DIST_INC;
		CIRCLE_ROT = 0.0f;

		// setvard CIRCLE_COLOR $get_token(EFFECT_COLORS,CIRCLE_COUNT)
		for (int i = 0; i < 16; i++)
		{
			loopIteration = i;
			OnDrawCircleLoop();
		}
	}

	// draw_circle_loop
	void OnDrawCircleLoop()
	{
		Vector3 beamStart = FX_ORIGIN;
		beamStart += RelativePosition(Vector3(0, CIRCLE_ROT, 0), Vector3(0, CIRCLE_RAD, 0));
		CIRCLE_ROT += 22.5f;

		Vector3 beamEnd = FX_ORIGIN + RelativePosition(Vector3(0, CIRCLE_ROT, 0), Vector3(0, CIRCLE_RAD, 0));

		// <startpos> <endpos> <spritename> <life> <width> <amplitude> <brightness> <speed> <framerate> <color>
		ClientEffect("beam_points", beamStart, beamEnd, "3dmflagry.spr", 1.0f, 10, 0.2f, 1, 30, 30, LegacyFunction("clcol", FX_COLOR)); // $clcol(CIRCLE_COLOR)
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

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSetupBawls() {} // setup_bawls

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.01f, "SfxPrismBlast_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "beam_circle") { OnBeamCircle(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_circles") { OnDoCircles(); return true; }
		if (name == "draw_circle_loop") { OnDrawCircleLoop(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "SfxPrismBlast_Timer") { SfxPrismBlast_Timer(); return true; }
		return false;
	}
}
