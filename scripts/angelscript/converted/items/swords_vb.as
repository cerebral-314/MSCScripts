#pragma context server

// Converted from items/swords_vb.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon_new.as"
#include "converted/items/base_vampire.as"

[script "items/swords_vb"]
class SwordsVb : BaseWeaponNewScript, BaseVampire
{
	// Constants
	bool BWEAPON_CUSTOM_DRAW = true;
	bool BWEAPON_CUSTOM_SWITCHHANDS = true;
	bool BITEM_CUSTOM_ATK2_EVENT = true;
	bool BITEM_CUSTOM_ATK1_EVENT = true;
	int PMODEL_IDX_HAND_RIGHT = 43;
	int PMODEL_IDX_HAND_LEFT = 44;
	int VANIM_DRAW_SNG = 6;
	int VANIM_IDLE_SNG = 7;
	int VANIM_BLOCK = 16;
	int VANIM_BLOCK_OFH = 18;
	string SOUND_BLOCK1 = "weapons/cbar_hit2.wav";

	// Variables (an unset .script variable reads as its own name)
	int C_VANIM_DRAW = 0;
	int C_VANIM_IDLE = 20;
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

	// Variables declared by included files, with the value they start with in this script
	SwordsVb()
	{
		BWEAPON_NAME = "Blood Blade";
		BWEAPON_DESC = "A sinuous blade of dark steel (matched set)";
		BWEAPON_WEIGHT = 1;
		BWEAPON_VALUE = 3000;
		BWEAPON_INV_SPRITE_IDX = 190;
		BWEAPON_HANDS = "right";
		BASE_LEVEL_REQ = "30";
		VMODEL_FILE = "viewmodels/v_1hswords.mdl";
		VMODEL_IDX = 7;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 45;
		PMODEL_IDX_HANDS = 44;
		PANIM_IDLE = "aim_axe_onehand";
		PANIM_EXT = "axe_onehand";
		VANIM_IDLE = 20;
		WANIM_FLOOR = "standard_floor_idle";
		WANIM_HAND = "standard_idle";
		ATK1_RANGE = 80;
		ATK1_DMG = 250;
		ATK1_DMG_TYPE = "dark";
		ATK1_STAMINA = 0.1f;
		ATK1_SKILL = "swordsmanship";
		ATK1_ACCURACY = "85%";
		ATK1_DELAY_STRIKE = 0.2f;
		ATK1_DURATION = 0.7f;
		ATK1_PANIM = "axe_onehand_swing";
		ATK1_VANIM = 2;
		PITCH_ATK1 = 0.0f;
		SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
		SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
		ATK2_RANGE = 110;
		ATK2_DELAY_STRIKE = 0.4f;
		ATK2_DURATION = 0.8f;
		SOUND_ATK2 = "SOUND_ATK2";
		PITCH_ATK2 = 0.0f;
	}

	// unnamed block (first think)
	void SwordsVb_FirstThink()
	{
		MATCHED_SET = true;
		MATCHED_SET_TYPE = "vsword";
		C_VANIM_DRAW = 0;
		C_VANIM_IDLE = 20;
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string SwordsVb_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
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
		PlayerMessageYellow(ENT_OWNER, "Vampyric Swords blocked " + amtBlockedText + " hp");
		return result;
	}

