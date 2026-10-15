#pragma context server

// Converted from idemarks_tower/book_wand.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/idemarks_tower/base_book.as"

[script "idemarks_tower/book_wand"]
class BookWand : IdemarksTowerBaseBookScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		IdemarksTowerBaseBook_OnGameSpawn(playerRace, playerGender); // idemarks_tower/base_book

		SetName("The Way of the Wand");
		OnAddPage("There is a power beneath magic, a very ancient one. It's called fate.");
		OnAddPage("It has limitless power - magic, as we all know, has many limitations, but not fate.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return IdemarksTowerBaseBookScript::DispatchEvent(name, params);
	}
}
