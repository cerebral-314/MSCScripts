#pragma context server

// Converted from items/magic_hand_ice_lance.script by msc_transpiler.
// Ice lance, from the hoarfrost shard.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_ice_lance"]
class MagicHandIceLance : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "0";
	float MELEE_ATK_DURATION = 1.0f;
	int RANGED_FORCE = 800;
	string RANGED_PROJECTILE = "proj_icelance";
	int SPELL_DAMAGE = 400;
	int SPELL_MPDRAIN = 15;
	string SPELL_STAT = "spellcasting.ice";

	// Variables declared by included files, with the value they start with in this script
	MagicHandIceLance()
	{
		ANIM_PREPARE = 7;
		ANIM_CAST = "17";
		SOUND_SHOOT = "magic/ice_strike.wav";
		MELEE_DMG_DELAY = 0.5f;
		SPELL_NOISE = 500;
		SPELL_PREPARE_TIME = 1.5f;
	}

	// spell_casted
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none>
		CallExternal(ENT_OWNER, "ext_tossprojectile", RANGED_PROJECTILE, "view", "none", RANGED_FORCE, SPELL_DAMAGE, 0, "spellcasting.ice");
		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Ice Lance");
		SetDescription("Fires deep freezing icicles.");
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOOT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/ice_strike.wav");
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
