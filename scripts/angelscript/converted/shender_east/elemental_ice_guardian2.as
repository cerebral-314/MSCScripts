#pragma context server

// Converted from shender_east/elemental_ice_guardian2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/shender_east/elemental_ice_guardian.as"

[script "shender_east/elemental_ice_guardian2"]
class ShenderEastElementalIceGuardian2 : ShenderEastElementalIceGuardianScript
{
	// Variables (an unset .script variable reads as its own name)
	bool BE_AGRESSIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ShenderEastElementalIceGuardian2()
	{
		ICE_GUARD_NAME = "Nightmare of Ice";
		ICE_GUARD_HP = 3000;
		ICE_GUARD_FIRE_VULN = 0.5f;
		ICE_GUARD_LEVEL = 2;
		NPC_BASE_EXP = "1500";
		DMG_BURST = 100.0f;
		DMG_LUNGE = 125;
		DMG_STAFF = 75;
		DOT_FROST = 35;
		ATTACK_MOVERANGE_DEF = 200;
	}

	// unnamed block (first think)
	void ShenderEastElementalIceGuardian2_FirstThink()
	{
		if (ToLowerCase(MapName()) == "tundra")
		{
			NPC_IS_BOSS = true;
			NPC_EXP_REDUCT = 1.5f; // actually raises XP
		}

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
		Precache("firemagic_8bit.spr");
		Precache("monsters/ice_guardian.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShenderEastElementalIceGuardian2_FirstThink();
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
