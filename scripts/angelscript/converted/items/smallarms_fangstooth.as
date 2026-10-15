#pragma context server

// Converted from items/smallarms_fangstooth.script by msc_transpiler.
// Dirk

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_fangstooth"]
class SmallarmsFangstooth : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "12";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsFangstooth()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 3;
		ANIM_LIFT1 = 18;
		ANIM_IDLE1 = "19";
		ANIM_WIELD = 20;
		ANIM_UNWIELD = 21;
		ANIM_WIELDEDIDLE1 = 22;
		ANIM_ATTACK1 = "23";
		ANIM_ATTACK2 = "24";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "35";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 100;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "30%";
		MODEL_BODY_OFS = "24";
		ANIM_PREFIX = "thiefdagger";
	}

	// game_dodamage
	string SmallarmsFangstooth_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		int random = RandomInt(0, 99);
		if (!(random < 15))
			return result;
		ApplyEffect(target, "effects/dot_poison", RandomInt(3, 6), @EntityOf(ENT_OWNER), Random(0.5f, 1.5f), "smallarms");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Fang's Tooth");
		SetDescription("Fang's Tooth");
		SetWeight(1);
		SetValue(50);
		SetHudSprite("trade", "171");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsFangstooth_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
