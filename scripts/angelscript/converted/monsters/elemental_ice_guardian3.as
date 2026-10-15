#pragma context server

// Converted from monsters/elemental_ice_guardian3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elemental_ice_guardian.as"

[script "monsters/elemental_ice_guardian3"]
class MonstersElementalIceGuardian3 : MonstersElementalIceGuardianScript
{
	// Constants
	Vector3 OFS_ICE_BALL = Vector3();

	// Variables declared by included files, with the value they start with in this script
	MonstersElementalIceGuardian3()
	{
		ICE_GUARD_NAME = "Greater Ice Guardian";
		ICE_GUARD_HP = 8000;
		ICE_GUARD_LEVEL = 3;
		ICE_GUARD_MODEL = "monsters/ice_guardian2.mdl";
		ICE_GUARD_WIDTH = 48;
		ICE_GUARD_HEIGHT = 120;
		NPC_BASE_EXP = "10000";
		DMG_BURST = 300.0f;
		DMG_LUNGE = 300;
		DMG_STAFF = 200;
		DOT_FROST = 100;
		DOT_SHOCK = 200.0f;
		ATTACK_MOVERANGE_DEF = 256;
		ATTACK_MOVERANGE_AGRO = 70;
		ATTACK_RANGE_DEF = 90;
		ATTACK_HITRANGE_DEF = 120;
		LUNGE_RANGE_MIN = 100;
		LUNGE_RANGE_MAX = 225;
		LUNGE_RANGE_MAX_HITRANGE = 175;
		FREQ_PROJECTILE = 0.0f;
	}

	// unnamed block (first think)
	void MonstersElementalIceGuardian3_FirstThink()
	{
		if (ToLowerCase(MapName()) == "tundra")
		{
			NPC_IS_BOSS = true;
			NPC_EXP_REDUCT = 1.5f; // actually raises XP
		}

		SetDamageTaken("lightning", 0);
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
		if (ToLowerCase(MapName()) != "shender_east")
			return;
		if (!(Float(Eval("game.players.totalhp")) < 3000.0f))
			return;
		CallExternal(GetVar("GAME_MASTER"), "map_shender_east_dream_win");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("firemagic_8bit.spr");
		Precache("monsters/ice_guardian2.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersElementalIceGuardian3_FirstThink();
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
		return MonstersElementalIceGuardianScript::DispatchEvent(name, params);
	}
}
