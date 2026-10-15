#pragma context server

// Converted from monsters/djinn_troll_lesser_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/troll_lobber.as"

[script "monsters/djinn_troll_lesser_fire"]
class DjinnTrollLesserFire : TrollLobberScript
{
	// Constants
	int DMG_AOE = 0;
	float DOT_DMG = 0.0f;
	float DOT_DUR = 5.0f;
	string FX_BURST_SCRIPT = "effects/sfx_fire_burst";
	string EFFECT_DOT = "effects/dot_fire";
	Vector3 ELEMENT_COLOR = Vector3();
	string BURST_ELEMENT = "fire_effect";

	// Variables declared by included files, with the value they start with in this script
	DjinnTrollLesserFire()
	{
		TROLL_EXP = 200;
		PROJ_SCRIPT = "proj_troll_rock_fire";
		TROLL_MODEL = "monsters/troll_fire.mdl";
		TROLL_NAME = "Lesser Fire Djinn";
		ROCK_DAMAGE = "0";
	}

	// game_dodamage
	string DjinnTrollLesserFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (Contains(damageType, "effect"))
			return result;
		if (!hit)
			return result;
		if (RelationshipOf(ENT_ME, @target) != "enemy")
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		ApplyEffect(target, EFFECT_DOT, "DUR_DOT", self, DOT_DMG);
		return result;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 1.5f);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnTrollLesserFire_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(FX_BURST_SCRIPT);
	}

	// ext_proj_landed
	// <origin>
	void OnExtProjLanded(Vector3 origin = Vector3())
	{
		DoDamageEx(origin, 256, DMG_AOE, 0.01f, ENT_ME, ENT_ME, "none", BURST_ELEMENT, "dmgevent:proj");
		ClientEvent("new", "all", FX_BURST_SCRIPT, origin, 256, 1, ELEMENT_COLOR);
	}

	// proj_dodamage
	void OnProjDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(ENT_ME, @target) != "enemy")
			return;
		ApplyEffect(target, EFFECT_DOT, "DUR_DOT", self, DOT_DMG);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/troll_fire.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_proj_landed") { OnExtProjLanded(Vec(Param(params, 0))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "proj_dodamage") { OnProjDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return TrollLobberScript::DispatchEvent(name, params);
	}
}
