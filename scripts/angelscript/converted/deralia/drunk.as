#pragma context server

// Converted from deralia/drunk.script by msc_transpiler.
// Drunkard Dridmar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_civilian.as"
#include "converted/monsters/base_chat_array.as"

[script "deralia/drunk"]
class Drunk : BaseNpcScript, BaseCivilian, BaseChatArray
{
	// Constants
	bool CHAT_AUTO_HAIL = true;
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHAT_AUTO_FACE = false;
	bool CHAT_FACE_ON_USE = false;

	// Variables (an unset .script variable reads as its own name)
	int SAID_HI = 0;
	int CAUGHT = 0;
	int DRUNKARD_QUEST = 0;
	bool QUEST_DONE = false;
	int ROB_ATTEMPT = 0;
	CBaseEntity@ Thief = null;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (CAUGHT == 0)
		{
			menuItem.title = "Pickpocket";
			menuItem.type = "callback";
			menuItem.callback = "say_rob";
			RegisterMenuItem(menuItem);
		}

		if (SAID_HI == 1)
		{
			menuItem.title = "Drink";
			menuItem.type = "callback";
			menuItem.callback = "say_drink";
			RegisterMenuItem(menuItem);
		}

		if (DRUNKARD_QUEST == 1 && Truthy(ItemExists(player, "drink_mead")))
		{
			menuItem.title = "Give Mead";
			menuItem.type = "payment";
			menuItem.data = "drink_mead";
			menuItem.callback = "give_mead";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Drunkard");
		SetHealth(25);

		SetWidth(32);
		SetHeight(32);
		SetRace("human");
		SetRoam(false);

		SetModel("npc/human1.mdl");

		SetIdleAnim("sitidle");

		SAID_HI = 0;
		CAUGHT = 0;
		DRUNKARD_QUEST = 0;
		QUEST_DONE = false;
	}

	// say_rob
	void OnSayRob()
	{
		ROB_ATTEMPT = RandomInt(1, 3);

		if (ROB_ATTEMPT == 1)
			OnRobFail();
		else
			OnRobPass();
	}

	// rob_pass
	void OnRobPass()
	{
		@Thief = EntityOf(ENT_LASTUSED);
		Offer(Thief, "gold", 3);
		CAUGHT = 1;
	}

	// rob_fail
	void OnRobFail()
	{
		SayText("Get your hands out of my pockets!");
		CAUGHT = 1;
		OnBchatMouthMove();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (QUEST_DONE)
		{
			SayText("Thanks for *hic* your help, Adventurer.");
			OnChatMoveMouth("2");
			DRUNKARD_QUEST = 0;
		}
		else
		{
			SayText("*hic* Can you believe they cut me off. I really need another [drink].");
			SAID_HI = 1;
			OnChatMoveMouth("2.5");
		}
	}

	// say_drink
	void OnSayDrink()
	{
		OnChatNow("Can you go inside the Inn and get me *hic*", "1.8");
		OnChatNow("I will give you some gold for your troubles.", "2.0");
		OnChatNow("I would you to get me *hic* of mead.", "2.0");
		OnChatMoveMouth("6");

		DRUNKARD_QUEST = 1;
	}

	// give_mead
	void OnGiveMead(CBasePlayer@ player = null)
	{
		SayText("Cheers! Thanks for your *hic* help adventurer.");
		OnChatMoveMouth("1.5");

		Offer(player, "gold", 10);
		QUEST_DONE = true;
		SAID_HI = 0;

		UseTrigger("RenderMug");
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
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
	}

	void OnBchatMouthMove() {} // bchat_mouth_move

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
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_mead") { OnGiveMead(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "rob_fail") { OnRobFail(); return true; }
		if (name == "rob_pass") { OnRobPass(); return true; }
		if (name == "say_drink") { OnSayDrink(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_rob") { OnSayRob(); return true; }
		return BaseCivilian_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
