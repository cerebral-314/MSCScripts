#pragma context server

// Converted from effects/sfx_fissure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_fissure"]
class SfxFissure : ScriptEntity
{
	// Constants
	float SCALE_ROCK_LARGE = 0.0f;
	float RIGHT_ADJ_LARGE = 0.0f;
	float LEFT_ADJ_LARGE = 0.0f;
	float SCALE_ROCK_SMALL = 0.0f;
	float RIGHT_ADJ_SMALL = 0.0f;
	float LEFT_ADJ_SMALL = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	Vector3 FISSURE_START = Vector3();
	Vector3 ORG_FISSURE_START = Vector3();
	string FISSURE_YAW = "FISSURE_YAW";
	Vector3 FISSURE_END = Vector3();
	float FISSURE_LENGTH = 0.0f;
	string NO_ROCKS = "NO_ROCKS";
	string NO_FIRE = "NO_FIRE";
	float FISSURE_COUNT = 0.0f;
	bool FISSURE_ACTIVE = false;
	bool FX_ACTIVE = false;
	float DRAWN_FISSURE_LENGTH = 0.0f;
	Vector3 BEAM_START = Vector3();
	Vector3 BEAM_DIR = Vector3();
	Vector3 BEAM_END = Vector3();
	float ROCK_SCALE = 0.0f;
	int ROCK_BODY = 0;
	Vector3 ROCK_VELOCITY = Vector3();
	bool FLIP_SPRITE = false;

	// client_activate
	// <start_org> <yaw> <end> <length> <norocks:1|0> <nofire:1|0>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		// dbg cl_fissure PARAM1 PARAM2
		FISSURE_START = Vec(owner);
		ORG_FISSURE_START = FISSURE_START;
		FISSURE_YAW = hand;
		FISSURE_END = Vec(fxColor);
		FISSURE_LENGTH = Float(lifetime);
		NO_ROCKS = sprite;
		NO_FIRE = flag;
		// vectoradd FISSURE_END $relpos($vec(0,FISSURE_YAW,0),$vec(0,768,0))
		FISSURE_COUNT = 0.0f;
		FISSURE_ACTIVE = true;
		FX_ACTIVE = true;
		OnFissureLoop();
		CallEventDelayed(4.0f, "end_fx");
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

	// fissure_loop
	void OnFissureLoop()
	{
		if (!FISSURE_ACTIVE)
			return;
		CallEventDelayed(0.135f, "fissure_loop");

		OnFissureDebri();

		DRAWN_FISSURE_LENGTH += 64.0f;
		if (DRAWN_FISSURE_LENGTH >= FISSURE_LENGTH)
		{
			DebugPrint("fissure_stopped ( " + Text(FISSURE_COUNT) + " )");
			FISSURE_ACTIVE = false;
		}

		// vectoradd BEAM_END z 32
		// vectormultiply BEAM_DIR 32
		FISSURE_COUNT += 1.0f;
		if (FISSURE_COUNT == 16.0f)
			FISSURE_ACTIVE = false;
	}

	// fissure_debri
	void OnFissureDebri()
	{
		if (!(Distance(FISSURE_START, ORG_FISSURE_START) < FISSURE_LENGTH))
			return;

		BEAM_START = FISSURE_START;
		BEAM_DIR = DirectionTo(BEAM_START, FISSURE_END);
		BEAM_END = FISSURE_START;

		BEAM_END.z += 32.0f;
		BEAM_DIR *= 48.0f;
		BEAM_END += BEAM_DIR;

		// cleffect beam_points BEAM_START BEAM_END lgtning.spr 10.0 10.0 0.01 0.3 0.1 30 (0,2,0)
		FISSURE_START = BEAM_END;
		FISSURE_START.z = GroundHeight(FISSURE_START);

		Vector3 defLineCenter = BEAM_END;
		defLineCenter.z = GroundHeight(defLineCenter);

		if (!Truthy(NO_ROCKS))
		{
			// large left rock
			string lineCenter = Text(defLineCenter);
			float rndLr = RIGHT_ADJ_LARGE;
			float rndFb = Random(-8, 8);
			ROCK_SCALE = SCALE_ROCK_LARGE;
			ROCK_BODY = 0;
			ROCK_VELOCITY = Vector3(0, 0, 0);
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");

			// large right rock
			lineCenter = Text(defLineCenter);
			rndLr = LEFT_ADJ_LARGE;
			rndFb = Random(-8, 8);
			ROCK_SCALE = SCALE_ROCK_LARGE;
			ROCK_BODY = 0;
			ROCK_VELOCITY = Vector3(0, 0, 0);
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");

			// small left rock x2
			lineCenter = Text(defLineCenter);
			rndLr = RIGHT_ADJ_SMALL;
			rndFb = Random(-16, 16);
			ROCK_SCALE = SCALE_ROCK_SMALL;
			ROCK_BODY = RandomInt(1, 2);
			ROCK_VELOCITY = RelativeVelocity(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 120));
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");

			// small right rock x2
			lineCenter = Text(defLineCenter);
			rndLr = LEFT_ADJ_SMALL;
			rndFb = Random(-16, 16);
			ROCK_SCALE = SCALE_ROCK_SMALL;
			SetVar("ROCK_BODY$rand(1,2)", "");
			ROCK_VELOCITY = RelativeVelocity(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 120));
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");

