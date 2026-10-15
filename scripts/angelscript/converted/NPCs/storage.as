#pragma context server

// Converted from NPCs/storage.script by msc_transpiler.
// Generic storage NPC, for testing

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/NPCs/base_storage.as"

[script "NPCs/storage"]
class NPCsStorage : BaseNpcScript, BaseStorage
{
	// Constants
	bool PLACEHOLDER = false;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Edric of Galat's Storage");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetWidth(28);
		SetHeight(96);
		SetModel("npc/balancepriest1.mdl");
		SetModelBody(1, 1);

		SetSayTextRange(1024);

		CatchSpeech("heard_hi", "hail", "hello", "hi", "greets", "gweets", "j0", "waddup");
		CatchSpeech("heard_rumor", "job", "rumor", "rumour", "quest");
		CatchSpeech("heard_store", "shop", "store", "bank");
	}

	// heard_hi
	void OnHeardHi()
	{
		PlayAnim("critical", "talkright");
		SayText("Greetings, welcome to Galat's Weapon and Armor Storage...");
		CallEventDelayed(5.0f, "heard_hi2");
	}

	// heard_hi2
	void OnHeardHi2()
	{
		SayText("For a nominal fee, we can store your items here for you.");
		CallEventDelayed(5.0f, "heard_hi3");
	}

	// heard_hi3
	void OnHeardHi3()
	{
		SayText("We'll give you a ticket in exchange for any item we can store.");
		CallEventDelayed(5.0f, "heard_hi4");
	}

	// heard_hi4
	void OnHeardHi4()
	{
		SayText("Thanks to our contacts with the Felewyn wizards, you can redeem this ticket at any Galat outlet.");
		CallEventDelayed(5.0f, "heard_hi5");
	}

	// heard_hi5
	void OnHeardHi5()
	{
		SayText("Galat has outlets in Deralia, Gatecity, Kray Eldorad, and now, even in Helena!");
	}

	// heard_rurmor
	void OnHeardRurmor()
	{
		SayText("Look, I just work here, I don't live here. You got an item to store, or what?");
	}

	// heard_store
	void OnHeardStore()
	{
		OpenMenu(EntityOf(ENT_LASTHEARD));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseStorage_OnGameSpawn(playerRace, playerGender); // NPCs/base_storage
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseStorage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "heard_hi") { OnHeardHi(); return true; }
		if (name == "heard_hi2") { OnHeardHi2(); return true; }
		if (name == "heard_hi3") { OnHeardHi3(); return true; }
		if (name == "heard_hi4") { OnHeardHi4(); return true; }
		if (name == "heard_hi5") { OnHeardHi5(); return true; }
		if (name == "heard_rurmor") { OnHeardRurmor(); return true; }
		if (name == "heard_store") { OnHeardStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseStorage_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
