#pragma context server

// Converted from items/smallarms_nh.script by msc_transpiler.
// This blade fires magic images of itself short distances

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_nh"]
class SmallarmsNh : SmallarmsBaseScript
{
	// Constants
	bool CUSTOM_REGISTER_NORMAL = true;
	bool CUSTOM_REGISTER_CHARGE1 = true;
	bool CUSTOM_REGISTER_SECONDARY = true;
	string BASE_LEVEL_REQ = "30";
	string MELEE_ALIGN_BASE = "0,0";
	string MELEE_ALIGN_TIP = "0,0";
	string CL_SCRIPT = "items/smallarms_nh_cl";

	// Variables (an unset .script variable reads as its own name)
	float SPRITE_SCALE = 0.0f;
	int GAME_PVP = 0;
	string CL_IDX = "CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsNh()
	{
		ANIM_LIFT1 = 31;
		ANIM_IDLE1 = "32";
		ANIM_WIELD = 21;
		ANIM_UNWIELD = 38;
		ANIM_WIELDEDIDLE1 = 32;
		ANIM_ATTACK1 = "34";
		ANIM_ATTACK2 = "34";
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "37";
		MODEL_VIEW_IDX = 11;
		MELEE_DMG_TYPE = "slash";
		MELEE_RANGE = "600";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 225;
		MELEE_DMG_RANGE = 50;
		MELEE_ACCURACY = "85%";
		MELEE_PARRY_CHANCE = "35%";
		SOUND_HITWALL1 = "none";
		SOUND_HITWALL2 = "none";
		ANIM_PREFIX = "standard";
	}

	// game_precache
	// this may not apply to items
	void OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
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
		SmallarmsBase_OnGameDeploy(); // items/smallarms_base

		// setvard MY_HAND game.item.hand_index //0-right 1-left
		SPRITE_SCALE = 0.1f;
		GAME_PVP = (IsPvp() ? 1 : 0);

		if (CL_IDX != "CL_IDX")
			return;
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_OWNER));
		CL_IDX = LastClientScriptId();
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		if (CL_IDX == "CL_IDX")
			return;
		ClientEvent("remove", "all", CL_IDX);
		CL_IDX = "CL_IDX";
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseItem_OnGameDrop(); // items/base_item
		if (CL_IDX == "CL_IDX")
			return;
		ClientEvent("remove", "all", CL_IDX);
		CL_IDX = "CL_IDX";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Neck Hunter");
		SetDescription("An evil enchanted blade with unusual reach");
		SetWeight(3);
		SetValue(3000);
		SetHudSprite("hand", "134");
		SetHudSprite("trade", "134");
	}

	// register_normal
	void OnRegisterNormal()
	{
		BaseMelee_OnRegisterNormal(); // items/base_melee

		// Normal swing attack
		// ===================
		string fBaseLevelReq = BASE_LEVEL_REQ;

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "melee");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.reqskill", fBaseLevelReq);

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";

		RegisterAttack();

		OnRegisterCharge1();
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee

		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", "magic");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "melee");
		SetLocal("reg.attack.noise", MELEE_NOISE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "special_01");
		LegacyCommand("multiply", "reg.attack.dmg", 3);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// melee_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		// original
		Vector3 bonePos = EyePositionOf(ENT_OWNER); // $get(ent_owner,svbonepos,BONE_IDX)
		Vector3 ownerViewang = ViewAnglesOf(ENT_OWNER);
		bonePos += RelativePosition(ownerViewang, Vector3(0, 28, 0));
		ClientEvent("update", "all", CL_IDX, "shadow_knife", bonePos, ViewAnglesOf(ENT_OWNER), endPos, hitType, SPRITE_SCALE);
		SPRITE_SCALE = 0.1f;

		// experiment
		// if ( MY_HAND == 0 ) local BONE_IDX 21
		// if ( MY_HAND == 1 ) local BONE_IDX 38
		// local BONE_POS $get(ent_owner,origin) //$get(ent_owner,svbonepos,BONE_IDX)
		// local HIT_TYPE PARAM1
		// local ATTACK_END PARAM2
		// local ANG_TO_END $angles3d(BONE_POS,ATTACK_END)
		// vectorset ANG_TO_END x $neg($vec.x(ANG_TO_END))
		// vectoradd BONE_POS $relpos(ANG_TO_END,$vec(0,28,0))
		// if ( G_DEVELOPER_MODE )
		// {
		// local VEC_TO_END $relpos(ANG_TO_END,$vec(0,600,0))
		// effect beam point laserbeam.spr 20 BONE_POS VEC_TO_END (255,255,0) 255 0.7 MELEE_ATK_DURATION
		// }
		// clientevent update all CL_IDX shadow_knife BONE_POS ATTACK_END HIT_TYPE SPRITE_SCALE
		SPRITE_SCALE = 0.1f;
	}

	// special_01_strike
	void OnSpecial01Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (IsAlive(hitEntity))
		{
			if (IsPlayer(hitEntity) && GAME_PVP == 0)
				exitSub = true;
			if (!exitSub && MaxHealthOf(hitEntity) < 1250.0f)
			{
				Vector3 pushVel = RelativeVelocity(Vector3(0, 300, 120));
				AddVelocity(hitEntity, pushVel);
			}
		}

		SPRITE_SCALE = 2.0f;
		OnMeleeStrike(hitType, endPos, hitEntity);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "register_normal") { OnRegisterNormal(); return true; }
		if (name == "special_01_strike") { OnSpecial01Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