			// small left rock x2
			lineCenter = Text(defLineCenter);
			rndLr = RIGHT_ADJ_SMALL;
			rndFb = Random(-16, 16);
			ROCK_SCALE = SCALE_ROCK_SMALL;
			ROCK_BODY = RandomInt(1, 2);
			ROCK_VELOCITY = RelativeVelocity(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 120));
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");

			// small right rock x2
			lineCenter = Text(defLineCenter);
			rndLr = LEFT_ADJ_SMALL;
			rndFb = Random(-16, 16);
			ROCK_SCALE = SCALE_ROCK_SMALL;
			ROCK_BODY = RandomInt(1, 2);
			ROCK_VELOCITY = RelativeVelocity(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 120));
			lineCenter = Text(Vec(lineCenter) + RelativePosition(Vector3(0, Float(FISSURE_YAW), 0), Vector3(rndLr, rndFb, 0)));
			lineCenter = Text(WithZ(Vec(lineCenter), GroundHeight(Vec(lineCenter))));
			ClientEffect("tempent", "model", "rockgibs.mdl", lineCenter, "setup_rock", "update_rock");
		}

		// flames
		if (Truthy(NO_FIRE))
			return;
		FLIP_SPRITE = false;
		string firePos = Text(defLineCenter);
		firePos = Text(WithZ(Vec(firePos), GroundHeight(Vec(firePos))));
		ClientEffect("tempent", "sprite", "fire1_fixed2.spr", firePos, "setup_fire", "update_fire");
		FLIP_SPRITE = true;
		ClientEffect("tempent", "sprite", "fire1_fixed2.spr", firePos, "setup_fire", "update_fire");
	}

	// update_rock
	void OnUpdateRock()
	{
		// if !FX_ACTIVE
		float curRend = Float(Eval("game.tempent.fuser1"));
		int fadeTime = Int(Eval("game.tempent.fuser2"));
		if (!(curRend > 0.0f))
			return;
		if (!(GameTime() >= fadeTime))
			return;
		curRend -= 5.0f;
		ClientEffect("tempent", "set_current_prop", "fuser1", curRend);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", curRend);
	}

	// setup_rock
	void OnSetupRock()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 4.0f);
		ClientEffect("tempent", "set_current_prop", "scale", ROCK_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", 2);
		ClientEffect("tempent", "set_current_prop", "velocity", ROCK_VELOCITY);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", ROCK_BODY);
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		float rndYaw = Random(0, 359.99f);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, rndYaw, 0));
		ClientEffect("tempent", "set_current_prop", "fuser1", 255);
		float fadeStart = GameTime() + 3.0f; // hate that I have to do this manual
		ClientEffect("tempent", "set_current_prop", "fuser2", fadeStart);
	}

	// update_fire
	void OnUpdateFire()
	{
		float curSize = Float(Eval("game.tempent.fuser1"));
		curSize -= 0.01f;
		if (!(curSize > 0.0f))
			return;
		ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
		ClientEffect("tempent", "set_current_prop", "scale", curSize);
	}

	// setup_fire
	void OnSetupFire()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "frames", 23);
		float yaw = Float(FISSURE_YAW);
		yaw += 90.0f;
		if (yaw > 359.99f)
			yaw -= 359.99f;
		if (FLIP_SPRITE)
		{
			yaw += 180.0f;
			if (yaw > 359.99f)
				yaw -= 359.99f;
		}
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, yaw, 0));
		ClientEffect("tempent", "set_current_prop", "scale", 4.0f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 4.0f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fissure_debri") { OnFissureDebri(); return true; }
		if (name == "fissure_loop") { OnFissureLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fire") { OnSetupFire(); return true; }
		if (name == "setup_rock") { OnSetupRock(); return true; }
		if (name == "update_fire") { OnUpdateFire(); return true; }
		if (name == "update_rock") { OnUpdateRock(); return true; }
		return false;
	}
}
