#pragma context server

// Converted from items/blunt_staff_a_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/blunt_staff_a_cl"]
class BluntStaffACl : ScriptEntity
{
	// Constants
	string BEAM_WIDTH = "10.0";
	float BEAM_AMP = 0.01f;
	int STAFF_HAND_BONE = 22;
	int STAFF_FINGER1_BONE = 41;
	int STAFF_FINGER4_BONE = 50;
	float STAFF_HEAD_U = 14.06f;
	float STAFF_HEAD_V = 1.12f;
	float STAFF_HEAD_W = -0.0644f;
	float STAFF_HAND_SPAN = 5.33f;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string AIM_ANG = "AIM_ANG";
	float SMOOTH_PITCH = 0.0f;
	float LAST_FRAME = 0.0f;
	bool FX_ACTIVE = false;
	float NEXT_SPARK = 0.0f;
	bool BEAM_HIT_WALL = false;
	string BEAM_HIT = "BEAM_HIT";
	string STAFF_HEAD = "STAFF_HEAD";

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		AIM_ANG = hand;
		SMOOTH_PITCH = Vec(AIM_ANG).x;
		LAST_FRAME = GameTime();
		SetCallback("render", "enable");
		FX_ACTIVE = true;
		OnFxLoop();
	}

	// ext_aim
	void OnExtAim(string angle = "")
	{
		AIM_ANG = angle;
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.25f, "fx_loop");
		if (GameTime() > NEXT_SPARK)
		{
			NEXT_SPARK = GameTime() + Random(0.25f, 1);
			if (BEAM_HIT_WALL)
			{
				ClientEffect("spark", BEAM_HIT);
				int rndSpark = RandomInt(1, 3);
				if (rndSpark == 1)
					PlaySound3D("buttons/spark1.wav", 5, Vec(BEAM_HIT));
				if (rndSpark == 2)
					PlaySound3D("buttons/spark2.wav", 5, Vec(BEAM_HIT));
				if (rndSpark == 3)
					PlaySound3D("buttons/spark4.wav", 5, Vec(BEAM_HIT));
			}
		}
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

	// game_prerender
	void OnGamePrerender()
	{
		string aim;
		if (!FX_ACTIVE)
			return;
		BEAM_HIT_WALL = false;

		if (Eval("game.localplayer.index") == FX_OWNER)
		{
			if (!Truthy(Eval("game.localplayer.thirdperson")))
			{
				OnDrawFirstPerson();
				return;
			}
			aim = Eval("game.pmove.angles");
		}
		else
		{
			float dt = GameTime() - LAST_FRAME;
			float ease = Clamp(dt * 8.0f, 0.0f, 1.0f);
			float diff = Vec(AIM_ANG).x - SMOOTH_PITCH;
			SMOOTH_PITCH += diff * ease;
			aim = Text(Vector3(SMOOTH_PITCH, Vec(LegacyFunction("getcl", FX_OWNER, "angles")).y, 0));
		}
		LAST_FRAME = GameTime();

		OnGetStaffHead();
		string beamStart = STAFF_HEAD;
		if (!(Distance(Vec(beamStart), Vec(LegacyFunction("getcl", FX_OWNER, "origin"))) < 128.0f))
			return;
		string beamEnd = Text(Vec(beamStart) + RelativePosition(Vec(aim), Vector3(0, 1280, 0)));
		string traceLine = LegacyFunction("get_traceline", beamStart, beamEnd, "worldonly");
		BEAM_HIT = traceLine;
		if (traceLine != beamEnd)
			BEAM_HIT_WALL = true;
		ClientEffect("beam_points", beamStart, traceLine, "lgtning.spr", 0.001f, BEAM_WIDTH, BEAM_AMP, 0.3f, 0.1f, 30, Vector3(2, 0, 0));
	}

	// get_staff_head
	void OnGetStaffHead()
	{
		string hand = LegacyFunction("getcl", FX_OWNER, "bonepos", STAFF_HAND_BONE);
		STAFF_HEAD = hand;
		string f1 = LegacyFunction("getcl", FX_OWNER, "bonepos", STAFF_FINGER1_BONE);
		string f4 = LegacyFunction("getcl", FX_OWNER, "bonepos", STAFF_FINGER4_BONE);
		float scale = Distance(Vec(hand), Vec(f1));
		if (!(scale > 1.0f))
			return;
		scale = Divide(scale, STAFF_HAND_SPAN);

		float ux = Vec(f1).x - Vec(f4).x;
		float uy = Vec(f1).y - Vec(f4).y;
		float uz = Vec(f1).z - Vec(f4).z;
		float vx = Vec(f1).x - Vec(hand).x;
		float vy = Vec(f1).y - Vec(hand).y;
		float vz = Vec(f1).z - Vec(hand).z;
		float wx = uy * vz - uz * vy;
		float wy = uz * vx - ux * vz;
		float wz = ux * vy - uy * vx;
		float wc = Divide(STAFF_HEAD_W, scale);

		float hx = STAFF_HEAD_U * ux + STAFF_HEAD_V * vx + wc * wx;
		float hy = STAFF_HEAD_U * uy + STAFF_HEAD_V * vy + wc * wy;
		float hz = STAFF_HEAD_U * uz + STAFF_HEAD_V * vz + wc * wz;

		string head = Text(Vec(hand) + Vector3(hx, hy, hz));
		STAFF_HEAD = head;
	}

	// draw_first_person
	void OnDrawFirstPerson()
	{
		string beamStart = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment2");
		Vector3 beamEnd = Vec(LegacyFunction("getcl", FX_OWNER, "center"));
		beamEnd.z += 16.0f;
		string ownerViewangs = Eval("game.pmove.angles");
		beamEnd += RelativePosition(Vec(ownerViewangs), Vector3(0, 1280, 0));

		string traceLine = LegacyFunction("get_traceline", beamStart, beamEnd, "worldonly");
		BEAM_HIT = traceLine;
		if (traceLine != Text(beamEnd))
			BEAM_HIT_WALL = true;

		// dbg viewang OWNER_VIEWANGS
		ClientEffect("beam_points", beamStart, traceLine, "lgtning.spr", 0.001f, BEAM_WIDTH, BEAM_AMP, 0.3f, 0.1f, 30, Vector3(2, 0, 0));
		ClientEffect("frameent", "sprite", "3dmflaora.spr", beamStart, "setup_flare");
	}

	// setup_flare
	void OnSetupFlare()
	{
		ClientEffect("frameent", "set_current_prop", "renderamt", 200);
		ClientEffect("frameent", "set_current_prop", "rendermode", "add");
		ClientEffect("frameent", "set_current_prop", "rendercolor", Vector3(255, 0, 0));
		ClientEffect("frameent", "set_current_prop", "scale", 0.25f);
		ClientEffect("frameent", "set_current_prop", "frame", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "draw_first_person") { OnDrawFirstPerson(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "ext_aim") { OnExtAim(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "get_staff_head") { OnGetStaffHead(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_flare") { OnSetupFlare(); return true; }
		return false;
	}
}
