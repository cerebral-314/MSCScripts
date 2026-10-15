#pragma context server

// Converted from items/proj_acid_bomb.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_acid_bomb"]
class ProjAcidBomb : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "68";
	string PROJ_ANIM_IDLE = "spin_vertical_slow";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables declared by included files, with the value they start with in this script
	ProjAcidBomb()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "acid";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "100";
		PROJ_IGNORENPC = true;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		PlayAnim("critical", "spin_vertical_slow");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Acid Ball");
		SetWeight(500);
		SetValue(5);
		SetGravity(0.4f);
		SetGroupable(25);

		SetProp(ENT_ME, "scale", 0.75f);

		PlayAnim("once", "spin_vertical_slow");

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		// splodie
		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		// playsound 0 10 SOUND_SMOOSH
		Vector3 splooshPoint = OriginOf(ENT_ME);
		// vectorset SPLOOSH_POINT z $get_ground_height(SPLOOSH_POINT)
		ClientEvent("new", "all", "effects/sfx_acid_splash", splooshPoint);

		CallExternal(ENT_EXPOWNER, "ext_acid_bomb", OriginOf(ENT_ME));
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
