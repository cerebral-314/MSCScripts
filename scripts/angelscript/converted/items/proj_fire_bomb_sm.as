#pragma context server

// Converted from items/proj_fire_bomb_sm.script by msc_transpiler.
// small, wiggly, optionally semi-guided version of proj_fire_bomb with different sfx

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_fire_bomb_sm"]
class ProjFireBombSm : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "41";
	string PROJ_ANIM_IDLE = "axis_spin";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables (an unset .script variable reads as its own name)
	string PROJ_LOOP_SOUND = "PROJ_LOOP_SOUND";
	bool IN_FLIGHT = false;
	string PROJ_TARGET = "PROJ_TARGET";
	int WIGGLE_DIR = 0;
	float WIGGLE_COUNT = 0.0f;
	float TARG_HALF_HEIGHT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjFireBombSm()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "100";
		PROJ_IGNORENPC = true;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		string scaleText = ScriptVarOf(ENT_EXPOWNER, "PROJ_FIRE_BOMB_SCALE");
		int scale = Int(scaleText);
		if (scale > 0)
			SetProp(ENT_ME, "scale", scaleText);

		PlayAnim("critical", PROJ_ANIM_IDLE);
		PROJ_LOOP_SOUND = ScriptVarOf(ENT_EXPOWNER, "PROJ_LOOP_SOUND");
		if (PROJ_LOOP_SOUND == "PROJ_LOOP_SOUND")
			PROJ_LOOP_SOUND = "ambience/alienflyby1.wav";
		ServerPlaySound(2, 10, PROJ_LOOP_SOUND); // %% replace (snakish)
		IN_FLIGHT = true;

		PROJ_TARGET = ScriptVarOf(ENT_EXPOWNER, "PROJ_TARGET");
		WIGGLE_DIR = 1;
		WIGGLE_COUNT = 0.0f;
		if (!IsPlayer(PROJ_TARGET))
			TARG_HALF_HEIGHT = HeightOf(PROJ_TARGET) * 0.5f;
		else
			TARG_HALF_HEIGHT = 0.0f;
		CallEventDelayed(0.1f, "wiggle_loop");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Meteor");
		SetWeight(500);
		SetValue(5);
		SetGravity(0);
		SetGroupable(25);

		SetProp(ENT_ME, "scale", 0.1f);
		string scaleText = ScriptVarOf(ENT_EXPOWNER, "PROJ_FIRE_BOMB_SCALE");
		int scale = Int(scaleText);
		if (scale > 0)
			SetProp(ENT_ME, "scale", scaleText);

		PlayAnim("once", PROJ_ANIM_IDLE);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// wiggle_loop
	void OnWiggleLoop()
	{
		if (!IN_FLIGHT)
			return;
		CallEventDelayed(0.1f, "wiggle_loop");
		if (IsAlive(PROJ_TARGET))
		{
			Vector3 targOrg = OriginOf(PROJ_TARGET);
			targOrg.z = GroundHeight(targOrg);
			Vector3 myOrg = OriginOf(ENT_ME);
			Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
			angToTarg.x = -angToTarg.x;
			// dbg orient_on_target ANG_TO_TARG
			SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, 300, 0)));
			SetProp(ENT_ME, "movedir", angToTarg);
		}

		Vector3 myAng = Vec(GetProp(ENT_ME, "movedir"));
		myAng.y += WIGGLE_DIR;
		WIGGLE_COUNT += WIGGLE_DIR;
		if (WIGGLE_COUNT > 20.0f)
			WIGGLE_DIR = -1;
		if (WIGGLE_COUNT < -20.0f)
			WIGGLE_DIR = 1;

		SetProp(ENT_ME, "movedir", WIGGLE_DIR);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		// splodie
		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		IN_FLIGHT = false;

		PlaySound(0, 10, "ambience/steamburst1.wav");
		ServerPlaySound(2, 0, PROJ_LOOP_SOUND);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);

		Vector3 splooshPoint = OriginOf(ENT_ME);
		// vectorset SPLOOSH_POINT z $get_ground_height(SPLOOSH_POINT)
		string aoeText = ScriptVarOf(ENT_EXPOWNER, "PROJ_FIRE_BOMB_AOE");
		int aoe = Int(aoeText);
		if (aoe == 0)
		{
			aoe = 256;
			aoeText = Text(aoe);
		}

		ClientEvent("new", "all", "items/proj_arrow_phx_cl", splooshPoint, aoeText);

		CallExternal(ENT_EXPOWNER, "ext_fire_bomb", OriginOf(ENT_ME));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		if (name == "wiggle_loop") { OnWiggleLoop(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
