#pragma context server

// Converted from items/axes_tl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_td.as"

[script "items/axes_tl"]
class AxesTl : AxesTdScript
{
	// Variables declared by included files, with the value they start with in this script
	AxesTl()
	{
		MELEE_DMG_TYPE = "lightning";
		TOM_SKIN = 2;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string AxesTl_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.lightning"), 2.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		ApplyEffect(target, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage, "axehandling");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesTd_OnWeaponSpawn(); // items/axes_td

		SetName("Lightning Tomahawk");
		SetDescription("A mystic tomahawk of ancient times");
		SetWeight(90);
		SetValue(2500);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "173");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesTl_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesTdScript::DispatchEvent(name, params);
	}
}
