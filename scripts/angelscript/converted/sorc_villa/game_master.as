#pragma context server

// Converted from sorc_villa/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "sorc_villa/game_master"]
class SorcVillaGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool SORCV_FRIENDLY = false;
	bool SORCV_CHALLENGE_STARTED = false;
	float GM_MEDAL_COUNT = 0.0f;
	float GM_ACHIEVE_LEVEL = 0.0f;
	string GM_ACHIEVE_NAMES = "GM_ACHIEVE_NAMES";
	string SORCV_PLAYER_NAMES = "SORCV_PLAYER_NAMES";

	// gm_sorcv_init
	// called at shad palace side spawn
	void OnGmSorcvInit()
	{
		SORCV_FRIENDLY = Truthy(GetVar("G_SORCV_FRIENDLY")); // This is set once and will be active for the rest of the time on the map

		SetGlobal("G_SORCV_SETUP", 1);

		DebugPrint("gm_sorcv_init friend " + Text(SORCV_FRIENDLY) + " setup " + GetVar("G_SORCV_SETUP"));

		if (SORCV_FRIENDLY)
		{
			UseTrigger("spawn_guard1_friendly", "GM_friendly_unlock");
			SetGlobal("G_SORCV_FRIENDLY", 0);
		}
		else
		{
			UseTrigger("setup_hostile", "spawn_guard1_hostile");
			SetGlobal("G_TRACK_DEATHS", 1);
			SetGlobal("G_TRACK_DEATHS_TRIGGER", 10);
			SetGlobal("G_TRACK_DEATHS_EVENT", "gm_sorcv_start_challenge");
		}
	}

	// gm_sorcv_ogers
	// called by brush when player falls down well
	void OnGmSorcvOgers(string inHole = "")
	{
		CallExternal("all", "player_ogre_hole", inHole);
	}

	// gm_sorcv_a1
	void OnGmSorcvA1()
	{
		if (SORCV_FRIENDLY)
			UseTrigger("spawn_f1");
		else
			UseTrigger("spawn_h1");
	}

	// gm_sorcv_a2
	void OnGmSorcvA2()
	{
		if (SORCV_FRIENDLY)
			UseTrigger("spawn_f2");
		else
			UseTrigger("spawn_h2");
	}

	// gm_sorcv_a3
	void OnGmSorcvA3()
	{
		if (!SORCV_FRIENDLY)
			UseTrigger("spawn_h3");
	}

	// gm_sorcv_shop1
	void OnGmSorcvShop1()
	{
		if (SORCV_FRIENDLY)
			UseTrigger("spawn_shop_f1");
		else
			UseTrigger("spawn_shop_h1");
	}

	// gm_sorcv_smith
	void OnGmSorcvSmith()
	{
		if (SORCV_FRIENDLY)
			UseTrigger("spawn_smith_f1");
		else
			UseTrigger("spawn_smith_h1");
	}

	// gm_sorcv_horrors1
	void OnGmSorcvHorrors1()
	{
		if (!SORCV_FRIENDLY)
			UseTrigger("s_horrors");
	}

	// gm_sorcv_horrors2
	void OnGmSorcvHorrors2()
	{
		if (!SORCV_FRIENDLY)
			UseTrigger("s_horrors2");
	}

	// gm_sorv_north
	void OnGmSorvNorth()
	{
		if (!SORCV_FRIENDLY)
			UseTrigger("spawn_archers_north");
	}

	// gm_sorcv_shaman1
	void OnGmSorcvShaman1()
	{
		if (!SORCV_FRIENDLY)
			UseTrigger("spawn_shaman1");
	}

	// gm_sorcv_give_medal
	// <player>
	void OnGmSorcvGiveMedal(string player = "")
	{
		DebugPrint("gm_sorcv_give_medal " + NameOf(player));
		if (Truthy(ItemExists(player, "item_sorcv")))
			return;
		Offer(player, "item_sorcv");
		CallExternal(ENT_LASTCREATED, "ext_set_owner", player);
		string curAchievements = GetQuestData(player, "a");
		int curAlevel = Int(GetToken(curAchievements, 0));
		if (curAlevel < 1)
		{
			curAchievements = TokenSet(curAchievements, 0, "1");
			Quest("set", player, "a", curAchievements);
		}
	}

	// gm_sorcv_start_challenge
	void OnGmSorcvStartChallenge()
	{
		DebugPrint("gm_sorcv_start_challenge");
		if (SORCV_CHALLENGE_STARTED)
			return;
		SORCV_CHALLENGE_STARTED = true;
		SetGlobal("G_TRACK_DEATHS_EVENT", "gm_sorcv_achieve");
		SetGlobal("G_TRACK_DEATHS_TRIGGER", 50);
		LegacyCommand("getplayersarray", "SORCV_PLAYERS");
		GM_MEDAL_COUNT = 0.0f;
		GM_ACHIEVE_LEVEL = 1.0f;
		GM_ACHIEVE_NAMES = "null;Tin;Bronze;Silver;Gold;Platinum;Diamond;LORELDIAN";
		SORCV_PLAYER_NAMES = "Participating Players:|";
		int count = GetArrayCount("SORCV_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmSorcvMakePlayerList();
		}
		OnGmSorcvHandleMedals();
	}

	// gm_sorcv_make_player_list
	void OnGmSorcvMakePlayerList()
	{
		string curPlayer = GetArray("SORCV_PLAYERS", Text(loopIteration));
		SORCV_PLAYER_NAMES += NameOf(curPlayer) + "|";
	}

	// gm_sorcv_handle_medals
	void OnGmSorcvHandleMedals()
	{
		string curPlayer = GetArray("SORCV_PLAYERS", Text(GM_MEDAL_COUNT));
		DebugPrint("gm_sorcv_handle_medals " + NameOf(curPlayer));
		SORCV_PLAYER_NAMES += "Player list is now locked!";
		OnGmSorcvGiveMedal(curPlayer);
		GM_MEDAL_COUNT += 1.0f;
		if (GM_MEDAL_COUNT < GetArrayCount("SORCV_PLAYERS"))
			CallEventDelayed(1.0f, "gm_sorcv_handle_medals");
		HelpTip(curPlayer, "generic", "Shadahar Village Challenge Has Begun!", SORCV_PLAYER_NAMES);
	}

	// gm_sorcv_achieve
	void OnGmSorcvAchieve()
	{
		DebugPrint("gm_sorcv_achieve " + Text(GM_ACHIEVE_LEVEL));
		if (!(GM_ACHIEVE_LEVEL < 7.0f))
			return;
		GM_ACHIEVE_LEVEL += 1.0f;
		LegacyCommand("add", "G_TRACK_DEATHS_TRIGGER", 50);
		if (GM_ACHIEVE_LEVEL == 7.0f)
		{
			SetGlobal("G_TRACK_DEATHS", 0);
			CallEventDelayed(10.0f, "gm_sorcv_end_challenge");
		}
		int count = GetArrayCount("SORCV_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmSorcvUpdateAchievements();
		}
	}

	// gm_sorcv_update_achievements
	void OnGmSorcvUpdateAchievements()
	{
		string msgOut;
		string msgReason = "MSG_REASON";
		string curPlayer = GetArray("SORCV_PLAYERS", Text(loopIteration));
		if (GetProp(curPlayer, "ip") == "0")
			return;
		string curAchievements = GetQuestData(curPlayer, "a");
		int curAlevel = Int(GetToken(curAchievements, 0));
		if (curAlevel < GM_ACHIEVE_LEVEL)
		{
			curAchievements = TokenSet(curAchievements, 0, Text(GM_ACHIEVE_LEVEL));
			Quest("set", curPlayer, "a", curAchievements);
			msgOut = "You now have achieved ";
			msgOut = msgOut + GetToken(GM_ACHIEVE_NAMES, int(GM_ACHIEVE_LEVEL)) + " Status for the Shadahar Village Challenge";
			InfoMessage(curPlayer, "ACHIEVEMENT LEVEL INCREASED!", msgOut);
		}
		else
		{
			msgOut = "Your team has achieved ";
			if (curAlevel == GM_ACHIEVE_LEVEL)
				msgReason = "They are now on your level.";
			if (curAlevel > GM_ACHIEVE_LEVEL)
				msgReason = "You have already gone beyond this level.";
			msgOut = msgOut + GetToken(GM_ACHIEVE_NAMES, int(GM_ACHIEVE_LEVEL)) + " Status for the Shadahar Village Challenge. " + msgReason;
			InfoMessage(curPlayer, "ACHIEVEMENT PROGRESS!", msgOut);
		}
	}

	// gm_sorcv_end_challenge
	// this is okay (deletes spawn), but be nicer to have a tool to stop monster spawns, so monsters wouldnt hafta suicide
	void OnGmSorcvEndChallenge()
	{
		UseTrigger("end_challenge");
		CallEventDelayed(1.0f, "gm_sorcv_end_challenge2");
	}

	// gm_sorcv_end_challenge2
	void OnGmSorcvEndChallenge2()
	{
		CallExternal("all", "npc_suicide", "override");
		InfoMessage("all", "CHALLENGE COMPLETE", "The village has been cleared!");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_sorcv_a1") { OnGmSorcvA1(); return true; }
		if (name == "gm_sorcv_a2") { OnGmSorcvA2(); return true; }
		if (name == "gm_sorcv_a3") { OnGmSorcvA3(); return true; }
		if (name == "gm_sorcv_achieve") { OnGmSorcvAchieve(); return true; }
		if (name == "gm_sorcv_end_challenge") { OnGmSorcvEndChallenge(); return true; }
		if (name == "gm_sorcv_end_challenge2") { OnGmSorcvEndChallenge2(); return true; }
		if (name == "gm_sorcv_give_medal") { OnGmSorcvGiveMedal(Param(params, 0)); return true; }
		if (name == "gm_sorcv_handle_medals") { OnGmSorcvHandleMedals(); return true; }
		if (name == "gm_sorcv_horrors1") { OnGmSorcvHorrors1(); return true; }
		if (name == "gm_sorcv_horrors2") { OnGmSorcvHorrors2(); return true; }
		if (name == "gm_sorcv_init") { OnGmSorcvInit(); return true; }
		if (name == "gm_sorcv_make_player_list") { OnGmSorcvMakePlayerList(); return true; }
		if (name == "gm_sorcv_ogers") { OnGmSorcvOgers(Param(params, 0)); return true; }
		if (name == "gm_sorcv_shaman1") { OnGmSorcvShaman1(); return true; }
		if (name == "gm_sorcv_shop1") { OnGmSorcvShop1(); return true; }
		if (name == "gm_sorcv_smith") { OnGmSorcvSmith(); return true; }
		if (name == "gm_sorcv_start_challenge") { OnGmSorcvStartChallenge(); return true; }
		if (name == "gm_sorcv_update_achievements") { OnGmSorcvUpdateAchievements(); return true; }
		if (name == "gm_sorv_north") { OnGmSorvNorth(); return true; }
		return false;
	}
}
