#pragma context server

// Converted from items/swords_base_twohanded.script by msc_transpiler.
// One handed sword

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SwordsBaseTwohanded
{
	// Constants
	bool IS_TWO_HANDED_SWORD = true;
	bool NO_IDLE = false;
	string PLAYERANIM_AIM = "sword_idle";
	string PLAYERANIM_SWING = "sword_swing";
	string SOUND_PARRY = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	float FREQ_MANUAL_PARRY = 2.0f;
	string ANIM_PARRY = "4";
	int ANIM_UNPARRY = 5;
	float SWORD_MANUAL_PARRY_RATIO = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	bool SWORD_CAN_PARRY = false;
	bool IS_DEPLOYED = false;
	float NEXT_MANUAL_PARRY = 0.0f;
	bool SWORD_MANUAL_PARRY_ON = false;

	// weapon_spawn
	void SwordsBaseTwohanded_OnWeaponSpawn()
	{
		SetHand("both");
	}

	// game_deploy
	void SwordsBaseTwohanded_OnGameDeploy()
	{
		SWORD_CAN_PARRY = true;
		IS_DEPLOYED = true;
	}

	// bweapon_effect_remove
	void SwordsBaseTwohanded_OnBweaponEffectRemove(string reason = "")
	{
		SWORD_CAN_PARRY = false;
		IS_DEPLOYED = false;
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string SwordsBaseTwohanded_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool exitSub = false;
		float dmgTaken = 0.0f;
		string result = "";

		// dbg dply IS_DEPLOYED pry SWORD_CAN_PARRY man SWORD_MANUAL_PARRY_ON
		if (!IS_DEPLOYED)
			return result;

		if (!SWORD_CAN_PARRY)
			return result;

		// if MELEE_NEW_PARRY_CHANCE isnot 'MELEE_NEW_PARRY_CHANCE'
		if (Contains(damageType, "effect"))
			exitSub = true;
		if (Contains(damageType, "target"))
			exitSub = true;
		if (Contains(damageType, "magic"))
			exitSub = true;
		if (exitSub)
			return result;

		Vector3 pos = OriginOf(ENT_OWNER);
		Vector3 mypos = OriginOf(ENT_OWNER);
		Vector3 myang = AnglesOf(ENT_OWNER);
		Vector3 attpos = OriginOf(attacker);

		if (!WithinCone2D(attpos, mypos, myang, 100)) // Attack must come from in front of player
			return result;

		int parryChance = Int(GetVar("MELEE_NEW_PARRY_CHANCE"));

		if (!SWORD_MANUAL_PARRY_ON)
		{
			if (Truthy(GetVar("PARRY_ON")))
				parryChance = 100;
			if (RandomInt(1, 100) <= parryChance)
			{
				dmgTaken = damage;
				PlaySound(2, 5, SOUND_PARRY);
				OwnerMessage("Sword parried! ( " + Text(dmgTaken) + " hp )");
				SetDamageInfo("hit", 0);
				SetDamageInfo("dmg", 0);
				CallEventDelayed(0.1f, "parryanim");
			}
		}
		else
		{
			dmgTaken = damage;
			float dmgBlocked = damage;
			dmgTaken *= SWORD_MANUAL_PARRY_RATIO;
			dmgBlocked -= dmgTaken;
			PlaySound(2, 5, SOUND_PARRY);
			OwnerMessage("Sword blocked " + Text(dmgBlocked) + " hp");
			SetDamageInfo("dmg", dmgTaken);
			result = AppendResult(result, Text(SWORD_MANUAL_PARRY_RATIO));
		}
		return result;
	}

	// game_parry
	void SwordsBaseTwohanded_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		// dbg game_parry triggered
		CallEventDelayed(0.1f, "play_parry");
	}

	// play_parry
	void SwordsBaseTwohanded_OnPlayParry()
	{
		PlayViewAnim(Int(GetVar("ANIM_PARRY1")));
		PlaySound(0, 10, SOUND_PARRY);
		if (!(RangeTo(ENT_LASTSTRUCK) < Float(MELEE_RANGE)))
			return;
		float riposteDamage = SkillOf(ENT_OWNER, "parry");
		OwnerMessage("You ripost\xEF\xBF\xBD the attack! ( " + Text(riposteDamage) + " )");
		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		// applyeffect ent_laststruck effects/generic_damage RIPOSTE_DAMAGE L_MY_OWNER
		DoDamageEx(@EntityOf(ENT_LASTSTRUCK), "direct", riposteDamage, "100%", @myOwner, @myOwner, MELEE_STAT, MELEE_DMG_TYPE);
	}

	// melee_end
	void SwordsBaseTwohanded_OnMeleeEnd()
	{
		PlayViewAnim(Int(ANIM_IDLE1));
	}

	// special_01_end
	void SwordsBaseTwohanded_OnSpecial01End()
	{
		PlayViewAnim(Int(ANIM_IDLE1));
	}

	// parryanim
	void SwordsBaseTwohanded_OnParryanim()
	{
		if (ANIM_PARRY == ANIM_PARRY)
			return;
		PlayItemViewAnim(ENT_ME, Int(ANIM_PARRY));
	}

	// register_charge1
	void SwordsBaseTwohanded_OnRegisterCharge1()
	{
		if (Truthy(GetVar("CUSTOM_REGISTER_CHARGE1")))
			return;

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		LegacyCommand("multiply", "reg.attack.range", 1.5f);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", 1.3f);
		SetLocal("reg.attack.delay.end", 1.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// game_+attack2
	void SwordsBaseTwohanded_OnGamePressAttack2()
	{
		if (!Truthy(GetVar("SWORD_MANUAL_PARRY")))
			return;
		if (SWORD_MANUAL_PARRY_ON)
			return;
		if (!(GameTime() > NEXT_MANUAL_PARRY))
			return;
		NEXT_MANUAL_PARRY = GameTime() + FREQ_MANUAL_PARRY;
		PlayItemViewAnim(ENT_ME, Int(ANIM_PARRY));
		SWORD_MANUAL_PARRY_ON = true;
	}

	// game_-attack2
	void SwordsBaseTwohanded_OnGameReleaseAttack2()
	{
		if (!Truthy(GetVar("SWORD_MANUAL_PARRY")))
			return;
		if (!SWORD_MANUAL_PARRY_ON)
			return;
		PlayItemViewAnim(ENT_ME, ANIM_UNPARRY);
		SWORD_MANUAL_PARRY_ON = false;
		NEXT_MANUAL_PARRY = GameTime() + FREQ_MANUAL_PARRY;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		SwordsBaseTwohanded_OnGameDeploy();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SwordsBaseTwohanded_OnBweaponEffectRemove(reason);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseWeapon_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // items/base_weapon
		SwordsBaseTwohanded_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn();
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		SwordsBaseTwohanded_OnRegisterCharge1();
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SwordsBaseTwohanded_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnPlayParry() { SwordsBaseTwohanded_OnPlayParry(); } // play_parry
	void OnMeleeEnd() { SwordsBaseTwohanded_OnMeleeEnd(); } // melee_end
	void OnSpecial01End() { SwordsBaseTwohanded_OnSpecial01End(); } // special_01_end
	void OnParryanim() { SwordsBaseTwohanded_OnParryanim(); } // parryanim
	void OnGamePressAttack2() { SwordsBaseTwohanded_OnGamePressAttack2(); } // game_+attack2
	void OnGameReleaseAttack2() { SwordsBaseTwohanded_OnGameReleaseAttack2(); } // game_-attack2

	// This file's events and timers by their .script names
	bool SwordsBaseTwohanded_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "melee_end") { OnMeleeEnd(); return true; }
		if (name == "parryanim") { OnParryanim(); return true; }
		if (name == "play_parry") { OnPlayParry(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "special_01_end") { OnSpecial01End(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/swords_base_twohanded"]
shared class SwordsBaseTwohandedScript : AxesBaseOnehandedScript, SwordsBaseTwohanded
{
	// Variables every script that includes this file declares
	bool ANIM_LIFT = false;
	int ANIM_UNSHEATH = 0;
	string BASE_LEVEL_REQ = "BASE_LEVEL_REQ";
	string MELEE_ALIGN_BASE = "MELEE_ALIGN_BASE";
	string MELEE_ALIGN_TIP = "MELEE_ALIGN_TIP";
	string SOUND_DRAW = "SOUND_DRAW";
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables declared by included files, with the value they start with in this script
	SwordsBaseTwohandedScript()
	{
		PLAYERANIM_AIM = "sword_idle";
		PLAYERANIM_SWING = "sword_swing";
		SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
		SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SwordsBaseTwohanded_DispatchEvent(name, params)
			|| AxesBaseOnehandedScript::DispatchEvent(name, params);
	}
}
