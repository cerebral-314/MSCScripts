#pragma context server

// Converted from items/smallarms_base.script by msc_transpiler.
// Smallarms base
// Uses ANIM_ATTACK1-2

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SmallarmsBase
{
	// Constants
	int ANIM_LIFT1 = 9;
	string ANIM_IDLE1 = "10";
	int ANIM_IDLE_TOTAL = 1;
	int ANIM_WIELD = 11;
	int ANIM_UNWIELD = 12;
	int ANIM_WIELDEDIDLE1 = 13;
	string ANIM_ATTACK1 = "14";
	string ANIM_ATTACK2 = "15";
	int ANIM_IDLE_DELAY_LOW = 0;
	int ANIM_IDLE_DELAY_HIGH = 0;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/dagger/daggermetal1.wav";
	string SOUND_HITWALL2 = "weapons/dagger/daggermetal2.wav";
	string SOUND_DRAW = "weapons/dagger/dagger2.wav";
	string SOUND_SHOUT1 = "SOUND_SHOUT1";
	string SOUND_SHOUT2 = "SOUND_SHOUT2";
	string MELEE_DMG_TYPE = "pierce";
	string MELEE_STAT = "smallarms";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string PLAYERANIM_AIM = "knife";
	string PLAYERANIM_SWING = "swing_knife";
	float MELEE_ENERGY = 0.1f;

	// Variables (an unset .script variable reads as its own name)
	bool SMALLARMS_TURBO_ON = false;

	// weapon_spawn
	void SmallarmsBase_OnWeaponSpawn()
	{
		SetHand("right");

		OnRegisterSecondary(); // adding this so it can be changed externally
	}

	// game_deploy
	void SmallarmsBase_OnGameDeploy()
	{
		OnTurboOff();
	}

	// melee_start
	void SmallarmsBase_OnMeleeStart()
	{
		if (Truthy(GetVar("CUSTOM_SWING")))
			return;

		int anim = Int(MELEE_VIEWANIM_ATK);

		PlayViewAnim(anim);
	}

	// special_02_start
	void SmallarmsBase_OnSpecial02Start()
	{
		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SWORDREADY"));
	}

	// special_02_strike
	void SmallarmsBase_OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		string nextHasteText = ScriptVarOf(ENT_OWNER, "PLR_NEXT_HASTE");
		int nextHaste = Int(nextHasteText);
		if (GameTime() < nextHaste)
		{
			float hasteDelay = nextHaste;
			string hasteDelayText;
			hasteDelay -= GameTime();

			hasteDelayText = Text(int(hasteDelay)) + " s";

			PlayerMessageDark(ENT_OWNER, "Cannot repeat haste attack yet. ( " + hasteDelayText + " )");
			return;
		}

		// Thothie FEB2010_01 - Urdual/smallarms haste exploit prevention
		int urdualCheck = Int(ScriptVarOf(ENT_OWNER, "PLR_URDUAL_RELEASE_TIME"));
		if (!(GameTime() > urdualCheck))
			return;

		float specDuration = Float(LegacyFunction("get_skill_ratio", SkillOf(ENT_OWNER, "smallarms.prof.ratio"), 15, 30));

		ApplyEffect(ENT_OWNER, "effects/specialattack_haste", specDuration, self);
		OnTurboOn();

		CallExternal(ENT_OWNER, "ext_haste_cooldown", specDuration + 35.0f);
	}

	// turbo_on
	void SmallarmsBase_OnTurboOn()
	{
		DebugPrint("turbo_on");

		if (SMALLARMS_TURBO_ON)
			return;
		SMALLARMS_TURBO_ON = true;

		float newMeleeAtkDuration = MELEE_ATK_DURATION;
		float newMeleeDmgDelay = MELEE_DMG_DELAY;
		newMeleeAtkDuration = Divide(newMeleeAtkDuration, 2.0f);
		newMeleeDmgDelay = Divide(newMeleeDmgDelay, 2.0f);
		SetAttackProp(ENT_ME, 0, "delay.strike", newMeleeDmgDelay);
		SetAttackProp(ENT_ME, 0, "delay.end", newMeleeAtkDuration);
	}

	// turbo_off
	void SmallarmsBase_OnTurboOff()
	{
		DebugPrint("turbo_off");

		if (!SMALLARMS_TURBO_ON)
			return;
		SMALLARMS_TURBO_ON = false;

		if (HasEffect(ENT_OWNER, "player_haste"))
			LegacyCommand("removeeffect", ENT_OWNER, "player_haste");

		SetAttackProp(ENT_ME, 0, "delay.strike", MELEE_DMG_DELAY);
		SetAttackProp(ENT_ME, 0, "delay.end", MELEE_ATK_DURATION);
	}

	// register_secondary
	void SmallarmsBase_OnRegisterSecondary()
	{
		if (Truthy(GetVar("CUSTOM_REGISTER_SECONDARY")))
			return;

		// Smallarms speed (200%) - No attack - short speed gain, followed by loss of all stamina
		// ======================================================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		// local reg.attack.energydrain	999999
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.0f);
		SetLocal("reg.attack.delay.end", 1.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);
		SetLocal("reg.attack.dmg.ignore", 1);
		if (Float(GetVar("BASE_LEVEL_REQ")) > 0.0f) // Base level + 4 levels to use this skill
			LegacyCommand("add", "reg.attack.reqskill", GetVar("BASE_LEVEL_REQ"));

		RegisterAttack();
	}

	// bs_global_command
	// player died
	void SmallarmsBase_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		DebugPrint("bs_global_command " + NameOf(deadPlayer) + " vs " + NameOf(ENT_OWNER));
		if (deadPlayer !is EntityOf(ENT_OWNER))
			return;
		CallEventDelayed(1.0f, "turbo_off");
	}

	// activate_items
	void SmallarmsBase_OnActivateItems(string activator = "")
	{
		DebugPrint("activate_items " + NameOf(activator) + " vs " + NameOf(ENT_OWNER));
		if (NameOf(activator) != NameOf(ENT_OWNER))
			return;
		CallEventDelayed(1.0f, "turbo_off");
	}

	// bweapon_effect_remove
	void SmallarmsBase_OnBweaponEffectRemove(string reason = "")
	{
		OnTurboOff();
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
		SmallarmsBase_OnGameDeploy();
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		SmallarmsBase_OnBweaponEffectRemove(reason);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		SmallarmsBase_OnMeleeStart();
	}

	void OnSpecial02Start() { SmallarmsBase_OnSpecial02Start(); } // special_02_start
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { SmallarmsBase_OnSpecial02Strike(hitType, endPos, hitEntity, hit); } // special_02_strike
	void OnTurboOn() { SmallarmsBase_OnTurboOn(); } // turbo_on
	void OnTurboOff() { SmallarmsBase_OnTurboOff(); } // turbo_off
	void OnRegisterSecondary() { SmallarmsBase_OnRegisterSecondary(); } // register_secondary
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "") { SmallarmsBase_OnBsGlobalCommand(deadPlayer, command, reason); } // bs_global_command
	void OnActivateItems(string activator = "") { SmallarmsBase_OnActivateItems(activator); } // activate_items

	// This file's events and timers by their .script names
	bool SmallarmsBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_items") { OnActivateItems(Param(params, 0)); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_secondary") { OnRegisterSecondary(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "turbo_off") { OnTurboOff(); return true; }
		if (name == "turbo_on") { OnTurboOn(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/smallarms_base"]
shared class SmallarmsBaseScript : BaseMeleeScript, SmallarmsBase
{
	// Variables every script that includes this file declares
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	float MELEE_ATK_DURATION = 0.0f;
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	string MELEE_PARRY_CHANCE = "MELEE_PARRY_CHANCE";
	string MELEE_RANGE = "MELEE_RANGE";
	int MODEL_VIEW_IDX = 0;

	// Variables declared by included files, with the value they start with in this script
	SmallarmsBaseScript()
	{
		ANIM_LIFT1 = 9;
		ANIM_IDLE1 = "10";
		ANIM_IDLE_DELAY_LOW = 0;
		ANIM_IDLE_DELAY_HIGH = 0;
		PLAYERANIM_AIM = "knife";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SmallarmsBase_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
