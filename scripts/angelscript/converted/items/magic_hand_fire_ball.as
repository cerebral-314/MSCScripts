#pragma context server

// Converted from items/magic_hand_fire_ball.script by msc_transpiler.
// Stronger fireball added by Thothie
// - No one ever makes it to spell casting 8
// - So I figure we need more spells to help get people there
// - Larger radious than standard fireball + burn effect + greater range

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_fire_ball"]
class MagicHandFireBall : MagicHandBaseScript
{
	// Constants
	int RANGED_FORCE = 1500;
	string RANGED_ATK_DURATION = "1";
	string RANGED_PROJECTILE = "proj_fire_ball";
	string SPELL_DAMAGE_TYPE = "fire";
	int SPELL_MPDRAIN = 5;
	string SPELL_STAT = "spellcasting.fire";
	int MIN_BURN_DAMAGE = 3;
	float MAX_BURN_DAMAGE = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 7;

	// Variables declared by included files, with the value they start with in this script
	MagicHandFireBall()
	{
		ANIM_CAST = "11";
		SOUND_CHARGE = "magic/fireball_powerup.wav";
		SOUND_SHOOT = "magic/fireball_large.wav";
		RANGED_COF = "15;1";
		RANGED_DMG_DELAY = 0.5f;
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 5;
	}

	// unnamed block (first think)
	void MagicHandFireBall_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 7; // the requirement will be 7 - have it at 6 now for testing
	}

	// cast_start
	void OnCastStart()
	{
		MagicHandBase_OnCastStart(); // items/magic_hand_base

		SetVar("baseitem.canidle", 0);
		CallEventDelayed(1.45f, "start_spell_anim");
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Fire ball");
		SetDescription("Burn opponents over a large area");
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
		ServerPlaySound(0, Eval("game.sound.maxvol"), SOUND_SHOOT);
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
		Precache("magic/fireball_powerup.wav");
		Precache("magic/fireball_large.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandFireBall_FirstThink();
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
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "start_spell_anim") { OnStartSpellAnim(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
