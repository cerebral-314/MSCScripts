#pragma context server

// Converted from items/swords_poison1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_shortsword.as"

[script "items/swords_poison1"]
class SwordsPoison1 : SwordsShortswordScript
{
	// Variables declared by included files, with the value they start with in this script
	SwordsPoison1()
	{
		BASE_LEVEL_REQ = "6";
	}

	// game_dodamage
	string SwordsPoison1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		int random = RandomInt(1, 100);
		if (!(random > 50))
			return result;
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", RandomInt(3, 6), @EntityOf(ENT_OWNER), Random(1.5f, 2.5f), "swordsmanship");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsShortsword_OnWeaponSpawn(); // items/swords_shortsword

		SetName("Envenomed Shortsword");
		SetDescription("This shortsword is laced with vile poison that oozes along the blade.");
		SetWeight(30);
		SetValue(500);
		SetHudSprite("trade", "shortsword");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsPoison1_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsShortswordScript::DispatchEvent(name, params);
	}
}
