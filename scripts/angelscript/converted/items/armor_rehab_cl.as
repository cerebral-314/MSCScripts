#pragma context server

// Converted from items/armor_rehab_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/armor_rehab_cl"]
class ArmorRehabCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string FX_COLOR = "FX_COLOR";
	Vector3 SPR_COLOR = Vector3();
	string OFSZ_POS = "OFSZ_POS";
	int OFSZ_NEG = 0;
	float OFS_POS = 0.0f;
	float OFS_NEG = 0.0f;
	int SPR_RAD = 0;
	string THIS_LIGHT = "THIS_LIGHT";
	bool FX_ACTIVE = false;

	// client_activate
	// <ownerindex> <color1-4>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		MY_OWNER = owner;
		FX_COLOR = hand;

		if (Float(FX_COLOR) == 1.0f)
			SPR_COLOR = Vector3(255, 0, 0);
		if (Float(FX_COLOR) == 2.0f)
			SPR_COLOR = Vector3(255, 255, 0);
		if (Float(FX_COLOR) == 3.0f)
			SPR_COLOR = Vector3(64, 64, 255);
		if (Float(FX_COLOR) == 4.0f)
			SPR_COLOR = Vector3(0, 255, 0);

		OFSZ_POS = "96";
		OFSZ_NEG = -96;
		OFS_POS = 72.0f;
		OFS_NEG = -72.0f;
		SPR_RAD = 32;

		ClientEffect("light", "new", LegacyFunction("getcl", MY_OWNER, "origin"), 200, SPR_COLOR, 3.0f);
		THIS_LIGHT = Eval("game.script.last_light_id");

		FX_ACTIVE = true;
		OnFxLoop();

		CallEventDelayed(2.0f, "end_fx");
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.05f, "fx_loop");
		OnCreateElementSprites();
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
		FX_ACTIVE = false;
	}

	// create_element_sprites
	void OnCreateElementSprites()
	{
		float rndLeft = Random(-20, 20);
		float rndRight = Random(-20, 20);
		Vector3 spriteVel = Vector3(rndLeft, rndRight, 0);
		ClientEffect("light", THIS_LIGHT, LegacyFunction("getcl", MY_OWNER, "origin"), 200, SPR_COLOR, 0.09f);

		Vector3 startPos = Vec(LegacyFunction("getcl", MY_OWNER, "origin"));
		int rndRad = RandomInt(0, 359);
		startPos += RelativePosition(Vector3(0, rndRad, 0), Vector3(0, SPR_RAD, -30));
		// $vec($randf(OFS_NEG,OFS_POS),$randf(OFS_NEG,OFS_POS),$randf(OFSZ_POS,OFSZ_NEG))
		ClientEffect("tempent", "sprite", "xflare1.spr", startPos, "setup_element_sprite");

		startPos = Vec(LegacyFunction("getcl", MY_OWNER, "origin"));
		rndRad = RandomInt(0, 359);
		startPos += RelativePosition(Vector3(0, rndRad, 0), Vector3(0, SPR_RAD, -30));
		// $vec($randf(OFS_NEG,OFS_POS),$randf(OFS_NEG,OFS_POS),$randf(OFSZ_POS,OFSZ_NEG))
		ClientEffect("tempent", "sprite", "xflare1.spr", startPos, "setup_element_sprite");

		startPos = Vec(LegacyFunction("getcl", MY_OWNER, "origin"));
		rndRad = RandomInt(0, 359);
		startPos += RelativePosition(Vector3(0, rndRad, 0), Vector3(0, SPR_RAD, -30));
		// $vec($randf(OFS_NEG,OFS_POS),$randf(OFS_NEG,OFS_POS),$randf(OFSZ_POS,OFSZ_NEG))
		ClientEffect("tempent", "sprite", "xflare1.spr", startPos, "setup_element_sprite");
	}

	// setup_element_sprite
	void OnSetupElementSprite()
	{
		float rndLeft = Random(-20, 20);
		float rndRight = Random(-20, 20);
		Vector3 spriteVel = Vector3(rndLeft, rndRight, 0);

		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 20);
		ClientEffect("tempent", "set_current_prop", "velocity", spriteVel);
		ClientEffect("tempent", "set_current_prop", "scale", 0.25f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", SPR_COLOR);
		ClientEffect("tempent", "set_current_prop", "gravity", -0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		int myVel = Int(LegacyFunction("getcl", MY_OWNER, "velocity"));
		string myAng = LegacyFunction("getcl", MY_OWNER, "angles");
		// dbg *** setup_element_sprite $relvel(MY_ANG,$vec(0,MY_VEL,0))
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vec(myAng), Vector3(0, myVel, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_element_sprites") { OnCreateElementSprites(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_element_sprite") { OnSetupElementSprite(); return true; }
		return false;
	}
}
