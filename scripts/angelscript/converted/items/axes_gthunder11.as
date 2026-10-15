#pragma context server

// Converted from items/axes_gthunder11.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_gthunder11"]
class AxesGthunder11 : AxesBaseTwohandedScript
{
	// Constants
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables declared by included files, with the value they start with in this script
	AxesGthunder11()
	{
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 2;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "124";
		MELEE_DMG_TYPE = "lightning";
		MELEE_ACCURACY = "35%";
		BASE_LEVEL_REQ = "20";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		ANIM_PREFIX = "axe";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 400;
		MELEE_DMG_RANGE = 50;
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string AxesGthunder11_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		// if $rand(1,3) == 1
		float burnDamage = SkillOf(ENT_OWNER, "spellcasting.lightning") + Random(1, 3);
		// divide BURN_DAMAGE 2
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		ApplyEffect(target, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage, "axehandling");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Greater Thunderaxe");
		SetDescription("An axe enchanted with powerful lightning magics");
		SetWeight(110);
		SetValue(3000);
		SetHudSprite("hand", "122");
		SetHudSprite("trade", "122");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesGthunder11_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
