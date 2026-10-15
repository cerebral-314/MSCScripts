#pragma context server

// Converted from items/proj_fire_bomb.script by msc_transpiler.
// Thothie - Blizzard from Fireball
// - To prevent blizzard storm from crashing the server when it strikes func_breakables
// - Generic_AOE's freeze effect doesnt seem to be working constantly, hence we have this.
// - This projectile does no damage in itself
// - Designate dam via tossprojectile
// - example: tossprojectile view 1000 MY_BASE_DMG 30 proj_generic_aoe $vec(z,x,y)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_fire_bomb"]
class ProjFireBomb : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "41";
	string PROJ_ANIM_IDLE = "axis_spin";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables declared by included files, with the value they start with in this script
	ProjFireBomb()
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
		ServerPlaySound(2, 10, "ambience/alienflyby1.wav");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Meteor");
		SetWeight(500);
		SetValue(5);
		SetGravity(0.4f);
		SetGroupable(25);

		SetProp(ENT_ME, "scale", 0.5f);
		string scaleText = ScriptVarOf(ENT_EXPOWNER, "PROJ_FIRE_BOMB_SCALE");
		int scale = Int(scaleText);
		if (scale > 0)
			SetProp(ENT_ME, "scale", scaleText);

		PlayAnim("once", PROJ_ANIM_IDLE);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		// splodie
		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		PlaySound(0, 10, "weapons/mortarhit.wav");
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
		Precache("ambience/alienflyby1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
