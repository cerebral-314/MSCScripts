#pragma context server

// Converted from nashalrath/dragon_ice_storm_cl.script by msc_transpiler.
// Removed defunct "cleffect ce" command //greatguys1@MAR2022
// Script now properly gets removed

#include "runtime/ScriptEntity.as"

[script "nashalrath/dragon_ice_storm_cl"]
class DragonIceStormCl : ScriptEntity
{
	// Constants
	int STORM_RAD = 768;
	float MIN_SCALE = 2.0f;
	float MAX_SCALE = 3.0f;
	string SOUND_BREAK1 = "debris/glass1.wav";
	string SOUND_BREAK2 = "debris/glass2.wav";

	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	bool FX_ACTIVE = false;
	Vector3 FX_GROUND = Vector3();
	string SHARD_ORIGIN = "SHARD_ORIGIN";

	// client_activate
	// <origin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_ACTIVE = true;

		FX_GROUND = FX_ORIGIN;
		FX_GROUND.z = GroundHeight(FX_GROUND);

		OnFxLoop();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(Random(0.2f, 0.5f), "fx_loop");
		Vector3 pos = FX_ORIGIN;
		float rndAng = Random(0, 359.99f);
		float rndDist = Random(0, STORM_RAD);
		pos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, 0));
		ClientEffect("tempent", "model", "glassgibs.mdl", pos, "setup_ice_spike");
	}

	// shard_land
	void OnShardLand()
	{
		SHARD_ORIGIN = Eval("game.tempent.origin");

		string shardSize = Eval("game.tempent.fuser1");
		int shardVolume = 5;

		int rndSound = RandomInt(1, 2);
		if (rndSound == 1)
			PlaySound3D(SOUND_BREAK1, shardVolume, Vec(SHARD_ORIGIN));
		else if (rndSound == 2)
			PlaySound3D(SOUND_BREAK2, shardVolume, Vec(SHARD_ORIGIN));
	}

	// setup_ice_spike
	void OnSetupIceSpike()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 3.0f); // Sometimes the ice spikes don't touch the ground before they die. That's ok.
		ClientEffect("tempent", "set_current_prop", "body", 0);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "cb_collide", "shard_land");
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		float rndScale = Random(MIN_SCALE, MAX_SCALE);
		ClientEffect("tempent", "set_current_prop", "scale", rndScale);
		ClientEffect("tempent", "set_current_prop", "fuser1", rndScale); // only shards larger than EXPLODE_SCALE will cause damage or explode
		ClientEffect("tempent", "set_current_prop", "gravity", Random(1, 2));
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(90, 0, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(-10, -10, -200));
	}

	// end_fx
	// { setup_gibs
	// cleffect tempent set_current_prop death_delay 2.0
	// cleffect tempent set_current_prop body $rand(0,6)
	// cleffect tempent set_current_prop framerate 1.0
	// cleffect tempent set_current_prop sequence 0
	// cleffect tempent set_current_prop rendermode add
	// cleffect tempent set_current_prop renderamt 255
	// cleffect tempent set_current_prop gravity 1
	// cleffect tempent set_current_prop collide world
	// cleffect tempent set_current_prop fadeout lifetime
	// cleffect tempent set_current_prop frames 1
	// local L_GIB_SCALE $randf(0.2,0.4)
	// multiply L_GIB_SCALE GIB_SCALE_ADJ
	// cleffect tempent set_current_prop scale L_GIB_SCALE
	// cleffect tempent set_current_prop gravity 1
	// cleffect tempent set_current_prop bouncefactor 1
	// cleffect tempent set_current_prop angles $vec($rand(0,359),$rand(0,359),0)
	// local RND_ANG $randf(0,359.99)
	// local RND_SPRING $randf(150,350)
	// local RND_SWING $randf(-100,100)
	// cleffect tempent set_current_prop velocity $relvel($vec(0,RND_ANG,0),$vec(RND_SWING,0,RND_SPRING))
	// }
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(3.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_ice_spike") { OnSetupIceSpike(); return true; }
		if (name == "shard_land") { OnShardLand(); return true; }
		return false;
	}
}
