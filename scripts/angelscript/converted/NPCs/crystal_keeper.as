#pragma context server

// Converted from NPCs/crystal_keeper.script by msc_transpiler.
// Crystal Keeper from Scratch for Crow

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/crystal_keeper"]
class CrystalKeeper : BaseNpcScript
{
	// Constants
	int SHARDS_REQ = 10;
	string ANIM_MAGIC = "kneel";
	string ANIM_GIVE = "gluonshow";
	string DUNGEON_NAME = "'Crows";
	string MONSTER_MODEL = "npc/balancepriest1.mdl";
	float CHAT_SPEED = 5.0f;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	float SHARDS_RECIEVED = 0.0f;
	bool IN_CHAT = false;
	float JOB_STEP = 0.0f;
	string QUEST_WINNER = "QUEST_WINNER";
	string PLAYER_NAME = "PLAYER_NAME";
	float SHARDS_LEFT = 0.0f;
	bool GAVE_KEY = false;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Tal'thul, the High Priest");
		SetHealth(100);
		SetRace("human");
		SetInvincible(true);
		SetModel(MONSTER_MODEL);
		SetModelBody(1, 3);
		SetWidth(32);
		SetHeight(72);

		GiveItem("ring_light2");

		SHARDS_RECIEVED = 0.0f;

		CatchSpeech("say_hi", "hi", "hail", "hello", "j0", "waddup", "wassup", "greetings", "gweets", "salutations");
		CatchSpeech("say_job", "crystal", "key", "quest", "job");
		CatchSpeech("say_where", "where");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (IN_CHAT)
			return;
		IN_CHAT = true;
		OnSayJobLoop();
	}

	// say_job_loop
	void OnSayJobLoop()
	{
		if (GAVE_KEY)
			return;

		JOB_STEP += 1.0f;
		if (JOB_STEP == 1.0f)
			SayText("The door to this temple requires a crystal key, but the key has been shattered.");
		if (JOB_STEP == 2.0f)
			SayText("If warriors of light cannot penetrate inside, the evil therein will simply grow without end.");
		if (JOB_STEP == 3.0f)
			SayText("I have some of the shards... I think if I had the rest I could re-forge the key.");
		if (JOB_STEP == 4.0f)
			SayText("They are scattered throughout " + DUNGEON_NAME + " but I lack the power to gather the rest.");
		if (JOB_STEP == 5.0f)
			SayText("If you can bring me " + SHARDS_REQ + " shards, I can re-forge magical key that opens this door.");
		if (JOB_STEP == 6.0f)
			SayText("Be sure to bring them to me all at once, for I must have all the pieces on hand at the same time.");
		if (JOB_STEP < 6.0f)
			CallEventDelayed(CHAT_SPEED, "say_job_loop");
		if (JOB_STEP == 6.0f)
		{
			JOB_STEP = 0.0f;
			IN_CHAT = false;
		}
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (IN_CHAT)
			return;
		if (SHARDS_RECIEVED > 0.0f)
			SayText("I still need " + Text(SHARDS_LEFT) + " shards to re-forge the key to the temple door.");
		if (SHARDS_RECIEVED != 0.0f)
			return;
		if (!GAVE_KEY)
			SayText("Greetings warrior, I am Tal'thul, priest of Felewyn.");
		if (GAVE_KEY)
			SayText("Thank you for your work, now hurry, use the key to enter the temple before it's too late.");
		CallEventDelayed(CHAT_SPEED, "say_job");
	}

	// say_where
	void OnSayWhere()
	{
		if (IN_CHAT)
			return;
		SayText("I am uncertain as to where exactally, I only barely survived finding the first three pieces in DUNGEON_NAME.");
	}

	// gave_shard
	void OnGaveShard(CBasePlayer@ winner = null)
	{
		string shardSuffix;

		QUEST_WINNER = EntityId(winner);
		PLAYER_NAME = NameOf(QUEST_WINNER) + ",";

		SHARDS_RECIEVED += 1.0f;

		SHARDS_LEFT = SHARDS_REQ - SHARDS_RECIEVED;
		SHARDS_LEFT = int(SHARDS_LEFT);
		shardSuffix = "shards.";
		if (SHARDS_LEFT == 1.0f)
			shardSuffix = "shard.";

		if (SHARDS_LEFT == 0.0f)
			OnGiveKey();
		if (!(SHARDS_LEFT > 0.0f))
			return;

		int randomChat = RandomInt(1, 4);
		if (randomChat == 1)
			SayText("Excellent, " + PLAYER_NAME + " I only need " + Text(SHARDS_LEFT) + " more " + shardSuffix);
		if (randomChat == 2)
			SayText("Good work, " + PLAYER_NAME + " I only need " + Text(SHARDS_LEFT) + " more " + shardSuffix);
		if (randomChat == 3)
			SayText("Keep them coming, " + PLAYER_NAME + " I only need " + Text(SHARDS_LEFT) + " more " + shardSuffix);
		if (randomChat == 4)
			SayText("Alright, " + PLAYER_NAME + " I only need " + Text(SHARDS_LEFT) + " more " + shardSuffix);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (GAVE_KEY)
			return;

		if (Truthy(ItemExists(player, "item_crow_shard")))
		{
			menuItem.id = "payment";
			menuItem.title = "Give Crystal Shard";
			menuItem.type = "payment";
			menuItem.data = "item_crow_shard";
			menuItem.callback = "gave_shard";
			RegisterMenuItem(menuItem);
		}
	}

	// give_key
	void OnGiveKey()
	{
		SayText("Truly you are a warrior of the light " + PLAYER_NAME + " one moment while I perform the incantation.");
		CreateNpc("monsters/companion/spell_maker_divination", RelativePosition(Vector3(0, 0, 40)), self, "none", "none", 50);
		PlayAnim("once", ANIM_MAGIC);
		CallEventDelayed(2.0f, "give_key2");
	}

	// give_key2
	void OnGiveKey2()
	{
		PlayAnim("once", ANIM_GIVE);
		SayText("Here, take it quickly and use it to enter the foul temple and expunge the evil therein!");
		Offer(QUEST_WINNER, "key_crystal");
		GAVE_KEY = true;
		CallEventDelayed(5.0f, "return_home");
	}

	// return_home
	void OnReturnHome()
	{
		SayText("I've done all I can here, so I am using my return scroll's magic now.");
		CallEventDelayed(2.0f, "return_home2");
	}

	// return_home2
	void OnReturnHome2()
	{
		SayText("I wish you luck in your quest!");
		CallEventDelayed(0.1f, "npc_fade_away");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnChatSpeed() {} // CHAT_SPEED

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "gave_shard") { OnGaveShard(PlayerParam(params, 0)); return true; }
		if (name == "give_key") { OnGiveKey(); return true; }
		if (name == "give_key2") { OnGiveKey2(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "return_home") { OnReturnHome(); return true; }
		if (name == "return_home2") { OnReturnHome2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job_loop") { OnSayJobLoop(); return true; }
		if (name == "say_where") { OnSayWhere(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
