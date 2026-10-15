#pragma context server

// Converted from mines/rudolf.script by msc_transpiler.
// Thothie - plays Hi text after he gets his mace (minor asthetic complaint), fixed, untested

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "mines/rudolf"]
class MinesRudolf : BaseNpcScript, BaseChat
{
	// Constants
	int FLEE_HEALTH = 34;
	string FLEE_CHANCE = "100%";
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string FLINCH_DELAY = "FLINCH_DELAY";
	bool recievedit = false;
	int REQ_QUEST_NOTDONE = 0;
	bool SPOKE = true;
	string QUEST_WINNER = "";
	bool I_GOT_MY_MACE = false;

	// Variables declared by included files, with the value they start with in this script
	MinesRudolf()
	{
		SOUND_DEATH = "player/stomachhit1.wav";
		ANIM_WALK = "run";
	}

	// unnamed block (first think)
	void MinesRudolf_FirstThink()
	{
		CAN_ATTACK = "0";
		CAN_FLEE = "1";
		FLEE_DISTANCE = "1000";
		CAN_RETALIATE = "0";
		CAN_FLINCH = "1";
		FLINCH_ANIM = "llflinch";
		FLINCH_CHANCE = "50%";
		FLINCH_DELAY = "1";
		ANIM_DEATH = "dieforward";
		ANIM_WALK = "run";
	}

	// say_where
	void MinesRudolf_OnSayWhere()
	{
		SayText("Well, you enter in here, then go across the bridge, then a right...");
		CallEventDelayed(0.0f, "3");
	}

	// say_where
	void MinesRudolf_OnSayWhere_2()
	{
		if (recievedit)
			return;

		SayText("There'll will be those things... I hope you're strong enough... here, take these.");
		Offer(ENT_LASTSPOKE, "health_mpotion");
		Offer(ENT_LASTSPOKE, "item_torch");
		recievedit = true;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "blunt_rudolfsmace")))
		{
			menuItem.title = "Return mace";
			menuItem.type = "payment";
			menuItem.data = "blunt_rudolfsmace";
			menuItem.callback = "give_mace";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "item_ring")))
		{
			string rquestStageText = GetQuestData(player, "r");
			int rquestStage = Int(rquestStageText);
			if (rquestStage == 5)
			{
				// in case they need to ask again
				menuItem.title = "Ask about the ring";
				menuItem.type = "callback";
				menuItem.data = rquestStageText;
				menuItem.callback = "ring_comment";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		REQ_QUEST_NOTDONE = 1;

		SetHealth(35);
		SetName("Scared Rudolf");
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(5, 3);

		SetAngle("face", Vector3(0, 180, 0));

		recievedit = false;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");

		CatchSpeech("say_what", "hammer", "maul", "mace");

		CatchSpeech("say_where", "where");

		CatchSpeech("say_thank", "thank", "thanks");

		CatchSpeech("say_reward", "gold", "reward", "money");

		CatchSpeech("say_thing", "things", "thing");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (I_GOT_MY_MACE)
			return;

		SayText("Please help me, I lost my very valuable mace! Please recover it!");
		CallEventDelayed(0.0f, "3");

		SPOKE = true;
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText(".....I was venturing in the caves...I think I remember where...");
		CallEventDelayed(0.0f, "4");
		PlayAnim("once", "panic");
	}

	// say_hi3
	void OnSayHi3()
	{
		SayText("All of a sudden, a bunch of things attacked me! I ran out as fast as I could...");
		CallEventDelayed(0.0f, "4");
		PlayAnim("once", "panic");
	}

	// say_hi4
	void OnSayHi4()
	{
		SayText("When I came back out, I realized my mace was gone!");
		PlayAnim("once", "beatdoor");
		CallEventDelayed(0.0f, "4");
	}

	// say_hi5
	void OnSayHi5()
	{
		SayText("It was a family heirloom...!");
		PlayAnim("once", "crouch_idle");
	}

	// say_where
	void OnSayWhere()
	{
		MinesRudolf_OnSayWhere();
		MinesRudolf_OnSayWhere_2();
	}

	// say_thank
	void OnSayThank()
	{
		SayText("Good luck!");
	}

	// say_what
	void OnSayWhat()
	{
		SayText("Yes, I lost my mace, please help me find it. I think I remember where..");
		CallEventDelayed(0.0f, "3");
		PlayAnim("once", "eye_wipe");
	}

	// say_what2
	void OnSayWhat2()
	{
		SayText("I'll be happy to reward you!");
		PlayAnim("once", "idle2");
	}

	// say_reward
	void OnSayReward(CBasePlayer@ player = null)
	{
		SayText("I'll give you gold! Please, no more talking, find my mace!");
		PlayAnim("once", "llflinch");
	}

	// say_thing
	void OnSayThing()
	{
		SayText("There were about 4 things that attacked me!");
		PlayAnim("once", "fear");
		CallEventDelayed(0.0f, "2");
	}

	// say_thing2
	void OnSayThing2()
	{
		SayText("You'll probably have to kill them all to find my mace");
		PlayAnim("once", "fear");
	}

	// give_mace
	void OnGiveMace(CBasePlayer@ winner = null)
	{
		ReceiveOffer("accept");
		PlayAnim("once", "eye_wipe");
		SayText("THANK YOU!!!");

		QUEST_WINNER = EntityId(winner);

		CallEventDelayed(0.0f, "2");
	}

	// recvmace_2
	void OnRecvmace2()
	{
		I_GOT_MY_MACE = true;
		SayText("As I promised you...");
		Offer(QUEST_WINNER, "bows_crossbow_light");
		CallEventDelayed(0.0f, "3");

		if (!Truthy(ItemExists(QUEST_WINNER, "item_ring")))
			return;
		string rquestStage = GetQuestData(QUEST_WINNER, "r");
		if (rquestStage != "4")
			return;
		CallEventDelayed(0.1f, "ring_comment");
	}

	// ring_comment
	void OnRingComment()
	{
		SayText("Nice ring by the way! You know, I think Vadrel used to have one just like it!");
		SayText("If memory serves me right, he was stationed at some old outpost.");
		Quest("set", QUEST_WINNER, "r", 5);
		REQ_QUEST_NOTDONE = 0;
	}

	// recvmace_3
	void OnRecvmace3()
	{
		SayText("Goodbye now! I must hurry!");
		SetMoveDest(Vector3(-3101, 351, 64), 0);

		CallEventDelayed(5.0f, "rudolfdelete");
	}

	// rudolfdelete
	void OnRudolfdelete()
	{
		DeleteEntity(ENT_ME, "fade");
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
		MinesRudolf_FirstThink();
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
		if (name == "give_mace") { OnGiveMace(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "recvmace_2") { OnRecvmace2(); return true; }
		if (name == "recvmace_3") { OnRecvmace3(); return true; }
		if (name == "ring_comment") { OnRingComment(); return true; }
		if (name == "rudolfdelete") { OnRudolfdelete(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_hi4") { OnSayHi4(); return true; }
		if (name == "say_hi5") { OnSayHi5(); return true; }
		if (name == "say_reward") { OnSayReward(PlayerParam(params, 0)); return true; }
		if (name == "say_thank") { OnSayThank(); return true; }
		if (name == "say_thing") { OnSayThing(); return true; }
		if (name == "say_thing2") { OnSayThing2(); return true; }
		if (name == "say_what") { OnSayWhat(); return true; }
		if (name == "say_what2") { OnSayWhat2(); return true; }
		if (name == "say_where") { OnSayWhere(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
