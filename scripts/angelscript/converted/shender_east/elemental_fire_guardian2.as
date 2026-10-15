#pragma context server

// Converted from shender_east/elemental_fire_guardian2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/shender_east/elemental_ice_guardian.as"

[script "shender_east/elemental_fire_guardian2"]
class ShenderEastElementalFireGuardian2 : ShenderEastElementalIceGuardianScript
{
	// Constants
	int DMG_FIRE_BURST = 200;

	// Variables (an unset .script variable reads as its own name)
	int FLAME_JET_DMG = 0;
	int FLAME_JET_DOT = 0;
	bool BE_AGRESSIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ShenderEastElementalFireGuardian2()
	{
		ICE_GUARD_NAME = "Nightmare of Fire";
		ICE_GUARD_HP = 3000;
		ICE_GUARD_ICE_VULN = 0.5f;
		ICE_GUARD_FIRE_VULN = 0.0f;
		ICE_GUARD_LEVEL = 2;
		ICE_GUARD_MODEL = "monsters/fire_guardian.mdl";
		NPC_BASE_EXP = "1000";
		DMG_BURST = 100.0f;
		DMG_LUNGE = 125;
		DMG_STAFF = 75;
		DOT_FROST = 75;
		GUARD_ELEMENT = "fire";
		ICE_GUARD_DOT_EFFECT = "effects/dot_fire";
		ATTACK_MOVERANGE_DEF = 200;
		CL_FX_SCRIPT = "monsters/elemental_fire_guardian_cl";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	}

	// unnamed block (first think)
	void ShenderEastElementalFireGuardian2_FirstThink()
	{
		FLAME_JET_DMG = 100;
		FLAME_JET_DOT = 50;

		if (ToLowerCase(MapName()) != "shender_east")
			return;
		BE_AGRESSIVE = true;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/sfx_seal");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("explode1.spr");
		Precache("xfireball3.spr");
		Precache("firemagic_8bit.spr");
		Precache("monsters/fire_guardian.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShenderEastElementalFireGuardian2_FirstThink();
		ShenderEastElementalIceGuardian_FirstThink();
		ShenderEastElementalIceGuardian_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return ShenderEastElementalIceGuardianScript::DispatchEvent(name, params);
	}
}
