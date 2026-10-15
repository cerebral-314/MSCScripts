#pragma context server

// Converted from monsters/beetle_venom_cl.script by msc_transpiler.
// Beetle farts by Thothie (venom beetles fart in flight)

#include "runtime/ScriptEntity.as"

[script "monsters/beetle_venom_cl"]
class BeetleVenomCl : ScriptEntity
{
	// Constants
	int SPRITE_NFRAMES = 17;

	// Variables (an unset .script variable reads as its own name)
	string SPRITE_NAME = "SPRITE_NAME";
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;

	// unnamed block (first think)
	void BeetleVenomCl_FirstThink()
	{
		SPRITE_NAME = "poison_cloud.spr";
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;

		FX_ACTIVE = true;
		OnFartLoop();
		CallEventOrDelay(hand, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		if (!FX_ACTIVE)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(3.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// fart_loop
	void OnFartLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.5f, "fart_loop");
		Vector3 spritePos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		int ownerYaw = Int(LegacyFunction("getcl", FX_OWNER, "angles.yaw"));
		spritePos += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, -64, -32));
		ClientEffect("tempent", "sprite", SPRITE_NAME, spritePos, "setup_sprite");
	}

	// setup_sprite
	void OnSetupSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 255, 0));
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", SPRITE_NFRAMES);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxMaxDuration() {} // FX_MAX_DURATION

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleVenomCl_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "fart_loop") { OnFartLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_sprite") { OnSetupSprite(); return true; }
		return false;
	}
}
