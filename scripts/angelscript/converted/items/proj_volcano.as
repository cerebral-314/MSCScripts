#pragma context server

// Converted from items/proj_volcano.script by msc_transpiler.
// Volcano projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ProjVolcano
{
	// Constants
	string MODEL_HANDS = "none";
	string SOUND_HITWALL1 = "none";
	string SOUND_HITWALL2 = "none";
	string MODEL_WORLD = "weapons/projectiles.mdl";
	string PROJ_ANIM_IDLE = "1";
	bool CLFX_ARROW_NOSTICK = true;
	bool PROJ_STICK_ON_NPC = false;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_MOTIONBLUR = false;
	bool PROJ_STICK_ON_WALL_NEW = false;
	string PROJ_DAMAGE = "80";
	string PROJ_DAMAGE_TYPE = "fire";
	int PROJ_AOE_RANGE = 110;
	float PROJ_AOE_FALLOFF = 0.01f;
	string CLFX_ARROW = "1";
	float CLFX_ARROW_UPDATE_RATE = 20.0f;

	// projectile_spawn
	void ProjVolcano_OnProjectileSpawn()
	{
		SetName("Volcanic fireball");
		SetGravity(Random(0.6f, 1));
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string ProjVolcano_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float dmgFire;
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ owner = EntityOf(ENT_EXPOWNER);
		if (IsPlayer(owner))
		{
			// Dot dmg should match dot in items/summon/summon_volcano
			dmgFire = SkillOf(owner, "spellcasting.fire") * 0.5f;
			ApplyEffect(target, "effects/dot_fire", 5, @owner, dmgFire, "spellcasting.fire");
		}
		else
		{
			dmgFire = Float(ScriptVarOf(owner, "DMG_VOLCANO"));
			// local USE_DOT $get(L_OWNER,scriptvar,'DMG_VOLCANO_DOT')
			if (Text(dmgFire) == "DMG_VOLCANO")
				dmgFire = 50.0f;

			// if ( $get(L_TARGET,name) contains Garonhroth ) local L_DMG_FIRE 1000 //more likely to finish Lord BS off with volcano
			ApplyEffect(target, "effects/dot_fire", 5, @owner, dmgFire, "spellcasting.fire");
		}
		return result;
	}

	// update_clfx_projectile
	void ProjVolcano_OnUpdateClfxProjectile()
	{
		OnExtScale(1.3f);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// update_clfx_projectile
	void OnUpdateClfxProjectile()
	{
		ProjBase_OnUpdateClfxProjectile(); // items/proj_base
		ProjVolcano_OnUpdateClfxProjectile();
	}

	void OnProjectileSpawn() { ProjVolcano_OnProjectileSpawn(); } // projectile_spawn
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjVolcano_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// This file's events and timers by their .script names
	bool ProjVolcano_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		if (name == "update_clfx_projectile") { OnUpdateClfxProjectile(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/proj_volcano"]
shared class ProjVolcanoScript : ProjBaseScript, ProjVolcano
{
	// Variables declared by included files, with the value they start with in this script
	ProjVolcanoScript()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_STICK_ON_NPC = false;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "80";
		PROJ_DAMAGE_TYPE = "fire";
		CLFX_ARROW_UPDATE_RATE = 20.0f;
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
		return ProjVolcano_DispatchEvent(name, params)
			|| ProjBaseScript::DispatchEvent(name, params);
	}
}
