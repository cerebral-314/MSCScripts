#pragma context server

// Converted from items/item_book_latin.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_book.as"

[script "items/item_book_latin"]
class ItemBookLatin : ItemsBaseBookScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemBookLatin()
	{
		BOOK_TITLE = "Some latin crap or something";
		BOOK_PAGES = "#LOCALPAGE_TEST1;latin;latin2;latin3";
		BOOK_PAGES_SRC = "local;file;file;file";
	}

	// unnamed block (first think)
	void ItemBookLatin_FirstThink()
	{
		BOOK_TITLE = "Some latin crap or something";
		BOOK_PAGES = "#LOCALPAGE_TEST1;latin;latin2;latin3";
		BOOK_PAGES_SRC = "local;file;file;file";
	}

	// book_spawn
	void OnBookSpawn()
	{
		SetName("Latin Book");
		SetDescription("What the hell does this even say?");
		SetValue(500);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ItemBookLatin_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "book_spawn") { OnBookSpawn(); return true; }
		return ItemsBaseBookScript::DispatchEvent(name, params);
	}
}
