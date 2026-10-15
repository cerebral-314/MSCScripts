#pragma context server

// Converted from items/proj_elemental_guided.script by msc_transpiler.
// guided dynamic elemental cloud o sprites
// requires set on creator:
// setvard PROJ_ELEMENT_TYPE <fire|cold|lightning|poison>
// setvard PROJ_ELEMENT_TARGET <target>
// the following sounds must be fake pre-cached:
// magic/sps_fogfire.wav
// magic/cold_breath.wav
// magic/bolt_loop.wav
// magic/flame_loop.wav
// the following sprite must be fake pre-cached:
// 3dmflagry.spr
// ^ Though we should really replace 3dmflaorg.spr with that, and tweak all the scripts that use it
// (But by the gods, that's a lotta scripts)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_elemental_guided"]
class ProjElementalGuided : ProjArrowBaseScript
{
	// Constants
	int PROJ_AOE_RANGE = 128;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;

	// Variables (an unset .script variable reads as its own name)
	float FWD_SPEED = 200.0f;
	float MAX_DURATION = 10.0f;
	int GAME_PVP = 0;
	string ELEMENT_TYPE = "ELEMENT_TYPE";
	string NPCATK_TARGET = "NPCATK_TARGET";
	bool TARG_ISPLAYER = false;
	int SOUND_VOL = 0;
	string CLOUD_SPRITE = "CLOUD_SPRITE";
	float FREQ_UPDATE = 0.0f;
	string CL_SCRIPT = "CL_SCRIPT";
	Vector3 CL_COLOR = Vector3();
	string SOUND_LOOP = "SOUND_LOOP";
	string SOUND_EXPLODE = "SOUND_EXPLODE";
	bool IS_ACTIVE = false;
	bool ACQUIRE_MODE = false;
	string CL_IDX = "CL_IDX";
	int DRIFT_DIR = 0;
	bool DID_LAND = false;

