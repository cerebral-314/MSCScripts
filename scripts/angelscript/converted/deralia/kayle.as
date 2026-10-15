#pragma context server

// Converted from deralia/kayle.script by msc_transpiler.
// Thothie - Slight fix for this pointless NPC - helena response was set for gatecity
// Kayle

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "deralia/kayle"]
class Kayle : BaseChatArrayScript
{
	// Constants
	int SEE_RANGE = 200;

	// Variables (an unset .script variable reads as its own name)
	string MENU_MODE = "MENU_MODE";
	int CANCHAT = 1;
	CBasePlayer@ MENU_TO = null;

	// Variables declared by included files, with the value they start with in this script
	Kayle()
	{
		CHAT_AUTO_HAIL = true;
		CHAT_AUTO_RUMOR = true;
		CHAT_NEVER_INTERRUPT = true;
	}

	// unnamed block (first think)
	void Kayle_FirstThink()
	{
		MENU_MODE = "0";
	}

	// game_menu_getoptions
	// <playerID>
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (Float(MENU_MODE) == 0.0f)
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ask about Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_rumor";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ask about...";
			menuItem.type = "callback";
			menuItem.callback = "menu_switch_towns";
			RegisterMenuItem(menuItem);
		}
		else if (Float(MENU_MODE) == 1.0f)
		{
			menuItem.title = "Edana";
			menuItem.type = "callback";
			menuItem.callback = "say_edana";
			RegisterMenuItem(menuItem);

			menuItem.title = "Deralia";
			menuItem.type = "callback";
			menuItem.callback = "say_deralia";
			RegisterMenuItem(menuItem);

			menuItem.title = "Gatecity";
			menuItem.type = "callback";
			menuItem.callback = "say_gatecity";
			RegisterMenuItem(menuItem);

			menuItem.title = "Helena";
			menuItem.type = "callback";
			menuItem.callback = "say_helena";
			RegisterMenuItem(menuItem);

			MENU_MODE = "0";
		}
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		// fov		180
		// gold		50 //She cant die so...
		SetWidth(32);
		SetHeight(64);
		SetRace("human");
		SetSkillLevel(0);
		SetName("Kayle");
		SetRoam(false);
		SetModel("npc/human2.mdl");
		SetInvincible(true);
		CANCHAT = 1;

		CHAT_MENU_ON = false;

		// catchspeech say_hi hi hello hail greet hey
		CatchSpeech("say_help", "help");
		// catchspeech say_rumour news happenings rumour rumours
		CatchSpeech("say_kayle", "kayle");
		CatchSpeech("say_deralia", "deralia");
		CatchSpeech("say_edana", "edana");
		CatchSpeech("say_gatecity", "gatecity");
		CatchSpeech("say_helena", "helena");

		CallEventDelayed(0.1f, "add_dialogue");
	}

	// add_dialogue
	void OnAddDialogue()
	{
		// callevent chat_add_text <convo_sequence_name> <sentence_string> [time] [anim|"none"] [event] [sound:<file>]
		OnChatAddText("seq_hi", "Hey.", "3.0");
		OnChatAddText("seq_hi", "My names Kayle.", "1.0");

		OnChatAddText("seq_rumor", "Nothing much, besides the fact that they won't let us into to uptown Deralia.", "3.0");
		OnChatAddText("seq_rumor", "Don't really get why, not everyone wants to hang around with smelly ship mates.", "3.0");

		OnChatAddText("seq_help", "You talking to me?", "5.0");
		OnChatAddText("seq_help", "...", "1.0");

		OnChatAddText("seq_kayle", "Huh? You beckoned?", "2.0");

		OnChatAddText("seq_edana", "Edana huh, that's pretty far off.", "2.0");
		OnChatAddText("seq_edana", "Sembelbin seemed interested in an Urdual Title Ring last time I was there.", "3.0");

		OnChatAddText("seq_deralia", "I like living in Deralia, its always been my home.", "3.0");

		OnChatAddText("seq_gatecity", "Really? You don't look like a dwarf.", "2.0");
		OnChatAddText("seq_gatecity", "I don't see any point in going there. It's too much trouble getting around the goblins.", "3.0");

		OnChatAddText("seq_helena", "Helena... must've been tough through all those orc attacks.", "2.0");
		OnChatAddText("seq_helena", "I've seen old paintings of the heroes who saved Helena from an army of orcs. You have an odd resemblence to one of 'em.", "4.0");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;
		// callevent chat_start_sequence <convo_sequence_name> ["clear_que"] ["prioritize"] ["add_to_que"]
		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_hi");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_rumor");
	}

	// say_help
	void OnSayHelp(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_help");
	}

	// say_kayle
	void OnSayKayle(string talkingPlayer = "")
	{
		CBaseEntity@ player = null;

		if (!talkingPlayer.isEmpty())
			@player = FindEntity(talkingPlayer);
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_kayle");
	}

	// say_edana
	void OnSayEdana(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_edana");
	}

	// say_deralia
	void OnSayDeralia(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_deralia");
	}

	// say_gatecity
	void OnSayGatecity(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_gatecity");
	}

	// say_helena
	void OnSayHelena(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;

		OnChatStartSequence("seq_helena");
	}

	// menu_switch_towns
	// <playerID
	void OnMenuSwitchTowns(CBasePlayer@ playerId = null)
	{
		MENU_MODE = "1";

		@MENU_TO = playerId;
		CallEventDelayed(0.1f, "send_menu");
	}

	// send_menu
	// So I can send this at a delay
	void OnSendMenu()
	{
		OpenMenu(MENU_TO);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Kayle_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_dialogue") { OnAddDialogue(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "menu_switch_towns") { OnMenuSwitchTowns(PlayerParam(params, 0)); return true; }
		if (name == "say_deralia") { OnSayDeralia(PlayerParam(params, 0)); return true; }
		if (name == "say_edana") { OnSayEdana(PlayerParam(params, 0)); return true; }
		if (name == "say_gatecity") { OnSayGatecity(PlayerParam(params, 0)); return true; }
		if (name == "say_helena") { OnSayHelena(PlayerParam(params, 0)); return true; }
		if (name == "say_help") { OnSayHelp(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_kayle") { OnSayKayle(Param(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
