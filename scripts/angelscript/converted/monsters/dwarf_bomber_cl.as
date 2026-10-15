#pragma context server

// Converted from monsters/dwarf_bomber_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/dwarf_bomber_cl"]
class DwarfBomberCl : ScriptEntity
{
	// Constants
	string RHAND_IDX = "attachment0";
	string LHAND_IDX = "attachment1";
	float GLOW_RAD = 64.0f;
	Vector3 GLOW_COLOR = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	float FX_ACTIVATE_TIME = 0.0f;
	string FX_RACTIVE = "FX_RACTIVE";
	string FX_LACTIVE = "FX_LACTIVE";
	int LIGHT_RHAND = 0;
	int LIGHT_LHAND = 0;

	// client_activate
	// <owner> <duration> <handr_on> <handl_on>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_ACTIVE = true;

		FX_ACTIVATE_TIME = GameTime();

		FX_RACTIVE = fxColor;
		FX_LACTIVE = lifetime;

		OnSetHands(FX_RACTIVE, FX_LACTIVE);

		OnSparksLoop();

		SetCallback("render", "enable");

		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// sparks_loop
	void OnSparksLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(Random(0.1f, 0.5f), "sparks_loop");
		// dbg sparks_loop FX_RACTIVE FX_LACTIVE [ FX_OWNER $getcl(FX_OWNER,RHAND_IDX) ]
		if (Truthy(FX_RACTIVE))
		{
			ClientEffect("spark", FX_OWNER, 0); // $getcl(FX_OWNER,RHAND_IDX)
		}

		if (Truthy(FX_LACTIVE))
		{
			ClientEffect("spark", FX_OWNER, 1); // $getcl(FX_OWNER,LHAND_IDX)
		}
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (FX_ACTIVE)
		{
			if (Truthy(FX_RACTIVE))
			{
				ClientEffect("light", LIGHT_RHAND, LegacyFunction("getcl", FX_OWNER, RHAND_IDX), GLOW_RAD, GLOW_COLOR, 1.0f);
			}
			else if (LIGHT_RHAND > 0)
			{
				ClientEffect("light", LIGHT_RHAND, LegacyFunction("getcl", FX_OWNER, RHAND_IDX), 0, Vector3(0, 0, 0), 1.0f);
				LIGHT_RHAND = -1;
			}

			if (Truthy(FX_LACTIVE))
			{
				ClientEffect("light", LIGHT_LHAND, LegacyFunction("getcl", FX_OWNER, LHAND_IDX), GLOW_RAD, GLOW_COLOR, 1.0f);
			}
			else if (LIGHT_LHAND > 0)
			{
				ClientEffect("light", LIGHT_LHAND, LegacyFunction("getcl", FX_OWNER, LHAND_IDX), 0, Vector3(0, 0, 0), 1.0f);
				LIGHT_LHAND = -1;
			}
		}
		else
		{
			if (LIGHT_RHAND > 0)
			{
				ClientEffect("light", LIGHT_RHAND, LegacyFunction("getcl", FX_OWNER, RHAND_IDX), 0, Vector3(0, 0, 0), 1.0f);
				LIGHT_RHAND = -1;
			}

			if (LIGHT_LHAND > 0)
			{
				ClientEffect("light", LIGHT_LHAND, LegacyFunction("getcl", FX_OWNER, LHAND_IDX), 0, Vector3(0, 0, 0), 1.0f);
				LIGHT_LHAND = -1;
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

	// set_hands
	// <handr_on> <handl_on>
	void OnSetHands(string handrOn = "", string handlOn = "")
	{
		FX_RACTIVE = handrOn;
		FX_LACTIVE = handlOn;

		if (Truthy(FX_RACTIVE))
		{
			ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, RHAND_IDX), GLOW_RAD, GLOW_COLOR, FX_DURATION);
			LIGHT_RHAND = Int(Eval("game.script.last_light_id"));
		}

		if (Truthy(FX_LACTIVE))
		{
			ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, LHAND_IDX), GLOW_RAD, GLOW_COLOR, FX_DURATION);
			LIGHT_LHAND = Int(Eval("game.script.last_light_id"));
		}
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
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "set_hands") { OnSetHands(Param(params, 0), Param(params, 1)); return true; }
		if (name == "sparks_loop") { OnSparksLoop(); return true; }
		return false;
	}
}
