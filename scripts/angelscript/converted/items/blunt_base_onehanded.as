#pragma context server

// Converted from items/blunt_base_onehanded.script by msc_transpiler.
// Blunt weapon (one-handed)

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntBaseOnehanded
{
	// Constants
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_STAT = "bluntarms";
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_SOUND = "MELEE_SOUND";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string PLAYERANIM_AIM = "blunt";
	string PLAYERANIM_SWING = "swing_blunt";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_AUGMENT = "0%";
	string ANIM_PREFIX = "rustedaxe";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string MODEL_HANDS = "MODEL_HANDS";
	string EFFECT_SCRIPT = "effects/debuff_stun";
	string SPECIAL_02_CALLBACK = "special_02";
	float SPECIAL_02_DELAY_STRIKE = 1.5f;
	float SPECIAL_02_DELAY_END = 2.0f;
	string SPECIAL_02_RANGE = "SPECIAL_02_RANGE";
	string SOUND_HITWALL1 = "weapons/xbow_hitbod1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hitbod2.wav";

	// weapon_spawn
	void BluntBaseOnehanded_OnWeaponSpawn()
	{
		int secondaryDmg = 0;

		SetHand("right");

		if (Truthy(GetVar("CUSTOM_REGISTER_BLUNT")))
			return;

		// Blunt bash attack (200%) - Normal damage, but stun for several seconds
		// ======================================================================
		if (Text(secondaryDmg) == "SECONDARY_DMG")
			secondaryDmg = MELEE_DMG;

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", SPECIAL_02_RANGE);
		SetLocal("reg.attack.dmg", secondaryDmg);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		// local reg.attack.aoe.range	100
		// local reg.attack.aoe.falloff	1.5
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		LegacyCommand("add", "reg.attack.hitchance", "10%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", SPECIAL_02_DELAY_STRIKE);
		SetLocal("reg.attack.delay.end", SPECIAL_02_DELAY_END);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", SPECIAL_02_CALLBACK);
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);
		if (GetVar("SPECIAL_02_MP") != "SPECIAL_02_MP")
			SetLocal("reg.attack.mpdrain", GetVar("SPECIAL_02_MP"));
		if (Float(GetVar("BASE_LEVEL_REQ")) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", GetVar("BASE_LEVEL_REQ"));

		RegisterAttack();
	}

	// special_02_start
	void BluntBaseOnehanded_OnSpecial02Start()
	{
		CallEventDelayed(0.9f, "bash");

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SWORDREADY"));
	}

	// bash
	void BluntBaseOnehanded_OnBash()
	{
		if (!Truthy(Eval("game.item.attacking"))) // Just in case player dies
			return;
		PlayViewAnim(Int(MELEE_VIEWANIM_ATK));
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// special_02_damaged_other
	// PARAM1 - Entity Damaged
	void BluntBaseOnehanded_OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		if (Truthy(GetVar("BLUNT_NO_STUN")))
			return;
		float maxstun = Clamp(SkillOf(ENT_OWNER, "bluntarms.prof") + 1.0f, 1.0f, 45.0f);
		float stuntime = Random(1, maxstun);
		ApplyEffect(target, EFFECT_SCRIPT, stuntime, @EntityOf(ENT_OWNER));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn();
	}

	void OnSpecial02Start() { BluntBaseOnehanded_OnSpecial02Start(); } // special_02_start
	void OnBash() { BluntBaseOnehanded_OnBash(); } // bash
	void OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { BluntBaseOnehanded_OnSpecial02DamagedOther(target, damage, damageType, damageEvent); } // special_02_damaged_other

	// This file's events and timers by their .script names
	bool BluntBaseOnehanded_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bash") { OnBash(); return true; }
		if (name == "special_02_damaged_other") { OnSpecial02DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_base_onehanded"]
shared class BluntBaseOnehandedScript : BaseMeleeScript, BluntBaseOnehanded
{
	// Variables every script that includes this file declares
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	float MELEE_ATK_DURATION = 0.0f;
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	float MELEE_ENERGY = 0.0f;
	string MELEE_RANGE = "MELEE_RANGE";

	// Variables declared by included files, with the value they start with in this script
	BluntBaseOnehandedScript()
	{
		ANIM_IDLE1 = "1";
		ANIM_PREFIX = "rustedaxe";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntBaseOnehanded_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
