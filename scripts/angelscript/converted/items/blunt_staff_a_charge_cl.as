#pragma context server

// Converted from items/blunt_staff_a_charge_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/blunt_staff_a_charge_cl"]
class BluntStaffAChargeCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float MAX_CHARGE = 0.0f;
	Vector3 CHARGE_COLOR = Vector3();
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;
	float CHARGE_LEVEL = 0.0f;
	float CUR_FRAME = 0.0f;

	// client_activate
	// <owner>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("cleyes_activate");

		MAX_CHARGE = 0.0f;
		CHARGE_COLOR = Vector3(0, 255, 0);
		FX_OWNER = owner;
		FX_ACTIVE = true;
		CHARGE_LEVEL = 1.0f;
		CUR_FRAME = 0.0f;
		SetCallback("render", "enable");
		OnAddChargeLevel();
		CallEventDelayed(20.0f, "end_fx"); // max duration
	}

	// add_charge_level
	// <charge_level>
	void OnAddChargeLevel(float chargeLevel = 0.0f)
	{
		if (!FX_ACTIVE)
			return;

		MAX_CHARGE = 0.0f;
		CHARGE_LEVEL = chargeLevel;

		if (CHARGE_LEVEL == 1.0f) // COD1
			CHARGE_COLOR = Vector3(0, 255, 0);
		if (CHARGE_LEVEL == 1.5f)
			MAX_CHARGE = 1.0f;
		if (CHARGE_LEVEL == 2.0f) // COD2
			CHARGE_COLOR = Vector3(255, 0, 0);
		if (CHARGE_LEVEL == 2.5f)
			MAX_CHARGE = 1.0f;
		if (CHARGE_LEVEL == 3.0f) // Summon
			CHARGE_COLOR = Vector3(255, 255, 255);
		if (CHARGE_LEVEL == 3.5f)
			MAX_CHARGE = 1.0f;

		// if ( CHARGE_LEVEL == 4 ) setvard CHARGE_COLOR (255,0,255) //Summon2
		// if ( CHARGE_LEVEL == 4.5 ) setvard MAX_CHARGE 1
		// if ( CHARGE_LEVEL == 5 ) setvard CHARGE_COLOR (255,255,0) //Summon3
		// if ( CHARGE_LEVEL == 5.5 ) setvard MAX_CHARGE 1
		// if ( CHARGE_LEVEL == 6 ) setvard CHARGE_COLOR (255,255,255) //???
		// if ( CHARGE_LEVEL == 6.5 ) setvard MAX_CHARGE 1
		if (int(MAX_CHARGE) != 0 && !Truthy(Eval("game.localplayer.thirdperson")))
		{
			ClientEffect("spark", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment2"));
			ClientEffect("spark", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment3"));
		}

		// render third person sprite, if needed
		if (Eval("game.localplayer.index") == FX_OWNER && Truthy(Eval("game.localplayer.thirdperson")))
		{
			string angAdjText = LegacyFunction("getcl", FX_OWNER, "viewangles");
			float angAdj;
			angAdj = Vec(angAdjText).y;
			Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
			sprPos += RelativePosition(Vector3(0, angAdj, 0), Vector3(0, 32, 32));
			ClientEffect("tempent", "sprite", "3dmflaora.spr", sprPos, "setup_thirdperson_flare");
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
		string eyePos = "EYE_POS";

		// viewmodel sprite
		if (!FX_ACTIVE)
			return;
		// if game.localplayer.index equals FX_OWNER
		if (Truthy(Eval("game.localplayer.thirdperson")))
			return;

		CUR_FRAME += 1.0f;
		if (CUR_FRAME > 15.0f)
			CUR_FRAME = 0.0f;

		if (int(MAX_CHARGE) != 0)
		{
			eyePos = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment2");
			ClientEffect("frameent", "sprite", "3dmflaora.spr", eyePos, "setup_eye_max");
		}

		// local EYE_POS $getcl(game.localplayer.viewmodel.active.id,attachment3)
		// cleffect frameent sprite  3dmflaora.spr  EYE_POS setup_eye_max
		eyePos = LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "attachment2");
		// dbg cl_eyes1 EYE_POS
		ClientEffect("frameent", "sprite", "calflame_small.spr", eyePos, "setup_eye");
	}

	// setup_thirdperson_flare
	void OnSetupThirdpersonFlare()
	{
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", CHARGE_COLOR);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "frame", 0);

		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// setup_eye
	void OnSetupEye()
	{
		ClientEffect("frameent", "set_current_prop", "renderamt", 200);
		ClientEffect("frameent", "set_current_prop", "rendermode", "glow");
		ClientEffect("frameent", "set_current_prop", "rendercolor", CHARGE_COLOR);
		ClientEffect("frameent", "set_current_prop", "scale", 1.5f);
		ClientEffect("frameent", "set_current_prop", "frame", CUR_FRAME);
	}

	// setup_eye_max
	void OnSetupEyeMax()
	{
		ClientEffect("frameent", "set_current_prop", "renderamt", 200);
		ClientEffect("frameent", "set_current_prop", "rendermode", "glow");
		ClientEffect("frameent", "set_current_prop", "rendercolor", CHARGE_COLOR);
		ClientEffect("frameent", "set_current_prop", "scale", 1.5f);
		ClientEffect("frameent", "set_current_prop", "frame", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_charge_level") { OnAddChargeLevel(Float(Param(params, 0))); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_eye") { OnSetupEye(); return true; }
		if (name == "setup_eye_max") { OnSetupEyeMax(); return true; }
		if (name == "setup_thirdperson_flare") { OnSetupThirdpersonFlare(); return true; }
		return false;
	}
}
