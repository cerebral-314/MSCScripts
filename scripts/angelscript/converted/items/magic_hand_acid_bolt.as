#pragma context server

// Converted from items/magic_hand_acid_bolt.script by msc_transpiler.
// Poison spell added by Thothie
// - No one ever makes it to spell casting 8
// - So I figure we need more spells to help get people there

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_acid_bolt"]
class MagicHandAcidBolt : MagicHandBaseScript
{
	// Constants
	int RANGED_FORCE = 800;
	string RANGED_ATK_DURATION = "0.5";
	string RANGED_PROJECTILE = "proj_acid_bolt";
	string SPELL_DAMAGE_TYPE = "acid";
	int SPELL_MPDRAIN = 10;
	string SPELL_STAT = "spellcasting.affliction";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 15;

	// Variables declared by included files, with the value they start with in this script
	MagicHandAcidBolt()
	{
		ANIM_CAST = "11";
		SOUND_CHARGE = "bullchicken/bc_attack1.wav";
		SOUND_SHOOT = "bullchicken/bc_attack3.wav";
		RANGED_COF = "1";
		RANGED_DMG_DELAY = 0.25f;
		SPELL_PREPARE_TIME = 0.5f;
	}

	// unnamed block (first think)
	void MagicHandAcidBolt_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 15;

		PrecacheFile("items/magic_hand_base");
	}

	// cast_start
	void OnCastStart()
	{
		MagicHandBase_OnCastStart(); // items/magic_hand_base

		SetVar("baseitem.canidle", 0);
		CallEventDelayed(Float(RANGED_ATK_DURATION) + RANGED_DMG_DELAY + 0.75f, "start_spell_anim");
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		ServerPlaySound(0, 10, SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Acidic Bolt");
		SetDescription("Fires a bolt of corrosive bile");
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
		CallEventDelayed(2.0f, "bitem_set_can_idle");
		PlayViewAnim(13);
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
		Precache("bullchicken/bc_attack1.wav");
		Precache("bullchicken/bc_attack3.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandAcidBolt_FirstThink();
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
