#pragma context server

// Converted from monsters/elemental_ice_guardian2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elemental_ice_guardian.as"

[script "monsters/elemental_ice_guardian2"]
class MonstersElementalIceGuardian2 : MonstersElementalIceGuardianScript
{
	// Variables declared by included files, with the value they start with in this script
	MonstersElementalIceGuardian2()
	{
		ICE_GUARD_NAME = "Ice Guardian";
		ICE_GUARD_HP = 6000;
		ICE_GUARD_LEVEL = 2;
		NPC_BASE_EXP = "3000";
		DMG_BURST = 200.0f;
		DMG_LUNGE = 250;
		DMG_STAFF = 150;
		DOT_FROST = 75;
		ATTACK_MOVERANGE_DEF = 200;
	}

	// unnamed block (first think)
	void MonstersElementalIceGuardian2_FirstThink()
	{
		if (ToLowerCase(MapName()) == "tundra")
		{
			NPC_IS_BOSS = true;
			NPC_EXP_REDUCT = 1.5f; // actually raises XP
		}
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
		MonstersElementalIceGuardian2_FirstThink();
		MonstersElementalIceGuardian_FirstThink();
		MonstersElementalIceGuardian_FirstThink2();
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
		return MonstersElementalIceGuardianScript::DispatchEvent(name, params);
	}
}