	// Variables declared by included files, with the value they start with in this script
	ProjElementalGuided()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE = "0";
		PROJ_MOTIONBLUR = false;
	}

	// unnamed block (first think)
	void ProjElementalGuided_FirstThink()
	{
		FWD_SPEED = 200.0f;

		MAX_DURATION = 10.0f;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		DebugPrint("game_tossprojectile");
		GAME_PVP = (IsPvp() ? 1 : 0);
		ELEMENT_TYPE = ScriptVarOf(ENT_EXPOWNER, "PROJ_ELEMENT_TYPE");
		NPCATK_TARGET = ScriptVarOf(ENT_EXPOWNER, "PROJ_ELEMENT_TARGET");

		string altSpeedText = ScriptVarOf(ENT_EXPOWNER, "PROJ_ELEMENT_SPEED");
		int altSpeed = Int(altSpeedText);
		if (altSpeed > 0)
			FWD_SPEED = altSpeed;

		string altDurationText = ScriptVarOf(ENT_EXPOWNER, "PROJ_ELEMENT_MAX_DURATION");
		int altDuration = Int(altDurationText);
		if (altDuration > 0)
			MAX_DURATION = altDuration;

		CallEventDelayed(MAX_DURATION, "end_projectile"); // max duration

		TARG_ISPLAYER = IsPlayer(NPCATK_TARGET);

		SOUND_VOL = 5;

		CLOUD_SPRITE = "3dmflagry.spr"; // so we don't pre-cache without unnecesarily

		FREQ_UPDATE = 0.5f;
		CL_SCRIPT = "items/proj_elemental_cl";

		if (ELEMENT_TYPE == "fire")
		{
			CL_COLOR = Vector3(255, 64, 0);
			SOUND_LOOP = "magic/sps_fogfire.wav";
			SOUND_EXPLODE = "weapons/explode3.wav";
		}
		else if (ELEMENT_TYPE == "fire_jet")
		{
			CL_COLOR = Vector3(255, 128, 64);
			SOUND_LOOP = "magic/sps_fogfire.wav";
			SOUND_EXPLODE = "weapons/explode3.wav";
			CLOUD_SPRITE = "xfireball3.spr";
			FREQ_UPDATE = 1.0f;
			CL_SCRIPT = "items/proj_flamejet_guided_cl";
		}
		else if (ELEMENT_TYPE == "cold")
		{
			CL_COLOR = Vector3(128, 128, 255);
			SOUND_LOOP = "magic/cold_breath.wav";
			SOUND_EXPLODE = "magic/freeze.wav";
		}
		else if (ELEMENT_TYPE == "lightning")
		{
			CL_COLOR = Vector3(255, 255, 0);
			SOUND_LOOP = "magic/bolt_loop.wav";
			SOUND_EXPLODE = "magic/lightning_strike2.wav";
			SOUND_VOL = 5;
		}
		else if (ELEMENT_TYPE == "poison")
		{
			CL_COLOR = Vector3(0, 255, 0);
			SOUND_LOOP = "magic/flame_loop.wav";
			SOUND_EXPLODE = "ambience/steamburst1.wav";
			SOUND_VOL = 5;
		}

		IS_ACTIVE = true;

		ACQUIRE_MODE = true; // toggles 1/0 (target/drift) each cycle

		ServerPlaySound(2, SOUND_VOL, SOUND_LOOP);

		CallEventDelayed(0.05f, "cl_start");
		CallEventDelayed(0.1f, "projectile_loop");
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		DID_LAND = true;
		OnEndProjectile();
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Elemental Cloud");
		SetDescription("This may explode");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// cl_start
	void OnClStart()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), AnglesOf(ENT_ME), VelocityOf(ENT_ME), CL_COLOR, MAX_DURATION, CLOUD_SPRITE);
		CL_IDX = LastClientScriptId();
	}

	// projectile_loop
	void OnProjectileLoop()
	{
		int hofs = 0;
		string targOrg;
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(FREQ_UPDATE, "projectile_loop");

		if (!IsAlive(NPCATK_TARGET))
			ACQUIRE_MODE = false;

		Vector3 myOrg = OriginOf(ENT_ME);

		if (!IsAlive(NPCATK_TARGET))
		{
			if (DRIFT_DIR == 0)
			{
				hofs = -50;
				DRIFT_DIR = 1;
			}
			else
			{
				hofs = 50;
				DRIFT_DIR = 0;
			}
			targOrg = Text(myOrg);
			Vector3 myAng = AnglesOf(ENT_ME);
			targOrg = Text(Vec(targOrg) + RelativePosition(myAng, Vector3(DRIFT_DIR, FWD_SPEED, 0)));
		}
		else
		{
			targOrg = Text(OriginOf(NPCATK_TARGET));
			if (!TARG_ISPLAYER)
				targOrg = Text(Vec(targOrg) + Vector3(0.0f, 0.0f, 32.0f));
		}

		Vector3 angToTarg = Angles3DTo(myOrg, Vec(targOrg));
		angToTarg.x = -angToTarg.x;
		SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, FWD_SPEED, 0)));
		SetProp(ENT_ME, "movedir", angToTarg);

		ClientEvent("update", "all", CL_IDX, "sv_update_vel", AnglesOf(ENT_ME), VelocityOf(ENT_ME), OriginOf(ENT_ME));
	}

	// end_projectile
	void OnEndProjectile()
	{
		IS_ACTIVE = false;
		ServerPlaySound(2, 0, SOUND_LOOP);
		// callexternal ent_expowner ext_arrow_hit $get(ent_me,origin)
		ClientEvent("update", "all", CL_IDX, "proj_explode");
		PlaySound(0, 10, SOUND_EXPLODE);
		CallExternal(ENT_EXPOWNER, "ext_proj_elemental_hit", OriginOf(ENT_ME), ELEMENT_TYPE);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqUpdate() {} // FREQ_UPDATE
	void OnMaxDuration() {} // MAX_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjElementalGuided_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "cl_start") { OnClStart(); return true; }
		if (name == "end_projectile") { OnEndProjectile(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "projectile_loop") { OnProjectileLoop(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
