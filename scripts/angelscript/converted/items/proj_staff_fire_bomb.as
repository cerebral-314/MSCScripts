#pragma context server

// Converted from items/proj_staff_fire_bomb.script by msc_transpiler.
// Thothie - Phlame staff fire bomb

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_staff_fire_bomb"]
class ProjStaffFireBomb : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "41";
	string PROJ_ANIM_IDLE = "axis_spin";
	string ITEM_NAME = "firemana";
	bool CLFX_ARROW_NOSTICK = true;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_STICK_ON_WALL_NEW = false;
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 0.01f;
	int ARROW_BODY_OFS = 41;
	string SPRITE_ARROW_TRADE = "silverarrow";

	// Variables declared by included files, with the value they start with in this script
	ProjStaffFireBomb()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_DAMAGE = "100";
		PROJ_STICK_ON_NPC = false;
		PROJ_MOTIONBLUR = false;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		DebugPrint("game_tossprojectile");

		PlayAnim("critical", PROJ_ANIM_IDLE);
		PlaySound(2, 10, "ambience/alienflyby1.wav");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Meteor");
		// weight 		500
		// size 		3
		// value		5
		SetGravity(0.4f);

		// groupable	25
		SetProp(ENT_ME, "scale", 0.5f);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		// splodie
		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		DebugPrint("projectile_landed");

		PlaySound(0, 10, "weapons/mortarhit.wav");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);

		Vector3 splooshPoint = OriginOf(ENT_ME);
		// vectorset SPLOOSH_POINT z $get_ground_height(SPLOOSH_POINT)
		ClientEvent("new", "all", "items/proj_arrow_phx_cl", splooshPoint, 256);

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
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
