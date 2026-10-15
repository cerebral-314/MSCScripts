#pragma context server

// Converted from belmont/bartender.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "belmont/bartender"]
class Bartender : BaseChatScript
{
	// Constants
	string SOUND_DEATH = "xxx";

	// Variables (an unset .script variable reads as its own name)
	bool NO_HAIL = false;
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	CBaseEntity@ BAR_ID = null;
	float SKEL_RESPAWN_TIMES = 0.0f;
	CBaseEntity@ MY_SAVIOR = null;
	bool QUESTS_ACTIVE = false;

	// unnamed block (first think)
	void Bartender_FirstThink()
	{
		NO_HAIL = true;
		NO_JOB = true;
		NO_RUMOR = true;
	}

	// game_spawn
	void Bartender_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("bartender");

		SetHealth(30);
		SetInvincible(true);
		SetName("Helga, The Barkeep");
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetModel("npc/human1.mdl");
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");

		SetSayTextRange(1024);

		SetModelBody(0, 4);

		CatchSpeech("say_yes", "yes", "yep", "yeah", "ja", "jes");
		CatchSpeech("say_no", "no", "not", "stop", "nope", "nah", "nein");
		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CallEventDelayed(2.0f, "get_extorter_id");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		Bartender_OnGameSpawn(playerRace, playerGender);
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!Truthy(ItemExists(player, "item_bar_coffer")))
			return;
		menuItem.title = "Return Coffer";
		menuItem.type = "payment";
		menuItem.data = "item_bar_coffer";
		menuItem.callback = "return_coffer";
		RegisterMenuItem(menuItem);
	}

	// get_extorter_id
	void OnGetExtorterId()
	{
		@BAR_ID = FindByName("extorter");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!QUESTS_ACTIVE)
			return;
		OnConvoAnim();
		SayText("I'm glad you saved me and all, but he has a lot of nasty friends who will follow.");
		CallEventDelayed(3.0f, "say_hi2");
	}

	// say_hi2
	void OnSayHi2()
	{
		OnConvoAnim();
		SayText("I'd just get up and leave here, but they have all my money.");
		CallEventDelayed(3.0f, "say_hi2b");
	}

	// say_hi2b
	void OnSayHi2b()
	{
		SayText("It was all sealed in a magic coffer. I doubt they'll be able to open it anytime soon. But so long as they have it, I can't go anywhere.");
		CallEventDelayed(3.0f, "say_hi3");
	}

	// say_hi3
	void OnSayHi3()
	{
		OnConvoAnim();
		SayText("If you could get it back for me, I'd be sure to give you a handsom portion before I run off to Deralia!");
	}

	// ext_harass1
	void OnExtHarass1()
	{
		SayText("For the last time, I told you, we don't have that kind of money. You already took everything we had!");
		PlayAnim("critical", "converse1");
	}

	// ext_harass2
	void OnExtHarass2()
	{
		SayText("How could we possibly have made the money with your thugs scaring away all the customers?");
		PlayAnim("critical", "converse2");
	}

	// ext_harass3
	void OnExtHarass3()
	{
		SayText("NO! PLEASE DON'T!!!");
		PlayAnim("critical", "fear");
	}

	// npc_suicide
	// just copied from externals
	void OnNpcSuicide(string suicideMode = "")
	{
		bool exitSub = false;

		if (suicideMode == "no_pets")
		{
			// (never true here, the rest is skipped) if I_R_PET
		}

		if (suicideMode == "only_bad")
		{
			if (RaceOf(ENT_ME) == "human")
				exitSub = true;
			if (RaceOf(ENT_ME) == "hguard")
				exitSub = true;
		}
		if (exitSub)
			return;

		SetInvincible(false);
		SetRace("hated");
		SKEL_RESPAWN_TIMES = 99.0f;
		DoDamage(ENT_ME, "direct", 30000, 100, GetVar("GAME_MASTER"), "target");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayAnim("critical", "diesimple");
		PlaySound(0, 10, SOUND_DEATH);
	}

	// extorter_slain
	void OnExtorterSlain(CBaseEntity@ attacker = null)
	{
		@MY_SAVIOR = attacker;
		SayText("Thank Felewyn! You've saved my life!");
		QUESTS_ACTIVE = true;
		NO_JOB = false;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		OnSayHi();
	}

	// return_coffer
	void OnReturnCoffer(CBasePlayer@ player = null)
	{
		SayText("Thank you so very much! Now maybe I can setup some place more reputable...");
		UseTrigger("coffer_returned");
		Offer(player, "gold", 200);
		CallEventDelayed(3.0f, "next_quest");
	}

	// next_quest
	void OnNextQuest()
	{
		SayText("[Insert text for next quest here].");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bartender_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_harass1") { OnExtHarass1(); return true; }
		if (name == "ext_harass2") { OnExtHarass2(); return true; }
		if (name == "ext_harass3") { OnExtHarass3(); return true; }
		if (name == "extorter_slain") { OnExtorterSlain(EntityParam(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_extorter_id") { OnGetExtorterId(); return true; }
		if (name == "next_quest") { OnNextQuest(); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "return_coffer") { OnReturnCoffer(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi2b") { OnSayHi2b(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
