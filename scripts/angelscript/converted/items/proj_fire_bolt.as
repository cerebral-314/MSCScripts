#pragma context server

// Converted from items/proj_fire_bolt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_fire_bolt"]
class ProjFireBolt : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "40";
	int ARROW_BODY_OFS = 40;
	string SOUND_EXPLODE = "weapons/explode3.wav";
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 80;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	string SOUND_LAUNCH = "weapons/rocketfire1.wav";

	// Variables declared by included files, with the value they start with in this script
	ProjFireBolt()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "50";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_dodamage
	// { game_tossprojectile
	// gravity 0
	// }
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjFireBolt_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(myOwner);
		CBaseEntity@ entHit = target;

		if ((ownerIsplayer ? 1 : 0) == 1 && !IsPvp() && IsPlayer(entHit))
			exitSub = true;
		if (exitSub)
			return result;

		if (RelationshipOf(myOwner, @entHit) != "enemy")
			return result;
		if (HealthOf(entHit) < 1000.0f)
			AddVelocity(entHit, RelativeVelocity(Vector3(-10, 400, 30)));
		PlaySound(0, 10, SOUND_EXPLODE);
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Fire Bolt");
		SetDescription("A bolt of fire");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);

		PlaySound(0, 10, SOUND_LAUNCH);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjFireBolt_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
