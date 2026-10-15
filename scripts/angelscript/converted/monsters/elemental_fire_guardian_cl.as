#pragma context server

// Converted from monsters/elemental_fire_guardian_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/elemental_fire_guardian_cl"]
class ElementalFireGuardianCl : ScriptEntity
{
	// Constants
	string DRESS_SPRITE = "explode1.spr";
	int DRESS_SPRITE_NFRAMES = 8;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string STAFF_ON = "STAFF_ON";
	bool FX_ACTIVE = false;
	bool DEATH_MODE = false;
	Vector3 OWNER_VEL = Vector3();
	bool SHOCK_STORM_ON = false;
	string RING_Z = "RING_Z";
	float RING_ROT = 0.0f;
	float RING_ADD = 0.0f;
	int RING_RAD = 0;
	int RING_VADJ = 0;
	string STAFF_POS = "STAFF_POS";
	bool STAFF_LOOP_ACTIVE = false;

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

	// staff_glow
	// { fire_projectile //<angles> <end_pos> <hit:0|1> <speed>
	// setvard PROJECTILE_ANGLES PARAM1
	// local PROJECTILE_HIT PARAM3
	// setvard PROJECTILE_SPEED PARAM4
	// if ( !PROJECTILE_HIT )
	// {
	// setvard PROJECTILE_END PARAM2
	// callevent 0.5 fire_projectile_miss_sound
	// }
	// local SPR_POS $getcl(FX_OWNER,attachment1)
	// if ( !STAFF_LOOP_ACTIVE )
	// {
	// //dont need to track staff pos all the time, so just do it for next 10 secs
	// setvard STAFF_LOOP_ACTIVE 1
	// callevent 10.0 staff_track_end
	// callevent staff_track_loop
	// }
	// //dbg *** fire_projectile SPR_POS
	// cleffect tempent model weapons/projectiles.mdl SPR_POS setup_projectile
	// cleffect tempent sprite 3dmflaora.spr SPR_POS setup_staff_glow update_staff_glow
	// }
	// fire fire variant, that doesn't use a client projectile
	void OnStaffGlow()
	{
		ClientEffect("tempent", "sprite", "3dmflaora.spr", "SPR_POS", "setup_staff_glow", "update_staff_glow");
	}

