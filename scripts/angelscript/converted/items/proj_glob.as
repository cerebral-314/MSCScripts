#pragma context server

// Converted from items/proj_glob.script by msc_transpiler.
// scriptvars:
// GLOB_EFFECT_TYPE
// GLOB_EFFECT_DOT
// GLOB_EFFECT_DUR

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_glob"]
class ProjGlob : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "68";
	string PROJ_ANIM_IDLE = "spin_vertical_fast";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 64;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables (an unset .script variable reads as its own name)
	string EFFECT_TYPE = "EFFECT_TYPE";
	string EFFECT_DUR = "EFFECT_DUR";
	string EFFECT_DOT = "EFFECT_DOT";

	// Variables declared by included files, with the value they start with in this script
	ProjGlob()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "acid_effect";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "100";
	}

	// game_dodamage
	string ProjGlob_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		DebugPrint("game_dodamage " + EFFECT_TYPE + " " + Text(hit) + " " + NameOf(target) + " " + RelationshipOf(ENT_EXPOWNER, @target));
		if (!hit)
			return result;
		if (RelationshipOf(ENT_EXPOWNER, @target) != "enemy")
			return result;
		ApplyEffect(target, EFFECT_TYPE, EFFECT_DUR, @EntityOf(ENT_EXPOWNER), EFFECT_DOT, "none");
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		PlayAnim("critical", "spin_vertical_fast");
		ClientEvent("new", "all", "items/proj_slime_jet_cl", IndexOf(ENT_ME), "xfireball3.spr");

		EFFECT_TYPE = ScriptVarOf(ENT_EXPOWNER, "GLOB_EFFECT_TYPE");
		EFFECT_DUR = ScriptVarOf(ENT_EXPOWNER, "GLOB_EFFECT_DUR");
		EFFECT_DOT = ScriptVarOf(ENT_EXPOWNER, "GLOB_EFFECT_DOT");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Acid Glob");
		SetWeight(500);
		SetValue(0);
		SetGravity(0.4f);
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
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjGlob_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
