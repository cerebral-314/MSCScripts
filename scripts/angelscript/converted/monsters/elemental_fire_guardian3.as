#pragma context server

// Converted from monsters/elemental_fire_guardian3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elemental_ice_guardian.as"

[script "monsters/elemental_fire_guardian3"]
class MonstersElementalFireGuardian3 : MonstersElementalIceGuardianScript
{
	// Constants
	float FREQ_METEOR = 20.0f;

	// Variables (an unset .script variable reads as its own name)
	int FLAME_JET_DMG = 0;
	int FLAME_JET_DOT = 0;
	int DMG_METEOR = 0;
	int DOT_METEOR = 0;

	// Variables declared by included files, with the value they start with in this script
	MonstersElementalFireGuardian3()
	{
		ICE_GUARD_NAME = "Greater Fire Guardian";
		ICE_GUARD_HP = 8000;
		ICE_GUARD_LEVEL = 3;
		ICE_GUARD_MODEL = "monsters/fire_guardian2.mdl";
		ICE_GUARD_WIDTH = 48;
		ICE_GUARD_HEIGHT = 120;
		NPC_BASE_EXP = "7500";
		DMG_BURST = 300.0f;
		DMG_LUNGE = 300;
		DMG_STAFF = 200;
		DOT_FROST = 200;
		DOT_SHOCK = 200.0f;
		GUARD_ELEMENT = "fire";
		ICE_GUARD_FIRE_VULN = 0.0f;
		ICE_GUARD_DOT_EFFECT = "effects/dot_fire";
		ATTACK_MOVERANGE_DEF = 256;
		ATTACK_MOVERANGE_AGRO = 70;
		ATTACK_RANGE_DEF = 90;
		ATTACK_HITRANGE_DEF = 120;
		LUNGE_RANGE_MIN = 100;
		LUNGE_RANGE_MAX = 225;
		LUNGE_RANGE_MAX_HITRANGE = 175;
		FREQ_SHOCK_STORM = 20.0f;
		FREQ_PROJECTILE = 0.0f;
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		STAFF_ALT_EFFECT = "effects/dot_poison_blind";
		CL_FX_SCRIPT = "monsters/elemental_fire_guardian_cl";
		SOUND_SHOCK_LOOP = "magic/blackhole.wav";
		SOUND_SHOCK_START = "magic/spookie1.wav";
		SOUND_SHOCK_HIT = "bullchicken/bc_bite2.wav";
	}

	// unnamed block (first think)
	void MonstersElementalFireGuardian3_FirstThink()
	{
		if (ToLowerCase(MapName()) == "phobia")
			NPC_IS_BOSS = true;

		SetDamageTaken("acid", 0);
		SetDamageTaken("poison", 0);

		FLAME_JET_DMG = 300;
		FLAME_JET_DOT = 100;

		DMG_METEOR = 750;
		DOT_METEOR = 200;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/sfx_seal");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
		MonstersElementalIceGuardian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/elemental_ice_guardian
		if (ToLowerCase(MapName()) == "phobia")
			CallExternal("all", "bandit_ally_boss_dead");
		if (ToLowerCase(MapName()) == "shender_east")
			CallExternal(GetVar("GAME_MASTER"), "map_shender_east_dream_win");
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
		if (ToLowerCase(MapName()) != "phobia")
			return;
		CallExternal("all", "bandit_ally_fire_spawn");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("firemagic_8bit.spr");
		Precache("monsters/fire_guardian2.mdl");
		Precache("magic/blackhole.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersElementalFireGuardian3_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return MonstersElementalIceGuardianScript::DispatchEvent(name, params);
	}
}
