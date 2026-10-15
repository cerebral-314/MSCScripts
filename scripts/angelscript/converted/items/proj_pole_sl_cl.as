#pragma context server

// Converted from items/proj_pole_sl_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_pole_sl_cl"]
class ProjPoleSlCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_ANGS = "FX_ANGS";
	string SPRITES_ORG = "SPRITES_ORG";
	Vector3 SPRITES_DEST = Vector3();
	Vector3 SPRITES_DIR = Vector3();
	float SPRITES_COUNT = 0.0f;

	// client_activate
	// <idx>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_ANGS = LegacyFunction("getcl", FX_OWNER, "angles");
		FX_ANGS = Text(WithX(Vec(FX_ANGS), -Vec(FX_ANGS).x));
		SPRITES_ORG = LegacyFunction("getcl", FX_OWNER, "origin");
		SPRITES_DEST = Vec(SPRITES_ORG);
		SPRITES_DEST += RelativePosition(Vec(FX_ANGS), Vector3(0, -128, 0));
		SPRITES_DIR = DirectionTo(Vec(SPRITES_ORG), SPRITES_DEST);
		SPRITES_COUNT = 0.0f;
		for (int i = 0; i < 8; i++)
		{
			loopIteration = i;
			OnDoSprites();
		}
		CallEventDelayed(1.0f, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// do_sprites
	void OnDoSprites()
	{
		Vector3 sprPos = Vec(SPRITES_ORG);
		Vector3 sprAdd = SPRITES_DIR * SPRITES_COUNT;
		sprPos += sprAdd;

		ClientEffect("tempent", "sprite", "poison_cloud.spr", sprPos, "setup_poof", "update_poof");
		SPRITES_COUNT += 16.0f;
	}

	// update_poof
	void OnUpdatePoof()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (!(curScale > 0.0f))
			return;
		curScale -= 0.01f;
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
	}

	// setup_poof
	void OnSetupPoof()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(32, 0, 255));
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "scale", 0.75f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.75f);
		ClientEffect("tempent", "set_current_prop", "gravity", -0.25f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_sprites") { OnDoSprites(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_poof") { OnSetupPoof(); return true; }
		if (name == "update_poof") { OnUpdatePoof(); return true; }
		return false;
	}
}
