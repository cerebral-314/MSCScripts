#pragma context server

// Converted from idemarks_tower/book_armor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/idemarks_tower/base_book.as"

[script "idemarks_tower/book_armor"]
class BookArmor : IdemarksTowerBaseBookScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		IdemarksTowerBaseBook_OnGameSpawn(playerRace, playerGender); // idemarks_tower/base_book

		SetName("Armor of the Dark Knight");
		OnAddPage("When night is high / and hopes are naught");
		OnAddPage("darkness saves / those men who fought,");

		string str = "For even though he's / named Dark Knight";
		OnAddPage(str);

		OnAddPage("Order is his cause, / he fights for light.");
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
