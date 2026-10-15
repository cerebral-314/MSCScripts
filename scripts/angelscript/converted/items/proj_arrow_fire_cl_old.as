#pragma context server

// Converted from items/proj_arrow_fire_cl_old.script by msc_transpiler.
// Thothie - The fire arrow is too dim since 1.4 - attempting to give more torch level effect
// Fire Arrow (client-side special effects)

#include "runtime/ScriptEntity.as"

[script "items/proj_arrow_fire_cl_old"]
class ProjArrowFireClOld : ScriptEntity
{
	// Constants
	string SPR_FIRE = "fire1_fixed.spr";
	string SPR_SMOKE1 = "xsmoke3.spr";
	string SMOKE_DURATION = "$randf(1,2)";
	float OFS_POS = 5.0f;
	float OFS_NEG = -5.0f;
	int SPD_POS = 60;
	int SPD_NEG = -60;
	float LIGHT_RADIUS = 256.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// Variables (an unset .script variable reads as its own name)
	bool EFFECT_SET_TO_DIE = false;

	// unnamed block (timer)
	void ProjArrowFireClOld_Timer()
	{
		CallEventDelayed(0.1f, "ProjArrowFireClOld_Timer");

		// Create Smoke
		string pos = LegacyFunction("getcl", "sfx.modelid", "attachment0");
		OnSmokeSprCreate(Vec(pos), SPR_SMOKE1, 0.5f);
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetVar("sfx.modelid", owner);
		SetVar("sfx.duration", -1);
		if (Truthy(LegacyFunction("getcl", "sfx.modelid", "exists")))
		{
			OnCreateLight(LegacyFunction("getcl", "sfx.modelid", "origin"));
			OnFireSprCreate();
		}
		else
		{
			EFFECT_SET_TO_DIE = true;
			CallEventDelayed(20.0f, "effect_die");
		}

		SetCallback("render", "enable");
	}

	// effect_die
	void OnEffectDie()
	{
		RemoveScript();
	}

	// game_think
	void OnGameThink()
	{
		if (Truthy(LegacyFunction("getcl", "sfx.modelid", "exists")))
			return;
		if (EFFECT_SET_TO_DIE)
			return;
		EFFECT_SET_TO_DIE = true;
		CallEventDelayed(20.0f, "effect_die");
	}

	// smoke_spr_create
	void OnSmokeSprCreate(Vector3 position = Vector3(), string sprite = "", float scale = 0.0f)
	{
		Vector3 pos = position;
		pos += Vector3(Random(OFS_NEG, OFS_POS), Random(OFS_NEG, OFS_POS), Random(OFS_NEG, OFS_POS));

		SetVar("p.scale", scale);
		ClientEffect("tempent", "sprite", sprite, pos, "smoke_spr_steup");
	}

	// smoke_spr_steup
	void OnSmokeSprSteup()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", Random(100, 200));
		ClientEffect("tempent", "set_current_prop", "scale", "p.scale");
		ClientEffect("tempent", "set_current_prop", "gravity", Random(-0.1f, -0.01f));
		// cleffect tempent set_current_prop velocity 		$vec(0,0,$randf(0,5))
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(32, 32, 32));
		ClientEffect("tempent", "set_current_prop", "rendermodel", "alpha");
		ClientEffect("tempent", "set_current_prop", "frames", 14);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
	}

	// create_light
	void OnCreateLight(string origin = "")
	{
		if (origin == "0")
			return;

		ClientEffect("light", "new", origin, LIGHT_RADIUS, LIGHT_COLOR, 3);
		SetVar("sfx.lightid", Eval("game.script.last_light_id"));
	}

	// game_prerender
	void OnGamePrerender()
	{
		// Update light position
		if (!(LIGHT_RADIUS > 0.0f))
			return;

		float radius = LIGHT_RADIUS + Random(-8, 8);
		ClientEffect("light", "sfx.lightid", LegacyFunction("getcl", "sfx.modelid", "origin"), radius, LIGHT_COLOR, 1);
	}

	// fire_spr_create
	void OnFireSprCreate()
	{
		ClientEffect("tempent", "sprite", SPR_FIRE, Vector3(0, 0, 0), "fire_spr_steup");
	}

	// fire_spr_steup
	void OnFireSprSteup()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "die_with_ent", "sfx.modelid");
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 128);
		ClientEffect("tempent", "set_current_prop", "scale", 0.3f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 128, 128));
		ClientEffect("tempent", "set_current_prop", "frames", 23);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "follow", "sfx.modelid", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.1f, "ProjArrowFireClOld_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_light") { OnCreateLight(Param(params, 0)); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "fire_spr_create") { OnFireSprCreate(); return true; }
		if (name == "fire_spr_steup") { OnFireSprSteup(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "game_think") { OnGameThink(); return true; }
		if (name == "smoke_spr_create") { OnSmokeSprCreate(Vec(Param(params, 0)), Param(params, 1), Float(Param(params, 2))); return true; }
		if (name == "smoke_spr_steup") { OnSmokeSprSteup(); return true; }
		if (name == "ProjArrowFireClOld_Timer") { ProjArrowFireClOld_Timer(); return true; }
		return false;
	}
}
