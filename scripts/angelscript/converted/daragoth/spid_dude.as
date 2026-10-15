#pragma context server

// Converted from daragoth/spid_dude.script by msc_transpiler.
// *** Default human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"
#include "converted/monsters/base_chat.as"

[script "daragoth/spid_dude"]
class SpidDude : BaseNpcAttackScript, BaseChat
{
	// Constants
	string ANIM_ATTACK = "beatdoor";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "100%";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	string FLINCH_ANIM = "flinch1";
	string FLINCH_CHANCE = "50%";
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	bool NO_HAIL = true;

	// Variables (an unset .script variable reads as its own name)
	int REQ_QUEST_NOTDONE = 0;

	// Variables declared by included files, with the value they start with in this script
	SpidDude()
	{
		MOVE_RANGE = "64";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		CAN_HUNT = "0";
		HUNT_AGRO = "0";
		CAN_ATTACK = "0";
		ATTACK_RANGE = 90.0f;
		CAN_FLEE = "1";
		CAN_HEAR = "1";
		CAN_RETALIATE = "1";
		CAN_FLINCH = "1";
		FLINCH_DELAY = "1";
	}

	// unnamed block (first think)
	void SpidDude_FirstThink()
	{
		ATTACK_RANGE = 90.0f;

		REQ_QUEST_NOTDONE = 1;
	}

	// unnamed block (timer)
	void SpidDude_Timer()
	{
		CallEventDelayed(30.0f, "SpidDude_Timer");

		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		SetVolume(2);
		Say("chitchat[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_help";
		RegisterMenuItem(menuItem);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Narad");

		SetHealth(25);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");

		SetMenuAutoOpen(true);

		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 3);
		SetMoveAnim("walk");

		CatchSpeech("say_help", "hi", "hello", "hail", "greet");
	}

	// say_help
	void OnSayHelp(CBasePlayer@ talkingPlayer = null)
	{
		if (REQ_QUEST_NOTDONE == 0)
			SayText("Thank you very much. Hopefully you found a treat in the chest.");
		if (REQ_QUEST_NOTDONE == 0)
			return;

		CBaseEntity@ speaker = talkingPlayer;
		if (speaker is null)
			@speaker = EntityOf(ENT_LASTSPOKE);
		OnFaceSpeaker(EntityId(speaker));

		SayText("Oh, hello...can you help me?");

		CallEventDelayed(0.0f, "3");
	}

	// say_help2
	void OnSayHelp2()
	{
		SayText("You see, I keep all of my supplies in the basement. However...");

		CallEventDelayed(0.0f, "3");
	}

	// say_help3
	void OnSayHelp3()
	{
		SayText("Quite recently, a family of spiders seemed to have moved in.");

		UseTrigger("spawn_spiders");

		CallEventDelayed(0.0f, "3");
	}

	// say_help4
	void OnSayHelp4()
	{
		SayText("Can you get rid of them for me? I'm afraid I have nothing of much value to give...");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, "ATTACK1_DAMAGE", "ATTACK_PERCENTAGE");
	}

	// spider_chest_used
	void OnSpiderChestUsed()
	{
		REQ_QUEST_NOTDONE = 0;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") { BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); } // npcatk_suspend_ai

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/chitchat.wav");
		CallEventDelayed(30.0f, "SpidDude_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpidDude_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_help") { OnSayHelp(PlayerParam(params, 0)); return true; }
		if (name == "say_help2") { OnSayHelp2(); return true; }
		if (name == "say_help3") { OnSayHelp3(); return true; }
		if (name == "say_help4") { OnSayHelp4(); return true; }
		if (name == "spider_chest_used") { OnSpiderChestUsed(); return true; }
		if (name == "SpidDude_Timer") { SpidDude_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
