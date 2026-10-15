#pragma context server

// Converted from items/proj_glob_guided.script by msc_transpiler.
// as proj_glob, but lets monster deal the damage, just reporting impact location

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_glob_guided"]
class ProjGlobGuided : ProjBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "68";
	string PROJ_ANIM_IDLE = "spin_vertical_fast";
	string ITEM_NAME = "firemana";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables (an unset .script variable reads as its own name)
	string MY_CL_ID = "MY_CL_ID";
	string MY_TARG = "MY_TARG";
	float TARG_HALF_HEIGHT = 0.0f;
	bool IS_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ProjGlobGuided()
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
		MY_CL_ID = LastClientScriptId();
		CallEventDelayed(0.1f, "pick_target");
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Acid Glob");
		SetGravity(0);

		SetProp(ENT_ME, "scale", 0.25f);

		PlayAnim("once", "spin_vertical_fast");
	}

	// pick_target
	void OnPickTarget()
	{
		MY_TARG = ScriptVarOf(ENT_EXPOWNER, "GLOB_TARG"); // get target from owner
		if (MY_TARG == "none")
			return;
		if (!IsPlayer(MY_TARG))
			TARG_HALF_HEIGHT = HeightOf(MY_TARG) * 0.5f;
		else
			TARG_HALF_HEIGHT = 0.0f;
		IS_ACTIVE = true;
		OnHomeOnTarget();
		CallEventDelayed(10.0f, "max_chase_time");
	}

	// home_on_target
	void OnHomeOnTarget()
	{
		if (!IS_ACTIVE)
			return;
		if (!IsAlive(MY_TARG))
			return;
		CallEventDelayed(0.25f, "home_on_target");
		Vector3 targOrg = OriginOf(MY_TARG);
		targOrg.z += TARG_HALF_HEIGHT;
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
		angToTarg.x = -angToTarg.x;
		// dbg orient_on_target ANG_TO_TARG
		SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, 300, 0)));
		SetProp(ENT_ME, "movedir", angToTarg);
	}

	// max_chase_time
	void OnMaxChaseTime()
	{
		// maxed out chase time, delete
		OnProjectileLanded();
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		IS_ACTIVE = false;
		Vector3 splooshPoint = OriginOf(ENT_ME);
		ClientEvent("new", "all", "effects/sfx_acid_splash", splooshPoint, 64);
		CallExternal(ENT_EXPOWNER, "ext_glob_landed", splooshPoint);
		ClientEvent("update", "all", MY_CL_ID, "end_fx");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
		DeleteEntity(ENT_ME);
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
		if (name == "home_on_target") { OnHomeOnTarget(); return true; }
		if (name == "max_chase_time") { OnMaxChaseTime(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
