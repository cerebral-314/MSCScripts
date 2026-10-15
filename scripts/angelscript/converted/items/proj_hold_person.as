#pragma context server

// Converted from items/proj_hold_person.script by msc_transpiler.
// Thothie FEB2009_13 - Freezing sphere, now a projectile! :D
// -
// define on user:
// PASS_FREEZE_DMG (can be 0)
// PASS_FREEZE_DUR

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_hold_person"]
class ProjHoldPerson : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 2;
	string MODEL_BODY_OFS = "2";
	string PROJ_ANIM_IDLE = "idle_iceball";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string SOUND_LOOP = "ambience/pulsemachine.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;
	int SCAN_RANGE = 96;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	string HOLD_DURATION = "HOLD_DURATION";
	string HOLD_DMG = "HOLD_DMG";
	CBaseEntity@ MY_BEAM_ID = null;

	// Variables declared by included files, with the value they start with in this script
	ProjHoldPerson()
	{
		MODEL_HANDS = "weapons/projectiles.mdl";
		MODEL_WORLD = "weapons/projectiles.mdl";
		HITWALL_VOL = 2;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "magic";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		HOLD_DURATION = ScriptVarOf(ENT_EXPOWNER, "PROJ_HOLD_DURATION");
		HOLD_DMG = ScriptVarOf(ENT_EXPOWNER, "PROJ_HOLD_DMG");
		if (HOLD_DURATION == "PROJ_HOLD_DURATION")
			HOLD_DURATION = "30.0";
		if (HOLD_DMG == "PROJ_HOLD_DMG")
			HOLD_DMG = "0";
		ServerPlaySound(1, 10, SOUND_LOOP);
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 0, ENT_EXPOWNER, 1, Vector3(255, 255, 255), 200, 100, 10.0f);
		@MY_BEAM_ID = EntityOf(ENT_LASTCREATED);
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		OnRemoveMe();
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall(); // items/proj_arrow_base
		OnRemoveMe();
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_hold", HOLD_DURATION);
		OnRemoveMe();
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Hold Person Spell");
		SetDescription("A paralyzing ball of magic");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 2);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 200);
		SetProp(ENT_ME, "rendercolor", Vector3(255, 128, 0));

		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		Effect("beam", "update", @MY_BEAM_ID, "remove", 0.1f);
		ServerPlaySound(1, 0, SOUND_LOOP);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/pulsemachine.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
