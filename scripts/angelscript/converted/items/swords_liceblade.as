#pragma context server

// Converted from items/swords_liceblade.script by msc_transpiler.
// Lesser Ice Blade, From Short Sword by Thothie (model pending)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"
#include "converted/items/base_varied_attacks.as"

[script "items/swords_liceblade"]
class SwordsLiceblade : SwordsBaseOnehandedScript, BaseVariedAttacks
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	int MODEL_VIEW_IDX = 1;
	string SOUND_SHOUT = "SOUND_SHOUT";
	int FREEZE_HITS_NEEDED = 10;

	// Variables (an unset .script variable reads as its own name)
	float FREEZE_HITS = 0.0f;
	int SWING_ANIM = 0;

	// Variables declared by included files, with the value they start with in this script
	SwordsLiceblade()
	{
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "48";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 120;
		MELEE_DMG_TYPE = "cold";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		ANIM_PREFIX = "shortsword";
		MELEE_PARRY_CHANCE = "15%";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SwordsLiceblade_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		FREEZE_HITS += 1.0f;

		if (FREEZE_HITS != 10.0f)
			return result;

		CBaseEntity@ enemyHit = target;

		float nmeMaxhp = HealthOf(target);
		if (nmeMaxhp > 500.0f)
			OwnerMessage("This enemy is too strong to be affected by your swords magic!");
		if (!(nmeMaxhp < 500.0f))
			return result;
		ApplyEffect(enemyHit, "effects/dot_cold", 5, @EntityOf(ENT_OWNER), 10, "swordsmanship");
		OwnerMessage("The Ice Blade's magic has frozen your enemy!");
		PlaySound(0, 10, "debris/beamstart14.wav");
		FREEZE_HITS = 1.0f;
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Lesser Ice Blade");
		SetDescription("A shortsword variant of the Ice Blade used by elite Marogar");
		SetWeight(30);
		SetValue(400);
		SetHudSprite("trade", "95");
		FREEZE_HITS = 1.0f;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsLiceblade_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// melee_start
	void OnMeleeStart()
	{
		// local SWING $rand(1,ATTACK_ANIMS)
		// local SWING_ANIM ANIM_ATTACK1
		// if( SWING == 2 ) setvard SWING_ANIM ANIM_ATTACK2
		// else if( SWING == 3 ) setvard SWING_ANIM ANIM_ATTACK3
		// else if( SWING == 4 ) setvard SWING_ANIM ANIM_ATTACK4
		// else if( SWING == 5 ) setvard SWING_ANIM ANIM_ATTACK5
		PlaySound(1, 10, SOUND_SWIPE);

		PlayOwnerAnim("once", "sword_swing"); // global.anim.combatwalk 3
		OnCheckAttackAnim();
		SWING_ANIM = CUR_ATTACK_ANIM;
		PlayItemViewAnim(ENT_ME, SWING_ANIM);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hswordssb.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVariedAttacks_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
