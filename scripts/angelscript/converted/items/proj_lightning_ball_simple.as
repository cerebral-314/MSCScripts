#pragma context server

// Converted from items/proj_lightning_ball_simple.script by msc_transpiler.
// magic bolt that varies with size by the energy put into it

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_lightning_ball_simple"]
class ProjLightningBallSimple : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 6;
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string PROJ_ANIM_IDLE = "spin_horizontal_slow";
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 32;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string F_BALL_SIZE = "F_BALL_SIZE";
	string F_BALL_DMG = "F_BALL_DMG";
	string F_BALL_TYPE = "F_BALL_TYPE";
	float SCAN_SIZE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjLightningBallSimple()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "200";
		PROJ_DAMAGE_TYPE = "lightning";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		F_BALL_SIZE = ScriptVarOf(MY_OWNER, "BALL_SIZE");
		F_BALL_DMG = ScriptVarOf(MY_OWNER, "BALL_DMG");
		F_BALL_TYPE = "lightning";
		SCAN_SIZE = 16.0f;
		if (Truthy(OWNER_ISPLAYER))
			SCAN_SIZE = 12.0f;
		SCAN_SIZE *= Float(F_BALL_SIZE);

		if (Float(F_BALL_SIZE) == 0.0f)
			DeleteEntity(ENT_ME);
		if (!(Float(F_BALL_SIZE) > 0.0f))
			return;

		SetModel("weapons/projectiles.mdl");
		float subModel = int(Float(F_BALL_SIZE)) + 12.0f;
		subModel = int(subModel);
		SetModelBody(0, int(subModel));
		SetBoundingBox("animsize");
		PlaySound(0, F_BALL_SIZE, SOUND_SHOOT);
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base

		SetModel("none");

		LegacyCommand("expiretime", 0);
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base

		SetModel("none");
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
		Effect("screenfade", @EntityOf(ENT_LASTSTRUCKBYME), 3, 1, Vector3(255, 255, 255), 255, "fadein");
		LegacyCommand("expiretime", 0);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Manabolt");
		SetDescription("Manabolt");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("none");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		CallEventDelayed(10.0f, "remove_me");
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_hitworld
	void OnGameHitworld()
	{
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
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
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitworld") { OnGameHitworld(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
