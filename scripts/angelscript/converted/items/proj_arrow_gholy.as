#pragma context server

// Converted from items/proj_arrow_gholy.script by msc_transpiler.
// Greater Holy Arrow by Thothie (from Holy Arrow)
// Adds Turn Undead effect +divine light damage

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_gholy"]
class ProjArrowGholy : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int ARROW_STICK_DURATION = 5;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "50%";

	// Variables (an unset .script variable reads as its own name)
	bool DID_HIT = false;

	// Variables declared by included files, with the value they start with in this script
	ProjArrowGholy()
	{
		SPRITE_ARROW_TRADE = "firearrow";
		PROJ_DAMAGE_TYPE = "holy";
		PROJ_DAMAGE = "400";
		ARROW_EXPIRE_DELAY = 5;
	}

	// game_projectile_hitnpc
	// <target> - game_hitnpc doesn't do what ya think it does //Changed from strike_target, as that only goes off with hitscan arrows/bolts greatguys1@August2018
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base

		DebugPrint("strike_target " + NameOf(target));

		if (DID_HIT)
			return;
		DID_HIT = true;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		float holyDmg = SkillOf(ENT_EXPOWNER, "spellcasting.divination") + 5.0f;

		if (holyDmg <= 5.0f)
			holyDmg = 5.0f;

		// multiply HOLY_DMG 2.0
		CallExternal(target, "turn_undead", holyDmg, @myOwner);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Greater Holy Arrow");
		SetDescription("An arrow imbued with fantastic divine energies");
		SetWeight(0.175f);
		SetValue(500);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
