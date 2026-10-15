#pragma context server

// Converted from items/magic_hand_fire_dart.script by msc_transpiler.
// Thothie changing RANGED_COF so holding button down actually does something

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_fire_dart"]
class MagicHandFireDart : MagicHandBaseScript
{
	// Constants
	int RANGED_FORCE = 1000;
	string RANGED_ATK_DURATION = "1";
	string RANGED_PROJECTILE = "proj_fire_dart";
	string SPELL_DAMAGE_TYPE = "fire";
	int SPELL_MPDRAIN = 1;
	string SPELL_STAT = "spellcasting.fire";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 0;

	// Variables declared by included files, with the value they start with in this script
	MagicHandFireDart()
	{
		ANIM_CAST = "11";
		SOUND_CHARGE = "magic/fireball_powerup.wav";
		SOUND_SHOOT = "magic/fireball_strike.wav";
		RANGED_COF = "10;1";
		RANGED_DMG_DELAY = 0.5f;
		SPELL_PREPARE_TIME = 4.0f;
		SPELL_ENERGYDRAIN = 5;
	}

	// unnamed block (first think)
	void MagicHandFireDart_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 0;
	}

	// cast_start
	void OnCastStart()
	{
		MagicHandBase_OnCastStart(); // items/magic_hand_base

		SetVar("baseitem.canidle", 0);
		CallEventDelayed(1.65f, "start_spell_anim");
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		// playviewanim  ANIM_FIRE
		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Fire Dart");
		SetDescription("A weak bolt of fire");
	}

	// cast_toss
	// If ranged
	void OnCastToss()
	{
		OnSpellCasted();
		PlayOwnerAnim("critical", PLAYERANIM_CAST, "squatwalk1");
	}

	// start_spell_anim
	void OnStartSpellAnim()
	{
		CallEventDelayed(2.5f, "bitem_set_can_idle");
		PlayViewAnim(12);
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_CHARGE);
		ServerPlaySound(0, 0, SOUND_SHOOT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/fireball_powerup.wav");
		Precache("magic/fireball_strike.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandFireDart_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cast_start") { OnCastStart(); return true; }
		if (name == "cast_toss") { OnCastToss(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "start_spell_anim") { OnStartSpellAnim(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
