#pragma context server

// Converted from items/proj_fire_dart_cl.script by msc_transpiler.
// Fireball (client-side special effects)

#include "runtime/ScriptEntity.as"

[script "items/proj_fire_dart_cl"]
class ProjFireDartCl : ScriptEntity
{
	// Constants
	string SPRITE_1 = "3dmflaora.spr";
	string GLOW_DURATION = "$randf(1,2)";
	float OFS_POS = 15.0f;
	float OFS_NEG = -15.0f;
	int SPD_POS = 60;
	int SPD_NEG = -60;
	float LIGHT_RADIUS = 128.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// unnamed block (first think)
	void ProjFireDartCl_FirstThink()
	{
		SetCallback("render", "enable");
	}

	// unnamed block (timer)
	void ProjFireDartCl_Timer()
	{
		CallEventDelayed(Random(0.15f, 0.25f), "ProjFireDartCl_Timer");

		// Drip flames
		string pos = LegacyFunction("getcl", "script.modelid", "origin");
		OnMakeSprite1(pos);
		OnMakeSprite1(pos);
		OnMakeSprite1(pos);

		if (!Truthy(LegacyFunction("getcl", "script.modelid", "exists")))
			OnEffectDie();
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetVar("script.modelid", owner);
		SetVar("script.duration", 30);
		if (Truthy(LegacyFunction("getcl", "script.modelid", "exists")))
		{
			OnScriptDuration();

			OnCreateLight(LegacyFunction("getcl", "script.modelid", "origin"));
		}
		else
		{
			OnEffectDie();
		}
	}

	// effect_die
	void OnEffectDie()
	{
	}

	// make_sprite_1
	void OnMakeSprite1(string bonePosition = "")
	{
		Vector3 pos = Vec(bonePosition);
		pos += Vector3(Random(OFS_NEG, OFS_POS), Random(OFS_NEG, OFS_POS), Random(OFS_NEG, OFS_POS));
		ClientEffect("tempent", "sprite", SPRITE_1, pos, "setup_sprite_1");
	}

	// setup_sprite_1
	void OnSetupSprite12()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", GLOW_DURATION);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", Random(0.2f, 0.1f));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, Random(0, 5)));
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 0, 0));
		ClientEffect("tempent", "set_current_prop", "rendermodel", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", Random(128, 200));
	}

	// create_light
	void OnCreateLight(string origin = "")
	{
		if (origin == "0")
			return;

		ClientEffect("light", "new", origin, LIGHT_RADIUS, LIGHT_COLOR, "script.duration");
		SetVar("script.lightid", Eval("game.script.last_light_id"));
	}

	// game_prerender
	void OnGamePrerender()
	{
		// Update light position
		if (!(LIGHT_RADIUS > 0.0f))
			return;

		float radius = LIGHT_RADIUS + Random(-8, 8);
		ClientEffect("light", "script.lightid", LegacyFunction("getcl", "script.modelid", "origin"), radius, LIGHT_COLOR, 1);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnScriptDuration() {} // script.duration

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		CallEventDelayed(Float(Eval("$randf(0.15,0.25)")), "ProjFireDartCl_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjFireDartCl_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_light") { OnCreateLight(Param(params, 0)); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "make_sprite_1") { OnMakeSprite1(Param(params, 0)); return true; }
		if (name == "setup_sprite_1") { OnSetupSprite12(); return true; }
		if (name == "ProjFireDartCl_Timer") { ProjFireDartCl_Timer(); return true; }
		return false;
	}
}
