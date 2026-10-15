#pragma context server

// Converted from items/proj_catapaultball.script by msc_transpiler.
// Thothie - AOE probably not working, AOE names to not match up with proj_base
// - couple other var names not matching up as well :\
// Catabult Ball

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_catapaultball"]
class ProjCatapaultball : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 4;
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 250;
	float PROJ_AOE_FALLOFF = 0.0f;
	string SMOKE_SPRITE = "bigsmoke.spr";

	// Variables declared by included files, with the value they start with in this script
	ProjCatapaultball()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "siege";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjCatapaultball_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		CallExternal(target, "hit_by_siege");
		return result;
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);
		Effect("tempent", "trail", SMOKE_SPRITE, RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 10)), 10, 2, 2, 10, 20);
		DeleteMe();
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Catapult ball");
		SetDescription("A giant rock");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.6f);
		SetGroupable(25);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjCatapaultball_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("bigsmoke.spr");
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
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
