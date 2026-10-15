#pragma context server

// Converted from items/magic_hand_lightning_disc.script by msc_transpiler.
// Ice lance, from the hoarfrost shard. <-- This is a Lightning Disc sir - Dravus

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_lightning_disc"]
class MagicHandLightningDisc : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "0";
	float MELEE_ATK_DURATION = 2.4f;
	string SPELL_DAMAGE_TYPE = "lightning";
	int SPELL_MPDRAIN = 20;
	string SPELL_STAT = "spellcasting.lightning";
	int SPELL_BASE_SPEED = 600;
	int SPELL_SPEED_ADJ = 450;
	float SPELL_BASE_DMG = 0.0f;
	float SPELL_DMG_ADJ = 0.5f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandLightningDisc()
	{
		ANIM_PREPARE = 7;
		ANIM_CAST = "17";
		SOUND_SHOOT = "magic/ice_strike.wav";
		MELEE_DMG_DELAY = 0.5f;
		SPELL_NOISE = 500;
		SPELL_PREPARE_TIME = 1.5f;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"	2: Attack end Position	3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		float speed = SPELL_BASE_SPEED + 0.0f * SPELL_SPEED_ADJ; // get spell speed from charge amt

		float mult = 0.0f * SPELL_DMG_ADJ + 1.0f;

		float dmg = SPELL_BASE_DMG * mult;

		Vector3 vel = RelativeVelocity(ViewAnglesOf(ENT_OWNER), Vector3(0, speed, 0));

		Vector3 pos = EyePositionOf(ENT_OWNER) + Vector3(0, 0, -2);

		// <owner> <vec> <level Cast as> <skill to level>
		CreateNpc("effects/lightning_disc", pos, @EntityOf(ENT_OWNER), vel, dmg, "spellcasting.lightning");
		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Lightning Disc");
		SetDescription("Concentrated lightning that will slice through anything.");
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOOT);
		ServerPlaySound(0, 0, "ambient/alien_frantic.wav");
		ServerPlaySound(0, 0, "magic/bolt_end.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/ice_strike.wav");
		Precache("ambient/alien_frantic.wav");
		Precache("magic/bolt_end.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
