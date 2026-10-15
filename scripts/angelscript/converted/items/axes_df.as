#pragma context server

// Converted from items/axes_df.script by msc_transpiler.
// Winter Cleaver
// (Cold Dmg, balanced, 100% cold DOT, freeze burst)
// Great Axe

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_df"]
class AxesDf : AxesBaseTwohandedScript
{
	// Constants
	int FAURA_MP = 50;
	int FAURA_RADIUS = 256;
	int VANIM_WARCRY = 9;
	float FREEZE_ATTACK_DELAY = 0.4f;
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables (an unset .script variable reads as its own name)
	float FREEZE_COUNT = 0.0f;
	int GAME_PVP = 0;
	CBaseEntity@ REPEAT_TARGET = null;
	CBaseEntity@ OLD_REPEAT_TARGET = null;
	float NEXT_FREEZE_ATTEMPT = 0.0f;
	Vector3 FAURA_START = Vector3();
	string FREEZE_TARGS = "FREEZE_TARGS";

	// Variables declared by included files, with the value they start with in this script
	AxesDf()
	{
		BASE_LEVEL_REQ = "30";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 6;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "77";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 500;
		MELEE_DMG_RANGE = 50;
		MELEE_DMG_TYPE = "cold";
		MELEE_ACCURACY = "60%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// game_dodamage
	string AxesDf_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";
		if (!hit)
			return result;
		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		@REPEAT_TARGET = target;
		if (OLD_REPEAT_TARGET is REPEAT_TARGET)
			FREEZE_COUNT += 1.0f;
		else
			FREEZE_COUNT = 0.0f;
		@OLD_REPEAT_TARGET = target;

		float dotBurn = SkillOf(ENT_OWNER, "spellcasting.ice");

		if (FREEZE_COUNT < 4.0f)
		{
			ApplyEffect(target, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "axehandling");
		}
		else
		{
			FREEZE_COUNT = 0.0f;
			dotBurn *= 0.25f;
			if (HealthOf(target) < 2000.0f)
				ApplyEffect(target, "effects/dot_cold_freeze", 5.0f, @EntityOf(ENT_OWNER), dotBurn, "axehandling", 2000);
		}
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
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Wintercleaver");
		SetDescription("A gigantic axe of elemental ice");
		SetWeight(90);
		SetValue(5000);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "146");

		FREEZE_COUNT = 0.0f;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesDf_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;

		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_FREEZE_ATTEMPT))
			return;
		NEXT_FREEZE_ATTEMPT = GameTime() + 1.0f;

		if (ManaOf(ENT_OWNER) < FAURA_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Wintercleaver: Insufficient mana for Freezing Burst.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (SkillOf(ENT_OWNER, "spellcasting.ice") < 25.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Wintercleaver: Insufficient ice skill for Freezing Burst.");
			exitSub = true;
		}
		if (exitSub)
			return;

		PlayItemViewAnim(ENT_ME, VANIM_WARCRY);

		GiveMana(ENT_OWNER, -FAURA_MP);

		CallEventDelayed(FREEZE_ATTACK_DELAY, "do_faura");

		ServerPlaySound(0, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// do_faura
	void OnDoFaura()
	{
		FAURA_START = OriginOf(ENT_OWNER);
		FAURA_START.z = GroundHeight(FAURA_START);

		ClientEvent("new", "all", "effects/sfx_ice_burst", FAURA_START, FAURA_RADIUS, 1, Vector3(64, 64, 255));

		CallExternal(ENT_OWNER, "ext_sphere_token_x", "enemy", 256);

		FREEZE_TARGS = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		DebugPrint("do_faura " + FREEZE_TARGS);
		if (FREEZE_TARGS == "none")
			return;
		int count = GetTokenCount(FREEZE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFauraAffectTargets();
		}
	}

	// faura_affect_targets
	void OnFauraAffectTargets()
	{
		bool exitSub = false;
		string curTarg = GetToken(FREEZE_TARGS, loopIteration);
		if (IsPlayer(curTarg) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		if (!(HealthOf(curTarg) < 2000.0f))
			return;
		DebugPrint("faura_affect_targets " + NameOf(curTarg));
		ApplyEffect(curTarg, "effects/dot_cold_freeze", Random(5, 8), @EntityOf(ENT_OWNER), 0, "none", 2000);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreezeAttackDelay() {} // FREEZE_ATTACK_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_faura") { OnDoFaura(); return true; }
		if (name == "faura_affect_targets") { OnFauraAffectTargets(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
