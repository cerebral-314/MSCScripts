#pragma context server

// Converted from monsters/summon/npc_poison_cloud2.script by msc_transpiler.
// As simplistic as possible NPC DOT cloud
// poison, spore, and acid variants

#include "runtime/ScriptEntity.as"

[script "monsters/summon/npc_poison_cloud2"]
class NpcPoisonCloud2 : ScriptEntity
{
	// Constants
	int CLOUD_RADIUS = 256;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	float DOT_POISON = 0.0f;
	string MY_DURATION = "MY_DURATION";
	string CLOUD_TYPE = "CLOUD_TYPE";
	string CL_ID = "CL_ID";
	bool IS_ACTIVE = false;
	string SCAN_TARGS = "SCAN_TARGS";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Poisonous Cloud");
		SetNoPush(true);
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetWidth(1);
		SetHeight(1);
		SetModel("null.mdl");
		SetSolid("none");
	}

	// game_dynamically_created
	// <owner> <DPS> <duration> [variant:1=poison,2=spore,3=acid]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		DOT_POISON = Float(creatorValue2);
		MY_DURATION = damage;
		CLOUD_TYPE = skill;

		if (CLOUD_TYPE.isEmpty())
			CLOUD_TYPE = "1";
		DebugPrint("game_dynamically_created Owner " + NameOf(MY_OWNER) + " dot " + Text(DOT_POISON) + " dur " + MY_DURATION + " type " + CLOUD_TYPE);
		SetRace(RaceOf(MY_OWNER));
		CL_ID = LastClientScriptId();
		IS_ACTIVE = true;
		CallEventDelayed(0.1f, "do_scan");
		CallEventDelayed(0.1f, "cl_effects");
		CallEventOrDelay(MY_DURATION, "remove_me");
	}

	// cl_effects
	void OnClEffects()
	{
		Vector3 pos = OriginOf(ENT_ME);
		pos.z = GroundHeight(pos);
		ClientEvent("new", "all", "monsters/summon/npc_poison_cloud2_cl", pos, MY_DURATION, CLOUD_TYPE);
	}

	// do_scan
	void OnDoScan()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(1.0f, "do_scan");
		Vector3 pos = OriginOf(ENT_ME);
		pos.z += 32.0f;
		SCAN_TARGS = LegacyFunction("get_tsphere", "enemy", CLOUD_RADIUS, pos);
		if (SCAN_TARGS == "none")
			return;
		int count = GetTokenCount(SCAN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonTargets();
		}
	}

	// poison_targets
	void OnPoisonTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));
		if (Float(CLOUD_TYPE) == 1.0f)
			ApplyEffect(curTarg, "effects/dot_poison", 5.0f, MY_OWNER, DOT_POISON);
		if (Float(CLOUD_TYPE) == 2.0f)
			ApplyEffect(curTarg, "effects/poison_spore", 5.0f, MY_OWNER, DOT_POISON);
		if (Float(CLOUD_TYPE) == 3.0f)
			ApplyEffect(curTarg, "effects/dot_acid", 5.0f, MY_OWNER, DOT_POISON, "none");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_effects") { OnClEffects(); return true; }
		if (name == "do_scan") { OnDoScan(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "poison_targets") { OnPoisonTargets(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
