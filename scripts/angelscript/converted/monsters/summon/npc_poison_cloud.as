#pragma context server

// Converted from monsters/summon/npc_poison_cloud.script by msc_transpiler.
// Poison Cloud by Thothie (from scratch, save smokes, from monsters/summon/summon_lightning_storm)
// - This script removes all occurances of itself at end, therefor, "there can be only one"
// - If you want an NPC to use this, copy to poison_cloud_noc - so player can't 'steal' his cloud

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe2.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class NpcPoisonCloud
{
	// Constants
	string SMOKE_SPRITE = "poison_cloud.spr";
	string SPAWN_SOUND = "ambience/steamburst1.wav";
	string EFFECT_SCRIPT = "effects/dot_poison";
	string AOE_RADIUS = "128";
	string AOE_SCAN_TYPE = "tsphere";
	Vector3 SPRITE_COLOR = Vector3();
	string CHECK_EFFECT = "DOT_poison";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DAMAGE = 0.0f;
	string MY_DURATION = "MY_DURATION";
	string AOE_OWNER = "AOE_OWNER";
	string AOE_DURATION = "AOE_DURATION";

	// game_dynamically_created
	// PARAM1=Owner PARAM2=Angles* PARAM3=Damage PARAM4=Duration [* unused, here for compatability]
	void NpcPoisonCloud_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_BASE_DAMAGE = Float(damage);
		MY_DURATION = skill;

		AOE_OWNER = MY_OWNER;
		AOE_DURATION = MY_DURATION;

		Vector3 myOrg = OriginOf(ENT_ME);
		float myGround = GroundHeight(myOrg);

		if (myOrg.z != myGround)
		{
			myGround += 20.0f;
			myOrg.z += -40.0f;
			if (myOrg.z > myGround)
			{
				DebugPrint("game_dynamically_created adjusting height");
				SetOrigin(ENT_ME, myOrg);
			}
		}

		float clDuration = Float(MY_DURATION);
		clDuration -= 2.5f;
		ClientEvent("new", "all", "monsters/summon/npc_poison_cloud", OriginOf(ENT_ME), SPRITE_COLOR, clDuration); // self removing
	}

	// game_spawn
	void NpcPoisonCloud_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Poison Cloud");
		CallEventDelayed(0.1f, "spawn_sound");
	}

	// spawn_sound
	void NpcPoisonCloud_OnSpawnSound()
	{
		PlaySound(0, 10, SPAWN_SOUND);
	}

	// aoe_affect_target
	void NpcPoisonCloud_OnAoeAffectTarget(string target = "")
	{
		if (HasEffect(target, CHECK_EFFECT))
			return;
		ApplyEffect(target, EFFECT_SCRIPT, 5.0f, MY_OWNER, MY_BASE_DAMAGE);
	}

	// aoe_end
	void NpcPoisonCloud_OnAoeEnd()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe2_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe2
		NpcPoisonCloud_OnGameSpawn(playerRace, playerGender);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseAoe2_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_aoe2
		NpcPoisonCloud_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// aoe_end
	void OnAoeEnd()
	{
		BaseAoe2_OnAoeEnd(); // monsters/summon/base_aoe2
		NpcPoisonCloud_OnAoeEnd();
	}

	void OnSpawnSound() { NpcPoisonCloud_OnSpawnSound(); } // spawn_sound
	void OnAoeAffectTarget(string target = "") { NpcPoisonCloud_OnAoeAffectTarget(target); } // aoe_affect_target

	// This file's events and timers by their .script names
	bool NpcPoisonCloud_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "aoe_affect_target") { OnAoeAffectTarget(Param(params, 0)); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "spawn_sound") { OnSpawnSound(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/npc_poison_cloud"]
shared class NpcPoisonCloudScript : BaseAoe2Script, NpcPoisonCloud
{
	// Variables declared by included files, with the value they start with in this script
	NpcPoisonCloudScript()
	{
		AOE_RADIUS = "128";
		AOE_SCAN_TYPE = "tsphere";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return NpcPoisonCloud_DispatchEvent(name, params)
			|| BaseAoe2Script::DispatchEvent(name, params);
	}
}
