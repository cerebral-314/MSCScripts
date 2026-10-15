#pragma context server

// Converted from items/polearms_test.script by msc_transpiler.
// Script for testing theoretical polearm idears (from novablade)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/polearms_test"]
class PolearmsTest : SwordsBaseTwohandedScript
{
	// Constants
	int RANGE_SWIPE = 64;
	int POLEARM_OPTIMUM_RANGE = 80;
	float POLEARM_DMG_FALLOFF = 0.05f;
	string ANIM_SWIPE = "6";
	string ANIM_SMASH = "5";
	int ANIM_POKE = 4;
	int ANIM_TRIP = 3;
	float MELEE_DMG_DELAY_LONG = 1.0f;
	float MELEE_ATK_DURATION_LONG = 1.4f;
	string MELEE_ACCURACY2 = "90%";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	string SWIPE_LIST = "SWIPE_LIST";
	string OWNER_ORG = "OWNER_ORG";
	Vector3 OWNER_ANG = Vector3();
	bool PARRY_MODE = false;
	float NEXT_PARRY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	PolearmsTest()
	{
		BASE_LEVEL_REQ = "0";
		SOUND_PARRY = "weapons/parry.wav";
		ANIM_LIFT = true;
		ANIM_IDLE1 = "0";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 1;
		ANIM_SHEATH = 1;
		ANIM_PARRY = "7";
		MODEL_VIEW = "viewmodels/v_polearms.mdl";
		MODEL_VIEW_IDX = 4;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		MODEL_BODY_OFS = "104";
		ANIM_PREFIX = "khopesh";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.4f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 500;
		MELEE_DMG_TYPE = "generic";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "60%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// melee_damaged_other
	// <target> <damage>
	string PolearmsTest_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		OnAdjustDmg(target, damage);
		return result;
	}

