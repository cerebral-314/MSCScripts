#pragma context server

// Converted from idemarks_tower/base_book.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class IdemarksTowerBaseBook
{
	// Constants
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHAT_FACE_ON_USE = false;
	bool CHAT_AUTO_FACE = false;
	string CHAT_ARRAY_EVENT = "page";

	// Variables (an unset .script variable reads as its own name)
	float CUR_PAGE = 0.0f;
	float NUM_PAGES = 0.0f;

	// unnamed block (first think)
	void IdemarksTowerBaseBook_FirstThink()
	{
		CUR_PAGE = 0.0f;
		NUM_PAGES = 0.0f;
	}

	// game_spawn
	void IdemarksTowerBaseBook_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetMenuAutoOpen(true);
		SetInvincible(true);
		SetNoPush(true);
		SetModel("null.mdl"); // Prevents crash

		SetName("Your book name");
	}

	// game_menu_getoptions
	void IdemarksTowerBaseBook_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = "Read a Page";
		menuItem.type = "callback";
		menuItem.callback = "read_page";
		RegisterMenuItem(menuItem);
	}

	// add_page
	// <page text string. actually just one line of text.>
	void IdemarksTowerBaseBook_OnAddPage(string pageText = "")
	{
		OnChatAddText(CHAT_ARRAY_EVENT, pageText, "0.1", "none", "none", "sound:magic/pageflip.wav");
		NUM_PAGES += 1.0f;
	}

	// read_page
	void IdemarksTowerBaseBook_OnReadPage()
	{
		if (int(CUR_PAGE) == 0)
		{
			OnChatStartSequence(CHAT_ARRAY_EVENT);
			CUR_PAGE += 1.0f;
		}
		else
		{
			OnChatResume();
		}
		OnChatPause();

		CUR_PAGE += 1.0f;
		if (!(CUR_PAGE > NUM_PAGES))
			return;
		CUR_PAGE = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		IdemarksTowerBaseBook_OnGameSpawn(playerRace, playerGender);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		IdemarksTowerBaseBook_OnGameMenuGetoptions(player);
	}

	void OnAddPage(string pageText = "") { IdemarksTowerBaseBook_OnAddPage(pageText); } // add_page
	void OnReadPage() { IdemarksTowerBaseBook_OnReadPage(); } // read_page

	// This file's events and timers by their .script names
	bool IdemarksTowerBaseBook_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_page") { OnAddPage(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "read_page") { OnReadPage(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "idemarks_tower/base_book"]
shared class IdemarksTowerBaseBookScript : BaseChatArrayScript, IdemarksTowerBaseBook
{
	// Variables declared by included files, with the value they start with in this script
	IdemarksTowerBaseBookScript()
	{
		CHAT_USE_CONV_ANIMS = false;
		CHAT_FACE_ON_USE = false;
		CHAT_AUTO_FACE = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IdemarksTowerBaseBook_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return IdemarksTowerBaseBook_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
