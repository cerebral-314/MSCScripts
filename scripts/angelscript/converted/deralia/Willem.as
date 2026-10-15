#pragma context server

// Converted from deralia/Willem.script by msc_transpiler.
// Willem in Deralia

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_civilian.as"
#include "converted/monsters/base_chat.as"

[script "deralia/Willem"]
class Willem : BaseNpcScript, BaseCivilian, BaseChat
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string QUEST_WINNER = "QUEST_WINNER";

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_letter")))
		{
			menuItem.title = "Deliver letter";
			menuItem.type = "payment";
			menuItem.data = "item_letter";
			menuItem.callback = "give_letter";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		// fov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Willem");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetMoveAnim("walk");

		CatchSpeech("say_hi", "hi", "hail", "greet");

		OnRandomspawn();
	}

	// give_letter
	void OnGiveLetter(CBasePlayer@ winner = null)
	{
		ReceiveOffer("accept");
		CallEventDelayed(0.0f, "1");
		QUEST_WINNER = EntityId(winner);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("What do you want?");
		SetMoveDest(ENT_LASTSPOKE, 999);
	}

	// say_letter
	void OnSayLetter(CBasePlayer@ speaker = null)
	{
		SayText("Thank you. Wow, a letter from Hoguld, it has been ages.");
		SetMoveDest(ENT_LASTGAVE, 999);
		CallEventDelayed(0.0f, "3");
	}

	// say_letter2
	void OnSayLetter2()
	{
		SayText("I hope this is enough for the trouble");
		SetMoveDest(ENT_LASTGAVE, 999);
		Offer(QUEST_WINNER, "health_mpotion");
		Offer(QUEST_WINNER, "gold", 8);
	}

	// randomspawn
	void OnRandomspawn()
	{
		if (!(RandomInt(0, 99) > 65))
			return;
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
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
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_letter") { OnGiveLetter(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "randomspawn") { OnRandomspawn(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_letter") { OnSayLetter(PlayerParam(params, 0)); return true; }
		if (name == "say_letter2") { OnSayLetter2(); return true; }
		return BaseCivilian_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
