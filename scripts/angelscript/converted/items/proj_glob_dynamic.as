#pragma context server

// Converted from items/proj_glob_dynamic.script by msc_transpiler.
// as proj_glob, but lets monster deal the damage, just reporting impact location

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_glob_dynamic"]
class ProjGlobDynamic : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "68";
	string PROJ_ANIM_IDLE = "spin_vertical_fast";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables declared by included files, with the value they start with in this script
	ProjGlobDynamic()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "acid_effect";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		PlayAnim("critical", "spin_vertical_fast");
		ClientEvent("new", "all", "items/proj_slime_jet_cl", IndexOf(ENT_ME), "xfireball3.spr");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Acid Glob");
		SetWeight(500);
		SetValue(0);
		SetGravity(0.3f);
		SetGroupable(25);

		SetProp(ENT_ME, "scale", 0.25f);

		PlayAnim("once", "spin_vertical_fast");

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		Vector3 splooshPoint = OriginOf(ENT_ME);
		ClientEvent("new", "all", "effects/sfx_acid_splash", splooshPoint, 64);
		CallExternal(ENT_EXPOWNER, "ext_glob_landed", splooshPoint);
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
