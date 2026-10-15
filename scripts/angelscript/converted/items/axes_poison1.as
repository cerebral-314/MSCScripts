#pragma context server

// Converted from items/axes_poison1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_battleaxe.as"

[script "items/axes_poison1"]
class AxesPoison1 : AxesBattleaxeScript
{
	// game_dodamage
	string AxesPoison1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		int rand = RandomInt(0, 1);
		if (rand == 0)
			return result;
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", RandomInt(6, 12), @EntityOf(ENT_OWNER), Random(3.5f, 5.5f), "axehandling");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesBattleaxe_OnWeaponSpawn(); // items/axes_battleaxe

		SetName("Envenomed Battleaxe");
		SetDescription("This battleaxe has been laced with a fast acting poison");
		SetWeight(80);
		SetValue(500);
		SetHudSprite("hand", "battleaxe");
		SetHudSprite("trade", "battleaxe");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesPoison1_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBattleaxeScript::DispatchEvent(name, params);
	}
}
