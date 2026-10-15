#pragma context server

// Converted from items/smallarms_cre.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SmallarmsCre
{
	// Constants
	int MP_THROW = 10;
	string CRE_TYPE = "slash";
	string BWEAPON_NAME = "Crescent Blade";
	string BWEAPON_DESC = "A viscious pair of curving blades (matched set)";
	int BWEAPON_WEIGHT = 1;
	int BWEAPON_VALUE = 3000;
	int BWEAPON_INV_SPRITE_IDX = 193;
	string BWEAPON_HANDS = "right";
	string BASE_LEVEL_REQ = "30";
	bool BWEAPON_CUSTOM_DRAW = true;
	bool BWEAPON_CUSTOM_SWITCHHANDS = true;
	bool BITEM_CUSTOM_ATK2_EVENT = true;
	string VMODEL_FILE = "viewmodels/v_1hswords.mdl";
	int VMODEL_IDX = 6;
	string PMODEL_FILE = "weapons/p_weapons4.mdl";
	int PMODEL_IDX_FLOOR = 42;
	int PMODEL_IDX_HANDS = 41;
	string PANIM_IDLE = "aim_axe_onehand";
	string PANIM_EXT = "knife";
	int VANIM_DRAW = 0;
	int VANIM_IDLE = 1;
	int VANIM_DRAW_SNG = 6;
	int VANIM_IDLE_SNG = 7;
	string WANIM_FLOOR = "standard_floor_idle";
	string WANIM_HAND = "standard_idle";
	string ATK1_TYPE = "strike-land";
	string ATK1_KEYS = "+attack1";
	int ATK1_RANGE = 60;
	int ATK1_DMG = 275;
	int ATK1_DMG_RANGE = 5;
	string ATK1_DMG_TYPE = "slash";
	float ATK1_STAMINA = 0.1f;
	string ATK1_SKILL = "smallarms";
	string ATK1_ACCURACY = "85%";
	float ATK1_DELAY_STRIKE = 0.5f;
	float ATK1_DURATION = 1.1f;
	bool ATK1_OFS = false;
	bool ATK1_ANG = false;
	string ATK1_CALLBACK = "atk1";
	int ATK1_NOISE = 650;
	string ATK1_SKILL_LEVEL = "ATK1_SKILL_LEVEL";
	bool ATK1_MPDRAIN = false;
	bool ATK1_DMG_MULTI = false;
	bool ATK1_NO_AUTOAIM = false;
	string ATK1_PANIM = "axe_onehand_swing";
	int ATK1_VANIM = 3;
	string SOUND_ATK1 = "weapons/cbar_miss1.wav";
	float PITCH_ATK1 = 0.0f;
	string ATK2_TYPE = "ATK2_TYPE";
	string ATK2_KEYS = "-attack1";
	int ATK2_RANGE = 0;
	int ATK2_DMG = 0;
	int ATK2_DMG_RANGE = 0;
	string ATK2_DMG_TYPE = "ATK2_DMG_TYPE";
	float ATK2_STAMINA = 0.0f;
	string ATK2_SKILL = "ATK2_SKILL";
	string ATK2_ACCURACY = "ATK2_ACCURACY";
	float ATK2_DELAY_STRIKE = 0.3f;
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
	float PITCH_ATK2 = 80.0f;
	string SOUND_HITWALL1 = "weapons/dagger/daggermetal1.wav";
	string SOUND_HITWALL2 = "weapons/dagger/daggermetal2.wav";
	string SOUND_BLOCK1 = "body/armour3.wav";

	// Variables (an unset .script variable reads as its own name)
	int C_VANIM_DRAW = 0;
	int C_VANIM_IDLE = 1;
	bool MATCHED_SET = false;
	string MATCHED_SET_TYPE = "MATCHED_SET_TYPE";
	float NEXT_BLOCK = 0.0f;
	bool SENT_HELP_TIP = false;
	string HANDS_SINGLE = "HANDS_SINGLE";
	string OTHER_HAND = "OTHER_HAND";
	float LAST_KEY_CHECK = 0.0f;
	bool BLOCK_ON = false;
	bool MATCHED_SET_ACTIVE = false;
	bool GAVE_MATCH_SET_MSG = false;

	// unnamed block (first think)
	void SmallarmsCre_FirstThink()
	{
		MATCHED_SET = true;
		MATCHED_SET_TYPE = "crescent";
		C_VANIM_DRAW = 0;
		C_VANIM_IDLE = 1;
	}

	// bitem_draw
	// custom draw, anims vary with weapons
	void SmallarmsCre_OnBitemDraw()
	{
		PlayViewAnim(0);
		PlayAnim("break");

		SetViewModel(VMODEL_FILE);
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);

		float pmodelIdxHands = PMODEL_IDX_HANDS - ItemHandIndex();
		SetModelBody(0, int(pmodelIdxHands));

		SetAnimExtension(PANIM_EXT);

		PlayAnim(WANIM_HAND);

		NEXT_BLOCK = GameTime() + 2.0f;

		CallEventDelayed(0.1f, "set_anims");
	}

	// set_anims
	void SmallarmsCre_OnSetAnims()
	{
		bool singleHanded = false;
		if (!SENT_HELP_TIP)
		{
			HelpTip(ENT_OWNER, "crematch", "MATCHED SET WEAPON", "If you can find another crescent weapon, you'll have no dual weild penalty with it!");
			SENT_HELP_TIP = true;
		}

		OnCheckMatched();

		// dbg bitem_draw [ game.item.hand_index ] $get(OTHER_HAND,itemname)
		if (ItemNameOf(OTHER_HAND) == "fist_bare")
			singleHanded = true;
		if (ItemNameOf(OTHER_HAND) == "0")
			singleHanded = true;

		if (singleHanded)
		{
			OnSetAnimsSingle();
			CallClientItemEvent(ENT_ME, "set_anims_single", 1);
		}
		else
		{
			// splayviewanim ent_me C_VANIM_DRAW
			OnSetAnimsDouble();
			CallClientItemEvent(ENT_ME, "set_anims_double", 1);
		}
		// (never true here, the rest is skipped) if game.clientside
	}

	// set_anims_single
	void SmallarmsCre_OnSetAnimsSingle(string skipIdle = "")
	{
		HANDS_SINGLE = "1";
		C_VANIM_DRAW = VANIM_DRAW_SNG;
		C_VANIM_IDLE = VANIM_IDLE_SNG;
		// (never true here, the rest is skipped) if game.clientside
	}

	// set_anims_double
	void SmallarmsCre_OnSetAnimsDouble(string skipIdle = "")
	{
		HANDS_SINGLE = "0";
		C_VANIM_DRAW = VANIM_DRAW;
		C_VANIM_IDLE = VANIM_IDLE;
		// (never true here, the rest is skipped) if game.clientside
	}

	// game_switchhands
	void SmallarmsCre_OnGameSwitchhands()
	{
		OnSetIdle();
	}

	// atk1_end
	void SmallarmsCre_OnAtk1End()
	{
		OnCheckMatched();
		// (never true here, the rest is skipped) if game.clientside
	}

	// atk2_end
	void SmallarmsCre_OnAtk2End()
	{
		OnCheckMatched();
	}

	// set_idle
	void SmallarmsCre_OnSetIdle()
	{
		bool singleHanded = false;
		if (ItemHandIndex() == 0)
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND");
		else
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND");

		// dbg bitem_draw [ game.item.hand_index ] $get(OTHER_HAND,itemname)
		if (ItemNameOf(OTHER_HAND) == "fist_bare")
			singleHanded = true;
		if (ItemNameOf(OTHER_HAND) == "0")
			singleHanded = true;

		if (singleHanded)
		{
			OnSetAnimsSingle();
			CallClientItemEvent(ENT_ME, "set_anims_single");
		}
		else
		{
			OnSetAnimsDouble();
			CallClientItemEvent(ENT_ME, "set_anims_double");
		}
	}

	// atk2_start
	void SmallarmsCre_OnAtk2Start()
	{
		bool exitSub = false;
		if (ManaOf(ENT_OWNER) < MP_THROW)
		{
			PlayItemViewAnim(ENT_ME, 9);
			exitSub = true;
		}
		if (exitSub)
			return;
		PlayItemViewAnim(ENT_ME, 15);
		PlayOwnerAnim("critical", ATK2_PANIM, "global.anim.combatwalk", 3);
		PlaySound(1, 10, SOUND_ATK2, 0.8f, PITCH_ATK2);
	}

	// atk2_strike
	void SmallarmsCre_OnAtk2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (ManaOf(ENT_OWNER) < MP_THROW)
		{
			PlayerMessageDark(ENT_OWNER, "Crescent Blade: Insufficient mana for shadow throw");
			exitSub = true;
		}
		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -MP_THROW);

		CallExternal(ENT_OWNER, "ext_tosscre", ItemHandIndex(), CRE_TYPE);
	}

	// check_keys_loop
	void SmallarmsCre_OnCheckKeysLoop()
	{
		if (!MATCHED_SET_ACTIVE)
			return;
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;
		CallEventDelayed(0.25f, "check_keys_loop");

		// dbg check_keys_loop
		LAST_KEY_CHECK = GameTime();

		if (BLOCK_ON && !IsKeyDown(ENT_OWNER, "use"))
			OnBlockEnd();

		if (BLOCK_ON)
			return;
		if (!(GameTime() > NEXT_BLOCK))
			return;

		if (!IsKeyDown(ENT_OWNER, "use"))
			return;

		NEXT_BLOCK = GameTime() + 1.0f;

		OnCheckMatched();

		if (!MATCHED_SET_ACTIVE)
			return;
		PlayItemViewAnim(ENT_ME, 14);
		BLOCK_ON = true;
		PlayOwnerAnim("critical", "aim_fists", "global.anim.combatwalk", 3);
		CallExternal(OTHER_HAND, "match_block_anim");
		OnLockWeapon();
		ScriptFlags(ENT_OWNER, "add", "wcre", "nopush", 1, -1, "none");
	}

	// block_end
	void SmallarmsCre_OnBlockEnd()
	{
		if (!BLOCK_ON)
			return;
		PlayItemViewAnim(ENT_ME, C_VANIM_IDLE);
		BLOCK_ON = false;
		NEXT_BLOCK = GameTime() + 1.0f;
		PlayOwnerAnim("once", PANIM_IDLE, "global.anim.combatwalk", 3);
		OnUnlockWeapon();
		CallExternal(OTHER_HAND, "match_unblock_anim");
		ScriptFlags(ENT_OWNER, "remove", "wcre");
	}

	// game_putinpack
	void SmallarmsCre_OnGamePutinpack()
	{
		if (BLOCK_ON)
			ScriptFlags(ENT_OWNER, "remove", "wcre");
		BLOCK_ON = false;
		MATCHED_SET_ACTIVE = false;
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string SmallarmsCre_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool cantBlock = false;
		string result = "";
		if (!BLOCK_ON)
			return result;
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return result;
		if (StartsWith(damageType, "target"))
			cantBlock = true;
		if (Contains(damageType, "effect"))
			cantBlock = true;
		if (StartsWith(ItemNameOf(inflictor), "proj_arrow")) // can't block arrows with these
			cantBlock = true;
		if (cantBlock)
			return result;
		if (attacker is EntityOf(ENT_OWNER))
			return result;
		if (RelationshipOf(attacker, ENT_OWNER) != "enemy")
			return result;
		Vector3 ownerPos = OriginOf(ENT_OWNER);
		Vector3 ownerAng = AnglesOf(ENT_OWNER);
		Vector3 attackerPos = OriginOf(attacker);

		if (!WithinCone2D(attackerPos, ownerPos, ownerAng, 100))
			return result;
		float outDmg = damage * 0.25f;
		SetDamageInfo("dmg", outDmg);
		float amtBlocked = damage - outDmg;
		string amtBlockedText = Text(amtBlocked);
		if (amtBlocked > 1.0f)
		{
			amtBlocked = int(amtBlocked);
			amtBlockedText = Text(amtBlocked);
		}
		PlaySound(4, 10, SOUND_BLOCK1, 0.8f, Random(125, 150));
		PlayerMessageYellow(ENT_OWNER, "Crescents blocked " + amtBlockedText + " hp");
		return result;
	}

	// match_block_anim
	void SmallarmsCre_OnMatchBlockAnim()
	{
		PlayItemViewAnim(ENT_ME, 14);
	}

	// match_unblock_anim
	void SmallarmsCre_OnMatchUnblockAnim()
	{
		PlayItemViewAnim(ENT_ME, C_VANIM_IDLE);
	}

	// lock_weapon
	void SmallarmsCre_OnLockWeapon()
	{
		ApplyEffect(ENT_OWNER, "effects/effect_templock");
	}

	// unlock_weapon
	void SmallarmsCre_OnUnlockWeapon()
	{
		CallExternal(ENT_OWNER, "ext_end_templock");
	}

	// check_matched
	void SmallarmsCre_OnCheckMatched()
	{
		if (ItemHandIndex() == 0)
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND");
		else
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND");
		if (ScriptVarOf(OTHER_HAND, "MATCHED_SET_TYPE") == "crescent")
			MATCHED_SET_ACTIVE = true;
		else
			MATCHED_SET_ACTIVE = false;

		DebugPrint("check_matched " + Text(MATCHED_SET_ACTIVE));

		if (!MATCHED_SET_ACTIVE)
			return;
		float lastKeyCheck = LAST_KEY_CHECK + 1.0f;
		if (GameTime() > lastKeyCheck)
			OnCheckKeysLoop();
		if (!GAVE_MATCH_SET_MSG)
		{
			GAVE_MATCH_SET_MSG = true;
			InfoMessage(ENT_OWNER, "MATCHED SET ABILITY", "Hold +use to block with crescent blades");
		}
	}

	// ext_activate_items
	void SmallarmsCre_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		OnCheckMatched();
	}

	// bweapon_effect_remove
	void SmallarmsCre_OnBweaponEffectRemove(string reason = "")
	{
		if (!BLOCK_ON)
			return;
		ScriptFlags(ENT_ME, "remove", "wcre");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		SmallarmsCre_OnExtActivateItems(playerId);
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		SmallarmsCre_OnGamePutinpack();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SmallarmsCre_OnBweaponEffectRemove(reason);
	}

	// game_switchhands
	void OnGameSwitchhands()
	{
		BaseWeaponNew_OnGameSwitchhands(); // items/base_weapon_new
		SmallarmsCre_OnGameSwitchhands();
	}

	// bitem_draw
	void OnBitemDraw()
	{
		BaseWeaponNew_OnBitemDraw(); // items/base_weapon_new
		SmallarmsCre_OnBitemDraw();
	}

	// atk2_start
	void OnAtk2Start()
	{
		BaseWeaponNew_OnAtk2Start(); // items/base_weapon_new
		SmallarmsCre_OnAtk2Start();
	}

	void OnSetAnims() { SmallarmsCre_OnSetAnims(); } // set_anims
	void OnSetAnimsSingle(string skipIdle = "") { SmallarmsCre_OnSetAnimsSingle(skipIdle); } // set_anims_single
	void OnSetAnimsDouble(string skipIdle = "") { SmallarmsCre_OnSetAnimsDouble(skipIdle); } // set_anims_double
	void OnAtk1End() { SmallarmsCre_OnAtk1End(); } // atk1_end
	void OnAtk2End() { SmallarmsCre_OnAtk2End(); } // atk2_end
	void OnSetIdle() { SmallarmsCre_OnSetIdle(); } // set_idle
	void OnAtk2Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { SmallarmsCre_OnAtk2Strike(hitType, endPos, hitEntity, hit); } // atk2_strike
	void OnCheckKeysLoop() { SmallarmsCre_OnCheckKeysLoop(); } // check_keys_loop
	void OnBlockEnd() { SmallarmsCre_OnBlockEnd(); } // block_end
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SmallarmsCre_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnMatchBlockAnim() { SmallarmsCre_OnMatchBlockAnim(); } // match_block_anim
	void OnMatchUnblockAnim() { SmallarmsCre_OnMatchUnblockAnim(); } // match_unblock_anim
	void OnLockWeapon() { SmallarmsCre_OnLockWeapon(); } // lock_weapon
	void OnUnlockWeapon() { SmallarmsCre_OnUnlockWeapon(); } // unlock_weapon
	void OnCheckMatched() { SmallarmsCre_OnCheckMatched(); } // check_matched
	void OnClPlayDraw() {} // cl_play_draw
	void OnClPlayIdle() {} // cl_play_idle

	// This file's events and timers by their .script names
	bool SmallarmsCre_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "atk1_end") { OnAtk1End(); return true; }
		if (name == "atk2_end") { OnAtk2End(); return true; }
		if (name == "atk2_start") { OnAtk2Start(); return true; }
		if (name == "atk2_strike") { OnAtk2Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "bitem_draw") { OnBitemDraw(); return true; }
		if (name == "block_end") { OnBlockEnd(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "check_keys_loop") { OnCheckKeysLoop(); return true; }
		if (name == "check_matched") { OnCheckMatched(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "lock_weapon") { OnLockWeapon(); return true; }
		if (name == "match_block_anim") { OnMatchBlockAnim(); return true; }
		if (name == "match_unblock_anim") { OnMatchUnblockAnim(); return true; }
		if (name == "set_anims") { OnSetAnims(); return true; }
		if (name == "set_anims_double") { OnSetAnimsDouble(Param(params, 0)); return true; }
		if (name == "set_anims_single") { OnSetAnimsSingle(Param(params, 0)); return true; }
		if (name == "set_idle") { OnSetIdle(); return true; }
		if (name == "unlock_weapon") { OnUnlockWeapon(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/smallarms_cre"]
shared class SmallarmsCreScript : BaseWeaponNewScript, SmallarmsCre
{
	// Variables every script that includes this file declares
	float CRE_EFFECT_DURATION = 0.0f;
	string CRE_EFFECT_NAME = "CRE_EFFECT_NAME";
	float CRE_EFFECT_RATIO = 0.0f;
	string CRE_EFFECT_SCRIPT = "CRE_EFFECT_SCRIPT";
	string CRE_EFFECT_SKILL = "CRE_EFFECT_SKILL";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsCreScript()
	{
		BWEAPON_NAME = "Crescent Blade";
		BWEAPON_DESC = "A viscious pair of curving blades (matched set)";
		BWEAPON_WEIGHT = 1;
		BWEAPON_VALUE = 3000;
		BWEAPON_INV_SPRITE_IDX = 193;
		BWEAPON_HANDS = "right";
		BASE_LEVEL_REQ = "30";
		VMODEL_FILE = "viewmodels/v_1hswords.mdl";
		VMODEL_IDX = 6;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 42;
		PMODEL_IDX_HANDS = 41;
		PANIM_IDLE = "aim_axe_onehand";
		PANIM_EXT = "knife";
		VANIM_IDLE = 1;
		WANIM_FLOOR = "standard_floor_idle";
		WANIM_HAND = "standard_idle";
		ATK1_RANGE = 60;
		ATK1_DMG = 275;
		ATK1_DMG_RANGE = 5;
		ATK1_DMG_TYPE = "slash";
		ATK1_STAMINA = 0.1f;
		ATK1_SKILL = "smallarms";
		ATK1_ACCURACY = "85%";
		ATK1_DELAY_STRIKE = 0.5f;
		ATK1_PANIM = "axe_onehand_swing";
		ATK1_VANIM = 3;
		PITCH_ATK1 = 0.0f;
		ATK2_DMG_TYPE = "ATK2_DMG_TYPE";
		ATK2_DELAY_STRIKE = 0.3f;
		PITCH_ATK2 = 80.0f;
		SOUND_HITWALL1 = "weapons/dagger/daggermetal1.wav";
		SOUND_HITWALL2 = "weapons/dagger/daggermetal2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_1hswords.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SmallarmsCre_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SmallarmsCre_DispatchEvent(name, params)
			|| BaseWeaponNewScript::DispatchEvent(name, params);
	}
}
