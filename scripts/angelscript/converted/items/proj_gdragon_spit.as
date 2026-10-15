#pragma context server

// Converted from items/proj_gdragon_spit.script by msc_transpiler.
// scriptvars:
// - splits into more globs on death
// - (maybe, we can't use an external, as tossprojectile locations are relative, hrmmm...)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_gdragon_spit"]
class ProjGdragonSpit : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "68";
	string PROJ_ANIM_IDLE = "spin_vertical_fast";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 256;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_DAMAGE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjGdragonSpit()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "acid_effect";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "100";
		PROJ_IGNORENPC = true;
	}

	// game_touch
	string ProjGdragonSpit_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg game_touch $get(PARAM1,name)
		if (!(GameTime() > NEXT_DAMAGE))
			return result;
		NEXT_DAMAGE = GameTime() + 0.2f;
		// xdodamage PARAM1 direct DMG_AMT 100% ent_expowner ent_expowner USE_SKILL DMG_TYPE
		CallExternal(ENT_EXPOWNER, "ext_proj_touch", @other);
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		LegacyCommand("projectiletouch", 1);

		PlayAnim("critical", "spin_vertical_fast");
		ClientEvent("new", "all", "items/proj_slime_jet_cl", IndexOf(ENT_ME), "xfireball3.spr", 5.0f, 3.0f);
		ServerPlaySound(2, 10, "ambience/alienflyby1.wav");
	}

	// game_touch
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		result = AppendResult(result, ProjBase_OnGameTouch(other, hpRange, effectDamage));
		result = AppendResult(result, ProjGdragonSpit_OnGameTouch(other, hpRange, effectDamage));
		return result;
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Acid Glob");
		SetWeight(500);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);

		// setprop ent_me scale 0.25
		PlayAnim("once", "spin_vertical_fast");

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		Vector3 splooshPoint = OriginOf(ENT_ME);
		ClientEvent("new", "all", "effects/sfx_acid_splash", splooshPoint, 128);
		CallExternal(ENT_EXPOWNER, "ext_proj_landed", splooshPoint);
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
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
