#pragma context server

// Converted from NPCs/wall_of_text_guy.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "NPCs/wall_of_text_guy"]
class WallOfTextGuy : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Wall of Text Guy");
		SetModel("npc/human1.mdl");
		SetRace("beloved");
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetWidth(32);
		SetHeight(96);
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		menuItem.title = "Show me Text1";
		menuItem.type = "callback";
		menuItem.data = "text1";
		menuItem.callback = "do_text";
		RegisterMenuItem(menuItem);

		menuItem.title = "Show me Text2";
		menuItem.type = "callback";
		menuItem.data = "text2";
		menuItem.callback = "do_text2";
		RegisterMenuItem(menuItem);
	}

	// do_text2
	void OnDoText2(CBasePlayer@ menuId = null)
	{
		LegacyCommand("localmenu.reset", @menuId);

		SetLocal("reg.local.menu.title", "'Testtitle'");
		LegacyCommand("registerlocal.menu", @menuId);

		SetLocal("reg.local.button.text", "Button1");
		SetLocal("reg.local.button.closeonclick", 0);
		SetLocal("reg.local.button.enabled", 1);
		SetLocal("reg.local.button.docallback", 1);
		SetLocal("reg.local.button.callback", "CB_TEST1");
		LegacyCommand("registerlocal.button", @menuId);

		SetLocal("reg.local.button.text", "Button2");
		SetLocal("reg.local.button.closeonclick", 1);
		SetLocal("reg.local.button.enabled", 0);
		SetLocal("reg.local.button.docallback", 0);
		LegacyCommand("registerlocal.button", @menuId);

		SetLocal("reg.local.button.text", "Button3");
		SetLocal("reg.local.button.closeonclick", 1);
		SetLocal("reg.local.button.enabled", 1);
		SetLocal("reg.local.button.docallback", 0);
		SetLocal("reg.local.button.callback", "CB_TEST2");
		LegacyCommand("registerlocal.button", @menuId);

		SetLocal("reg.local.paragraph.source.type", "file");
		SetLocal("reg.local.paragraph.source", "Credits_Original");
		LegacyCommand("registerlocal.paragraph", @menuId);

		LegacyCommand("localmenu.open", @menuId);
	}

	// do_text
	// <user> <data>
	void OnDoText(CBasePlayer@ user = null, string data = "")
	{
		PlayAnim("once", "give_shot");
		SayText("Take a look at wall of text: " + data);
		ClientEvent("update", user, Eval("const.localplayer.scriptID"), "cl_show_text", data);
	}

	// CB_TEST1
	void OnCbTest1(string text = "")
	{
		SayText("CB_TEST1 " + text);
		LegacyCommand("localmenu.close", text);
	}

	// CB_TEST2
	void OnCbTest2(string text = "")
	{
		SayText("CB_TEST2 " + text);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "CB_TEST1") { OnCbTest1(Param(params, 0)); return true; }
		if (name == "CB_TEST2") { OnCbTest2(Param(params, 0)); return true; }
		if (name == "do_text") { OnDoText(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "do_text2") { OnDoText2(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
