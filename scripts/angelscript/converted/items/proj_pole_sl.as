#pragma context server

// Converted from items/proj_pole_sl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_pole_sl"]
class ProjPoleSl : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "73";
	int ARROW_BODY_OFS = 73;
	int ARROW_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.affliction";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_COLLIDE = true;

	// Variables (an unset .script variable reads as its own name)
	string MY_LIGHT_IDX = "MY_LIGHT_IDX";

	// Variables declared by included files, with the value they start with in this script
	ProjPoleSl()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		ARROW_EXPIRE_DELAY = 0;
		SOUND_HITWALL1 = "magic/dburst_sdr_blackout.wav";
		SOUND_HITWALL2 = "magic/dburst_sdr_blackout.wav";
		PROJ_DAMAGE_TYPE = "dark";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 0, 255), 128, 1.5f);
		MY_LIGHT_IDX = LastClientScriptId();
		LegacyCommand("projectiletouch", 0);
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base

		Vector3 myOrg = OriginOf(ENT_ME);
		float myZ = myOrg.z;
		float myGround = GroundHeight(myOrg);
		if (myGround > myZ - 128.0f && myGround < myZ + 128.0f)
		{
			// landed somewhere near the ground, snap to
			myOrg.z = myGround;
		}
		ClientEvent("new", "all", "items/proj_pole_sl_cl", IndexOf(ENT_ME)); // poof effect
		CallExternal(ENT_EXPOWNER, "ext_dburst", myOrg, 96, 0, 0);
		ClientEvent("update", "all", MY_LIGHT_IDX, "remove_light");

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			Vector3 beamStart = OriginOf(ENT_ME);
			string beamEnd = Text(beamStart);
			Vector3 myAng = AnglesOf(ENT_ME);
			myAng.x = -myAng.x;
			beamEnd = Text(Vec(beamEnd) + RelativePosition(myAng, Vector3(0, -128, 0)));
			Effect("beam", "point", "lgtning.spr", 20, beamStart, beamEnd, Vector3(255, 255, 0), 200, 0, 5.0f);
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/affliction_lance");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Shadow Lance");
		SetDescription("You have been afflicted by this lance");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.8f);
		SetGroupable(25);
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
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
