#pragma context server

// Converted from items/magic_hand_summon_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MagicHandSummonBase
{
	// Constants
	string SPELL_NAME = "Some Spell";
	string SPELL_DESC = "Some Description";
	string SOUND_SHOOT = "magic/cast.wav";
	string MELEE_RANGE = "200";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	float SPELL_PREPARE_TIME = 2.0f;
	string SPELL_DAMAGE_TYPE = "summon";
	int SPELL_ENERGYDRAIN = 20;
	int SPELL_MPDRAIN = 1;
	string SPELL_STAT = "none";
	int EFFECT_MAXDURATION = 180;
	float EFFECT_MINDURATION = 10.0f;
	float EFFECT_DURATION_STAT = 0.0f;
	string EFFECT_DURATION = "EFFECT_DURATION";
	int EFFECT_MAX_DMG = 10;
	float EFFECT_MIN_DMG = 0.1f;
	float EFFECT_DMG = 0.0f;
	string EFFECT_SCRIPT = "EFFECT_SCRIPT needs to be defined!";

	// unnamed block (first think)
	void MagicHandSummonBase_FirstThink()
	{
		PrecacheFile(EFFECT_SCRIPT);
	}

	// spell_spawn
	void MagicHandSummonBase_OnSpellSpawn()
	{
		SetName(SPELL_NAME);
		SetDescription(SPELL_NAME);
	}

	// cast_start
	void MagicHandSummonBase_OnCastStart()
	{
		SetVar("baseitem.canidle", 0);
		OnStartSpellAnim();
	}

	// cast_toss
	// If ranged
	void MagicHandSummonBase_OnCastToss()
	{
		OnSpellCasted();
		PlayOwnerAnim("critical", PLAYERANIM_CAST, "squatwalk1");
	}

	// start_spell_anim
	void MagicHandSummonBase_OnStartSpellAnim()
	{
		CallEventDelayed(1.1f, "bitem_set_can_idle");
		PlayViewAnim(16);
	}

	// summon_check
	// <origin>
	void MagicHandSummonBase_OnSummonCheck(string spawnPosition = "")
	{
		// setsolid ent_owner none
		SetLocal("reg.npcmove.endpos", spawnPosition);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", "z", 16);
		SetLocal("reg.npcmove.testonly", 0);
		LegacyCommand("npcmove", ENT_LASTCREATED, "none"); // $get(ent_owner,id)

		// setsolid ent_owner slidebox
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			OwnerMessage("You cannot summon here");
			DeleteEntity(ENT_LASTCREATED);
			// subtract CURRENT_SUMMONS 1
			// dbg CurSums CURRENT_SUMMONS max MAX_SUMMONS
			GiveMana(ENT_OWNER, SPELL_MPDRAIN);
			if (Truthy(GetVar("SUMMON_UNQIUE")))
				CallExternal(ENT_OWNER, "ext_unsummon_unique", GetVar("SUMMON_UNIQUE_TAG"));
		}
		else
		{
			LegacyCommand("add", "CURRENT_SUMMONS", 1);
			LegacyCommand("drop_to_floor", ENT_LASTCREATED);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// cast_start
	void OnCastStart()
	{
		MagicHandBase_OnCastStart(); // items/magic_hand_base
		MagicHandSummonBase_OnCastStart();
	}

	void OnSpellSpawn() { MagicHandSummonBase_OnSpellSpawn(); } // spell_spawn
	void OnCastToss() { MagicHandSummonBase_OnCastToss(); } // cast_toss
	void OnStartSpellAnim() { MagicHandSummonBase_OnStartSpellAnim(); } // start_spell_anim
	void OnSummonCheck(string spawnPosition = "") { MagicHandSummonBase_OnSummonCheck(spawnPosition); } // summon_check

	// This file's events and timers by their .script names
	bool MagicHandSummonBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cast_start") { OnCastStart(); return true; }
		if (name == "cast_toss") { OnCastToss(); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "start_spell_anim") { OnStartSpellAnim(); return true; }
		if (name == "summon_check") { OnSummonCheck(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/magic_hand_summon_base"]
shared class MagicHandSummonBaseScript : MagicHandBaseScript, MagicHandSummonBase
{
	// Variables every script that includes this file declares
	int SPELL_SKILL_REQUIRED = 0;

	// Variables declared by included files, with the value they start with in this script
	MagicHandSummonBaseScript()
	{
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 20;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandSummonBase_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MagicHandSummonBase_DispatchEvent(name, params)
			|| MagicHandBaseScript::DispatchEvent(name, params);
	}
}
