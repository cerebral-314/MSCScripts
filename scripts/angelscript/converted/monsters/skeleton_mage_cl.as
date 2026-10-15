#pragma context server

// Converted from monsters/skeleton_mage_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/skeleton_mage_cl"]
class SkeletonMageCl : ScriptEntity
{
	// Constants
	float GLOW_RAD = 128.0f;
	Vector3 GLOW_COLOR = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	string SKEL_LIGHT_ID = "SKEL_LIGHT_ID";
	bool FX_ACTIVE = false;
	float ATTACK_LIGHT_RAD = 0.0f;
	bool ATTACK_LIGHT_REMOVED = false;
	float SEAL_LIGHT_RADCOUNT = 0.0f;
	bool SEAL_LIGHT_REMOVED = false;
	bool SEAL_LIGHT_ACTIVE = false;
	string ATTACK_LIGHT_COLOR = "ATTACK_LIGHT_COLOR";
	string ATTACK_LIGHT_ID = "ATTACK_LIGHT_ID";
	bool ATTACK_LIGHT_ACTIVE = false;
	string SEAL_ORIGIN = "SEAL_ORIGIN";
	string SEAL_RAD = "SEAL_RAD";
	string SEAL_OFS = "SEAL_OFS";
	Vector3 SEAL_COLOR = Vector3();
	float SEAL_GLOW_RAD = 0.0f;
	string SEAL_LIGHT_ID = "SEAL_LIGHT_ID";

	// client_activate
	// <owner> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);

		SetCallback("render", "enable");

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), GLOW_RAD, GLOW_COLOR, FX_DURATION);
		SKEL_LIGHT_ID = Eval("game.script.last_light_id");

		FX_ACTIVE = true;
		CallEventDelayed(FX_DURATION, "end_effect");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!Truthy(LegacyFunction("getcl", FX_OWNER, "exists")))
			return;
		string pos = LegacyFunction("getcl", FX_OWNER, "origin");
		ClientEffect("light", SKEL_LIGHT_ID, pos, GLOW_RAD, GLOW_COLOR, 1.0f);

		if (ATTACK_LIGHT_ACTIVE)
		{
			if (ATTACK_LIGHT_RAD < 256.0f)
				ATTACK_LIGHT_RAD += 1.0f;
			ClientEffect("light", ATTACK_LIGHT_ID, pos, ATTACK_LIGHT_RAD, ATTACK_LIGHT_COLOR, 0.1f);
		}
		else if (!ATTACK_LIGHT_REMOVED && Float(ATTACK_LIGHT_ID) > 0.0f)
		{
			ATTACK_LIGHT_REMOVED = true;
			ClientEffect("light", ATTACK_LIGHT_ID, Vector3(5000, 0, 0), 1, Vector3(1, 1, 1), 0.1f);
		}

		if (SEAL_LIGHT_ACTIVE)
		{
			if (SEAL_LIGHT_RADCOUNT < SEAL_GLOW_RAD)
				SEAL_LIGHT_RADCOUNT += 1.0f;
			ClientEffect("light", SEAL_LIGHT_ID, pos, SEAL_LIGHT_RADCOUNT, SEAL_COLOR, 0.1f);
		}
		else if (!SEAL_LIGHT_REMOVED && Float(SEAL_LIGHT_ID) > 0.0f)
		{
			SEAL_LIGHT_REMOVED = true;
			ClientEffect("light", SEAL_LIGHT_ID, Vector3(5000, 0, 0), 1, Vector3(1, 1, 1), 0.1f);
		}
	}

	// end_effect
	void OnEndEffect()
	{
		FX_ACTIVE = false;
		SEAL_LIGHT_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_effect");
	}

	// remove_effect
	void OnRemoveEffect()
	{
		RemoveScript();
	}

	// show_orb
	// Power Projectile Orb
	// <color>
	void OnShowOrb(string color = "")
	{
		ATTACK_LIGHT_COLOR = color;
		ClientEffect("tempent", "sprite", "3dmflagry.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "setup_orb_sprite", "update_orb_sprite");
		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 10, ATTACK_LIGHT_COLOR, 0.1f);
		ATTACK_LIGHT_ID = Eval("game.script.last_light_id");
		ATTACK_LIGHT_ACTIVE = true;
		ATTACK_LIGHT_RAD = 10.0f;
		ATTACK_LIGHT_REMOVED = false;
	}

	// hide_orb
	// called by owner
	void OnHideOrb()
	{
		ATTACK_LIGHT_ACTIVE = false;
	}

	// setup_orb_sprite
	void OnSetupOrbSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 1);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", ATTACK_LIGHT_COLOR);
		ClientEffect("tempent", "set_current_prop", "renderamt", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", 1);
	}

	// update_orb_sprite
	void OnUpdateOrbSprite()
	{
		if (ATTACK_LIGHT_ACTIVE)
		{
			float curRenderamt = Float(Eval("game.tempent.fuser1"));
			if (curRenderamt < 255.0f)
				curRenderamt += 1.0f;
			ClientEffect("tempent", "set_current_prop", "renderamt", curRenderamt);
			ClientEffect("tempent", "set_current_prop", "fuser1", curRenderamt);
			ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", FX_OWNER, "attachment0"));
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "renderamt", 0);
		}
	}

	// show_seal_warning
	// seal warning circle
	// <origin> <rad> <body> <color>
	void OnShowSealWarning(string origin = "", string radius = "", string bodyOffset = "", Vector3 color = Vector3())
	{
		SEAL_ORIGIN = origin;
		SEAL_RAD = radius;
		SEAL_OFS = bodyOffset;
		SEAL_COLOR = color;
		ClientEffect("tempent", "model", "weapons/magic/seals.mdl", SEAL_ORIGIN, "setup_seal_warn");

		SEAL_GLOW_RAD = Float(SEAL_RAD);
		SEAL_GLOW_RAD *= 1.11f; // glow slightly larger than circle

		SEAL_LIGHT_ACTIVE = true;
		SEAL_LIGHT_RADCOUNT = 1.0f;
		SEAL_LIGHT_REMOVED = false;
		ClientEffect("light", "new", SEAL_ORIGIN, SEAL_GLOW_RAD, SEAL_COLOR, 2.0f);
		SEAL_LIGHT_ID = Eval("game.script.last_light_id");

		CallEventDelayed(2.0f, "seal_warning_end");

		PlaySound3D("magic/lightprep.wav", 5, Vec(SEAL_ORIGIN), 0.8f, 0, 50);
	}

	// seal_warning_end
	void OnSealWarningEnd()
	{
		SEAL_LIGHT_ACTIVE = false;
	}

	// setup_seal_warn
	void OnSetupSealWarn()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "body", SEAL_OFS);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 2.0f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", SEAL_COLOR);
		ClientEffect("tempent", "set_current_prop", "renderamt", 100);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_effect") { OnEndEffect(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "hide_orb") { OnHideOrb(); return true; }
		if (name == "remove_effect") { OnRemoveEffect(); return true; }
		if (name == "seal_warning_end") { OnSealWarningEnd(); return true; }
		if (name == "setup_orb_sprite") { OnSetupOrbSprite(); return true; }
		if (name == "setup_seal_warn") { OnSetupSealWarn(); return true; }
		if (name == "show_orb") { OnShowOrb(Param(params, 0)); return true; }
		if (name == "show_seal_warning") { OnShowSealWarning(Param(params, 0), Param(params, 1), Param(params, 2), Vec(Param(params, 3))); return true; }
		if (name == "update_orb_sprite") { OnUpdateOrbSprite(); return true; }
		return false;
	}
}
