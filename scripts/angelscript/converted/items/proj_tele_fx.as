#pragma context server

// Converted from items/proj_tele_fx.script by msc_transpiler.
// Thothie - Designed to make an npc appear to be teleporting
// no workie :/

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_tele_fx"]
class ProjTeleFx : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 5;
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 1.0f;
	string TRAIL_SPRITE = "char_breath.spr";

	// Variables declared by included files, with the value they start with in this script
	ProjTeleFx()
	{
		MODEL_WORLD = "none";
		SOUND_HITWALL1 = "fire.wav";
		SOUND_HITWALL2 = "fire.wav";
		PROJ_DAMAGE_TYPE = "siege";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjTeleFx_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");

		if (!hit)
			return result;

		CallExternal(target, "hit_by_siege");
		return result;
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		CallEventDelayed(0.1f, "vanish");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Fx");
		SetDescription("A giant rock");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
		SetSolid("none");
		CallEventDelayed(0.1f, "spark_fx");
	}

	// spark_fx
	void OnSparkFx()
	{
		Effect("tempent", "spray", TRAIL_SPRITE, RelativePosition(Vector3(0, 0, 0)), RelativeVelocity(Vector3(0, -30, 0)), 10, 0.5f, 50); // more nifty effects
		CallEventDelayed(0.25f, "spark_fx");
	}

	// vanish
	void OnVanish()
	{
		DeleteMe();
	}

	// hitwall
	void OnHitwall()
	{
		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjTeleFx_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "spark_fx") { OnSparkFx(); return true; }
		if (name == "vanish") { OnVanish(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
