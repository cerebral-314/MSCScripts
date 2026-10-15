#pragma context server

// Converted from tutorial/slave.script by msc_transpiler.
// Tutorial Map Slave, by The Magical Bong/CrazyMonkeyDude

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "tutorial/slave"]
class Slave : BaseNpcScript, BaseChat
{
	// Constants
	string NPC_MODEL = "npc/human1.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "crouch_idle";
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool ASKED_OK = false;
	bool NO_HAIL = false;
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	bool DEAD_MASTER = false;

	// Variables declared by included files, with the value they start with in this script
	Slave()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
	}

	// unnamed block (first think)
	void Slave_FirstThink()
	{
		ANIM_IDLE = "crouch_idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";

		NO_JOB = true;
		NO_RUMOR = true;
		ASKED_OK = false;
		NO_HAIL = true;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!ASKED_OK && DEAD_MASTER)
		{
			menuItem.title = "Are you okay?";
			menuItem.type = "callback";
			menuItem.callback = "say_ok";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Doran");
		SetHealth(1);
		SetInvincible(true);
		SetNoPush(true);

		SetRace("beloved");
		SetModel(NPC_MODEL);
		SetModelBody(0, 4);
		SetModelBody(1, 5);

		SetWidth(30);
		SetHeight(96);
		SetSayTextRange(1024);
		CallEventDelayed(0.1f, "be_scared");
	}

	// be_scared
	void OnBeScared()
	{
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
	}

	// say_ok
	void OnSayOk(CBasePlayer@ speaker = null)
	{
		ANIM_IDLE = "idle1";
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_IDLE);
		if (IsPlayer(speaker))
			OnFaceSpeaker(EntityId(speaker));
		if (IsPlayer(ENT_LASTSPOKE))
			OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));

		CHAT_STEPS = 5;
		CHAT_STEP = 0.0f;
		CHAT_STEP1 = "Yes, I'm fine now, adventurer.";
		CHAT_STEP2 = "Thanks to you.";
		CHAT_STEP3 = "...There is way out of here.";
		CHAT_STEP4 = "I believe there is a secret passage in the, er, LATE slave master's hut.";
		CHAT_STEP5 = "There's a cage in there I've never seen him use, and a cool wind that blows from it.";
		OnChatLoop();

		ASKED_OK = true;
	}

	// slavemaster_dies
	void OnSlavemasterDies()
	{
		DEAD_MASTER = true;
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
		Slave_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "be_scared") { OnBeScared(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_ok") { OnSayOk(PlayerParam(params, 0)); return true; }
		if (name == "slavemaster_dies") { OnSlavemasterDies(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
