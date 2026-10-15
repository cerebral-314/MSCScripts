#pragma context server

// Converted from effects/sfx_poison_cloud.script by msc_transpiler.
// meh, didn't notice we already have sfx_cloud
// well, this is a bit fancier, representing more of a steaming pool of poison

#include "runtime/ScriptEntity.as"

[script "effects/sfx_poison_cloud"]
class SfxPoisonCloud : ScriptEntity
{
	// Constants
	string SPRITE_NAME = "poison_cloud.spr";
	string SOUND_BURST = "ambience/steamburst1.wav";

	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	string FX_AOE = "FX_AOE";
	float FX_DURATION = 0.0f;
	string FX_SOUND = "FX_SOUND";
	bool FX_ACTIVE = false;
	float SPRITE_SCALE_MIN = 0.0f;
	float SPRITE_SCALE_MAX = 0.0f;
	string DBG_AOE_RATIO = "DBG_AOE_RATIO";
	float SPRITE_SCALE = 0.0f;
	float SPITE_GRAVITY = 0.0f;
	string DBG_SPRITE_COUNT = "DBG_SPRITE_COUNT";

	// client_activate
	// <loc> <aoe> <duration> [playsound:0|1]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_AOE = hand;
		FX_DURATION = Float(fxColor);
		if (!lifetime.isEmpty())
			FX_SOUND = lifetime;
		else
			FX_SOUND = "1";
		FX_ACTIVE = true;

		float lightRad = Float(FX_AOE);
		lightRad *= 1.5f;
		ClientEffect("light", "new", FX_ORIGIN, lightRad, Vector3(0, 255, 0), FX_DURATION);

		// dbg *** sfx_poison_cloud ground $get_ground_height(FX_ORIGIN) //not sure if $get_ground_height() works on client, may need to trace
		float aoeRatio = Float(FX_AOE);
		if (aoeRatio > 256.0f)
			aoeRatio = 256.0f;
		aoeRatio = Divide(aoeRatio, 256.0f);
		SPRITE_SCALE_MIN = 5.0f;
		SPRITE_SCALE_MAX = 5.0f;
		SPRITE_SCALE_MIN *= aoeRatio;
		SPRITE_SCALE_MAX *= aoeRatio;
		DBG_AOE_RATIO = Text(aoeRatio);

		OnDoSmokes();
		CallEventDelayed(FX_DURATION, "end_fx");

		if (!Truthy(FX_SOUND))
			return;
		PlaySound3D(SOUND_BURST, 10, FX_ORIGIN);
	}

	// end_fx
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

	// do_smokes
	void OnDoSmokes()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.25f, "do_smokes");

		float rndDist = Random(0, Float(FX_AOE));
		float rndAng = Random(0, 359.99f);
		bool ofsZ = false;

		// local L_HALF_AOE FX_AOE
		// multiply L_HALF_AOE 0.4
		// subtract L_OFS_Z L_HALF_AOE
		Vector3 pos = FX_ORIGIN;
		pos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, (ofsZ ? 1.0f : 0.0f)));

		// scale down based on distance from center
		SPRITE_SCALE = Random(SPRITE_SCALE_MIN, SPRITE_SCALE_MAX);
		float pillarScale = SPRITE_SCALE * 1.5f;

		float distRatio = Divide(rndDist, Float(FX_AOE));
		distRatio = Ratio(distRatio, 0, 1.2f);
		float fratio = 1.3f - distRatio;

		SPITE_GRAVITY = -0.03f;
		SPRITE_SCALE *= fratio;
		ClientEffect("tempent", "sprite", SPRITE_NAME, pos, "setup_smoke", "update_smoke");

		if (DBG_SPRITE_COUNT == "DBG_SPRITE_COUNT")
			DBG_SPRITE_COUNT = "1";
		// big one in the center
		SPITE_GRAVITY = -0.05f;
		SPRITE_SCALE = pillarScale;
		ClientEffect("tempent", "sprite", SPRITE_NAME, FX_ORIGIN, "setup_smoke", "update_smoke");
		DBG_SPRITE_COUNT = "0";
	}

	// update_smoke
	void OnUpdateSmoke()
	{
		float curScale = Float(Eval("game.tempent.fuser1HD"));
		if (curScale > 0.02f)
		{
			curScale *= 0.99f;
			ClientEffect("tempent", "set_current_prop", "scaleHD", curScale);
			ClientEffect("tempent", "set_current_prop", "fuser1HD", curScale);
		}
		else
		{
			// local L_SPAWN_TIME game.tempent.fuser2
			// local L_DIE_TIME L_SPAWN_TIME
			// add L_DIE_TIME 2.5
			// local L_RENDER_RATIO L_SPAWN_TIME
			// divide L_RENDER_RATIO L_DIE_TIME
			// if (  game.tempent.iuser1 == 1 ) dbg *** sfx_poison_cloud update_smoke CUR_SCALE
			// local L_RENDER_FRATIO 200
			// subtract L_RENDER_FRATIO $ratio(L_RENDER_RATIO,0,200)
			// cleffect tempent set_current_prop renderamt L_RENDER_FRATIO
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(6000, 6000, 6000));
		}
	}

	// setup_smoke
	void OnSetupSmoke()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.5f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 15);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", SPRITE_SCALE);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 150);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 255, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", SPITE_GRAVITY);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", SPRITE_SCALE);
		ClientEffect("tempent", "set_current_prop", "fuser2", GameTime());
		ClientEffect("tempent", "set_current_prop", "iuser1", DBG_SPRITE_COUNT);
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
		if (name == "do_smokes") { OnDoSmokes(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_smoke") { OnSetupSmoke(); return true; }
		if (name == "update_smoke") { OnUpdateSmoke(); return true; }
		return false;
	}
}
