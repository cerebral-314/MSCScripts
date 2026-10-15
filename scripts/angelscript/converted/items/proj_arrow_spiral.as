#pragma context server

// Converted from items/proj_arrow_spiral.script by msc_transpiler.
// Spiral arrow - does damage as it flies

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_spiral"]
class ProjArrowSpiral : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 1;
	string PROJ_ANIM_IDLE = "idle_iceball";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string MODEL_BODY_OFS = "1";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;
	int SCAN_RANGE = 96;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	string DMG_TYPE = "DMG_TYPE";
	float DMG_AMT = 0.0f;
	string CL_SPRITE_FILE = "CL_SPRITE_FILE";
	string CL_SPRITE_FRAMES = "CL_SPRITE_FRAMES";
	string CL_SPRITE_SCALE = "CL_SPRITE_SCALE";
	string CL_SPRITE_COLOR = "CL_SPRITE_COLOR";
	string CL_GLOW_COLOR = "CL_GLOW_COLOR";
	string USE_SKILL = "USE_SKILL";
	bool IS_ACTIVE = false;
	string MY_CL_IDX = "MY_CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowSpiral()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		HITWALL_VOL = 2;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_IGNORENPC = true;
	}

	// game_projectile_hitwall
	void ProjArrowSpiral_OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base

		CallEventDelayed(10.0f, "remove_me"); // max dist

		DMG_TYPE = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_DMG_TYPE");
		DMG_AMT = Float(ScriptVarOf(ENT_EXPOWNER, "SPIRAL_DMG"));
		CL_SPRITE_FILE = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_SPIRTE_FILE");
		CL_SPRITE_FRAMES = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_SPRITE_FRAMES");
		CL_SPRITE_SCALE = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_SPRITE_SCALE");
		CL_SPRITE_COLOR = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_SPRITE_COLOR");
		CL_GLOW_COLOR = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_GLOW_COLOR");
		if (!IsPlayer(ENT_EXPOWNER))
		{
			USE_SKILL = "none";
		}
		else
		{
			// get skill from active weapon or player external
			USE_SKILL = ScriptVarOf(ENT_EXPOWNER, "SPIRAL_SKILL");
		}

		IS_ACTIVE = true;

		ClientEvent("new", "all", "items/proj_arrow_spiral_cl", IndexOf(ENT_ME), CL_SPRITE_FILE, CL_SPRITE_FRAMES, CL_SPRITE_SCALE, CL_SPRITE_COLOR, CL_GLOW_COLOR);
		MY_CL_IDX = LastClientScriptId();

		CallEventDelayed(0.01f, "damage_area");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Freezing Sphere");
		SetDescription("A large ball of freezing magiks");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renaderamt", 0);

		ServerPlaySound(1, 10, "ambience/alien_hollow.wav");

		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		OnRemoveMe();
	}

	// damage_area
	void OnDamageArea()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "damage_area");
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(OriginOf(ENT_ME), 128, DMG_AMT, 0, ENT_EXPOWNER, ENT_EXPOWNER, USE_SKILL, DMG_TYPE, "dmgevent:spiral");
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		OnRemoveMe();
	}

	// remove_me
	// { [server] scan_targets
	// if IS_ACTIVE
	// callevent 0.2 scan_targets
	// setvard TARGET_LIST $get_tsphere(any,SCAN_RANGE)
	// if TARGET_LIST isnot 'none'
	// local N_TARGETS $get_token_amt(TARGET_LIST)
	// if $get_token_amt(MY_ORG) > 0
	// if N_TARGETS > 0
	// calleventloop N_TARGETS affect_targets
	// }
	// { [server] affect_targets
	// local CUR_TARGET $get_token(TARGET_LIST,game.script.iteration)
	// if $get(CUR_TARGET,relationship,ent_expowner) equals enemy
	// if !$get(CUR_TARGET,scriptvar,'I_R_FROZEN')
	// applyeffect CUR_TARGET effects/dot_cold_freeze FREEZE_DUR $get(ent_expowner,id) FREEZE_DMG
	// }
	void OnRemoveMe(string caller = "")
	{
		if (!IsPlayer(ENT_EXPOWNER)) // tell monster his ball popped
			CallExternal(ENT_EXPOWNER, "ext_spiral_done");
		ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/alien_hollow.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "damage_area") { OnDamageArea(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
