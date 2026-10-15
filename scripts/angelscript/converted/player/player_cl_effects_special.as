#pragma context server

// Converted from player/player_cl_effects_special.script by msc_transpiler.
// Any CL effect event in this script can be called simply by using:
// clientevent update all const.localplayer.scriptID <eventname> <params>
// Also this script stays alive for the duration of the map.
// You cannot remove this script.
// Kaz Elder effects were moved to independant script - Kaz Hollow One is still here though

#include "runtime/ScriptEntity.as"
#include "converted/player/client/halos.as"
#include "converted/player/player_cl_effects_weather.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClEffectsSpecial
{
	// Constants
	int LIGHTSYS_N_LIGHTS = 16;
	string PLAYER_MODEL = "human/reference.mdl";
	string CL_HBAR_SPRITE = "health_bar.spr";
	string KH_SPRITE_DRAINER = "fire1_fixed.spr";
	int KH_DRAINER_SPEED = 30;
	string KH_GLOW_SPRITE = "3dmflaora.spr";
	int MIRROR_DIST = 96;
	float MIRROR_LIFE = 5.0f;
	string SOUND_FREEZE = "magic/freeze.wav";
	int TN_TELE_FRAMES = 25;

	// Variables (an unset .script variable reads as its own name)
	string KH_SKEL = "KH_SKEL";
	string KH_DRAINER_ANGS = "KH_DRAINER_ANGS";
	bool MIRRORS_ON = false;
	bool KH_FIRE_BREATH = false;
	bool KH_FLIGHT_SPRITES_ON = false;
	string KH_HAND_SPRITE_COLOR = "KH_HAND_SPRITE_COLOR";
	bool KH_HAND_SPRITES_ON = false;
	string MIRROR_MODEL = "MIRROR_MODEL";
	string MIRROR_ANGLES = "MIRROR_ANGLES";
	float MIRROR_ANGLE_COUNTER = 0.0f;
	int MIRROR_MODE = 0;
	float MIRROR_RENDERAMT = 0.0f;
	Vector3 MIRROR_VEL = Vector3();
	Vector3 KH_BREATH_COLOR = Vector3();
	string KH_FLAME_SPRITE = "KH_FLAME_SPRITE";
	bool KH_ZAP_ON = false;
	string KH_ZAP_TARGET = "KH_ZAP_TARGET";
	float KH_ZAP_NERF = 0.0f;
	float KH_FS_ROT_COUNT = 0.0f;
	float KH_FS_ANG_COUNT = 0.0f;
	Vector3 KH_DRAG_POS = Vector3();
	string KH_DRAG_PAT01 = "KH_DRAG_PAT01";
	string KH_DRAG_PAT02 = "KH_DRAG_PAT02";
	string KH_DRAG_PAT03 = "KH_DRAG_PAT03";
	string KH_DRAG_PAT04 = "KH_DRAG_PAT04";
	string KH_DRAG_PAT05 = "KH_DRAG_PAT05";
	string KH_DRAG_PAT06 = "KH_DRAG_PAT06";
	string KH_DRAG_PAT07 = "KH_DRAG_PAT07";
	string KH_DRAG_PAT08 = "KH_DRAG_PAT08";
	string KH_DRAG_PAT09 = "KH_DRAG_PAT09";
	string KH_DRAG_PAT10 = "KH_DRAG_PAT10";
	string KH_DRAG_PAT11 = "KH_DRAG_PAT11";
	string KH_DRAG_PAT12 = "KH_DRAG_PAT12";
	string KH_DRAG_PAT13 = "KH_DRAG_PAT13";
	string KH_DRAG_PAT14 = "KH_DRAG_PAT14";
	string KH_DRAG_PAT15 = "KH_DRAG_PAT15";
	string KH_DRAG_PAT16 = "KH_DRAG_PAT16";
	float KH_DRAG_COUNT = 0.0f;
	string KH_TEMP_ROW = "KH_TEMP_ROW";
	int KH_X_COUNT = 0;
	string TN_IDX = "TN_IDX";
	string TN_TELE_SPR = "TN_TELE_SPR";
	string TN_GLOW_SPR = "TN_GLOW_SPR";
	bool TN_SPRITE_LOOP = false;
	bool FX_SMITH_EFFECTS = false;
	string FX_SMITH_TYPE = "FX_SMITH_TYPE";
	string FX_SMITH_SPRITE = "FX_SMITH_SPRITE";
	string FX_SMITH_ICESPRITE = "FX_SMITH_ICESPRITE";
	string PHL_OWNER = "PHL_OWNER";
	bool PHL_ON = false;
	string PHL_POS = "PHL_POS";
	bool PHL_HIDE = false;
	float PHL_NEXT_SEAL = 0.0f;
	string CL_HBAR_POS = "CL_HBAR_POS";
	float CL_HBAR_FRAME = 0.0f;
	string CL_HBAR_SCALE = "CL_HBAR_SCALE";
	string CL_HBAR_INDEX = "CL_HBAR_INDEX";
	float NEXT_LIGHT_DEBUG = 0.0f;
	bool LIGHTSYS_TRACK_LIGHTS = false;
	bool LIGHTSYS_INITIALIZED = false;
	bool LIGHTSYS_ANY_VALID = false;
	string CL_TELE1_ORG = "CL_TELE1_ORG";
	string SFX_METAL_CAVE_MDL = "SFX_METAL_CAVE_MDL";
	float SFX_R_CYCLE = 0.0f;
	float SFX_G_CYCLE = 0.0f;
	float SFX_B_CYCLE = 0.0f;
	float SFX_R_CYCLE_PM = 0.0f;
	float SFX_G_CYCLE_PM = 0.0f;
	float SFX_B_CYCLE_PM = 0.0f;
	string SFX_METAL_CAVE_LIGHT = "SFX_METAL_CAVE_LIGHT";
	bool SFX_METAL_CAVE_LIGHT_ACTIVE = false;
	string CYCLE_BEAM = "CYCLE_BEAM";
	string CORPSE_ANG = "CORPSE_ANG";
	string CORPSE_ANIM_IDX = "CORPSE_ANIM_IDX";
	string CORPSE_SCALE = "CORPSE_SCALE";
	float L_INRENDER = 0.0f;
	string CORPSE_RENDERMODE = "CORPSE_RENDERMODE";
	string CORPSE_RENDERAMT = "CORPSE_RENDERAMT";
	string CORPSE_BODY_IDX = "CORPSE_BODY_IDX";
	string CORPSE_SKIN = "CORPSE_SKIN";
	bool SETUP_TEST_ARRAY = false;

	// unnamed block (first think)
	void PlayerClEffectsSpecial_FirstThink()
	{
		// array.create ARRAY_LIGHT_OWNERLIST
		ArrayCreate("ARRAY_LIGHT_COLOR");
		ArrayCreate("ARRAY_LIGHT_RAD");
		ArrayCreate("ARRAY_LIGHT_IDLIST");
	}

	// ext_cl_clientcmd
	// <commands>
	void PlayerClEffectsSpecial_OnExtClClientcmd(string commands = "")
	{
		DebugPrint("*** ext_cl_clientcmd " + LegacyFunction("quote", commands));
		// The Steam Pipe variant makes some commands illegal to send from the server
		// this is a work around to have the client send commands to himself
		ClientEffect("clientcmd", commands);
	}

	// game_prerender
	void PlayerClEffectsSpecial_OnGamePrerender()
	{
		int count;

		if (LIGHTSYS_TRACK_LIGHTS)
		{
			count = LIGHTSYS_N_LIGHTS;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnLightsysRenderLights();
			}
		}
		if (SFX_METAL_CAVE_LIGHT_ACTIVE)
			OnClMetalCaveCycle();
	}

	// cl_error
	// ==========================================
	// Call error against specific client so as not to disconnect whole server
	// <text>
	void PlayerClEffectsSpecial_OnClError(string message = "")
	{
		LegacyCommand("errormessage", message);
	}

	// kh_setup
	// <owner>
	void PlayerClEffectsSpecial_OnKhSetup(string owner = "")
	{
		KH_SKEL = owner;
	}

	// kh_make_drain_sprite
	// <pos> [idx] <angs> <draining>
	void PlayerClEffectsSpecial_OnKhMakeDrainSprite(string spawnPosition = "", string index = "", string drainerAngles = "", string draining = "")
	{
		// dbg **** kh_make_drain_sprite PARAM1 PARAM2 PARAM3
		KH_DRAINER_ANGS = drainerAngles;
		ClientEffect("tempent", "sprite", KH_SPRITE_DRAINER, spawnPosition, "kh_setup_drainer");

		if (Truthy(draining))
			PlaySound3D("magic/energy1_loud.wav", 10, Vec(spawnPosition));
	}

	// kh_sprite_splode
	// origin
	void PlayerClEffectsSpecial_OnKhSpriteSplode(string origin = "")
	{
		// dbg **** kh_sprite_splode
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, origin, "kh_setup_spark");
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, origin, "kh_setup_spark");
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, origin, "kh_setup_spark");
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, origin, "kh_setup_spark");
		PlaySound3D("turret/tu_die2.wav", 10, Vec(origin));
	}

	// kh_setup_drainer
	void PlayerClEffectsSpecial_OnKhSetupDrainer()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.1f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 255));
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 23);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", KH_DRAINER_ANGS);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vec(KH_DRAINER_ANGS), Vector3(0, KH_DRAINER_SPEED, 0)));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// kh_setup_spark
	void PlayerClEffectsSpecial_OnKhSetupSpark()
	{
		float rndAng = Random(0, 359);
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vector3(0, rndAng, 0), Vector3(0, 120, 110)));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 5);
		ClientEffect("tempent", "set_current_prop", "scale", 0.25f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 255));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// kh_setup_hand_sprite
	void PlayerClEffectsSpecial_OnKhSetupHandSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(Random(-20, 20), 0, 0)));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", KH_HAND_SPRITE_COLOR);
		ClientEffect("tempent", "set_current_prop", "gravity", -0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// kh_end_effects
	void PlayerClEffectsSpecial_OnKhEndEffects()
	{
		MIRRORS_ON = false;
		KH_FIRE_BREATH = false;
		KH_FLIGHT_SPRITES_ON = false;
	}

	// kh_hand_sprites
	void PlayerClEffectsSpecial_OnKhHandSprites(string duration = "", string color = "")
	{
		KH_HAND_SPRITE_COLOR = color;
		KH_HAND_SPRITES_ON = true;
		CallEventOrDelay(duration, "kh_end_hand_sprites");
		OnKhHandSpriteLoop();
	}

	// kh_hand_sprite_loop
	void PlayerClEffectsSpecial_OnKhHandSpriteLoop()
	{
		if (!KH_HAND_SPRITES_ON)
			return;
		CallEventDelayed(0.1f, "kh_hand_sprite_loop");

		string spawnPos = LegacyFunction("getcl", KH_SKEL, "bonepos", 20);
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, spawnPos, "kh_setup_hand_sprite");

		spawnPos = LegacyFunction("getcl", KH_SKEL, "bonepos", 16);
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, spawnPos, "kh_setup_hand_sprite");
	}

	// kh_end_hand_sprites
	void PlayerClEffectsSpecial_OnKhEndHandSprites()
	{
		KH_HAND_SPRITES_ON = false;
	}

	// kh_spawn_mirrors
	// <model> <origin> <angles>
	void PlayerClEffectsSpecial_OnKhSpawnMirrors(string model = "", string origin = "", string angles = "")
	{
		// we pass the model here to make sure it doesn't precache when it's not needed
		MIRROR_MODEL = model;
		MIRROR_ANGLES = angles;
		MIRROR_ANGLE_COUNTER = 0.0f;

		MIRRORS_ON = true;
		MIRROR_MODE = 1;
		MIRROR_RENDERAMT = 0.0f;

		int mirrorStartSpeed = 5;

		// five mirror images at various angles
		float mirrorSang = 0.0f;
		MIRROR_VEL = RelativeVelocity(Vector3(0, mirrorSang, 0), Vector3(0, mirrorStartSpeed, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, origin, "kh_setup_mirror", "kh_update_mirror0");

		mirrorSang += 72.0f;
		MIRROR_VEL = RelativeVelocity(Vector3(0, mirrorSang, 0), Vector3(0, mirrorStartSpeed, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, origin, "kh_setup_mirror", "kh_update_mirror1");

		mirrorSang += 72.0f;
		MIRROR_VEL = RelativeVelocity(Vector3(0, mirrorSang, 0), Vector3(0, mirrorStartSpeed, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, origin, "kh_setup_mirror", "kh_update_mirror2");

		mirrorSang += 72.0f;
		MIRROR_VEL = RelativeVelocity(Vector3(0, mirrorSang, 0), Vector3(0, mirrorStartSpeed, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, origin, "kh_setup_mirror", "kh_update_mirror3");

		mirrorSang += 72.0f;
		MIRROR_VEL = RelativeVelocity(Vector3(0, mirrorSang, 0), Vector3(0, mirrorStartSpeed, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, origin, "kh_setup_mirror", "kh_update_mirror4");

		CallEventDelayed(MIRROR_LIFE, "kh_refresh_mirrors");
	}

	// kh_update_mirror0
	void PlayerClEffectsSpecial_OnKhUpdateMirror0()
	{
		OnKhMirrorUpdate(0);
	}

	// kh_update_mirror1
	void PlayerClEffectsSpecial_OnKhUpdateMirror1()
	{
		OnKhMirrorUpdate(72);
	}

	// kh_update_mirror2
	void PlayerClEffectsSpecial_OnKhUpdateMirror2()
	{
		OnKhMirrorUpdate(144);
	}

	// kh_update_mirror3
	void PlayerClEffectsSpecial_OnKhUpdateMirror3()
	{
		OnKhMirrorUpdate(216);
	}

	// kh_update_mirror4
	void PlayerClEffectsSpecial_OnKhUpdateMirror4()
	{
		OnKhMirrorUpdate(288);
		MIRROR_ANGLE_COUNTER += 1.0f;
		if (MIRROR_ANGLE_COUNTER > 359.0f)
			MIRROR_ANGLE_COUNTER -= 359.0f;
	}

	// kh_mirror_update
	void PlayerClEffectsSpecial_OnKhMirrorUpdate(int angleOffset = 0)
	{
		if (!MIRRORS_ON)
		{
			ClientEffect("tempent", "set_current_prop", "rendermode", "add");
			ClientEffect("tempent", "set_current_prop", "renderamt", 0);
			ClientEffect("tempent", "set_current_prop", "death_delay", 0.1f);
		}

		if (!MIRRORS_ON)
			return;

		if (MIRROR_MODE == 1)
		{
			// fade in (all mirrors)
			// dbg **** Mirrors fade in MIRROR_RENDERAMT
			MIRROR_RENDERAMT += 5.0f;
			if (MIRROR_RENDERAMT >= 255.0f)
			{
				// cleffect tempent set_current_prop rendermode add
				ClientEffect("tempent", "set_current_prop", "renderamt", 255);
				MIRROR_MODE = 2;
			}
			else
			{
				ClientEffect("tempent", "set_current_prop", "renderamt", MIRROR_RENDERAMT);
			}
		}

		if (MIRROR_MODE == 2)
		{
			int angAdj = angleOffset;
			// add MIRROR_ANGLE_COUNTER 1
			// if ( MIRROR_ANGLE_COUNTER > 359 ) subtract MIRROR_ANGLE_COUNTER 359
			float ang = MIRROR_ANGLE_COUNTER + angAdj;
			if (ang > 359.0f)
				ang -= 359.0f;

			Vector3 mirrorPos = Vec(LegacyFunction("getcl", KH_SKEL, "origin"));
			string dbgPos = Text(mirrorPos);
			mirrorPos += RelativePosition(Vector3(0, ang, 0), Vector3(0, MIRROR_DIST, 0));

			// dbg **** mirrors_spin $dist(MIRROR_POS,DBG_POS)
			ClientEffect("tempent", "set_current_prop", "renderamt", 255);
			ClientEffect("tempent", "set_current_prop", "rendermode", "add");
			ClientEffect("tempent", "set_current_prop", "angles", LegacyFunction("getcl", KH_SKEL, "angles"));
			ClientEffect("tempent", "set_current_prop", "origin", mirrorPos);
			ClientEffect("tempent", "set_current_prop", "velocity", 0);
		}
	}

	// kh_refresh_mirrors
	void PlayerClEffectsSpecial_OnKhRefreshMirrors()
	{
		DebugPrint("**** kh_refresh_mirrors");

		if (!MIRRORS_ON)
			return;

		MIRROR_ANGLES = LegacyFunction("getcl", KH_SKEL, "angles");

		float mirrorAng = MIRROR_ANGLE_COUNTER;
		if (mirrorAng > 359.0f)
			mirrorAng -= 359.0f;
		Vector3 mirrorPos = RelativePosition(Vector3(0, 0, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, mirrorPos, "kh_setup_mirror", "kh_update_mirror0");

		mirrorAng = MIRROR_ANGLE_COUNTER + 72.0f;
		if (mirrorAng > 359.0f)
			mirrorAng -= 359.0f;
		mirrorPos = RelativePosition(Vector3(0, 0, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, mirrorPos, "kh_setup_mirror", "kh_update_mirror1");

		mirrorAng = MIRROR_ANGLE_COUNTER + 144.0f;
		if (mirrorAng > 359.0f)
			mirrorAng -= 359.0f;
		mirrorPos = RelativePosition(Vector3(0, 0, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, mirrorPos, "kh_setup_mirror", "kh_update_mirror2");

		mirrorAng = MIRROR_ANGLE_COUNTER + 216.0f;
		if (mirrorAng > 359.0f)
			mirrorAng -= 359.0f;
		mirrorPos = RelativePosition(Vector3(0, 0, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, mirrorPos, "kh_setup_mirror", "kh_update_mirror3");

		mirrorAng = MIRROR_ANGLE_COUNTER + 288.0f;
		if (mirrorAng > 359.0f)
			mirrorAng -= 359.0f;
		mirrorPos = RelativePosition(Vector3(0, 0, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, mirrorPos, "kh_setup_mirror", "kh_update_mirror4");

		CallEventDelayed(MIRROR_LIFE, "kh_refresh_mirrors");
	}

	// kh_setup_mirror
	void PlayerClEffectsSpecial_OnKhSetupMirror()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", MIRROR_LIFE);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", LegacyFunction("getcl", KH_SKEL, "angles"));
		ClientEffect("tempent", "set_current_prop", "velocity", MIRROR_VEL);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 999);
	}

	// kh_mirror_poof
	void PlayerClEffectsSpecial_OnKhMirrorPoof()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 3.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", -0.25f);
		ClientEffect("tempent", "set_current_prop", "angles", LegacyFunction("getcl", KH_SKEL, "angles"));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 999);
	}

	// kh_mirrors_off
	void PlayerClEffectsSpecial_OnKhMirrorsOff()
	{
		// dbg **** kh_mirrors_off
		MIRRORS_ON = false;

		float poofPosAng = MIRROR_ANGLE_COUNTER;
		Vector3 poofPos = RelativePosition(Vector3(0, poofPosAng, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, poofPos, "kh_mirror_poof");

		poofPosAng = MIRROR_ANGLE_COUNTER + 72.0f;
		if (poofPosAng > 359.0f)
			poofPosAng -= 359.0f;
		poofPos = RelativePosition(Vector3(0, poofPosAng, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, poofPos, "kh_mirror_poof");

		poofPosAng = MIRROR_ANGLE_COUNTER + 144.0f;
		if (poofPosAng > 359.0f)
			poofPosAng -= 359.0f;
		poofPos = RelativePosition(Vector3(0, poofPosAng, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, poofPos, "kh_mirror_poof");

		poofPosAng = MIRROR_ANGLE_COUNTER + 216.0f;
		if (poofPosAng > 359.0f)
			poofPosAng -= 359.0f;
		poofPos = RelativePosition(Vector3(0, poofPosAng, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, poofPos, "kh_mirror_poof");

		poofPosAng = MIRROR_ANGLE_COUNTER + 288.0f;
		if (poofPosAng > 359.0f)
			poofPosAng -= 359.0f;
		poofPos = RelativePosition(Vector3(0, poofPosAng, 0), Vector3(0, MIRROR_DIST, 0));
		ClientEffect("tempent", "model", MIRROR_MODEL, poofPos, "kh_mirror_poof");
	}

	// kh_ice_spikes
	// == Ice Spikes
	// <position>
	void PlayerClEffectsSpecial_OnKhIceSpikes(string spawnPosition = "")
	{
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", spawnPosition, "kh_setup_ice_spikes", "kh_update_ice_spikes");
		PlaySound3D(SOUND_FREEZE, 10, Vec(spawnPosition));
	}

	// kh_update_ice_spikes
	void PlayerClEffectsSpecial_OnKhUpdateIceSpikes()
	{
		if (Float(Eval("game.tempent.fuser2")) == 1.0f)
			return;

		int curAnim = Int(Eval("game.tempent.anim"));
		string curFrame = Eval("game.tempent.frame"); // meh, this seems to be broken for models, returns all sorts of weird numbers

		// dbg *** kh_update_ice_spikes game.tempent.fuser1 game.tempent.fuser2 game.tempent.animtime game.tempent.starttime
		if (curAnim == 17)
		{
			float raiseTime = Float(Eval("game.tempent.fuser1"));
			raiseTime += 0.5f;
			if (GameTime() > raiseTime)
			{
				ClientEffect("tempent", "set_current_prop", "sequence", 18);
				ClientEffect("tempent", "set_current_prop", "framerate", 0.1f);
				ClientEffect("tempent", "set_current_prop", "frame", 0);
				ClientEffect("tempent", "set_current_prop", "fuser2", 1);
			}
		}
	}

	// kh_setup_ice_spikes
	void PlayerClEffectsSpecial_OnKhSetupIceSpikes()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		// cleffect tempent set_current_prop renderamt	255
		// cleffect tempent set_current_prop rendermode add
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 2.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 999);
		ClientEffect("tempent", "set_current_prop", "body", 45);
		ClientEffect("tempent", "set_current_prop", "sequence", 17);
		ClientEffect("tempent", "set_current_prop", "fuser1", GameTime());
		ClientEffect("tempent", "set_current_prop", "fuser2", 69);
	}

	// kh_fire_breath_on
	// ==== Fire/Posion Breath
	// (external)
	void PlayerClEffectsSpecial_OnKhFireBreathOn(string sprite = "")
	{
		KH_FIRE_BREATH = true;
		KH_BREATH_COLOR = Vector3(0, 0, 0);
		KH_FLAME_SPRITE = sprite; // passing sprite to avoid uneeded precaches
		DebugPrint("**** kh_fire_breath_on " + KH_FLAME_SPRITE + " at " + LegacyFunction("getcl", KH_SKEL, "attachment2") + " ang " + LegacyFunction("getcl", KH_SKEL, "angles.yaw"));
		OnKhFireBreathLoop();
	}

	// kh_fire_breath_loop
	void PlayerClEffectsSpecial_OnKhFireBreathLoop()
	{
		if (!KH_FIRE_BREATH)
			return;
		CallEventDelayed(0.01f, "kh_fire_breath_loop");
		string cloudOrg = LegacyFunction("getcl", KH_SKEL, "attachment2"); // just learned this attachment command from the code
		// if ( !$getcl(KH_SKEL,visible) )	vectoradd CLOUD_ORG z 72
		ClientEffect("tempent", "sprite", KH_FLAME_SPRITE, cloudOrg, "setup_fire_breath");
		ClientEffect("tempent", "sprite", KH_FLAME_SPRITE, cloudOrg, "setup_fire_breath");
	}

	// kh_fire_breath_off
	// (external)
	void PlayerClEffectsSpecial_OnKhFireBreathOff()
	{
		KH_FIRE_BREATH = false;
	}

	// kh_poison_breath_on
	// <sprite>
	void PlayerClEffectsSpecial_OnKhPoisonBreathOn(string sprite = "")
	{
		KH_FIRE_BREATH = true;
		KH_BREATH_COLOR = Vector3(0, 255, 0);
		KH_FLAME_SPRITE = sprite; // passing sprite to avoid uneeded precaches
		// dbg **** kh_fire_breath_on KH_FLAME_SPRITE at $getcl(KH_SKEL,attachment2) ang $getcl(KH_SKEL,angles.yaw)
		OnKhFireBreathLoop();
	}

	// kh_poison_breath_loop
	void PlayerClEffectsSpecial_OnKhPoisonBreathLoop()
	{
		if (!KH_FIRE_BREATH)
			return;
		CallEventDelayed(0.01f, "kh_poison_breath_loop");
		string cloudOrg = LegacyFunction("getcl", KH_SKEL, "attachment2"); // just learned this attachment command from the code
		// if ( !$getcl(KH_SKEL,visible) )	vectoradd CLOUD_ORG z 72
		ClientEffect("tempent", "sprite", KH_FLAME_SPRITE, cloudOrg, "setup_fire_breath");
		ClientEffect("tempent", "sprite", KH_FLAME_SPRITE, cloudOrg, "setup_fire_breath");
	}

	// kh_poison_breath_off
	// (external)
	void PlayerClEffectsSpecial_OnKhPoisonBreathOff()
	{
		KH_FIRE_BREATH = false;
	}

	// kh_zap_target_on
	// === Lightning Shield
	// target
	void PlayerClEffectsSpecial_OnKhZapTargetOn(string target = "")
	{
		KH_ZAP_ON = true;
		KH_ZAP_TARGET = target;
		OnKhZapTargetLoop();
		KH_ZAP_NERF = GameTime() + 1.0f;
	}

	// kh_zap_target_loop
	void PlayerClEffectsSpecial_OnKhZapTargetLoop()
	{
		int exitSub = 0;

		if (!KH_ZAP_ON)
			return;
		CallEventDelayed(0.1f, "kh_zap_target_loop");

		if (GameTime() > KH_ZAP_NERF)
		{
			// been zapping for awhile now, cut down to avoid ent flood
			exitSub = RandomInt(0, 1);
		}
		if (exitSub != 0)
			return;

		Vector3 beamStart = Vec(LegacyFunction("getcl", KH_SKEL, "origin"));
		Vector3 beamEnd = Vec(LegacyFunction("getcl", KH_SKEL, "origin")); // $getcl(KH_ZAP_TARGET,origin)

		beamStart.z += 36.0f; // adjust for height

		float rndPitch = Random(0, 359);
		float rndYaw = Random(0, 359);
		beamStart += RelativePosition(Vector3(rndPitch, rndYaw, 0), Vector3(0, 32, 0));

		rndPitch = Random(0, 359);
		rndYaw = Random(0, 359);
		beamEnd += RelativePosition(Vector3(rndPitch, rndYaw, 0), Vector3(0, 32, 0));
		ClientEffect("beam_points", beamStart, beamEnd, "lgtning.spr", 0.2f, 2, 9, 0.3f, 0.1f, 30, Vector3(2, 1.5f, 0.25f));
	}

	// kh_zap_target_off
	void PlayerClEffectsSpecial_OnKhZapTargetOff()
	{
		KH_ZAP_ON = false;
	}

	// kh_flight_sprites
	// ====================== FLIGHT SPRITES =============================
	// <1|0>
	void PlayerClEffectsSpecial_OnKhFlightSprites(string enabled = "")
	{
		if (Truthy(enabled))
		{
			KH_FLIGHT_SPRITES_ON = true;
			KH_FS_ROT_COUNT = 0.0f;
			KH_FS_ANG_COUNT = 0.0f;
			for (int i = 0; i < 18; i++)
			{
				loopIteration = i;
				OnKhSpawnFlightSprites();
			}
			CallEventDelayed(10.0f, "kh_refresh_flight_sprites");
		}
		else
		{
			KH_FLIGHT_SPRITES_ON = false;
		}
	}

	// kh_spawn_flight_sprites
	void PlayerClEffectsSpecial_OnKhSpawnFlightSprites()
	{
		Vector3 spawnPos = Vec(LegacyFunction("getcl", KH_SKEL, "origin"));
		spawnPos += RelativePosition(Vector3(0, KH_FS_ANG_COUNT, 0), Vector3(0, 64, 0));
		ClientEffect("tempent", "sprite", KH_GLOW_SPRITE, spawnPos, "kh_setup_flight_sprite", "kh_update_flight_sprite");
		KH_FS_ANG_COUNT += 40.0f;
	}

	// kh_refresh_flight_sprites
	void PlayerClEffectsSpecial_OnKhRefreshFlightSprites()
	{
		if (!KH_FLIGHT_SPRITES_ON)
			return;
		KH_FS_ANG_COUNT = 0.0f;
		for (int i = 0; i < 9; i++)
		{
			loopIteration = i;
			OnKhSpawnFlightSprites();
		}
		CallEventDelayed(10.0f, "kh_refresh_flight_sprites");
	}

	// kh_update_flight_sprite
	void PlayerClEffectsSpecial_OnKhUpdateFlightSprite()
	{
		if (KH_FLIGHT_SPRITES_ON)
		{
			// dbg **** kh_update_flight_sprite KH_FS_ROT_COUNT [ game.tempent.fuser1 ]
			if (Float(Eval("game.tempent.fuser1")) == 0.0f)
			{
				KH_FS_ROT_COUNT += 1.0f;
				if (KH_FS_ROT_COUNT > 359.0f)
					KH_FS_ROT_COUNT -= 359.0f;
			}
			float myRot = KH_FS_ROT_COUNT + Float(Eval("game.tempent.fuser1"));
			if (myRot > 359.0f)
				myRot -= 359.0f;
			Vector3 myPos = Vec(LegacyFunction("getcl", KH_SKEL, "origin"));
			myPos += RelativePosition(Vector3(0, myRot, 0), Vector3(0, 64, 0));
			ClientEffect("tempent", "set_current_prop", "origin", myPos);
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "death_delay", 0.01f);
			ClientEffect("tempent", "set_current_prop", "renderamt", 0);
		}
	}

	// kh_setup_flight_sprite
	void PlayerClEffectsSpecial_OnKhSetupFlightSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vector3(0, 0, 0), Vector3(Random(-20, 20), 0, 0)));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		// cleffect tempent set_current_prop rendercolor (255,255,255)
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "update", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", KH_FS_ANG_COUNT);
	}

	// kh_dragon_death
	// <pos>
	void PlayerClEffectsSpecial_OnKhDragonDeath(Vector3 position = Vector3())
	{
		KH_DRAG_POS = position;
		KH_DRAG_POS.z = GroundHeight(KH_DRAG_POS);

		// dbg **** kh_dragon_death KH_DRAG_POS
		// dragon pattern
		KH_DRAG_PAT01 = "0;0;0;1;0;1;0;1;0;0;0;0";
		KH_DRAG_PAT02 = "0;1;0;0;1;1;1;0;0;0;1;0";
		KH_DRAG_PAT03 = "1;0;0;0;1;1;1;0;0;0;0;1";
		KH_DRAG_PAT04 = "1;1;0;0;0;1;0;0;0;0;1;1";
		KH_DRAG_PAT05 = "0;1;1;0;0;1;0;0;1;1;1;0";
		KH_DRAG_PAT06 = "0;0;1;1;1;1;1;1;1;1;0;0";
		KH_DRAG_PAT07 = "0;0;0;1;1;1;1;1;1;0;0;0";
		KH_DRAG_PAT08 = "0;0;0;0;1;1;1;0;0;0;0;0";
		KH_DRAG_PAT09 = "0;0;0;0;0;1;0;0;0;0;0;0";
		KH_DRAG_PAT10 = "0;0;0;0;0;1;0;0;0;0;0;0";
		KH_DRAG_PAT11 = "0;0;0;0;0;1;0;0;0;0;0;0";
		KH_DRAG_PAT12 = "0;0;0;0;0;1;0;0;0;0;0;0";
		KH_DRAG_PAT13 = "0;0;0;0;0;1;0;0;0;0;0;0";
		KH_DRAG_PAT14 = "0;0;0;0;0;0;0;0;0;0;0;0";
		KH_DRAG_PAT15 = "0;0;0;0;0;0;1;0;0;0;0;0";
		KH_DRAG_PAT16 = "0;0;0;0;0;0;0;1;0;0;0;0";

		KH_DRAG_COUNT = 0.0f;
		OnKhDragonDeathLoop();
	}

	// kh_dragon_death_loop
	void PlayerClEffectsSpecial_OnKhDragonDeathLoop()
	{
		// dbg **** kh_dragon_death_loop KH_DRAG_COUNT
		if (KH_DRAG_COUNT < 16.0f)
			CallEventDelayed(0.2f, "kh_dragon_death_loop");
		KH_DRAG_COUNT += 1.0f;

		if (KH_DRAG_COUNT == 1.0f)
			OnKhMakeRow(KH_DRAG_PAT01);
		if (KH_DRAG_COUNT == 2.0f)
			OnKhMakeRow(KH_DRAG_PAT02);
		if (KH_DRAG_COUNT == 3.0f)
			OnKhMakeRow(KH_DRAG_PAT03);
		if (KH_DRAG_COUNT == 4.0f)
			OnKhMakeRow(KH_DRAG_PAT04);
		if (KH_DRAG_COUNT == 5.0f)
			OnKhMakeRow(KH_DRAG_PAT05);
		if (KH_DRAG_COUNT == 6.0f)
			OnKhMakeRow(KH_DRAG_PAT06);
		if (KH_DRAG_COUNT == 7.0f)
			OnKhMakeRow(KH_DRAG_PAT07);
		if (KH_DRAG_COUNT == 8.0f)
			OnKhMakeRow(KH_DRAG_PAT08);
		if (KH_DRAG_COUNT == 9.0f)
			OnKhMakeRow(KH_DRAG_PAT09);
		if (KH_DRAG_COUNT == 10.0f)
			OnKhMakeRow(KH_DRAG_PAT10);
		if (KH_DRAG_COUNT == 11.0f)
			OnKhMakeRow(KH_DRAG_PAT11);
		if (KH_DRAG_COUNT == 12.0f)
			OnKhMakeRow(KH_DRAG_PAT12);
		if (KH_DRAG_COUNT == 13.0f)
			OnKhMakeRow(KH_DRAG_PAT13);
		if (KH_DRAG_COUNT == 14.0f)
			OnKhMakeRow(KH_DRAG_PAT14);
		if (KH_DRAG_COUNT == 15.0f)
			OnKhMakeRow(KH_DRAG_PAT15);
		if (KH_DRAG_COUNT == 16.0f)
			OnKhMakeRow(KH_DRAG_PAT16);
	}

	// kh_make_row
	// cleffect tempent sprite 3dmflaora.spr SPR_POS kh_dragon_sprite
	void PlayerClEffectsSpecial_OnKhMakeRow(string row = "")
	{
		KH_TEMP_ROW = row;
		KH_X_COUNT = 8;
		int count = GetTokenCount(KH_TEMP_ROW);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnKhMakeRowLoop();
		}
	}

	// kh_make_row_loop
	void PlayerClEffectsSpecial_OnKhMakeRowLoop()
	{
		int curIdx = loopIteration;
		// dbg *** kh_dragon_death_loop KH_TEMP_ROW CUR_IDX $get_token(KH_TEMP_ROW,CUR_IDX)
		if (Float(GetToken(KH_TEMP_ROW, curIdx)) != 1.0f)
			return;
		float khXCount = 16.0f * curIdx - 96.0f;
		Vector3 spritePos = KH_DRAG_POS + RelativePosition(Vector3(0, 0, 0), Vector3(khXCount, 0, 0));
		ClientEffect("tempent", "sprite", "3dmflaora.spr", spritePos, "kh_dragon_sprite");
	}

	// kh_dragon_sprite
	void PlayerClEffectsSpecial_OnKhDragonSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 5.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", -0.05f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// titan_setup
	// ==== TITAN
	// $get(ent_me,index) CL_TELE_SPR CL_GLOW_SPR
	void PlayerClEffectsSpecial_OnTitanSetup(string titanIndex = "", string teleSprite = "", string glowSprite = "")
	{
		// Passing the sprite names to avoid uneeded precaches
		TN_IDX = titanIndex;
		TN_TELE_SPR = teleSprite;
		TN_GLOW_SPR = glowSprite;
	}

	// titan_summon_sprite
	// <sum_point>
	void PlayerClEffectsSpecial_OnTitanSummonSprite(string sumPoint = "")
	{
		ClientEffect("tempent", "sprite", TN_TELE_SPR, sumPoint, "titan_tele_sprite");

		if (TN_SPRITE_LOOP)
			return;
		TN_SPRITE_LOOP = true;
		OnTitanSpriteLoop();
		CallEventDelayed(2.5f, "titan_end_sprite_loop");
	}

	// titan_sprite_loop
	void PlayerClEffectsSpecial_OnTitanSpriteLoop()
	{
		if (!TN_SPRITE_LOOP)
			return;
		CallEventDelayed(0.25f, "titan_sprite_loop");
		ClientEffect("tempent", "sprite", TN_GLOW_SPR, LegacyFunction("getcl", TN_IDX, "attachment1"), "titan_hand_sprite_setup");
		ClientEffect("tempent", "sprite", TN_GLOW_SPR, LegacyFunction("getcl", TN_IDX, "attachment2"), "titan_hand_sprite_setup");
	}

	// titan_end_sprite_loop
	void PlayerClEffectsSpecial_OnTitanEndSpriteLoop()
	{
		TN_SPRITE_LOOP = false;
	}

	// titan_tele_sprite
	void PlayerClEffectsSpecial_OnTitanTeleSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "scale", 3.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", TN_TELE_FRAMES);
	}

	// titan_hand_sprite_setup
	void PlayerClEffectsSpecial_OnTitanHandSpriteSetup()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", 0.5f);
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", 1.0f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// set_view_dist
	void PlayerClEffectsSpecial_OnSetViewDist(string viewDistance = "")
	{
		SetEnvironment("maxviewdist", viewDistance);
	}

	// fx_spark
	// <spark_loc>
	void PlayerClEffectsSpecial_OnFxSpark(Vector3 sparkPosition = Vector3())
	{
		Vector3 sprPos = Vec("SPR_POS");
		ClientEffect("spark", sparkPosition);

		if (!FX_SMITH_EFFECTS)
			return;

		if (Contains(FX_SMITH_TYPE, "dark"))
		{
			sprPos = sparkPosition;
			sprPos.z += 20.0f;
			ClientEffect("tempent", "sprite", FX_SMITH_SPRITE, sprPos, "fx_smith_setup_dark_sprite");
			PlaySound3D("magic/spookie1.wav", 10, sparkPosition);
		}

		if (Contains(FX_SMITH_TYPE, "fire"))
		{
			sprPos = sparkPosition;
			sprPos.z += 5.0f;
			ClientEffect("tempent", "model", "weapons/projectiles.mdl", sprPos, "fx_smith_setup_fire_sprite", "fx_smith_update_fire_sprite");
			PlaySound3D("magic/volcano_start.wav", 10, sparkPosition);
		}

		if (Contains(FX_SMITH_TYPE, "ice"))
		{
			sprPos = sparkPosition;
			sprPos.z += 20.0f;
			ClientEffect("tempent", "sprite", FX_SMITH_ICESPRITE, sprPos, "fx_smith_setup_ice_sprite");
			PlaySound3D("magic/freeze.wav", 10, sparkPosition);
		}
	}

	// fx_smith_effect
	// <type> [dark_sprite] [ice_sprite]
	void PlayerClEffectsSpecial_OnFxSmithEffect(string effectType = "", string darkSprite = "", string iceSprite = "")
	{
		bool exitSub = false;
		if (effectType == "end")
		{
			FX_SMITH_EFFECTS = false;
			exitSub = true;
		}
		if (exitSub)
			return;

		FX_SMITH_EFFECTS = true;
		FX_SMITH_TYPE = effectType;

		// we're passing these sprites via strings to make sure they don't precache when not required
		FX_SMITH_SPRITE = darkSprite;
		FX_SMITH_ICESPRITE = iceSprite;
	}

	// fx_smith_setup_fire_sprite
	void PlayerClEffectsSpecial_OnFxSmithSetupFireSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "body", 51);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 100);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.25f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 1.25f);
	}

	// fx_smith_update_fire_sprite
	void PlayerClEffectsSpecial_OnFxSmithUpdateFireSprite()
	{
		float curSize = Float(Eval("game.tempent.fuser1"));
		curSize -= 0.01f;
		if (!(curSize > 0.0f))
			return;
		ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
		ClientEffect("tempent", "set_current_prop", "scale", curSize);
	}

	// fx_smith_setup_dark_sprite
	void PlayerClEffectsSpecial_OnFxSmithSetupDarkSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "scale", 0.75f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
	}

	// fx_smith_setup_ice_sprite
	void PlayerClEffectsSpecial_OnFxSmithSetupIceSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "scale", 0.25f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// phlames_viewfinder_on
	// ================= Phlames Staff Viewfinder
	// <owner>
	void PlayerClEffectsSpecial_OnPhlamesViewfinderOn(string owner = "")
	{
		PHL_OWNER = owner;
		if (PHL_ON)
			return;
		PHL_ON = true;
		OnPhlamesViewfinderLocator();
	}

	// phlames_viewfinder_off
	void PlayerClEffectsSpecial_OnPhlamesViewfinderOff()
	{
		PHL_ON = false;
	}

	// phlames_viewfinder_locator
	void PlayerClEffectsSpecial_OnPhlamesViewfinderLocator()
	{
		if (!PHL_ON)
			return;
		CallEventDelayed(0.01f, "phlames_viewfinder_locator");

		string ownerView = LegacyFunction("getcl", PHL_OWNER, "viewangles");
		string sealPos = LegacyFunction("getcl", PHL_OWNER, "origin");

		string traceStart = sealPos;
		string traceEnd = Text(Vec(sealPos) + RelativePosition(Vec(ownerView), Vector3(0, 1000, 0)));
		Vector3 traceLine = Vec(LegacyFunction("get_traceline", traceStart, traceEnd, "clworld"));
		traceLine.z = GroundHeight(traceLine);

		PHL_POS = Text(traceLine);

		if (Distance(Vec(sealPos), Vec(PHL_POS)) > 1024.0f)
			PHL_HIDE = true;
		else
			PHL_HIDE = false;

		if (!(GameTime() > PHL_NEXT_SEAL))
			return;
		PHL_NEXT_SEAL = GameTime() + 10.0f;
		ClientEffect("tempent", "model", "weapons/magic/seals.mdl", PHL_POS, "phlames_setup_seal", "phlames_update_seal");
	}

	// phlames_update_seal
	void PlayerClEffectsSpecial_OnPhlamesUpdateSeal()
	{
		if (!PHL_ON)
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(10000, 10000, 10000));

		if (!PHL_ON)
			return;
		ClientEffect("tempent", "set_current_prop", "origin", PHL_POS);

		string ownerOrg = LegacyFunction("getcl", PHL_OWNER, "origin");

		if (PHL_HIDE)
		{
			ClientEffect("tempent", "set_current_prop", "rendermode", "add");
			ClientEffect("tempent", "set_current_prop", "renderamt", 1);
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
			ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		}
	}

	// phlames_setup_seal
	void PlayerClEffectsSpecial_OnPhlamesSetupSeal()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "fade", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "body", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 39);
	}

	// cl_playsound
	void PlayerClEffectsSpecial_OnClPlaysound(string sound = "", float volume = 0.0f, Vector3 location = Vector3())
	{
		PlaySound(0, 10, sound);
	}

	// show_hbar
	// moving health bar system here MAR2012
	// <origin> <frame> <scale> [index]
	void PlayerClEffectsSpecial_OnShowHbar(string origin = "", string frame = "", string scale = "", string index = "")
	{
		bool exitSub = false;
		// dbg show_hbar PARAM1 PARAM2 PARAM3 PARAM4
		if (frame.isEmpty())
		{
			// dbg *** show_hbar got bogus frame ( PARAM2 ) $getcl(HBAR_INDEX,isalive)
			exitSub = true;
		}
		if (exitSub)
			return;

		CL_HBAR_POS = origin;
		CL_HBAR_FRAME = Float(frame);
		CL_HBAR_FRAME -= 22.0f; // wtf is going on that we need this? ><
		CL_HBAR_SCALE = scale;
		CL_HBAR_INDEX = index;
		if (Truthy(LegacyFunction("getcl", CL_HBAR_INDEX, "isplayer")) && !Truthy(Eval("game.localplayer.thirdperson")))
		{
			// hopefully this bit stops player from seeing own sprite when looking up
			if (Eval("game.localplayer.index") == CL_HBAR_INDEX)
				exitSub = true;
		}
		if (exitSub)
			return;

		// dbg *** show_hbar CL_HBAR_FRAME pos PARAM1 frm PARAM2 scl PARAM3 idx PARAM4
		ClientEffect("tempent", "sprite", CL_HBAR_SPRITE, CL_HBAR_POS, "setup_hbar");
	}

	// set_test_beam
	void PlayerClEffectsSpecial_OnSetTestBeam(string sourceEnt = "", string targetEnt = "")
	{
		// cleffect beam_points <startpos> <endpos> <spritename> <life> <width> <amplitude> <brightness> <speed> <framerate> <color>
		// $getcl(game.localplayer.viewmodel.active.id,attachment)
		// local BEAM_START game.localplayer.viewmodel.active.id
		// dbg set_test_beam BEAM_START $getcl(BEAM_START,attachment0)
		// cleffect beam_points $getcl(BEAM_START,attachment1) $getcl(PARAM2,origin) lgtning.spr 50.0 10 0.1 0.3 0.1 30 (2,0,2)
		ClientEffect("beam_ents", sourceEnt, 1, targetEnt, 1, "lgtning.spr", 60.0f, 10, 0.1f, 0.3f, 0.1f, 30, Vector3(2, 1.5f, 0.25f));
	}

	// cl_playsound
	// { game_prerender
	// if TEST_BEAM_ON
	// local BEAM_START game.localplayer.viewmodel.active.id
	// cleffect beam_points $getcl(BEAM_START,attachment1) $getcl(TEST_BEMA_TARG,origin) lgtning.spr 0.001 10 0.1 0.3 0.1 30 (2,0,2)
	// }
	// <sound> <vol> <loc>
	void PlayerClEffectsSpecial_OnClPlaysound_2(string sound = "", float volume = 0.0f, Vector3 location = Vector3())
	{
		PlaySound3D(sound, volume, location);
	}

	// cl_svplaysound
	// <chan> <vol> <sound> <origin>
	void PlayerClEffectsSpecial_OnClSvplaysound(string channel = "", float volume = 0.0f, string sound = "", Vector3 origin = Vector3())
	{
		PlaySound3D(sound, volume, origin, channel);
	}

	// game_cl_playsound
	void PlayerClEffectsSpecial_OnGameClPlaysound(string value = "", float volume = 0.0f, string soundFile = "", Vector3 position = Vector3())
	{
		DebugPrint("*** game_cl_playsound " + soundFile + " " + Text(volume) + " " + Text(position) + " " + value);
		PlaySound3D(soundFile, volume, position, value);
	}

	// lightsys_render_lights
	void PlayerClEffectsSpecial_OnLightsysRenderLights()
	{
		string curLightColor = GetArray("ARRAY_LIGHT_COLOR", Text(loopIteration));
		if (Float(curLightColor) == -1.0f)
			return;

		int curLightOwner = loopIteration;
		string curLightRad = GetArray("ARRAY_LIGHT_RAD", Text(loopIteration));
		string curLightPos = LegacyFunction("getcl", curLightOwner, "origin");
		string curLightId = GetArray("ARRAY_LIGHT_IDLIST", Text(loopIteration));
		ClientEffect("light", curLightId, curLightPos, curLightRad, curLightColor, 1.0f);

		if (GameTime() > NEXT_LIGHT_DEBUG)
			NEXT_LIGHT_DEBUG = GameTime() + 5.0f;
	}

	// cl_light_update
	// <new|remove|update|clear> <owner_index> <color> <rad>
	void PlayerClEffectsSpecial_OnClLightUpdate(string lightAction = "", string ownerIndex = "", string lightColor = "", string lightRadius = "")
	{
		int count;

		string action = lightAction;

		// dbg cl_light_update act L_ACTION own L_OWNER col L_COLOR rad L_RAD
		if (!Truthy(Eval("game.cvar.ms_showotherglow"))) // If player doesnt want to see other player's glows
		{
			if (ownerIndex != Eval("game.localplayer.index")) // Check if this is my glow or not. If it's not my glow, then dont turn it on.
				return;
		}

		string playerIdx = ownerIndex;

		if (action == "new")
		{
			LIGHTSYS_TRACK_LIGHTS = true;
			if (!LIGHTSYS_INITIALIZED)
			{
				count = LIGHTSYS_N_LIGHTS;
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnLightsysMakeLights();
				}
				LIGHTSYS_INITIALIZED = true;
			}

			// dbg cl_light_update initlights for L_PLAYER_IDX fidx $get_arrayfind(ARRAY_LIGHT_COLOR,L_PLAYER_IDX)
			if (Float(GetArray("ARRAY_LIGHT_COLOR", playerIdx)) == -1.0f)
			{
				ClientEffect("light", "new", LegacyFunction("getcl", ownerIndex, "origin"), lightColor, lightRadius, 5.0f);
				string lightId = Eval("game.script.last_light_id");
				ArraySet("ARRAY_LIGHT_IDLIST", playerIdx, lightId);
				ArraySet("ARRAY_LIGHT_COLOR", playerIdx, lightColor);
				ArraySet("ARRAY_LIGHT_RAD", playerIdx, lightRadius);
			}
			else
			{
				// dbg cl_light_update new light for player L_PLAYER_IDX [ L_LIGHT_ID ]
				// check if owner's light already on, just go to update
				action = "update";
			}
		}

		if (action == "update")
		{
			ArraySet("ARRAY_LIGHT_COLOR", playerIdx, lightColor);
			ArraySet("ARRAY_LIGHT_RAD", playerIdx, lightRadius);
			LIGHTSYS_TRACK_LIGHTS = true;
		}

		// dbg cl_light_update update for L_PLAYER_IDX
		if (action == "remove")
		{
			// dbg cl_light_update removing player light L_PLAYER_IDX
			ArraySet("ARRAY_LIGHT_COLOR", playerIdx, -1);
			ArraySet("ARRAY_LIGHT_IDLIST", playerIdx, -1);
			ArraySet("ARRAY_LIGHT_RAD", playerIdx, -1);
			LIGHTSYS_ANY_VALID = false;
			count = LIGHTSYS_N_LIGHTS;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnLightsysCheckValidLights();
			}
			if (!LIGHTSYS_ANY_VALID)
			{
				// dbg cl_light_update no valid lights, stop tracking
				LIGHTSYS_TRACK_LIGHTS = false;
			}
		}

		// remove all lights pending re-sync
		if (action == "clear")
		{
			// dbg cl_light_update clearing all lights
			count = LIGHTSYS_N_LIGHTS;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnLightsysLightRemove();
			}
		}
	}

	// lightsys_dumplights
	void PlayerClEffectsSpecial_OnLightsysDumplights()
	{
		int count = LIGHTSYS_N_LIGHTS;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLightsysDumplightsLoop();
		}
	}

	// lightsys_dumplights_loop
	void PlayerClEffectsSpecial_OnLightsysDumplightsLoop()
	{
		int curIdx = loopIteration;
		DebugPrint(Text(curIdx) + " " + GetArray("ARRAY_LIGHT_IDLIST", Text(curIdx)) + " " + GetArray("ARRAY_LIGHT_COLOR", Text(curIdx)) + " " + GetArray("ARRAY_LIGHT_RAD", Text(curIdx)));
	}

	// lightsys_make_lights
	void PlayerClEffectsSpecial_OnLightsysMakeLights()
	{
		// array.add ARRAY_LIGHT_OWNERLIST $int(game.script.iteration)
		ArrayAdd("ARRAY_LIGHT_IDLIST", -1);
		ArrayAdd("ARRAY_LIGHT_COLOR", -1);
		ArrayAdd("ARRAY_LIGHT_RAD", -1);
	}

	// lightsys_check_valid_lights
	void PlayerClEffectsSpecial_OnLightsysCheckValidLights()
	{
		string curLight = GetArray("ARRAY_LIGHT_COLOR", Text(loopIteration));
		if (curLight == "-1")
			return;
		LIGHTSYS_ANY_VALID = true;
	}

	// lightsys_light_remove
	void PlayerClEffectsSpecial_OnLightsysLightRemove()
	{
		int curIdx = loopIteration;
		ArraySet("ARRAY_LIGHT_COLOR", curIdx, -1);
		ArraySet("ARRAY_LIGHT_RAD", curIdx, 0);
		ArraySet("ARRAY_LIGHT_IDLIST", curIdx, 0);
	}

	// cl_tele1_fx
	// <origin> (from player/externals for teleport-in fx)
	void PlayerClEffectsSpecial_OnClTele1Fx(string origin = "")
	{
		CL_TELE1_ORG = origin;
		PlaySound3D("debris/beamstart1.wav", 10, Vec(CL_TELE1_ORG));
		// setvard CL_TELE1_V_ADJ 0
		OnClTele1FxGo();
		CallEventDelayed(0.2f, "cl_tele1_fx_go");
		CallEventDelayed(0.4f, "cl_tele1_fx_go");

		ClientEffect("light", "new", CL_TELE1_ORG, 128, Vector3(255, 0, 0), 2.0f);
	}

	// cl_tele1_fx_go
	void PlayerClEffectsSpecial_OnClTele1FxGo()
	{
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", CL_TELE1_ORG, "cl_tele1_fx_sprite");
	}

	// cl_tele1_fx_sprite
	void PlayerClEffectsSpecial_OnClTele1FxSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "body", 54);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 0, 255));
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "scale", 0.3f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", -0.3f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
	}

	// cl_metal_cave_light
	// <model_index>
	void PlayerClEffectsSpecial_OnClMetalCaveLight(string modelIndex = "")
	{
		if (SFX_METAL_CAVE_LIGHT_ACTIVE) // already setup
			return;

		SFX_METAL_CAVE_MDL = modelIndex;

		SFX_R_CYCLE = 254.0f;
		SFX_G_CYCLE = 1.0f;
		SFX_B_CYCLE = 254.0f;

		SFX_R_CYCLE_PM = 0.02f;
		SFX_G_CYCLE_PM = -0.02f;
		SFX_B_CYCLE_PM = 0.02f;

		ClientEffect("light", "new", LegacyFunction("getcl", SFX_METAL_CAVE_MDL, "origin"), 768, Vector3(255, 0, 255), 5.0f);
		SFX_METAL_CAVE_LIGHT = Eval("game.script.last_light_id");
		SFX_METAL_CAVE_LIGHT_ACTIVE = true;
	}

	// cl_metal_cave_light_end
	void PlayerClEffectsSpecial_OnClMetalCaveLightEnd()
	{
		SFX_METAL_CAVE_LIGHT_ACTIVE = false;
	}

	// cl_metal_cave_cycle
	void PlayerClEffectsSpecial_OnClMetalCaveCycle()
	{
		float cycle = SFX_R_CYCLE_PM * Random(1, 2);
		SFX_R_CYCLE += cycle;
		if (SFX_R_CYCLE < 0.0f)
		{
			SFX_R_CYCLE_PM *= -1.0f;
			SFX_R_CYCLE = 0.0f;
		}
		if (SFX_R_CYCLE > 255.0f)
		{
			SFX_R_CYCLE_PM *= -1.0f;
			SFX_R_CYCLE = 255.0f;
		}

		cycle = SFX_G_CYCLE_PM * Random(1, 2);
		SFX_G_CYCLE += cycle;
		if (SFX_G_CYCLE < 0.0f)
		{
			SFX_G_CYCLE_PM *= -1.0f;
			SFX_G_CYCLE = 0.0f;
		}
		if (SFX_G_CYCLE > 255.0f)
		{
			SFX_G_CYCLE_PM *= -1.0f;
			SFX_G_CYCLE = 255.0f;
		}

		cycle = SFX_B_CYCLE_PM * Random(1, 2);
		SFX_B_CYCLE += cycle;
		if (SFX_B_CYCLE < 0.0f)
		{
			SFX_B_CYCLE_PM *= -1.0f;
			SFX_B_CYCLE = 0.0f;
		}
		if (SFX_B_CYCLE > 255.0f)
		{
			SFX_B_CYCLE_PM *= -1.0f;
			SFX_B_CYCLE = 255.0f;
		}

		Vector3 color = Vector3(int(SFX_R_CYCLE), int(SFX_G_CYCLE), int(SFX_B_CYCLE));

		// dbg cl_metal_cave_cycle L_COLOR
		ClientEffect("light", SFX_METAL_CAVE_LIGHT, LegacyFunction("getcl", SFX_METAL_CAVE_MDL, "origin"), 768, color, 1.0f);
	}

	// s_test
	// <range> <flags>
	void PlayerClEffectsSpecial_OnSTest(string range = "", string scanFlags = "")
	{
		string scanFlagsValue = "SCAN_FLAGS";
		string plr = Eval("game.localplayer.index");
		string plrOrg = LegacyFunction("getcl", plr, "origin");
		if (!scanFlags.isEmpty())
			scanFlagsValue = scanFlags;

		string scanResult = LegacyFunction("getcl_tsphere", plrOrg, range, scanFlagsValue);
		DebugPrint("s_test " + scanResult);
	}

	// cl_set_height
	void PlayerClEffectsSpecial_OnClSetHeight(float height = 0.0f)
	{
		DebugPrint("cl_set_height " + Text(height));
		SetVar(Eval("game.cleffect.view_ofs.z"), height);
	}

	// ext_sbfollow
	void PlayerClEffectsSpecial_OnExtSbfollow(string viewmodelIndex = "", string attachPoint = "")
	{
		// . clme ext_sbfollow
		string viewmodelIdx = Eval("game.localplayer.viewmodel.active.id");
		string attach = "1";
		if (!viewmodelIndex.isEmpty())
			viewmodelIdx = viewmodelIndex;
		if (!attachPoint.isEmpty())
			attach = attachPoint;
		ClientEffect("beam_follow", viewmodelIdx, attach, "lgtning.spr", 20.0f, 30, Vector3(1, 0, 0), 1);
		DebugPrint("*** ext_sbfollow " + viewmodelIndex + " " + attachPoint + " [ " + Eval("game.script.last_beam_id") + " ]");
		CYCLE_BEAM = Eval("game.script.last_beam_id");
	}

	// ext_sbent
	void PlayerClEffectsSpecial_OnExtSbent(string viewmodelIndex = "", string startAttach = "", string endAttach = "")
	{
		// . clme ext_sbent <ent> <at1> <at2>
		string viewmodelIdx = Eval("game.localplayer.viewmodel.active.id");
		string attach1 = "1";
		string attach2 = "2";
		if (!viewmodelIndex.isEmpty())
			viewmodelIdx = viewmodelIndex;
		if (!startAttach.isEmpty())
			attach1 = startAttach;
		if (!endAttach.isEmpty())
			attach2 = endAttach;
		ClientEffect("beam_ents", viewmodelIdx, attach1, viewmodelIdx, attach2, "lgtning.spr", 20.0f, 5, 1, 0.5f, 100, 30, Vector3(1, 0, 1));
		DebugPrint("*** ext_sbent " + viewmodelIndex + " " + startAttach + " " + endAttach + " [ " + Eval("game.script.last_beam_id") + " ]");
		CYCLE_BEAM = Eval("game.script.last_beam_id");
	}

	// ext_sbents
	void PlayerClEffectsSpecial_OnExtSbents(string startEntity = "", string endEntity = "")
	{
		// . clme ext_sbents <ent> <ent>
		ClientEffect("beam_ents", startEntity, 0, endEntity, 0, "lgtning.spr", 120.0f, 5, 1, 255, 100, 30, Vector3(255, 0, 255));
		DebugPrint("*** ext_sbent " + startEntity + " " + endEntity + " [ " + Eval("game.script.last_beam_id") + " ] [ GAME_BULLSHIT ]");
		CYCLE_BEAM = Eval("game.script.last_beam_id");
	}

	// edit_beam
	// <prop> <value>
	void PlayerClEffectsSpecial_OnEditBeam(string prop = "", string value = "")
	{
		// . clme edit_beam color "(1,0.5,2)"
		// . clme edit_beam brightness 0.3
		ClientEffect("beam_update", CYCLE_BEAM, prop, value);
	}

	// get_beam
	// <prop>
	void PlayerClEffectsSpecial_OnGetBeam(string prop = "")
	{
		DebugPrint("*** beamprop " + prop + " is " + LegacyFunction("getcl_beam", CYCLE_BEAM, prop));
	}

	// clear_beams
	void PlayerClEffectsSpecial_OnClearBeams()
	{
		DebugPrint("*** clear_beams");
		ClientEffect("beam_update", "removeall");
	}

	// change_sky
	// <skyname>
	void PlayerClEffectsSpecial_OnChangeSky(string skyName = "")
	{
		// . clme change_sky ax_darkclouds_
		SetEnvironment("sky.texture", skyName);
	}

	// cl_show_text
	// <text_name>
	void PlayerClEffectsSpecial_OnClShowText()
	{
		LegacyCommand("localmenu.reset");

		SetLocal("reg.local.menu.title", "Test title");
		LegacyCommand("registerlocal.menu");

		SetLocal("reg.local.button.text", "Button1");
		SetLocal("reg.local.button.closeonclick", 0);
		SetLocal("reg.local.button.enabled", 1);
		SetLocal("reg.local.button.docallback", 1);
		SetLocal("reg.local.button.callback", "cb_test1");
		LegacyCommand("registerlocal.button");

		SetLocal("reg.local.button.text", "Button2");
		SetLocal("reg.local.button.closeonclick", 1);
		SetLocal("reg.local.button.enabled", 0);
		SetLocal("reg.local.button.docallback", 0);
		SetLocal("reg.local.button.callback", "cb_test1");
		LegacyCommand("registerlocal.button");

		SetLocal("reg.local.button.text", "Button3");
		SetLocal("reg.local.button.closeonclick", 1);
		SetLocal("reg.local.button.enabled", 1);
		SetLocal("reg.local.button.docallback", 0);
		LegacyCommand("registerlocal.button");

		SetLocal("reg.local.paragraph.source.type", "local");
		SetLocal("reg.local.paragraph.source", "#LOCALPAGE_TEST1");
		LegacyCommand("registerlocal.paragraph");

		ConsoleMessage(ENT_ME, "OPENING");

		LegacyCommand("localmenu.open");
	}

	// cb_test1
	void PlayerClEffectsSpecial_OnCbTest12()
	{
		LegacyCommand("localmenu.close");
	}

	// cb_test2
	void PlayerClEffectsSpecial_OnCbTest22()
	{
	}

	// spawn_corpse
	// <idx> <anim_idx> <renderprops:scale;rendermode;renderamt;bodyidx;skin>
	void PlayerClEffectsSpecial_OnSpawnCorpse(string entityIndex = "", string animIndex = "", string renderProps = "")
	{
		CORPSE_ANG = LegacyFunction("getcl", entityIndex, "angles");

		CORPSE_ANIM_IDX = animIndex;

		CORPSE_SCALE = GetToken(renderProps, 0);
		if (Float(CORPSE_SCALE) == 0.0f)
			CORPSE_SCALE = "1";

		L_INRENDER = Float(GetToken(renderProps, 1));
		CORPSE_RENDERMODE = "normal";
		if (L_INRENDER == 2.0f)
			CORPSE_RENDERMODE = "texture";
		if (L_INRENDER == 5.0f)
			CORPSE_RENDERMODE = "add";

		CORPSE_RENDERAMT = GetToken(renderProps, 2);
		if (Float(CORPSE_RENDERAMT) == 0.0f)
			CORPSE_RENDERAMT = "255";

		CORPSE_BODY_IDX = GetToken(renderProps, 3);
		CORPSE_SKIN = GetToken(renderProps, 4);

		DebugPrint("*** clplayer spawn_corpse " + entityIndex + " " + animIndex + " model: " + LegacyFunction("getcl", entityIndex, "model") + " scale: " + CORPSE_SCALE + " rmode: " + CORPSE_RENDERMODE + " ramt: " + CORPSE_RENDERAMT + " bodyidx: " + CORPSE_BODY_IDX + " origin: " + LegacyFunction("getcl", entityIndex, "origin"));

		ClientEffect("tempent", "model", LegacyFunction("getcl", entityIndex, "model"), LegacyFunction("getcl", entityIndex, "origin"), "setup_corpse");
	}

	// setup_corpse
	void PlayerClEffectsSpecial_OnSetupCorpse()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 20.0f);
		ClientEffect("tempent", "set_current_prop", "scale", CORPSE_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, -50));
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", CORPSE_BODY_IDX);
		ClientEffect("tempent", "set_current_prop", "sequence", CORPSE_ANIM_IDX);
		ClientEffect("tempent", "set_current_prop", "angles", CORPSE_ANG);
		ClientEffect("tempent", "set_current_prop", "rendermode", CORPSE_RENDERMODE);
		ClientEffect("tempent", "set_current_prop", "renderamt", CORPSE_RENDERAMT);
		ClientEffect("tempent", "set_current_prop", "skin", CORPSE_SKIN);
	}

	// cl_array_test
	void PlayerClEffectsSpecial_OnClArrayTest()
	{
		if (!SETUP_TEST_ARRAY)
		{
			ArrayCreate("ARRAY_TEST");
			SETUP_TEST_ARRAY = true;
		}

		ArrayAdd("ARRAY_TEST", "yes");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMirrorLife() {} // MIRROR_LIFE
	void OnSpriteDuration() {} // SPRITE_DURATION
	void OnClMetalCaveCycle() {} // cl_metal_cave_cycle
	void OnClTele1FxGo() {} // cl_tele1_fx_go
	void OnKhDragonDeathLoop() {} // kh_dragon_death_loop
	void OnKhFireBreathLoop() {} // kh_fire_breath_loop
	void OnKhHandSpriteLoop() {} // kh_hand_sprite_loop
	void OnKhMakeRow(string row = "") {} // kh_make_row
	void OnKhMakeRowLoop() {} // kh_make_row_loop
	void OnKhMirrorUpdate(int angleOffset = 0) {} // kh_mirror_update
	void OnKhSpawnFlightSprites() {} // kh_spawn_flight_sprites
	void OnKhZapTargetLoop() {} // kh_zap_target_loop
	void OnLightsysCheckValidLights() {} // lightsys_check_valid_lights
	void OnLightsysDumplightsLoop() {} // lightsys_dumplights_loop
	void OnLightsysLightRemove() {} // lightsys_light_remove
	void OnLightsysMakeLights() {} // lightsys_make_lights
	void OnLightsysRenderLights() {} // lightsys_render_lights
	void OnPhlamesViewfinderLocator() {} // phlames_viewfinder_locator
	void OnTitanSpriteLoop() {} // titan_sprite_loop
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_effects_special"]
shared class PlayerClEffectsSpecialScript : PlayerClEffectsWeatherScript, PlayerClEffectsSpecial, Halos
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerClEffectsSpecial_FirstThink();
	}
}
