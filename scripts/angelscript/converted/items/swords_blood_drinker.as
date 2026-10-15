#pragma context server

// Converted from items/swords_blood_drinker.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"
#include "converted/items/base_vampire.as"

[script "items/swords_blood_drinker"]
class SwordsBloodDrinker : SwordsBaseTwohandedScript, BaseVampire
{
	// Constants
	bool CUSTOM_REGISTER_CHARGE1 = true;
	int SPECIAL_OVERRIDE = 1;
	bool SWORD_MANUAL_PARRY = true;
	float HP_RETURN_RATIO = 0.01f;
	int THROW_MP = 40;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	string MELEE_NEW_PARRY_CHANCE = "30";

	// Variables (an unset .script variable reads as its own name)
	bool FIST_MODE = false;
	bool SENT_RETURN_REQ = false;
	string SWORD_ID = "SWORD_ID";

	// Variables declared by included files, with the value they start with in this script
	SwordsBloodDrinker()
	{
		BASE_LEVEL_REQ = "30";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 6;
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_BODY_OFS = "114";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		ANIM_PREFIX = "longsword";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 425;
		MELEE_DMG_RANGE = 80;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "30%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string SwordsBloodDrinker_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (FIST_MODE)
			return result;
		if (!hit)
			return result;

		float hpToGive = MaxHealthOf(ENT_OWNER) * HP_RETURN_RATIO;

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(hpToGive)); // <owner> <target> <healAmt>
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Blood Drinker");
		SetDescription("A gigantic dancing blade with a thirst for blood");
		SetWeight(100);
		SetValue(4000);
		SetHudSprite("trade", "105");

		SetHand("both");

		FIST_MODE = false;
		SWORD_CAN_PARRY = true;
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		SwordsBaseTwohanded_OnRegisterCharge1(); // items/swords_base_twohanded

		// stabby
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		LegacyCommand("add", "reg.attack.delay.strike", 0.5f);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		LegacyCommand("add", "reg.attack.delay.end", 0.5f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 32);
		RegisterAttack();

		// toss sword
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 0);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "slash");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "throwsword");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.mpdrain", THROW_MP);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 34);
		RegisterAttack();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesBaseOnehanded_OnMeleeStart(); // items/axes_base_onehanded
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		FIST_MODE = false;
		SWORD_CAN_PARRY = true;
		OnBwSetupModel();
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee

		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded

		if (!FIST_MODE)
			return;
		if (SENT_RETURN_REQ)
			return;
		OwnerMessage("Sent return request to " + NameOf(SWORD_ID)); // remove
		SENT_RETURN_REQ = true;
		CallExternal(SWORD_ID, "return_to_owner");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsBloodDrinker_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// throwsword_start
	void OnThrowswordStart()
	{
		// setviewmodel viewmodels/v_martialarts.mdl
		// setviewmodelprop ent_me submodel 0
		SetViewModel("none");
		PlayOwnerAnim("critical", "bow_release");
		SetModel("none");
		SetWorldModel("none");
		SetHand("undroppable");
		PlayViewAnim(4);
		FIST_MODE = true;
		SWORD_CAN_PARRY = false;

		if (!(ManaOf(ENT_OWNER) < THROW_MP))
			return;
		FIST_MODE = false;
		SWORD_CAN_PARRY = true;
		OnSwordReturn();
		PlayerMessageDark(ENT_OWNER, "Blood Drinker: Insufficient mana for Blood Dance");
	}

	// throwsword_strike
	void OnThrowswordStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlayOwnerAnim("critical", "bow_release");
		if (!FIST_MODE)
			return;
		SENT_RETURN_REQ = false;
		float dmgBase = Divide(SkillOf(ENT_OWNER, "spellcasting"), 2.0f);
		CreateNpc("monsters/summon/blood_drinker", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), @TargetOf(ENT_OWNER), dmgBase, dmgBase, self);
		SWORD_ID = EntityId(EntityOf(ENT_LASTCREATED));

		ApplyEffect(ENT_OWNER, "effects/effect_templock");
	}

	// restore_sword_cl
	void OnRestoreSwordCl()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		FIST_MODE = false;
		SWORD_CAN_PARRY = true;
	}

	// sword_return
	// called by monsters/summon/blood_drinker or when insufficient mana
	void OnSwordReturn()
	{
		CallExternal(ENT_OWNER, "ext_end_templock");
		SetViewModelProp(ENT_ME, "model", MODEL_VIEW);
		if (FIST_MODE)
			PlayerMessageGreen(ENT_OWNER, "Blood Drinker returns.");
		FIST_MODE = false;
		SWORD_CAN_PARRY = true;
		SetViewModel(MODEL_VIEW);
		SetHand("both");
		OnBwSetupModel();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "restore_sword_cl") { OnRestoreSwordCl(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "sword_return") { OnSwordReturn(); return true; }
		if (name == "throwsword_start") { OnThrowswordStart(); return true; }
		if (name == "throwsword_strike") { OnThrowswordStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVampire_DispatchEvent(name, params)
			|| SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
