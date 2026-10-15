#pragma context server

// Converted from items/proj_troll_rock_fire.script by msc_transpiler.
// Thothie - Troll Rock from proj_catapult
// - monsters/summon/rock_storm also uses this projectile
// - When Rock Storm becomes a player spell, you'll have to zero the damage on this and
// - create an AOE damage that grabs the XP owner via the scriptvar ROCK_OWNER on the caster

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_troll_rock_fire"]
class ProjTrollRockFire : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 67;
	string MODEL_BODY_OFS = "67";
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 1.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjTrollRockFire()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "fire.wav";
		SOUND_HITWALL2 = "fire.wav";
		PROJ_DAMAGE_TYPE = "siege";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjTrollRockFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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

		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);
		// trail looks best, but gives non-sprite set to glow error
		// effect tempent trail rockgibs.mdl $relpos(0,0,0) $relpos(0,0,10) 10 2 5 10 20
		CallExternal(ENT_EXPOWNER, "ext_proj_landed", OriginOf(ENT_ME));
		CallEventDelayed(0.1f, "vanish");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Flaming Boulder");
		SetDescription("A giant flaming rock");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.4f);
		SetGroupable(25);

		SetProp(ENT_ME, "scale", 0.5f);
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

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjTrollRockFire_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
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
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "vanish") { OnVanish(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
