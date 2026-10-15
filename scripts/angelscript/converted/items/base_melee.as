#pragma context server

// Converted from items/base_melee.script by msc_transpiler.
// Basic Melee Weapon
// REQ:
// MODEL_VIEW
// MODEL_HANDS
// MELEE_RANGE, MELEE_DMG, MELEE_DMG_RANGE, MELEE_DMG_TYPE
// MELEE_ENERGY

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMelee
{
	// Constants
	int MELEE_NOISE = 650;
	string SPECIAL01_SND = "SPECIAL01_SND";
	float FREQ_NUB = 30.0f;
	string MELEE_CALLBACK = "melee";
	string MELEE_CALLBACK_CHARGED = "melee";
	float BWEAPON_DBL_CHARGE_ADJ = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	bool BITEM_UNDERSKILLED = false;
	bool NOOB_LOOP = false;
	string PARRY_VALUE = "PARRY_VALUE";
	float PARRY_MULTI_OUT = 0.0f;
	float BWEAPON_CHARGE_PERCENT = 0.0f;

	// weapon_spawn
	void BaseMelee_OnWeaponSpawn()
	{
		OnRegisterNormal();
	}

	// register_normal
	void BaseMelee_OnRegisterNormal()
	{
		// Normal swing attack
		// ===================
		if (Truthy(GetVar("CUSTOM_REGISTER_NORMAL")))
			return;

		string fBaseLevelReq = GetVar("BASE_LEVEL_REQ");
		if (GetVar("BASE_LEVEL_REQ") == "BASE_LEVEL_REQ")
			fBaseLevelReq = "0";

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", GetVar("MELEE_RANGE"));
		SetLocal("reg.attack.dmg", GetVar("MELEE_DMG"));
		SetLocal("reg.attack.dmg.range", GetVar("MELEE_DMG_RANGE"));
		SetLocal("reg.attack.dmg.type", GetVar("MELEE_DMG_TYPE"));
		SetLocal("reg.attack.energydrain", GetVar("MELEE_ENERGY"));
		SetLocal("reg.attack.stat", GetVar("MELEE_STAT"));
		SetLocal("reg.attack.hitchance", GetVar("MELEE_ACCURACY"));
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", GetVar("MELEE_DMG_DELAY"));
		SetLocal("reg.attack.delay.end", GetVar("MELEE_ATK_DURATION"));
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", MELEE_CALLBACK);
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.reqskill", fBaseLevelReq);

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";

		RegisterAttack();

		OnRegisterCharge1();
	}

	// game_deploy
	void BaseMelee_OnGameDeploy()
	{
		OnWeaponEquip();

		string findMeleeStat = "skill." + GetVar("MELEE_STAT");
		if (Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(GetVar("BASE_LEVEL_REQ")))
		{
			CallEventDelayed(5.0f, "nub_loop");
			BITEM_UNDERSKILLED = true;
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + GetVar("MELEE_STAT");
			outStr += " proficiency " + GetVar("BASE_LEVEL_REQ") + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			NOOB_LOOP = true;
		}
	}

	// register_charge1
	void BaseMelee_OnRegisterCharge1()
	{
		if (Truthy(GetVar("CUSTOM_REGISTER_CHARGE1")))
			return;
		if (Truthy(GetVar("IS_TWO_HANDED_SWORD")))
			return;

		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", GetVar("MELEE_RANGE"));
		SetLocal("reg.attack.dmg", GetVar("MELEE_DMG"));
		SetLocal("reg.attack.dmg.range", GetVar("MELEE_DMG_RANGE"));
		SetLocal("reg.attack.dmg.type", GetVar("MELEE_DMG_TYPE"));
		SetLocal("reg.attack.energydrain", GetVar("MELEE_ENERGY"));
		SetLocal("reg.attack.stat", GetVar("MELEE_STAT"));
		SetLocal("reg.attack.hitchance", GetVar("MELEE_ACCURACY"));
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", GetVar("MELEE_DMG_DELAY"));
		SetLocal("reg.attack.delay.end", GetVar("MELEE_ATK_DURATION"));
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", MELEE_CALLBACK_CHARGED);
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", BWEAPON_DBL_CHARGE_ADJ);
		LegacyCommand("multiply", "reg.attack.energydrain", BWEAPON_DBL_CHARGE_ADJ);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);

		if (Float(GetVar("BASE_LEVEL_REQ")) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", GetVar("BASE_LEVEL_REQ"));

		RegisterAttack();
	}

	// melee_start
	void BaseMelee_OnMeleeStart()
	{
		if (Truthy(GetVar("MELEE_OVERRIDE")))
			return;

		OnBmAttackStart();
	}

	// bm_attack_start
	void BaseMelee_OnBmAttackStart()
	{
		PlayViewAnim(Int(GetVar("MELEE_VIEWANIM_ATK")));
		// dbg bm_attack_start PLAYERANIM_SWING global.anim.combatwalk
		if (GetVar("PLAYERANIM_SWING") != "PLAYERANIM_SWING")
			PlayOwnerAnim("once", GetVar("PLAYERANIM_SWING"), "global.anim.combatwalk", 3);
		CallEventOrDelay(GetVar("MELEE_SOUND_DELAY"), "melee_playsound");
	}

	// melee_playsound
	void BaseMelee_OnMeleePlaysound()
	{
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), GetVar("SOUND_SWIPE"));
	}

	// game_attack_done
	void BaseMelee_OnGameAttackDone()
	{
		OnItemIdle();
	}

	// special_01_start
	void BaseMelee_OnSpecial01Start()
	{
		if (Truthy(GetVar("SPECIAL1_OVERRIDE")))
			return;

		OnMeleeStart();
		ServerPlaySound(1, 10, SPECIAL01_SND);
	}

	// hitwall
	void BaseMelee_OnHitwall()
	{
		if (GetVar("SOUND_HITWALL1") == "SOUND_HITWALL1")
			return;
		PlayRandomSound(1, 10, GetVar("SOUND_HITWALL1"), GetVar("SOUND_HITWALL2"));
	}

	// nub_loop
	void BaseMelee_OnNubLoop()
	{
		if (!NOOB_LOOP)
			BITEM_UNDERSKILLED = false;

		if (!NOOB_LOOP)
			return;
		BITEM_UNDERSKILLED = true;
		string findMeleeStat = "skill." + GetVar("MELEE_STAT");
		if (!(Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(GetVar("BASE_LEVEL_REQ"))))
			return;
		CallEventDelayed(FREQ_NUB, "nub_loop");
		string outStr = "You lack the proficiency to wield this weapon. ( requires: " + GetVar("MELEE_STAT");
		outStr += " proficiency " + GetVar("BASE_LEVEL_REQ") + " )";
		InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
		PlayerMessageDark(ENT_OWNER, "You lack the skill to wield this weapon.");
	}

	// game_wear
	void BaseMelee_OnGameWear(string race = "", string gender = "", string source = "")
	{
		OnWeaponEquip();
		NOOB_LOOP = false;
	}

	// game_removefromowner
	// this seems to go off when item is put in pack OR drawn - but seems undepndable for second weapon?
	void BaseMelee_OnGameRemovefromowner()
	{
		NOOB_LOOP = false;
	}

	// weapon_equip
	void BaseMelee_OnWeaponEquip()
	{
		if (Truthy(GetVar("AM_SHIELD")))
		{
			PARRY_VALUE = "am_shield";
			PARRY_MULTI_OUT = Float(GetVar("PARRY_MULTI"));
		}
		if (!Truthy(GetVar("AM_SHIELD")))
		{
			string findMeleeStat = "skill." + GetVar("MELEE_STAT");
			PARRY_VALUE = GetProp(ENT_OWNER, findMeleeStat);
		}
		if (Truthy(GetVar("NO_PARRY")))
			PARRY_VALUE = "0";
	}

	// game_setchargepercent
	void BaseMelee_OnGameSetchargepercent(float chargePercent = 0.0f)
	{
		// dbg game_setchargepercent PARAM1
		BWEAPON_CHARGE_PERCENT = chargePercent;
	}

	// melee_damaged_other
	string BaseMelee_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (BITEM_UNDERSKILLED)
		{
			SetDamageInfo("dmg", 0.05f);
			// return 1 //fucks with damage
			return result;
		}

		if (!(BWEAPON_CHARGE_PERCENT < 1.0f)) // anything above 100% charge should not be buffed.
			return result;
		if (BWEAPON_CHARGE_PERCENT > 0.25f)
		{
			BWEAPON_CHARGE_PERCENT -= 0.25f;

			float chargeRatio = Ratio(BWEAPON_CHARGE_PERCENT, 1.25f, BWEAPON_DBL_CHARGE_ADJ);

			float newDmg = damage * chargeRatio;
			SetDamageInfo("dmg", newDmg);
			result = AppendResult(result, Text(chargeRatio));
			DebugPrint("Adjusted dmg x " + Text(chargeRatio));
			BWEAPON_CHARGE_PERCENT = 0.0f;

			float curDrain = Float(GetVar("MELEE_ENERGY"));
			curDrain *= BWEAPON_CHARGE_PERCENT;
			LegacyCommand("drainstamina", ENT_OWNER, curDrain);
		}
		return result;
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
		BaseMelee_OnGameDeploy();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source);
	}

	void OnWeaponSpawn() { BaseMelee_OnWeaponSpawn(); } // weapon_spawn
	void OnRegisterNormal() { BaseMelee_OnRegisterNormal(); } // register_normal
	void OnRegisterCharge1() { BaseMelee_OnRegisterCharge1(); } // register_charge1
	void OnMeleeStart() { BaseMelee_OnMeleeStart(); } // melee_start
	void OnBmAttackStart() { BaseMelee_OnBmAttackStart(); } // bm_attack_start
	void OnMeleePlaysound() { BaseMelee_OnMeleePlaysound(); } // melee_playsound
	void OnGameAttackDone() { BaseMelee_OnGameAttackDone(); } // game_attack_done
	void OnSpecial01Start() { BaseMelee_OnSpecial01Start(); } // special_01_start
	void OnHitwall() { BaseMelee_OnHitwall(); } // hitwall
	void OnNubLoop() { BaseMelee_OnNubLoop(); } // nub_loop
	void OnGameRemovefromowner() { BaseMelee_OnGameRemovefromowner(); } // game_removefromowner
	void OnWeaponEquip() { BaseMelee_OnWeaponEquip(); } // weapon_equip
	void OnGameSetchargepercent(float chargePercent = 0.0f) { BaseMelee_OnGameSetchargepercent(chargePercent); } // game_setchargepercent
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent); } // melee_damaged_other
	void OnFreqNub() {} // FREQ_NUB
	void OnMeleeSoundDelay() {} // MELEE_SOUND_DELAY

	// This file's events and timers by their .script names
	bool BaseMelee_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bm_attack_start") { OnBmAttackStart(); return true; }
		if (name == "game_attack_done") { OnGameAttackDone(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_setchargepercent") { OnGameSetchargepercent(Float(Param(params, 0))); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "melee_playsound") { OnMeleePlaysound(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "nub_loop") { OnNubLoop(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "register_normal") { OnRegisterNormal(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_equip") { OnWeaponEquip(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_melee"]
shared class BaseMeleeScript : BaseWeaponScript, BaseMelee
{
	// Variables every script that includes this file declares
	string ANIM_PREFIX = "ANIM_PREFIX";
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseMelee_DispatchEvent(name, params)
			|| BaseWeaponScript::DispatchEvent(name, params);
	}
}
