#pragma context server

// Converted from roghan/crystal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "roghan/crystal"]
class Crystal : BaseNpcScript
{
	// Constants
	string MONSTER_MODEL = "nimble/crystal.mdl";

	// Variables (an unset .script variable reads as its own name)
	string CAN_FLINCH = "CAN_FLINCH";
	string PLAYER_LIST = "PLAYER_LIST";

	// Variables declared by included files, with the value they start with in this script
	Crystal()
	{
		SOUND_DEATH = "monsters/abomination/die.wav";
	}

	// unnamed block (first think)
	void Crystal_FirstThink()
	{
		CAN_FLINCH = "0";
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string Crystal_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		PlayRandomSound(0, 8, "SOUND_PAIN1", "SOUND_PAIN2");
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("a Fire Crystal");
		SetRace("evil");

		SetHealth(100);

		SetModel(MONSTER_MODEL);
		SetWidth(32);
		SetHeight(72);

		SetDamageTaken("all", 0.5f);
		CallEventDelayed(5.0f, "ice_shatter");

		SetBlood("none");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Crystal_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ice_shatter
	void OnIceShatter()
	{
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRemoveIce();
		}
		CallEventDelayed(5.0f, "ice_shatter");
	}

	// remove_ice
	void OnRemoveIce()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		Vector3 targPos = OriginOf(curTarg);
		// if ( $cansee(CUR_TARG) ) dodamage CUR_TARG "direct" .5 100 Crystal fire  //Just working this out for a diff script, REMOVE LATER
		if (HasEffect(curTarg, "iceshield")) // If player has Ice Shield up
		{
			LegacyCommand("removeeffect", curTarg, "iceshield");
			DoDamageEx(targPos, 100, 5, 0, ENT_ME, ENT_ME, "none", "cold_effect");
			PlayerMessageGreen(curTarg, "It found the shield.");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("nimble/crystal.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Crystal_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "ice_shatter") { OnIceShatter(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "remove_ice") { OnRemoveIce(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
