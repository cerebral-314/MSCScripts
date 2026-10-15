#pragma context server

// Converted from items/base_weapon_new.script by msc_transpiler.
// Base Weapon New by Thothie for more dynamic weapons

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseWeaponNew
{
	// Constants
	float BWEAPON_DBL_CHARGE_ADJ = 2.0f;
	string ATK1_TYPE = "strike-land";
	string ATK1_KEYS = "+attack1";
	int ATK1_RANGE = 90;
	int ATK1_DMG = 120;
	int ATK1_DMG_RANGE = 10;
	string ATK1_DMG_TYPE = "blunt";
	float ATK1_STAMINA = 1.0f;
	string ATK1_SKILL = "polearms";
	string ATK1_ACCURACY = "85";
	float ATK1_DELAY_STRIKE = 0.6f;
	float ATK1_DURATION = 1.1f;
	bool ATK1_OFS = false;
	bool ATK1_ANG = false;
	string ATK1_CALLBACK = "atk1";
	int ATK1_NOISE = 650;
	string ATK1_SKILL_LEVEL = "ATK1_SKILL_LEVEL";
	bool ATK1_MPDRAIN = false;
	bool ATK1_DMG_MULTI = false;
	bool ATK1_NO_AUTOAIM = false;
	string ATK1_PANIM = "pole_swing";
	int ATK1_VANIM = 4;
	string SOUND_ATK1 = "weapons/cbar_miss1.wav";
	float PITCH_ATK1 = 100.0f;
	bool ATK1_IS_PROJECTILE = false;
	string ATK1_PROJECTILE = "arrow";
	bool ATK1_AMMODRAIN = true;
	bool ATK1_COF = false;
	string ATK2_TYPE = "ATK2_TYPE";
	string ATK2_KEYS = "-attack1";
	int ATK2_RANGE = 0;
	int ATK2_DMG = 0;
	int ATK2_DMG_RANGE = 0;
	string ATK2_DMG_TYPE = "AT1_DMG_TYPE";
	float ATK2_STAMINA = 0.0f;
	string ATK2_SKILL = "ATK2_SKILL";
	string ATK2_ACCURACY = "ATK2_ACCURACY";
	float ATK2_DELAY_STRIKE = 0.0f;
	float ATK2_DURATION = 0.0f;
	bool ATK2_OFS = false;
	bool ATK2_ANG = false;
	string ATK2_CALLBACK = "atk2";
	int ATK2_NOISE = 0;
	string ATK2_SKILL_LEVEL = "ATK2_SKILL_LEVEL";
	int ATK2_ADD_SKILL_REQ = 2;
	bool ATK2_MPDRAIN = false;
	int ATK2_DMG_MULTI = 2;
	bool ATK2_NO_AUTOAIM = false;
	string ATK2_PANIM = "pole_swing";
	int ATK2_VANIM = 5;
	bool ATK2_IS_PROJECTILE = false;
	string ATK2_PROJECTILE = "arrow";
	bool ATK2_AMMODRAIN = true;
	bool ATK2_COF = false;
	string SOUND_ATK2 = "zombie/claw_miss2.wav";
	float PITCH_ATK2 = 100.0f;
	string SOUND_HITWALL1 = "weapons/bullet_hit1.wav";
	string SOUND_HITWALL2 = "weapons/bullet_hit2.wav";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	bool BITEM_UNDERSKILLED = false;
	bool BITEM_WAS_UNDERSKILLED = false;
	float BWEAPON_CHARGE_PERCENT = 0.0f;

	// game_spawn
	void BaseWeaponNew_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName(BWEAPON_NAME);
		SetDescription(BWEAPON_DESC);
		SetWeight(BWEAPON_WEIGHT);
		// unused, but set here, just in case
		SetValue(BWEAPON_VALUE);
		SetHudSprite("trade", Text(BWEAPON_INV_SPRITE_IDX));

		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);
		SetHand(BWEAPON_HANDS);

		OnBitemRegisterAttacks();
	}

	// game_deploy
	void BaseWeaponNew_OnGameDeploy()
	{
		OnBitemDraw();

		GAME_PVP = (IsPvp() ? 1 : 0);
		CallEventDelayed(0.01f, "bitem_check_skill");
		CallEventDelayed(0.01f, "bitem_setup_model");
	}

	// game_show
	void BaseWeaponNew_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		OnBweaponShow();
	}

	// bweapon_show
	void BaseWeaponNew_OnBweaponShow()
	{
		SetViewModel(VMODEL_FILE);
		// setworldmodel PMODEL_FILE
		SetModel(PMODEL_FILE);
		if (ItemHandIndex() == 0)
			SetModelBody(0, Int(GetVar("PMODEL_IDX_HAND_LEFT")));
		else
			SetModelBody(0, Int(GetVar("PMODEL_IDX_HAND_RIGHT")));
	}

	// game_switchhands
	void BaseWeaponNew_OnGameSwitchhands()
	{
		if (Truthy(GetVar("BWEAPON_CUSTOM_SWITCHHANDS")))
			return;
		PlayViewAnim(VANIM_IDLE);
	}

	// game_pickup
	void BaseWeaponNew_OnGamePickup()
	{
		OnBitemDraw();
	}

	// game_fall
	void BaseWeaponNew_OnGameFall()
	{
		SetModelBody(0, PMODEL_IDX_FLOOR);
		PlayAnim(WANIM_FLOOR);
	}

	// game_drop
	void BaseWeaponNew_OnGameDrop()
	{
		int rlHand = ItemHandIndex();
		CallExternal(ENT_OWNER, "ext_set_hand_id", rlHand, 0);
	}

	// bitem_draw
	void BaseWeaponNew_OnBitemDraw()
	{
		if (Truthy(GetVar("BWEAPON_CUSTOM_DRAW")))
			return;
		PlayViewAnim(0);
		PlayAnim("break");

		OnBweaponShow();

		SetAnimExtension(PANIM_EXT);
		// (never true here, the rest is skipped) if game.clientside
	}

	// bitem_setup_model
	void BaseWeaponNew_OnBitemSetupModel()
	{
		if (!IsInHand(ENT_ME))
			return;
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), VMODEL_IDX);
		CallEventDelayed(1.0f, "bitem_setup_model2");
	}

	// bitem_setup_model2
	void BaseWeaponNew_OnBitemSetupModel2()
	{
		if (!IsInHand(ENT_ME))
			return;
		DebugPrint("bi_setup_model2");
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), VMODEL_IDX);
	}

	// bitem_register_attacks
	void BaseWeaponNew_OnBitemRegisterAttacks()
	{
		// yet to be tested:
		// reg.attack.aoe.range
		// reg.attack.aoe.falloff
		// reg.attack.dmg.ignore //no damage?
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.type", ATK1_TYPE);
		SetLocal("reg.attack.keys", ATK1_KEYS);
		SetLocal("reg.attack.range", ATK1_RANGE);
		SetLocal("reg.attack.dmg", ATK1_DMG);
		SetLocal("reg.attack.dmg.range", ATK1_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", ATK1_DMG_TYPE);
		SetLocal("reg.attack.energydrain", ATK1_STAMINA);
		SetLocal("reg.attack.stat", ATK1_SKILL);
		SetLocal("reg.attack.hitchance", ATK1_ACCURACY);
		SetLocal("reg.attack.delay.strike", ATK1_DELAY_STRIKE);
		SetLocal("reg.attack.delay.end", ATK1_DURATION);
		SetLocal("reg.attack.ofs.startpos", ATK1_OFS);
		SetLocal("reg.attack.ofs.aimang", ATK1_ANG);
		SetLocal("reg.attack.callback", ATK1_CALLBACK);
		SetLocal("reg.attack.noise", ATK1_NOISE);
		SetLocal("reg.attack.mpdrain", ATK1_MPDRAIN);
		SetLocal("reg.attack.dmg.multi", ATK1_DMG_MULTI);
		SetLocal("reg.attack.noautoaim", ATK1_NO_AUTOAIM);
		SetLocal("reg.attack.reqskill", ATK1_SKILL_LEVEL);

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";

		if (ATK1_IS_PROJECTILE)
		{
			SetLocal("reg.attack.ammodrain", ATK1_AMMODRAIN);
			SetLocal("reg.attack.projectile", ATK1_PROJECTILE);
			SetLocal("reg.attack.COF", ATK1_COF);
		}

		RegisterAttack();

		if (!Truthy(GetVar("BITEM_CUSTOM_ATK2_REGISTER")))
		{
			SetLocal("reg.attack.priority", 1);
			SetLocal("reg.attack.chargeamt", 100);
			SetLocal("reg.attack.type", ATK2_TYPE);
			SetLocal("reg.attack.keys", ATK2_KEYS);
			SetLocal("reg.attack.range", ATK2_RANGE);
			SetLocal("reg.attack.dmg", ATK2_DMG);
			SetLocal("reg.attack.dmg.range", ATK2_DMG_RANGE);
			SetLocal("reg.attack.dmg.type", ATK2_DMG_TYPE);
			SetLocal("reg.attack.energydrain", ATK2_STAMINA);
			SetLocal("reg.attack.stat", ATK2_SKILL);
			SetLocal("reg.attack.hitchance", ATK2_ACCURACY);
			SetLocal("reg.attack.delay.strike", ATK2_DELAY_STRIKE);
			SetLocal("reg.attack.delay.end", ATK2_DURATION);
			SetLocal("reg.attack.ofs.startpos", ATK2_OFS);
			SetLocal("reg.attack.ofs.aimang", ATK2_ANG);
			SetLocal("reg.attack.callback", ATK2_CALLBACK);
			SetLocal("reg.attack.noise", ATK2_NOISE);
			SetLocal("reg.attack.mpdrain", ATK2_MPDRAIN);
			SetLocal("reg.attack.dmg.multi", ATK2_DMG_MULTI);
			DebugPrint(NameOf(ENT_ME) + " multi " + ATK2_DMG_MULTI);
			if (ATK2_DMG_MULTI != 0)
				LegacyCommand("multiply", "reg.attack.dmg", ATK2_DMG_MULTI);
			SetLocal("reg.attack.noautoaim", ATK2_NO_AUTOAIM);
			SetLocal("reg.attack.reqskill", ATK2_SKILL_LEVEL);
			LegacyCommand("add", "reg.attack.reqskill", ATK2_ADD_SKILL_REQ);

			if (ATK2_IS_PROJECTILE)
			{
				SetLocal("reg.attack.ammodrain", ATK2_AMMODRAIN);
				SetLocal("reg.attack.projectile", ATK2_PROJECTILE);
				SetLocal("reg.attack.COF", ATK2_COF);
			}

			RegisterAttack();
		}
	}

	// game_attack_cancel
	void BaseWeaponNew_OnGameAttackCancel()
	{
		PlayOwnerAnim("once", PANIM_IDLE, "global.anim.combatwalk", 3);
	}

	// game_hitworld
	void BaseWeaponNew_OnGameHitworld()
	{
		// dbg game_hitworld
		if (Truthy(GetVar("BWEAPON_CUSTOM_HITWALL")))
			return;
		PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// atk1_start
	void BaseWeaponNew_OnAtk1Start()
	{
		if (Truthy(GetVar("BITEM_CUSTOM_ATK1_EVENT")))
			return;
		PlayViewAnim(ATK1_VANIM);
		PlayOwnerAnim("critical", ATK1_PANIM, "global.anim.combatwalk", 3);
		PlaySound(1, 10, SOUND_ATK1, 0.8f, PITCH_ATK1);
	}

	// atk2_start
	void BaseWeaponNew_OnAtk2Start()
	{
		if (Truthy(GetVar("BITEM_CUSTOM_ATK2_EVENT")))
			return;
		PlayViewAnim(ATK2_VANIM);
		PlayOwnerAnim("critical", ATK2_PANIM, "global.anim.combatwalk", 3);
		PlaySound(1, 10, SOUND_ATK2, 0.8f, PITCH_ATK2);
	}

	// bitem_check_skill
	void BaseWeaponNew_OnBitemCheckSkill()
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;

		string findMeleeStat = "skill." + ATK1_SKILL;

		string ownerSkillText = GetProp(ENT_OWNER, findMeleeStat);
		int ownerSkill = Int(ownerSkillText);

		DebugPrint("bitem_check_skill " + findMeleeStat + " " + ownerSkillText);

		if (ownerSkill < Float(BASE_LEVEL_REQ))
		{
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + ATK1_SKILL;
			outStr += " proficiency " + BASE_LEVEL_REQ + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			BITEM_UNDERSKILLED = true;
			BITEM_WAS_UNDERSKILLED = true;
			SetAttackProp(ENT_ME, 0, "dmg.multi", 0.1f);
		}
		else
		{
			BITEM_UNDERSKILLED = false;
			if (BITEM_WAS_UNDERSKILLED)
			{
				SetAttackProp(ENT_ME, 0, "dmg.multi", 1.0f);
				BITEM_WAS_UNDERSKILLED = false;
			}
		}
	}

	// game_setchargepercent
	void BaseWeaponNew_OnGameSetchargepercent(float chargePercent = 0.0f)
	{
		// dbg game_setchargepercent PARAM1
		BWEAPON_CHARGE_PERCENT = chargePercent;
	}

	// atk1_damaged_other
	string BaseWeaponNew_OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (BWEAPON_CHARGE_PERCENT > 0.25f)
		{
			BWEAPON_CHARGE_PERCENT -= 0.25f;

			float chargeRatio = Ratio(BWEAPON_CHARGE_PERCENT, 1.25f, BWEAPON_DBL_CHARGE_ADJ);

			float newDmg = damage * chargeRatio;
			SetDamageInfo("dmg", newDmg);
			result = AppendResult(result, Text(chargeRatio));
			DebugPrint("Adjusted dmg x " + Text(chargeRatio));
			BWEAPON_CHARGE_PERCENT = 0.0f;

			string curDrainText;
			float curDrain = 0.0f * BWEAPON_CHARGE_PERCENT;
			curDrainText = Text(curDrain);
			LegacyCommand("drainstamina", ENT_OWNER, curDrainText);
		}
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseWeaponNew_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeaponNew_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseWeaponNew_OnGameDeploy();
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseWeaponNew_OnGameDrop();
	}

	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { BaseWeaponNew_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnBweaponShow() { BaseWeaponNew_OnBweaponShow(); } // bweapon_show
	void OnGameSwitchhands() { BaseWeaponNew_OnGameSwitchhands(); } // game_switchhands
	void OnGamePickup() { BaseWeaponNew_OnGamePickup(); } // game_pickup
	void OnBitemDraw() { BaseWeaponNew_OnBitemDraw(); } // bitem_draw
	void OnBitemSetupModel() { BaseWeaponNew_OnBitemSetupModel(); } // bitem_setup_model
	void OnBitemSetupModel2() { BaseWeaponNew_OnBitemSetupModel2(); } // bitem_setup_model2
	void OnBitemRegisterAttacks() { BaseWeaponNew_OnBitemRegisterAttacks(); } // bitem_register_attacks
	void OnGameAttackCancel() { BaseWeaponNew_OnGameAttackCancel(); } // game_attack_cancel
	void OnGameHitworld() { BaseWeaponNew_OnGameHitworld(); } // game_hitworld
	void OnAtk1Start() { BaseWeaponNew_OnAtk1Start(); } // atk1_start
	void OnAtk2Start() { BaseWeaponNew_OnAtk2Start(); } // atk2_start
	void OnBitemCheckSkill() { BaseWeaponNew_OnBitemCheckSkill(); } // bitem_check_skill
	void OnGameSetchargepercent(float chargePercent = 0.0f) { BaseWeaponNew_OnGameSetchargepercent(chargePercent); } // game_setchargepercent
	string OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BaseWeaponNew_OnAtk1DamagedOther(target, damage, damageType, damageEvent); } // atk1_damaged_other

	// This file's events and timers by their .script names
	bool BaseWeaponNew_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "atk1_damaged_other") { Return(OnAtk1DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "atk1_start") { OnAtk1Start(); return true; }
		if (name == "atk2_start") { OnAtk2Start(); return true; }
		if (name == "bitem_check_skill") { OnBitemCheckSkill(); return true; }
		if (name == "bitem_draw") { OnBitemDraw(); return true; }
		if (name == "bitem_register_attacks") { OnBitemRegisterAttacks(); return true; }
		if (name == "bitem_setup_model") { OnBitemSetupModel(); return true; }
		if (name == "bitem_setup_model2") { OnBitemSetupModel2(); return true; }
		if (name == "bweapon_show") { OnBweaponShow(); return true; }
		if (name == "game_attack_cancel") { OnGameAttackCancel(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitworld") { OnGameHitworld(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_setchargepercent") { OnGameSetchargepercent(Float(Param(params, 0))); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_weapon_new"]
shared class BaseWeaponNewScript : BaseItemExtrasScript, BaseWeaponNew
{
	// Variables every script that includes this file declares
	string BASE_LEVEL_REQ = "BASE_LEVEL_REQ";
	string BWEAPON_DESC = "BWEAPON_DESC";
	string BWEAPON_HANDS = "BWEAPON_HANDS";
	int BWEAPON_INV_SPRITE_IDX = 0;
	string BWEAPON_NAME = "BWEAPON_NAME";
	int BWEAPON_VALUE = 0;
	int BWEAPON_WEIGHT = 0;
	string PANIM_EXT = "PANIM_EXT";
	string PANIM_IDLE = "PANIM_IDLE";
	string PMODEL_FILE = "PMODEL_FILE";
	int PMODEL_IDX_FLOOR = 0;
	int PMODEL_IDX_HANDS = 0;
	int VANIM_DRAW = 0;
	int VANIM_IDLE = 0;
	string VMODEL_FILE = "VMODEL_FILE";
	int VMODEL_IDX = 0;
	string WANIM_FLOOR = "WANIM_FLOOR";
	string WANIM_HAND = "WANIM_HAND";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseWeaponNew_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
