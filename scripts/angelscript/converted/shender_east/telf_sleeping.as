#pragma context server

// Converted from shender_east/telf_sleeping.script by msc_transpiler.
// scientist/cough.wav
// scientist/getoutalive.wav
// scientist/iwoundedbad.wav
// scientist/sneeze.wav

#include "runtime/ScriptEntity.as"

[script "shender_east/telf_sleeping"]
class TelfSleeping : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float TELE_COUNT = 0.0f;
	bool DOING_LEV = false;
	string PLAYER_LIST = "PLAYER_LIST";
	string QUEST_FAILED = "QUEST_FAILED";

	// unnamed block (timer)
	void TelfSleeping_Timer()
	{
		CallEventDelayed(5.0f, "TelfSleeping_Timer");
		if (Truthy(QUEST_FAILED))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 64, 4.9f);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("sleep_elf");
		SetName("Sleeping Elf");
		SetModel("npc/elf_m_wizard.mdl");
		SetWidth(32);
		SetHeight(32);
		SetHealth(1);
		SetInvincible(true);
		SetIdleAnim("sleep_idle");
		SetMoveAnim("sleep_idle");
		PlayAnim("once", "sleep_idle");
		SetMenuAutoOpen(true);
		TELE_COUNT = 0.0f;
		SetProp(ENT_ME, "skin", 8);
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		if (Truthy(QUEST_FAILED))
			return;
		if (DOING_LEV)
			return;
		menuItem.title = "Wake Sleeping Elf";
		menuItem.type = "callback";
		menuItem.callback = "wake_elf";
		RegisterMenuItem(menuItem);
	}

	// wake_elf
	void OnWakeElf()
	{
		DOING_LEV = true;
		PlayAnim("hold", "lev");
		PlaySound(1, 10, "scientist/sci_fear4.wav");
		PlaySound(2, 10, "ambience/particle_suck2.wav"); // debris/beamstart8.wav
		CallEventDelayed(2.0f, "fade_players");
		CallEventDelayed(3.0f, "tele_players");

		// tag players for teleport
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();

		SetProp(ENT_ME, "skin", 9);
	}

	// fade_players
	void OnFadePlayers()
	{
		PlaySound(0, 10, "scientist/scream1.wav");
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFadePlayersGo();
		}
	}

	// fade_players_go
	void OnFadePlayersGo()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (!(RangeTo(curTarg) < 128.0f))
			return;
		Effect("screenfade", curTarg, 3.0f, 1.0f, Vector3(255, 255, 255), 255, "fadein");
	}

	// tele_players
	void OnTelePlayers()
	{
		int count = GetTokenCount(PLAYER_LIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTelePlayersGo();
		}
		loopIteration = outerIteration;
		CallEventDelayed(1.0f, "resume_idle");
	}

	// resume_idle
	void OnResumeIdle()
	{
		PlayAnim("critical", "sleep_idle");
		SetProp(ENT_ME, "skin", 8);
		DOING_LEV = false;
	}

	// tele_players_go
	void OnTelePlayersGo()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (!(RangeTo(curTarg) < 384.0f))
			return;

		if (TELE_COUNT >= 8.0f)
			TELE_COUNT = 0.0f;
		if (PlayerCount() < 5 && TELE_COUNT >= 4.0f)
			TELE_COUNT = 0.0f;
		TELE_COUNT += 1.0f;

		if (TELE_COUNT == 1.0f)
			SetOrigin(curTarg, Vector3(-272, -8, -3720));
		if (TELE_COUNT == 2.0f)
			SetOrigin(curTarg, Vector3(240, -8, -3720));
		if (TELE_COUNT == 3.0f)
			SetOrigin(curTarg, Vector3(-16, -264, -3720));
		if (TELE_COUNT == 4.0f)
			SetOrigin(curTarg, Vector3(-8, -240, -3720));
		if (TELE_COUNT == 5.0f)
			SetOrigin(curTarg, Vector3(-232, -8, -3720));
		if (TELE_COUNT == 6.0f)
			SetOrigin(curTarg, Vector3(220, -8, -3720));
		if (TELE_COUNT == 7.0f)
			SetOrigin(curTarg, Vector3(-16, -234, -3720));
		if (TELE_COUNT == 8.0f)
			SetOrigin(curTarg, Vector3(-8, -210, -3720));

		// callexternal CUR_TARG ext_playsound_kiss 4 10 debris/beamstart7.wav
		CallExternal(curTarg, "ext_delay_playsound", 0.5f, 4, 10, "debris/beamstart7.wav");
	}

	// quest_fail
	void OnQuestFail()
	{
		QUEST_FAILED = "1";
		PlayAnim("hold", "deadback");
		SetIdleAnim("deadback");
		SetMoveAnim("deadback");
		SetName("Dead Elf");
	}

	// ext_quest_win
	void OnExtQuestWin()
	{
		DeleteEntity(ENT_ME);
	}

	// ext_shender_fail
	void OnExtShenderFail()
	{
		OnQuestFail();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_m_wizard.mdl");
		Precache("bunny.spr");
		CallEventDelayed(5.0f, "TelfSleeping_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_quest_win") { OnExtQuestWin(); return true; }
		if (name == "ext_shender_fail") { OnExtShenderFail(); return true; }
		if (name == "fade_players") { OnFadePlayers(); return true; }
		if (name == "fade_players_go") { OnFadePlayersGo(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "quest_fail") { OnQuestFail(); return true; }
		if (name == "resume_idle") { OnResumeIdle(); return true; }
		if (name == "tele_players") { OnTelePlayers(); return true; }
		if (name == "tele_players_go") { OnTelePlayersGo(); return true; }
		if (name == "wake_elf") { OnWakeElf(); return true; }
		if (name == "TelfSleeping_Timer") { TelfSleeping_Timer(); return true; }
		return false;
	}
}
