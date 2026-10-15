#pragma context server

// Converted from items/axes_c_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/axes_c_cl"]
class AxesCCl : ScriptEntity
{
	// Constants
	string EFFECT_ELEMENTS = "acid;fire;cold;poison;dark;lightning;holy";
	string EFFECT_COLORS = "EFFECT_COLORS";

	// Variables (an unset .script variable reads as its own name)
	string CAXE_SPRITE_COLOR = "CAXE_SPRITE_COLOR";
	bool SPRITE_ACTIVE = false;
	string PREV_POS = "PREV_POS";

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetCallback("render", "enable");
	}

	// update_caxe_sprite
	// <type>
	void OnUpdateCaxeSprite(string type = "")
	{
		int idx = FindToken(EFFECT_ELEMENTS, type);
		CAXE_SPRITE_COLOR = GetToken(EFFECT_COLORS, idx);
		SPRITE_ACTIVE = true;
		DebugPrint("update_caxe_sprite " + CAXE_SPRITE_COLOR);
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!SPRITE_ACTIVE)
			return;
		if (Truthy(Eval("game.localplayer.thirdperson")))
			return;
		string wepIdx = Eval("game.localplayer.viewmodel.active.id");
		string pos = LegacyFunction("getcl", wepIdx, "attachment0");
		ClientEffect("frameent", "sprite", "3dmflagry.spr", pos, "setup_caxe_sprite");
		// <startpos> <endpos> <spritename> <life> <width> <amplitude> <brightness> <speed> <framerate> <color>
		ClientEffect("beam_points", pos, PREV_POS, "3dmflagry.spr", 0.25f, 0.5f, 0.2f, 1, 30, 30, LegacyFunction("clcol", CAXE_SPRITE_COLOR));
		PREV_POS = pos;
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		SPRITE_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_caxe_sprite
	void OnSetupCaxeSprite()
	{
		ClientEffect("frameent", "set_current_prop", "renderamt", 200);
		ClientEffect("frameent", "set_current_prop", "rendermode", "glow");
		ClientEffect("frameent", "set_current_prop", "rendercolor", CAXE_SPRITE_COLOR);
		// cleffect frameent set_current_prop color CAXE_SPRITE_COLOR
		ClientEffect("frameent", "set_current_prop", "scale", 0.5f);
		ClientEffect("frameent", "set_current_prop", "frame", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_caxe_sprite") { OnSetupCaxeSprite(); return true; }
		if (name == "update_caxe_sprite") { OnUpdateCaxeSprite(Param(params, 0)); return true; }
		return false;
	}
}
