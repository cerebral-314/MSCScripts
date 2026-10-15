#pragma context server

// Converted from items/proj_lava_rock.script by msc_transpiler.
// Thothie - Troll Rock from proj_catapult
// - monsters/summon/rock_storm also uses this projectile
// - When Rock Storm becomes a player spell, you'll have to zero the damage on this and
// - create an AOE damage that grabs the XP owner via the scriptvar ROCK_OWNER on the caster

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_lava_rock"]
class ProjLavaRock : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 67;
	string MODEL_BODY_OFS = "67";
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 1;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	string FINAL_OWNER = "FINAL_OWNER";
	float FINAL_DOT = 0.0f;
	bool DID_SPLODIE = false;

	// Variables declared by included files, with the value they start with in this script
	ProjLavaRock()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "fire.wav";
		SOUND_HITWALL2 = "fire.wav";
		PROJ_DAMAGE_TYPE = "siege";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjLavaRock_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		DebugPrint("game_dodamage " + NameOf(target) + " " + NameOf(FINAL_OWNER));

		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");

		if (RelationshipOf(target, FINAL_OWNER) != "enemy")
			return result;
		ApplyEffect(target, "effects/dot_fire", 5.0f, FINAL_OWNER, FINAL_DOT);
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		FINAL_OWNER = ScriptVarOf(ENT_EXPOWNER, "ROCK_OWNER");
		FINAL_DOT = Float(ScriptVarOf(ENT_EXPOWNER, "ROCK_DAMAGE"));
		FINAL_DOT *= 0.25f;
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		OnGoSplodie();
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base
		OnGoSplodie();
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Molten Boulder");
		SetDescription("A giant ball of lava");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.4f);
		SetGroupable(25);

		Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, -1, -1);
	}

	// go_splodie
	void OnGoSplodie()
	{
		if (DID_SPLODIE)
			return;
		DID_SPLODIE = true;
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 100, 5, 3, 500);
		// trail looks best, but gives non-sprite set to glow error
		// effect tempent trail rockgibs.mdl $relpos(0,0,0) $relpos(0,0,10) 10 2 5 10 20
		ClientEvent("new", "all", "effects/sfx_fire_burst", OriginOf(ENT_ME), 200, 1, Vector3(255, 0, 0));

		CallEventDelayed(0.1f, "vanish");
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

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjLavaRock_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "vanish") { OnVanish(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
