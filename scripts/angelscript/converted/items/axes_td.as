#pragma context server

// Converted from items/axes_td.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesTd
{
	// Constants
	string BASE_LEVEL_REQ = "25";
	bool NO_IDLE = true;
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	string ANIM_ATTACK1 = "9";
	string ANIM_ATTACK2 = "10";
	string ANIM_ATTACK3 = "11";
	int ANIM_SHEATH = 5;
	string MELEE_VIEWANIM_ATK = "9";
	string MODEL_VIEW = "viewmodels/v_1haxes.mdl";
	int MODEL_VIEW_IDX = 5;
	int TOM_SKIN = 4;
	string MODEL_HANDS = "weapons/p_weapons3.mdl";
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_BODY_OFS = "20";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string ANIM_PREFIX = "standard";
	string MELEE_RANGE = "80";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 0.7f;
	float MELEE_ENERGY = 0.1f;
	int MELEE_DMG = 180;
	int MELEE_DMG_RANGE = 70;
	string MELEE_DMG_TYPE = "dark";
	string MELEE_ACCURACY = "75%";
	string MELEE_STAT = "axehandling";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "25%";

	// Variables (an unset .script variable reads as its own name)
	bool AXE_RESTORED = false;
	bool THROWING_AXE = false;

	// weapon_spawn
	void AxesTd_OnWeaponSpawn()
	{
		SetName("Dark Tomahawk");
		SetDescription("A cursed tomahawk of ancient times");
		SetWeight(30);
		SetValue(2500);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "175");

		OnBwSetupModel();
	}

	// game_deploy
	void AxesTd_OnGameDeploy()
	{
		CallEventDelayed(0.1f, "toma_setup_skin");
	}

	// toma_setup_skin
	void AxesTd_OnTomaSetupSkin()
	{
		SetProp(ENT_ME, "skin", TOM_SKIN);
	}

	// bw_setup_model
	void AxesTd_OnBwSetupModel()
	{
		LegacyCommand("setmodelskin", TOM_SKIN); // no workie?
		SetViewModelProp(ENT_ME, "skin", TOM_SKIN);
		SetProp(ENT_ME, "skin", TOM_SKIN);
	}

	// register_charge1
	void AxesTd_OnRegisterCharge1()
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 4096);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "slash");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "axehandling");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "axethrow");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 27);
		RegisterAttack();
	}

	// axethrow_start
	void AxesTd_OnAxethrowStart()
	{
		AXE_RESTORED = false;
		// sethand	undroppable
		SetModel("none");
		SetWorldModel("none");
		SetViewModel("viewmodels/v_martialarts.mdl");
		PlayViewAnim(4);
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), 0);
		ServerPlaySound(0, 8, ScriptVarOf(ENT_OWNER, "PLR_SOUND_JAB2"));
	}

	// axethrow_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void AxesTd_OnAxethrowStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlayOwnerAnim("critical", "bow_release");

		Vector3 endTarget = endPos;
		Vector3 myView = ViewAnglesOf(ENT_OWNER);

		DebugPrint("axethrow_strike " + hitType);

		if (hitType != "world")
			endTarget += RelativePosition(myView, Vector3(0, 128, 0));

		float dmgAxe = SkillOf(ENT_OWNER, "axehandling") * 1.5f;
		CreateNpc("monsters/summon/tomahawk", AttachmentPositionOf(ENT_OWNER, 0), @EntityOf(ENT_OWNER), endTarget, dmgAxe, self, MELEE_DMG_TYPE);

		ApplyEffect(ENT_OWNER, "effects/effect_templock");
	}

	// restore_axe_cl
	void AxesTd_OnRestoreAxeCl()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		if (AXE_RESTORED)
			return;
		PlayViewAnim(ANIM_LIFT1);
	}

	// catch_axe
	// called external from tom
	void AxesTd_OnCatchAxe()
	{
		DebugPrint("Caught Axe");
		// if ( game.clientside ) callevent restore_axe_cl //this is probably never client side as it is an external call
		// callexternal ent_owner ext_force_itemevent $get(ent_me,id) restore_axe_cl
		CallClientItemEvent(ENT_ME, "restore_axe_cl");
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), MODEL_VIEW_IDX);

		CallExternal(ENT_OWNER, "ext_end_templock"); // effect_templock
		THROWING_AXE = false;

		// hacky way to restore axe attribs on the client
		ClientCommand(ENT_OWNER, "+attack");
		CallEventDelayed(0.5f, "catch_axe2");
	}

	// catch_axe2
	void AxesTd_OnCatchAxe2()
	{
		ClientCommand(ENT_OWNER, "-attack");
	}

	// melee_start
	void AxesTd_OnMeleeStart()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		AXE_RESTORED = true;
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
		AxesTd_OnGameDeploy();
	}

	// bw_setup_model
	void OnBwSetupModel()
	{
		BaseWeapon_OnBwSetupModel(); // items/base_weapon
		AxesTd_OnBwSetupModel();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesTd_OnWeaponSpawn();
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		AxesTd_OnRegisterCharge1();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesBaseOnehanded_OnMeleeStart(); // items/axes_base_onehanded
		AxesTd_OnMeleeStart();
	}

	void OnTomaSetupSkin() { AxesTd_OnTomaSetupSkin(); } // toma_setup_skin
	void OnAxethrowStart() { AxesTd_OnAxethrowStart(); } // axethrow_start
	void OnAxethrowStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { AxesTd_OnAxethrowStrike(hitType, endPos, hitEntity, hit); } // axethrow_strike
	void OnRestoreAxeCl() { AxesTd_OnRestoreAxeCl(); } // restore_axe_cl
	void OnCatchAxe() { AxesTd_OnCatchAxe(); } // catch_axe
	void OnCatchAxe2() { AxesTd_OnCatchAxe2(); } // catch_axe2

	// This file's events and timers by their .script names
	bool AxesTd_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "axethrow_start") { OnAxethrowStart(); return true; }
		if (name == "axethrow_strike") { OnAxethrowStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "bw_setup_model") { OnBwSetupModel(); return true; }
		if (name == "catch_axe") { OnCatchAxe(); return true; }
		if (name == "catch_axe2") { OnCatchAxe2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "restore_axe_cl") { OnRestoreAxeCl(); return true; }
		if (name == "toma_setup_skin") { OnTomaSetupSkin(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_td"]
shared class AxesTdScript : AxesBaseOnehandedScript, AxesTd
{
	// Variables declared by included files, with the value they start with in this script
	AxesTdScript()
	{
		ANIM_ATTACK1 = "9";
		ANIM_ATTACK2 = "10";
		ANIM_ATTACK3 = "11";
		MELEE_VIEWANIM_ATK = "9";
		MODEL_VIEW = "viewmodels/v_1haxes.mdl";
		MODEL_VIEW_IDX = 5;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "20";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 0.7f;
		MELEE_ENERGY = 0.1f;
		MELEE_DMG = 180;
		MELEE_DMG_RANGE = 70;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_1haxes.mdl");
		Precache("viewmodels/v_martialarts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesTd_DispatchEvent(name, params)
			|| AxesBaseOnehandedScript::DispatchEvent(name, params);
	}
}