	// special_01_damaged_other
	// <target> <damage>
	string PolearmsTest_OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		OnAdjustDmg(target, damage);
		return result;
	}

	// game_takedamage
	// PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string PolearmsTest_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool exitSub = false;
		string result = "";
		if (!PARRY_MODE)
			return result;
		if (Contains(damageType, "effect"))
			exitSub = true;
		if (Contains(damageType, "magic"))
			exitSub = true;
		if (exitSub)
			return result;
		Vector3 targOrg = OriginOf(attacker);
		OWNER_ORG = Text(OriginOf(ENT_OWNER));
		OWNER_ANG = AnglesOf(ENT_OWNER);
		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 30))
			return result;
		float dmgTaken = damage;
		float dmgBlocked = damage;
		dmgTaken *= 0.25f;
		dmgBlocked *= 0.75f;
		SetDamageInfo("dmg", dmgTaken);
		if (dmgBlocked > 0.0f)
			dmgBlocked = int(dmgBlocked);
		dmgBlocked = Float(Text(dmgBlocked) + "pts");
		OwnerMessage("Polearm blocked " + Text(dmgBlocked) + " damage.");
		return result;
	}

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
		SwordsBaseTwohanded_OnGameDeploy(); // items/swords_base_twohanded

		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// weapon_spawn
	// change
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Polearm (test)");
		SetDescription("It's a polearm! Really it is!");
		SetWeight(75);
		SetValue(0); // change
		SetHudSprite("trade", "longsword"); // change

		SetHand("both");
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PolearmsTest_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, SwordsBaseTwohanded_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, PolearmsTest_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded

		if (PARRY_MODE)
			return;
		if (!(GameTime() > NEXT_PARRY))
			return;
		PARRY_MODE = true;
		SetVar(Eval("game.effect.canattack"), 0);
		PlayItemViewAnim(ENT_ME, Int(ANIM_PARRY));
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		SwordsBaseTwohanded_OnGameReleaseAttack2(); // items/swords_base_twohanded
		if (!PARRY_MODE)
			return;
		OnEndParry();
	}

	// melee_start
	// ==================== THIS SHOULD BE PART OF items/base_polearm
	void OnMeleeStart()
	{
		PlayOwnerAnim("once", "sword_double_swing"); // change
		PlayViewAnim(Int(ANIM_ATTACK1));
		PlaySound(1, 10, SOUND_SWIPE);

		if (PARRY_MODE)
			OnEndParry();
	}

	string OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return PolearmsTest_OnSpecial01DamagedOther(target, damage, damageType, damageEvent); } // special_01_damaged_other

	// adjust_dmg
	void OnAdjustDmg(CBaseEntity@ target = null, float damage = 0.0f)
	{
		float missedAmt = 0.0f;
		bool tooClose = false;

		// if ( G_DEVELOPER_MODE ) gplayermessage ent_owner melee_damaged_other $get(PARAM1,name) $int(PARAM2) $get(PARAM1,range)
		if (!IsAlive(target))
			return;

		int optimumRange = POLEARM_OPTIMUM_RANGE;
		float dmgFalloff = POLEARM_DMG_FALLOFF;

		float targRange = RangeTo(target);

		if (targRange == optimumRange)
			return;

		// missed, adjust damage accordingly
		// hack hack (can't remember if scripts have an ABS or ratio function that'd work for this)
		if (targRange > optimumRange)
		{
			missedAmt = targRange - optimumRange;
			tooClose = false;
		}
		if (targRange < optimumRange)
		{
			missedAmt = optimumRange - targRange;
			tooClose = true;
		}

		float dmgPenaltyFactor = dmgFalloff * missedAmt;

		if (dmgPenaltyFactor >= 1.0f)
		{
			dmgPenaltyFactor = 0.9f; // completely out of range, do min damage
		}

		// if ( TOO_CLOSE ) playermessage You are too close to attack with this polearm! //not intuitive
		float outDmgFactor = 1.0f - dmgPenaltyFactor;

		float outDmg = damage * outDmgFactor;
		SetDamageInfo("dmg", outDmg);
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY2);

		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY_LONG);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION_LONG);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "melee");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);
		LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();

		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "generic");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY_LONG);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION_LONG);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "melee");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_02");
		LegacyCommand("multiply", "reg.attack.dmg", 2);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 5);
		LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// special_01_start
	void OnSpecial01Start()
	{
		if (PARRY_MODE)
			OnEndParry();
		PlayOwnerAnim("once", "sword_double_swing"); // change
		PlayViewAnim(ANIM_POKE);
		SetVolume(10);
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// special_02_start
	void OnSpecial02Start()
	{
		if (PARRY_MODE)
			OnEndParry();
		PlayOwnerAnim("once", "sword_double_swing"); // change
		PlayViewAnim(Int(ANIM_SWIPE));
		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SWORDREADY"));
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		CallExternal(ENT_OWNER, "ext_sphere_token", "enemy", RANGE_SWIPE, OriginOf(ENT_OWNER));
		SWIPE_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		DebugPrint("special_02_end " + SWIPE_LIST);
		if (SWIPE_LIST == "none")
			return;
		int nSwipies = GetTokenCount(SWIPE_LIST);
		if (!(nSwipies > 0))
			return;
		OWNER_ORG = Text(OriginOf(ENT_OWNER));
		OWNER_ANG = AnglesOf(ENT_OWNER);
		for (int i = 0; i < nSwipies; i++)
		{
			loopIteration = i;
			OnSwipeTargets();
		}
	}

	// swipe_targets
	void OnSwipeTargets()
	{
		bool exitSub = false;
		string curTarget = GetToken(SWIPE_LIST, loopIteration);

		// dont swipe players outside of PVP
		if (IsPlayer(curTarget) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		// within the cone
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 30))
			return;

		// no swiping through walls
		string traceStart = OWNER_ORG;
		string traceEnd = Text(targOrg);
		if (!IsPlayer(curTarget))
		{
			// adjust for origin center
			float halfMonHeight = Divide(HeightOf(curTarget), 2.0f);
			traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, halfMonHeight));
		}
		string traceCheck = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceCheck != traceEnd)
			return;

		// pow
		string statStr = "skill." + MELEE_STAT;

		string statSkill = GetProp(ENT_OWNER, statStr);
		string statFloatText = statSkill;
		float statFloat = Float(statFloatText) * 0.01f;
		statFloatText = Text(statFloat);

		float hitChance = 100.0f - Float(MELEE_ACCURACY);
		hitChance = Float(LegacyFunction("get_skill_ratio", statFloatText, MELEE_ACCURACY, 100)); // calc

		float dmgSwipe = MELEE_DMG;
		dmgSwipe = Float(LegacyFunction("get_skill_ratio", statFloatText, 0, MELEE_DMG));
		dmgSwipe = Divide(dmgSwipe, 2.0f); // no need for optimal range

		DebugPrint("swipe_targets Hitchance " + Text(hitChance) + " dmg " + Text(dmgSwipe));

		DoDamageEx(curTarget, "direct", dmgSwipe, hitChance, ENT_OWNER, ENT_OWNER, statStr, MELEE_DMG_TYPE);
	}

	// item_idle
	// prevent idle playing while in parry
	void OnItemIdle()
	{
	}

	// end_parry
	void OnEndParry(string source = "")
	{
		NEXT_PARRY = GameTime() + 1.0f;
		PARRY_MODE = false;
		SetVar(Eval("game.effect.canattack"), 1);
		PlayItemViewAnim(ENT_ME, 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_polearms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "adjust_dmg") { OnAdjustDmg(EntityParam(params, 0), Float(Param(params, 1))); return true; }
		if (name == "end_parry") { OnEndParry(Param(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "special_01_damaged_other") { Return(OnSpecial01DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "swipe_targets") { OnSwipeTargets(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
