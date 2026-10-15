#pragma context server

// Converted from joe/bartifact.script by msc_transpiler.
// Bloodshrine Artifact - Joe
// This NPC is Bloodshrine specific -- It should not exist on any other map.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "joe/bartifact"]
class Bartifact : BaseNpcScript
{
	// Variables (an unset .script variable reads as its own name)
	CBasePlayer@ THE_PLAYER = null;

	// game_spawn
	void Bartifact_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1000);
		SetName("A Bloodshrine Artifact");
		SetWidth(12);
		SetHeight(6);
		SetRace("beloved");
		SetModel("misc/bartifact.mdl");
		SetInvincible(true);
		SetAlive(false); // so the model won't *fix* itself.
		SetAngle("face", Vector3(90, 0, 0));
		SetMenuAutoOpen(true);

		@THE_PLAYER = null;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		Bartifact_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
	}

	// itemtook
	void OnItemtook(CBasePlayer@ player = null)
	{
		@THE_PLAYER = player;
		// offer THE_PLAYER unknown_item //why?
		UseTrigger("door_event");
		DeleteEntity(ENT_ME);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.id = "takeitem";
		menuItem.title = "Remove the stone";
		menuItem.callback = "itemtook";

		RegisterMenuItem(menuItem);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/bartifact.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "itemtook") { OnItemtook(PlayerParam(params, 0)); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
