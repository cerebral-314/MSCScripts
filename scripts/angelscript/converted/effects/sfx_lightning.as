#pragma context server

// Converted from effects/sfx_lightning.script by msc_transpiler.
// Lightning
// 1: Start Origin
// 2: End Origin
// 3: Duration
// 4: Intensity (0-1)

#include "runtime/ScriptEntity.as"

[script "effects/sfx_lightning"]
class SfxLightning : ScriptEntity
{
	// Constants
	string LIGHTNING_SPRITE = "lgtning.spr";
	string LIGHTNING_SPRITE_SPARKS = "3dmflaora.spr";
	string LIGHT_COLOR = "LIGHT_COLOR";
	string LIGHTNING_SOUND = "weather/lightning.wav";
	int SPARK_HORIZONTAL_NOISE = 30;
	int SHN = 0;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetVar("sfx.start", owner);
		SetVar("sfx.end", hand);
		SetVar("sfx.duration", fxColor);
		SetVar("sfx.amt", lifetime);

		SetVar("sfx.width", LegacyFunction("get_skill_ratio", "sfx.amt", 1, 25));
		SetVar("sfx.sparkscale", LegacyFunction("get_skill_ratio", "sfx.amt", 0.1f, 0.2f));

		SetVar("l.grnd", GroundHeight(Vec("sfx.start")));
		LegacyCommand("vectorset", "sfx.start", "z", "l.grnd");

		OnEffectStart();
		OnEffectDie();
	}

	// effect_start
	void OnEffectStart()
	{
		ClientEffect("beam_points", "sfx.start", "sfx.end", LIGHTNING_SPRITE, "sfx.duration", "sfx.width", 0.4f, 0.5f, 1, 30, LIGHT_COLOR);
		PlaySound3D(LIGHTNING_SOUND, 7, Vec("sfx.start"));
		int count = RandomInt(6, 8);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnEffectCreateball();
		}
	}

	// effect_createball
	void OnEffectCreateball()
	{
		ClientEffect("tempent", "sprite", LIGHTNING_SPRITE_SPARKS, "sfx.start", "effect_setupball_tempent");
	}

	// effect_setupball_tempent
	void OnEffectSetupballTempent()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", Random(0.6f, 1));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 2);
		float x = Random(-SHN, SHN); // Calculate velocity randomness
		float y = Random(-SHN, SHN);
		float z = Random(-300, -30);
		Vector3 vel = Vector3(x, y, z);
		ClientEffect("tempent", "set_current_prop", "velocity", vel);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		// cleffect tempent set_current_prop rendercolor 	(100,33,253)
		ClientEffect("tempent", "set_current_prop", "scale", "sfx.sparkscale");
		// cleffect tempent set_current_prop timer 	0.4 effect_setupball_fade
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
	}

	// effect_die
	void OnEffectDie()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("lgtning.spr");
		Precache("3dmflaora.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "effect_createball") { OnEffectCreateball(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "effect_setupball_tempent") { OnEffectSetupballTempent(); return true; }
		if (name == "effect_start") { OnEffectStart(); return true; }
		return false;
	}
}
