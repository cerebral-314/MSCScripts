#pragma context server

// Converted from monsters/summon/npc_poison_cloud_old.script by msc_transpiler.
// Poison Cloud by Thothie (from scratch, save smokes, from monsters/summon/summon_lightning_storm)
// - This script removes all occurances of itself at end, therefor, "there can be only one"
// - If you want an NPC to use this, copy to poison_cloud_noc - so player can't 'steal' his cloud

#include "runtime/ScriptEntity.as"

[script "monsters/summon/npc_poison_cloud_old"]
class NpcPoisonCloudOld : ScriptEntity
{
	// Constants
	string SMOKE_SPRITE = "poison_cloud.spr";
	string SPAWN_SOUND = "ambience/steamburst1.wav";
	string DAMAGE_TYPE = "poison";
	string EFFECT_SCRIPT = "effects/dot_poison";
	int HEIGHT = 40;
	int WIDTH = 96;
	int SCAN_RANGE = 128;

	// Variables (an unset .script variable reads as its own name)
	bool POISONING = false;
	bool STORMING = false;
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DAMAGE = 0.0f;
	string MY_DURATION = "MY_DURATION";
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string TARG_LIST = "TARG_LIST";

	// unnamed block (first think)
	void NpcPoisonCloudOld_FirstThink()
	{
		POISONING = true;
	}

	// smokes_start
	// Start shooting
	void NpcPoisonCloudOld_OnSmokesStart()
	{
		STORMING = true;
	}

	// unnamed block (timer)
	// EFFECTS STUFF from monsters/summon/summon_lightning_storm
	void NpcPoisonCloudOld_Timer()
	{
		CallEventDelayed(1.0f, "NpcPoisonCloudOld_Timer");
		if (!STORMING)
			return;
	}

	// smokes_start
	// Random lightning bolt
	// Start shooting
	void NpcPoisonCloudOld_OnSmokesStart_2()
	{
		STORMING = true;
	}

	// smokes_start
	void OnSmokesStart()
	{
		NpcPoisonCloudOld_OnSmokesStart();
		NpcPoisonCloudOld_OnSmokesStart_2();
	}

	// game_dynamically_created
	// PARAM1=Owner PARAM2=Angles PARAM3=Damage PARAM4=Duration
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_BASE_DAMAGE = Float(damage);
		MY_DURATION = skill;

		MY_OWNER_RACE = RaceOf(creatorValue1);
		SetRace(MY_OWNER_RACE);

		// //dbg got own $get(MY_OWNER,name) dmg MY_BASE_DAMAGE dur MY_DURATION
		CallEventOrDelay(MY_DURATION, "poisoning_end");

		CallEventDelayed(2.0f, "smokes_start");
		ClientEvent("new", "all", "monsters/summon/npc_poison_cloud_old", OriginOf(ENT_ME), creatorValue2, MY_DURATION);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // not a valid target

		SetName("Poison Cloud");
		SetHealth(1);
		SetFieldOfView(359);
		SetInvincible(true);
		SetHeight(32);
		SetWidth(32);
		SetBlood("none");
		SetModel("none");
		SetSolid("none");

		SetGravity(0);
		SetFly(true);
		SetNoPush(true);

		SetAngle("face", Vector3(0, 90, 0));

		POISONING = true;

		CallEventDelayed(0.5f, "poisoning_go");
		CallEventDelayed(0.1f, "spawn_sound");
	}

	// poisoning_go
	void OnPoisoningGo()
	{
		if (!POISONING)
			return;

		CallEventDelayed(0.5f, "poisoning_go");

		TARG_LIST = LegacyFunction("get_tsphere", "enemy", SCAN_RANGE, MyOrigin());
		if (TARG_LIST == "none")
			return;
		int count = GetTokenCount(TARG_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
	}

	// affect_targets
	void OnAffectTargets()
	{
		bool exitSub = false;

		string checkEnt = GetToken(TARG_LIST, loopIteration);

		// dbg aborted, players do not stun players in non-pvp ( game.pvp )
		if (exitSub)
			return;

		ApplyEffect(checkEnt, EFFECT_SCRIPT, 5.0f, MY_OWNER, MY_BASE_DAMAGE);
	}

	// poisoning_end
	void OnPoisoningEnd()
	{
		ClientEvent("remove", "all", "monsters/summon/npc_poison_cloud_old");
		POISONING = false;
		STORMING = false;
		CallEventDelayed(0.1f, "remove_final");
	}

	// remove_final
	void OnRemoveFinal()
	{
		DeleteEntity(ENT_ME);
	}

	// spawn_sound
	void OnSpawnSound()
	{
		PlaySound(0, 10, SPAWN_SOUND);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		CallEventDelayed(1.0f, "NpcPoisonCloudOld_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NpcPoisonCloudOld_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "poisoning_end") { OnPoisoningEnd(); return true; }
		if (name == "poisoning_go") { OnPoisoningGo(); return true; }
		if (name == "remove_final") { OnRemoveFinal(); return true; }
		if (name == "smokes_start") { OnSmokesStart(); return true; }
		if (name == "spawn_sound") { OnSpawnSound(); return true; }
		if (name == "NpcPoisonCloudOld_Timer") { NpcPoisonCloudOld_Timer(); return true; }
		return false;
	}
}
