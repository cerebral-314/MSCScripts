#pragma context server

// Converted from deralia/deraliateller.script by msc_transpiler.
// Edana teller

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/base_banker.as"

[script "deralia/deraliateller"]
class Deraliateller : BaseBankerScript
{
	// Variables declared by included files, with the value they start with in this script
	Deraliateller()
	{
		STORAGE_DISPLAYNAME = "Deralia Bank";
		STORAGE_NAME = "deraliastorage";
		NO_CHAT = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(25);
		SetGold(30);
		SetName("Teller");
		// fov 180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
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
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseBankerScript::DispatchEvent(name, params);
	}
}
