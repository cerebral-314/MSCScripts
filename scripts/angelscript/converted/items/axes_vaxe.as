#pragma context server

// Converted from items/axes_vaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_greataxe.as"
#include "converted/items/base_vampire.as"

[script "items/axes_vaxe"]
class AxesVaxe : AxesGreataxeScript, BaseVampire
{
	// Variables declared by included files, with the value they start with in this script
	AxesVaxe()
	{
		MODEL_VIEW_IDX = 3;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "118";
		MELEE_DMG = 280;
		MELEE_DMG_RANGE = 100;
		MELEE_ACCURACY = "30%";
	}

	// game_dodamage
	string AxesVaxe_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// would use game_damaged_other, but doesnt return proper when used in weapons
		if (!hit)
			return result;

		float healAmt = Float(ScriptVarOf(ENT_LASTSTRUCKBYME, "LAST_STRUCK_FOR"));
		healAmt = Divide(healAmt, 3.0f);

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(healAmt));
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesGreataxe_OnWeaponSpawn(); // items/axes_greataxe

		SetName("Blood Axe");
		SetDescription("A sinister breed of axe forged with the blood of vampires and demons");
		SetWeight(90);
		SetValue(2000);
		SetHudSprite("hand", "120");
		SetHudSprite("trade", "120");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesVaxe_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVampire_DispatchEvent(name, params)
			|| AxesGreataxeScript::DispatchEvent(name, params);
	}
}
