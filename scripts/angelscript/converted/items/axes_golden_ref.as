#pragma context server

// Converted from items/axes_golden_ref.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesGoldenRef
{
	// Constants
	bool THIS_NO_BREAK = true;
	string BASE_LEVEL_REQ = "15";
	bool CUSTOM_AXE_SECONDARY = true;
	int FINAL_VALUE = 5000;
	string BREAK_SOUND = "debris/bustmetal1.wav";
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
	int MODEL_VIEW_IDX = 1;
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string SOUND_SWIPE = "magic/energy4.wav";
	string MODEL_BODY_OFS = "80";
	string ANIM_PREFIX = "khopesh";
	int BREAK_CHANCE = 2;
	string MELEE_RANGE = "100";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.5f;
	float MELEE_ENERGY = 3.0f;
	int MELEE_DMG = 400;
	int MELEE_DMG_RANGE = 100;
	string MELEE_DMG_TYPE = "holy";
	string MELEE_ACCURACY = "24%";
	string MELEE_STAT = "axehandling";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "25%";

	// Variables (an unset .script variable reads as its own name)
	int SPEC_ATTACK = 0;
	bool BROKEN = false;
	float HOLY_DMG = 0.0f;

	// weapon_spawn
	void AxesGoldenRef_OnWeaponSpawn()
	{
		SetName("Unbreakable Golden Axe");
		SetHudSprite("trade", "110");

		SetDescription("A holy axe, forged by the dwarves of Urdual");
		SetWeight(90);
		SetValue(FINAL_VALUE);
		SetHand("both");
	}

	// game_spawn
	void AxesGoldenRef_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 90);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		LegacyCommand("multiply", "reg.attack.dmg", 8);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.aoe.range", 100);
		SetLocal("reg.attack.aoe.falloff", 1.5f);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		LegacyCommand("add", "reg.attack.hitchance", "10%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.7f);
		SetLocal("reg.attack.delay.end", 2.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// special_02_start
	void AxesGoldenRef_OnSpecial02Start()
	{
		SPEC_ATTACK = 1;

		PlaySound(0, 10, "magic/energy1.wav");
	}

	// special_02_strike
	void AxesGoldenRef_OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		// dbg temp breakcheck spec2
		OnBreakCheck();
	}

	// hitwall
	void AxesGoldenRef_OnHitwall()
	{
		// //dbg temp breakcheck hitwall
		if (BROKEN)
			return;
		OnBreakCheck();
	}

	// melee_start
	void AxesGoldenRef_OnMeleeStart()
	{
		SPEC_ATTACK = 0;
	}

	// melee_strike
	void AxesGoldenRef_OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		CBaseEntity@ targetId = TargetOf(ENT_OWNER);
		if (!IsAlive(targetId))
			return;
		OnBreakCheck();
		if (BROKEN)
			return;
		float wackingRace = DamageTakenOf(targetId, "holy");
		// if ( WACKING_RACE equals undead ) local VALID_TARGET 1
		// if ( WACKING_RACE equals demon ) local VALID_TARGET 1
		// if ( $get(TARGET_ID,takedmg,holy) > 0 ) local VALID_TARGET 1 //future use
		if (wackingRace != 0.0f)
			return;
		// if !VALID_TARGET
		OwnerMessage("This weapon is only effective against the undead and unholy");
	}

	// break_check
	void AxesGoldenRef_OnBreakCheck()
	{
		if (THIS_NO_BREAK)
			return;
		if (BROKEN)
			return;

		if (!(RandomInt(1, 100) < BREAK_CHANCE))
			return;
		BROKEN = true;
		SetViewModel("none");
		PlaySound(0, 10, BREAK_SOUND);
		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 0.3f, 30, 10, 5, 1.0f);
		OwnerMessage("YOUR GOLDEN AXE HAS BROKEN!");
		CallEventDelayed(0.2f, "break_msg2");
	}

	// break_msg2
	void AxesGoldenRef_OnBreakMsg2()
	{
		OwnerMessage("You might want to ask the mayor of Gatecity about this.");
		CreateNpc("monsters/companion/giver", Vec(LegacyFunction("replos", 0, 0, 32)), @EntityOf(ENT_OWNER), "item_gaxe_handle");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void AxesGoldenRef_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string AxesGoldenRef_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (SPEC_ATTACK == 0)
			return result;
		SPEC_ATTACK = 0;
		// if $get(MY_TARGET,range) < MELEE_RANGE
		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		// dbg calling against $get(MY_TARGET,name)
		HOLY_DMG = SkillOf(ENT_OWNER, "spellcasting.divination") * 8.0f; // was 15x - but turn_undead used to not do holy damage (for some reason)
		CallExternal(target, "turn_undead", HOLY_DMG, @myOwner);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		AxesBaseTwohanded_OnGameSpawn(playerRace, playerGender); // items/axes_base_twohanded
		AxesBaseTwohanded_OnGameSpawn_2(playerRace, playerGender); // items/axes_base_twohanded
		AxesGoldenRef_OnGameSpawn(playerRace, playerGender);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesGoldenRef_OnWeaponSpawn();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesGoldenRef_OnMeleeStart();
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee
		AxesGoldenRef_OnHitwall();
	}

	// special_02_start
	void OnSpecial02Start()
	{
		AxesBaseTwohanded_OnSpecial02Start(); // items/axes_base_twohanded
		AxesGoldenRef_OnSpecial02Start();
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		AxesBaseTwohanded_OnSpecial02Strike(hitType, endPos, hitEntity, hit); // items/axes_base_twohanded
		AxesGoldenRef_OnSpecial02Strike(hitType, endPos, hitEntity, hit);
	}

	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { AxesGoldenRef_OnMeleeStrike(hitType, endPos, hitEntity, hit); } // melee_strike
	void OnBreakCheck() { AxesGoldenRef_OnBreakCheck(); } // break_check
	void OnBreakMsg2() { AxesGoldenRef_OnBreakMsg2(); } // break_msg2
	void OnRemoveMe(string caller = "") { AxesGoldenRef_OnRemoveMe(caller); } // remove_me
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesGoldenRef_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// This file's events and timers by their .script names
	bool AxesGoldenRef_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "break_check") { OnBreakCheck(); return true; }
		if (name == "break_msg2") { OnBreakMsg2(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_golden_ref"]
shared class AxesGoldenRefScript : AxesBaseTwohandedScript, AxesGoldenRef
{
	// Variables declared by included files, with the value they start with in this script
	AxesGoldenRefScript()
	{
		BASE_LEVEL_REQ = "15";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 1;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		SOUND_SWIPE = "magic/energy4.wav";
		MODEL_BODY_OFS = "80";
		ANIM_PREFIX = "khopesh";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 400;
		MELEE_DMG_RANGE = 100;
		MELEE_DMG_TYPE = "holy";
		MELEE_ACCURACY = "24%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesGoldenRef_DispatchEvent(name, params)
			|| AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