	// poison_storm_on
	// <ground_pos>
	void OnPoisonStormOn(string groundPos = "")
	{
		if (!STAFF_LOOP_ACTIVE)
			OnStaffTrackLoop();
		SHOCK_STORM_ON = true;

		string sprPos = LegacyFunction("getcl", FX_OWNER, "origin");
		RING_Z = groundPos;

		PlaySound3D("magic/blackhole.wav", 10, Vec(sprPos));

		RING_ROT = 0.0f;
		RING_ADD = 90.0f;
		RING_RAD = 128;
		RING_VADJ = 128;
		for (int i = 0; i < 4; i++)
		{
			loopIteration = i;
			OnMakePoisonStormRing();
		}
		RING_ROT = 0.0f;
		RING_ADD = 45.0f;
		RING_RAD = 256;
		RING_VADJ = 64;
		for (int i = 0; i < 8; i++)
		{
			loopIteration = i;
			OnMakePoisonStormRing();
		}
		RING_ROT = 0.0f;
		RING_ADD = 22.5f;
		RING_RAD = 512;
		RING_VADJ = 32;
		for (int i = 0; i < 16; i++)
		{
			loopIteration = i;
			OnMakePoisonStormRing();
		}

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 512, Vector3(0, 128, 0), 10.0f);
	}

	// make_poison_storm_ring
	void OnMakePoisonStormRing()
	{
		Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		float ringFinalZ = Float(RING_Z);
		ringFinalZ += RING_VADJ;
		sprPos += RelativePosition(Vector3(0, RING_ROT, 0), Vector3(0, RING_RAD, ringFinalZ));
		ClientEffect("tempent", "sprite", "poison_cloud.spr", sprPos, "setup_storm_sprite", "update_storm_sprite");
		RING_ROT += RING_ADD;
	}

	// poison_storm_end
	void OnPoisonStormEnd()
	{
		SHOCK_STORM_ON = false;
		OnStaffTrackEnd();
	}

	// poison_storm_loop
	void OnPoisonStormLoop()
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
		PlaySound3D("weapons/dagger/daggermetal2.wav", 10, Vec("PROJECTILE_END"));
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
		// cleffect tempent set_current_prop rendercolor (64,128,255)
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", 1.0f);
		ClientEffect("tempent", "set_current_prop", "update", 1);
	}

	// setup_cloud
	// { setup_projectile
	// cleffect tempent set_current_prop death_delay 	1.5
	// cleffect tempent set_current_prop renderamt	255
	// cleffect tempent set_current_prop rendermode add
	// cleffect tempent set_current_prop scale 2.0
	// cleffect tempent set_current_prop gravity 	0
	// local L_PROJECTILE_ANGLES PROJECTILE_ANGLES
	// vectorset L_PROJECTILE_ANGLES x $neg($vec.x(PROJECTILE_ANGLES))
	// cleffect tempent set_current_prop angles L_PROJECTILE_ANGLES //$getcl(FX_OWNER,angles)
	// cleffect tempent set_current_prop velocity $relvel(PROJECTILE_ANGLES,$vec(0,PROJECTILE_SPEED,0))
	// cleffect tempent set_current_prop collide world;die
	// cleffect tempent set_current_prop body 	38
	// cleffect tempent set_current_prop fadeout lifetime
	// cleffect tempent set_current_prop framerate 1.0
	// cleffect tempent set_current_prop frames 40
	// cleffect tempent set_current_prop sequence 15
	// }
	void OnSetupCloud()
	{
		float rndPitch;
		float rndAng;
		Vector3 cloudVel;

		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "framerate", 60);
		ClientEffect("tempent", "set_current_prop", "frames", DRESS_SPRITE_NFRAMES);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "framerate", 15);
		ClientEffect("tempent", "set_current_prop", "scale", 0.05f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		// cleffect tempent set_current_prop rendercolor (128,230,255)
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
		if (curScale < 1.0f)
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

	// setup_storm_sprite
	void OnSetupStormSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", -0.01f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", RING_RAD);
		ClientEffect("tempent", "set_current_prop", "fuser2", RING_ROT);
	}

	// update_storm_sprite
	void OnUpdateStormSprite()
	{
		string curPos = Eval("game.tempent.origin");
		int curRad = Int(Eval("game.tempent.fuser1"));
		float curRot = Float(Eval("game.tempent.fuser2"));
		curRot += 1.0f;
		if (curRot > 359.99f)
			curRot = 0.0f;
		ClientEffect("tempent", "set_current_prop", "fuser2", curRot);

		Vector3 newPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		newPos.z = Vec(curPos).z;
		newPos += RelativePosition(Vector3(0, curRot, 0), Vector3(0, curRad, 0));
		ClientEffect("tempent", "set_current_prop", "origin", newPos);
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
		if (name == "fire_projectile_miss_sound") { OnFireProjectileMissSound(); return true; }
		if (name == "guardian_death") { OnGuardianDeath(); return true; }
		if (name == "make_poison_storm_ring") { OnMakePoisonStormRing(); return true; }
		if (name == "poison_storm_end") { OnPoisonStormEnd(); return true; }
		if (name == "poison_storm_loop") { OnPoisonStormLoop(); return true; }
		if (name == "poison_storm_on") { OnPoisonStormOn(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_staff_glow") { OnSetupStaffGlow(); return true; }
		if (name == "setup_storm_sprite") { OnSetupStormSprite(); return true; }
		if (name == "staff_glow") { OnStaffGlow(); return true; }
		if (name == "staff_track_end") { OnStaffTrackEnd(); return true; }
		if (name == "staff_track_loop") { OnStaffTrackLoop(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "update_staff_glow") { OnUpdateStaffGlow(); return true; }
		if (name == "update_storm_sprite") { OnUpdateStormSprite(); return true; }
		return false;
	}
}
