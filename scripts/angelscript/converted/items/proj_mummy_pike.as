#pragma context server

// Converted from items/proj_mummy_pike.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_mummy_pike"]
class ProjMummyPike : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "46";
	int ARROW_BODY_OFS = 46;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 30;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjMummyPike()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE_TYPE = "dark";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "50";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjMummyPike_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(myOwner);
		CBaseEntity@ entHit = target;

		if (ownerIsplayer && !IsPvp() && IsPlayer(entHit))
			exitSub = true;
		if (exitSub)
			return result;

		if (RelationshipOf(myOwner, @entHit) != "enemy")
			return result;

		ApplyEffect(entHit, "effects/debuff_hold", 10.0f);
		CallExternal(myOwner, "ext_projectile_hit");
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Cursed Pike");
		SetDescription("A cursed polearm");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjMummyPike_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
