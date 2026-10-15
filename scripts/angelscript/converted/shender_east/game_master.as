#pragma context server

// Converted from shender_east/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "shender_east/game_master"]
class ShenderEastGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string GM_SE_PLAYER_LIST = "GM_SE_PLAYER_LIST";
	float GM_SHENDER_EAST_TELECOUNT = 0.0f;
	bool GM_BUNNY_KILLED = false;

	// map_shender_east_dream_win
	void OnMapShenderEastDreamWin()
	{
		// teleport all players with z < -3168 back to elf house
		// remove sleeping elf
		// spawn quest reward elf
		// unlock elf chest
		CBaseEntity@ sleepElfId = FindByName("sleep_elf");
		CallExternal(sleepElfId, "ext_quest_win");
		CBaseEntity@ questElfId = FindByName("telf_quest");
		CallExternal(questElfId, "ext_quest_win");
		UseTrigger("spawn_win_elf");
		GM_SE_PLAYER_LIST = "";
		GM_SE_PLAYER_LIST = GetActivePlayers();
		GM_SHENDER_EAST_TELECOUNT = 0.0f;
		CallEventDelayed(1.0f, "map_shender_east_win2");
		int count = GetTokenCount(GM_SE_PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMapShenderEastPrepret();
		}
	}

	// map_shender_east_win2
	void OnMapShenderEastWin2()
	{
		int count = GetTokenCount(GM_SE_PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMapShenderEastReturn();
		}
	}

	// map_shender_east_prepret
	void OnMapShenderEastPrepret()
	{
		CBasePlayer@ curTarg = FindPlayer(GetToken(GM_SE_PLAYER_LIST, loopIteration));
		if (!(OriginOf(curTarg).z < -3168.0f))
			return;
		Effect("screenfade", @curTarg, 3.0f, 1.0f, Vector3(255, 255, 255), 255, "fadein");
	}

	// map_shender_east_return
	void OnMapShenderEastReturn()
	{
		CBasePlayer@ curTarg = FindPlayer(GetToken(GM_SE_PLAYER_LIST, loopIteration));
		if (!(OriginOf(curTarg).z < -3168.0f))
			return;
		if (GM_SHENDER_EAST_TELECOUNT > 5.0f)
			GM_SHENDER_EAST_TELECOUNT = 0.0f;
		GM_SHENDER_EAST_TELECOUNT += 1.0f;
		if (GM_SHENDER_EAST_TELECOUNT == 1.0f)
			SetOrigin(curTarg, Vector3(1784, -3568, 296));
		if (GM_SHENDER_EAST_TELECOUNT == 2.0f)
			SetOrigin(curTarg, Vector3(1744, -3568, 296));
		if (GM_SHENDER_EAST_TELECOUNT == 3.0f)
			SetOrigin(curTarg, Vector3(1704, -3568, 296));
		if (GM_SHENDER_EAST_TELECOUNT == 4.0f)
			SetOrigin(curTarg, Vector3(1656, -3568, 296));
		if (GM_SHENDER_EAST_TELECOUNT == 5.0f)
			SetOrigin(curTarg, Vector3(1640, -3616, 296));
	}

	// gm_shender_east_bunny
	void OnGmShenderEastBunny(string player = "")
	{
		// dbg gm_shender_east_bunny PARAM1 PARAM2 $get(PARAM1,name)
		InfoMessage(player, "HOW COULD YOU!", "Poor bunny!");
		GM_BUNNY_KILLED = true;
		ClientEvent("new", player, "effects/sfx_bunny");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_shender_east_bunny") { OnGmShenderEastBunny(Param(params, 0)); return true; }
		if (name == "map_shender_east_dream_win") { OnMapShenderEastDreamWin(); return true; }
		if (name == "map_shender_east_prepret") { OnMapShenderEastPrepret(); return true; }
		if (name == "map_shender_east_return") { OnMapShenderEastReturn(); return true; }
		if (name == "map_shender_east_win2") { OnMapShenderEastWin2(); return true; }
		return false;
	}
}
