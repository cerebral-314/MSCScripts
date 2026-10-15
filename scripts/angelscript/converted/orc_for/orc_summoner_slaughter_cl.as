#pragma context server

// Converted from orc_for/orc_summoner_slaughter_cl.script by msc_transpiler.
// Orc summoner gets pwned

#include "runtime/ScriptEntity.as"

[script "orc_for/orc_summoner_slaughter_cl"]
class OrcSummonerSlaughterCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string MAX_Z = "MAX_Z";
	bool FX_ACTIVE = false;
	int FX_STAGE = 0;
	Vector3 ATTACH_POS = Vector3();
	Vector3 FINAL_ORG = Vector3();
	bool FINAL_ORG_SET = false;
	string FLING_VEL = "FLING_VEL";

	// unnamed block (timer)
	void OrcSummonerSlaughterCl_Timer()
	{
		CallEventDelayed(0.1f, "OrcSummonerSlaughterCl_Timer");
		ATTACH_POS = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));
		if (ATTACH_POS.z < Float(MAX_Z))
			ATTACH_POS.z = Float(MAX_Z);
		if (FX_STAGE == 1)
		{
			Vector3 bloodPos = ATTACH_POS;
			bloodPos.z += 10.0f;
			ClientEffect("tempent", "sprite", "bloodspray.spr", bloodPos, "setup_blood_spray");
		}
	}

	// client_activate
	// <abomination_idx>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		MAX_Z = LegacyFunction("getcl", owner, "origin");
		MAX_Z = Text(Vec(MAX_Z).z);
		FX_ACTIVE = true;
		FX_STAGE = 1;
		ATTACH_POS = Vec(LegacyFunction("getcl", FX_OWNER, "attachment0"));
		if (ATTACH_POS.z < Float(MAX_Z))
			ATTACH_POS.z = Float(MAX_Z);
		ClientEffect("tempent", "model", "monsters/Orc.mdl", ATTACH_POS, "setup_orc_corpse", "update_orc_corpse");

		SetCallback("render", "enable");
	}

	// update_orc_corpse
	void OnUpdateOrcCorpse()
	{
		if (!FX_ACTIVE)
			return;
		if (FX_STAGE == 1)
			ClientEffect("tempent", "set_current_prop", "origin", ATTACH_POS);
		if (FX_STAGE == 2)
		{
			ClientEffect("tempent", "set_current_prop", "collide", "world");
			ClientEffect("tempent", "set_current_prop", "cb_collide", "collide_corpse");

			ClientEffect("tempent", "set_current_prop", "velocity", FLING_VEL);
			FX_STAGE = 3;
		}

		if (!FINAL_ORG_SET)
			return;
		ClientEffect("tempent", "set_current_prop", "origin", FINAL_ORG);
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
	}

	// collide_corpse
	void OnCollideCorpse()
	{
		DebugPrint("***** collide_corpse " + Eval("game.tempent.origin"));
		if (FINAL_ORG_SET)
			return;
		FINAL_ORG = Vec(Eval("game.tempent.origin"));
		FINAL_ORG.z += 4.0f;
		// cleffect tempent model monsters/Orc.mdl FINAL_ORG setup_deader_corpse
		FINAL_ORG_SET = true;
		ClientEffect("tempent", "set_current_prop", "origin", FINAL_ORG);
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
	}

	// do_fling
	// vel
	void OnDoFling(string velocity = "")
	{
		FX_STAGE = 2;
		FLING_VEL = velocity;
		CallEventDelayed(10.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_orc_corpse
	void OnSetupOrcCorpse()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 30.0f);
		ClientEffect("tempent", "set_current_prop", "body", 16);
		ClientEffect("tempent", "set_current_prop", "skin", 2);
		ClientEffect("tempent", "set_current_prop", "framerate", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 44);
		ClientEffect("tempent", "set_current_prop", "sequence", 6);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", -20);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "scale", 1);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// setup_blood_spray
	void OnSetupBloodSpray()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", Random(1, 2));
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 10);
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 0, 0));
		// cleffect tempent set_current_prop renderamt 255
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.1f, 1));

		float rndUp = Random(50, 100);
		float rndAng = Random(0, 359.99f);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 0, rndUp)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.1f, "OrcSummonerSlaughterCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "collide_corpse") { OnCollideCorpse(); return true; }
		if (name == "do_fling") { OnDoFling(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_blood_spray") { OnSetupBloodSpray(); return true; }
		if (name == "setup_orc_corpse") { OnSetupOrcCorpse(); return true; }
		if (name == "update_orc_corpse") { OnUpdateOrcCorpse(); return true; }
		if (name == "OrcSummonerSlaughterCl_Timer") { OrcSummonerSlaughterCl_Timer(); return true; }
		return false;
	}
}
