#pragma context server

// Converted from items/proj_hit_wall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_hit_wall"]
class ProjHitWall : ProjBaseScript
{
	// Constants
	string PROJ_ANIM_IDLE = "idle";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables (an unset .script variable reads as its own name)
	bool HIT_NPC = false;
	Vector3 START_POS = Vector3();
	Vector3 END_POS = Vector3();
	float DISTANCE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjHitWall()
	{
		MODEL_HANDS = "none";
		PROJ_DAMAGE_TYPE = "none";
		PROJ_DAMAGE = "0";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_dodamage
	string ProjHitWall_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!IsAlive(target))
			return result;
		HIT_NPC = true;
		return result;
	}

	// game_tossprojectile
	// end projectile_spawn
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base

		START_POS = OriginOf(ENT_ME);
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		SetName("Stupid Hack");
		SetWeight(0);
		SetValue(0);
		SetGravity(0);

		HIT_NPC = false;

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", "ITEM_NAME");
		SetHand("any");
	}

	// hit_npc
	void OnHitNpc()
	{
		SetAlive(false);
		HIT_NPC = true;
		DeleteEntity(ENT_ME);
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		if (HIT_NPC)
			return;

		END_POS = OriginOf(ENT_ME);
		DISTANCE = Distance(START_POS, END_POS);
		CallExternal(EntityOf(ENT_EXPOWNER), "hitwall_test", DISTANCE, HIT_NPC);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjHitWall_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hit_npc") { OnHitNpc(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
