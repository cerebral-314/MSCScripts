#pragma context server

// Converted from items/magic_hand_base_cl.script by msc_transpiler.
// Magic (client-side special effects)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MagicHandBaseCl
{
	// Constants
	string GLOW_DURATION = "1";
	float OFS_POS = 5.0f;
	float OFS_NEG = -5.0f;
	float LIGHT_RADIUS = 128.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_FIRSTPERSON = false;

	// game_precache
	void MagicHandBaseCl_OnGamePrecache()
	{
	}

	// client_activate
	// <ownerIdx> <prepTime>
	void MagicHandBaseCl_OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand) + 5.0f;

		SetCallback("render", "enable");
		CallEventDelayed(FX_DURATION, "effect_die");
		OnCreateLight(LegacyFunction("getcl", FX_OWNER, "origin"));
	}

	// unnamed block (timer)
	void MagicHandBaseCl_Timer()
	{
		CallEventDelayed(Random(0.10f, 0.25f), "MagicHandBaseCl_Timer");

		FX_FIRSTPERSON = false;
		if (Float(FX_OWNER) == Float(Eval("game.localplayer.index")))
		{
			// Watching self cast in thir
			if (!Truthy(Eval("game.localplayer.thirdperson")))
				FX_FIRSTPERSON = true;
		}

		if (!FX_FIRSTPERSON)
		{
			// Watching other player cast spell
			OnMakeSprite1(LegacyFunction("getcl", FX_OWNER, "bonepos", 21));
			OnMakeSprite1(LegacyFunction("getcl", FX_OWNER, "bonepos", 38));
		}
		else
		{
			// Watching self cast spell in first person
			string handid = Eval("game.localplayer.viewmodel.active.id");
			OnMakeSprite1(LegacyFunction("getcl", handid, "bonepos", 13));
			OnMakeSprite1(LegacyFunction("getcl", handid, "bonepos", 32));
		}
	}

	// make_sprite_1
	void MagicHandBaseCl_OnMakeSprite1(string bonePosition = "")
	{
		string sprite1 = "3dmflaora.spr";

		Vector3 pos = Vec(bonePosition);
		pos += Vector3(0, Random(OFS_NEG, OFS_POS), Random(OFS_NEG, OFS_POS));
		ClientEffect("tempent", "sprite", sprite1, pos, "setup_sprite_1");
	}

	// setup_sprite_1
	void MagicHandBaseCl_OnSetupSprite12()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", GLOW_DURATION);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0.1f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", Random(0.2f, 0.1f));
		ClientEffect("tempent", "set_current_prop", "collide", "world");
	}

	// create_light
	void MagicHandBaseCl_OnCreateLight(string origin = "")
	{
		ClientEffect("light", "new", origin, LIGHT_RADIUS, LIGHT_COLOR, FX_DURATION);
	}

	// effect_die
	void MagicHandBaseCl_OnEffectDie()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { MagicHandBaseCl_OnGamePrecache(); } // game_precache
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "") { MagicHandBaseCl_OnClientActivate(owner, hand, fxColor, lifetime, sprite, flag, specialFlags, glowRadius); } // client_activate
	void OnMakeSprite1(string bonePosition = "") { MagicHandBaseCl_OnMakeSprite1(bonePosition); } // make_sprite_1
	void OnSetupSprite12() { MagicHandBaseCl_OnSetupSprite12(); } // setup_sprite_1
	void OnCreateLight(string origin = "") { MagicHandBaseCl_OnCreateLight(origin); } // create_light
	void OnEffectDie() { MagicHandBaseCl_OnEffectDie(); } // effect_die
	void OnFxDuration() {} // FX_DURATION

	// This file's events and timers by their .script names
	bool MagicHandBaseCl_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_light") { OnCreateLight(Param(params, 0)); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "make_sprite_1") { OnMakeSprite1(Param(params, 0)); return true; }
		if (name == "setup_sprite_1") { OnSetupSprite12(); return true; }
		if (name == "MagicHandBaseCl_Timer") { MagicHandBaseCl_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/magic_hand_base_cl"]
shared class MagicHandBaseClScript : ScriptEntity, MagicHandBaseCl
{
	// Variables every script that includes this file declares
	int SKYLTNG_OFS = 0;
	string SPRITE_GLOW = "SPRITE_GLOW";
	string SPRITE_LIGHTNING = "SPRITE_LIGHTNING";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		CallEventDelayed(Float(Eval("$randf(0.10,0.25)")), "MagicHandBaseCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MagicHandBaseCl_DispatchEvent(name, params);
	}
}
