#pragma context server

// Converted from monsters/summon/felewyn_shard.script by msc_transpiler.
// this is just a summon sequence for the felewyn shard reward

#include "runtime/ScriptEntity.as"

[script "monsters/summon/felewyn_shard"]
class FelewynShard : ScriptEntity
{
	// Constants
	int NPC_FWD_SPEED = 5;
	float CHAT_DELAY = 5.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_TARGET = "MY_TARGET";
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	Vector3 NPC_NOCLIP_DEST = Vector3();
	bool GAVE_SWORD = false;

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_TARGET = creatorValue1;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Shard of Felewyn");
		SetInvincible(true);
		SetWidth(32);
		SetHeight(128);
		SetGravity(0);
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 43);
		SetIdleAnim("spin_horizontal_slow");
		PlayAnim("once", "spin_horizontal_slow");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetSolid("none");

		ClientEvent("new", "all", "monsters/summon/felewyn_shard", IndexOf(ENT_ME), Vector3(255, 255, 255), 255);
		MY_SCRIPT_IDX = LastClientScriptId();

		SetMonsterClip(false);
		SetFly(true);
		SetSayTextRange(2048);
		CallEventDelayed(1.0f, "do_intro");
	}

	// do_intro
	void OnDoIntro()
	{
		SayText("I am a shard of the original Felewyn Blade...");
		CallEventDelayed(CHAT_DELAY, "do_intro2");
	}

	// do_intro2
	void OnDoIntro2()
	{
		SayText("One of five, scattered throughout the lands, when our goddess pierced the heart of the Doom Bringer with her sword.");
		CallEventDelayed(CHAT_DELAY, "do_intro3");
	}

	// do_intro3
	void OnDoIntro3()
	{
		SayText("We await that dread day when the Lor Malgoriand is destined to return. We await that day when great warriors may find us.");
		CallEventDelayed(CHAT_DELAY, "do_intro4");
	}

	// do_intro4
	void OnDoIntro4()
	{
		SayText("And lo, it has come, for you mighty warriors have defeated the mighty Undamael, a task previously believed beyond the reach of mortal hands.");
		CallEventDelayed(CHAT_DELAY, "do_intro5");
	}

	// do_intro5
	void OnDoIntro5()
	{
		SayText("Although you have all fought valiantly, I am but one shard. Thus, I offer myself to the warrior known as " + NameOf(MY_TARGET));
		CallEventDelayed(CHAT_DELAY, "do_intro6");

		SetMoveDest(MY_TARGET, 10);
		NPC_NOCLIP_DEST = Vec(MY_TARGET);
		CallEventDelayed(0.1f, "basenoclip_flight");
	}

	// basenoclip_flight
	void OnBasenoclipFlight()
	{
		if (GAVE_SWORD)
			return;
		CallEventDelayed(0.1f, "basenoclip_flight");

		Vector3 myOrg = MyOrigin() + RelativeVelocity(Vector3(0, NPC_FWD_SPEED, 0));
		SetOrigin(ENT_ME, myOrg);

		SetMoveDest(NPC_NOCLIP_DEST, 10);

		Vector3 targOrg = OriginOf(MY_TARGET);
		if (!(Distance(myOrg, targOrg) < 30.0f))
			return;
		GAVE_SWORD = true;
		SetProp(ENT_ME, "renderamt", 0);
		Effect("screenfade", MY_TARGET, 3, 1, Vector3(255, 255, 255), 255, "fadein");
		int fragElm = RandomInt(1, 5);
		if (fragElm == 1)
			Offer(MY_TARGET, "swords_fshard1");
		if (fragElm == 2)
			Offer(MY_TARGET, "swords_fshard2");
		if (fragElm == 3)
			Offer(MY_TARGET, "swords_fshard3");
		if (fragElm == 4)
			Offer(MY_TARGET, "swords_fshard4");
		if (fragElm == 5)
			Offer(MY_TARGET, "swords_fshard5");
		Quest("set", MY_TARGET, "f", "complete");
		HelpTip(ENT_ME, "generic", "One Time Quest (Shard of Felewyn) Completed", "The Felwyn Shard has been acquired.|Quest Complete.");
		SetModel("none");
		ClientEvent("remove", "all", MY_SCRIPT_IDX);
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnChatDelay() {} // CHAT_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "basenoclip_flight") { OnBasenoclipFlight(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
