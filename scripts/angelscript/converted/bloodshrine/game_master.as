#pragma context server

// Converted from bloodshrine/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "bloodshrine/game_master"]
class BloodshrineGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYER_LIST = "PLAYER_LIST";
	bool GM_BLOOD_DRINKER_FOUND = false;
	bool GM_SFS_DEAD = false;
	bool GM_DID_SFS_ALERT = false;

	// gm_bloodshrine_sorc_check
	void OnGmBloodshrineSorcCheck()
	{
		PLAYER_LIST = "0";
		PLAYER_LIST = GetPlayers();
		GM_BLOOD_DRINKER_FOUND = false;
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSearchForBloodDrinker();
		}
		if (GM_BLOOD_DRINKER_FOUND)
			UseTrigger("spawn_zorcs_friendly");
		else
			UseTrigger("spawn_zorcs_hostile");
	}

	// gm_bloodshrine_sorc_door
	void OnGmBloodshrineSorcDoor()
	{
		if (GM_BLOOD_DRINKER_FOUND)
		{
			UseTrigger("sorc_door1");
			CallExternal("all", "ext_fsorc_init");
		}
		else
		{
			UseTrigger("sorc_door1");
			UseTrigger("sorc_door2");
		}
	}

	// search_for_blood_drinker
	void OnSearchForBloodDrinker()
	{
		int curIdx = loopIteration;
		string curPlayer = GetToken(PLAYER_LIST, curIdx);
		if (!Truthy(ItemExists(curPlayer, "swords_blood_drinker")))
			return;
		GM_BLOOD_DRINKER_FOUND = true;
	}

	// gm_bloodshrine_boss_fx
	void OnGmBloodshrineBossFx()
	{
		CBaseEntity@ bossId = FindByName("shadowform_boss");
		if (!IsAlive(bossId))
			return;
		CallExternal(bossId, "ext_cl_fx_update");
	}

	// gm_bloodshrine_sfs_dead
	void OnGmBloodshrineSfsDead()
	{
		CallExternal("all", "fsorc_unwait");
		GM_SFS_DEAD = true;
	}

	// gm_bloodshrine_fsorc_tele
	void OnGmBloodshrineFsorcTele()
	{
		bool initMoveToTele = false;
		if (!GM_SFS_DEAD)
			return;
		CBaseEntity@ shamanId = FindByName("fsorc_shaman");
		CBaseEntity@ leaderId = FindByName("fsorc_leader");
		CBaseEntity@ secondId = FindByName("fsorc_second");
		Vector3 telePoint = Vector3(512, 128, -16);

		Vector3 org = OriginOf(shamanId);
		if (Distance(org, org) < 600.0f)
			initMoveToTele = true;

		org = OriginOf(leaderId);
		if (Distance(org, org) < 600.0f)
			initMoveToTele = true;

		org = OriginOf(secondId);
		if (Distance(org, org) < 600.0f)
			initMoveToTele = true;

		if (!initMoveToTele)
			return;

		CallExternal("all", "fsorc_move_tele");
	}

	// gm_bloodshrine_hold_sfs
	void OnGmBloodshrineHoldSfs()
	{
		if (GM_DID_SFS_ALERT)
			return;
		CBaseEntity@ shaman = FindByName("fsorc_shaman");
		if (!IsAlive(shaman))
			return;
		GM_DID_SFS_ALERT = true;
		CallExternal(shaman, "ext_wait_sfs_loop");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_bloodshrine_boss_fx") { OnGmBloodshrineBossFx(); return true; }
		if (name == "gm_bloodshrine_fsorc_tele") { OnGmBloodshrineFsorcTele(); return true; }
		if (name == "gm_bloodshrine_hold_sfs") { OnGmBloodshrineHoldSfs(); return true; }
		if (name == "gm_bloodshrine_sfs_dead") { OnGmBloodshrineSfsDead(); return true; }
		if (name == "gm_bloodshrine_sorc_check") { OnGmBloodshrineSorcCheck(); return true; }
		if (name == "gm_bloodshrine_sorc_door") { OnGmBloodshrineSorcDoor(); return true; }
		if (name == "search_for_blood_drinker") { OnSearchForBloodDrinker(); return true; }
		return false;
	}
}
