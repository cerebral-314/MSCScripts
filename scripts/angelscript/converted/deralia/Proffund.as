#pragma context server

// Converted from deralia/Proffund.script by msc_transpiler.
// *** Sitting human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "deralia/Proffund"]
class Proffund : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	bool DEED = false;
	bool SLINKER = false;
	bool OFFER = false;
	int OVER = 2;
	bool GIVEREWARD = false;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetUniqueName("Proffund");

		SetHealth(1);
		// fov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Master Proffund");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetMoveAnim("walk");
		SetInvincible(true);

		CatchSpeech("say_hi", "hail", "hello", "hi", "greet");
		CatchSpeech("say_deed", "deed");
		CatchSpeech("say_slinker", "slinker");
		CatchSpeech("say_yes", "yes", "sure", "ok", "yea");
		CatchSpeech("say_no", "no", "never", "naw");

		DEED = false;
		SLINKER = false;
		OFFER = false;
		OVER = 2;
		GIVEREWARD = false;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if ((GIVEREWARD ? 1 : 0) == 0)
			SayText("Yes, what do you want?");
		if ((GIVEREWARD ? 1 : 0) == 1)
		{
			SayText("Nice work, here's your reward!");
			Offer(ENT_LASTSPOKE, "gold", 25);
			Offer(ENT_LASTSPOKE, "scroll_summon_rat");
			GIVEREWARD = false;
		}
	}

	// say_deed
	void OnSayDeed()
	{
		if (OVER != 0)
			return;
		if ((SLINKER ? 1 : 0) == 0)
		{
			DEED = true;
			SayText("A property deed? What nonsense is this? ... who sent you?");
		}
		else
		{
			SayText("Oh really? A deed to one of my farm properties, I suppose. Well, he'll have to try harder than you, if he's planning on");
			SayText("intimidating me into giving him a property deed!");
			CallEventDelayed(0.0f, "3");
		}
	}

	// say_slinker
	void OnSaySlinker()
	{
		if (OVER != 0)
			return;
		if ((DEED ? 1 : 0) == 0)
		{
			SLINKER = true;
			SayText("S-slinker? Shh, be a little quieter! My reputation, you understand.. What does he want?");
		}
		else
		{
			SayText("S-slinker? Shh, be a little quieter! Well, he'll have to try harder than you, if he's planning on intimidating me into giving him a property deed!");
			CallEventDelayed(0.0f, "3");
		}
	}

	// say_helpme
	void OnSayHelpme()
	{
		SayText("However, maybe you can help me out. I'd like Slinker, shall we say, removed from the picture. Will you help me by, uhm, taking care of him?");
		OFFER = true;
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		if (OVER != 0)
			return;
		if ((OFFER ? 1 : 0) != 1)
			return;
		SayText("Excellent. When you return, I shall reward you...");
		CallExternal(FindByName("Slinker"), "mortal");
		OVER = 1;
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		if (OVER != 0)
			return;
		if ((OFFER ? 1 : 0) != 1)
			return;
		SayText("Are..are you sure? I mean... please don't hurt me. Here, here! Take it!");
		Offer(ENT_LASTSPOKE, "item_deed");
		OFFER = false;
		OVER = 1;
	}

	// slinker_dead
	void OnSlinkerDead()
	{
		GIVEREWARD = true;
	}

	// quest_start
	void OnQuestStart()
	{
		OVER = 0;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "quest_start") { OnQuestStart(); return true; }
		if (name == "say_deed") { OnSayDeed(); return true; }
		if (name == "say_helpme") { OnSayHelpme(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "say_slinker") { OnSaySlinker(); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "slinker_dead") { OnSlinkerDead(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
