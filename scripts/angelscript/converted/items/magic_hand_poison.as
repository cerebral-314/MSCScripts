#pragma context server

// Converted from items/magic_hand_poison.script by msc_transpiler.
// Poison spell added by Thothie
// - No one ever makes it to spell casting 8
// - So I figure we need more spells to help get people there

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_poison"]
class MagicHandPoison : MagicHandBaseScript
{
	// Constants
	int RANGED_FORCE = 500;
	string RANGED_ATK_DURATION = "0.5";
	string RANGED_PROJECTILE = "proj_poison_spell";
	string SPELL_DAMAGE_TYPE = "poison";
	int SPELL_MPDRAIN = 5;
	string SPELL_STAT = "spellcasting.affliction";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 0;

	// Variables declared by included files, with the value they start with in this script
	MagicHandPoison()
	{
		SOUND_CHARGE = "bullchicken/bc_acid1.wav";
		SOUND_SHOOT = "bullchicken/bc_acid1.wav";
		RANGED_COF = "1";
		RANGED_DMG_DELAY = 0.5f;
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 10;
	}

	// unnamed block (first think)
	void MagicHandPoison_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 0;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Poison");
		SetDescription("Poison - Afflicts your enemies with slow acting poison");
	}

	// cast_start
	void OnCastStart()
	{
		SetGlobal("PASS_SPELL", "poison");

		// dbg Passed Spell PASS_SPELL
		PlayViewAnim(0);
		PlayOwnerAnim("critical", PLAYERANIM_PREPARE, "squatwalk1");
		PlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_CHARGE);
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
		Precache("bullchicken/bc_acid1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandPoison_FirstThink();
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
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
