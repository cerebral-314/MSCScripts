#pragma context server

// Converted from effects/sfx_quake.script by msc_transpiler.
// Earthquake Effect by Thothie
// be nice to rig up a function to screenshake individual players based on distance from src, or do it client side

#include "runtime/ScriptEntity.as"

[script "effects/sfx_quake"]
class SfxQuake : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_SRC = "FX_SRC";
	string FX_MOBILE = "FX_MOBILE";
	string FX_AOE = "FX_AOE";
	float FX_DURATION = 0.0f;
	string FX_VOLCANIC = "FX_VOLCANIC";
	bool FX_ACTIVE = false;
	int ATTACKER_IDX = 0;
	float FX_RATIO = 0.0f;
	float FX_ROCKS_PER_CIRC = 0.0f;
	float FX_N_CIRCS = 0.0f;
	Vector3 FX_ORIGIN = Vector3();
	bool CIRC_COUNT = false;
	float CIRC_STEP = 0.0f;
	float CIRC_RAD = 0.0f;
	float ROT_COUNT = 0.0f;
	float ROT_STEP = 0.0f;

	// client_activate
	// <src_idx|origin> <mobile:0|1> <aoe> <duration> [volcanic] [attacker_idx]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		// $get(ent_me,index) 1 256 L_DUR 1 PARAM2
		// . clfx effects/sfx_quake 1 1 256 20.0
		FX_SRC = owner;
		FX_MOBILE = hand;
		FX_AOE = fxColor;
		FX_DURATION = Float(lifetime);
		FX_VOLCANIC = sprite;

		FX_ACTIVE = true;

		if (Truthy(FX_VOLCANIC))
		{
			if (!flag.isEmpty())
			{
				ATTACKER_IDX = Int(flag); // we'll report to and damage each player struck direct
			}
			else
			{
				ATTACKER_IDX = 0; // don't report if not provided
			}
			CallEventDelayed(RandomInt(0, 1), "flaming_rocks_loop");
		}

		FX_RATIO = Divide(Float(FX_AOE), 1024.0f); // max AOE is 1024
		FX_ROCKS_PER_CIRC = Ratio(FX_RATIO, 4, 16);
		FX_ROCKS_PER_CIRC = int(FX_ROCKS_PER_CIRC);
		FX_N_CIRCS = Ratio(FX_RATIO, 2, 8);
		FX_N_CIRCS = int(FX_N_CIRCS);

		OnQuakeLoop();
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// flaming_rocks_loop
	void OnFlamingRocksLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(Random(0.25f, 0.5f), "flaming_rocks_loop");

		if (Truthy(FX_MOBILE))
			FX_ORIGIN = Vec(LegacyFunction("getcl", FX_SRC, "origin"));
		else
			FX_ORIGIN = Vec(FX_SRC);

		// pick a point around area, drop a flaming rock of random size, report blast loc on land
		float dropYaw = Random(0, 359.99f);
		float dropDist = Random(0, Float(FX_AOE));
		Vector3 dropPoint = FX_ORIGIN + RelativePosition(Vector3(0, dropYaw, 0), Vector3(0, dropDist, 256));

		ClientEffect("tempent", "model", "rockgibs.mdl", dropPoint, "setup_frock", "update_frock");
	}

	// cb_frock_land
	void OnCbFrockLand()
	{
		// explode sound, check if near current player, ce if so
		string org = Eval("game.tempent.origin");
		ClientEffect("tempent", "sprite", "xfireball3.spr", org, "setup_frock_explode");
		ClientEffect("tempent", "sprite", "xfireball3.spr", org, "setup_frock_explode");
		ClientEffect("tempent", "sprite", "xfireball3.spr", org, "setup_frock_explode");

		PlaySound3D("fire.wav", 10, Vec(org));

		if (!(ATTACKER_IDX > 0))
			return;

		string plrIdx = Eval("game.localplayer.index");
		string plrOrg = LegacyFunction("getcl", plrIdx, "origin");

		DebugPrint("*** effects/sfx_quake cb_frock_land ds " + Text(Distance(Vec(org), Vec(plrOrg))) + " atk " + ATTACKER_IDX + " [ " + org + " vs. " + plrOrg + " ]");
	}

	// setup_frock
	void OnSetupFrock()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 3.0f);
		ClientEffect("tempent", "set_current_prop", "scale", Random(6, 8));
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "cb_collide", "cb_frock_land");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", RandomInt(1, 2));
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(90, 0, 0));
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "fuser1", GameTime() + 0.1f);
	}

	// update_frock
	void OnUpdateFrock()
	{
		if (!(GameTime() > Float(Eval("game.tempent.fuser1"))))
			return;
		ClientEffect("tempent", "set_current_prop", "fuser1", GameTime() + 0.1f);
		ClientEffect("tempent", "sprite", "xfireball3.spr", Eval("game.tempent.origin"), "setup_frock_trail");
	}

	// setup_frock_trail
	void OnSetupFrockTrail()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "fade", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 19);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 96, 64));
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// setup_frock_explode
	void OnSetupFrockExplode()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "fade", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 19);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 2);
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 96, 64));
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(Random(-100, 100), Random(-100, 100), Random(100, 400)));
	}

	// quake_loop
	void OnQuakeLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(1.0f, "quake_loop");
		if (Truthy(FX_MOBILE))
			FX_ORIGIN = Vec(LegacyFunction("getcl", FX_SRC, "origin"));
		else
			FX_ORIGIN = Vec(FX_SRC);
		FX_ORIGIN.z = GroundHeight(FX_ORIGIN);

		CIRC_COUNT = false;
		CIRC_STEP = Divide(Float(FX_AOE), FX_N_CIRCS);
		int count = int(FX_N_CIRCS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoCircles();
		}
	}

	// do_circles
	void OnDoCircles()
	{
		int curCirc = loopIteration;
		CIRC_RAD = CIRC_STEP * curCirc + CIRC_STEP;
		ROT_COUNT = Random(0, 359.99f);
		float nrocks = Divide(curCirc, FX_N_CIRCS);
		nrocks = Ratio(nrocks, 4, FX_ROCKS_PER_CIRC);
		nrocks = int(nrocks);
		ROT_STEP = Divide(359.99f, nrocks);

		// dbg $currentscript do_circles cur CUR_CIRC / FX_N_CIRCS rad CUR_RAD step ROT_STEP rocks L_NROCKS
		// dbg $currentscript do_circles FX_ORIGIN cur CUR_CIRC / FX_N_CIRCS rad CUR_RAD rocks L_NROCKS
		int count = int(nrocks);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoRocks();
		}
		loopIteration = outerIteration;
	}

	// do_rocks
	void OnDoRocks()
	{
		Vector3 pos = FX_ORIGIN + RelativePosition(Vector3(0, ROT_COUNT, 0), Vector3(0, CIRC_RAD, 0));
		ClientEffect("tempent", "model", "rockgibs.mdl", pos, "setup_rock", "update_rock");

		ROT_COUNT += ROT_STEP;
		if (ROT_COUNT > 359.99f)
			ROT_COUNT -= 359.99f;
	}

	// setup_rock
	void OnSetupRock()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 3.0f);
		ClientEffect("tempent", "set_current_prop", "scale", Random(1.4f, 2));
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 50));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", RandomInt(1, 2));
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "fuser1", GameTime());
	}

	// update_rock
	void OnUpdateRock()
	{
		if (!FX_ACTIVE)
		{
			Vector3 curVel = Vec(Eval("game.tempent.velocity"));
			curVel.z += -100.0f;
			if (curVel.z < -600.0f)
				curVel.z = -600.0f;
			ClientEffect("tempent", "set_current_prop", "bouncefactor", 1);
			ClientEffect("tempent", "set_current_prop", "velocity", curVel);
			ClientEffect("tempent", "set_current_prop", "gravity", 1);
			ClientEffect("tempent", "set_current_prop", "collide", "world");
		}

		string curAng = Eval("game.tempent.angles");
		float yaw = Vec(curAng).y + 1.0f;
		if (yaw > 359.99f)
			yaw -= 359.99f;
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, yaw, 0));

		// works, but think they look better solid
		float curRend = GameTime() - Float(Eval("game.tempent.fuser1"));
		curRend = Divide(curRend, 3.0f);
		curRend = Ratio(curRend, 512, 0);
		if (curRend > 255.0f)
			curRend = 255.0f;
		// dbg *** $currentscript CUR_REND
		ClientEffect("tempent", "set_current_prop", "renderamt", curRend);
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(4.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cb_frock_land") { OnCbFrockLand(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_circles") { OnDoCircles(); return true; }
		if (name == "do_rocks") { OnDoRocks(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "flaming_rocks_loop") { OnFlamingRocksLoop(); return true; }
		if (name == "quake_loop") { OnQuakeLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_frock") { OnSetupFrock(); return true; }
		if (name == "setup_frock_explode") { OnSetupFrockExplode(); return true; }
		if (name == "setup_frock_trail") { OnSetupFrockTrail(); return true; }
		if (name == "setup_rock") { OnSetupRock(); return true; }
		if (name == "update_frock") { OnUpdateFrock(); return true; }
		if (name == "update_rock") { OnUpdateRock(); return true; }
		return false;
	}
}
