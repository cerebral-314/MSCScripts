#pragma context server

// Converted from idemarks_tower/book_felewyn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/idemarks_tower/base_book.as"

[script "idemarks_tower/book_felewyn"]
class BookFelewyn : IdemarksTowerBaseBookScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		IdemarksTowerBaseBook_OnGameSpawn(playerRace, playerGender); // idemarks_tower/base_book

		SetName("Felewyn 15:12");
		OnAddPage("We are to chose apostles: mortal beings who will defend and enforce our ideals on the mortal plane.");
		OnAddPage("Lanethan is his name, though that was also not his birth name, and he is the Dark Knight Aginor.");
		OnAddPage("So shall he be known, as apostle of Felewyn, who shall enforce Order and peace.");
		OnAddPage("Idemark I have chosen to represent my order, the most powerful of the apostles of good.");
		OnAddPage("Her sister, Iquitas, I have chosen to represent my chaos, the most powerful of the apostles of evil.");
		OnAddPage("So shall they be, apostles of Pathos, two sides of the same coin - the coin of balance.");
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
