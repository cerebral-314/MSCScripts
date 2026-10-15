#pragma context server

// Converted from items/base_varied_attacks.script by msc_transpiler.
// kinda brings back ye old weapon key combos
// only available on certain weapons due to animations and compatible bases

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseVariedAttacks
{
	// Constants
	int BV_EXTRA_ANIM_STAB = 6;
	int BV_EXTRA_ANIM_SWIPE = 5;
	int BV_REGULAR_ATTACK_ANIM = 2;

	// Variables (an unset .script variable reads as its own name)
	int CUR_ATTACK_ANIM = 0;

	// check_attack_anim
	void BaseVariedAttacks_OnCheckAttackAnim()
	{
		bool swipe = false;
		bool stab = false;
		float curDmg = 0.0f;
		float curAcc = 0.0f;
		bool exitSub = false;
		// $get(<player>,keydown,<attack1|attack2|use|jump|moveleft|moveright|back|forward>)
		if (BITEM_UNDERSKILLED)
			return;

		if (IsKeyDown(ENT_OWNER, "moveleft"))
			swipe = true;
		if (IsKeyDown(ENT_OWNER, "moveright"))
			swipe = true;
		if (IsKeyDown(ENT_OWNER, "forward"))
			stab = true;
		if (IsKeyDown(ENT_OWNER, "back"))
			stab = true;

		if (stab)
		{
			CUR_ATTACK_ANIM = BV_EXTRA_ANIM_STAB;
			curDmg = MELEE_DMG;
			curAcc = Float(MELEE_ACCURACY);
			curDmg *= 1.5f;
			curAcc *= 0.75f;
			SetAttackProp(ENT_ME, 0, "dmg", curDmg);
			SetAttackProp(ENT_ME, 0, "hitchance", curAcc);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (swipe)
		{
			CUR_ATTACK_ANIM = BV_EXTRA_ANIM_SWIPE;
			curDmg = MELEE_DMG;
			curAcc = Float(MELEE_ACCURACY);
			curDmg *= 0.75f;
			curAcc *= 1.5f;
			SetAttackProp(ENT_ME, 0, "dmg", curDmg);
			SetAttackProp(ENT_ME, 0, "hitchance", curAcc);
			exitSub = true;
		}
		if (exitSub)
			return;

		CUR_ATTACK_ANIM = BV_REGULAR_ATTACK_ANIM;

		curDmg = MELEE_DMG;
		curAcc = Float(MELEE_ACCURACY);
		SetAttackProp(ENT_ME, 0, "dmg", curDmg);
		SetAttackProp(ENT_ME, 0, "hitchance", curAcc);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnCheckAttackAnim() { BaseVariedAttacks_OnCheckAttackAnim(); } // check_attack_anim

	// This file's events and timers by their .script names
	bool BaseVariedAttacks_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_attack_anim") { OnCheckAttackAnim(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_varied_attacks"]
shared class BaseVariedAttacksScript : ScriptEntity, BaseVariedAttacks
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	string ANIM_IDLE1 = "ANIM_IDLE1";
	string ANIM_IDLE2 = "ANIM_IDLE2";
	string ANIM_IDLE3 = "ANIM_IDLE3";
	int ANIM_IDLE4 = 0;
	int ANIM_IDLE5 = 0;
	int ANIM_IDLE_DELAY_HIGH = 0;
	int ANIM_IDLE_DELAY_LOW = 0;
	int ANIM_IDLE_TOTAL = 0;
	int ANIM_LIFT1 = 0;
	string ANIM_PREFIX = "ANIM_PREFIX";
	string BASE_LEVEL_REQ = "BASE_LEVEL_REQ";
	string BITEM_DEBUG_CALLER = "BITEM_DEBUG_CALLER";
	string BITEM_DEBUG_OUT = "BITEM_DEBUG_OUT";
	bool BITEM_UNDERSKILLED = false;
	float BI_IDLE_PENDING = 0.0f;
	float BWEAPON_BASE_ANIM_SPEED = 0.0f;
	float BWEAPON_CHARGE_PERCENT = 0.0f;
	float BWEAPON_DBL_CHARGE_ADJ = 0.0f;
	float FREQ_NUB = 0.0f;
	bool IS_RESERVED = false;
	bool IS_WEAPON = false;
	string ITEM_BASE_SPEED = "ITEM_BASE_SPEED";
	string ITEM_BASE_STRIKE = "ITEM_BASE_STRIKE";
	bool ITEM_RESERVED = false;
	bool ITEM_SWIFT_BLADE = false;
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	string MELEE_ALIGN_BASE = "MELEE_ALIGN_BASE";
	string MELEE_ALIGN_TIP = "MELEE_ALIGN_TIP";
	float MELEE_ATK_DURATION = 0.0f;
	string MELEE_CALLBACK = "MELEE_CALLBACK";
	string MELEE_CALLBACK_CHARGED = "MELEE_CALLBACK_CHARGED";
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "MELEE_DMG_TYPE";
	float MELEE_ENERGY = 0.0f;
	int MELEE_NOISE = 0;
	string MELEE_PARRY_CHANCE = "MELEE_PARRY_CHANCE";
	string MELEE_RANGE = "MELEE_RANGE";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_STAT = "MELEE_STAT";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	int MODEL_VIEW_IDX = 0;
	string MODEL_WORLD = "MODEL_WORLD";
	bool NOOB_LOOP = false;
	float PARRY_MULTI_OUT = 0.0f;
	string PARRY_VALUE = "PARRY_VALUE";
	string PLAYERANIM_AIM = "PLAYERANIM_AIM";
	string PLAYERANIM_SWING = "PLAYERANIM_SWING";
	string SOUND_HITWALL1 = "SOUND_HITWALL1";
	string SOUND_HITWALL2 = "SOUND_HITWALL2";
	string SOUND_SWIPE = "SOUND_SWIPE";
	string SPECIAL01_SND = "SPECIAL01_SND";
	int SWING_ANIM = 0;
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseVariedAttacks_DispatchEvent(name, params);
	}
}
