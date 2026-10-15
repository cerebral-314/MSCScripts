#pragma context server

// Converted from other/keyhole_forged.script by msc_transpiler.
// Thothie - This keyhole only takes treasury keys, it will not return them

#include "runtime/ScriptEntity.as"

[script "other/keyhole_forged"]
class KeyholeForged : ScriptEntity
{
	// Constants
	string KEY_NAME = "key_forged";
	string KEYHOLE_TITLE = "Use the forged key";

	// spawn
	void OnSpawn()
	{
		SetName("Ornate Keyhole");
		SetWidth(2);
		SetHeight(16);
		SetRoam(false);
		SetModel("props/skullprop.mdl");
		SetModelBody(0, 0);
		SetInvincible(true);
		SetFly(true); // suspend in air where placed
		LegacyCommand("float", 1);
		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, KEY_NAME)))
		{
			menuItem.title = KEYHOLE_TITLE;
			menuItem.type = "payment";
			menuItem.data = KEY_NAME;
			menuItem.callback = "key_used";
			RegisterMenuItem(menuItem);
		}
	}

	// key_used
	void OnKeyUsed(CBasePlayer@ playerId = null)
	{
		ReceiveOffer("accept");
		SetModelBody(0, 1);
		UseTrigger(KEY_NAME, "ustart");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/skullprop.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "key_used") { OnKeyUsed(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return false;
	}
}
