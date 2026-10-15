#pragma context server

// Converted from idemarks_tower/survivor_alfgar.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/skeleton_base.as"

[script "idemarks_tower/survivor_alfgar"]
class SurvivorAlfgar : SkeletonBaseScript, BaseChatArray
{
	// Constants
	bool CHAT_AUTO_HAIL = true;
	float ATTACK_DAMAGE_LOW = 20.0f;
	float ATTACK_DAMAGE_HIGH = 50.0f;
	string SKEL_RESPAWN_CHANCE = "0";
	int SKEL_RESPAWN_LIVES = 0;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool ZOMBIFIED = false;
	bool CHAT_MENU_ON = false;

	// Variables declared by included files, with the value they start with in this script
	SurvivorAlfgar()
	{
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "80%";
	}

	// unnamed block (first think)
	void SurvivorAlfgar_FirstThink()
	{
		NPC_GIVE_EXP = 400.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 15;
	}

	// skel_setup_body
	void OnSkelSetupBody()
	{
		SkeletonBase_OnSkelSetupBody(); // monsters/skeleton_base

		SetName("The Survivor|Alfgar");
		SetUniqueName("alfgar");

		SetInvincible(true);
		SetRace("beloved");

		SetRoam(false);

		SetModel("npc/guard1.mdl");
		PlayAnim("hold", 89);

		SetWidth(32);
		SetHeight(72);

		SetMenuAutoOpen(true);

		CatchSpeech("say_madness", "madness");
		CatchSpeech("say_lost", "lost");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (ZOMBIFIED)
			return;
		if (CHAT_BUSY)
			return;
		OnChatNow("URDUAL'S BEARD!!! Adventurers? It's so good to see a friendly face here.");
		OnChatNow("Well, may this humble soldier welcome you to Idemark's Tower.");
		OnChatNow("My platoon was sent here to gather reconnaissance on the area, to relay to King Deralia our standing here.");
		OnChatNow("This tower, it seems to be an anchor for the [Lost], a baited hook in a dark ocean that draws predators unknown to us mortals.");
		OnChatNow("Evil energy lurks here, as my dear friends and I found out the hard way. Please heed my warnings, take care to not join the Undead or Lost armies here.");
		OnChatNow("My soldiers were overtaken by a [madness], once we fought our way towards the inner courtyard.");
		OnChatNow("I began to feel it myself, a resonating hum, drawing me deeper, tickling my brain...");
		OnChatNow("No. I can't return. If you absolutely must venture forth, I would suggest using the highest caution.");
	}

	// say_lost
	void OnSayLost()
	{
		if (ZOMBIFIED)
			return;
		if (CHAT_BUSY)
			return;
		OnChatNow("Makes me wish that I had more of an interest in our histories growing up.");
		OnChatNow("I can tell you that this name is misleading. They are purposeful creatures, of that I am sure.");
	}

	// say_madness
	void OnSayMadness()
	{
		if (ZOMBIFIED)
			return;
		if (CHAT_BUSY)
			return;
		OnChatNow("The sight of it is seared in my mind. Even when I blink, I am haunted by flashes of the scene.");
		OnChatNow("It was slow to onset at first, some of the men were confused, and had to be turned toward the fight.");
		OnChatNow("Before long they were digging at their wounds. Have you ever dug out a splinter, me lad?");
		OnChatNow("I imagine it was like that burning, hurting desire to be freed of something... foreign to yourself.");
		OnChatNow("There are a lot of fates worse than death to be found here.");
		OnChatNow("I'm not ashamed to say that I screamed and took off running. By that point, I was the only one hanging onto any sanity, though I fear I speak too soon.");
	}

	// ext_zombify
	// trigger hostile & undead
	void OnExtZombify()
	{
		if (ZOMBIFIED)
			return;
		ZOMBIFIED = true;
		CHAT_MENU_ON = false; // disable say_hi

		SetModel("monsters/skeleton2.mdl");
		SetBoundingBox("npcsize");

		SetRoam(true);

		SetRace("undead");
		SetDamageTaken("holy", 1);

		SetInvincible(false);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		Precache("npc/guard1.mdl");
		Precache("monsters/skeleton2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SurvivorAlfgar_FirstThink();
		BaseChatArray_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_zombify") { OnExtZombify(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_lost") { OnSayLost(); return true; }
		if (name == "say_madness") { OnSayMadness(); return true; }
		if (name == "skel_setup_body") { OnSkelSetupBody(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