	// atk1_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type //items return attcallback_damaged_other
	string SwordsVb_OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		OnBloodDrain(target, damage);
		return result;
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		OnCheckMatched();
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		if (BLOCK_ON)
			ScriptFlags(ENT_OWNER, "remove", "wcre");
		BLOCK_ON = false;
		MATCHED_SET_ACTIVE = false;
	}

	// game_switchhands
	void OnGameSwitchhands()
	{
		BaseWeaponNew_OnGameSwitchhands(); // items/base_weapon_new
		OnSetIdle();
	}

	// bitem_draw
	// custom draw, anims vary with weapons
	void OnBitemDraw()
	{
		BaseWeaponNew_OnBitemDraw(); // items/base_weapon_new
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

	// atk1_start
	void OnAtk1Start()
	{
		BaseWeaponNew_OnAtk1Start(); // items/base_weapon_new
		int vanim;
		DebugPrint("hands " + HANDS_SINGLE);
		if (!Truthy(HANDS_SINGLE))
			vanim = 19;
		else
			vanim = RandomInt(8, 11);
		PlayViewAnim(vanim);
		PlayOwnerAnim("critical", ATK1_PANIM, "global.anim.combatwalk", 3);
		PlaySound(1, 10, SOUND_ATK1, 0.8f, PITCH_ATK1);
	}

	// atk2_start
	void OnAtk2Start()
	{
		BaseWeaponNew_OnAtk2Start(); // items/base_weapon_new
		int vanim;
		DebugPrint("hands " + HANDS_SINGLE);
		if (!Truthy(HANDS_SINGLE))
			vanim = 17;
		else
			vanim = 17;
		PlayViewAnim(vanim);
		PlayOwnerAnim("critical", ATK2_PANIM, "global.anim.combatwalk", 3);
		PlaySound(1, 10, SOUND_ATK2, 0.8f, PITCH_ATK2);
	}

	// atk1_damaged_other
	string OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseWeaponNew_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SwordsVb_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// set_anims
	void OnSetAnims()
	{
		bool singleHanded = false;
		if (!SENT_HELP_TIP)
		{
			HelpTip(ENT_OWNER, "vswordmatch", "MATCHED SET WEAPON", "If you can find another vampyric sword, you'll have no dual wield penalty with it!");
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
	}

	// set_anims_single
	void OnSetAnimsSingle(string skipIdle = "")
	{
		HANDS_SINGLE = "1";
		C_VANIM_DRAW = VANIM_DRAW_SNG;
		C_VANIM_IDLE = VANIM_IDLE_SNG;
		// (never true here, the rest is skipped) if game.clientside
	}

	// set_anims_double
	void OnSetAnimsDouble(string skipIdle = "")
	{
		HANDS_SINGLE = "0";
		C_VANIM_DRAW = VANIM_DRAW;
		C_VANIM_IDLE = VANIM_IDLE;
		// (never true here, the rest is skipped) if game.clientside
	}

	// set_idle
	void OnSetIdle()
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

	// check_keys_loop
	void OnCheckKeysLoop()
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
		PlayItemViewAnim(ENT_ME, VANIM_BLOCK);
		BLOCK_ON = true;
		PlayOwnerAnim("critical", "aim_fists", "global.anim.combatwalk", 3);
		CallExternal(OTHER_HAND, "match_block_anim");
		OnLockWeapon();
	}

	// block_end
	void OnBlockEnd()
	{
		if (!BLOCK_ON)
			return;
		PlayItemViewAnim(ENT_ME, C_VANIM_IDLE);
		BLOCK_ON = false;
		NEXT_BLOCK = GameTime() + 1.0f;
		PlayOwnerAnim("once", PANIM_IDLE, "global.anim.combatwalk", 3);
		OnUnlockWeapon();
		CallExternal(OTHER_HAND, "match_unblock_anim");
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SwordsVb_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// match_block_anim
	void OnMatchBlockAnim()
	{
		PlayItemViewAnim(ENT_ME, VANIM_BLOCK_OFH);
	}

	// match_unblock_anim
	void OnMatchUnblockAnim()
	{
		PlayItemViewAnim(ENT_ME, C_VANIM_IDLE);
	}

	// lock_weapon
	void OnLockWeapon()
	{
		ApplyEffect(ENT_OWNER, "effects/effect_templock");
	}

	// unlock_weapon
	void OnUnlockWeapon()
	{
		CallExternal(ENT_OWNER, "ext_end_templock");
	}

	// check_matched
	void OnCheckMatched()
	{
		bool singleHanded = false;
		if (ItemHandIndex() == 0)
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND");
		else
			OTHER_HAND = ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND");
		if (ScriptVarOf(OTHER_HAND, "MATCHED_SET_TYPE") == MATCHED_SET_TYPE)
			MATCHED_SET_ACTIVE = true;
		else
			MATCHED_SET_ACTIVE = false;

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

		// splayviewanim ent_me C_VANIM_DRAW
		// dbg check_matched MATCHED_SET_ACTIVE
		if (!MATCHED_SET_ACTIVE)
			return;
		float lastKeyCheck = LAST_KEY_CHECK + 1.0f;
		if (GameTime() > lastKeyCheck)
			OnCheckKeysLoop();
		if (!GAVE_MATCH_SET_MSG)
		{
			GAVE_MATCH_SET_MSG = true;
			InfoMessage(ENT_OWNER, "MATCHED SET ABILITY", "Hold +use to block with Vampyric Blades");
		}
	}

	// atk2_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type //items return attcallback_damaged_other
	void OnAtk2DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		OnBloodDrain(target, damage);
	}

	// atk1_end
	void OnAtk1End()
	{
		OnCheckMatched();
		// (never true here, the rest is skipped) if game.clientside
	}

	// atk2_end
	void OnAtk2End()
	{
		OnCheckMatched();
		// (never true here, the rest is skipped) if game.clientside
	}

	// blood_drain
	// <target_hit> <dmg>
	void OnBloodDrain(CBaseEntity@ target = null, float healAmount = 0.0f)
	{
		float healAmt = healAmount * 0.1f;

		Effect("glow", ENT_OWNER, Vector3(0, 100, 0), 60, 0.5f, 0.5f);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(healAmt));
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
		SwordsVb_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "atk1_damaged_other") { Return(OnAtk1DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "atk1_end") { OnAtk1End(); return true; }
		if (name == "atk1_start") { OnAtk1Start(); return true; }
		if (name == "atk2_damaged_other") { OnAtk2DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "atk2_end") { OnAtk2End(); return true; }
		if (name == "atk2_start") { OnAtk2Start(); return true; }
		if (name == "bitem_draw") { OnBitemDraw(); return true; }
		if (name == "block_end") { OnBlockEnd(); return true; }
		if (name == "blood_drain") { OnBloodDrain(EntityParam(params, 0), Float(Param(params, 1))); return true; }
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
		return BaseVampire_DispatchEvent(name, params)
			|| BaseWeaponNewScript::DispatchEvent(name, params);
	}
}
