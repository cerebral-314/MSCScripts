#pragma context server

// Converted from items/blunt_darkmaul.script by msc_transpiler.
// Dark Maul, by Thothie - from Granite Maul
// - differences <damage <speed +firedamage

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_maul.as"

[script "items/blunt_darkmaul"]
class BluntDarkmaul : BluntMaulScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntDarkmaul()
	{
		BASE_LEVEL_REQ = "15";
		ANIM_ATTACK3 = "2";
		ANIM_SHEATH = 0;
		MELEE_DMG_TYPE = "dark";
		MODEL_VIEW_IDX = 4;
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_BODY_OFS = "62";
		ANIM_PREFIX = "darkmaul";
		MELEE_DMG = 240;
		MELEE_DMG_RANGE = 150;
		MELEE_ENERGY = 5.0f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ACCURACY = "70%";
		SOUND_HITWALL1 = "debris/metal6.wav";
		SOUND_HITWALL2 = "ambience/steamburst1.wav";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BluntDarkmaul_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, 5) != 1)
			return result;

		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.fire"), 2.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;

		ApplyEffect(target, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), burnDamage, "bluntarms");
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMaul_OnWeaponSpawn(); // items/blunt_maul

		SetName("Dark Maul");
		SetDescription("This maul of scorched metal emits an evil aura");
		SetWeight(150);
		SetValue(1500);
		SetHudSprite("trade", "100");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntDarkmaul_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_2hblunts.mdl");
		Precache("weapons/p_weapons1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntMaulScript::DispatchEvent(name, params);
	}
}
