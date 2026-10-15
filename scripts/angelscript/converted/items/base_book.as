#pragma context server

// Converted from items/base_book.script by msc_transpiler.
// MiB - Base book script
// Requires:
// BOOK_TITLE		- Title of book
// BOOK_PAGES		- Tokenized string of pages
// BOOK_PAGES_SRC	- Associated tokenized string of source types

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemsBaseBook
{
	// Constants
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_HOLD = "misc/p_misc.mdl";

	// Variables (an unset .script variable reads as its own name)
	float MAX_PAGE = 0.0f;
	float CUR_PAGE = 0.0f;

	// game_spawn
	void ItemsBaseBook_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWeight(1);
		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "book");

		OnBookSpawn();
	}

	// game_deploy
	void ItemsBaseBook_OnGameDeploy()
	{
		SetViewModel("none");
		SetModel(MODEL_HOLD);
		float submodel = 15.0f + ItemHandIndex();
		SetModelBody(0, int(submodel));
		MAX_PAGE = GetTokenCount(BOOK_PAGES) - 1.0f;
		CUR_PAGE = 0.0f;
	}

	// game_fall
	void ItemsBaseBook_OnGameFall()
	{
		SetModel(MODEL_WORLD);
		SetModelBody(0, 17);
		PlayAnim("package_floor_idle");
	}

	// game_attack1
	void ItemsBaseBook_OnGameAttack1()
	{
		// (never true here, the rest is skipped) if game.clientside
	}

	// read_book
	void ItemsBaseBook_OnReadBook()
	{
		CUR_PAGE = 0.0f;
		OnTurnPage();
	}

	// turn_page
	void ItemsBaseBook_OnTurnPage()
	{
		LegacyCommand("localmenu.reset");

		float dispPage = CUR_PAGE + 1.0f;
		float dispMax = MAX_PAGE + 1.0f;

		string dispTitle = BOOK_TITLE + ", Page " + int(dispPage) + "/" + int(dispMax);
		SetLocal("reg.local.menu.title", dispTitle);
		LegacyCommand("registerlocal.menu");

		if (CUR_PAGE > MAX_PAGE)
			CUR_PAGE = MAX_PAGE;
		if (CUR_PAGE < 0.0f)
			CUR_PAGE = 0.0f;

		SetLocal("reg.local.paragraph.source.type", GetToken(BOOK_PAGES_SRC, int(CUR_PAGE)));

		SetLocal("reg.local.paragraph.source", "");
		LegacyCommand("stradd", "reg.local.paragraph.source", GetToken(BOOK_PAGES, int(CUR_PAGE)));

		LegacyCommand("registerlocal.paragraph");

		bool enablePrev = true;
		if (CUR_PAGE == 0.0f)
			enablePrev = false;

		bool enableNext = true;
		if (CUR_PAGE == MAX_PAGE)
			enableNext = false;

		SetLocal("reg.local.button.text", "Previous");
		SetLocal("reg.local.button.closeonclick", 0);
		SetLocal("reg.local.button.enabled", enablePrev);
		SetLocal("reg.local.button.docallback", 1);
		SetLocal("reg.local.button.callback", "prev_page");
		LegacyCommand("registerlocal.button");

		SetLocal("reg.local.button.text", "Next");
		SetLocal("reg.local.button.closeonclick", 0);
		SetLocal("reg.local.button.enabled", enableNext);
		SetLocal("reg.local.button.docallback", 1);
		SetLocal("reg.local.button.callback", "next_page");
		LegacyCommand("registerlocal.button");

		LegacyCommand("localmenu.open");
	}

	// next_page
	void ItemsBaseBook_OnNextPage()
	{
		CUR_PAGE += 1.0f;
		OnTurnPage();
	}

	// prev_page
	void ItemsBaseBook_OnPrevPage()
	{
		CUR_PAGE -= 1.0f;
		OnTurnPage();
	}

	// game_removefromowner
	void ItemsBaseBook_OnGameRemovefromowner()
	{
		CancelAttack();
		// (never true here, the rest is skipped) if game.clientside
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ItemsBaseBook_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ItemsBaseBook_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		ItemsBaseBook_OnGameDeploy();
	}

	void OnGameAttack1() { ItemsBaseBook_OnGameAttack1(); } // game_attack1
	void OnReadBook() { ItemsBaseBook_OnReadBook(); } // read_book
	void OnTurnPage() { ItemsBaseBook_OnTurnPage(); } // turn_page
	void OnNextPage() { ItemsBaseBook_OnNextPage(); } // next_page
	void OnPrevPage() { ItemsBaseBook_OnPrevPage(); } // prev_page
	void OnGameRemovefromowner() { ItemsBaseBook_OnGameRemovefromowner(); } // game_removefromowner
	void OnBookSpawn() {} // book_spawn

	// This file's events and timers by their .script names
	bool ItemsBaseBook_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "next_page") { OnNextPage(); return true; }
		if (name == "prev_page") { OnPrevPage(); return true; }
		if (name == "read_book") { OnReadBook(); return true; }
		if (name == "turn_page") { OnTurnPage(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_book"]
shared class ItemsBaseBookScript : BaseItemExtrasScript, ItemsBaseBook
{
	// Variables every script that includes this file declares
	string BOOK_PAGES = "BOOK_PAGES";
	string BOOK_PAGES_SRC = "BOOK_PAGES_SRC";
	string BOOK_TITLE = "BOOK_TITLE";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ItemsBaseBook_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
