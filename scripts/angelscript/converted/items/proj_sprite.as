#pragma context server

// Converted from items/proj_sprite.script by msc_transpiler.
// Dynamic sprite projectile

#include "runtime/ScriptEntity.as"

[script "items/proj_sprite"]
class ProjSprite : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string CL_ID = "CL_ID";

	// game_dodamage
	string ProjSprite_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		SetOrigin(ENT_ME, end);
		CallExternal(ENT_EXPOWNER, "ext_proj_land", hit, @target, start, end);
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Projectile");
		SetModel("weapons/projectiles.mdl");
		SetDescription("Yeah, that's a projectile");
		SetWeight(0.01f);
		SetValue(0);
		SetGravity(0.01f);
		SetGroupable(25);
		LegacyCommand("useable", 0);

		LegacyCommand("movetype", "projectile");

		SetLocal("reg.proj.dmg", 0);
		SetLocal("reg.proj.dmgtype", 0);
		SetLocal("reg.proj.aoe.range", 0);
		SetLocal("reg.proj.aoe.falloff", 0);
		SetLocal("reg.proj.stick.duration", 0);
		SetLocal("reg.proj.collidehitbox", 0);
		SetLocal("reg.proj.ignorenpc", 0);

		LegacyCommand("registerprojectile");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ClientEvent("new", "all", "items/proj_sprite_cl", IndexOf(ENT_ME), ScriptVarOf(ENT_EXPOWNER, "PROJ_SPRITE"));
		CL_ID = LastClientScriptId();
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		OnProjLanded();
	}

	// hitwall
	void OnHitwall()
	{
		OnProjLanded();
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjSprite_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// proj_landed
	void OnProjLanded()
	{
		ClientEvent("update", "all", CL_ID, "proj_landed");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "proj_landed") { OnProjLanded(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
