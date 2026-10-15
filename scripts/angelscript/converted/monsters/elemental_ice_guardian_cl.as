#pragma context server

// Converted from monsters/elemental_ice_guardian_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/elemental_ice_guardian_cl"]
class ElementalIceGuardianCl : ScriptEntity
{
	// Constants
	string DRESS_SPRITE = "char_breath.spr";
	int DRESS_SPRITE_NFRAMES = 30;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string STAFF_ON = "STAFF_ON";
	bool FX_ACTIVE = false;
	bool DEATH_MODE = false;
	Vector3 OWNER_VEL = Vector3();
	string PROJECTILE_ANGLES = "PROJECTILE_ANGLES";
	string PROJECTILE_SPEED = "PROJECTILE_SPEED";
	string PROJECTILE_END = "PROJECTILE_END";
	bool STAFF_LOOP_ACTIVE = false;
	bool SHOCK_STORM_ON = false;
	string STAFF_POS = "STAFF_POS";

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		STAFF_ON = hand;

		DebugPrint("ice_cl " + FX_OWNER + " " + STAFF_ON);

		FX_ACTIVE = true;
		CallEventDelayed(45.0f, "end_fx");
		OnDressSpriteLoop();
	}

	// guardian_death
	void OnGuardianDeath()
	{
		DEATH_MODE = true;
		CallEventDelayed(1.0f, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// dress_sprite_loop
	void OnDressSpriteLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.1f, "dress_sprite_loop");
		string sprPos = LegacyFunction("getcl", FX_OWNER, "attachment0");
		OWNER_VEL = Vec(LegacyFunction("getcl", FX_OWNER, "velocity"));
		OWNER_VEL *= 0.1f;
		// dbg dress_sprite_loop OWNER_VEL
		// local OWNER_YAW $getcl(FX_OWNER,angles.yaw)
		// dbg dress_sprite_loop OWNER_YAW
		// vectoradd SPR_POS z 8
		// vectoradd SPR_POS $relvel($vec(0,OWNER_YAW,0),$vec(0,16,8))
		ClientEffect("tempent", "sprite", DRESS_SPRITE, sprPos, "setup_cloud", "update_cloud");
		ClientEffect("tempent", "sprite", DRESS_SPRITE, sprPos, "setup_cloud", "update_cloud");
		ClientEffect("tempent", "sprite", DRESS_SPRITE, sprPos, "setup_cloud", "update_cloud");
		ClientEffect("tempent", "sprite", DRESS_SPRITE, sprPos, "setup_cloud", "update_cloud");
	}

	// fire_projectile
	// <angles> <end_pos> <hit:0|1> <speed>
	void OnFireProjectile(string angles = "", string endPos = "", string hit = "", string speed = "")
	{
		PROJECTILE_ANGLES = angles;
		PROJECTILE_SPEED = speed;
		if (!Truthy(hit))
		{
			PROJECTILE_END = endPos;
			CallEventDelayed(0.5f, "fire_projectile_miss_sound");
		}
		string sprPos = LegacyFunction("getcl", FX_OWNER, "attachment1");
		if (!STAFF_LOOP_ACTIVE)
		{
			// dont need to track staff pos all the time, so just do it for next 10 secs
			STAFF_LOOP_ACTIVE = true;
			CallEventDelayed(10.0f, "staff_track_end");
			OnStaffTrackLoop();
		}
		// dbg *** fire_projectile SPR_POS
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", sprPos, "setup_projectile");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", sprPos, "setup_staff_glow", "update_staff_glow");
	}

	// shock_storm_on
	void OnShockStormOn()
	{
		if (!STAFF_LOOP_ACTIVE)
			OnStaffTrackLoop();
		SHOCK_STORM_ON = true;
	}

	// shock_storm_end
	void OnShockStormEnd()
	{
		SHOCK_STORM_ON = false;
		OnStaffTrackEnd();
	}

	// shock_storm_loop
	void OnShockStormLoop()
	{
		if (!SHOCK_STORM_ON)
			return;
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.5f, "shock_storm_loop");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", "SPR_POS", "setup_staff_glow", "update_staff_glow");
	}

	// staff_track_loop
	void OnStaffTrackLoop()
	{
		if (!STAFF_LOOP_ACTIVE)
			return;
		CallEventDelayed(0.01f, "staff_track_loop");
		STAFF_POS = LegacyFunction("getcl", FX_OWNER, "attachment1");
	}

	// staff_track_end
	void OnStaffTrackEnd()
	{
		STAFF_LOOP_ACTIVE = false;
	}

	// fire_projectile_miss_sound
	void OnFireProjectileMissSound()
	{
		PlaySound3D("weapons/dagger/daggermetal2.wav", 10, Vec(PROJECTILE_END));
	}

	// update_staff_glow
	void OnUpdateStaffGlow()
	{
		ClientEffect("tempent", "set_current_prop", "origin", STAFF_POS);
		float curSize = Float(Eval("game.tempent.fuser1"));
		curSize -= 0.01f;
		if (curSize > 0.0f)
		{
			ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
			ClientEffect("tempent", "set_current_prop", "scale", curSize);
		}
		if (curSize == 0.0f)
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
	}

	// setup_staff_glow
	void OnSetupStaffGlow()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "fade", "lifetime");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(64, 128, 255));
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", 1.0f);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// setup_projectile
	void OnSetupProjectile()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.5f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		Vector3 projectileAngles = Vec(PROJECTILE_ANGLES);
		projectileAngles.x = -Vec(PROJECTILE_ANGLES).x;
		ClientEffect("tempent", "set_current_prop", "angles", projectileAngles); // $getcl(FX_OWNER,angles)
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vec(PROJECTILE_ANGLES), Vector3(0, Float(PROJECTILE_SPEED), 0)));
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "body", 38);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "sequence", 15);
	}

	// setup_cloud
	void OnSetupCloud()
	{
		float rndPitch;
		float rndAng;
		Vector3 cloudVel;

		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "framerate", 60);
		ClientEffect("tempent", "set_current_prop", "frames", DRESS_SPRITE_NFRAMES);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.05f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 230, 255));
		if (!DEATH_MODE)
			ClientEffect("tempent", "set_current_prop", "gravity", 0.5f);
		else
			ClientEffect("tempent", "set_current_prop", "gravity", 0.0f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.05f);

		if (!DEATH_MODE)
		{
			rndPitch = Random(70, 110);
			rndAng = Random(0, 359.99f);
			ClientEffect("tempent", "set_current_prop", "angles", Vector3(rndPitch, rndAng, 0));

			cloudVel = OWNER_VEL + RelativeVelocity(Vector3(rndPitch, rndAng, 0), Vector3(0, 10, 0));
			ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
		}
		else
		{
			rndAng = Random(0, 359.99f);
			rndPitch = Random(0, 359.99f);
			ClientEffect("tempent", "set_current_prop", "angles", Vector3(rndPitch, rndAng, 0));
			cloudVel = OWNER_VEL + RelativeVelocity(Vector3(rndPitch, rndAng, 0), Vector3(0, 50, 0));
			ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
		}
	}

	// update_cloud
	void OnUpdateCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (curScale < 1.5f)
		{
			curScale += 0.025f;
			ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}

		if (!DEATH_MODE)
			return;
		Vector3 curVel = Vec(Eval("game.tempent.velocity"));
		string curAng = Eval("game.tempent.angles");
		curVel += RelativeVelocity(Vec(curAng), Vector3(0, 50, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", curVel);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "dress_sprite_loop") { OnDressSpriteLoop(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fire_projectile") { OnFireProjectile(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "fire_projectile_miss_sound") { OnFireProjectileMissSound(); return true; }
		if (name == "guardian_death") { OnGuardianDeath(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_projectile") { OnSetupProjectile(); return true; }
		if (name == "setup_staff_glow") { OnSetupStaffGlow(); return true; }
		if (name == "shock_storm_end") { OnShockStormEnd(); return true; }
		if (name == "shock_storm_loop") { OnShockStormLoop(); return true; }
		if (name == "shock_storm_on") { OnShockStormOn(); return true; }
		if (name == "staff_track_end") { OnStaffTrackEnd(); return true; }
		if (name == "staff_track_loop") { OnStaffTrackLoop(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "update_staff_glow") { OnUpdateStaffGlow(); return true; }
		return false;
	}
}
