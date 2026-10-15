#pragma context server

// Converted from items/proj_fire_xolt.script by msc_transpiler.
// Thothie - AOE probably not working, AOE names to not match up with proj_base
// - couple other var names not matching up as well :\
// Catabult Ball

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"
#include "converted/items/proj_guided_base.as"

[script "items/proj_fire_xolt"]
class ProjFireXolt : ProjArrowBaseScript, ProjGuidedBase
{
	// Constants
	int ARROW_BODY_OFS = 40;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_STICK_DURATION = 0;
	int PROJ_AOE_RANGE = 64;
	float PROJ_AOE_FALLOFF = 1.0f;
	string SOUND_EXPLODE1 = "weapons/explode3.wav";
	string SOUND_EXPLODE2 = "weapons/explode4.wav";
	string SOUND_EXPLODE3 = "weapons/explode5.wav";

	// Variables declared by included files, with the value they start with in this script
	ProjFireXolt()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "siege";
		PROJ_MOTIONBLUR = false;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjFireXolt_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		AddVelocity(target, RelativeVelocity(Vector3(-50, 300, 120)));
		return result;
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base
		ProjGuidedBase_OnProjectileLanded(); // items/proj_guided_base

		PlayRandomSound(2, 10, SOUND_EXPLODE1, SOUND_EXPLODE2, SOUND_EXPLODE3);
		DeleteMe();
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		// dbg firebolt spawned
		SetName("Fire Bolt");
		SetDescription("A bolt of fire");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
		PlaySound(0, 10, "weapons/rocketfire1.wav");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjFireXolt_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		ProjGuidedBase_OnGameTossprojectile(); // items/proj_guided_base
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		return ProjGuidedBase_DispatchEvent(name, params)
			|| ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
