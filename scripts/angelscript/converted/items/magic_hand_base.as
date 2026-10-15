#pragma context server

// Converted from items/magic_hand_base.script by msc_transpiler.
// Required skill is not set in the magic hand. The scrolls and tomes determine that.
// Needs:
// MELEE_RANGE, MELEE_HITCHANCE, MELEE_ATK_DURATION
// SPELL_PREPARE_TIME, SPELL_DAMAGE_TYPE, SPELL_ENERGYDRAIN, SPELL_MPDRAIN, SPELL_STAT
// * defunct

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MagicHandBase
{
	// Constants
	int ANIM_LIFT1 = 7;
	int ANIM_PREPARE = 9;
	int ANIM_PREPARE_IDLE = 11;
	string ANIM_CAST = "12";
	string ANIM_IDLE1 = "ANIM_IDLE1";
	int ANIM_IDLE_TOTAL = 1;
	int ANIM_IDLE_DELAY_LOW = 0;
	int ANIM_IDLE_DELAY_HIGH = 0;
	string MODEL_VIEW = "viewmodels/v_martialarts.mdl";
	string MODEL_HANDS = "none";
	string MODEL_WORLD = "none";
	string SOUND_CHARGE = "none";
	string SOUND_SHOOT = "magic/cast.wav";
	int SPELL_NOISE = 650;
	int SPELL_ENERGYDRAIN = 0;
	float SPELL_PREPARE_TIME = 5.5f;
	string RANGED_TYPE = "charge-throw-projectile";
	float RANGED_DMG_DELAY = 0.4f;
	string RANGED_HOLD_MINMAX = "2;2";
	string RANGED_COF = "0;0";
	string MELEE_TYPE = "target";
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG = 0;
	int MELEE_DMG_RANGE = 0;
	bool MELEE_NOAUTOAIM = false;
	string PLAYERANIM_AIM = "fireball";
	string PLAYERANIM_PREPARE = "prepare_fireball";
	string PLAYERANIM_CAST = "throw_fireball";
	string SCRIPT_SFX_PREP = "items/magic_hand_base_cl";

	// Variables (an unset .script variable reads as its own name)
	bool IS_MAGIC_HAND = true;
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";

	// unnamed block (first think)
	void MagicHandBase_FirstThink()
	{
		IS_MAGIC_HAND = true;
	}

	// game_precache
	void MagicHandBase_OnGamePrecache()
	{
		PrecacheFile(SCRIPT_SFX_PREP);
	}

	// game_spawn
	void MagicHandBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWeight(0);
		SetAnimExtension(PLAYERANIM_AIM);
		SetHand("both");
		SetHudSprite("hand", "bow");
		SetHudSprite("trade", "firemagic");

		OnSpellSpawn();
		OnSetupAttack();
		OnSetupSpell();
	}

	// game_deploy
	void MagicHandBase_OnGameDeploy()
	{
		ClientEvent("new", "all", SCRIPT_SFX_PREP, IndexOf(ENT_OWNER), SPELL_PREPARE_TIME);
		SetVar("spell.prepscript.id", LastClientScriptId());

		SetViewModel(MODEL_VIEW);
		PlayOwnerAnim("once", PLAYERANIM_PREPARE, "global.anim.combatwalk", SPELL_PREPARE_TIME);
		PlayViewAnim(ANIM_PREPARE);
		SetVar("baseitem.canidle", 0);

		OnSpellDeploy();
	}

	// game_switchhands
	void MagicHandBase_OnGameSwitchhands()
	{
		// playviewanim  ANIM_IDLE1
		OnItemSwitchhands();
	}

	// game_pickup
	void MagicHandBase_OnGamePickup()
	{
		// playviewanim  ANIM_PREPARE1
		OnItemSwitchhands();
	}

	// game_removefromowner
	void MagicHandBase_OnGameRemovefromowner()
	{
		ClientEvent("remove", "all", "spell.prepscript.id");
	}

	// setup_attack
	void MagicHandBase_OnSetupAttack()
	{
		// Weapon properties
		if (GetVar("MELEE_RANGE") != "MELEE_RANGE")
		{
			SetLocal("reg.attack.type", MELEE_TYPE);
			SetLocal("reg.attack.range", GetVar("MELEE_RANGE"));
			SetLocal("reg.attack.dmg", MELEE_DMG);
			SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
			SetLocal("reg.attack.dmg.type", GetVar("SPELL_DAMAGE_TYPE"));
			SetLocal("reg.attack.hitchance", GetVar("MELEE_HITCHANCE"));
			SetLocal("reg.attack.priority", 1);
			SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
			SetLocal("reg.attack.delay.end", GetVar("MELEE_ATK_DURATION"));
			SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
			SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		}
		else
		{
			SetLocal("reg.attack.type", "charge-throw-projectile");
			SetLocal("reg.attack.hold_min&max", RANGED_HOLD_MINMAX);
			SetLocal("reg.attack.dmg.type", GetVar("SPELL_DAMAGE_TYPE"));
			SetLocal("reg.attack.range", GetVar("RANGED_FORCE"));
			SetLocal("reg.attack.COF", RANGED_COF);
			SetLocal("reg.attack.projectile", GetVar("RANGED_PROJECTILE"));
			SetLocal("reg.attack.priority", 0);
			SetLocal("reg.attack.delay.strike", RANGED_DMG_DELAY);
			SetLocal("reg.attack.delay.end", GetVar("RANGED_ATK_DURATION"));
			SetLocal("reg.attack.ofs.startpos", "RANGED_STARTPOS");
			SetLocal("reg.attack.ofs.aimang", "RANGED_AIMANGLE");
			SetLocal("reg.attack.ammodrain", 0);
		}

		SetLocal("reg.attack.keys", "+attack1");
		// local reg.attack.dmg.ignore	1
		SetLocal("reg.attack.noise", SPELL_NOISE);
		SetLocal("reg.attack.energydrain", SPELL_ENERGYDRAIN);
		SetLocal("reg.attack.mpdrain", GetVar("SPELL_MPDRAIN"));
		SetLocal("reg.attack.stat", GetVar("SPELL_STAT"));
		SetLocal("reg.attack.callback", "cast");
		SetLocal("reg.attack.noautoaim", MELEE_NOAUTOAIM);

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";

		if (!Truthy(GetVar("NO_REGISTER")))
			RegisterAttack();
	}

	// setup_spell
	void MagicHandBase_OnSetupSpell()
	{
		// Spell properties
		SetLocal("reg.spell.reqskill", GetVar("SPELL_SKILL_REQUIRED"));
		SetLocal("reg.spell.fizzletime", 9999999); // Practically no fizzle time. fizzle time is not fun.
		SetLocal("reg.spell.castsuccess", 100); // SPELL_CAST_SUCCESS - JAN2010_12 screw this spell failure crap
		SetLocal("reg.spell.preparetime", SPELL_PREPARE_TIME);

		LegacyCommand("registerspell");
	}

	// game_prepare_success
	// Spell preparation
	// ---------------------------
	void MagicHandBase_OnGamePrepareSuccess()
	{
		CallEventDelayed(SPELL_PREPARE_TIME, "prepare_success_done");
	}

	// prepare_success_done
	void MagicHandBase_OnPrepareSuccessDone()
	{
		SetVar("baseitem.canidle", 1);
		OnSpellPrepareSuccess();
	}

	// spell_prepare_success
	void MagicHandBase_OnSpellPrepareSuccess()
	{
	}

	// cast_start
	// ---------------------------
	void MagicHandBase_OnCastStart()
	{
		PlayViewAnim(Int(ANIM_CAST));
		PlayOwnerAnim("critical", PLAYERANIM_PREPARE, "squatwalk1");
		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_CHARGE);
	}

	// cast_strike
	// If melee
	void MagicHandBase_OnCastStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		OnSpellCasted(hitType, endPos, hitEntity);
	}

	// cast_toss
	// If ranged
	void MagicHandBase_OnCastToss()
	{
		OnSpellCasted();
		PlayOwnerAnim("critical", PLAYERANIM_CAST, "squatwalk1");
	}

	// cast_end
	void MagicHandBase_OnCastEnd()
	{
	}

	// spell_end
	void MagicHandBase_OnSpellEnd()
	{
		OwnerMessage("The spell's duration ends.");
		OnBweaponEffectRemove();
		DeleteMe();
	}

	// spell_casted
	void MagicHandBase_OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		CallExternal(ENT_OWNER, "mana_drain");
	}

	// game_fall
	void MagicHandBase_OnGameFall()
	{
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { MagicHandBase_OnGamePrecache(); } // game_precache

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		MagicHandBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		MagicHandBase_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		MagicHandBase_OnGameDeploy();
	}

	// game_pickup
	void OnGamePickup()
	{
		BaseItem_OnGamePickup(); // items/base_item
		MagicHandBase_OnGamePickup();
	}

	// game_switchhands
	void OnGameSwitchhands()
	{
		BaseItem_OnGameSwitchhands(); // items/base_item
		MagicHandBase_OnGameSwitchhands();
	}

	void OnGameRemovefromowner() { MagicHandBase_OnGameRemovefromowner(); } // game_removefromowner
	void OnSetupAttack() { MagicHandBase_OnSetupAttack(); } // setup_attack
	void OnSetupSpell() { MagicHandBase_OnSetupSpell(); } // setup_spell
	void OnGamePrepareSuccess() { MagicHandBase_OnGamePrepareSuccess(); } // game_prepare_success
	void OnPrepareSuccessDone() { MagicHandBase_OnPrepareSuccessDone(); } // prepare_success_done
	void OnSpellPrepareSuccess() { MagicHandBase_OnSpellPrepareSuccess(); } // spell_prepare_success
	void OnCastStart() { MagicHandBase_OnCastStart(); } // cast_start
	void OnCastStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { MagicHandBase_OnCastStrike(hitType, endPos, hitEntity, hit); } // cast_strike
	void OnCastToss() { MagicHandBase_OnCastToss(); } // cast_toss
	void OnCastEnd() { MagicHandBase_OnCastEnd(); } // cast_end
	void OnSpellEnd() { MagicHandBase_OnSpellEnd(); } // spell_end
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null) { MagicHandBase_OnSpellCasted(hitType, endPosition, target); } // spell_casted
	void OnSpellPrepareTime() {} // SPELL_PREPARE_TIME
	void OnSpellDeploy() {} // spell_deploy
	void OnSpellSpawn() {} // spell_spawn

	// This file's events and timers by their .script names
	bool MagicHandBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cast_end") { OnCastEnd(); return true; }
		if (name == "cast_start") { OnCastStart(); return true; }
		if (name == "cast_strike") { OnCastStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "cast_toss") { OnCastToss(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_prepare_success") { OnGamePrepareSuccess(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "prepare_success_done") { OnPrepareSuccessDone(); return true; }
		if (name == "setup_attack") { OnSetupAttack(); return true; }
		if (name == "setup_spell") { OnSetupSpell(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_end") { OnSpellEnd(); return true; }
		if (name == "spell_prepare_success") { OnSpellPrepareSuccess(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/magic_hand_base"]
shared class MagicHandBaseScript : BaseItemScript, MagicHandBase
{
	// Variables declared by included files, with the value they start with in this script
	MagicHandBaseScript()
	{
		ANIM_LIFT1 = 7;
		ANIM_IDLE1 = "ANIM_IDLE1";
		ANIM_IDLE_DELAY_LOW = 0;
		ANIM_IDLE_DELAY_HIGH = 0;
		PLAYERANIM_AIM = "fireball";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MagicHandBase_DispatchEvent(name, params)
			|| BaseItemScript::DispatchEvent(name, params);
	}
}
