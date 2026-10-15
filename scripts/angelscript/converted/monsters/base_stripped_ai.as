#pragma context server

// Converted from monsters/base_stripped_ai.script by msc_transpiler.
// often building mobs with no AI, that need common functions - collected here

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_self_adjust.as"
#include "converted/monsters/externals.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseStrippedAi
{
	// Variables (an unset .script variable reads as its own name)
	bool NPC_DID_DEATH = false;
	bool IN_ICECAGE = false;
	bool NPC_GAVE_XP_MSG = false;

	// game_spawn
	void BaseStrippedAi_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(1.0f, "npc_post_spawn");
	}

	// game_death
	void BaseStrippedAi_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_DID_DEATH)
			return;
		NPC_DID_DEATH = true;

		// DEC2010_03 - death tracker
		if (Truthy(GetVar("G_APRIL_FOOLS_MODE")))
			CallExternal(GetVar("GAME_MASTER"), "gm_april_fools_spawn_add", OriginOf(ENT_ME));

		if (NPC_SUMMON)
		{
			LegacyCommand("subtract", "G_NPC_SUMMON_COUNT", 1);
			if (Float(GetVar("G_NPC_SUMMON_COUNT")) < 0.0f) // not sure how this is happening - death getting called twice, or something
				SetGlobal("G_NPC_SUMMON_COUNT", 0);
			DebugPrint("game_death_summoned " + GetVar("G_NPC_SUMMON_COUNT"));
		}

		// from base_monster_shared
		SetFly(false); // Thothie - if it flies, its flying days are over

		// from monsters/externals
		if (EXT_FADE_ON_DEATH && MyMaxHealth() < 1000.0f)
			CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);

		SetAnimFrameRate(Float(BASE_FRAMERATE));
		SetAnimMoveSpeed(BASE_MOVESPEED);

		if (IN_ICECAGE)
		{
			// if ( $get(SCRIPT_ICECAGE,exists) ) deleteent SCRIPT_ICECAGE
			ClientEvent("update", "all", "SCRIPT_ICECAGE", "end_cage_fx");
			// playsound 0 5 debris/bustglass2.wav
			IN_ICECAGE = false;
		}

		if (NPC_CRITICAL)
		{
			// siege system
			string infoTitle = "A CRITICAL NPC HAS DIED!";
			string infoMsg = NameOf(ENT_ME) + " has been slain! ";
			InfoMessage("all", infoTitle, infoMsg);
			CallExternal(GetVar("GAME_MASTER"), "gm_crit_npc_died", self, @EntityOf(ENT_LASTSTRUCK));
		}

		// if ( IN_ICECAGE ) setanim.framerate OLD_FRAMERATE
		OnNpcDeath();

		// ye old standard base_npc

		ClearEffects();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseStrippedAi_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseStrippedAi_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0) {} // bm_gold_spew
	void OnNpcDeath() {} // npc_death
	void OnNpcatkAlertAllAllies(string attacker = "") {} // npcatk_alert_all_allies

	// This file's events and timers by their .script names
	bool BaseStrippedAi_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_stripped_ai"]
shared class BaseStrippedAiScript : MonstersExternalsScript, BaseStrippedAi, BaseSelfAdjust
{
	// Variables every script that includes this file declares
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_IDLE = "ANIM_IDLE";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_PAIN1 = "SOUND_PAIN1";
	string SOUND_PAIN2 = "SOUND_PAIN2";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseStrippedAi_DispatchEvent(name, params)
			|| BaseSelfAdjust_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
